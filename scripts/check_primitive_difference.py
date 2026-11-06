"""Build each scoped Lean module and census every theorem's axiom dependencies."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
MODULES = {
    "PrimitiveDifference": {
        "namespace": "OmegaCodex.PrimitiveDifference.",
        "allowed_axioms": {"propext"},
        "imports": (),
    },
    "MirrorNonIdentification": {
        "namespace": "OmegaCodex.MirrorNonIdentification.",
        "allowed_axioms": {"propext"},
        "imports": ("PrimitiveDifference",),
    },
    "ZeroEquivalence": {
        "namespace": "OmegaCodex.ZeroEquivalence.",
        "allowed_axioms": {"propext", "Quot.sound"},
        "imports": ("PrimitiveDifference",),
    },
    "TorsorAndOperations": {
        "namespace": "OmegaCodex.TorsorAndOperations.",
        "allowed_axioms": {"propext"},
        "imports": ("PrimitiveDifference", "MirrorNonIdentification"),
    },
    "MinimalSeparation": {
        "namespace": "OmegaCodex.MinimalSeparation.",
        "allowed_axioms": {"propext", "Quot.sound"},
        "imports": ("TorsorAndOperations", "ZeroEquivalence"),
    },
    "RetentionAndRefusal": {
        "namespace": "OmegaCodex.RetentionAndRefusal.",
        "allowed_axioms": {"propext", "Quot.sound"},
        "imports": ("TorsorAndOperations", "ZeroEquivalence"),
    },
    "LocalGlobalObstruction": {
        "namespace": "OmegaCodex.LocalGlobalObstruction.",
        "allowed_axioms": {"propext", "Quot.sound"},
        "imports": ("TorsorAndOperations", "ZeroEquivalence"),
    },
    "InternalMetatheory": {
        "namespace": "OmegaCodex.InternalMetatheory.",
        "allowed_axioms": {"propext", "Quot.sound"},
        "imports": ("TorsorAndOperations", "MinimalSeparation", "RetentionAndRefusal"),
    },
    "ProfilePreorderAndGenerator": {
        "namespace": "OmegaCodex.ProfilePreorderAndGenerator.",
        "allowed_axioms": {"propext", "Quot.sound"},
        "imports": ("TorsorAndOperations", "ZeroEquivalence"),
    },
}


RECEIPTS = {
    "PrimitiveDifference": "docs/primitive_difference_verification.json",
    "MirrorNonIdentification": "docs/mirror_non_identification_verification.json",
    "ZeroEquivalence": "docs/zero_equivalence_verification.json",
    "TorsorAndOperations": "docs/torsor_and_operations_verification.json",
    "MinimalSeparation": "docs/minimal_separation_verification.json",
    "RetentionAndRefusal": "docs/retention_and_refusal_verification.json",
    "LocalGlobalObstruction": "docs/local_global_obstruction_verification.json",
    "InternalMetatheory": "docs/internal_metatheory_verification.json",
    "ProfilePreorderAndGenerator": "docs/profile_preorder_and_generator_verification.json",
}


def _dependency_sets(receipt):
    deps = receipt.get("dependencies")
    if not isinstance(deps, dict) or not deps:
        raise RuntimeError("Missing theorem inventory")
    result = {}
    for name, axioms in deps.items():
        if (not isinstance(name, str) or not isinstance(axioms, list)
                or any(not isinstance(a, str) for a in axioms)
                or len(axioms) != len(set(axioms))):
            raise RuntimeError("Malformed theorem dependency inventory")
        result[name] = frozenset(axioms)
    if type(receipt.get("theorems_checked")) is not int or receipt["theorems_checked"] != len(deps):
        raise RuntimeError("Theorem count does not match inventory")
    return result


def verify_receipt(actual, expected, module):
    """Compare the reviewed contract, ignoring platform text in lean --version.

    Explicit receipt regeneration acknowledges drift; it does not establish that
    a changed mathematical statement retains its former strength.
    """
    source = "lean/" + module + ".lean"
    for item in (actual, expected):
        if item.get("verified") is not True or item.get("source") != source:
            raise RuntimeError("Receipt module identity or verification status mismatch")
        version = re.match(r"^Lean \(version (\d+\.\d+\.\d+),", item.get("lean_version", ""))
        if not version or version[1] != "4.33.0":
            raise RuntimeError("Receipt Lean version mismatch")
        axioms = item.get("allowed_axioms")
        if (not isinstance(axioms, list) or any(not isinstance(a, str) for a in axioms)
                or len(axioms) != len(set(axioms))
                or set(axioms) != MODULES[module]["allowed_axioms"]):
            raise RuntimeError("Receipt axiom policy mismatch")
    for field in ("source_sha256", "toolchain", "theorems_checked"):
        if actual.get(field) != expected.get(field):
            raise RuntimeError("Stored receipt mismatch: " + field)
    # The oldest primitive-difference receipt predates the empty imports field.
    if actual.get("direct_imports", {}) != expected.get("direct_imports", {}):
        raise RuntimeError("Stored receipt mismatch: direct_imports")
    if _dependency_sets(actual) != _dependency_sets(expected):
        raise RuntimeError("Stored receipt mismatch: theorem names or dependency sets")


def check(module="PrimitiveDifference"):
    config = MODULES[module]
    source_path = ROOT / "lean" / (module + ".lean")
    prefix = config["namespace"]
    allowed_axioms = config["allowed_axioms"]
    build = subprocess.run(["lake", "build", module], cwd=ROOT, capture_output=True,
                           text=True, encoding="utf-8", errors="replace")
    if build.returncode:
        raise RuntimeError(build.stdout + build.stderr)
    raw = source_path.read_bytes()
    source = raw.decode("utf-8")
    names = re.findall(r"^theorem\s+(\w+)", source, re.M)
    if not names or len(names) != len(set(names)):
        raise RuntimeError("Missing or duplicate theorem declarations")
    if re.search(r"^\s*(?:axiom|opaque)\s|\b(?:sorry|admit|native_decide)\b", source, re.M):
        raise RuntimeError("Unsupported declaration or proof placeholder in module")
    imports = tuple(name for line in re.findall(r"^import\s+([^\r\n]+)", source, re.M)
                    for name in line.split())
    if imports != config["imports"]:
        raise RuntimeError("Unexpected direct imports: " + repr(imports))
    census = source + "\n" + "\n".join("#print axioms " + prefix + name for name in names)
    with tempfile.TemporaryDirectory(prefix="omega-lean-") as temporary:
        path = Path(temporary) / (module + "Census.lean")
        path.write_text(census, encoding="utf-8")
        result = subprocess.run(["lake", "env", "lean", str(path)], cwd=ROOT, capture_output=True,
                                text=True, encoding="utf-8", errors="replace")
    if result.returncode:
        raise RuntimeError(result.stdout + result.stderr)
    dependencies = {}
    for name in names:
        pattern = "'" + re.escape(prefix + name) + "' (does not depend on any axioms|depends on axioms: \\[([^\\]]*)\\])"
        match = re.search(pattern, result.stdout)
        if not match:
            raise RuntimeError("Missing axiom report for " + name)
        axioms = [] if match[2] is None else [x.strip() for x in match[2].split(",") if x.strip()]
        if set(axioms) - allowed_axioms:
            raise RuntimeError("Unexpected theorem dependencies: " + name + " " + repr(axioms))
        dependencies[name] = axioms
    version = subprocess.check_output(["lean", "--version"], cwd=ROOT).decode("utf-8").strip()
    toolchain = (ROOT / "lean-toolchain").read_text(encoding="utf-8").strip()
    if toolchain != "leanprover/lean4:v4.33.0" or "version 4.33.0," not in version:
        raise RuntimeError("Unexpected Lean version")
    return {"verified": True, "source": source_path.relative_to(ROOT).as_posix(),
            "source_sha256": hashlib.sha256(raw).hexdigest(),
            "direct_imports": {
                "lean/" + name + ".lean": hashlib.sha256(
                    (ROOT / "lean" / (name + ".lean")).read_bytes()).hexdigest()
                for name in config["imports"]},
            "toolchain": toolchain,
            "lean_version": version, "theorems_checked": len(names),
            "allowed_axioms": sorted(allowed_axioms), "dependencies": dependencies,
            "scope": "Lean core module and theorem dependency census; no legacy project build, physical execution, or global minimality claim."}


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    output_mode = parser.add_mutually_exclusive_group()
    output_mode.add_argument("--receipt", type=Path, help="Explicitly regenerate a reviewed receipt")
    output_mode.add_argument("--verify-receipt", nargs="?", const="auto",
                             help="Verify the stored receipt; optionally give its path")
    parser.add_argument("--module", choices=MODULES, default="PrimitiveDifference")
    args = parser.parse_args()
    receipt = check(args.module)
    if args.verify_receipt:
        path = (ROOT / RECEIPTS[args.module] if args.verify_receipt == "auto"
                else Path(args.verify_receipt))
        expected = json.loads(path.read_text(encoding="utf-8"))
        verify_receipt(receipt, expected, args.module)
        print("Verified reviewed receipt: " + str(path), file=sys.stderr)
    output = json.dumps(receipt, indent=2) + "\n"
    if args.receipt:
        args.receipt.write_text(output, encoding="utf-8")
    print(output, end="")
