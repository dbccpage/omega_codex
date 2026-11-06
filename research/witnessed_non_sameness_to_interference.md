# A route from witnessed non-sameness to finite interference

**Status: research map, not a completed derivation.** This route connects existing results by their mathematical form and exposes the missing bridges. It does not claim that witnessed non-sameness has been shown to force a carrier, a projection, a cochain complex, a quantum state, or a physical universe.

Read the arrows as: “the next construction is a candidate continuation, with the following new inputs.” An arrow marked **OPEN** is not a proved implication. A source saying `PROVED_LEAN` or `LANDED_CONDITIONAL` reports its own evidence status; this map did not rebuild its code or verify the full dependency chain.

## The route at a glance

| Step | What we have | What is supplied or still owed |
| --- | --- | --- |
| 0. Starting commitment | Witnessed non-sameness, as one admission. | Its mathematical representation and any consequences are open. |
| 1. Represented difference | Conditional examples of a relation, a related pair, and sometimes irreflexivity. | Types, equality, relation, inhabitance and any laws are supplied. **OPEN:** why this represents step 0 faithfully. |
| 2. A specified presentation | A report map creates fibers of things with the same report. | A carrier, report and equality on reports are supplied. **OPEN:** acquiring or justifying that report from step 0 or 1. |
| 3. Obstruction | If a required target differs within a single report fiber, it cannot be computed from that report alone. | The target and the requirement to recover it are supplied. **OPEN:** why this target must be available internally or at all. |
| 4. Structure or repair | A finer report can preserve an old report while separating a specified pair; other examples use sections, transitions, or enlarged grammars. | Refinement, access and a rule for using it must be supplied or proved. **OPEN:** why a response occurs and whether it must be a lift. |
| 5. Optional cochain/L1 branch | On declared finite windows, nonzero residuals and exact integer-triangle L1 bounds can be studied. | Incidence, coefficients, coboundaries, weights, costs and relevant minimization assumptions are extra. **OPEN:** derive or justify them from the earlier steps. This branch is not a premise of the finite interference calculation below. |
| 6. Finite interference example | Two supplied amplitude vectors have identical phase-blind weights and distinct weights after a supplied mixer. Consequently, the latter weights do not factor through the former. | The amplitude arithmetic, quadratic report and mixing operation are supplied. **OPEN:** derive them and their physical interpretation from earlier stages. |

## 0. What is admitted

The starting commitment is **witnessed non-sameness**, with witnessing belonging to the admission rather than to a separately supplied witness. Neither role is given an independent identity. We do not infer two objects, a clock, spatial separation, an observer, a transition, or a carrier from this wording. The meaning of “non-sameness” and whether it can be expressed without relying on a sameness comparator remain questions.

The older inscription `<>` is historical notation, not an automatic source of the proposed admission. The TFQM source record [TFQ-0392](</C:/Users/a343o/source/repos/theory_of_finite_quantum_mechanics/dag/derivations/01_pregenesis/tfq_0392_inscription_to_coproduct_gap.md>) records a gap between an inert inscription and a separately admitted difference/structure root. This user's current proposal is not a claim that the inscription itself contains or produces that root.

**Bridge A — OPEN:** exhibit a representation that preserves the intended content of witnessed non-sameness; distinguish what the formal host uses from what the represented account itself requires. We currently have candidates and tests, not a derivation that selects one.

## 1. First representable distinction

The Omega theorem [irrefl_witness_ne](</C:/Users/a343o/source/repos/omega_codex/lean/PrimitiveDifference.lean:19>) takes a type, a binary relation, a proof of a related pair, and irreflexivity. It concludes the endpoints are unequal. Its two-position example additionally takes `Bool`. Neither theorem supplies the original occurrence or an internally performed act of witnessing.

The older walk's [B001](</C:/.ana/coda_university/coda_research/projection_obstruction_primitive_difference_walk/B001_raw_distinction.md>) explicitly starts with a carrier and unequal elements, and marks the obligation `OPEN`: it does not derive the carrier or its inhabitance. A one-position model with an asserted self-relation is therefore a relevant negative control against inferring two unequal endpoints from an unconstrained relation. Conversely, irreflexivity plus an asserted pair rules out that model. These are conditional facts about representations, not a disproof of a one-commitment starting point.

**Polarity matters.** Positive apartness says a pair is different; a zero relation says a pair is identified or indistinguishable under a stated criterion. They are not automatically the same relation or complements. [B014](</C:/.ana/coda_university/coda_research/projection_obstruction_primitive_difference_walk/B014_relation_polarity_firewall.md>) separates them. [B016](</C:/.ana/coda_university/coda_research/projection_obstruction_primitive_difference_walk/B016_no_quotient_from_apartness_alone.md>) records an open bridge from apartness to a quotient. Its note explicitly says multiple compatible zero-equivalences do not by themselves prove the absence of every natural selector.

## 2. A report and its fibers

Now **supply** a type `X`, a report type `M`, and a map `p : X → M`. Define two inputs to be report-equivalent when `p(x) = p(y)`. Equality in `M` gives reflexivity, symmetry and transitivity, so this is an equivalence relation. It need not be a claim that `x` and `y` are literally identical, or that an internal process has performed a report.

The walk's [E003](</C:/.ana/coda_university/coda_research/projection_obstruction_primitive_difference_walk/E003_projection_fiber_primitive_difference.md>) describes exactly this construction. It labels its estate `OPEN`; the local [ProjectionFiberPrimitiveDifference.lean](</C:/Users/a343o/source/repos/theory_of_finite_quantum_mechanics/lean4/ProjectionFiberPrimitiveDifference.lean:41>) states the fiber characterization as a definitional equivalence. Changing `p` can change the fibers. The map is an explicit representation choice.

Given a specified equivalence, Omega's [ZeroEquivalence.lean](</C:/Users/a343o/source/repos/omega_codex/lean/ZeroEquivalence.lean:14>) constructs quotient classes and states the factorization criterion. The walk calls the corresponding [B008](</C:/.ana/coda_university/coda_research/projection_obstruction_primitive_difference_walk/B008_quotient_universal_property.md>) `LANDED_CONDITIONAL`. Neither a quotient nor a report function supplies a canonical representative, a section, or an agent. A specified split in [FiberQuotientEquivalence.lean](</C:/Users/a343o/source/repos/theory_of_finite_quantum_mechanics/lean4/FiberQuotientEquivalence.lean>) is a stronger construction with its section supplied.

**Bridge B — OPEN:** connect positive witnessed non-sameness to this particular report, zero relation and quotient without identifying unlike predicates. Mathematical instantiation of a general quotient theorem is a conditional bridge between *models*; it is not the missing derivation from the starting commitment.

## 3. An obstruction with an exact success condition

Supply a target `d : X → Y` and the task of recovering `d(x)` from `p(x)`. If there are `x,y` with the same report but different targets, there is no function `g` satisfying `d = g ∘ p` on all inputs. Otherwise `g` would have to assign two different outputs to the same input.

This is the fiber obstruction described in the walk's [B010](</C:/.ana/coda_university/coda_research/projection_obstruction_primitive_difference_walk/B010_observable_descent_lggr.md>) and in Omega's [unary_no_factor_of_witness](</C:/Users/a343o/source/repos/omega_codex/lean/ZeroEquivalence.lean:119>). Conversely, a function constant on equivalence classes descends to the quotient. The result is about an explicitly named task and interface; it does not require an external observer, but neither does it establish that an internal observer has been constructed.

For a supplied operation `T : X → X`, set `d = p ∘ T`. The exact requirement for its report-level behavior to descend is: whenever `p(x) = p(y)`, also `p(Tx) = p(Ty)`. The walk gives this criterion in [E011](</C:/.ana/coda_university/coda_research/projection_obstruction_primitive_difference_walk/E011_fiber_dynamics_congruence.md>), an `OPEN` estate item with candidate evidence. Its [E018](</C:/.ana/coda_university/coda_research/projection_obstruction_primitive_difference_walk/E018_descent_failure_without_escape.md>) counterexample shows that fixing a chosen section does not suffice to check every fiber.

**Bridge C — OPEN:** why must the target be recovered, why must the inputs remain admissible, and why would failure cause any response? A model may simply lack the information and remain unchanged. A conditional diagonal self-description obstruction from the earlier discussion supplies a different task and additional evaluation, self-application, answer-change and fidelity assumptions; it does not by itself supply a transition rule.

## 4. A possible response: preserve more information

If a supplied additional report `q` separates the obstructing pair, the combined report `(p,q)` can distinguish them while retaining the original `p`. [PrimitiveDifferenceBridge.lean](</C:/Users/a343o/source/repos/theory_of_finite_quantum_mechanics/lean4/PrimitiveDifferenceBridge.lean:97>) formalizes a supplied strict refinement and the corresponding distinction of quotient classes. The obstruction rules out exact recovery from the old report alone. It does **not** establish that `q` is available, that it is found, or that adding it is the only response.

Removal of a demand, refusing the task, leaving it unmet, or using a different representation can also be considered. A proposed repair needs its own task, admissible operations, preservation condition and evidence that it is performed. The local [repair and lift review](</C:/Users/a343o/source/repos/omega_codex/research/reviews/tfqm-proof-review-repair-lift.md>) records a relevant warning: a Boolean `hasCertificate` field is not itself a `RepairCertificate`.

**Bridge D — OPEN:** derive or explicitly adopt a response and show it preserves the intended difference. Persistence does not by itself prove indefinite growth, and a successful finite refinement need not repair a broader self-description task.

## 5. Optional branch: finite cochains and L1

The [TFQM route](</C:/Users/a343o/source/repos/theory_of_finite_quantum_mechanics/dag/derivations/PREGENESIS_TO_WDP_ROUTE.md>) records a candidate path through Genesis and finite obstruction. Its [TFQ-0344](</C:/Users/a343o/source/repos/theory_of_finite_quantum_mechanics/dag/derivations/06_wdp/tfq_0344_do_not_derive_the_degree_1_window_c0_c1_c2_d0_d1_from.md>) is a `GAP`: a finite window `(C0,C1,C2,d0,d1)` with `d1 ∘ d0 = 0` is declared, not derived from Genesis admission. The walk's [D010](</C:/.ana/coda_university/coda_research/projection_obstruction_primitive_difference_walk/D010_weighted_l1_gauge.md>) marks a weighted L1 gauge `LANDED_CONDITIONAL` and explicitly imports coordinates, weights, order and absolute value; [D011](</C:/.ana/coda_university/coda_research/projection_obstruction_primitive_difference_walk/D011_phi1_existence.md>) keeps general optimum/certificate work open.

For one declared integer triangle with unit weights, [PregenesisWdpHandoffToL1.lean](</C:/Users/a343o/source/repos/theory_of_finite_quantum_mechanics/lean4/PregenesisWdpHandoffToL1.lean>) gives a face-evaluation lower bound for the L1 residual of any integer vertex potential, and its explicit repair constructions attain that bound. This is a useful exact, conditional structure result. It does not establish that this triangle or its L1 objective is forced by step 0.

This cochain route and the phase-blind example share a theme—information surviving or failing under an identified equivalence—but **their actual equivalence or a derivation from the former to the latter is not established here**. The finite example can be understood directly using steps 2–3.

## 6. The finite phase-blind interference example

**Supplied:** two indexed positions `false` and `true`; Gaussian-integer amplitude arithmetic; vectors on those positions; a coordinatewise squared-magnitude report; and a mixer. For the specific witness all amplitudes are ordinary integers, a subset of the supplied Gaussian integers. The source defines the report and vectors in [HilbertWalkPhaseBlindPresentation.lean](</C:/Users/a343o/source/repos/theory_of_finite_quantum_mechanics/lean4/HilbertWalkPhaseBlindPresentation.lean:18>) and the mixer in [InterferenceNonDescent.lean](</C:/Users/a343o/source/repos/theory_of_finite_quantum_mechanics/lean4/InterferenceNonDescent.lean:20>).

Let the positions be ordered as `(false, true)`:

| Supplied vector | Initial squared weights `p(v)` | Mixer `T(a,b) = (a+b,a-b)` | Squared weights `p(T(v))` |
| --- | --- | --- | --- |
| `(1, 1)` | `(1, 1)` | `(2, 0)` | `(4, 0)` |
| `(1, -1)` | `(1, 1)` | `(0, 2)` | `(0, 4)` |

The same input report is compatible with two different post-mixing reports. Therefore no total function of the initial weight pair alone gives the post-mixing weights for every vector. The exact source statement is [no_descent_through_fiber](</C:/Users/a343o/source/repos/theory_of_finite_quantum_mechanics/lean4/InterferenceNonDescent.lean:48>); the file also states the integer-only version and a negative control where removing the sign difference removes the difference in these outputs. [PhaseFiber.lean](</C:/Users/a343o/source/repos/theory_of_finite_quantum_mechanics/lean4/PhaseFiber.lean:61>) further states that the two witnesses are not related by a single Gaussian-integer scalar.

This directly instantiates the step-3 obstruction: `X` is the supplied carrier of two-indexed Gaussian-integer vectors, `p` is squared-weight readout, and `d = p ∘ T`. That identification is a mathematical correspondence between supplied models; this map has not added or checked a cross-repository Lean import proving their formal definitions identical.

The source's mixer is **unnormalized**: each input has total weight 2, and each mixed output has total weight 4. Dividing each displayed pair by its own total gives `(1/2,1/2)` initially and `(1,0)` versus `(0,1)` afterwards, but that arithmetic does not make the source mixer a norm-preserving unitary. A normalized Hilbert-space realization would additionally require an appropriate normalized state and mixer, including the coefficient `1/√2` in an appropriate scalar field.

The result shows that this **particular phase-blind population report** cannot determine this **particular mixed readout**. It does not say every L1-based method lacks access to phase if given additional phase information. Nor does it derive the Born rule, complex amplitudes, a physical measurement, or quantum mechanics from non-sameness. TFQM's [TFQ-0251](</C:/Users/a343o/source/repos/theory_of_finite_quantum_mechanics/dag/derivations/12_finite_qm_structure/tfq_0251_superposition_as_a_quotient_fiber.md>) and [TFQ-0252](</C:/Users/a343o/source/repos/theory_of_finite_quantum_mechanics/dag/derivations/12_finite_qm_structure/tfq_0252_interference_as_a_resource_outside_l1_bookkeeping.md>) explicitly list amplitude/readout and context assumptions; the latter says its listed Lean build was not rechecked in that record. [TFQ-0006](</C:/Users/a343o/source/repos/theory_of_finite_quantum_mechanics/dag/derivations/08_l1_to_l2/tfq_0006_conditional_finite_hilbert_lift.md>) remains a `GAP`, and [TFQ-0311](</C:/Users/a343o/source/repos/theory_of_finite_quantum_mechanics/dag/derivations/09_finite_hilbert/tfq_0311_ordinary_matrix_algebra_over_c_is_not_recovered.md>) distinguishes Gaussian integers from ordinary complex matrix algebra. The walk's [G023](</C:/.ana/coda_university/coda_research/projection_obstruction_primitive_difference_walk/G023_hilbert_envelope_import_fence.md>) likewise keeps the Hilbert-envelope imports separate.

## Checks and provenance

On this map, an independent Python calculation used exact integers to check both rows, the totals, and the sign-removal negative control. It enumerated the 25 input vectors in `{-2,-1,0,1,2}²` and found 32 ordered pairs with identical initial squared weights and different mixed squared weights. That bounded check confirms the example and supplies many witnesses; it is not the universal no-factor theorem or a Lean build.

Omega checkout HEAD at review: `b90f6146b4ea3272502eaea5196aa979f2e2a587`. TFQM checkout HEAD read from its branch reference: `e45ed2e133920aa3790af8c5e072ee9829898490`; no claim is made that its working files match that commit. The TFQM table of contents, the three main Lean sources, and walk index were read from their working copies with these SHA-256 hashes:

| Source | SHA-256 |
| --- | --- |
| `dag/theory_of_finite_qm.md` | `9fbddf4ef94bcbcc067c34b877c50f2661834c5a1eb05feaadf4d5ab8897fdd0` |
| `lean4/InterferenceNonDescent.lean` | `a7247e052643452607f54ef0efa5ea98df3dc763e0620558ca81080fa73eca94` |
| `lean4/HilbertWalkPhaseBlindPresentation.lean` | `e7ca49b4ca6cd26239b024ee0f171bba8b978d4d0b3eebb8ab99f9068b8cee04` |
| `lean4/PhaseFiber.lean` | `ee7078faf56d9ea2aa0702383cefe2e9fbe1bf90097f60ecfaeb79a3170c6300` |
| Projection walk `WALK_INDEX.md` | `bb8f80ee719461a1ed26fc3f2b6132672ef0857fd1b337b4f16fbb68e516a070` |

The projection walk's historical [A001](</C:/.ana/coda_university/coda_research/projection_obstruction_primitive_difference_walk/A001_freeze_source_revisions.md>) identifies its own older anomalonpy and 19L57G1 freezes; those are not asserted to be the current `.ana` files' Git revisions. No legacy repository was changed, no Lean or Rust build was run, and no receipt or DAG status was changed.
