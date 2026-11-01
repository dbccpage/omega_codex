"""Check the small Lean module and every theorem's reported axiom dependencies."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "lean" / "PrimitiveDifference.lean"
PREFIX = "OmegaCodex.PrimitiveDifference."
ALLOWED_AXIOMS = {"propext"}

def check():
    raw = SOURCE.read_bytes()
    source = raw.decode("utf-8")
    names = re.findall(r"^theorem\s+(\w+)", source, re.M)
    if not names or len(names) != len(set(names)):
        raise RuntimeError("Missing or duplicate theorem declarations")
    if re.search(r"^\s*(?:axiom|opaque)\s|\b(?:sorry|admit|native_decide)\b", source, re.M):
        raise RuntimeError("Unsupported declaration or proof placeholder in module")
    census = source + "\n" + "\n".join("#print axioms " + PREFIX + name for name in names)
    with tempfile.TemporaryDirectory(prefix="omega-lean-") as temporary:
        path = Path(temporary) / "PrimitiveDifferenceCensus.lean"
        path.write_text(census, encoding="utf-8")
        result = subprocess.run(["lean", str(path)], cwd=ROOT, capture_output=True,
                                text=True, encoding="utf-8", errors="replace")
    if result.returncode:
        raise RuntimeError(result.stdout + result.stderr)
    dependencies = {}
    for name in names:
        pattern = "'" + re.escape(PREFIX + name) + "' (does not depend on any axioms|depends on axioms: \\[([^\\]]*)\\])"
        match = re.search(pattern, result.stdout)
        if not match:
            raise RuntimeError("Missing axiom report for " + name)
        axioms = [] if match[2] is None else [x.strip() for x in match[2].split(",") if x.strip()]
        if set(axioms) - ALLOWED_AXIOMS:
            raise RuntimeError("Unexpected theorem dependencies: " + name + " " + repr(axioms))
        dependencies[name] = axioms
    version = subprocess.check_output(["lean", "--version"], cwd=ROOT).decode("utf-8").strip()
    toolchain = (ROOT / "lean-toolchain").read_text(encoding="utf-8").strip()
    if toolchain != "leanprover/lean4:v4.33.0" or "version 4.33.0," not in version:
        raise RuntimeError("Unexpected Lean version")
    return {"verified": True, "source": SOURCE.relative_to(ROOT).as_posix(),
            "source_sha256": hashlib.sha256(raw).hexdigest(), "toolchain": toolchain,
            "lean_version": version, "theorems_checked": len(names),
            "allowed_axioms": sorted(ALLOWED_AXIOMS), "dependencies": dependencies,
            "scope": "Lean core module and theorem dependency census; no legacy project build, physical execution, or global minimality claim."}

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--receipt", type=Path)
    args = parser.parse_args()
    receipt = check()
    output = json.dumps(receipt, indent=2) + "\n"
    if args.receipt:
        args.receipt.write_text(output, encoding="utf-8")
    print(output, end="")
