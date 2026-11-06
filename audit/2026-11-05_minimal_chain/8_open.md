# Task 6 (Part C): Open Questions Left in the Chain (Ordered by Dependency Weight)

## Source Commits

- `A` (`C:\Users\a343o\source\repos\19L57G1`): `45bb09864f9b52ed5ecf66e977ca81f0ed623de7`
- `B` (`C:\Users\a343o\source\repos\theory_of_finite_quantum_mechanics`): `e45ed2e133920aa3790af8c5e072ee9829898490`
- `omega_codex` (`C:\Users\a343o\source\repos\omega_codex` baseline): `e21b785626ff8d0231a53409c76fe4e7a57cd59d`

Path abbreviations:
- `B/pregenesis/paper.md` = `B/atlas/finite_obstruction_calculus/pregenesis_to_minimal_symbol_systems/paper.md`
- `B/genesis/paper.md` = `B/atlas/finite_obstruction_calculus/genesis/paper.md`
- `B/wdp/wdp.md` = `B/atlas/finite_obstruction_calculus/witnessed_difference_programme/witnessed_difference_programme.md`
- `B/wdp/bridge_reg.md` = `B/atlas/finite_obstruction_calculus/witnessed_difference_programme/docs/genesis_bridge_register.md`
- `B/wdp/programme.md` = `B/atlas/finite_obstruction_calculus/witnessed_difference_programme/docs/genesis_to_wdp_derivation_programme.md`

---

## Summary Table of Open Questions (Ordered from Highest to Lowest Chain Dependency)

| Rank & ID | Status Tag | Question | How Much of the Chain Depends on It | Resolution / Smallest Check |
|---|---|---|---|---|
| **1. `OQ-01`** (`PG-R-GAP-DIAMOND-TO-ROOT` / `N21`) | **`Derived` + `Witnessed`** (Settled in §9.3) | Can a 2-point carrier $\|X\| \ge 2$ and an inhabited irreflexive relation $R(a,b)$ (`S2, S3` in `6_minimal_chain.md`) be obtained from `<>` (`Step 0`) without an external second token, occurrence-indexing rule (`stepOcc`), or reifying refusal rule (`reifyUntagged` / `reifyTagged`)? | **All post-mark steps (`S2`–`D2` in `6_minimal_chain.md`, Genesis §§6–9, WDP Chapters 1–10):** Every non-trivial separation and cut requires $\|X\| \ge 2$ (`PrimDiff.no_witness_on_subsingleton`). | **Settled (`Not forced` from `<>` alone; `Forced` that $\|Idx\| \ge 2$ or $\|X_1\| \ge 2$ is `Supplied`):** Formalized in `9_oq01_to_oq04.lean:685-714` (`subsingleton_image_no_irrefl_witness`, `list_expansion_requires_target_ne`, `indexed_admission_requires_index_ne`) and checked in `9_oq01_to_oq04_checks.py` `[3]`. |
| **2. `OQ-02`** (`PG-R-GAP-GENESIS-TO-WINDOW` / `A29`) | **`Derived` + `Witnessed`** (Settled in §9.4) | What is the minimal admission needed to pass from a discrete WDP Admitted Cut $C = (X, E, \tau, K)$ (`Step 7` / `WDP-CH01-D01`) to a linear cochain window $C^0 \xrightarrow{d^0} C^1 \xrightarrow{d^1} C^2$ with $d^1 \circ d^0 = 0$ and a real seminorm $J$ (`Root P`, `WDP-CH04-P01`)? | **All of WDP Root P and Chapters 4–9:** Quotient defect $\Phi_J([\delta])$, gauge equivalence, exact-vs-coexact decomposition, and $\ell_1$ obstruction calculus depend on $(C^\bullet, d^\bullet, J)$. | **Settled (`Not forced` from $C=(X,E,\tau,K)$; ring characteristic, edge/face orientation signs, $d^1 d^0 = 0$, and seminorm $J$ are independent `Supplied` admissions):** Formalized in `9_oq01_to_oq04.lean:730-802` and checked in `9_oq01_to_oq04_checks.py` `[4]`. |
| **3. `OQ-03`** (`GEN-WDP-O02` / `N22` / `A33`) | **`Derived` + `Witnessed`** (Settled in §9.2) | What minimal axioms on a retention packet $\mathcal{R} = (M, u, r, \approx)$ isolate the `16 / 1024` distinction-retaining packets (`5_forcing_checks.py` `[4]`) and link Genesis monotone list retention (`insts, reqs`) to `WDP-CH03-O01/O02`? | **All multi-step dynamics, memory retention, and observer state (`ClosedRun`, WDP §3.3, WDP Chapter 10 `Mem_O`):** Required whenever a distinction must survive across $\ge 1$ transition step. | **Settled:** Exact 4-condition characterization (`C1` write separation, `C2` idle-step injectivity, `C3` readout injectivity, `C4` reflexive directed apartness) matches `retainsDistinction` with `0 / 1024` mismatches (`4 × 2 × 2 = 16`), and strengthening `C2 → C2'` (idle fixed-point stability, ruling out `CM5`) and `C4 → C4'` (symmetric equality on $O$) isolates the `4 / 1024` drift-free symmetric packets (`9_oq01_to_oq04.lean:565-680`, `9_oq01_to_oq04_checks.py` `[2]`). |
| **4. `OQ-04`** (`GEN-WDP-O01` / `A19`) | **`Derived` + `Witnessed`** (Settled in §9.1) | Can the general strictly-monotone arity-cost uniqueness theorem (`general_refinement.py`: any $\phi(1) < \phi(k)$ for $k \ge 2$ selects $\{U_0, U_1\}$) be formalized in Lean 4 to replace the linear `aritySum` specialization in `Minimality.lean:480-485`? | **Uniqueness of the unary mark `(2, 1)` class (`R2` in `3_regime_fields.md`, Genesis §7 Prop. 2, `WDP-CH03-P03`):** Connects the single-hole context formula $k \cdot n^{k-1}$, multi-hole formula $(n+1)^k - n^k$, and `aritySum` $k$. | **Settled:** Formalized in Lean 4 (`mu2_unique_general` on `R2L` and `mu2_unique_F_general` on `R2F`, plus concrete corollaries `mu2_unique_linear`, `mu2_unique_singleHole`, `mu2_unique_multiHole` in `9_oq01_to_oq04.lean:250-558`) with zero `Classical.choice` and zero `sorry`. |
| **5. `OQ-05`** (`GEN-WDP-O03` / `A21`) | **`Derived` + `Witnessed` (`DER-08` + `DER-24`)** (Settled in §11.1) | Does WDP Chapter 3 admit a multi-round closure theorem (`WDP-CH03-P04`) matching Genesis §8 (`closedRun_round_bound` $2(\|Q_0\|+m) \le n(n-1)$ and `mark_progress`), and what separates the explicit-`Q` bound $\binom{n}{2}$ from the derived-`Q` bound $n-1$ (`3_regime_deletions.py` `[6]`)? | **All finite cuts with $\|X\| = n \ge 3$ (`R5` in `3_regime_fields.md`, `GEN-WDP-07` in `B/wdp/bridge_reg.md:27`):** Needed to extend single-pair separation (`WDP-CH03-P03`) to full carrier separation. | **Settled (`DER-08` + `DER-24`):** In `lean/MinimalSeparation.lean:771-1394`, finite-carrier context enumeration (`allWfCtxs4`, `collapsed4Bool`) and canonical class-representative counting (`isRep4`, `classCount4`, `regimeClassCount4`) connect `StrictRegimeTransition4` (`regime4_strict_class_count_growth`) and concrete fresh-unary form transitions (`stepFreshUnary4_strict_transition`, `stepFreshUnary4_class_count_growth`) to `QuotRefRun` (`regimeRefinementRun4_to_quotRefRun`, `regimeRefinementRun4_round_bound` $m \le r.\text{data} - 1$), alongside the `RT-09` class-count comparison (`rt09_class_count_comparison`). |
| **6. `OQ-06`** (`GEN-WDP-O05` / `H01`) | **`Derived` + `Witnessed`** (Settled in §11.2) | Can `Classical.choice` (`H01`) be eliminated from Theorem 2 (`history_report_criterion` in `B/atlas/finite_obstruction_calculus/genesis/lean4/Paper.lean:24-27`) when $H$ is restricted to a finite history set? | **Report-descent criterion (`A06`, pre-Genesis §5 Thm. 2, Genesis §5 Thm. 2, `GEN-WDP-03`):** Settles whether the audit report theorem is constructive on finite trace spaces. | **Settled (`does not depend on any axioms`):** `decodeFin` (`List.find?`) establishes `oq06_history_report_criterion_fin` over `H : List Hist` with `[DecidableEq V]` using zero axioms (`11_oq05_to_oq08.lean:294-350`, `11_oq05_to_oq08_checks.py` `[2]`). |
| **7. `OQ-07`** (`L1-R-RESIDUAL-TO-WEIGHTS` / `A32`) | **`Derived` + `Witnessed`** (Settled in §11.3) | Are positive cell weights $w_e > 0$ in the weighted $\ell_1$ repair functional $\|v\|_{1,w} = \sum_e w_e \|v_e\|$ (`B/dag/derivation_dag.json:40`) forced by cut symmetries or must they remain `Supplied` (`A32`)? | **Weighted $\ell_1$ repair and dual-witness certification in WDP Chapters 5–7:** Determines whether $\ell_1$ weights are derived from the cut or supplied in the symmetry-breaking ledger (`WDP-CH03-D01`). | **Settled (`Not forced` without symmetry; `Forced` equal under transitive edge-automorphism invariance):** On the 3-edge cycle with $v_1+v_2+v_3=1$, $w=(1,2,2)$ uniquely selects $(1,0,0)$ while $w'=(2,1,2)$ uniquely selects $(0,1,0)$ (`oq07_weights_not_forced_without_symmetry`), whereas cyclic edge invariance forces $w_1=w_2=w_3$ (`oq07_transitive_symmetry_forces_equal_weights` in `11_oq05_to_oq08.lean:357-440`). |
| **8. `OQ-08`** (`GEN-WDP-O04` / `A30, A31`) | **`DERIVED_CONDITIONALLY` (`DER-12`) + `OWED` (`OWE-12`)** (Scoped in §11.4) | Does a formal state-refinement morphism exist from the WDP Five-Gate Grounding Span `(g_sup, g_adm, g_ret, g_ev, g_auth)` (`WDP-CH01-D03`) to the `Horizon.lean` / `Represented.lean` budget world (`step`)? | **Priced observer boundary and horizon branch only (`A30, A31`, WDP §1.6 and §10.9):** Neither `WDP-CH01-P02` nor `WDP-CH03-P03` depends on it (`B/wdp/wdp.md:527`). | **`DERIVED_CONDITIONALLY` (`DER-12`) + `OWED` (`OWE-12`):** `projToHorizon` commutes between simplified models (`WDPWorld` and `HWorld`), but `stepHWorldGuarded` omits `Represented.World`'s novelty, `increaseB`, and `augLicensed` guards (`InternalMetatheory.lean` establishes in Lean all 4 discrepancy regressions and adapted `FullWDPWorld` commutation). The non-adapted bridge from prose `WDP-CH01-D03` to legacy `Represented`/`Horizon` remains **`OWED` (`OWE-12`)**. |

---

## Detailed Specifications for Each Open Question

### 1. `OQ-01` — Root-to-Two-Point-Carrier Gap (`PG-R-GAP-DIAMOND-TO-ROOT` / `N21`)
- **Tag:** `Derived` + `Witnessed` (Settled in `9_oq01_to_oq04.lean:685-714` and `9_oq01_to_oq04_checks.py` `[3]`)
- **Where recorded:** `B/dag/derivation_dag.json:25` (`PG-R-GAP-DIAMOND-TO-ROOT`), `omega_codex/docs/research_map.md:105-115` (`N21`), `A/lean4/Derivation/Bridge.lean:87-91` (`single_token_carrier_bound`), `A/lean4/Derivation/Refusal.lean:142-230`.
- **What was unsettled:** In `6_minimal_chain.md`, Step `S0` starts at `<>` (a single token), whereas Step `S2` + `S3` requires an inhabited irreflexive relation $R(a, b)$, which by `Step 4` (`PrimDiff.no_witness_on_subsingleton`) requires $|X| \ge 2$. In `A/lean4/Derivation/Bridge.lean:87-91`, token-deduplicated admission from a 1-token supply satisfies `t.tokens.length ≤ 1` forever. Reaching $|X| = 2$ in `Refusal.lean` requires choosing either `stepOcc` (which uses the host natural-number step index) or `Mode.reifyUntagged` / `Mode.reifyTagged` (which reifies a duplicate-admission refusal into a second carrier element).
- **How it is settled (see §9.3):**
  1. `subsingleton_image_no_irrefl_witness` (`9_oq01_to_oq04.lean:685-690`, zero axioms): For any `[Subsingleton X0]`, any pure map `f : X0 → X1`, and any irreflexive relation `R : X1 → X1 → Prop`, `¬ R (f x) (f y)` holds for all `x, y : X0` because `congrArg f (Subsingleton.elim x y)` yields `f x = f y`, contradicting `irrefl_witness_ne`.
  2. `list_expansion_requires_target_ne` (`9_oq01_to_oq04.lean:695-699`, zero axioms): Any finite-list expansion `F : X0 → List X1` with `a, b ∈ F x0` and `R a b` requires `a ≠ b` already inhabited in `X1`.
  3. `indexed_admission_requires_index_ne` (`9_oq01_to_oq04.lean:705-713`, zero axioms): Any indexed admission rule `step : Idx → X0 → X1` on `[Subsingleton X0]` with `R (step i x) (step j y)` requires `i ≠ j` in the host index type `Idx` (`Not forced` from `<>` alone; an external 2-element index or carrier is `Forced` as a `Supplied` admission).

### 2. `OQ-02` — Discrete Admitted Cut to Linear Cochain Window (`PG-R-GAP-GENESIS-TO-WINDOW` / `A29`)
- **Tag:** `Derived` + `Witnessed` (Settled in `9_oq01_to_oq04.lean:730-802` and `9_oq01_to_oq04_checks.py` `[4]`)
- **Where recorded:** `B/dag/derivation_dag.json:32` (`PG-R-GAP-GENESIS-TO-WINDOW`), `5_unrecognised_forcing.md:50` (`A29`), `B/wdp/wdp.md:547-557` (`Root P`), `B/wdp/wdp.md:990-1035` (`WDP-CH04-P01`).
- **What was unsettled:** Target 2 of `6_minimal_chain.md` reaches the discrete tuple $C = (X, E, \tau, K)$ (`WDP-CH01-D01`). WDP Chapter 4 (`WDP-CH04-P01`) assumes an abelian group / real vector-space cochain complex $(C^0, C^1, C^2, d^0, d^1)$ with $d^1 \circ d^0 = 0$ and a convex seminorm $J : C^1 \to \mathbb{R}_{\ge 0}$ (plus real completeness `H08` in `WDP-CH04-P02`). No theorem in `A`, `B`, or `omega_codex` derives vector-space structure, edge orientation signs $\pm 1$, or $d^1 \circ d^0 = 0$ from $C = (X, E, \tau, K)$ alone.
- **How it is settled (see §9.4):** On the fixed 3-vertex triangle cut $X=\{0,1,2\}, E=\{e_{01},e_{12},e_{02}\}, F=\{f_{012}\}$, `9_oq01_to_oq04.lean:730-802` constructs four explicit models demonstrating that:
  1. **Coefficient ring characteristic (`Supplied`):** Unsigned incidence coboundaries satisfy $d^1 \circ d^0 = 0$ over $\mathbb{F}_2$ (`oq02_unsigned_f2_complex_holds`), whereas over $\mathbb{Z}$ they give $d^1(d^0(1,0,0)) = 2 \ne 0$ (`oq02_unsigned_int_complex_fails`).
  2. **Orientation signs and $d^1 \circ d^0 = 0$ (`Supplied`):** Over $\mathbb{Z}$, cyclic signs $(+1,+1,-1)$ satisfy $d^1 \circ d^0 = 0$ (`oq02_signed_cyc_int_complex_holds`), whereas flipping one edge sign to $(+1,+1,+1)$ gives $d^1(d^0(0,0,1)) = 2 \ne 0$ (`oq02_signed_flip_int_complex_fails`).
  3. **Seminorm $J$ (`Supplied`):** On the signed complex over $\mathbb{Z}$, the vortex 1-cochain $h=(1,1,1)$ satisfies $d^0(v_0,v_1,v_2) \ne (1,1,1)$ for all $v_0,v_1,v_2 \in \mathbb{Z}$ (`oq02_vortex_not_in_im_d0`), and the zero seminorm $J_0=0$ assigns defect $0$ whereas the $\ell_1$ norm satisfies $\|(1,1,1) - d^0 v\|_1 \ge 1$ for all $v \in \mathbb{Z}^3$ (`oq02_vortex_l1_defect_pos`).

### 3. `OQ-03` — Minimal Axioms for Memory Retention (`GEN-WDP-O02` / `N22` / `A33`)
- **Tag:** `Derived` + `Witnessed` (Settled in `9_oq01_to_oq04.lean:565-680` and `9_oq01_to_oq04_checks.py` `[2]`)
- **Where recorded:** `B/wdp/bridge_reg.md:36` (`GEN-WDP-O02`), `B/wdp/programme.md:155-158` (`G2`), `omega_codex/docs/research_map.md:116-120` (`N22`), `5_unrecognised_forcing.md:54` (`A33`).
- **What was unsettled:** `5_forcing_checks.py` `[4]` shows that among the $1,024$ retention packets $(u, r, \approx)$ on $|M|=|I|=|O|=2$, $1,008$ fail to retain a 1-bit distinction across a single idle step (`CM1`–`CM5`). Neither WDP §3.3 (`WDP-CH03-O01/O02`) nor `omega_codex` (`N22`) states the minimal algebraic axioms on $(M, u, r, \approx)$ that characterize the $16$ retaining packets and bridge them to Genesis's append-only list retention (`reqs`, `insts`).
- **How it is settled (see §9.2):** `oq03_retains_iff_four_conditions` (`9_oq01_to_oq04.lean:643-645`) establishes with `0 / 1024` mismatches that `retainsDistinction` on $|M|=|I|=|O|=2$ is equivalent to the 4-condition characterization `C1 && C2 && C3 && C4` (`4 × 2 × 2 = 16` packets), and strengthening `C2 → C2'` (idle fixed-point stability `u(m,0)=m`, ruling out `CM5` permutation drift) and `C4 → C4'` (symmetric diagonal equality on $O$) isolates the `4 / 1024` (`2 × 2 × 1 = 4`) drift-free symmetric packets (`oq03_drift_free_symmetric_count_eq_4`, `oq03_factor_counts`, `oq03_condition_independence_witnesses`).

### 4. `OQ-04` — Lean 4 Formalization of General Cost Refinement (`GEN-WDP-O01` / `A19`)
- **Tag:** `Derived` + `Witnessed` (Settled in `9_oq01_to_oq04.lean:250-558` and `9_oq01_to_oq04_checks.py` `[1]`)
- **Where recorded:** `B/wdp/bridge_reg.md:35` (`GEN-WDP-O01`), `B/wdp/programme.md:151-154` (`G1`), `A/code/derivation/general_refinement.py:1-120`, `7_adversary.md` Finding `F2`.
- **What was unsettled:** As found in `7_adversary.md` `F2`, `3_regime_fields.md` and `3_regime_deletions.py` conflated three distinct second-stage cost formulas: `Minimality.lean`'s linear `aritySum` ($k$), `3_regime_deletions.py`'s single-hole context count ($k \cdot n^{k-1}$), and `B/genesis/paper.md:253-255`'s multi-hole context count ($\sum ((n+1)^k - n^k)$). All three are instances of a strictly increasing positive function $\phi(k)$ with $\phi(1) < \phi(k)$ for $k \ge 2$, which was checked in Python (`A/code/derivation/general_refinement.py`) but not in Lean 4 (`A/lean4/Derivation/Minimality.lean`).
- **How it is settled (see §9.1):** `mu2_unique_general` (`9_oq01_to_oq04.lean:258-369`) and `mu2_unique_F_general` (`9_oq01_to_oq04.lean:374-475`) establish in Lean 4 (with zero `Classical.choice` and zero `sorry`) that for **any** weight function `φ : Nat → Nat` satisfying `∀ k, 2 ≤ k → φ 1 < φ k`, every 2-item valid separating response `[a, b]` on `R2L` (resp. `R2F`) with `phiSum φ [a, b] ≤ φ 1` yields a regime isomorphic to `U0` (resp. `U0F`). Concrete corollaries `mu2_unique_linear`, `mu2_unique_singleHole`, and `mu2_unique_multiHole` (`9_oq01_to_oq04.lean:541-558`) instantiate the theorem for all three cost formulas.

### 5. `OQ-05` — Multi-Round Closure Theorem in WDP (`GEN-WDP-O03` / `A21`)
- **Tag:** `Derived` + `Witnessed` (`DER-08` + `DER-24`, settled in `lean/MinimalSeparation.lean:662-1394`, `11_oq05_to_oq08.lean`, and `11_oq05_to_oq08_checks.py` `[1]`; see §11.1)
- **Where recorded:** `B/wdp/bridge_reg.md:27,37` (`GEN-WDP-07`, `GEN-WDP-O03`), `B/wdp/programme.md:159-162` (`G3`), `3_regime_fields.md:49,160-166`, `lean/MinimalSeparation.lean:662-1394`.
- **What was unsettled:** Genesis §8 establishes `closedRun_round_bound` ($2(|Q_0|+m) \le n(n-1)$) and `mark_progress` (`A/lean4/Derivation/Rounds.lean:452-468`, `Progress.lean:75-190`), whereas WDP Chapter 3 has no multi-round theorem. Moreover, `3_regime_deletions.py` `[6]` shows that on $n=3$, a single unary predicate separating `(0, 1)` automatically separates either `(0, 2)` or `(1, 2)`, so the maximum number of rounds when each step strictly increases the number of equivalence classes on a fixed carrier of size $n$ is $n - 1$ (not $\binom{n}{2}$).
- **How it is settled (`DER-08` + `DER-24`, see §11.1):**
  - **Arithmetic round bounds and $n=3$ witnesses (`DER-08`, `MinimalSeparation.lean:662-768`):** `ExplicitQRun` gives $2(q_0+m) \le n(n-1)$ (`explicit_pair_round_bound`), `QuotRefRun` gives $c_0 + m \le n$ and $m \le n - 1$ for $1 \le c_0$ (`quotient_refinement_bound`, `quotient_refinement_from_one`), `rt09_fresh_form_strictly_refines_all_pairs` exhibits a 2-round fresh-form completion on $n=3$, and `rt09_unrequested_pair_recollapse_witness` exhibits a same-form unrequested-pair re-collapse on $n=3$.
  - **General `Regime4` transition-to-class-count growth bridge (`DER-24`, formerly `OWE-11`, `MinimalSeparation.lean:771-1394`):** Discharges all five components connecting actual `Regime4` transitions to `QuotRefRun` for general $n$: (1) finite-carrier context enumeration (`allWfCtxs4`, `mem_allWfCtxs4_iff`) and decidable `collapsed4Bool` (`collapsed4_iff_collapsed4Bool`, `separable4_iff_collapsed4Bool_false`); (2) canonical class-representative counting (`isRep4`, `classCount4`, `regimeClassCount4`, `classCount4_strict_mono_of_witness`); (3) constructive canonical representative extraction (`BoolEquivOn4`, `exists_rep_of_equiv4`, `StrictRefinementOn4`, `strict_refinement_classCount4_inc`); (4) `StrictRegimeTransition4` (`regime4_strict_class_count_growth`) and concrete fresh-unary form transitions (`stepFreshUnary4`, `applyDelta4_freshUnaryDelta4`, `stepFreshUnary4_strict_transition`, `stepFreshUnary4_class_count_growth`); and (5) multi-round `RegimeRefinementRun4` bridge (`regimeRefinementRun4_to_quotRefRun`, `regimeRefinementRun4_round_bound` $m \le r.\text{data} - 1$, and `rt09_class_count_comparison`).

### 6. `OQ-06` — Constructive Elimination of `Classical.choice` (`H01`) in `history_report_criterion` (`GEN-WDP-O05`)
- **Tag:** `Derived` + `Witnessed` (Settled in `11_oq05_to_oq08.lean:294-350` and `11_oq05_to_oq08_checks.py` `[2]`)
- **Where recorded:** `B/wdp/bridge_reg.md:39` (`GEN-WDP-O05`), `B/wdp/programme.md:167-170` (`G5`), `1_admission_ledger.md:92` (`H01`), `B/atlas/finite_obstruction_calculus/genesis/lean4/Paper.lean:24-27`.
- **What was unsettled:** `Paper.lean:24-27` uses `Classical.choose v.property` to construct a decoding function `decode : ReportImage report → S` in Theorem 2 (`history_report_criterion`), importing `Classical.choice` into an otherwise finite combinatorial development.
- **How it is settled (see §11.2):** `decodeFin` (`11_oq05_to_oq08.lean:294-298`) uses `H.find? (fun h => report h == v)` over `H : List Hist` with `[DecidableEq V]`, and `oq06_history_report_criterion_fin` (`11_oq05_to_oq08.lean:344-350`) establishes the exact iff criterion with **zero axioms** (`does not depend on any axioms`).

### 7. `OQ-07` — Derivation vs Admission of Positive $\ell_1$ Weights (`L1-R-RESIDUAL-TO-WEIGHTS` / `A32`)
- **Tag:** `Derived` + `Witnessed` (Settled in `11_oq05_to_oq08.lean:357-440` and `11_oq05_to_oq08_checks.py` `[3]`)
- **Where recorded:** `B/dag/derivation_dag.json:40` (`L1-R-RESIDUAL-TO-WEIGHTS`), `1_admission_ledger.md:48` (`A32`), `5_unrecognised_forcing.md:53` (`A32`).
- **What was unsettled:** WDP Chapters 4–6 evaluate cochain repair cost via a weighted $\ell_1$ norm $\|v\|_{1,w} = \sum_{e \in E} w_e |v_e|$ with $w_e > 0$. `B/dag/derivation_dag.json:40` marks the bridge from unweighted residuals to weights $w_e$ as open.
- **How it is settled (see §11.3):** `oq07_weights_not_forced_without_symmetry` (`11_oq05_to_oq08.lean:395-424`) establishes over all $v \in \mathbb{Z}^3$ with $v_1+v_2+v_3=1$ that $w=(1,2,2)$ has unique minimizer $(1,0,0)$ while $w'=(2,1,2)$ has unique minimizer $(0,1,0)$ (`Not forced` without symmetry; weights are `Supplied`), and `oq07_transitive_symmetry_forces_equal_weights` (`11_oq05_to_oq08.lean:430-440`, zero axioms) establishes that cyclic edge-permutation invariance on valid repairs forces $w_1 = w_2 = w_3$.

### 8. `OQ-08` — State-Refinement Morphism Between `WDP-CH01-D03` and `Horizon.lean` (`GEN-WDP-O04` / `A30, A31`)
- **Tag:** `DERIVED_CONDITIONALLY` (`DER-12`) + `DERIVED` (`DER-19` regressions) + `OWED` (`OWE-12`) (see §11.4)
- **Where recorded:** `B/wdp/bridge_reg.md:38` (`GEN-WDP-O04`), `B/wdp/programme.md:163-166` (`G4`), `1_admission_ledger.md:47-48` (`A30, A31`), `4_priced_containers.md:35,54`, `lean/RetentionAndRefusal.lean:414-585`, `lean/InternalMetatheory.lean:621-804`.
- **What was unsettled:** `WDP-CH01-D03` (`B/wdp/wdp.md:513-530`, commit `e45ed2e133920aa3790af8c5e072ee9829898490`) defines a 5-gate span `(g_sup, g_adm, g_ret, g_ev, g_auth)` over a rational ledger $R \in \mathbb{Q}_{\ge 0}$, whereas `A/lean4/Derivation/Represented.lean:105-120` and `Horizon.lean:155-161` (commit `45bb09864f9b52ed5ecf66e977ca81f0ed623de7`) define `World.step` with five augmentation guards on `.addView c`: `augLicensed`, `1 ≤ budget`, `wfViewB w c`, `!(decide (c ∈ w.views))`, and `increaseB w c`.
- **What is checked vs. what remains `OWED` (see §11.4):**
  - **Checked (`DERIVED_CONDITIONALLY` in `DER-12` and regressions in `DER-19`):** `oq08_refinement_commutes_at_zero_adm_ret_cost` and `rt12_guarded_refinement_commutes_at_zero_adm_ret_cost` (`RetentionAndRefusal.lean:488-585`) establish commutation between two *simplified* models (`WDPWorld` and `HWorld`), where `stepHWorldGuarded` checks only `1 ≤ w.budget` and `v < w.toks.length` and omits novelty, `increaseB`, and `augLicensed`. `lean/InternalMetatheory.lean:621-804` (`DER-19`) and `11_oq05_to_oq08_checks.py` `[5]` establish in Lean four concrete discrepancy regressions between `stepHWorldGuarded` and `Represented.World` (`oq08_singleton_discrepancy_regression`, `oq08_duplicate_view_regression`, `oq08_disabled_license_regression`, `oq08_no_new_separation_regression`) and commutation for an adapted 5-gate `FullWDPWorld` over `Represented.World` (`oq08_full_guard_refinement_commutes_at_zero_adm_ret_cost`).
  - **Retained as `OWED` (`OWE-12`):** Because prose `WDP-CH01-D03` does not define data-subset views, view novelty, `increaseB` separation checks, or `augLicensed`, matching guards between adapted models does not establish a non-adapted source-level equivalence between `WDP-CH01-D03` and legacy `Represented`/`Horizon`.


---

## 9. Formal Resolution of `OQ-01` through `OQ-04` (`9_oq01_to_oq04.lean` and `9_oq01_to_oq04_checks.py`)

### 9.1 `OQ-04` (`GEN-WDP-O01` / `A19`) — General Strictly Increasing Arity Weights (`mu2_unique_general`)
- **Tag:** `Derived` + `Witnessed`
- **Supplied premises:** `A13` (`Regime`), `A14` (`wfCtx`, `plug`, `derivable`), `A15` (`collapsed`, `separable`), `A16` (`Item`, `applyItem`, `applyDelta`, `validResponse`), `A18` ($\mu_1 = |\delta|$), and any arity weight function $\phi : \mathbb{N} \to \mathbb{N}$ satisfying $\forall k \ge 2,\; \phi(1) < \phi(k)$ (`A19`).
- **Full proof (`9_oq01_to_oq04.lean:250-558`):**
  1. Define `phiSum φ δ` by summing `φ c` over all `.newForm c` items in `δ`.
  2. For any 2-item valid separating response `[a, b]` on `R2L = ⟨2, [], [], [], [(0, 1)]⟩` (or `R2F = ⟨3, [], [], [], [(1, 2)]⟩` with target `(1, 2)`), `R2L.forms = []` rules out `a = .newInst` and `a = .newRuleAll`.
  3. If `a = .newDatum`, every choice of `b` leaves `s.insts = []`, contradicting `no_insts_no_separation` (`9_oq01_to_oq04.lean:87-89`).
  4. Thus `a = .newForm c` with $1 \le c$. Every choice of `b` except `b = .newInst f args` again leaves `s.insts = []`.
  5. For `a = .newForm c` and `b = .newInst f args`, `phiSum φ [a, b] = φ c`. The hypothesis `phiSum φ [a, b] ≤ φ 1` gives $\phi(c) \le \phi(1)$. By case analysis on $c < 2$ vs $2 \le c$: if $2 \le c$, the hypothesis `hφ c` gives $\phi(1) < \phi(c)$, contradicting $\phi(c) \le \phi(1)$; hence $c = 1$.
  6. With $c = 1$, $f < 1$ forces $f = 0$ and `args.length = 1`, so `args = [x]`. On `R2L`, $x \in \{0, 1\}$ yields `U0` (`isoRefl U0`) or `U1` (`isoU1U0`). On `R2F`, $x \in \{0, 1, 2\}$, where $x = 0$ is excluded by `genesis_mark_not_separable` (`9_oq01_to_oq04.lean:229-236`) and $x \in \{1, 2\}$ yields `U0F` (`isoRefl U0F`) or `U2F` (`isoU2F_U0F`).
  7. All three concrete second-stage cost functions satisfy $\forall k \ge 2,\; \phi(1) < \phi(k)$ for $n \ge 1$:
     - `phiLinear k = k` (`phiLinear_strict`, `mu2_unique_linear`, `9_oq01_to_oq04.lean:489-492, 543-546`)
     - `phiSingleHole n k = k * n ^ (k - 1)` (`phiSingleHole_strict`, `mu2_unique_singleHole`, `9_oq01_to_oq04.lean:495-511, 548-552`)
     - `phiMultiHole n k = (n + 1) ^ k - n ^ k` (`pow_succ_gap`, `phiMultiHole_strict`, `mu2_unique_multiHole`, `9_oq01_to_oq04.lean:514-540, 554-558`)

### 9.2 `OQ-03` (`GEN-WDP-O02` / `N22` / `A33`) — 4-Condition Characterization of the `16 / 1024` Retaining Memory Packets on $|M| = |I| = |O| = 2$
- **Tag:** `Derived` + `Witnessed`
- **Supplied premises:** Carrier sizes $|M| = |I| = |O| = 2$ (`Bool`), initial memory state $m_0 = 0$, operational test `retainsDistinction(u, r, approx)` (`9_oq01_to_oq04.lean:585-590`, `5_forcing_checks.py` `[4]`).
- **The 4-Condition Algebraic Characterization (`9_oq01_to_oq04.lean:598-615`):**
  - **C1 (`cond1WriteSep` — Write separation from $m_0 = 0$):** $u(0, 0) \ne u(0, 1)$ ($8 / 16$ update maps; rules out `CM1`/`CM2` write collapse).
  - **C2 (`cond2IdleInj` — Idle-step injectivity on $M$):** $u(0, 0) \ne u(1, 0)$, i.e., $m \mapsto u(m, 0)$ is a bijection on $M$ ($4 / 16$ update maps satisfy `C1 && C2`: bitmasks `uMask ∈ {1, 6, 9, 14}`, because $u(1, 1) \in \{0, 1\}$ is unconstrained).
  - **C3 (`cond3ReadoutInj` — Readout injectivity $r : M \to O$):** $r(0) \ne r(1)$ ($2 / 4$ readout maps: bitmasks `rMask ∈ {1, 2}`; rules out `CM3` constant report).
  - **C4 (`cond4ReflexiveApart` — Reflexive directed apartness on reported outputs):** $\approx(0, 0) = \text{True}$, $\approx(1, 1) = \text{True}$, and $\approx(o_0, o_1) = \text{False}$ ($2 / 16$ relations $\approx$ per $(u, r)$, since $\approx(o_1, o_0)$ is unconstrained; rules out `CM4` coarse comparison).
- **Exact product and non-redundancy (`oq03_retains_iff_four_conditions`, `oq03_factor_counts`, `oq03_condition_independence_witnesses`, `9_oq01_to_oq04.lean:640-680`):**
  - Across all $16 \times 4 \times 16 = 1,024$ packets, `retainsDistinction u r a = charFourConditions u r a` holds with `0` mismatches (`4 × 2 × 2 = 16` packets).
  - Dropping any single condition `C1`, `C2`, `C3`, or `C4` admits explicit non-retaining countermodels (`uMask=12`, `uMask=10`, `rMask=0`, `apMask=15`).
  - Strengthening `C2` to **C2' (`cond2PrimeIdleId`: $\forall m,\; u(m, 0) = m$)** rules out `CM5` permutation drift (`uMask ∈ {1, 9}` where $u(m, 0) = 1 - m$, cutting $u$ from $4$ to $2$: `uMask ∈ {6, 14}`), and strengthening `C4` to **C4' (`cond4PrimeDiagEq`: symmetric equality `apMask = 9`)** cuts $\approx$ from $2$ to $1$, yielding `2 × 2 × 1 = 4` drift-free symmetric packets (`oq03_drift_free_symmetric_count_eq_4`). Genesis monotone list admission (`insertNew` on `insts, reqs`, where $u(\text{false}, i) = i$ and $u(\text{true}, i) = \text{true}$, i.e. latch `uMask = 14`) with identity readout (`rMask = 2`) and diagonal equality (`apMask = 9`) is one of these $4$ drift-free symmetric packets.

### 9.3 `OQ-01` (`PG-R-GAP-DIAMOND-TO-ROOT` / `N21`) — Root-to-Two-Point-Carrier Theorem
- **Tag:** `Derived` + `Witnessed`
- **Full proof (`9_oq01_to_oq04.lean:685-714`):**
  1. `subsingleton_image_no_irrefl_witness`: Given `[Subsingleton X0]`, `f : X0 → X1`, and `hirr : Irrefl R`, for any `x y : X0`, `Subsingleton.elim x y` gives `x = y`, so `congrArg f` gives `f x = f y`, which contradicts `irrefl_witness_ne hirr` if `R (f x) (f y)` holds.
  2. `list_expansion_requires_target_ne`: Any expansion `F : X0 → List X1` with `a, b ∈ F x0` and `R a b` immediately yields `a ≠ b` in `X1` by `irrefl_witness_ne`.
  3. `indexed_admission_requires_index_ne`: Any indexed admission `step : Idx → X0 → X1` on `[Subsingleton X0]` with `R (step i x) (step j y)` requires `i ≠ j` in `Idx` (if `i = j`, then since `x = y`, `step i x = step j y`, contradicting `hirr`). Thus a 2-element carrier or index (`stepOcc` or `reifyUntagged` / `reifyTagged`) is `Not forced` by `<>` alone and is `Forced` as a `Supplied` admission.

### 9.4 `OQ-02` (`PG-R-GAP-GENESIS-TO-WINDOW` / `A29`) — Discrete Admitted Cut to Linear Cochain Window
- **Tag:** `Derived` + `Witnessed`
- **Full proof (`9_oq01_to_oq04.lean:730-802`):**
  1. `oq02_unsigned_f2_complex_holds` vs `oq02_unsigned_int_complex_fails`: On the 3-vertex triangle cut, unsigned incidence maps satisfy $d^1(d^0(c)) = 0$ over $\mathbb{F}_2$ for all $c \in \mathbb{F}_2^3$, whereas over $\mathbb{Z}$ they evaluate to $d^1(d^0(1,0,0)) = 2 \ne 0$.
  2. `oq02_signed_cyc_int_complex_holds` vs `oq02_signed_flip_int_complex_fails`: Over $\mathbb{Z}$, the cyclic edge-sign assignment $(+1, +1, -1)$ satisfies $d^1(d^0(v_0, v_1, v_2)) = (v_1 - v_0) + (v_2 - v_1) - (v_2 - v_0) = 0$ for all $v_0, v_1, v_2 \in \mathbb{Z}$, whereas flipping the third edge sign to $+1$ gives $d^1(d^0(0,0,1)) = 2 \ne 0$.
  3. `oq02_vortex_not_in_im_d0` and `oq02_vortex_l1_defect_pos`: On the signed complex over $\mathbb{Z}$, the vortex 1-cochain $h = (1, 1, 1)$ satisfies $d^1_{\text{cyc}}(h) = 1 \ne 0 = d^1_{\text{cyc}}(d^0 v)$, so $h \notin \operatorname{im} d^0$, and $\|(1, 1, 1) - d^0 v\|_1 = |1 - (v_1 - v_0)| + |1 - (v_2 - v_1)| + |1 - (v_2 - v_0)| \ge 1$ for all $v_0, v_1, v_2 \in \mathbb{Z}$, whereas the zero seminorm $J_0 = 0$ gives defect $0$.

---

## 10. Witnessed Execution Outputs for `OQ-01` through `OQ-04`

### 10.1 Lean 4 Verification (`lake env lean audit/2026-11-05_minimal_chain/9_oq01_to_oq04.lean`)

Command:
```text
lake env lean audit/2026-11-05_minimal_chain/9_oq01_to_oq04.lean
```

Pasted output:
```text
'MinimalChainAudit.mu2_unique_general' depends on axioms: [propext, Quot.sound]
'MinimalChainAudit.mu2_unique_F_general' depends on axioms: [propext, Quot.sound]
'MinimalChainAudit.mu2_unique_singleHole' depends on axioms: [propext, Quot.sound]
'MinimalChainAudit.mu2_unique_multiHole' depends on axioms: [propext, Quot.sound]
'MinimalChainAudit.oq03_retains_iff_four_conditions' depends on axioms: [propext]
'MinimalChainAudit.oq03_factor_counts' depends on axioms: [propext]
'MinimalChainAudit.oq03_condition_independence_witnesses' depends on axioms: [propext]
'MinimalChainAudit.subsingleton_image_no_irrefl_witness' does not depend on any axioms
'MinimalChainAudit.indexed_admission_requires_index_ne' does not depend on any axioms
'MinimalChainAudit.oq02_vortex_not_in_im_d0' depends on axioms: [propext, Quot.sound]
'MinimalChainAudit.oq02_vortex_l1_defect_pos' depends on axioms: [propext, Quot.sound]
```

### 10.2 Python Verification (`python audit/2026-11-05_minimal_chain/9_oq01_to_oq04_checks.py`)

Command:
```text
python audit/2026-11-05_minimal_chain/9_oq01_to_oq04_checks.py
```

Pasted output:
```text
=== [1] OQ-04: mu2_unique_general FOR STRICTLY INCREASING ARITY WEIGHTS ===
  Reading L (R2L): n=2, req=(0, 1), total 2-item separating responses (arity<=4) = 30
    phiLinear(k) = k                    | strict_inc=True | min_phi=1 | minimizers=2 (arities=[1], all iso to U0: True)
    phiSingleHole(n,k) = k*n^(k-1)      | strict_inc=True | min_phi=1 | minimizers=2 (arities=[1], all iso to U0: True)
    phiMultiHole(n,k) = (n+1)^k - n^k   | strict_inc=True | min_phi=1 | minimizers=2 (arities=[1], all iso to U0: True)
    phiCustom(k) = 1 if k==1 else 2     | strict_inc=True | min_phi=1 | minimizers=2 (arities=[1], all iso to U0: True)
  Reading F (R2F): n=3, req=(1, 2), total 2-item separating responses (arity<=4) = 116
    phiLinear(k) = k                    | strict_inc=True | min_phi=1 | minimizers=2 (arities=[1], all iso to U0: True)
    phiSingleHole(n,k) = k*n^(k-1)      | strict_inc=True | min_phi=1 | minimizers=2 (arities=[1], all iso to U0: True)
    phiMultiHole(n,k) = (n+1)^k - n^k   | strict_inc=True | min_phi=1 | minimizers=2 (arities=[1], all iso to U0: True)
    phiCustom(k) = 1 if k==1 else 2     | strict_inc=True | min_phi=1 | minimizers=2 (arities=[1], all iso to U0: True)

=== [2] OQ-03: 4-CONDITION CHARACTERIZATION OF 16 / 1024 MEMORY PACKETS ===
  Total packets (|M|=|I|=|O|=2): 1024
  Operational retainsDistinction count: 16 / 1024
  Algebraic C1 && C2 && C3 && C4 count: 16 / 1024
  Mismatches across all 1024 packets:   0
  Factor counts (general):   |U(C1,C2)|=4 (masks [1, 6, 9, 14]) x |R(C3)|=2 (masks [1, 2]) x |Ap(C4)|=2 = 16
  Factor counts (drift-free):|U(C1,C2')|=2 (masks [6, 14]) x |R(C3)|=2 (masks [1, 2]) x |Ap(C4')|=1 (masks [9]) = 4
  Condition independence countermodels:
    Drop C1 (u=12: u(m,i)=m, r=2, ap=9)       -> C2=True,  C3=True,  C4'=True, retains=False
    Drop C2 (u=10: u(m,i)=i, r=2, ap=9)       -> C1=True,  C3=True,  C4'=True, retains=False
    Drop C3 (u=14: u(m,i)=m||i, r=0, ap=9)    -> C1=True,  C2=True,  C4'=True, retains=False
    Drop C4 (u=14: u(m,i)=m||i, r=2, ap=15)   -> C1=True,  C2=True,  C3=True,  retains=False
    CM5 drift (u=9: u(m,0)=!m, r=2, ap=9)     -> C1..C4=True, C2'=False,       retains=True

=== [3] OQ-01: ROOT-TO-TWO-POINT-CARRIER THEOREM (|X0| = 1) ===
  |X0|=1 -> |X1|=1: pure maps=1, irrefl rels=1, pairs with R(f(x),f(y)) = 0
  |X0|=1 -> |X1|=2: pure maps=2, irrefl rels=4, pairs with R(f(x),f(y)) = 0
  |X0|=1 -> |X1|=3: pure maps=3, irrefl rels=64, pairs with R(f(x),f(y)) = 0
  Indexed step : Idx(|Idx|=1) x X0(1) -> X1(2): total=2, witnessing R(step(i,<>),step(j,<>)) = 0
  Indexed step : Idx(|Idx|=2) x X0(1) -> X1(2): total=4, witnessing R(step(i,<>),step(j,<>)) = 2
  Indexed step : Idx(|Idx|=3) x X0(1) -> X1(2): total=8, witnessing R(step(i,<>),step(j,<>)) = 6

=== [4] OQ-02: DISCRETE ADMITTED CUT TO LINEAR COCHAIN WINDOW ===
  Unsigned triangle over F2: d1(d0(c)) == 0 for all 8 0-cochains: True
  Unsigned triangle over Z on c=(1,0,0): d0(c)=(1,0,1), d1(d0(c)) = 2 != 0
  Signed cyclic (+1,+1,-1) over Z: d1(d0(c)) == 0 on [-2..2]^3: True
  Signed flipped (+1,+1,+1) over Z on c=(0,0,1): d1(d0(c)) = 2 != 0
  Vortex h=(1,1,1): d1_cyc(h) = 1 != 0 (not in im d0); J0 defect = 0; min L1 defect = 1
```


---

## 11. Formal Scope and Conditional / Owed Decomposition of `OQ-05` through `OQ-08` (`11_oq05_to_oq08.lean`, `InternalMetatheory.lean`, and `11_oq05_to_oq08_checks.py`)

### 11.1 `OQ-05` (`GEN-WDP-O03` / `A21`) — Multi-Round Arithmetic Round Bound (`DER-08`) and General `Regime4` Transition-to-Class-Count Growth Bridge (`DER-24`)
- **Tag:** `Derived` + `Witnessed` (`DER-08` + `DER-24`)
- **Checked results (`11_oq05_to_oq08.lean:104-285`, `MinimalSeparation.lean:662-1394`):**
  1. `ctxKernel` and `oq05_ctxKernel_zeroRel_iff` (`11_oq05_to_oq08.lean:107-129`): For any fixed regime `r` and context `c`, `relabel binary (fun d => derivableBool r (plug c d))` defines a `ZeroEquivalence.Kernel Nat Bool` whose `ZeroRel` is equivalent to `(derivable r (plug c d1) ↔ derivable r (plug c d2))`.
  2. `collapsedSetoid`, `collapsedKernel`, and `oq05_collapsed_equivalence` (`11_oq05_to_oq08.lean:145-157`): `collapsed r` is the intersection of `ZeroRel (ctxKernel r c)` over all well-formed contexts `c` and forms a `ZeroEquivalence.Kernel Nat Prop`.
  3. `oq05_explicit_pair_round_bound` (`11_oq05_to_oq08.lean:161-171`; `explicit_pair_round_bound` in `MinimalSeparation.lean:667-672`): Under explicit pair-demand accounting (`ExplicitQRun n q0 m`, where each round adds one demanded unordered pair inside capacity $n(n-1)/2$), $2(q_0 + m) \le n(n-1)$ holds by induction on `m`.
  4. `oq05_quotient_refinement_bound` and `oq05_quotient_refinement_from_one` (`11_oq05_to_oq08.lean:176-192`; `quotient_refinement_bound` and `quotient_refinement_from_one` in `MinimalSeparation.lean:681-693`): Under quotient-refinement accounting (`QuotRefRun n c0 m`) on a fixed finite carrier of size $n$, per-step class-count growth $c + 1 \le c'$ yields $c_0 + m \le n$, so for $c_0 \ge 1$, $m \le n - 1$.
  5. `oq05_strict_gap_for_n_ge_3` (`11_oq05_to_oq08.lean:197-202`), `oq05_n3_unary_splits_two_pairs` (`11_oq05_to_oq08.lean:207-230`), and `rt09_unrequested_pair_recollapse_witness` (`MinimalSeparation.lean:731-751`): On $n = 3$, admitting a fresh unary form + instance separates `(0, 1)` and `(0, 2)` simultaneously (`rt09_fresh_form_strictly_refines_all_pairs`, `MinimalSeparation.lean:756-768`), whereas appending a new instance of an *existing* unary form can re-collapse an unrequested pair `(0, 2)` (`rt09_unrequested_pair_recollapse_witness`).
  6. **General `Regime4` Transition-to-Class-Count Growth Bridge (`DER-24`, formerly `OWE-11`, `MinimalSeparation.lean:771-1394`, mirrored in `11_oq05_to_oq08.lean:237-285`):**
     - **Component 1 (`allWfCtxs4`, `collapsed4Bool`):** Enumerates all slot options (`allSlotOptions4`, `mem_allSlotOptions4_iff`), length-$k$ slot lists (`allSlotLists4`, `mem_allSlotLists4_iff`), and well-formed contexts (`allWfCtxs4`, `mem_allWfCtxs4_iff`), providing a constructive boolean equivalence `collapsed4Bool` (`collapsed4_iff_collapsed4Bool`, `separable4_iff_collapsed4Bool_false`) and `Decidable` instances for `collapsed4` and `separable4` without `Classical.choice`.
     - **Component 2 (`hasEarlierEquiv4`, `isRep4`, `classCount4`):** Counts canonical least-element equivalence class representatives on $\{0, \dots, n-1\}$ (`isRep4_iff`, `classCount4_le`, `classCount4_pos_of_pos`, `classCount4_mono_of_imp`, `classCount4_strict_mono_of_witness`).
     - **Component 3 (`BoolEquivOn4`, `exists_rep_of_equiv4`, `StrictRefinementOn4`):** Extracts for every $a < n$ its least equivalent representative $r \le a$ with `isRep4 eqv r = true`, and shows in `exists_new_rep_of_strictRefinementOn4` and `strict_refinement_classCount4_inc` that when a previously equivalent pair $(a, b)$ becomes separated while all prior separations are preserved, $\max(r'_a, r'_b)$ is a new canonical representative, forcing `classCount4 eqv n + 1 ≤ classCount4 eqv' n`.
     - **Component 4 (`StrictRegimeTransition4`, `stepFreshUnary4`):** Establishes `regime4_strict_class_count_growth` (`regimeClassCount4 r + 1 ≤ regimeClassCount4 s`) for any `StrictRegimeTransition4 r s`, and shows in `stepFreshUnary4_strict_transition` and `stepFreshUnary4_class_count_growth` that appending a fresh unary form and instance (`freshUnaryDelta4 r target`) on any regime with well-formed existing instances (`∀ p ∈ r.insts, p.1 < r.forms.length`) and a collapsed pair `(target, other)` with `target ≠ other` satisfies `StrictRegimeTransition4` and increments `regimeClassCount4` by at least $1$.
     - **Component 5 (`RegimeRefinementRun4`, `regimeRefinementRun4_round_bound`, `rt09_class_count_comparison`):** Maps any $m$-step `RegimeRefinementRun4 r m` into `QuotRefRun r.data (regimeClassCount4 r) m` (`regimeRefinementRun4_to_quotRefRun`), yielding `m ≤ r.data - 1` whenever `1 ≤ r.data` (`regimeRefinementRun4_round_bound`), and confirms `regimeClassCount4 R3_round1 = 2`, `regimeClassCount4 R3_round2_recollapse = 2`, and `regimeClassCount4 R3_round2_fresh = 3`.

### 11.2 `OQ-06` (`GEN-WDP-O05` / `H01`) — Constructive Elimination of `Classical.choice` in `history_report_criterion`
- **Tag:** `Derived` + `Witnessed`
- **Full derivation (`11_oq05_to_oq08.lean:294-350`):**
  1. Define `decodeFin H report state defaultS v` by matching `H.find? (fun h => report h == v)` (`some h => state h`, `none => defaultS`).
  2. `decode_implies_fiber_const`: If `∃ decode, ∀ h ∈ H, decode (report h) = state h`, then for any `h1, h2 ∈ H` with `report h1 = report h2`, `state h1 = decode (report h1) = decode (report h2) = state h2`.
  3. `fiber_const_implies_decodeFin_exact`: By induction on `H : List Hist`, if `report head == report h` is `true`, fiber constancy gives `state head = state h`; if `false`, then `h ≠ head`, so `h ∈ tail` and the induction hypothesis gives `decodeFin tail ... (report h) = state h`.
  4. `oq06_history_report_criterion_fin` combines both directions with **zero axioms** (`does not depend on any axioms`).

### 11.3 `OQ-07` (`L1-R-RESIDUAL-TO-WEIGHTS` / `A32`) — Positive $\ell_1$ Weights: Non-Forcing Without Symmetry vs Forcing Under Transitive Edge Symmetry
- **Tag:** `Derived` + `Witnessed`
- **Full derivation (`11_oq05_to_oq08.lean:357-440`):**
  1. `oq07_weights_not_forced_without_symmetry`: On the 3-edge cycle with constraint $v_1 + v_2 + v_3 = 1$ ($v \in \mathbb{Z}^3$), for $w = (1, 2, 2)$, $J_w(1, 0, 0) = 1$ while every $v \ne (1, 0, 0)$ with $v_1 + v_2 + v_3 = 1$ satisfies $J_w(v) \ge 2$; for $w' = (2, 1, 2)$, $J_{w'}(0, 1, 0) = 1$ while every $v \ne (0, 1, 0)$ with $v_1 + v_2 + v_3 = 1$ satisfies $J_{w'}(v) \ge 2$. Thus positive weights are `Not forced` without symmetry (`Supplied`).
  2. `oq07_transitive_symmetry_forces_equal_weights`: If $J_w(\text{rotEdge}(v)) = J_w(v)$ for all valid repairs $v$, evaluating at $(1, 0, 0)$ gives $w_3 = w_1$ and evaluating at $(0, 1, 0)$ gives $w_1 = w_2$, forcing $w_1 = w_2 = w_3$ (`does not depend on any axioms`).

### 11.4 `OQ-08` (`GEN-WDP-O04` / `A30, A31`) — Simplified-Model Commutation (`DER-12`), Discrepancy Regressions (`DER-19`), and Open Legacy Bridge (`OWE-12`)
- **Tag:** `DERIVED_CONDITIONALLY` (`DER-12`) + `DERIVED` (`DER-19` regressions) + `OWED` (`OWE-12`)
- **Checked results and scope boundaries (`11_oq05_to_oq08.lean:447-570`, `RetentionAndRefusal.lean:414-585`, `InternalMetatheory.lean:621-804`):**
  1. **Simplified-model commutation (`DER-12`):** `oq08_refinement_commutes_at_zero_adm_ret_cost` (`11_oq05_to_oq08.lean:529-543`, `RetentionAndRefusal.lean:488-502`) and `rt12_guarded_refinement_commutes_at_zero_adm_ret_cost` (`RetentionAndRefusal.lean:568-585`) establish commutation between two *simplified* models (`WDPWorld` and `HWorld`) at gate costs `⟨0, 0, 0, 1⟩`, where `stepHWorldGuarded` checks only `1 ≤ w.budget` and `v < w.toks.length`.
  2. **Four concrete guard-discrepancy regressions (`DER-19`, `InternalMetatheory.lean:686-751`, `11_oq05_to_oq08_checks.py` `[5]`):** Comparing `stepHWorldGuarded` against pinned legacy `Represented.World` (`19L57G1/Represented.lean:105-120`, commit `45bb09864f9b52ed5ecf66e977ca81f0ed623de7`) exhibits four verified discrepancies:
     - `oq08_singleton_discrepancy_regression`: `HWorld` with `toks=[0], reqs=[], views=[], budget=1` accepts `addView 0` (yielding `views=[0], budget=0`), whereas `Represented.World` with `data=[0], views=[], reqs=[], refusals=[], budget=1, augLicensed=true, notes=[]` rejects `addView [0]` because `increaseB` is `false` (no pair is separated on a singleton carrier).
     - `oq08_duplicate_view_regression`: When `views` already contains `[1]` at `budget=1`, `Represented.step` rejects a duplicate `addView [1]` (`!(decide (c ∈ w.views)) = false`) and preserves `budget=1`, whereas `stepHWorldGuarded` deduplicates `views` via `insertNewNat` to `[1]` and debits `budget` from `1` to `0`.
     - `oq08_disabled_license_regression`: When `augLicensed = false`, `Represented.step` rejects `addView [1]`, whereas `stepHWorldGuarded` has no license field and accepts `addView 1`.
     - `oq08_no_new_separation_regression`: On `data=[0, 1]` with `views=[[0]]` (so `(0, 1)` is already separated), `Represented.step` rejects novel `addView [1]` because `increaseB` is `false`, whereas `stepHWorldGuarded` accepts `addView 1`.
  3. **Adapted 5-gate commutation (`oq08_full_guard_refinement_commutes_at_zero_adm_ret_cost` in `InternalMetatheory.lean:790-804`) and remaining `OWED` bridge (`OWE-12`):** Adapting the 5-gate state `FullWDPWorld` to include `augLicensed`, novelty, and `increaseB` restores commutation with `Represented.step` at zero admission/retention cost, but prose `WDP-CH01-D03` (`B/wdp/wdp.md:513-530`, commit `e45ed2e133920aa3790af8c5e072ee9829898490`) does not specify those `Represented.World` structures. Therefore the source-level bridge between prose `WDP-CH01-D03` and legacy `Represented`/`Horizon` remains `OWED` in `OWE-12`.

---

## 12. Witnessed Execution Outputs for `OQ-05` through `OQ-08`

### 12.1 Lean 4 Verification (`lake env lean audit/2026-11-05_minimal_chain/11_oq05_to_oq08.lean`)

Command:
```text
lake env lean audit/2026-11-05_minimal_chain/11_oq05_to_oq08.lean
```

Pasted output:
```text
'MinimalChainAuditOQ05To08.oq05_ctxKernel_zeroRel_iff' depends on axioms: [propext, Quot.sound]
'MinimalChainAuditOQ05To08.oq05_collapsed_equivalence' depends on axioms: [propext]
'MinimalChainAuditOQ05To08.oq05_explicit_pair_round_bound' depends on axioms: [propext, Quot.sound]
'MinimalChainAuditOQ05To08.oq05_quotient_refinement_from_one' depends on axioms: [propext, Quot.sound]
'MinimalChainAuditOQ05To08.oq05_strict_gap_for_n_ge_3' depends on axioms: [propext, Quot.sound]
'MinimalChainAuditOQ05To08.oq05_n3_unary_splits_two_pairs' depends on axioms: [propext, Quot.sound]
'MinimalChainAuditOQ05To08.oq05_collapsed4_iff_collapsed4Bool' depends on axioms: [propext, Quot.sound]
'MinimalChainAuditOQ05To08.oq05_separable4_iff_collapsed4Bool_false' depends on axioms: [propext, Quot.sound]
'MinimalChainAuditOQ05To08.oq05_regime4_strict_class_count_growth' depends on axioms: [propext, Quot.sound]
'MinimalChainAuditOQ05To08.oq05_applyDelta4_freshUnaryDelta4' depends on axioms: [propext, Quot.sound]
'MinimalChainAuditOQ05To08.oq05_stepFreshUnary4_strict_transition' depends on axioms: [propext, Quot.sound]
'MinimalChainAuditOQ05To08.oq05_stepFreshUnary4_class_count_growth' depends on axioms: [propext, Quot.sound]
'MinimalChainAuditOQ05To08.oq05_regimeRefinementRun4_to_quotRefRun' depends on axioms: [propext, Quot.sound]
'MinimalChainAuditOQ05To08.oq05_regimeRefinementRun4_round_bound' depends on axioms: [propext, Quot.sound]
'MinimalChainAuditOQ05To08.oq05_rt09_class_count_comparison' depends on axioms: [propext, Quot.sound]
'MinimalChainAuditOQ05To08.oq06_history_report_criterion_fin' does not depend on any axioms
'MinimalChainAuditOQ05To08.oq07_weights_not_forced_without_symmetry' depends on axioms: [propext, Quot.sound]
'MinimalChainAuditOQ05To08.oq07_transitive_symmetry_forces_equal_weights' does not depend on any axioms
'MinimalChainAuditOQ05To08.oq08_refinement_commutes_at_zero_adm_ret_cost' depends on axioms: [propext, Quot.sound]
'MinimalChainAuditOQ05To08.oq08_trace_commutes_at_zero_adm_ret_cost' depends on axioms: [propext, Quot.sound]
'MinimalChainAuditOQ05To08.oq08_five_gate_strictly_finer_when_adm_priced' depends on axioms: [propext, Quot.sound]
```

### 12.2 Python Verification (`python audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py`)

Command:
```text
python audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py
```

Pasted output:
```text
=== [1] OQ-05: MULTI-ROUND CLOSURE BOUND (EXPLICIT Q VS DERIVED Q_der) ===
  n=2: max_rounds(explicit Q) = 1 [n(n-1)/2], max_rounds(derived Q_der) = 1 [n-1], gap = 0
  n=3: max_rounds(explicit Q) = 3 [n(n-1)/2], max_rounds(derived Q_der) = 2 [n-1], gap = 1
  n=4: max_rounds(explicit Q) = 6 [n(n-1)/2], max_rounds(derived Q_der) = 3 [n-1], gap = 3
  n=5: max_rounds(explicit Q) = 10 [n(n-1)/2], max_rounds(derived Q_der) = 4 [n-1], gap = 6
  n=3 unary witness (0,[0]): sep(0,1)=True, sep(0,2)=True, collapsed(1,2)=True (1 round splits 2 pairs simultaneously)
  n=2 stepFreshUnary4 classCount4 trajectory: [1, 2] (reaches 2 in 1 rounds)
  n=3 stepFreshUnary4 classCount4 trajectory: [1, 2, 3] (reaches 3 in 2 rounds)
  n=4 stepFreshUnary4 classCount4 trajectory: [1, 2, 3, 4] (reaches 4 in 3 rounds)
  n=5 stepFreshUnary4 classCount4 trajectory: [1, 2, 3, 4, 5] (reaches 5 in 4 rounds)
  RT-09 classCount4 comparison: R3_round1=2, R3_round2_recollapse=2 (stalled), R3_round2_fresh=3 (strict +1)

=== [2] OQ-06: CONSTRUCTIVE decodeFin (List.find?) ON FINITE HISTORIES ===
  |H|=4, |V|=2, |S|=2: total (report, state) pairs = 256
  Fiber-constant pairs:                60 / 256
  decodeFin exact on all h in H:       60 / 256
  Mismatches (fiber_const != decodeFin): 0

=== [3] OQ-07: POSITIVE L1 WEIGHTS (NON-FORCING VS SYMMETRY FORCING) ===
  Valid repairs in [-3..3]^3 with v1+v2+v3=1: 36
  w=(1,2,2): min=1, unique minimizer=[(1, 0, 0)], min on v!=(1,0,0) is 2
  w=(2,1,2): min=1, unique minimizer=[(0, 1, 0)], min on v!=(0,1,0) is 2
  Cyclic-invariant weights in {1..4}^3: 4 / 64 (matches w1==w2==w3: True)

=== [4] OQ-08: STATE-REFINEMENT MORPHISM (SIMPLIFIED WDPWorld VS HWorld) ===
  Zero adm/ret cost (0,0,0,1): traces(len<=3)=155, commutation mismatches=0
  Priced admission  (0,1,0,1): traces(len<=3)=155, commutation mismatches=114
  Priced retention  (0,0,1,1): traces(len<=3)=155, commutation mismatches=70

=== [5] OQ-08: GUARD DISCREPANCY REGRESSIONS (stepHWorldGuarded VS LEGACY Represented.World) ===
  (1) Singleton data=[0], addView [0]: HWorld views=[0] (budget=0) vs Represented views=[] (budget=1, increaseB=False)
  (2) Duplicate view [1]:              HWorld views=[1] (budget=0) vs Represented views=[[1]] (budget=1, novel=False)
  (3) Disabled augLicensed=False:      HWorld views=[1] (budget=0) vs Represented views=[] (budget=1, licensed=False)
  (4) Novel view [1] with 0 new sep:   HWorld views=[0, 1] (budget=0) vs Represented views=[[0]] (budget=1, increaseB=False)
```

