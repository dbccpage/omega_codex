# Omega Codex Derivation DAG (`dag/derivation_dag.json`)

This directory contains [`derivation_dag.json`](./derivation_dag.json), a machine-auditable directed acyclic graph (DAG) classifying every derivation node, admission, open bridge, and planned downstream target in `omega_codex` into three disjoint epistemic buckets:

1. **`DERIVED` (20 nodes; 227 constructive Lean 4.33.0 theorems across 8 modules + stdlib Python checks)**:
   - Every node in this bucket resolves to concrete Lean 4.33.0 theorem names (checked under allowed axioms restricted to `propext` and `Quot.sound`, with zero `Classical.choice`, zero `sorry`, and zero Mathlib) and/or stdlib Python check scripts, backed by SHA-256 source-bound receipts in `docs/`.
   - Covers the pre-seal mark and counterpart involution (`PrimitiveDifference.lean`), two-position census and $C_2$ torsor operations (`TorsorAndOperations.lean`), mirror non-identification (`MirrorNonIdentification.lean`), kernel zero-equivalence (`ZeroEquivalence.lean`), pruned 4-tuple separation and binary arity-cost uniqueness (`MinimalSeparation.lean`), 5-mode refusal, `16/1024` memory retention packet, and choice-free finite report factorization (`RetentionAndRefusal.lean`), $\mathbb{F}_2$ vs $\mathbb{Z}$ simplicial coboundaries, vortex defect, and twisted holonomy (`LocalGlobalObstruction.lean`), and 6-guard constitutional initiality, diagonal non-exhaustion, and monotonic no-return (`InternalMetatheory.lean`).

2. **`OWED` (10 nodes)**:
   - Explicitly priced host substrate admissions (`S0`–`S5`), post-seal unfreezing mechanisms (`M1`–`M3`), and open proof/specification bridges (`PG-R-GAP-DIAMOND-TO-ROOT`, `PG-R-GAP-GENESIS-TO-WINDOW`, `N13`–`N15` internal witnessing acquisition, `N19`–`N22` profile preorder and ten-stick reflection, `L1-R-RESIDUAL-TO-WEIGHTS` canonical weight selection on asymmetric quotients, and `N23`/`N25`/`N26` continuum completeness).

3. **`IMAGINED` (10 nodes)**:
   - Planned downstream extensions still to come: higher $k$-simplex WDP cohomology (`IMG-01`), causal-diamond observer functors (`IMG-02`), $\ell_1$-to-$\ell_2$ Parseval phase bridge (`IMG-03`), finite quantum mechanics Born/Gleason/CPTP (`IMG-04`), MUBs and composite tensor entanglement (`IMG-05`), discrete variational Noether currents (`IMG-06`), finite lattice gauge sectors (`IMG-07`), simplicial Regge gravity (`IMG-08`), finite constructor theory and Landauer erasure (`IMG-09`), and self-hosting Cosmos metatheory (`IMG-10`).

## Validation

Run the stdlib Python validator from the repository root:

```powershell
python scripts/validate_derivation_dag.py
```

Run the unit test suite (including negative mutation tests for cycles, broken theorem bindings, missing files, and Claim Hygiene violations):

```powershell
python -m unittest tests/test_derivation_dag.py -v
```

## Claim Hygiene Summary

1. **What it supports**: A deterministic, machine-checked inventory of which claims in `omega_codex` are backed by Lean 4.33.0 theorems and Python stdlib checks (`DERIVED`), which premises or bridge steps remain supplied admissions or open obligations (`OWED`), and which downstream stages are planned future targets (`IMAGINED`).
2. **What it does not support**: Any claim that `OWED` or `IMAGINED` nodes are already derived, any claim of zero-input creation from nothing, or any empirical physical validation beyond the finite algebraic models checked in this repository.
3. **The narrowest defensible claim**: All 20 `DERIVED` nodes resolve to existing Lean 4.33.0 theorems (227 theorems across 8 modules) and/or stdlib Python check scripts in this checkout, all 40 nodes and 48 directed edges form an acyclic graph, and all dependencies on `OWED` admissions are explicitly recorded.
4. **The next test needed**: Constructive discharge or minimal-premise reduction of the `OWED` bridge nodes (`OWE-07` witnessing acquisition, `OWE-08` profile preorder and ten-stick reflection, and `OWE-09` canonical positive weights on asymmetric quotients).
