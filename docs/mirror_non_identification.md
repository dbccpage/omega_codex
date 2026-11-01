# Mirror non-identification

This is the four-part slice approved by the user after the mirror-experiment assessment: construct the two models, establish identical accessible observations, prove the resulting non-identification theorem, and characterize a sufficient additional observation. It supersedes the earlier one-position proposal as the current slice; that proposal remains recorded and deferred.

The [Lean source](../lean/MirrorNonIdentification.lean) imports only the existing PrimitiveDifference module. The [finite code example](../scripts/mirror_models.py) independently enumerates the small observation interfaces and decoders. No source files were imported from the older Genesis repositories, and no historical evidence was modified.

## The two models and the observation interface

Both models use Bool as the same two-position presentation carrier. The labels false and true name positions in this encoding. The counterpart exchanges them. Both expose the same binary presentation relation: unequal positions return true and equal positions return false.

| Model | Referent carrier | Projection of the two presentations | Target answer to same referent |
|---|---|---|---|
| oneReferent | Unit | Both map to the sole value. | true |
| twoReferents | Bool | The projection is the identity. | false |

The full accessible relational observation is ordered as (false,false), (false,true), (true,false), (true,true). It is (false,true,true,false) in both models. The model tag and the projection are not inputs to the stipulated accessible interface.

This is a specified comparison class and observation boundary. The equality of observations is a property of that explicit model construction, not an empirical discovery about mirrors. No participant is assumed to be conscious, to have a perspective, or to recognize its own identity.

The target concerns the referents of the two presentations. It does not directly measure the total cardinality of an arbitrary larger reality. In these two stipulated models the projections cover their carriers, so the two assignments do instantiate one versus two referents.

## Result 1 and result 2

`one_referent_assignment`, `two_referent_assignment`, and `identity_answer_correct` bind the Boolean target to the actual projection equalities. The target is not an unexplained label attached to the models.

`same_accessible_relation` and `identical_observations` prove equality of the complete relational observations. `accessible_swap_invariant` preserves the earlier participant symmetry, while `target_answer_has_no_preferred_presentation` shows that swapping the presentation roles does not alter the equality question.

## Result 3

`mirror_non_identification` states:

```text
There is no f : Observation → Bool such that
f(observe(m)) = identityAnswer(m) for both admitted models m.
```

The reason is exact: the two inputs to f are equal, while the required outputs differ. The theorem concerns deterministic total functions whose only input is this observation. It does not quantify over unspecified additional interactions, randomized success criteria, or a broader model class.

`presentation_difference_does_not_descend` also proves that no Boolean function of the shared-referent projection pair can reproduce presentation difference on all presentation pairs. The diagonal pair and an off-diagonal pair project to the same referent pair but have different presentation answers.

A shared referent is not declared an unlawful representation. The earlier collapse obstruction applies only when the pushed-forward relation is required to preserve irreflexivity. Here the original presentation relation remains on the presentation carrier. No irreflexive referent-level relation is required.

## Result 4

For an observation interface o, define:

- `Decodes o`: a Boolean decoder of o answers the target correctly for both models.
- `FiberConstant o`: whenever two admitted models have the same observation, they have the same target answer.

`decoding_requires_fiber_constancy` establishes necessity without requiring decidable observation equality.

For the constructive converse, `decodes_iff_fiber_constant` explicitly assumes `DecidableEq` on observation values. The supplied decoder tests whether its input equals the one-referent model's observation. In this two-model task, that test answers correctly exactly when the observations separate the two target answers.

The extra-observation interface is `enhanced C m = (observe m, C m)`. Under the stated decidability assumption:

```text
Decodes (enhanced C)
if and only if
C(oneReferent) ≠ C(twoReferents).
```

This is `extra_observation_completion`. A Boolean channel satisfies the required decidability assumption. A constant extra channel fails. Supplying the target bit itself succeeds, but `target_bit_extra_suffices` is deliberately an oracle-like sufficiency example. It does not construct a mechanism that obtains that bit.

## Finite enumeration

Run:

```text
python scripts/mirror_models.py
python -m unittest discover -s tests -v
```

The code enumerates Boolean decoders on reachable observation values only. The external grading harness uses model tags and hidden projections to assess correctness; those values are not inputs to the decoders being tested. The base interface has one reachable value and two such decoders; neither answers both models correctly.

| Extra values for oneReferent and twoReferents | Reachable combined observations | Decoders examined | Correct decoders |
|---|---|---|---|
| false, false | 1 | 2 | 0 |
| false, true | 2 | 4 | 1 |
| true, false | 2 | 4 | 1 |
| true, true | 1 | 2 | 0 |

This exhausts the four Boolean extra channels for the two-model comparison. It does not enumerate arbitrary physical interactions or prove that any channel is internally available. The separate Lean theorem supplies the quantified result under its explicit assumptions.

## Assumptions and remaining question

The slice admits a two-position presentation carrier, two referent-assignment models, a fixed accessible relational table, a Boolean target encoding, and a class of deterministic decoders. The constructive completion proof further admits decidable observation equality. An extra channel is supplied as mathematical data.

Neither the relation nor the non-identification theorem generates an additional observation, an internal register, a history, or a performed act. The mirror apparatus, zero-to-one appearance story, four-step lifts, and physical spin interpretation remain outside this approved slice.

The next discussion concerns what permitted interaction could supply a distinguishing extra observation, and what would justify treating its result as internally obtained. No such interaction is implemented here.

## Verification

```text
lake build
python scripts/check_primitive_difference.py
python scripts/check_primitive_difference.py --module MirrorNonIdentification
python scripts/verify_genesis_record.py
python -m unittest discover -s tests -v
```

The new module has 19 checked theorems. Its core impossibility and non-descent results require no axioms; five constructive completion-related proofs depend on Lean's standard `propext`. There are no proof placeholders, custom axioms, or native decision shortcuts.

The [new source-bound receipt](mirror_non_identification_verification.json) records its exact source SHA-256, the imported PrimitiveDifference source hash, Lean toolchain, and dependency census. The checker builds the selected module and its dependencies before checking the census, so it does not rely on a stale imported build. The earlier PrimitiveDifference source and its 26-theorem receipt remain unchanged. CI builds both modules and repeats both censuses.
