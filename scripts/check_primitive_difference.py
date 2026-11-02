"""Build each scoped Lean module and census every theorem's axiom dependencies."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
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
}


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
    parser.add_argument("--receipt", type=Path)
    parser.add_argument("--module", choices=MODULES, default="PrimitiveDifference")
    args = parser.parse_args()
    receipt = check(args.module)
    output = json.dumps(receipt, indent=2) + "\n"
    if args.receipt:
        args.receipt.write_text(output, encoding="utf-8")
    print(output, end="")
