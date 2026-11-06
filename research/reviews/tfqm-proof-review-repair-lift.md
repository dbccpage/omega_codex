# TFQM proof-level review: repair and lift pipeline

Status: **partial**. This report covers the 14 named TFQM top-level files below, read at the working-tree hashes in `tfqm_lean_inventory.json`. It does not close the remainder of the 769 top-level modules or the wider requested corpus. Statements and proofs were inspected as text; Lean was not run, and axiom dependencies were not rechecked. Source root: `C:/Users/a343o/source/repos/theory_of_finite_quantum_mechanics/lean4`.

## Findings

### 1. A reported certificate is not tied to a repair certificate

`PrimitiveTerminalPacket.lean:14-32` accepts `boundary : RepairBoundaryStatus` and `hasCertificate : Bool` independently; `packetFor` lets the caller supply both. `PacketRepaired` at line 39 is exactly the conjunction `boundary = repaired` and `hasCertificate = true`. There is no repair system, zero class, actual `RepairCertificate`, or soundness equation for the flag in `TerminalPacket`.

Concrete counterexample by the definitions: let `Q = Unit`, let `Phi` and `Gamma` both be constantly 1, choose `q = ()`, set the packet boundary to `repaired` and its flag to `true`, and take an independently supplied repair system whose admissibility predicate is always `False`. The classifier status is `openObstruction` and the packet satisfies `PacketRepaired`, while `PrimitiveRepairCertificate.no_certificate_under_certificate_empty_system` rules out an actual certificate for that empty system. The packet type does not bind any system, so this does not contradict a theorem requiring such a binding: it shows that the binding is absent.

`PrimitiveSpineSummary.lean` carries the same terminal packet. `SpineSummaryWithCertificate` separately stores a real certificate, but does not equate the packet flag with its existence. `OntologyPrimitiveBridge.lean:27-40` uses the flag in a downstream status mapping; additional descent hypotheses are still needed for its authority predicate. These are formal status transitions, not evidence of a performed repair.

`PacketTerminal` is defined as `True`; `PacketReady` is defined as repaired OR blocked. Thus “terminal” and “ready” have the file's declared administrative meanings. `packet_ready_iff_blocked_or_repaired` is a rearrangement of that definition, not proof a repair succeeded.

### 2. Lift and checklist labels do not validate their evidence

`PrimitiveLiftCandidate.lean:47-61` represents source obstruction, new carrier, replay, reduction and closure by five independent Booleans. `IsLicensedLiftCandidate` requires all five to be true; no field carries a carrier, transition, replay, or residual comparison. `PrimitiveLiftCertificate.lean:8-22` replaces those flags with five caller-supplied propositions and their proofs; unless the propositions are tied to concrete objects, even `True` can fill each slot. Its `licensed_boolean_candidate_is_not_certificate` correctly shows that a licensed Boolean candidate does not supply a certificate for an arbitrarily chosen evidence record. It does not establish a real lift from the Boolean flags.

`PrimitiveLiftCandidate.lean:205-213` defines the result of adjoining a repair generator with `phi_after = 0` and proves that value is zero by reflexivity. The definition is a supplied output, not a derivation that an admissible generator exists or has been executed.

`PregenesisLiftChecklist.lean:68-120` stores checklist flags and counts. A record with all flags true, one admissible repair, nine tied minima and `ExhaustiveOnDeclaredDomain 1` satisfies `allSixChecksClosed`: there is no field requiring the nine minima to fit the one-element domain. Likewise, `exhaustive_vs_budget_stopped_triangle_obstruction` checks a prefilled record; that declaration does not itself enumerate K3 colorings. By contrast, `uninspected_tail_witness_refutes_budget_stop_claims` does provide a concrete four-element cost/repair example.

The boundary classifier in `PrimitiveRepairBoundary.lean` also takes four Booleans as input. Its case analysis correctly states how those inputs route to statuses, but no theorem in that file establishes that the inputs accurately describe an actual policy, budget, rule or witness. It routes a missing rule and a missing witness to the same `noRule` status.

## Per-module assumptions and results

| Module | Supplied assumptions and meaningful result | Remaining boundary |
| --- | --- | --- |
| `PrimitiveDifferenceBridge` | A type, question functions, retained/protected predicates and endpoints. If equal old profiles are separated by a supplied target, that target cannot factor through the old quotient. | The predicates, separator and refinement are supplied; `StrictSplit` includes the split it reports. No observer is constructed from difference. |
| `PointedObstructionClassifier` | A type and two natural-number readouts. Case analysis yields three mutually exclusive named cases. | `exactRepair` is defined as `Phi = 0`; it does not mean a repair was performed. The classifier functions need not be adequate. |
| `PrimitiveObstructionPipeline` | A pointed difference package, raw readouts and congruence proofs. Readouts descend and agree on quotient classes; a noncongruent readout has no such factorization. | Congruence and readouts are inputs; the classification does not produce their physical interpretation. |
| `PrimitiveRepairWitness` | A pointed quotient, classifier and supplied repair map. A witness amounts to a supplied result equal to both the map output and the zero class. Its Boolean example has exact status but no witness for identity repair. | This is a mathematical witness of an equality, not a record of an executed operation. |
| `PrimitiveAdmissibleRepair` | An arbitrary predicate on maps, an admissible map and an equality to zero. The witness implies an ordinary repair witness. | Admissibility is supplied; blocking the constant-zero map does not establish all other maps are meaningful or executed. |
| `PrimitiveRepairCertificate` | Exact classifier status and an admissible repair witness are fields. Projections give those fields back; an empty admissible system gives an exact-status/no-certificate counterexample when exact status is supplied. | A certificate is meaningful only relative to the chosen classifier, admissibility predicate and zero class; it is separate from the packet Boolean. |
| `PrimitiveRepairBoundary` | Four Boolean reports. Exhaustive case splits prove the stated routing and exclusion facts. | The input reports are not linked to witnesses or costs; `noRule` conflates absent rule and absent witness. |
| `PrimitiveTerminalPacket` | A classifier, state, status equality, arbitrary boundary and certificate flag. It proves status and Boolean-routing identities. | See finding 1; no semantic certificate binding, and terminality is `True`. |
| `PrimitiveLiftCandidate` | Five Boolean reports and an independently defined lexicographic comparison. The comparison is proved irreflexive and transitive, and rejected rollback retains prior values. | The candidate flags and adjoined-generator result are not evidence of the corresponding operations. |
| `PrimitiveLiftCertificate` | Five arbitrary propositions with supplied proofs. Field projections and conversion to five true flags follow. | Evidence propositions are not intrinsically tied to a concrete system, nor is a Boolean candidate sufficient for a certificate. |
| `PrimitiveSpineSummary` | Supplied pointed difference, classifier, repair system, packet, candidate and optionally an actual certificate. It restates quotient criteria and projects certificate fields. | The optional certificate and the packet's Boolean flag are independent; no universal growth or forced lift is proved. |
| `PregenesisLiftChecklist` | A record of flags, counts and a declared census state; explicit finite tail example and separately imported obstruction/refinement results. | Record labels do not verify the census, costs or count consistency; the triangle-record theorem checks a prefilled record. |
| `ReportFiberDescent` | Supplied report and decision functions. A unique decoder on the report's image exists exactly when the decision is constant on report fibers; postprocessing cannot separate an already-collapsed pair. | The decoder proof explicitly uses `Classical.choose`. The joint-report sufficiency construction supplies the decision as part of the report; it does not discover that information. |
| `PregenesisPresentationLift` | An explicitly two-element inscription type and a constant empty observation map. It exhibits distinct inscriptions with the same image and contrasts two declared equivalence conventions. | The collapsed observation is built into `emptyDistinctions`, and the paper's own header calls the outcome conditional. This does not derive an observation map or mark from a primitive. |

## Checks and duplicate scope

An independent Python calculation enumerated the 16 combinations of boundary input flags: only the all-true combination routes to `repaired`, while both a missing rule and an absent witness can route to `noRule`. It also evaluated the open-status/true-certificate-flag example and the one-element/nine-minima record above. These calculations manually translate the displayed definitions; they are not a Lean build, theorem mutation, or proof of equivalence to the implementation.

Prior exact-byte and import-wrapper comparisons are recorded in `tfqm-review-progress.md`; no new semantic duplicate equivalence was established for these 14 files. The prior 205 import-wrapper matches omit import lines, so changed dependencies remain a separate concern.
