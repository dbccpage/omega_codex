# Omega Codex Derivation DAG (`dag/derivation_dag.json`)

This directory contains the machine-auditable directed acyclic graph ([`derivation_dag.json`](derivation_dag.json)) classifying every derivation step, admission boundary, and downstream target in the `omega_codex` program into three epistemic buckets:

1. **`DERIVED` (20 nodes)**: Checked in constructive Lean 4.33.0 (`lean/*.lean`, 245 theorems across 8 modules with SHA-256 verification receipts in `docs/*_verification.json`, 100% theorem coverage in the DAG) and/or Python 3 standard-library check scripts (`audit/2026-11-05_minimal_chain/*_checks.py`, `scripts/*.py`).
2. **`OWED` (10 nodes)**: Explicit host substrate admissions (`S0`–`S5`), post-seal unfreezing mechanism choices (`M1`–`M3`), and open bridge obligations (`OWE-05` through `OWE-10`, covering `PG-R-GAP`, `N21`–`N22` internal witnessing/persistence, `N19`–`N20` ten-stick reflection and four-step lift, `L1-R-RESIDUAL-TO-WEIGHTS`, and `N23`/`N25`/`N26` profile preorder and continuum completeness) where historical or target steps require premises not forced by prior derived nodes alone.
3. **`IMAGINED` (10 nodes)**: Planned downstream Cosmos extensions still to come (`IMG-01` through `IMG-10`): higher $k$-simplex WDP cohomology, causal-diamond observer functors, $\ell_1$-to-$\ell_2$ Parseval phase bridge, finite quantum mechanics (Born rule, finite Gleason frame functions, CPTP channels), MUBs and entanglement, discrete Noether currents, finite lattice gauge sectors, simplicial Regge gravity, finite constructor theory, and self-hosting Cosmos metatheory.

## Lean 4.33.0 Inventory Bound to the DAG

| Module | Source | Verification Receipt | Theorems Checked | Allowed Axioms |
|---|---|---|---:|---|
| `PrimitiveDifference` | [`lean/PrimitiveDifference.lean`](../lean/PrimitiveDifference.lean) | [`docs/primitive_difference_verification.json`](../docs/primitive_difference_verification.json) | 26 | `propext` |
| `MirrorNonIdentification` | [`lean/MirrorNonIdentification.lean`](../lean/MirrorNonIdentification.lean) | [`docs/mirror_non_identification_verification.json`](../docs/mirror_non_identification_verification.json) | 19 | `propext` |
| `ZeroEquivalence` | [`lean/ZeroEquivalence.lean`](../lean/ZeroEquivalence.lean) | [`docs/zero_equivalence_verification.json`](../docs/zero_equivalence_verification.json) | 62 | `propext`, `Quot.sound` |
| `TorsorAndOperations` | [`lean/TorsorAndOperations.lean`](../lean/TorsorAndOperations.lean) | [`docs/torsor_and_operations_verification.json`](../docs/torsor_and_operations_verification.json) | 36 | `propext` |
| `MinimalSeparation` | [`lean/MinimalSeparation.lean`](../lean/MinimalSeparation.lean) | [`docs/minimal_separation_verification.json`](../docs/minimal_separation_verification.json) | 29 | `propext`, `Quot.sound` |
| `RetentionAndRefusal` | [`lean/RetentionAndRefusal.lean`](../lean/RetentionAndRefusal.lean) | [`docs/retention_and_refusal_verification.json`](../docs/retention_and_refusal_verification.json) | 29 | `propext`, `Quot.sound` |
| `LocalGlobalObstruction` | [`lean/LocalGlobalObstruction.lean`](../lean/LocalGlobalObstruction.lean) | [`docs/local_global_obstruction_verification.json`](../docs/local_global_obstruction_verification.json) | 20 | `propext`, `Quot.sound` |
| `InternalMetatheory` | [`lean/InternalMetatheory.lean`](../lean/InternalMetatheory.lean) | [`docs/internal_metatheory_verification.json`](../docs/internal_metatheory_verification.json) | 24 | `propext`, `Quot.sound` |
| **Total** | **8 modules** | **8 receipts** | **245** | **Constructive core (`zero sorry`, `zero Classical.choice`)** |

## Validation Commands

Run the standalone validator and unit test suite from the repository root:

```powershell
python scripts/validate_derivation_dag.py --run-checks
python -m unittest discover -s tests -p "test_*.py" -v
```

The validator checks:
- Top-level schema, Claim Hygiene scope fields, and absence of forbidden hype terms across all node titles, statements, and edge notes.
- Exact SHA-256 source and `direct_imports` match, axiom compliance (`propext` / `Quot.sound` only, zero `Classical.choice` or `sorryAx`), and theorem-count parity for all 8 Lean modules (`245` total theorems), plus 100% surjective theorem coverage (every theorem in every receipt is bound to at least one DAG node) and 100% reference coverage across `N00`–`N33`, `OQ-01`–`OQ-08`, and `RT-01`–`RT-12`.
- Existence of all referenced Lean files, JSON receipts, Python check scripts, and markdown documentation files, with optional execution of all 9 referenced Python check scripts via `--run-checks`.
- Epistemic edge discipline (no `DERIVED` or `OWED` node may depend on an `IMAGINED` node; every edge from an `OWED` node to a `DERIVED` node must have kind `"requires_admission"`).
- Strict topological acyclicity (Kahn's algorithm over all 40 nodes and 56 directed edges).
