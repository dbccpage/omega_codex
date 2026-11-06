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
    "WitnessedDifference.GenerativeHistoryCompression": {
        "namespace": "WitnessedDifference.GenerativeHistoryCompression.",
        "allowed_axioms": {"propext", "Quot.sound"},
        "imports": (),
    },
    "WitnessedDifference.GenesisConstruction": {
        "namespace": "WitnessedDifference.GenesisConstruction.",
        "allowed_axioms": {"propext"},
        "imports": ("WitnessedDifference.GenerativeHistoryCompression",),
    },
    "AdmissionReplay": {
        "namespace": "OmegaCodex.AdmissionReplay.",
        "allowed_axioms": {"propext", "Quot.sound"},
        "imports": ("MinimalSeparation", "WitnessedDifference.GenesisConstruction"),
    },
    "WitnessedDifference.FiniteDistinction": {
        "namespace": "Wd2.",
        "allowed_axioms": {"propext", "Quot.sound"},
        "imports": (),
    },
    "WitnessedDifference.RelationalRetention": {
        "namespace": "WitnessedDifference.RelationalRetention.",
        "allowed_axioms": {"propext", "Quot.sound"},
        "imports": (),
    },
    "WitnessedDifference.RetentionChoices": {
        "namespace": "WitnessedDifference.RetentionChoices.",
        "allowed_axioms": {"propext", "Quot.sound"},
        "imports": (),
    },
    "WitnessedDifference.Source25PairTransport": {
        "namespace": "WitnessedDifference.Source25PairTransport.",
        "allowed_axioms": {"propext", "Quot.sound"},
        "imports": (),
    },
    "WitnessedDifference.CochainTransport": {
        "namespace": "WitnessedDifference.CochainTransport.",
        "allowed_axioms": {"propext"},
        "imports": (),
    },
    "WitnessedDifference.BehavioralQuotient": {
        "namespace": "WitnessedDifference.BehavioralQuotient.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.ContextReflection": {
        "namespace": "WitnessedDifference.ContextReflection.",
        "allowed_axioms": {"propext"},
        "imports": (),
    },
    "WitnessedDifference.FaithfulRepresentation": {
        "namespace": "WitnessedDifference.FaithfulRepresentation.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.GuardedHistoryCoherence": {
        "namespace": "WitnessedDifference.GuardedHistoryCoherence.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.ObserverDescent": {
        "namespace": "WitnessedDifference.ObserverDescent.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.OriginalGenesisObserver": {
        "namespace": "WitnessedDifference.OriginalGenesisObserver.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.PrimitiveAdmissionFloor": {
        "namespace": "WitnessedDifference.PrimitiveAdmissionFloor.",
        "allowed_axioms": {"propext"},
        "imports": (),
    },
    "WitnessedDifference.PrimitiveContextFloor": {
        "namespace": "WitnessedDifference.PrimitiveContextFloor.",
        "allowed_axioms": {"propext"},
        "imports": (),
    },
    "WitnessedDifference.RootGaugeNormalization": {
        "namespace": "WitnessedDifference.RootGaugeNormalization.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.SparseChainTransportBounds": {
        "namespace": "WitnessedDifference.SparseChainTransportBounds.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.TrotterCharPoly": {
        "namespace": "WitnessedDifference.TrotterCharPoly.",
        "allowed_axioms": {"propext"},
        "imports": (),
    },
    "WitnessedDifference.WdpBatch9": {
        "namespace": "WitnessedDifference.WdpBatch9.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.Obstruction": {
        "namespace": "WitnessedDifference.Obstruction.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.LocalCompatibility": {
        "namespace": "WitnessedDifference.LocalCompatibility.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.DiscreteGaussBonnet": {
        "namespace": "WitnessedDifference.DiscreteGaussBonnet.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.FiniteWindowObstruction": {
        "namespace": "WitnessedDifference.FiniteWindowObstruction.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.HigherSimplicialCohomology": {
        "namespace": "WitnessedDifference.HigherSimplicialCohomology.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.BridgeObligationReductions": {
        "namespace": "WitnessedDifference.BridgeObligationReductions.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.WdpBatch13": {
        "namespace": "WitnessedDifference.WdpBatch13.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": ("WitnessedDifference.WdpBatch12",),
    },
    "WitnessedDifference.WdpBatch12": {
        "namespace": "WitnessedDifference.WdpBatch12.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": ("WitnessedDifference.WdpBatch11",),
    },
    "WitnessedDifference.WdpBatch11": {
        "namespace": "WitnessedDifference.WdpBatch11.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": ("WitnessedDifference.WdpBatch10",),
    },
    "WitnessedDifference.WdpBatch10": {
        "namespace": "WitnessedDifference.WdpBatch10.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": ("WitnessedDifference.WdpBatch9",),
    },
    "WitnessedDifference.BalancePreservingEdits": {
        "namespace": "WitnessedDifference.BalancePreservingEdits.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.AdmissionCount": {
        "namespace": "WitnessedDifference.AdmissionCount.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.FunctionalClassification": {
        "namespace": "WitnessedDifference.FunctionalClassification.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": ("WitnessedDifference.BehavioralQuotient",),
    },
    "WitnessedDifference.SelfReferenceBridges": {
        "namespace": "WitnessedDifference.SelfReferenceBridges.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.DyadicPresentation": {
        "namespace": "WitnessedDifference.DyadicPresentation.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.FiniteConstraintRepresentation": {
        "namespace": "WitnessedDifference.FiniteConstraintRepresentation.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": ("WitnessedDifference.FaithfulRepresentation",),
    },
    "WitnessedDifference.MeronThermoLimitConstants": {
        "namespace": "WitnessedDifference.MeronThermoLimitConstants.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.MarkedGaugeTransport": {
        "namespace": "WitnessedDifference.MarkedGaugeTransport.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": ("WitnessedDifference.RootGaugeNormalization", "WitnessedDifference.Source25PairTransport"),
    },
    "WitnessedDifference.ComplexTensorBalancing": {
        "namespace": "WitnessedDifference.ComplexTensorBalancing.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.GaussianIntQuantumReadout": {
        "namespace": "WitnessedDifference.GaussianIntQuantumReadout.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.DaggerObserverPairing": {
        "namespace": "WitnessedDifference.DaggerObserverPairing.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": ("WitnessedDifference.AdditiveTensorCompletion",),
    },
    "WitnessedDifference.AdditiveTensorCompletion": {
        "namespace": "WitnessedDifference.AdditiveTensorCompletion.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.ObserverAdapterCompleteness": {
        "namespace": "WitnessedDifference.ObserverAdapterCompleteness.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.FoundationalBridges": {
        "namespace": "WitnessedDifference.FoundationalBridges.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": (),
    },
    "WitnessedDifference.GuardedScheduleTopology": {
        "namespace": "WitnessedDifference.GuardedScheduleTopology.",
        "allowed_axioms": {"Quot.sound", "propext"},
        "imports": ("WitnessedDifference.GuardedHistoryCoherence",),
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
    "WitnessedDifference.GenerativeHistoryCompression": "docs/wdp_generative_history_compression_verification.json",
    "WitnessedDifference.GenesisConstruction": "docs/wdp_genesis_construction_verification.json",
    "AdmissionReplay": "docs/admission_replay_verification.json",
    "WitnessedDifference.FiniteDistinction": "docs/wdp_finite_distinction_verification.json",
    "WitnessedDifference.RelationalRetention": "docs/wdp_relational_retention_verification.json",
    "WitnessedDifference.RetentionChoices": "docs/wdp_retention_choices_verification.json",
    "WitnessedDifference.Source25PairTransport": "docs/wdp_source25_pair_transport_verification.json",
    "WitnessedDifference.CochainTransport": "docs/wdp_cochain_transport_verification.json",
    "WitnessedDifference.BehavioralQuotient": "docs/wdp_behavioral_quotient_verification.json",
    "WitnessedDifference.ContextReflection": "docs/wdp_context_reflection_verification.json",
    "WitnessedDifference.FaithfulRepresentation": "docs/wdp_faithful_representation_verification.json",
    "WitnessedDifference.GuardedHistoryCoherence": "docs/wdp_guarded_history_coherence_verification.json",
    "WitnessedDifference.ObserverDescent": "docs/wdp_observer_descent_verification.json",
    "WitnessedDifference.OriginalGenesisObserver": "docs/wdp_original_genesis_observer_verification.json",
    "WitnessedDifference.PrimitiveAdmissionFloor": "docs/wdp_primitive_admission_floor_verification.json",
    "WitnessedDifference.PrimitiveContextFloor": "docs/wdp_primitive_context_floor_verification.json",
    "WitnessedDifference.RootGaugeNormalization": "docs/wdp_root_gauge_normalization_verification.json",
    "WitnessedDifference.SparseChainTransportBounds": "docs/wdp_sparse_chain_transport_bounds_verification.json",
    "WitnessedDifference.TrotterCharPoly": "docs/wdp_trotter_char_poly_verification.json",
    "WitnessedDifference.WdpBatch9": "docs/wdp_batch9_verification.json",
    "WitnessedDifference.Obstruction": "docs/wdp_obstruction_verification.json",
    "WitnessedDifference.LocalCompatibility": "docs/wdp_local_compatibility_verification.json",
    "WitnessedDifference.DiscreteGaussBonnet": "docs/wdp_discrete_gauss_bonnet_verification.json",
    "WitnessedDifference.FiniteWindowObstruction": "docs/wdp_finite_window_obstruction_verification.json",
    "WitnessedDifference.HigherSimplicialCohomology": "docs/wdp_higher_simplicial_cohomology_verification.json",
    "WitnessedDifference.BridgeObligationReductions": "docs/wdp_bridge_obligation_reductions_verification.json",
    "WitnessedDifference.WdpBatch13": "docs/wdp_batch13_verification.json",
    "WitnessedDifference.WdpBatch12": "docs/wdp_batch12_verification.json",
    "WitnessedDifference.WdpBatch11": "docs/wdp_batch11_verification.json",
    "WitnessedDifference.WdpBatch10": "docs/wdp_batch10_verification.json",
    "WitnessedDifference.BalancePreservingEdits": "docs/wdp_balance_preserving_edits_verification.json",
    "WitnessedDifference.AdmissionCount": "docs/wdp_admission_count_verification.json",
    "WitnessedDifference.FunctionalClassification": "docs/wdp_functional_classification_verification.json",
    "WitnessedDifference.SelfReferenceBridges": "docs/wdp_self_reference_bridges_verification.json",
    "WitnessedDifference.DyadicPresentation": "docs/wdp_dyadic_presentation_verification.json",
    "WitnessedDifference.FiniteConstraintRepresentation": "docs/wdp_finite_constraint_representation_verification.json",
    "WitnessedDifference.MeronThermoLimitConstants": "docs/wdp_meron_thermo_limit_constants_verification.json",
    "WitnessedDifference.MarkedGaugeTransport": "docs/wdp_marked_gauge_transport_verification.json",
    "WitnessedDifference.ComplexTensorBalancing": "docs/wdp_complex_tensor_balancing_verification.json",
    "WitnessedDifference.GaussianIntQuantumReadout": "docs/wdp_gaussian_int_quantum_readout_verification.json",
    "WitnessedDifference.DaggerObserverPairing": "docs/wdp_dagger_observer_pairing_verification.json",
    "WitnessedDifference.AdditiveTensorCompletion": "docs/wdp_additive_tensor_completion_verification.json",
    "WitnessedDifference.ObserverAdapterCompleteness": "docs/wdp_observer_adapter_completeness_verification.json",
    "WitnessedDifference.FoundationalBridges": "docs/wdp_foundational_bridges_verification.json",
    "WitnessedDifference.GuardedScheduleTopology": "docs/wdp_guarded_schedule_topology_verification.json",
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
    source = "lean/" + module.replace(".", "/") + ".lean"
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
    source_path = ROOT / "lean" / (module.replace(".", "/") + ".lean")
    prefix = config["namespace"]
    allowed_axioms = config["allowed_axioms"]
    build = subprocess.run(["lake", "build", module], cwd=ROOT, capture_output=True,
                           text=True, encoding="utf-8", errors="replace")
    if build.returncode:
        raise RuntimeError(build.stdout + build.stderr)
    raw = source_path.read_bytes()
    source = raw.decode("utf-8")
    names = re.findall(r"^theorem\s+([\w.]+)", source, re.M)
    if not names or len(names) != len(set(names)):
        raise RuntimeError("Missing or duplicate theorem declarations")
    if re.search(r"^\s*(?:axiom|opaque)\s|\b(?:sorry|admit|native_decide)\b", source, re.M):
        raise RuntimeError("Unsupported declaration or proof placeholder in module")
    imports = tuple(name for line in re.findall(r"^import\s+([^\r\n]+)", source, re.M)
                    for name in line.split())
    if imports != config["imports"]:
        raise RuntimeError("Unexpected direct imports: " + repr(imports))
    census = source + "\n" + "\n".join("#print axioms " + prefix + name for name in names)
    (ROOT / ".lake").mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="omega-lean-", dir=ROOT / ".lake") as temporary:
        path = Path(temporary) / (module.replace(".", "_") + "Census.lean")
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
                "lean/" + name.replace(".", "/") + ".lean": hashlib.sha256(
                    (ROOT / "lean" / (name.replace(".", "/") + ".lean")).read_bytes()).hexdigest()
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
