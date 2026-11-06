# First working slice: admitted moves and replay

Implemented the first slice of the [finite reconstruction plan](2026-11-06-mark-to-cosmos-plan.md). Omega's existing `Item4` execution now has a proved connection to WDP's typed histories, including refusal. The executable walk begins with literal supply, executes datum admissions, displays the supplied requirement, and checks both unary separation alternatives in both readings.

## The concrete walk

Reading L gives the following run. Reading F also retains the initial datum and separates indices 1 and 2.

| Operation | Admitted data | Forms | Instances | Result |
| --- | ---: | --- | --- | --- |
| Start | 0 | none | none | Empty admitted regime |
| Supply `<>` | 0 | none | none | Presentation retained; state unchanged |
| Two datum admissions | 2 | none | none | No distinguishing context |
| Supply requirement `(0,1)` | 2 | none | none | Requirement recorded at an explicit initialization boundary |
| Declare unary form | 2 | arity 1 | none | Still no separation |
| Assert it at datum 0 | 2 | arity 1 | `form 0 [0]` | Data 0 and 1 separated |
| Repeat that assertion | 2 | arity 1 | same instance | Same endpoint, an additional history occurrence |

The successful response costs two items and one unit of new-form arity under the declared prices. Asserting at datum 1 instead also succeeds. The adapter retains both labeled alternatives. Reversing declaration and assertion refuses at the first event.

`Item4` remains unchanged: datum, form and instance admissions. `PresentedEvent` explicitly wraps it with opaque supply bookkeeping. Requirement initialization is a separate supplied operation, not an invented `Item4` constructor. These distinctions are visible in the computed trace.

## What the proof establishes

[AdmissionReplay.lean](../../lean/AdmissionReplay.lean) contains 25 checked theorems. The principal statements are:

- `replay_eq_applyDelta`: for every Omega regime and finite item list, WDP partial replay equals Omega's `applyDelta4`.
- `accepted_iff_history`: execution reaches a specified endpoint exactly when a typed history with precisely that event list exists.
- `refusal_iff_no_history`: execution returns `none` exactly when no such successful typed history exists.
- `composed_events` and `composed_cost`: typed composition concatenates the ordered events and adds any supplied natural-number event prices.
- `endpoint_question`: replay preserves any chosen question of the exact final regime. `history_keeps_separation` specializes this to a supplied final separation; it does not assert that every move preserves initial separations.
- `literal_prefix_replay`, `rooted_accepted_history` and `rooted_refusal`: the explicit inert supply wrapper retains the literal root in the history and preserves the continuation's success or refusal.
- Concrete statements check both readings, both marked responses, malformed admissions, different occurrence costs at an equal endpoint, and successful duplicate versus refusal.
- `fresh_response_has_history` reuses the existing fresh-unary execution theorem to obtain its typed history.

The census reports only `propext` and `Quot.sound`, with one of the 25 declarations axiom-free. No `Classical.choice`, added axiom or proof placeholder appears in the adapter's dependency reports. The [verification record](2026-11-06-admission-replay-verification.json) records each theorem separately and hashes the complete local import closure used by the check.

Two small WDP core modules were reused without byte changes, with their original namespaces: `GenerativeHistoryCompression` and `GenesisConstruction`. The [custody record](2026-11-06-admission-replay-source-custody.json) binds them to TFQM commit `1a7263e924accae0e114ab258b1747a84f693080` and their Git blobs. They compile under Omega's pinned Lean 4.33.0.

## Executed checks

| Check | Actual result |
| --- | --- |
| Scoped `lake build AdmissionReplay` | Passed |
| Complete adapter theorem census | 25 declarations checked |
| Actual Lean replay versus independent Python transition/context oracle | 365 cases: 97 accepted, 268 refused |
| Corpus | Five explicit starting regimes; all words of length 0–2 over eight explicit events |
| Targeted walks | 13 examples and two admission prefixes passed |
| Corrupted report controls | Five rejected: event order, argument, refusal-as-idle, retained report, occurrence price |
| Actual Lean negative controls | Six baseline claims compiled; six false variants failed with `decide` diagnostics |
| New live-replay unittest module | Four tests passed, including missing and duplicated coverage controls |
| Existing OQ-05 refinement tests | Five tests passed |
| Independent finite checks under Python `-O` | Same cases and mutation controls passed |

The [raw walk](2026-11-06-admission-replay-run.json) comes from executing the Lean functions. The Python oracle separately enumerates accepting contexts and verifies exact states, refusals, ordered attempts, prices and separation reports. Failed attempts stop that trace at the first refusal; proposed-list prices are explicitly labeled and are not charged as performed successful work.

The old-form re-collapse remains observable: on the three-datum example, adding an instance of the existing form at datum 2 loses separation of `(0,2)`. The fresh-form response keeps the old separations and adds `(1,2)`. Duplicate assertion also remains observable in history and price despite leaving the stored instance set unchanged.

## Reproduce

From Omega, using its Python environment:

```powershell
lake build AdmissionReplay
.\.venv\Scripts\python.exe scripts/check_admission_replay.py
.\.venv\Scripts\python.exe -m unittest discover -s tests -p test_admission_replay.py -v
```

To save fresh artifacts, pass `--report PATH --walk PATH` to the checker. On this sandbox's Windows host, the default temporary directory denied access; the successful census/control run used `TEMP` and `TMP` pointing to `.lake/admission-replay-tmp`. This was an environment rerun, with the proof statements unchanged.

The Lean CI job now invokes the scoped checker and live tests. The offline job skips live replay tests when Lake is unavailable. Hosted CI has not been run in this local task. The new target is explicit rather than added to the shared default target list. The actively edited DAG and existing historical receipts were not rewritten; this report records the slice pending its next review.

## Boundary and next discussion

This closes the particular Omega execution-to-WDP-history correspondence. It does not establish correspondence with the separate Rust primitive engine, manufacture the initial admissions or requirement, choose a tied response, or generate its own next demand. The presentation wrapper's inert supply law is declared.

The next proposed slice is the plan's retention/continuation connection: use these actual histories to preserve selected old questions through the existing refinement and projection operations, retaining the re-collapse case as a control. That slice remains for discussion. The current work adds no feedback engine, cochain stage or new quantum construction.

Concurrent changes elsewhere in the checkout were left untouched. The scoped changed-file whitespace check passed; a whole-checkout check reported trailing blank lines in other ongoing files. No commit, push or merge was performed.
