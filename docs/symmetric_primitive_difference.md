# Symmetric difference without a preferred participant

The symmetric two-position relation supports a distinction while leaving the identities of its participants interchangeable. A swap-invariant binary observation can distinguish a related pair from a self-pair, even though a swap-invariant unary Boolean classifier cannot label the participants differently. Neither theorem supplies a physically executing observer.

The self-contained [Lean module](../lean/PrimitiveDifference.lean) checks these statements using Lean core. It imports neither Regime nor the older Genesis project. Bool presents two positions; its false/true names have no privileged structural role.

## Source and correction

This investigation follows the user's pasted assessment of the earlier Primitive Difference work. The earlier sources were inspected at [19L57G1 commit 45bb09864f9b52ed5ecf66e977ca81f0ed623de7](https://github.com/dbccpage/19L57G1/commit/45bb09864f9b52ed5ecf66e977ca81f0ed623de7), with no local changes in the two inspected files:

- [PrimDiff.lean](https://github.com/dbccpage/19L57G1/blob/45bb09864f9b52ed5ecf66e977ca81f0ed623de7/lean4/Derivation/PrimDiff.lean), local SHA-256 `a2fd261439d70c2522ea4419029865870745df07ce2a1532cedde7c45a36890b`.
- [Companion paper](https://github.com/dbccpage/19L57G1/blob/45bb09864f9b52ed5ecf66e977ca81f0ed623de7/paper/primitive_difference.md), local SHA-256 `bcf0ebcc488eb6944bc7a9655a80a94b603880a87775fa19ec1115a5243dd65c`.

The earlier theorem `symmetric_no_equivariant_classifier` is correct. Its broad “no definable observer” comment must be restricted to invariant unary side-labeling with a trivially acted-on Boolean output. It does not exclude invariant binary distinctions or equivariant outputs that themselves transform. The old files and historical experiment remain unchanged; the corrected statement and extensions live here.

The new relation `S2 x y := x ≠ y` is extensionally the earlier symmetric relation on Bool. `S2_legacy_reading` proves that crosswalk.

## Four checked results

| Result | What is established | What remains outside the claim |
|---|---|---|
| Invariant relational difference | `difference x y` is Boolean XOR, is true exactly on S2, is nonconstant on pairs, and is unchanged by swapping both inputs. | No unary participant is given a preferred name. A binary query and its decidable evaluator are explicitly supplied. |
| Counterpart | The unique related participant is `counterpart x = not x`; applying it twice restores x, and it has no fixed participant. Every S2-preserving-and-reflecting endomap commutes with it. | This is a two-position result. A larger symmetric irreflexive relation need not have a unique counterpart. |
| Universal soundness | For every relation on any admitted type, irreflexivity is equivalent to every related pair having unequal endpoints. A predicate on relations guarantees universal soundness exactly when it entails irreflexivity. | A single designated pair can be distinct while loops exist elsewhere. Local soundness does not force global irreflexivity. No syntactic axiom grammar has been enumerated. |
| Obstruction and refusal | Identifying a witnessed pair puts a loop into its pushed-forward relation, violating preserved irreflexivity. A separately specified detector can record a correct rejection bit. | The obstruction does not force a detector, invocation, register, response policy, or physical refusal to exist. |

The generic equivalence settles F3's universal semantic soundness content directly. It does not settle a separately chosen syntax, proof complexity, finite axiom enumeration, or weaker guarantees restricted to designated pairs. The new `local_pair_does_not_force_irrefl` supplies an explicit counterexample to transferring a local guarantee globally.

## How the distinction survives the swap

There are four ordered input pairs:

| Pair | Relational difference |
|---|---|
| false, false | false |
| false, true | true |
| true, false | true |
| true, true | false |

Swapping both participants exchanges the first and last rows and exchanges the middle two rows. Outputs remain unchanged. The predicate distinguishes the diagonal from the off-diagonal; it does not choose one endpoint as alpha or omega.

The unary theorem concerns `f(not x) = f(x)`. The binary theorem concerns `D(not x, not y) = D(x,y)`. These have different input roles. The identity classifier also gives a nonconstant equivariant example if its output is swapped along with its input; it would not satisfy the unary invariance requirement.

## What an operational extension adds

The structural model includes two positions, a binary relation, an admitted related pair, and the no-loop law. Symmetry permits exchange without privileged orientation. Types, equality, and the formal logic are admitted mathematical apparatus. None is extracted from the opaque inscription.

The refusal example additionally supplies:

1. A candidate interface: a map from the two positions to themselves.
2. A decidable test of whether the images coincide.
3. An internal Boolean flag.
4. An update rule that writes the test result into that flag.
5. Invocation of that update and access to the resulting flag.

These roles are not claimed to require five separate mechanisms. For an immediate branch, a separate stored flag may be unnecessary. Here the flag models a recorded response; no persistence through a later change is proved.

For identity or exchange, the detector accepts. For either constant map, it rejects. Re-labeling the input or output positions does not change the rejection decision. `registered_refusal_correct` proves the stated update records exactly the collapse test. This remains a formal transition specification, not a claim that relation alone performs an act.

The same static S2 can be extended with a policy that always records no refusal. This does not make the prohibited collapse lawful: it demonstrates that the static law does not determine a response policy. The example does not execute an illegal collapse or claim to preserve the law after doing so.

This separates three things we can now discuss precisely: a supported relation, an obstruction to identifying its participants, and an explicitly added registered response. Whether the first deserves the name “self-witnessing” is still a proposed criterion, not a theorem about existence or awareness.

## Verification

The toolchain is pinned in [lean-toolchain](../lean-toolchain). Run:

```text
python scripts/check_primitive_difference.py
```

The checker compiles the complete module and obtains an axiom report for every theorem. It rejects proof placeholders, native decision shortcuts, and dependencies outside the declared allowlist. The generic soundness and central symmetry/counterpart results need no axioms; some simplifier proofs use Lean's standard propositional extensionality axiom `propext`. No custom axioms are introduced.

All 26 theorem declarations passed the local census. The [local verification receipt](primitive_difference_verification.json) binds the theorem census to the module's exact source SHA-256 and toolchain. CI repeats the check on the pushed revision. The archived seed experiment keeps its own independent verifier and manifests.
