# TFQM proof review: growth, demand, and lift exhaustion

Status: **partial**. Four top-level Lean modules were read in full at the working-tree hashes in `tfqm_lean_inventory.json`. Lean compilation and axiom reports were not rerun. Source root: `C:/Users/a343o/source/repos/theory_of_finite_quantum_mechanics/lean4`.

## Scope gap: an exhaustion receipt checks its supplied list

`WorldLiftExhaustion.lean` defines `Exhausted score applyMove moves state` as non-improvement for each move **in the supplied list**. `ExhaustionReceipt` supplies that list and a proof for its members; it does not contain a proof that the list covers `source.Repair`. An empty list satisfies the condition vacuously. For example, with state 1, natural-number score equal to the state and a move taking every state to 0, the empty list is exhausted in this definition although that unlisted move improves the score.

`VerifiedOneGeneratorLift` includes a real embedding/retraction equation, a repair-type bijection with one added element, and preservation fields. Its `resolvesSurvivor` and `removalRestoresSurvivor` fields are arbitrary supplied propositions accompanied by proofs. `generator_is_minimal` returns the latter supplied proof; the type does not define that proposition in terms of the selected generator or a cost comparison. These statements can serve as conditional contracts, but the name alone does not establish a global search or semantic minimality.

## Per-module results and boundaries

| Module | Assumptions and actual result | Boundary |
| --- | --- | --- |
| `WorldLiftExhaustion.lean` | A supplied score, transition, move list, and proof of no decrease on that list; a lift package additionally supplies typed maps, round trips, and preservation proofs. `preserves_zero_rel` follows from its supplied delta and zero-preservation fields. | No list-completeness condition; the two survivor/minimality propositions are unconstrained fields. The empty-list example above is a counterexample to interpreting list-relative exhaustion as exhaustion of every repair. |
| `WdpGrowthNoRepair.lean` | Finite rational indexed windows, compatible restriction maps, matched cochains, monotone/nonnegative weights, and attained minima (`IsPhi`). Under these hypotheses the restricted weighted-L1 defect cannot exceed the larger one. With a closed complex, the degree-two charge is invariant under the specified repairs. | Attainment and compatibility are hypotheses. Adding a two-cell preserves the defect by definition because the definition reads no two-cell row. The file gives counterexamples when operator compatibility or the weight inequality is dropped, and a norm not monotone under coordinate deletion. It does not prove arbitrary-norm monotonicity or existence of minima. Its header also correctly distinguishes older list-sum theorems from a quotient-minimum theorem. |
| `DemandAccounting.lean` | Finite active, discharged and born sets. The exact integer cardinality formula accounts for overlap; the simpler `s-d+b` identity follows under discharge subset and survivor/birth disjointness. The file also proves an exact iff, gives violation counterexamples, and shows every pair of counts can be realized by an admissible accounting step. | Counts alone do not determine a dynamic law or a unique discharge/birth split. Natural-number truncated subtraction can conceal a subset violation. List lengths count duplicates and are not equivalent to set cardinality. |
| `GenesisDemandPolicy.lean` | A supplied regime, finite enumeration of contexts, collapse test, and a controller whose policy is either halt or separate-all. For a selected pair, `seek` records an existing source `impose` event; the two policies differ on the same two-datum regime. | The policy, ordering, language extension and original regime machinery are supplied. Recording a demand preserves the existing observations; the code does not itself produce a separating observation. The finite two-datum saturation example is not unbounded self-sustaining growth. |

## Independent finite checks

Python enumeration checked the exact integer demand-accounting formula and its iff condition for all 512 triples of subsets of a three-element universe. A separate check evaluated the empty-list exhaustion counterexample. These are bounded checks of manually translated definitions, not Lean compilation or proof mutation.

The earlier audit of the 14-module repair/lift chain is `tfqm-proof-review-repair-lift.md`; the finite fiber and triangle review is `tfqm-proof-review-fibers-l1.md`. No new byte-duplicate or semantic-equivalence claim is made for these four modules.
