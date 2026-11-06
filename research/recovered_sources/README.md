# Recovered Lean sources

These are reference copies for research, not imports into the Omega build and not an endorsement of their mathematical claims. Dependencies may be missing and versions may differ. No reconstruction or Lean build was attempted. SHA-256 hashes of the copied files are recorded in SHA256SUMS.txt.

## Archive sources

Repository: https://github.com/dbccpage/_anomalon_archive at commit `b3b67e3e3fda96a2827b071665c8d3516d846405`. Each source was fetched from `old/<UUID>.lean`; the matching `new/<UUID>-*.md` record identifies its original path.

| Copy | Archive UUID | Original path |
| --- | --- | --- |
| archive/shared_kernel/primitive_difference.lean | 316d03be-35e1-4e03-bdf6-0bed447174f9 | oe_master_librarian/.claude/worktrees/musing-taussig-5273ef/omega_engine/lean4/shared_kernel/primitive_difference.lean |
| archive/shared_kernel/shared_kernel.lean | 68fe4996-8981-4b80-97c9-27f207e44f51 | oe_master_librarian/.claude/worktrees/musing-taussig-5273ef/omega_engine/lean4/shared_kernel/shared_kernel.lean |
| archive/short_kernel/PrimitiveDifference.lean | 5c3e1504-514f-41a2-9c33-4d3482bdd584 | general_theory_of_finite_obstruction_calculus/032_Descent Law - Domain Applications/lean4/OmegaCore/PrimitiveDifference.lean |
| archive/native_hott/PrimitiveDifference.lean | 81905ab8-edbd-47bf-8444-d20e20190e09 | oe_master_librarian/.claude/worktrees/musing-taussig-5273ef/omega_engine/lean4/omega_engine_native_hott/PrimitiveDifference.lean |
| archive/core/core_l020_08_primitive_difference_bridge.lean | facd2d82-d4b2-4dda-8ffa-452c896f9839 | oe_master_librarian/lean4/core_l020_08_primitive_difference_bridge.lean |
| archive/core/core_l025_30_diagonal_shortcut_refusal.lean | 35d466e7-3a14-41b3-9fd8-097152b7ad2f | oe_master_librarian/lean4/core_l025_30_diagonal_shortcut_refusal.lean |
| archive/core/core_l025_39_epk_lift_gate.lean | 4034a20c-60a3-487e-a1bd-8ece13901a40 | oe_master_librarian/lean4/core_l025_39_epk_lift_gate.lean |
| archive/core/core_l025_41_primitive_spine_summary_gate.lean | 2639f9d7-8a83-48f1-a83e-9f557d8336ad | oe_master_librarian/lean4/core_l025_41_primitive_spine_summary_gate.lean |

## Local sources

All paths are under `C:/Users/a343o/source/repos/`. The revisions below identify the source checkout HEAD; they do not establish that each working file matches that revision. The copied-file hashes capture the actual bytes retrieved.

- `anomalon/`: from `anomalon/lean4/PrimitiveDifference.lean`, HEAD `f547317025169b5d3ae74ea554b2dd4a48024517`.
- `tfqm/`: from `theory_of_finite_quantum_mechanics/lean4/PrimitiveDifference.lean` and `lean4/Imported/LegacyTopLevel/` for the two files in `tfqm/legacy/`; HEAD `e45ed2e133920aa3790af8c5e072ee9829898490`.
- `19L57G1/`: from `19L57G1/research/higher_order_diagonalization/lean/Diagonalization.lean`, HEAD `45bb09864f9b52ed5ecf66e977ca81f0ed623de7`.
- `l1_native_cohomology/`: top-level Lean files and toolchain from `proposal_fidelity_protocol_pfp/papers/002_l1_native_cohomology/lean4/`, HEAD `505492e03cb8effb47b25103864b0a36282c393a`. The source's paper and its other files are not copied.

For the subsequent non-PFP Lean source scan and selected recovery, see [papers_lean_recovery/README.md](papers_lean_recovery/README.md). That scan records its exclusions, source-level dependency checks, duplicate checks, and remaining limits.
