# Existing routes through Genesis WDP projection obstruction and quantum mechanics

Reviewed 6 November 2026. This is a comparison of existing arguments and their interfaces. It introduces no replacement derivation or new Lean implementation.

The main finding is that the corpus repeatedly uses a common question-preservation criterion, then adds genuinely different results about repair, future execution, quantum dynamics and higher coherence. Omega's downstream roadmap does not yet adequately identify those existing owners. An Omega target marked IMAGINED is not evidence that the corresponding mathematics is missing from the wider corpus.

## Source revisions and review scope

- Omega remote main: `b94d9232109f7bb9c63661c3a3811de03940d48b`, the merged [PR 6](https://github.com/dbccpage/omega_codex/pull/6). Local checkout: `5d0a8a56491a9d220fcd51307867b74046020690`, the PR head before its squash merge. Seven relevant local files match the merged Git blobs, allowing CRLF normalization for the DAG and validator.
- TFQM remote main: `88e8c24b88ef07d561855437ef363d36f616a78f`. Remote files were read at this revision because the local TFQM checkout is on a feature branch. Sources below use immutable revision links.
- The original Genesis and Genesis Ongoing arguments are traced through the current WDP source-specific bridge programme, which pins their historical revisions `f1d56c0` and `5d94883`. This review does not claim a fresh audit of those entire original checkouts.
- The local mark-to-projection walk and the `006_genesis_to_omega_to_mtheory` programme were consulted as historical research routes. They are not silently substituted for current TFQM.

This review compares theorem statements, selected proof bodies, source-specific bridge records and current gap registers. It does not certify every theorem or every implementation in these repositories. The distinction between a source-reported proof and a newly executed check is retained below.

## What the merged Omega work contributes

The [merged DAG][omega-dag] has 24 DERIVED, 12 OWED and 10 IMAGINED nodes. Its nine modules and receipts cover 350 named theorems. DERIVED includes statements with explicit conditional status; these counts are not a count of unconditional derivation steps from the mark.

PR 6 closes a real implementation-to-theorem gap. Previously, the class-count growth premise of a quotient-refinement run was supplied. [MinimalSeparation][omega-minimal] now enumerates actual Regime4 contexts, decides contextual collapse, counts canonical representatives and proves that a strict Regime4 refinement increases the class count. It also constructs the fresh-unary-form transition and proves its preservation and separation properties. For a nonempty fixed carrier of size n, a run of strict refinements has at most n-1 rounds. The retained three-position control has class counts 2, 2 and 3: an existing-form update can re-collapse another pair; the fresh-form update preserves old separations.

This is useful to the route. It does not supply the demand, choose the pair or force the transition to occur. Its fixed-carrier hypothesis is essential. It places no universal bound on carrier-growing systems.

Two roadmap risks are visible:

1. IMG-01 through IMG-09 describe targets already substantially developed elsewhere: WDP cochain transport and schedule topology; TFQM channels, Bell tables, Weyl systems, gauge and gravity branches; and constructor-theory work. Each node needs a link to those results and an exact remaining interface, rather than a fresh implementation programme inferred from the IMAGINED label.
2. DER-22 and DER-23 are explicit models. The ten positions, period-four example, token/receipt constructors, chosen profile radius and scheduled append rule are supplied. Omega itself preserves a period-two rival. Further study is justified only by a specified route obligation; these examples do not yet establish a uniquely necessary cosmos generator.

OWE-12 is a particularly important scope choice. It asks for a bridge between WDP's five-gate operational model and a particular legacy Represented/Horizon model. The adapted version commutes, but its guards were added to make the models match. Omega's own audit says the core WDP cut and minimum-separation results do not depend on this five-gate bridge. It should not become the default cosmology bottleneck merely because it is next in an issue list.

## Where the same argument appears

The recurring criterion is: a protected answer q can be recovered from report p exactly when equal p-reports imply equal q-answers, with the decoder defined on occupied reports. A collision p(x)=p(y), q(x)≠q(y) rules out every decoder using p alone. This is an identification of mathematical form; it does not assert that all source domains or implementations are already formally equivalent.

| Existing route | Report or identification | Protected content | Relationship |
| --- | --- | --- | --- |
| Genesis observation contexts | Indistinguishability under admitted forms and contexts | The pair a challenge requires to remain distinguishable | A report collision blocks that task. Changing the question family changes the relation. |
| Omega mirror and zero-equivalence | Accessible presentation or a declared setoid quotient | Referent answer, exact value or named readout | `unary_descends_iff` and the mirror no-decoder argument are instances of the same criterion. |
| WDP evaluation and permission | Evaluation report | Permission decision | [ProposalAdmissionBridge][wdp-factor] states the criterion directly. Evaluation and permission need separate information only when the former fails to determine the latter. |
| WDP history and replay | Final state, event multiset, compressed history or result mark | Occurrence, order, price, enabled actions and future answers | Present-answer sufficiency becomes contextual congruence when all admitted continuations must be preserved. |
| Phase-blind QM | Coordinate squared weights | Weights after a specified mixing experiment | [InterferenceNonDescent][interference] explicitly uses equal initial reports and unequal future readouts to refute every decoder. |
| Linear WDP and LGGR | Linear observation map, possibly descended through an allowed-repair quotient | Raw defect or repair class | Fiber constancy becomes a kernel-containment test. Which kernel and which quotient matter. |

The proof-body comparison matters: Omega's quotient factor uses `Quotient.lift`; WDP's arbitrary-image existence proof uses `Classical.choose` to select representatives. The no-decoder collision argument has the same content, but the implementations and axiom profiles should not be presented as identical. The mathematical existence proof also does not construct an executable observation instrument.

The interference witness is already complete at its stated scope. The supplied states (1,1) and (1,-1) have weights (1,1); after the supplied unnormalized mixer their readouts are (4,0) and (0,4). The source includes controls removing the phase distinction or replacing the target with the original report, plus an integer-valued realization. Repeating this witness in a new package would not fill the quantum-selection interface.

## Related arguments that must remain distinct

**A failed repair and a failed observation are different questions.** In linear notation, let B be the allowed repair image and K the observation kernel. A defect outside B is not repairable by that menu. A defect inside K is invisible to that observation. Neither condition implies the other. WDP's [distinct-image completion results][wdp-targets] explicitly distinguish realization image R from repair image B and give different minimum observation counts for raw recovery, quotient recovery and their joint task. This is more precise than calling every failure a single obstruction.

**Local compatibility does not automatically give a common global object.** WDP and LGGR contain gluing and cycle obstructions. The additional data are a cover, restrictions and compatibility laws. A cycle residual is not automatically an entanglement measure. Genesis Ongoing's directed assertion tables retain loops and independent reverse arcs; their repair quotient becomes ordinary cohomology only with the additional closure and orientation conditions described in the [existing bridge programme][wdp-programme].

**Projection Obstruction contains additional quantum dynamics.** The current [PO-000 paper][po] treats product-state retractions on a declared quantum lattice. It gives the short-time bound D_e(t) ≥ ν_e t - 24g²t² under its Hamiltonian and incident-norm assumptions. It also constructs graph-state examples with zero two-body edge defects but a nonzero higher diagnostic. These are not merely the two-line report-collision lemma: the paper supplies the dynamics, quantitative bounds and explicit observation adapter. The product correlation defect measures failure to be a product; it must not be substituted for every definition of entanglement.

**Diagonal non-exhaustion is a separate argument.** [InternalMetatheory][omega-internal] proves that no code in a supplied Boolean evaluator represents its diagonal negation. Its `extendEvaluator` captures the previous diagonal on old inputs while retaining a new diagonal obstruction. This is an existing repeatable extension result. It does not make the evaluator inconsistent, prove it internally invokes its own extension, or identify its index with a Postnikov degree.

## The route frame and its actual interfaces

These rows organize the existing branches. They are not a new numbered derivation or a claim that each row follows unconditionally from the preceding row.

| Region | Existing work to retain | Exact interface still requiring attention |
| --- | --- | --- |
| `<>` and first admission | Genesis inertia and admission-provenance results; Omega primitive/symmetry models; WDP GEN-WDP-01/02 and primitive-execution refinements | Which admission is the starting commitment, and how a particular source acquires a challenge and law. OWE-05/07 and GEN-WDP-O01 address different parts of this. |
| Questions, separation and retained history | Genesis contexts, Omega PR 6, WDP semantic signatures, replay and contextual compression | Faithful maps for actual source transitions, prices, occurrences and future questions. Existing source-23/25 and seeds-9/15/16 adapters already close selected cases. GEN-WDP-O02 remains broader. |
| Repair, projection and cochain structure | Directed-table normalization, gradient repair, quotient diagnostics, linear completion and LGGR | Carrier-changing edits may fail to respect the quotient. WDP has explicit AddTerm/Identify counterexamples and source-specific descent criteria. General dynamic transport is GEN-WDP-O03. |
| Finite quantum models | Scalar and matrix constructions, phase-sensitive experiments, state/effect pairings, finite channels, tensor statistics, Bell witnesses and operational distinctions | The selection and regularity hypotheses needed for the requested model. [TFQ-1010][qm-selection] records this interface; the downstream finite constructions are not erased by its remaining obligation. |
| Gauge, field, gravity and continuum interfaces | TFQM's separate finite gauge, QED, electroweak, QCD, topological, QG, dressing-field, causal-QFT, AdS/CFT and LQG branches; WDP's selected Meron limits | A separate limit/model correspondence for each branch. [TFQ-2620][qg-gap] names the combined quantum-gravity target. A finite receipt or a branch name does not close it. |
| Higher coherence and self-description | WDP guarded execution complexes and sparse chain maps; Omega diagonal tower; TFQM's Genesis-to-Higher branch | Maps connecting the actual source histories to higher objects, coherence across extensions, and the hypotheses needed to apply logical limit theorems to the constructed language. |
| M-theory and beyond | Historical `006_genesis_to_omega_to_mtheory/the_finite_system/the_finite_system.md` reserves a C3/G4 differential-cohomology/flux endpoint | That programme labels the endpoint reserved. No reviewed source establishes a route from the present constructions to a complete M-theory or a beyond-M-theory theory. The horizon can remain open without inventing intervening proofs. |

The [current Genesis-to-WDP register][wdp-register] records 75 scoped bridge entries plus five broader open obligations. These are not 75 consecutive stages. In particular, realification and complex tensor balancing already supply explicit representation bridges: they preserve the declared complex structure rather than selecting it from the primitive. Treating those bridges as absent would repeat completed work.

## Existing monsters and the tower proposal

There are already substantial counterexamples and arbitrarily high members of a specified obstruction family.

1. **Non-Born frame functions on the Gaussian rationals.** [TFQ-1055][qi3] now records a negative answer to unrestricted quadratic rigidity on Q(i)^3, even for nonnegative frame functions. The named source results are `exoticQi3_isNonnegFrameFunction` and `exoticQi3_not_quadratic`. Nine-ray tomography does not remove the residual. [TFQ-1056][qi3-uniform] supplies a positive result under uniform ray continuity; [TFQ-1057][qi3-pointwise] still asks whether pointwise continuity everywhere suffices, separately for signed and nonnegative functions. This is a concrete surviving competitor and a sharply located regularity question, not a reason to restart QM.
2. **Higher schedule obstructions at arbitrary finite degree.** WDP [Appendix P.22][schedule] proves, in its declared paired remove/add family, K(n,n-1) ≃ S^(n-2). More generally, capacity c controls the first nonzero homotopy/homology degree c-1 under the stated range. Thus the family has higher obstructions at arbitrarily large finite degrees as its supplied size grows. This is a written topological theorem with selected Lean and bounded executable scopes, not a newly executed all-dimension build. It does not provide bonding maps making all K(n,c) one Postnikov tower.
3. **Compressed equivalence that breaks under an actual next edit.** The WDP source-25 countermodels show that equal result marks can diverge under AddTerm or Identify. Its [native-future retention result][native-retention] finds raw equality as the coarsest sufficient report on a specific 29,771-state, two-edit domain with protected offers, prices and continuations. This is directly relevant to Omega's retention programme; the two models must be compared before building another toy memory engine.
4. **A fresh diagonal after an extension.** Omega already formalizes this for its chosen total evaluator. This supports a precise finite-stage non-exhaustion statement; it does not supply an origin mechanism or a universal physical growth law.

The user's suggested 1024-stage exploration can be a finite research budget. It is not a maximum number of possible lifts established by these sources. Omega's conspicuous 1024 is the number of binary memory packets in a particular enumeration, 16 × 4 × 16; the fixed-carrier n-1 refinement bound is a different quantity.

Likewise, “Gödel at lift 13” can be a proposed presentation label, but no reviewed source establishes that level assignment. [TFQ-2411][godel] states Gödel–Rosser and Tarski under explicit syntax, arithmetic and representation assumptions and explicitly attaches them by reading order. Those hypotheses have not been obtained from its unfinished admission language. Omega's finite diagonal theorem and this arithmetic incompleteness result are related techniques with different statements.

The existing [S(n) record][postnikov] explicitly withdraws the automatic identification of S(n) construction stages with Postnikov truncations. Keep three indices separate: construction stage, coherence/homotopy degree, and exploration budget. For an actual tower, the connecting maps and their preservation laws are part of the mathematical target. A single iteration counter cannot supply them.

## What Gemini should work against next

The immediate coordination task is to replace broad downstream ambitions with references to existing owners and a precise missing interface. This report does not change the DAG or authorize a new reconstruction slice.

- Keep PR 6 as a completed fixed-carrier result. Compare it with WDP/WD2 partition refinement; avoid another proof of the same counting argument.
- For OWE-13, compare the reflective-chain questions and operations with WDP contextual compression, realizable observation and native-future retention. Record which information must persist and whether WDP's hypotheses are satisfied. An endogenous mechanism remains different from an externally supplied continuation.
- Treat OWE-12 as an optional interoperability target unless a required result actually uses it. The current five-gate WDP model is operational and explicitly priced; its externally named inputs are not primitive cosmological ingredients.
- Link IMG-04 to the current quantum selection/regularity nodes, especially TFQ-1010 and TFQ-1055–1057. Link the higher-coherence part of IMG-01 to P.22/P.23 before proposing more simplices. [P.23][chain] already constructs integral maps p i = id and i p - id = dH + Hd with fixed-degree polynomial bounds for its minimum-sweep construction.
- Keep both meaningful positive results and counterexamples. A source-specific counterexample may close an overstrong claim while leaving a corrected route available. A missing universal derivation is not itself a universal impossibility theorem.

The criterion for a new slice is an identified edge between existing results whose hypotheses do not yet match, together with either a proposed preservation map or a concrete test that can refute the match. That is how additional code would advance this route.

## Checks performed for this review

- Confirmed PR 6 is merged and remote Omega main is `b94d923...`; read its merged DAG and the relevant Lean sources.
- Compared seven local Omega files with fetched merged Git-blob hashes. All matched, two after LF normalization.
- Ran `.venv/Scripts/python.exe scripts/validate_derivation_dag.py`: valid; 46 nodes, 104 edges, 51 admission edges, nine receipt-bound modules and 350 recorded theorems. This run executed zero Python model checks and did not compile Lean.
- Ran `.venv/Scripts/python.exe -m unittest discover -s tests -p test_oq05_regime4_class_count.py -v`: five tests passed, including empty/singleton carriers, context enumeration, fresh-form trajectories and the existing-form re-collapse control.
- Read proof bodies for Omega's quotient, refinement and diagonal results; WDP's image-factorization theorem; and TFQM's interference and selected exotic-frame declarations. No fresh Lean, Rust or full TFQM/WDP suite was run. Source-recorded kernel and replay statuses are not new attestations from this review.

[omega-dag]: https://github.com/dbccpage/omega_codex/blob/b94d9232109f7bb9c63661c3a3811de03940d48b/dag/README.md
[omega-minimal]: https://github.com/dbccpage/omega_codex/blob/b94d9232109f7bb9c63661c3a3811de03940d48b/lean/MinimalSeparation.lean
[omega-internal]: https://github.com/dbccpage/omega_codex/blob/b94d9232109f7bb9c63661c3a3811de03940d48b/lean/InternalMetatheory.lean
[wdp-factor]: https://github.com/dbccpage/theory_of_finite_quantum_mechanics/blob/88e8c24b88ef07d561855437ef363d36f616a78f/atlas/finite_obstruction_calculus/witnessed_difference_programme/lean4/WitnessedDifference/ProposalAdmissionBridge.lean
[wdp-programme]: https://github.com/dbccpage/theory_of_finite_quantum_mechanics/blob/88e8c24b88ef07d561855437ef363d36f616a78f/atlas/finite_obstruction_calculus/witnessed_difference_programme/docs/04_roadmap_and_gaps/genesis_to_wdp_derivation_programme.md
[wdp-register]: https://github.com/dbccpage/theory_of_finite_quantum_mechanics/blob/88e8c24b88ef07d561855437ef363d36f616a78f/atlas/finite_obstruction_calculus/witnessed_difference_programme/docs/04_roadmap_and_gaps/genesis_bridge_register.md
[wdp-targets]: https://github.com/dbccpage/theory_of_finite_quantum_mechanics/blob/88e8c24b88ef07d561855437ef363d36f616a78f/atlas/finite_obstruction_calculus/witnessed_difference_programme/docs/02_requiring_derivation/five_outstanding_derivations.md
[interference]: https://github.com/dbccpage/theory_of_finite_quantum_mechanics/blob/88e8c24b88ef07d561855437ef363d36f616a78f/lean4/InterferenceNonDescent.lean
[po]: https://github.com/dbccpage/theory_of_finite_quantum_mechanics/blob/88e8c24b88ef07d561855437ef363d36f616a78f/atlas/projection_obstruction/projection_obstruction_paper/projection_obstruction.md
[qm-selection]: https://github.com/dbccpage/theory_of_finite_quantum_mechanics/blob/88e8c24b88ef07d561855437ef363d36f616a78f/dag/derivations/10_finite_qm_core/tfq_1010_fq_prim_to_qm_selection_open.md
[qi3]: https://github.com/dbccpage/theory_of_finite_quantum_mechanics/blob/88e8c24b88ef07d561855437ef363d36f616a78f/dag/derivations/10_finite_qm_core/tfq_1055_fq_gleason_qi3_frame_functions.md
[qi3-uniform]: https://github.com/dbccpage/theory_of_finite_quantum_mechanics/blob/88e8c24b88ef07d561855437ef363d36f616a78f/dag/derivations/10_finite_qm_core/tfq_1056_fq_gleason_qi3_uniform_ray_continuity.md
[qi3-pointwise]: https://github.com/dbccpage/theory_of_finite_quantum_mechanics/blob/88e8c24b88ef07d561855437ef363d36f616a78f/dag/derivations/10_finite_qm_core/tfq_1057_fq_gleason_qi3_pointwise_to_uniform.md
[schedule]: https://github.com/dbccpage/theory_of_finite_quantum_mechanics/blob/88e8c24b88ef07d561855437ef363d36f616a78f/atlas/finite_obstruction_calculus/witnessed_difference_programme/docs/01_substantiated/guarded_schedule_topology.md
[chain]: https://github.com/dbccpage/theory_of_finite_quantum_mechanics/blob/88e8c24b88ef07d561855437ef363d36f616a78f/atlas/finite_obstruction_calculus/witnessed_difference_programme/docs/01_substantiated/sparse_guarded_chain_transport.md
[native-retention]: https://github.com/dbccpage/theory_of_finite_quantum_mechanics/blob/88e8c24b88ef07d561855437ef363d36f616a78f/atlas/finite_obstruction_calculus/witnessed_difference_programme/docs/01_substantiated/derivations/native_future_retention.md
[godel]: https://github.com/dbccpage/theory_of_finite_quantum_mechanics/blob/88e8c24b88ef07d561855437ef363d36f616a78f/dag/derivations/34_genesis_to_higher/tfq_2411_gth_lang_limits.md
[postnikov]: https://github.com/dbccpage/theory_of_finite_quantum_mechanics/blob/88e8c24b88ef07d561855437ef363d36f616a78f/dag/derivations/05_mssn_sn/tfq_0520_sn_postnikov_refusal.md
[qg-gap]: https://github.com/dbccpage/theory_of_finite_quantum_mechanics/blob/88e8c24b88ef07d561855437ef363d36f616a78f/dag/derivations/19_finite_qg/tfq_2620_qg_full_theory_completion_open.md
