# S(n) / MSS-N recovery target

## Author clarification, November 6, 2026

Jeremy describes the original programme as follows: fix a glyph vocabulary and
its grammar; encounter an obstruction that the current resources cannot build
the required structure to resolve; lift by extending the grammar or symbols.
MSS-N asks for the minimum expressive resources needed for that task. He recalls
early simplex/horn/missing-face obstructions, later L1/Born-Hilbert work, and
an intended invariant across an uplift and forgetful map. These are recovery
targets and recollections, not claims newly proved by this review.

The target is therefore an obstruction-driven extension procedure, not a
numbered list of mathematical subjects. Recovery should identify the actual
failure witness, permitted responses, cost, and preserved questions at each
transition. Do not substitute a supplied numerical schedule for that procedure.

## Sources inspected

Local TFQM paths supplied by Jeremy:

- `education/2_symmetric_group_presentations`
- `education/3_minimal_symbol_systems`

Read the two READMEs, S(n) source correspondence and sn.md, the S(n) Python core,
Lean carrier definitions and theorem inventory, minimum observation refinement
example E10, the MSS alphabet/encoding note, and sections of the combined
`pregenesis_to_minimal_symbol_systems` paper and source reader.

These numbered directories are untracked in the inspected checkout. Do not
attribute their current bytes to HEAD `e45ed2e133920aa3790af8c5e072ee9829898490`.
The tracked S(n) path is `education/symmetric_group_presentations/sn.md`.
Its available follow-history leads to `c7db46071` (October 26 naming migration)
and `c2e4de471` (October 26 import from the_symbol_game). Those are provenance
leads, not April/May experiment dates.

The local source reader names the_symbol_game revision
`d1d2f034198a72b730320a69691e63351557c019` for historical imports. Its referenced
`manifests/imported_sources.json` is absent at the inspected local package path;
that receipt has not been verified here.

## What survives usefully

1. **Demand bookkeeping:** sn.md defines active demands W, discharged demands D,
   births B and the update W'=(W minus D) disjoint-union B. This accounts for
   changes after D and B are known. It does not generate them.
2. **Recoverable extensions:** the Python example embeds x as (x,0) and refuses
   descent when the new coordinate is nonzero. Lean's old_image_base covers
   every admitted BasePresentation; SnOffImage supplies the exact image/refusal
   characterization. These are candidate ingredients for preservation, not a
   general invariant of every proposed lift.
3. **Task-relative minimum:** E10 takes three collapsed marks and all three
   pair-separation demands. It requires three tag values or two binary
   coordinates in its declared response class. This makes a useful distinction
   between endpoint count, tag count and coordinate cost.
4. **Countable encoding:** the MSS alphabet note gives the code x_k -> 1^k0.
   It shows why raw alphabet size alone cannot measure all expressive growth:
   a fixed alphabet can carry additional distinctions through longer expressions
   and a declared decoder. Grammar, operations, interpretation and cost must
   remain explicit in any recovered minimum claim.

## What these versions do not recover

The Python core supplies s_n and cost_floor fields. SnCarrier supplies its
cardinality, active-obstruction and cumulative-history tables. Their stated
numbers are therefore not output of an obstruction-driven search. The current
MSS README calls its 101 rows capability specifications, with no demonstrated
licensed sequence between all rows. These later representations do not settle
what the original experiment did.

The targeted non-domain source search did not locate the -1/i delta sweep,
1024 consensus stopping condition, or a Dirichlet survivor experiment.
This was not an exhaustive audit of every domain or historical revision.

## Next discussion slice, not implemented

Recover one existing transition with all five components:

- the current vocabulary, grammar and interpretation;
- a concrete obstruction and the requirement it prevents;
- the allowed extension class and explicit cost;
- the successful lift and the failure of cheaper admissible responses;
- the return map and precisely which old observations or operations it preserves.

Then recover the iteration rule that creates or detects the next demand. That
rule is needed before witness growth, slowdown, collapse or a 1024 cutoff can be
meaningfully replayed. A recovered original run must remain distinct from a
new experiment implementing a newly agreed rule.

No new mathematics, experiment, dependency installation or legacy build was
performed. TFQM files were not changed. This note lives only in Omega Codex.
