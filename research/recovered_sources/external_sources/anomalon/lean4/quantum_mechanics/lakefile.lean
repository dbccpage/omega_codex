import Lake
open Lake DSL

-- C750 block 01 real logarithm and algebraic-number reductions.
-- AuthorityEffect: None. Baker remains an explicit cited hypothesis.
require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "56a005855ea17e0b0958f73ec801ae140b0a1679"

package «FiniteQuantum» where
  version := v!"0.1.0"
  buildDir := "b"

@[default_target]
lean_lib «FiniteQuantum» where
  srcDir := "."
  roots := #[
    `DerivationDagQMClosure,
    `C750Definitions,
    `C750Reduction,
    `C750Purity,
    `C750AxiomCensus
  ]
