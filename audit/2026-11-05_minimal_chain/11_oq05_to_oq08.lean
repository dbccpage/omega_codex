import PrimitiveDifference
import ZeroEquivalence
import MinimalSeparation

/-!
# Open Questions `OQ-05` through `OQ-08` (`8_open.md`)

Pinned commits:
  A (19L57G1): 45bb09864f9b52ed5ecf66e977ca81f0ed623de7
  B (theory_of_finite_quantum_mechanics): e45ed2e133920aa3790af8c5e072ee9829898490
  omega_codex (baseline): e21b785626ff8d0231a53409c76fe4e7a57cd59d

This Lean 4 module checks:
- `OQ-05` (`DER-08` + `DER-24`): arithmetic round bound
  `oq05_quotient_refinement_from_one` from per-step class-count growth `c + 1 ≤ c'`
  on a fixed finite carrier (`r.data = n` fixed), the `n = 3` unary witness, and the
  discharged general `Regime4` transition-to-class-count growth bridge (`DER-24`,
  formerly `OWE-11`): `collapsed4Bool`, `classCount4`, `regimeClassCount4`,
  `StrictRegimeTransition4`, `regime4_strict_class_count_growth`,
  `stepFreshUnary4_strict_transition`, `stepFreshUnary4_class_count_growth`,
  `regimeRefinementRun4_to_quotRefRun`, `regimeRefinementRun4_round_bound`, and
  `rt09_class_count_comparison`.
- `OQ-06` (`DER-10`): choice-free `oq06_history_report_criterion_fin` via `decodeFin`.
- `OQ-07` (`DER-14`): `oq07_weights_not_forced_without_symmetry` and
  `oq07_transitive_symmetry_forces_equal_weights`.
- `OQ-08` (`DERIVED_CONDITIONALLY` in `DER-12`): simplified-model commutation
  `oq08_refinement_commutes_at_zero_adm_ret_cost` between `WDPWorld` and `HWorld`
  (omitting legacy `Represented.World`'s novelty, `increaseB`, and `augLicensed` guards;
  see `lean/InternalMetatheory.lean` (`DER-19`) for the 4 discrepancy regressions and
  `OWE-12` for the open source bridge).
-/

set_option autoImplicit false

namespace MinimalChainAuditOQ05To08

open OmegaCodex.PrimitiveDifference
open OmegaCodex.ZeroEquivalence
open OmegaCodex.MinimalSeparation hiding ExplicitQRun QuotRefRun

/-! =========================================================================
    SECTION 1: OQ-05 — Conditional Multi-Round Bound & Explicit `Q` vs `Q_der`
    ========================================================================= -/

abbrev Inst := Nat × List Nat

def insertNew {α : Type} [DecidableEq α] (l : List α) (a : α) : List α :=
  if a ∈ l then l else l ++ [a]

structure Regime where
  data  : Nat
  forms : List Nat
  insts : List Inst
  rules : List Nat
  reqs  : List (Nat × Nat)
deriving Repr, DecidableEq

structure Ctx where
  form  : Nat
  slots : List (Option Nat)
deriving Repr, DecidableEq

def plug (c : Ctx) (d : Nat) : Inst :=
  (c.form, c.slots.map (fun s => s.getD d))

def derivable (r : Regime) (i : Inst) : Prop :=
  i ∈ r.insts ∨ i.1 ∈ r.rules

instance (r : Regime) (i : Inst) : Decidable (derivable r i) := by
  unfold derivable; infer_instance

def derivableBool (r : Regime) (i : Inst) : Bool :=
  decide (derivable r i)

def slotOk (n : Nat) : Option Nat → Prop
  | none => True
  | some x => x < n

instance (n : Nat) (s : Option Nat) : Decidable (slotOk n s) :=
  match s with
  | none => isTrue trivial
  | some x => Nat.decLt x n

def wfCtx (r : Regime) (c : Ctx) : Prop :=
  c.form < r.forms.length ∧
  c.slots.length = r.forms.getD c.form 0 ∧
  none ∈ c.slots ∧
  ∀ s ∈ c.slots, slotOk r.data s

instance (r : Regime) (c : Ctx) : Decidable (wfCtx r c) := by
  unfold wfCtx; infer_instance

def collapsed (r : Regime) (d d' : Nat) : Prop :=
  ∀ c : Ctx, wfCtx r c → (derivable r (plug c d) ↔ derivable r (plug c d'))

def separable (r : Regime) (d d' : Nat) : Prop :=
  ∃ c : Ctx, wfCtx r c ∧
    ¬ (derivable r (plug c d) ↔ derivable r (plug c d'))

theorem separable_not_collapsed {r : Regime} {d d' : Nat}
    (h : separable r d d') : ¬ collapsed r d d' :=
  fun hc => h.elim fun c hc' => hc'.2 (hc c hc'.1)

/-- Connection to `ZeroEquivalence`: for any fixed regime `r` and context `c`,
the Boolean indicator `d ↦ derivableBool r (plug c d)` induces a `ZeroEquivalence.Kernel`
via `relabel binary`, whose `ZeroRel` is `(derivable r (plug c d1) ↔ derivable r (plug c d2))`. -/
def ctxKernel (r : Regime) (c : Ctx) : Kernel Nat Bool :=
  relabel binary (fun d => derivableBool r (plug c d))

theorem oq05_ctxKernel_zeroRel_iff (r : Regime) (c : Ctx) (d1 d2 : Nat) :
    ZeroRel (ctxKernel r c) d1 d2 ↔
      (derivable r (plug c d1) ↔ derivable r (plug c d2)) := by
  unfold ctxKernel
  rw [relabel_zeroRel, binary_zeroRel_iff_eq]
  unfold derivableBool
  constructor
  · intro heq
    constructor
    · intro hd1
      exact of_decide_eq_true (heq ▸ decide_eq_true hd1)
    · intro hd2
      exact of_decide_eq_true (heq.symm ▸ decide_eq_true hd2)
  · intro hiff
    by_cases hd1 : derivable r (plug c d1)
    · have hd2 : derivable r (plug c d2) := hiff.mp hd1
      rw [decide_eq_true hd1, decide_eq_true hd2]
    · have hd2 : ¬ derivable r (plug c d2) := fun h => hd1 (hiff.mpr h)
      rw [decide_eq_false hd1, decide_eq_false hd2]

theorem oq05_ctxKernel_equivalence (r : Regime) (c : Ctx) :
    Equivalence (ZeroRel (ctxKernel r c)) :=
  zeroRel_equivalence (ctxKernel r c)

/-- `collapsed r` is the intersection of `ZeroRel (ctxKernel r c)` over all well-formed
contexts `c`, and therefore forms a `Setoid Nat` and a `ZeroEquivalence.Kernel Nat Prop`. -/
theorem oq05_collapsed_iff_all_ctxKernel_zero (r : Regime) (d1 d2 : Nat) :
    collapsed r d1 d2 ↔ ∀ c : Ctx, wfCtx r c → ZeroRel (ctxKernel r c) d1 d2 := by
  unfold collapsed
  constructor
  · intro h c hwf
    exact (oq05_ctxKernel_zeroRel_iff r c d1 d2).mpr (h c hwf)
  · intro h c hwf
    exact (oq05_ctxKernel_zeroRel_iff r c d1 d2).mp (h c hwf)

def collapsedSetoid (r : Regime) : Setoid Nat where
  r := collapsed r
  iseqv := ⟨
    fun _ _ _ => Iff.rfl,
    fun h c hwf => (h c hwf).symm,
    fun h1 h2 c hwf => (h1 c hwf).trans (h2 c hwf)
  ⟩

def collapsedKernel (r : Regime) : Kernel Nat Prop :=
  fromSetoid (collapsedSetoid r)

theorem oq05_collapsed_equivalence (r : Regime) : Equivalence (collapsed r) :=
  zeroRel_equivalence (collapsedKernel r)

/-- Explicit pair-demand run (`ExplicitQRun n q m`): starting from `q` demanded pairs,
each of `m` rounds increments the pair count by `1` within the `n * (n - 1) / 2` pair capacity. -/
inductive ExplicitQRun (n : Nat) : Nat → Nat → Prop where
  | nil (q : Nat) (hcap : 2 * q ≤ n * (n - 1)) : ExplicitQRun n q 0
  | step {q q' m : Nat} (hinc : q + 1 ≤ q') (hrest : ExplicitQRun n q' m) :
      ExplicitQRun n q (m + 1)

theorem oq05_explicit_pair_round_bound {n q0 m : Nat}
    (hrun : ExplicitQRun n q0 m) :
    2 * (q0 + m) ≤ n * (n - 1) := by
  induction hrun with
  | nil q hcap => omega
  | step hinc _ ih => omega

/-- Quotient-refinement run (`QuotRefRun n c m`): increments the class count `c` by at least `1`
each round up to a fixed carrier capacity `n`. Connected to general `Regime4` transitions via
`regime4_strict_class_count_growth` and `regimeRefinementRun4_to_quotRefRun` (`DER-24`, formerly `OWE-11`). -/
inductive QuotRefRun (n : Nat) : Nat → Nat → Prop where
  | nil (c : Nat) (hcap : c ≤ n) : QuotRefRun n c 0
  | step {c c' m : Nat} (hinc : c + 1 ≤ c') (hrest : QuotRefRun n c' m) :
      QuotRefRun n c (m + 1)

theorem oq05_quotient_refinement_bound {n c0 m : Nat}
    (hrun : QuotRefRun n c0 m) :
    c0 + m ≤ n := by
  induction hrun with
  | nil c hcap => omega
  | step hinc _ ih => omega

theorem oq05_quotient_refinement_from_one {n c0 m : Nat}
    (hc0 : 1 ≤ c0) (hrun : QuotRefRun n c0 m) :
    m ≤ n - 1 := by
  have hb := oq05_quotient_refinement_bound hrun
  omega

/-- For every carrier size `n ≥ 3`, the quotient-refinement bound `n - 1` is strictly
smaller than the explicit pair-demand bound `n * (n - 1) / 2` (stated division-free as
`2 * (n - 1) < n * (n - 1)`). -/
theorem oq05_strict_gap_for_n_ge_3 (n : Nat) (hn : 3 ≤ n) :
    2 * (n - 1) < n * (n - 1) := by
  have h1 : 1 ≤ n - 1 := by omega
  have h2 : 2 * (n - 1) < 3 * (n - 1) := by omega
  have h3 : 3 * (n - 1) ≤ n * (n - 1) := Nat.mul_le_mul_right (n - 1) hn
  omega

/-- Concrete `n = 3` witness (`R3_after_round1`): after Round 1 separates `(0, 1)` on `n = 3`
by admitting the unary mark `(0, [0])` of arity 1, the single context `ctxUnary0 = ⟨0, [none]⟩`
separates `(0, 1)` AND simultaneously separates `(0, 2)`, leaving only `(1, 2)` collapsed. -/
def R3_after_round1 : Regime := ⟨3, [1], [(0, [0])], [], [(0, 1)]⟩

def ctxUnary0 : Ctx := ⟨0, [none]⟩

theorem oq05_n3_unary_splits_two_pairs :
    wfCtx R3_after_round1 ctxUnary0 ∧
    separable R3_after_round1 0 1 ∧
    separable R3_after_round1 0 2 ∧
    collapsed R3_after_round1 1 2 := by
  refine ⟨by decide, ⟨ctxUnary0, by decide, by decide⟩, ⟨ctxUnary0, by decide, by decide⟩, ?_⟩
  intro c hwf
  rcases c with ⟨f, slots⟩
  rcases hwf with ⟨hf, hlen, hnone, _⟩
  have hf0 : f = 0 := by change f < 1 at hf; omega
  subst hf0
  have hlen1 : slots.length = 1 := hlen
  match slots, hlen1 with
  | [s], _ =>
    have hs : s = none := by
      cases hnone with
      | head => rfl
      | tail _ h => cases h
    subst hs
    decide

/-- **OQ-05 General `Regime4` Transition-to-Class-Count Growth Bridge (`DER-24`, formerly `OWE-11`):**
Decidable equivalence `collapsed4Bool` over finite well-formed contexts `allWfCtxs4`,
canonical class-representative counter `regimeClassCount4`, strict refinement growth
`regime4_strict_class_count_growth`, constructive fresh-unary transition
`stepFreshUnary4_strict_transition`, and multi-round bound `regimeRefinementRun4_round_bound`. -/
theorem oq05_collapsed4_iff_collapsed4Bool (r : Regime4) (d d' : Nat) :
    collapsed4 r d d' ↔ collapsed4Bool r d d' = true :=
  collapsed4_iff_collapsed4Bool r d d'

theorem oq05_separable4_iff_collapsed4Bool_false (r : Regime4) (d d' : Nat) :
    separable4 r d d' ↔ collapsed4Bool r d d' = false :=
  separable4_iff_collapsed4Bool_false r d d'

theorem oq05_regime4_strict_class_count_growth {r s : Regime4}
    (h : StrictRegimeTransition4 r s) :
    regimeClassCount4 r + 1 ≤ regimeClassCount4 s ∧
    regimeClassCount4 s ≤ s.data :=
  regime4_strict_class_count_growth h

theorem oq05_stepFreshUnary4_class_count_growth (r : Regime4)
    (hwf : ∀ p ∈ r.insts, p.1 < r.forms.length)
    {target other : Nat} (ht : target < r.data) (ho : other < r.data)
    (hcol : collapsed4 r target other) (hne : target ≠ other) :
    regimeClassCount4 r + 1 ≤ regimeClassCount4 (stepFreshUnary4 r target) ∧
    regimeClassCount4 (stepFreshUnary4 r target) ≤ r.data :=
  stepFreshUnary4_class_count_growth r hwf ht ho hcol hne

theorem oq05_regimeRefinementRun4_round_bound {r : Regime4} {m : Nat}
    (hdata : 1 ≤ r.data) (hrun : RegimeRefinementRun4 r m) :
    m ≤ r.data - 1 :=
  regimeRefinementRun4_round_bound hdata hrun

theorem oq05_rt09_class_count_comparison :
    regimeClassCount4 R3_round1 = 2 ∧
    regimeClassCount4 R3_round2_recollapse = 2 ∧
    regimeClassCount4 R3_round2_fresh = 3 :=
  rt09_class_count_comparison


/-! =========================================================================
    SECTION 2: OQ-06 — Constructive `history_report_criterion_fin` (Zero `Classical.choice`)
    ========================================================================= -/

/-- Constructive decoder over a finite history list `H : List Hist` using `List.find?`
instead of `Classical.choose` (`B/atlas/finite_obstruction_calculus/genesis/lean4/Paper.lean:24-27`). -/
def decodeFin {Hist V S : Type} [DecidableEq V]
    (H : List Hist) (report : Hist → V) (state : Hist → S) (defaultS : S) (v : V) : S :=
  match H.find? (fun h => report h == v) with
  | some h => state h
  | none => defaultS

/-- Forward direction: any decoding function `decode : V → S` valid on `H` forces `state`
to be constant on `report`-fibers within `H`. -/
theorem decode_implies_fiber_const {Hist V S : Type}
    (H : List Hist) (report : Hist → V) (state : Hist → S)
    (hex : ∃ decode : V → S, ∀ h ∈ H, decode (report h) = state h) :
    ∀ h1 ∈ H, ∀ h2 ∈ H, report h1 = report h2 → state h1 = state h2 := by
  rcases hex with ⟨decode, hdec⟩
  intro h1 hh1 h2 hh2 hrep
  rw [← hdec h1 hh1, ← hdec h2 hh2, hrep]

/-- Backward direction: if `state` is constant on `report`-fibers within `H`, then
`decodeFin H report state defaultS` constructively recovers `state h` for every `h ∈ H`
without `Classical.choice`. -/
theorem fiber_const_implies_decodeFin_exact {Hist V S : Type} [DecidableEq V]
    (H : List Hist) (report : Hist → V) (state : Hist → S) (defaultS : S)
    (hfib : ∀ h1 ∈ H, ∀ h2 ∈ H, report h1 = report h2 → state h1 = state h2) :
    ∀ h ∈ H, decodeFin H report state defaultS (report h) = state h := by
  induction H with
  | nil =>
      intro h hh
      cases hh
  | cons head tail ih =>
      intro h hh
      unfold decodeFin
      simp only [List.find?]
      cases hbeq : (report head == report h) with
      | true =>
          have hrep : report head = report h := eq_of_beq hbeq
          exact hfib head (List.Mem.head _) h hh hrep
      | false =>
          cases hh with
          | head =>
              have hself : (report head == report head) = true := beq_self_eq_true (report head)
              rw [hself] at hbeq
              cases hbeq
          | tail _ hmem =>
              have hfib_tail : ∀ h1 ∈ tail, ∀ h2 ∈ tail, report h1 = report h2 → state h1 = state h2 :=
                fun h1 hh1 h2 hh2 hr =>
                  hfib h1 (List.Mem.tail _ hh1) h2 (List.Mem.tail _ hh2) hr
              exact ih hfib_tail h hmem

/-- **OQ-06 Main Theorem (`oq06_history_report_criterion_fin`):** Constructive equivalence
between report factorizability on a finite history list `H` and fiber constancy of `state`
with respect to `report`, derived with zero `Classical.choice`, zero `propext`, and zero `Quot.sound`. -/
theorem oq06_history_report_criterion_fin {Hist V S : Type} [DecidableEq V]
    (H : List Hist) (report : Hist → V) (state : Hist → S) (defaultS : S) :
    (∃ decode : V → S, ∀ h ∈ H, decode (report h) = state h) ↔
    (∀ h1 ∈ H, ∀ h2 ∈ H, report h1 = report h2 → state h1 = state h2) :=
  ⟨decode_implies_fiber_const H report state,
   fun hfib => ⟨decodeFin H report state defaultS,
     fiber_const_implies_decodeFin_exact H report state defaultS hfib⟩⟩


/-! =========================================================================
    SECTION 3: OQ-07 — Positive L1 Weights: Non-Forcing vs Symmetry Forcing
    ========================================================================= -/

abbrev Weight3 := Nat × Nat × Nat
abbrev Cochain3 := Int × Int × Int

def validRepair : Cochain3 → Prop
  | (v1, v2, v3) => v1 + v2 + v3 = 1

instance (v : Cochain3) : Decidable (validRepair v) := by
  rcases v with ⟨v1, v2, v3⟩
  unfold validRepair
  infer_instance

def weightedL1 : Weight3 → Cochain3 → Nat
  | (w1, w2, w3), (v1, v2, v3) =>
      w1 * v1.natAbs + w2 * v2.natAbs + w3 * v3.natAbs

def wAsym1 : Weight3 := (1, 2, 2)
def wAsym2 : Weight3 := (2, 1, 2)

def basis1 : Cochain3 := (1, 0, 0)
def basis2 : Cochain3 := (0, 1, 0)
def basis3 : Cochain3 := (0, 0, 1)

def rotEdge : Cochain3 → Cochain3
  | (v1, v2, v3) => (v2, v3, v1)

theorem rotEdge_preserves_validRepair (v : Cochain3) :
    validRepair (rotEdge v) ↔ validRepair v := by
  rcases v with ⟨v1, v2, v3⟩
  simp only [validRepair, rotEdge]
  omega

/-- **OQ-07 Theorem 1 (`oq07_weights_not_forced_without_symmetry`):**
On the 3-edge cycle with coboundary constraint `v1 + v2 + v3 = 1`:
  1. For positive weights `wAsym1 = (1, 2, 2)`, `basis1 = (1, 0, 0)` has cost `1`, while
     every other valid repair `v ≠ basis1` in `Int × Int × Int` has cost `≥ 2`.
  2. For positive weights `wAsym2 = (2, 1, 2)`, `basis2 = (0, 1, 0)` has cost `1`, while
     every other valid repair `v ≠ basis2` in `Int × Int × Int` has cost `≥ 2`.
Hence positive L1 weights select distinct unique minimizers and are not forced without symmetry. -/
theorem oq07_weights_not_forced_without_symmetry :
    (validRepair basis1 ∧ weightedL1 wAsym1 basis1 = 1 ∧
      ∀ v : Cochain3, validRepair v → v ≠ basis1 → 2 ≤ weightedL1 wAsym1 v) ∧
    (validRepair basis2 ∧ weightedL1 wAsym2 basis2 = 1 ∧
      ∀ v : Cochain3, validRepair v → v ≠ basis2 → 2 ≤ weightedL1 wAsym2 v) := by
  refine ⟨⟨by decide, by decide, ?_⟩, ⟨by decide, by decide, ?_⟩⟩
  · intro ⟨v1, v2, v3⟩ hval hne
    simp only [validRepair] at hval
    simp only [weightedL1, wAsym1]
    if hv2 : v2 = 0 then
      if hv3 : v3 = 0 then
        have hv1 : v1 = 1 := by omega
        exfalso
        exact hne (by subst hv1 hv2 hv3; rfl)
      else
        omega
    else
      omega
  · intro ⟨v1, v2, v3⟩ hval hne
    simp only [validRepair] at hval
    simp only [weightedL1, wAsym2]
    if hv1 : v1 = 0 then
      if hv3 : v3 = 0 then
        have hv2 : v2 = 1 := by omega
        exfalso
        exact hne (by subst hv1 hv2 hv3; rfl)
      else
        omega
    else
      omega

/-- **OQ-07 Theorem 2 (`oq07_transitive_symmetry_forces_equal_weights`):**
If the weighted L1 cost `weightedL1 w` is invariant under the cyclic edge permutation
`rotEdge (v1, v2, v3) = (v2, v3, v1)` on valid repairs, then evaluating on `basis1 = (1, 0, 0)`
and `basis2 = (0, 1, 0)` forces `w1 = w2 ∧ w2 = w3`. -/
theorem oq07_transitive_symmetry_forces_equal_weights (w : Weight3)
    (hinv : ∀ v : Cochain3, validRepair v → weightedL1 w (rotEdge v) = weightedL1 w v) :
    w.1 = w.2.1 ∧ w.2.1 = w.2.2 := by
  rcases w with ⟨w1, w2, w3⟩
  have h1 : w3 = w1 := by
    have := hinv basis1 (by decide)
    simpa [weightedL1, rotEdge, basis1] using this
  have h2 : w1 = w2 := by
    have := hinv basis2 (by decide)
    simpa [weightedL1, rotEdge, basis2] using this
  exact ⟨h2, h2.symm.trans h1.symm⟩


/-! =========================================================================
    SECTION 4: OQ-08 — State-Refinement Morphism (`WDP-CH01-D03` vs `Horizon.lean`)
    ========================================================================= -/

inductive HEv where
  | admitTok  (t : Nat)
  | require   (i j : Nat)
  | addView   (v : Nat)
  | setBudget (b : Nat)
deriving Repr, DecidableEq

/-- Simplified 1-gate `Horizon` model (`HWorld`), where `.admitTok` and `.require` are unpriced
and only `.addView` is gated by `1 ≤ budget` (omitting legacy `Represented.World`'s novelty,
`increaseB`, and `augLicensed` guards; see `lean/InternalMetatheory.lean` (`DER-19`) and `OWE-12`). -/
structure HWorld where
  toks   : List Nat
  reqs   : List (Nat × Nat)
  views  : List Nat
  budget : Nat
deriving Repr, DecidableEq

def stepHWorld (w : HWorld) : HEv → HWorld
  | .admitTok t =>
      if t ∈ w.toks then w else { w with toks := w.toks ++ [t] }
  | .require i j =>
      if (i, j) ∈ w.reqs then w else { w with reqs := w.reqs ++ [(i, j)] }
  | .addView v =>
      if 1 ≤ w.budget then
        { w with views := insertNew w.views v, budget := w.budget - 1 }
      else w
  | .setBudget b =>
      { w with budget := b }

/-- 5-gate WDP Grounding Span costs (`WDP-CH01-D03`):
  - `cSup`: gate 1 (`g_sup`) external supply cost
  - `cAdm`: gate 2 (`g_adm`) token-erased admission cost
  - `cRet`: gate 3 (`g_ret`) asymmetry-priced retention cost
  - `cEv` : gate 4/5 (`g_ev`, `g_auth`) quotient-defect evaluation + receipt emission cost -/
structure GateCosts where
  cSup : Nat
  cAdm : Nat
  cRet : Nat
  cEv  : Nat
deriving Repr, DecidableEq

structure WDPWorld where
  sup      : List Nat
  adm      : List Nat
  ret      : List (Nat × Nat)
  views    : List Nat
  ledger   : Nat
  receipts : Nat
deriving Repr, DecidableEq

def stepWDPWorld (costs : GateCosts) (w : WDPWorld) : HEv → WDPWorld
  | .admitTok t =>
      let cost := costs.cSup + costs.cAdm
      if cost ≤ w.ledger then
        let adm' := if t ∈ w.adm then w.adm else w.adm ++ [t]
        { w with sup := w.sup ++ [t], adm := adm', ledger := w.ledger - cost }
      else w
  | .require i j =>
      if costs.cRet ≤ w.ledger then
        let ret' := if (i, j) ∈ w.ret then w.ret else w.ret ++ [(i, j)]
        { w with ret := ret', ledger := w.ledger - costs.cRet }
      else w
  | .addView v =>
      if costs.cEv ≤ w.ledger then
        { w with
            views := insertNew w.views v,
            ledger := w.ledger - costs.cEv,
            receipts := w.receipts + 1 }
      else w
  | .setBudget b =>
      { w with ledger := b }

/-- Forgetful state-refinement projection from `WDPWorld` to `HWorld`
(forgetting the raw supply log `sup` and diagnostic receipt count `receipts`). -/
def projToHorizon (w : WDPWorld) : HWorld :=
  { toks := w.adm, reqs := w.ret, views := w.views, budget := w.ledger }

def horizonSpecializationCosts : GateCosts := ⟨0, 0, 0, 1⟩

/-- **OQ-08 Theorem 1 (`oq08_refinement_commutes_at_zero_adm_ret_cost`, simplified model):**
When the simplified 5-gate `WDPWorld` costs are specialized to `cSup = 0, cAdm = 0, cRet = 0, cEv = 1`,
`projToHorizon` commutes with every event `ev : HEv` on the simplified `HWorld` model. -/
theorem oq08_refinement_commutes_at_zero_adm_ret_cost (w : WDPWorld) (ev : HEv) :
    projToHorizon (stepWDPWorld horizonSpecializationCosts w ev) =
      stepHWorld (projToHorizon w) ev := by
  cases ev with
  | admitTok t =>
      by_cases ht : t ∈ w.adm <;>
        simp [stepWDPWorld, horizonSpecializationCosts, stepHWorld, projToHorizon, ht]
  | require i j =>
      by_cases hr : (i, j) ∈ w.ret <;>
        simp [stepWDPWorld, horizonSpecializationCosts, stepHWorld, projToHorizon, hr]
  | addView v =>
      by_cases hb : 1 ≤ w.ledger <;>
        simp [stepWDPWorld, horizonSpecializationCosts, stepHWorld, projToHorizon, hb]
  | setBudget b =>
      rfl

/-- Multi-step trace commutation corollary for arbitrary event lists `evs : List HEv`. -/
theorem oq08_trace_commutes_at_zero_adm_ret_cost (w : WDPWorld) (evs : List HEv) :
    projToHorizon (evs.foldl (stepWDPWorld horizonSpecializationCosts) w) =
      evs.foldl stepHWorld (projToHorizon w) := by
  induction evs generalizing w with
  | nil => rfl
  | cons ev rest ih =>
      simp only [List.foldl_cons]
      rw [ih (stepWDPWorld horizonSpecializationCosts w ev)]
      rw [oq08_refinement_commutes_at_zero_adm_ret_cost w ev]

/-- **OQ-08 Theorem 2 (`oq08_five_gate_strictly_finer_when_adm_priced`):**
When `cAdm = 1` (priced admission gate `g_adm`) or `cRet = 1` (priced retention gate `g_ret`)
at `ledger = 0`, `stepWDPWorld` refuses `.admitTok 0` (resp. `.require 0 1`) with
`REFUSE_INSUFFICIENT_FUNDS`, whereas `stepHWorld` admits them for free. Thus the 5-gate
WDP span is strictly finer whenever non-view gates carry positive prices. -/
def wdpEmptyZeroLedger : WDPWorld := ⟨[], [], [], [], 0, 0⟩

theorem oq08_five_gate_strictly_finer_when_adm_priced :
    (stepWDPWorld ⟨0, 1, 0, 1⟩ wdpEmptyZeroLedger (.admitTok 0)).adm = [] ∧
    (stepHWorld (projToHorizon wdpEmptyZeroLedger) (.admitTok 0)).toks = [0] ∧
    projToHorizon (stepWDPWorld ⟨0, 1, 0, 1⟩ wdpEmptyZeroLedger (.admitTok 0)) ≠
      stepHWorld (projToHorizon wdpEmptyZeroLedger) (.admitTok 0) ∧
    projToHorizon (stepWDPWorld ⟨0, 0, 1, 1⟩ wdpEmptyZeroLedger (.require 0 1)) ≠
      stepHWorld (projToHorizon wdpEmptyZeroLedger) (.require 0 1) := by
  decide

end MinimalChainAuditOQ05To08

#print axioms MinimalChainAuditOQ05To08.oq05_ctxKernel_zeroRel_iff
#print axioms MinimalChainAuditOQ05To08.oq05_collapsed_equivalence
#print axioms MinimalChainAuditOQ05To08.oq05_explicit_pair_round_bound
#print axioms MinimalChainAuditOQ05To08.oq05_quotient_refinement_from_one
#print axioms MinimalChainAuditOQ05To08.oq05_strict_gap_for_n_ge_3
#print axioms MinimalChainAuditOQ05To08.oq05_n3_unary_splits_two_pairs
#print axioms MinimalChainAuditOQ05To08.oq05_collapsed4_iff_collapsed4Bool
#print axioms MinimalChainAuditOQ05To08.oq05_separable4_iff_collapsed4Bool_false
#print axioms MinimalChainAuditOQ05To08.oq05_regime4_strict_class_count_growth
#print axioms MinimalChainAuditOQ05To08.oq05_stepFreshUnary4_class_count_growth
#print axioms MinimalChainAuditOQ05To08.oq05_regimeRefinementRun4_round_bound
#print axioms MinimalChainAuditOQ05To08.oq05_rt09_class_count_comparison
#print axioms MinimalChainAuditOQ05To08.oq06_history_report_criterion_fin
#print axioms MinimalChainAuditOQ05To08.oq07_weights_not_forced_without_symmetry
#print axioms MinimalChainAuditOQ05To08.oq07_transitive_symmetry_forces_equal_weights
#print axioms MinimalChainAuditOQ05To08.oq08_refinement_commutes_at_zero_adm_ret_cost
#print axioms MinimalChainAuditOQ05To08.oq08_trace_commutes_at_zero_adm_ret_cost
#print axioms MinimalChainAuditOQ05To08.oq08_five_gate_strictly_finer_when_adm_priced

