# Minimal Derivation Chain Audit: Shared Rules and File Index

## Source Commits

- `A` (`C:\Users\a343o\source\repos\19L57G1`): `45bb09864f9b52ed5ecf66e977ca81f0ed623de7`
- `B` (`C:\Users\a343o\source\repos\theory_of_finite_quantum_mechanics`): `e45ed2e133920aa3790af8c5e072ee9829898490`
- `omega_codex` (`C:\Users\a343o\source\repos\omega_codex` baseline): `e21b785626ff8d0231a53409c76fe4e7a57cd59d`

## Claim Tags and Definitions

- `Supplied` - declared, admitted, or chosen; specifies who chose it and where (`file:line`).
- `Derived` - follows from listed `Supplied` items by a proof written out in full.
- `Witnessed` - reproduced here by an exact command plus its pasted output (Python standard library, or `lake env lean <file>` on a scratch file inside the audit folder), or an exact quote with `file:line` from a source.
- `OPEN` - not settled; specifies what check or proof would settle it.
- `Forced` - holds in every model of the listed `Supplied` items, established either by a full proof or by checking every model inside a stated finite bound (stating that the bound is a bound).
- `Not forced` - refuted by an explicit countermodel satisfying the listed `Supplied` items.

## Output File List

| File | Prompt | Purpose |
|---|---|---|
| `0_README.md` | Prompt 0 | Records pinned source commits, claim tag definitions, output file inventory, and one-line prompt summaries. |
| `1_admission_ledger.md` | Prompt 1 | Lists every declared and hidden admission between `<>` and a witnessed difference across pre-Genesis, Genesis, and WDP. |
| `2_mark_alone.md` | Prompt 2 | Evaluates what follows from `<>` alone, distinguishes the seven operations, and classifies minimal single additions and carrier swaps. |
| `2_mark_checks.py` | Prompt 2 | Enumerates finite models for `<>` alone, minimal single additions, and carrier swaps using the Python standard library. |
| `3_regime_fields.md` | Prompt 3 | Tests deletion and derivability of each of the five `Regime` fields `(D, F, I, U, Q)` against core Genesis results and identifies non-field capabilities. |
| `3_regime_deletions.py` | Prompt 3 | Reimplements `Regime`, derivability, and profiles in the Python standard library and enumerates regimes with `n <= 3` data and arity `<= 2` under field deletions. |
| `4_priced_containers.md` | Prompt 4 | Fixes exact definitions of `container`, `priced`, `F1-frozen`, and `F2-frozen`, and tests whether priced containers are forced or needed only to break ties. |
| `4_frozen_checks.py` | Prompt 4 | Enumerates successors for small regimes under each unfreezing mechanism and tests unpriced versus priced containers. |
| `5_unrecognised_forcing.md` | Prompt 5 | Tests each `Supplied` row from `1_admission_ledger.md` for derivability from prior rows and identifies later theorems that render earlier admissions redundant. |
| `5_forcing_checks.py` | Prompt 5 | Checks finite derivability and countermodels for `Supplied` ledger admissions. |
| `6_minimal_chain.md` | Prompt 6 (Part A) | Assembles the shortest derivation chain from `<>` to `irreflexive R with R(a,b) gives a != b` and to the WDP admitted cut `(X, E, tau, K)`. |
| `7_adversary.md` | Prompt 6 (Part B) | Reruns all check scripts, attempts to falsify `Derived` and `Witnessed` claims from Tasks 1-5 and Part A, and audits unproved terms. |
| `8_open.md` | Prompt 6 (Part C) | Lists `OPEN` questions ordered by chain dependency weight and records the formal resolution of `OQ-01` through `OQ-08`. |
| `9_oq01_to_oq04.lean` | Post-Audit Settlement (`OQ-01`–`OQ-04`) | Self-contained Lean 4 proofs settling `OQ-04` (`mu2_unique_general`, `mu2_unique_F_general`), `OQ-03` (`oq03_retains_iff_four_conditions`), `OQ-01` (`subsingleton_image_no_irrefl_witness`), and `OQ-02` (`oq02_vortex_l1_defect_pos`) with zero `Classical.choice` and zero `sorry`. |
| `9_oq01_to_oq04_checks.py` | Post-Audit Settlement (`OQ-01`–`OQ-04`) | Reproducible Python stdlib verification for `OQ-01` through `OQ-04`. |
| `10_post_seal_inventory.md` | Campaign 1 (Post-Seal Audit) | Audits all post-seal modules in `A/lean4/Derivation/`, `A/research/`, and `B/wdp/`, testing deletions and countermodels and classifying each module as Drop, Merge, or Promote. |
| `10_post_seal_checks.py` | Campaign 1 (Post-Seal Audit) | Reproducible Python stdlib checks and deletion countermodels for `SymmetryFloor`, `NaturalSections`, `ObserverDescent`, `Erasure`/`Ext`/`Closure`, and post-seal dynamics. |
| `11_oq05_to_oq08.lean` | Campaign 2 (`OQ-05`–`OQ-08`) | Self-contained Lean 4 proofs settling `OQ-05` (`oq05_quotient_refinement_from_one`), `OQ-06` (`oq06_history_report_criterion_fin`), `OQ-07` (`oq07_weights_not_forced_without_symmetry`, `oq07_transitive_symmetry_forces_equal_weights`), and `OQ-08` (`oq08_refinement_commutes_at_zero_adm_ret_cost`) with zero `Classical.choice` and zero `sorry`. |
| `11_oq05_to_oq08_checks.py` | Campaign 2 (`OQ-05`–`OQ-08`) | Reproducible Python stdlib verification for `OQ-05` through `OQ-08`. |
| `12_post_seal_adversary_and_roadmap.md` | Campaign 3 Stage A | Red-team adversarial audit of Tasks 9–11 and `AGENTS.md`-compliant 5-slice reconstruction roadmap for `omega_codex/lean/`. |
| `13_slices_and_dag_verification.md` | Campaign 3 Stage B | Records the 5-slice Lean 4.33.0 implementation (`TorsorAndOperations` through `InternalMetatheory`, 227 total theorems across 8 modules), resolution of `RT-01`–`RT-12`, and verification of `dag/derivation_dag.json`. |

## Prompt Summaries (One Line per Prompt)

- **Prompt 0 (Shared rules):** Fix repository pins, claim tags (`Supplied`, `Derived`, `Witnessed`, `OPEN`), forcing criteria, and writing discipline for the audit.
- **Prompt 1 (Admission ledger):** Catalog all explicit, duplicate, and hidden admissions between `<>` and a witnessed difference across pre-Genesis, Genesis, and WDP.
- **Prompt 2 (The mark alone):** Determine what follows from `<>` with no operation, separate the seven foundational operations, and test minimal single additions and carrier swaps.
- **Prompt 3 (The five regime fields):** Test which Genesis results survive deleting or deriving each field of `R = (D, F, I, U, Q)` and count non-field capabilities.
- **Prompt 4 (Priced containers or frozen):** Distinguish `F1-frozen` (no successor forced) from `F2-frozen` (no successor possible) and test whether priced containers are required to move or only to break ties.
- **Prompt 5 (Forced but never recognised):** Test every `Supplied` admission in the ledger for derivability from earlier rows and identify redundant axioms.
- **Prompt 6 (Minimal chain and adversary):** Construct the minimal chain from `<>` to `a != b` and `(X, E, tau, K)` in a fresh session, rerun all scripts, attack prior claims, and rank open problems.
