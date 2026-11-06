# Campaign 3 Stage B: Five-Slice Lean 4.33.0 Reconstruction and Derivation DAG Verification

## 1. Scope and Summary

This report records the execution of the five-slice Lean 4.33.0 reconstruction roadmap from `12_post_seal_adversary_and_roadmap.md`, the constructive resolution of red-team boundary stress tests `RT-01` through `RT-12`, and the creation of `dag/derivation_dag.json` plus its stdlib Python validator `scripts/validate_derivation_dag.py`.

All eight Lean modules in `lean/` compile under `leanprover/lean4:v4.33.0` with zero `sorry`, zero `Classical.choice`, zero Mathlib dependencies, and `#print axioms` restricted to `propext` and `Quot.sound`.

---

## 2. Eight-Module Lean 4.33.0 Inventory (227 Theorems)

| Slice | Module | Source File | Verification Receipt | Theorems Checked | Primary Coverage |
|---|---|---|---|---:|---|
| Baseline 1 | `PrimitiveDifference` | `lean/PrimitiveDifference.lean` | `docs/primitive_difference_verification.json` | 26 | Mark soundness vs irreflexivity, `S2`, counterpart involution, refusal on identification |
| Baseline 2 | `MirrorNonIdentification` | `lean/MirrorNonIdentification.lean` | `docs/mirror_non_identification_verification.json` | 19 | Two-referent mirror symmetry, observation-only agreement, fiber-constant decoding |
| Baseline 3 | `ZeroEquivalence` | `lean/ZeroEquivalence.lean` | `docs/zero_equivalence_verification.json` | 62 | Kernel `zeroRel`, `ResidualQuotient`, unary/binary descent, static vs operational refinement |
| Slice 1 | `TorsorAndOperations` | `lean/TorsorAndOperations.lean` | `docs/torsor_and_operations_verification.json` | 34 | 16-relation census on `Bool`, `D2` vs `S2Bool`, $C_2$ torsor displacement, `Clos`/`Irred`/`merger_erases`, `OQ-01` + `RT-03` radix bound, `SymmetryFloor` on `Fin 3` |
| Slice 2 | `MinimalSeparation` | `lean/MinimalSeparation.lean` | `docs/minimal_separation_verification.json` | 26 | Pruned 4-tuple `Regime4`, `ctxKernel4` bridge, `OQ-04` (`mu2_unique_general`, `mu2_unique_F_general`) + `RT-01` countermodel, `OQ-05` round bounds + `RT-09` re-collapse witness |
| Slice 3 | `RetentionAndRefusal` | `lean/RetentionAndRefusal.lean` | `docs/retention_and_refusal_verification.json` | 27 | 5-mode refusal hierarchy, `OQ-03` `16/1024` & `4/1024` laws + `RT-02` multi-step idle drift, `OQ-06` choice-free `decodeFin` + `RT-05` / `RT-10`, `RT-06` closure-symmetry duality, `OQ-08` 5-gate morphism |
| Slice 4 | `LocalGlobalObstruction` | `lean/LocalGlobalObstruction.lean` | `docs/local_global_obstruction_verification.json` | 19 | `OQ-02` $\mathbb{F}_2$ vs $\mathbb{Z}$ triangle/tetrahedron coboundaries & vortex defect + `RT-04` intertwiner, `OQ-07` positive $\ell_1$ weights + `RT-11` non-transitive countermodel, `RT-07` fixed-pair section criterion, `RT-08` twisted triangle holonomy |
| Slice 5 | `InternalMetatheory` | `lean/InternalMetatheory.lean` | `docs/internal_metatheory_verification.json` | 14 | 6-guard constitutional initiality (`d20_unique_compliant`, `guard_independence_six_countermodels`), `NoOutside` re-entry, `InterpreterBoundary` diagonal non-exhaustion, monotonic no-return (`strict_measure_no_return`) |
| **Total** | **8 modules** | `lean/*.lean` | `docs/*_verification.json` | **227** | **All axioms in `{propext, Quot.sound}`** |

---

## 3. Red-Team Boundary Stress Tests (`RT-01`–`RT-12`) Resolution Matrix

| ID | Target | Resolution in Lean 4.33.0 | Theorem Name & Module |
|---|---|---|---|
| `RT-01` | `OQ-04` zero unary weight on 3-item carrier | Explicit countermodel on `Fin 3` showing `w(1)=0` witnesses `(0,2)` at cost 0 while keeping `(0,1)` unseparated | `rt01_zero_unary_weight_three_item_countermodel` (`MinimalSeparation.lean`) |
| `RT-02` | `OQ-03` idle drift beyond 1 step | Law in `16 \ 4` flips memory at 2 idle steps, whereas `4/1024` drift-free laws preserve memory for all idle horizons $k \ge 0$ | `rt02_idle_drift_flips_on_two_steps`, `rt02_drift_free_all_idle_steps` (`RetentionAndRefusal.lean`) |
| `RT-03` | `OQ-01` list-length radix bound | Any per-item replacement of length $L \le 1$ cannot grow list length; growth requires $L \ge 2$ | `list_expansion_requires_length_two` (`TorsorAndOperations.lean`) |
| `RT-04` | `OQ-02` cyclic vs simplicial sign convention | Explicit diagonal gauge `diag(1, 1, -1)` intertwines cyclic and standard simplicial boundary matrices | `rt04_cyclic_to_simplicial_intertwines`, `boundary_cancellation_tet_signed` (`LocalGlobalObstruction.lean`) |
| `RT-05` | `OQ-06` unary vs general fiber constancy | Congruence across all boolean unary predicates `Fin n -> Bool` is equivalent to fiber constancy for arbitrary output types | `rt05_unaryCongruent_iff_fiberConstant_all` (`RetentionAndRefusal.lean`) |
| `RT-06` | `OQ-08` closure failure vs internal symmetry | Unseparated pair `(u,v)` fails closure under `P` iff transposition `swap(u,v)` breaks `P`; faithful network descent forces trivial loop holonomy | `closure_failure_iff_internal_symmetry_break` (`RetentionAndRefusal.lean`), `faithful_network_descent_forces_trivial_loops` (`LocalGlobalObstruction.lean`) |
| `RT-07` | Natural section fixed-pair vs single fixed point | Natural section exists iff endomorphism fixes an off-diagonal pair; a single fixed point on `Fin 3` with swapped remainder fails | `natural_section_exists_iff_fixed_pair`, `rt07_carrier_fixed_point_insufficient_fin3` (`LocalGlobalObstruction.lean`) |
| `RT-08` | Pairwise flat vs global twisted $C_2$ triangle | Untwisted triangle glues uniquely per base bit; twisted triangle is pairwise solvable on every edge but admits no global section | `untwisted_triangle_glues_uniquely`, `twisted_triangle_pairwise_solvable_no_global` (`LocalGlobalObstruction.lean`) |
| `RT-09` | `OQ-05` non-append-only pair re-collapse | Overwriting evaluation separates requested `(0,1)` while re-collapsing unrequested `(1,2)` on `Fin 3` | `rt09_unrequested_pair_recollapse_witness` (`MinimalSeparation.lean`) |
| `RT-10` | `OQ-06` `decodeFin` order and default invariance | `decodeFin` is invariant to scan order and default fallback on `Im(h)`, and returns default off `Im(h)` | `rt10_decodeFin_order_and_default_invariant_on_image`, `rt10_decodeFin_off_image_eq_default` (`RetentionAndRefusal.lean`) |
| `RT-11` | `OQ-07` non-edge-transitive symmetry | Partial symmetry `swap23` preserves unequal positive weights `(1, 2, 2)`, showing edge-transitivity is required to force equal weights | `rt11_non_transitive_swap23_allows_unequal_weights` (`LocalGlobalObstruction.lean`) |
| `RT-12` | `OQ-08` 5-gate vs 3-gate strict refinement | Priced admission/retention trace step is non-zero under 5-gate cost while projecting to 0 under 3-gate horizon cost | `oq08_five_gate_strictly_finer_when_adm_priced` (`RetentionAndRefusal.lean`) |

---

## 4. Derivation DAG Summary (`dag/derivation_dag.json`)

The file `dag/derivation_dag.json` (validated by `scripts/validate_derivation_dag.py` and `tests/test_derivation_dag.py`) organizes the program into 40 nodes and 56 directed edges across three epistemic buckets:

- **`DERIVED` (20 nodes)**: `DER-01` through `DER-20`, bound to the 8 Lean 4.33.0 modules (227 theorems), their 8 receipts in `docs/`, the Python stdlib check suites in `audit/2026-11-05_minimal_chain/`, and the anchored seed audit in `evidence/seed_audit_2026-11-01/`.
- **`OWED` (10 nodes)**: `OWE-01` through `OWE-10`, recording host admissions `S0`–`S5`, unfreezing mechanisms `M1`–`M3`, and open bridges (`PG-R-GAP-DIAMOND-TO-ROOT`, `PG-R-GAP-GENESIS-TO-WINDOW`, `N13`–`N15` witnessing acquisition, `N19`–`N22` profile preorder and ten-stick reflection, `L1-R-RESIDUAL-TO-WEIGHTS`, and `N23`–`N26` continuum completeness).
- **`IMAGINED` (10 nodes)**: `IMG-01` through `IMG-10`, recording planned downstream targets (higher semi-simplicial WDP cohomology, causal-diamond observer functors, $\ell_1$-to-$\ell_2$ Parseval phase bridge, finite QM Born/Gleason/CPTP, MUB/entanglement, discrete Noether currents, finite gauge sectors, simplicial Regge gravity, finite constructor theory, and self-hosting Cosmos metatheory).

---

## 5. Claim Hygiene Summary

1. **What it supports**: The 5 new Lean 4.33.0 slices (`TorsorAndOperations`, `MinimalSeparation`, `RetentionAndRefusal`, `LocalGlobalObstruction`, `InternalMetatheory`) and the 3 baseline modules compile constructively (227 theorems total, axioms in `{propext, Quot.sound}`), settle `OQ-01`–`OQ-08` and `RT-01`–`RT-12`, and are indexed with `OWED` and `IMAGINED` nodes in `dag/derivation_dag.json`.
2. **What it does not support**: Any claim that `OWED` or `IMAGINED` nodes are derived, any claim of zero-input creation from nothing, or any empirical physical claim beyond the finite algebraic models checked here.
3. **The narrowest defensible claim**: Within `omega_codex`, all 20 `DERIVED` DAG nodes resolve to machine-checked Lean 4.33.0 theorems and stdlib Python check scripts with matching SHA-256 receipts, and all dependencies on `OWED` admissions are explicitly typed.
4. **The next test needed**: Constructive formalization or minimal-premise reduction of `OWE-07` (`N13`–`N15` witnessing acquisition), `OWE-08` (`N19`–`N22` profile preorder and ten-stick reflection), and `OWE-09` (`L1-R-RESIDUAL-TO-WEIGHTS`).
