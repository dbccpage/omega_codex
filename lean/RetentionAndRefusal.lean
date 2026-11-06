import TorsorAndOperations
import ZeroEquivalence

/-!
# Refusal modes, memory retention, choice-free decoding, and closure symmetry (Slice 3)

Reconstructs the five-mode refusal hierarchy, the 4-condition characterization
of the 16 / 1024 and 4 / 1024 binary memory packets (OQ-03, including the RT-02
multi-step idle drift theorems), constructive finite-history decoding (OQ-06,
including RT-10 on-image invariance and RT-05 global-to-finite congruence),
internal transposition symmetry-breaking and common refinement (RT-06), and the
5-gate WDP-to-Horizon state-refinement morphism (OQ-08).
-/
set_option autoImplicit false

namespace OmegaCodex.RetentionAndRefusal

open OmegaCodex.PrimitiveDifference
open OmegaCodex.ZeroEquivalence
open OmegaCodex.TorsorAndOperations

/-! ## Section 1: Five-mode refusal hierarchy (Refusal.lean) -/

inductive RMode where
  | silent
  | metaMarker
  | fact
  | reifyUntagged
  | reifyTagged
deriving DecidableEq, Repr

structure RState where
  data     : List Nat
  tags     : List Nat
  refusals : Nat
deriving DecidableEq, Repr

def stepRefusal (m : RMode) (s : RState) (t : Nat) : RState :=
  if t ∈ s.data then
    match m with
    | .silent        => s
    | .metaMarker    => s
    | .fact          => { s with refusals := s.refusals + 1 }
    | .reifyUntagged => { s with data := s.data ++ [s.data.length] }
    | .reifyTagged   =>
        { s with
            data := s.data ++ [s.data.length],
            tags := s.tags ++ [s.data.length] }
  else
    { s with data := s.data ++ [t] }

theorem silent_eq_metaMarker (s : RState) (t : Nat) :
    stepRefusal .silent s t = stepRefusal .metaMarker s t := by
  unfold stepRefusal
  split <;> rfl

theorem nonreify_data_preserved_on_dup (m : RMode) (s : RState) (t : Nat)
    (ht : t ∈ s.data)
    (hm : m = .silent ∨ m = .metaMarker ∨ m = .fact) :
    (stepRefusal m s t).data = s.data := by
  unfold stepRefusal
  rw [if_pos ht]
  rcases hm with rfl | rfl | rfl <;> rfl

theorem fact_state_changes_on_dup (s : RState) (t : Nat) (ht : t ∈ s.data) :
    (stepRefusal .fact s t).refusals = s.refusals + 1 ∧
    (stepRefusal .fact s t).data = s.data ∧
    stepRefusal .fact s t ≠ s := by
  unfold stepRefusal
  rw [if_pos ht]
  refine ⟨rfl, rfl, ?_⟩
  intro heq
  have h1 : s.refusals + 1 = s.refusals := congrArg RState.refusals heq
  omega

theorem reifyUntagged_grows_carrier_on_dup (s : RState) (t : Nat) (ht : t ∈ s.data) :
    (stepRefusal .reifyUntagged s t).data.length = s.data.length + 1 := by
  unfold stepRefusal
  rw [if_pos ht]
  simp [List.length_append]

theorem tag_separates_reified_modes (s : RState) (t : Nat) (ht : t ∈ s.data) :
    (stepRefusal .reifyTagged s t).data = (stepRefusal .reifyUntagged s t).data ∧
    (stepRefusal .reifyTagged s t).tags ≠ (stepRefusal .reifyUntagged s t).tags := by
  unfold stepRefusal
  rw [if_pos ht, if_pos ht]
  refine ⟨rfl, ?_⟩
  intro heq
  have hlen : (s.tags ++ [s.data.length]).length = s.tags.length :=
    congrArg List.length heq
  rw [List.length_append, List.length_singleton] at hlen
  omega

/-! ## Section 2: OQ-03 4-Condition Characterization & RT-02 Multi-Step Idle Drift -/

def evalU (uMask : Nat) (m i : Bool) : Bool :=
  let idx := (if m then 2 else 0) + (if i then 1 else 0)
  ((uMask >>> idx) &&& 1) == 1

def evalR (rMask : Nat) (m : Bool) : Bool :=
  let idx := if m then 1 else 0
  ((rMask >>> idx) &&& 1) == 1

def evalApprox (apMask : Nat) (o1 o2 : Bool) : Bool :=
  let idx := (if o1 then 2 else 0) + (if o2 then 1 else 0)
  ((apMask >>> idx) &&& 1) == 1

def retainsDistinction (uMask rMask apMask : Nat) : Bool :=
  let m0 := evalU uMask (evalU uMask false false) false
  let m1 := evalU uMask (evalU uMask false true) false
  let o0 := evalR rMask m0
  let o1 := evalR rMask m1
  evalApprox apMask o0 o0 && evalApprox apMask o1 o1 && !(evalApprox apMask o0 o1)

def cond1WriteSep (uMask : Nat) : Bool :=
  evalU uMask false false != evalU uMask false true

def cond2IdleInj (uMask : Nat) : Bool :=
  evalU uMask false false != evalU uMask true false

def cond3ReadoutInj (rMask : Nat) : Bool :=
  evalR rMask false != evalR rMask true

def cond4ReflexiveApart (uMask rMask apMask : Nat) : Bool :=
  let o0 := evalR rMask (evalU uMask (evalU uMask false false) false)
  let o1 := evalR rMask (evalU uMask (evalU uMask false true) false)
  evalApprox apMask false false && evalApprox apMask true true && !(evalApprox apMask o0 o1)

def charFourConditions (uMask rMask apMask : Nat) : Bool :=
  cond1WriteSep uMask && cond2IdleInj uMask && cond3ReadoutInj rMask &&
    cond4ReflexiveApart uMask rMask apMask

def cond2PrimeIdleId (uMask : Nat) : Bool :=
  evalU uMask false false == false && evalU uMask true false == true

def cond4PrimeDiagEq (apMask : Nat) : Bool :=
  evalApprox apMask false false && !(evalApprox apMask false true) &&
    !(evalApprox apMask true false) && evalApprox apMask true true

def charDriftFreeSymmetric (uMask rMask apMask : Nat) : Bool :=
  cond1WriteSep uMask && cond2PrimeIdleId uMask && cond3ReadoutInj rMask &&
    cond4PrimeDiagEq apMask

def countPackets (pred : Nat → Nat → Nat → Bool) : Nat :=
  (List.range 16).foldl (fun accU u =>
    (List.range 4).foldl (fun accR r =>
      (List.range 16).foldl (fun accA a =>
        if pred u r a then accA + 1 else accA) accR) accU) 0

set_option maxRecDepth 20000

theorem oq03_retaining_count_eq_16 : countPackets retainsDistinction = 16 := by decide

theorem oq03_char_four_count_eq_16 : countPackets charFourConditions = 16 := by decide

theorem oq03_retains_iff_four_conditions :
    ∀ u ∈ List.range 16, ∀ r ∈ List.range 4, ∀ a ∈ List.range 16,
      retainsDistinction u r a = charFourConditions u r a := by decide

theorem oq03_drift_free_symmetric_count_eq_4 :
    countPackets charDriftFreeSymmetric = 4 := by decide

theorem oq03_drift_free_implies_retains :
    ∀ u ∈ List.range 16, ∀ r ∈ List.range 4, ∀ a ∈ List.range 16,
      charDriftFreeSymmetric u r a = true → retainsDistinction u r a = true := by decide

theorem oq03_factor_counts :
    ((List.range 16).filter (fun u => cond1WriteSep u && cond2IdleInj u)).length = 4 ∧
    ((List.range 16).filter (fun u => cond1WriteSep u && cond2PrimeIdleId u)).length = 2 ∧
    ((List.range 4).filter cond3ReadoutInj).length = 2 ∧
    ((List.range 16).filter cond4PrimeDiagEq).length = 1 := by decide

theorem oq03_condition_independence_witnesses :
    (cond1WriteSep 12 = false ∧ cond2IdleInj 12 = true ∧ cond3ReadoutInj 2 = true ∧
      cond4PrimeDiagEq 9 = true ∧ retainsDistinction 12 2 9 = false) ∧
    (cond1WriteSep 10 = true ∧ cond2IdleInj 10 = false ∧ cond3ReadoutInj 2 = true ∧
      cond4PrimeDiagEq 9 = true ∧ retainsDistinction 10 2 9 = false) ∧
    (cond1WriteSep 14 = true ∧ cond2IdleInj 14 = true ∧ cond3ReadoutInj 0 = false ∧
      cond4PrimeDiagEq 9 = true ∧ retainsDistinction 14 0 9 = false) ∧
    (cond1WriteSep 14 = true ∧ cond2IdleInj 14 = true ∧ cond3ReadoutInj 2 = true ∧
      cond4ReflexiveApart 14 2 15 = false ∧ retainsDistinction 14 2 15 = false) ∧
    (charFourConditions 9 2 9 = true ∧ cond2PrimeIdleId 9 = false ∧
      retainsDistinction 9 2 9 = true) := by decide

def idleRun (uMask : Nat) (m : Bool) : Nat → Bool
  | 0 => m
  | k + 1 => evalU uMask (idleRun uMask m k) false

def readoutAfterIdle (uMask rMask : Nat) (i : Bool) (steps : Nat) : Bool :=
  evalR rMask (idleRun uMask (evalU uMask false i) steps)

/-- RT-02 witness: `uMask = 9` (`u(m, false) = !m`) satisfies the 1-step retention
test `retainsDistinction 9 2 9 = true`, but flips its output between `1` and `2`
idle steps. -/
theorem rt02_idle_drift_flips_on_two_steps :
    retainsDistinction 9 2 9 = true ∧
    readoutAfterIdle 9 2 false 1 ≠ readoutAfterIdle 9 2 false 2 ∧
    readoutAfterIdle 9 2 true 1 ≠ readoutAfterIdle 9 2 true 2 := by decide

/-- RT-02 time-invariance theorem: under `cond2PrimeIdleId uMask = true`, the
memory state is invariant across all idle durations `steps : Nat`. -/
theorem rt02_drift_free_all_idle_steps (uMask : Nat)
    (hC2p : cond2PrimeIdleId uMask = true) (m : Bool) (steps : Nat) :
    idleRun uMask m steps = m := by
  have h0 : evalU uMask false false = false := by
    unfold cond2PrimeIdleId at hC2p
    cases h : evalU uMask false false <;> simp [h] at hC2p <;> rfl
  have h1 : evalU uMask true false = true := by
    unfold cond2PrimeIdleId at hC2p
    cases h : evalU uMask true false <;> simp [h0, h] at hC2p <;> rfl
  induction steps with
  | zero => rfl
  | succ k ih =>
      simp only [idleRun, ih]
      cases m
      · exact h0
      · exact h1

/-! ## Section 3: OQ-06 Constructive decodeFin, RT-10 Invariance, & RT-05 Bridge -/

def decodeFin {Hist V S : Type} [DecidableEq V]
    (H : List Hist) (report : Hist → V) (state : Hist → S) (defaultS : S) (v : V) : S :=
  match H.find? (fun h => report h == v) with
  | some h => state h
  | none => defaultS

theorem decode_implies_fiber_const {Hist V S : Type}
    (H : List Hist) (report : Hist → V) (state : Hist → S)
    (hex : ∃ decode : V → S, ∀ h ∈ H, decode (report h) = state h) :
    ∀ h1 ∈ H, ∀ h2 ∈ H, report h1 = report h2 → state h1 = state h2 := by
  rcases hex with ⟨decode, hdec⟩
  intro h1 hh1 h2 hh2 hrep
  rw [← hdec h1 hh1, ← hdec h2 hh2, hrep]

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

theorem oq06_history_report_criterion_fin {Hist V S : Type} [DecidableEq V]
    (H : List Hist) (report : Hist → V) (state : Hist → S) (defaultS : S) :
    (∃ decode : V → S, ∀ h ∈ H, decode (report h) = state h) ↔
    (∀ h1 ∈ H, ∀ h2 ∈ H, report h1 = report h2 → state h1 = state h2) :=
  ⟨decode_implies_fiber_const H report state,
   fun hfib => ⟨decodeFin H report state defaultS,
     fiber_const_implies_decodeFin_exact H report state defaultS hfib⟩⟩

/-- RT-10 on-image invariance: when `fiber_const` holds on `H1`, `decodeFin` on
any image value `report h0` (`h0 ∈ H1`) is independent of both the ordering/duplication
of `H1` vs `H2` and the fallback values `d1, d2`. -/
theorem rt10_decodeFin_order_and_default_invariant_on_image {Hist V S : Type} [DecidableEq V]
    (H1 H2 : List Hist) (report : Hist → V) (state : Hist → S) (d1 d2 : S)
    (helem : ∀ h, h ∈ H1 ↔ h ∈ H2)
    (hfib1 : ∀ h1 ∈ H1, ∀ h2 ∈ H1, report h1 = report h2 → state h1 = state h2)
    {h0 : Hist} (hh0 : h0 ∈ H1) :
    decodeFin H1 report state d1 (report h0) =
      decodeFin H2 report state d2 (report h0) := by
  have hfib2 : ∀ h1 ∈ H2, ∀ h2 ∈ H2, report h1 = report h2 → state h1 = state h2 :=
    fun a ha b hb hr => hfib1 a ((helem a).mpr ha) b ((helem b).mpr hb) hr
  have e1 := fiber_const_implies_decodeFin_exact H1 report state d1 hfib1 h0 hh0
  have e2 := fiber_const_implies_decodeFin_exact H2 report state d2 hfib2 h0 ((helem h0).mp hh0)
  exact e1.trans e2.symm

/-- RT-10 off-image fallback: for `v` outside the report image of `H`,
`decodeFin` returns `defaultS` regardless of `H`'s ordering. -/
theorem rt10_decodeFin_off_image_eq_default {Hist V S : Type} [DecidableEq V]
    (H : List Hist) (report : Hist → V) (state : Hist → S) (defaultS : S) (v : V)
    (hoff : ∀ h ∈ H, report h ≠ v) :
    decodeFin H report state defaultS v = defaultS := by
  induction H with
  | nil => rfl
  | cons head tail ih =>
      unfold decodeFin
      simp only [List.find?]
      cases hbeq : (report head == v) with
      | true =>
          exact False.elim (hoff head (List.Mem.head _) (eq_of_beq hbeq))
      | false =>
          exact ih (fun h hh => hoff h (List.Mem.tail _ hh))

/-- RT-05 bridge (`ObsDescent.lean` §9): global type-level `UnaryCongruent S φ` is
equivalent to fiber constancy across all finite lists `D : List α`. -/
theorem rt05_unaryCongruent_iff_fiberConstant_all {α γ : Type}
    (S : Setoid α) (φ : α → γ) :
    UnaryCongruent S φ ↔
      ∀ D : List α, ∀ x ∈ D, ∀ y ∈ D, S.r x y → φ x = φ y := by
  constructor
  · intro h D x _ y _ hxy
    exact h x y hxy
  · intro h x y hxy
    exact h [x, y] x (List.Mem.head _) y (List.Mem.tail _ (List.Mem.head _)) hxy

/-- RT-05 strictness (`ObsDescent.lean` §9): fiber constancy on a single fixed list
`D = [false]` is strictly weaker than global `UnaryCongruent`. -/
theorem rt05_fiberConstant_fixed_D_not_unaryCongruent :
    (∀ x ∈ ([false] : List Bool), ∀ y ∈ ([false] : List Bool),
      (zeroSetoid constantAllZero).r x y → x = y) ∧
    ¬ UnaryCongruent (zeroSetoid constantAllZero) (fun x : Bool => x) := by
  refine ⟨?_, ?_⟩
  · intro x hx y hy _
    cases hx with
    | head =>
        cases hy with
        | head => rfl
        | tail _ hnil => cases hnil
    | tail _ hnil => cases hnil
  · intro h
    have hft : false = true := h false true True.intro
    cases hft

/-! ## Section 4: RT-06 ClosureSymmetry and ResidualClosure -/

def FactorsOn {α β γ : Type} (D : List α) (p : α → β) (q : α → γ) : Prop :=
  ∀ x ∈ D, ∀ y ∈ D, p x = p y → q x = q y

def transpose {α : Type} [DecidableEq α] (a b x : α) : α :=
  if x = a then b else if x = b then a else x

theorem transpose_self_left {α : Type} [DecidableEq α] (a b : α) :
    transpose a b a = b := by
  simp [transpose]

theorem transpose_involutive {α : Type} [DecidableEq α] (a b x : α) :
    transpose a b (transpose a b x) = x := by
  unfold transpose
  by_cases hxa : x = a
  · rw [if_pos hxa]
    by_cases hba : b = a
    · rw [if_pos hba]
      exact hba.trans hxa.symm
    · rw [if_neg hba, if_pos rfl]
      exact hxa.symm
  · rw [if_neg hxa]
    by_cases hxb : x = b
    · rw [if_pos hxb, if_pos rfl]
      exact hxb.symm
    · rw [if_neg hxb, if_neg hxa, if_neg hxb]

/-- RT-06 (`ClosureSymmetry.lean:154-165`): failure of `q` to factor through `p` on
finite dataset `D` is equivalent to the existence of a transposition `transpose a b`
(`a, b ∈ D`) that is an internal symmetry of `p` (`∀ x, p (transpose a b x) = p x`)
but breaks `q` (`q (transpose a b a) ≠ q a`). -/
theorem closure_failure_iff_internal_symmetry_break {α β γ : Type} [DecidableEq α]
    (D : List α) (p : α → β) (q : α → γ) :
    (∃ a ∈ D, ∃ b ∈ D, p a = p b ∧ q a ≠ q b) ↔
    (∃ a ∈ D, ∃ b ∈ D,
      (∀ x, p (transpose a b x) = p x) ∧ q (transpose a b a) ≠ q a) := by
  constructor
  · rintro ⟨a, ha, b, hb, hp, hq⟩
    refine ⟨a, ha, b, hb, ?_, ?_⟩
    · intro x
      unfold transpose
      by_cases hxa : x = a
      · rw [if_pos hxa, hxa]
        exact hp.symm
      · rw [if_neg hxa]
        by_cases hxb : x = b
        · rw [if_pos hxb, hxb]
          exact hp
        · rw [if_neg hxb]
    · rw [transpose_self_left]
      exact Ne.symm hq
  · rintro ⟨a, ha, b, hb, hp_symm, hq_break⟩
    refine ⟨a, ha, b, hb, ?_, ?_⟩
    · have hpa := hp_symm a
      rw [transpose_self_left] at hpa
      exact hpa.symm
    · rw [transpose_self_left] at hq_break
      exact Ne.symm hq_break

def commonRefinement {α β γ : Type} (p : α → β) (q : α → γ) (x : α) : β × γ :=
  (p x, q x)

/-- RT-06 (`ResidualClosure.lean:106-120`): the common refinement `(p, q)` factors
both `p` and `q` on `D` and separates any obstruction pair `(a, b)` where `p a = p b`
and `q a ≠ q b`. -/
theorem common_refinement_closes_current_obstruction {α β γ : Type}
    (D : List α) (p : α → β) (q : α → γ) :
    FactorsOn D (commonRefinement p q) p ∧
    FactorsOn D (commonRefinement p q) q ∧
    (∀ a b, p a = p b → q a ≠ q b →
      commonRefinement p q a ≠ commonRefinement p q b) := by
  refine ⟨?_, ?_, ?_⟩
  · intro x _ y _ h
    exact congrArg Prod.fst h
  · intro x _ y _ h
    exact congrArg Prod.snd h
  · intro a b _ hq heq
    exact hq (congrArg Prod.snd heq)

/-! ## Section 5: OQ-08 5-Gate Priced Boundary Refinement (WDP-CH01-D03 vs Horizon) -/

def insertNewNat (l : List Nat) (a : Nat) : List Nat :=
  if a ∈ l then l else l ++ [a]

inductive HEv where
  | admitTok  (t : Nat)
  | require   (i j : Nat)
  | addView   (v : Nat)
  | setBudget (b : Nat)
deriving Repr, DecidableEq

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
        { w with views := insertNewNat w.views v, budget := w.budget - 1 }
      else w
  | .setBudget b =>
      { w with budget := b }

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
            views := insertNewNat w.views v,
            ledger := w.ledger - costs.cEv,
            receipts := w.receipts + 1 }
      else w
  | .setBudget b =>
      { w with ledger := b }

def projToHorizon (w : WDPWorld) : HWorld :=
  { toks := w.adm, reqs := w.ret, views := w.views, budget := w.ledger }

def horizonSpecializationCosts : GateCosts := ⟨0, 0, 0, 1⟩

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

theorem oq08_trace_commutes_at_zero_adm_ret_cost (w : WDPWorld) (evs : List HEv) :
    projToHorizon (evs.foldl (stepWDPWorld horizonSpecializationCosts) w) =
      evs.foldl stepHWorld (projToHorizon w) := by
  induction evs generalizing w with
  | nil => rfl
  | cons ev rest ih =>
      simp only [List.foldl_cons]
      rw [ih (stepWDPWorld horizonSpecializationCosts w ev)]
      rw [oq08_refinement_commutes_at_zero_adm_ret_cost w ev]

def wdpEmptyZeroLedger : WDPWorld := ⟨[], [], [], [], 0, 0⟩

theorem oq08_five_gate_strictly_finer_when_adm_priced :
    (stepWDPWorld ⟨0, 1, 0, 1⟩ wdpEmptyZeroLedger (.admitTok 0)).adm = [] ∧
    (stepHWorld (projToHorizon wdpEmptyZeroLedger) (.admitTok 0)).toks = [0] ∧
    projToHorizon (stepWDPWorld ⟨0, 1, 0, 1⟩ wdpEmptyZeroLedger (.admitTok 0)) ≠
      stepHWorld (projToHorizon wdpEmptyZeroLedger) (.admitTok 0) ∧
    projToHorizon (stepWDPWorld ⟨0, 0, 1, 1⟩ wdpEmptyZeroLedger (.require 0 1)) ≠
      stepHWorld (projToHorizon wdpEmptyZeroLedger) (.require 0 1) := by
  decide

def stepHWorldGuarded (w : HWorld) : HEv → HWorld
  | .admitTok t =>
      if t ∈ w.toks then w else { w with toks := w.toks ++ [t] }
  | .require i j =>
      if i < w.toks.length ∧ j < w.toks.length ∧ i ≠ j then
        if (i, j) ∈ w.reqs then w else { w with reqs := w.reqs ++ [(i, j)] }
      else w
  | .addView v =>
      if 1 ≤ w.budget ∧ v < w.toks.length then
        { w with views := insertNewNat w.views v, budget := w.budget - 1 }
      else w
  | .setBudget b =>
      { w with budget := b }

def stepWDPWorldGuarded (costs : GateCosts) (w : WDPWorld) : HEv → WDPWorld
  | .admitTok t =>
      let cost := costs.cSup + costs.cAdm
      if cost ≤ w.ledger then
        let adm' := if t ∈ w.adm then w.adm else w.adm ++ [t]
        { w with sup := w.sup ++ [t], adm := adm', ledger := w.ledger - cost }
      else w
  | .require i j =>
      if costs.cRet ≤ w.ledger ∧ i < w.adm.length ∧ j < w.adm.length ∧ i ≠ j then
        let ret' := if (i, j) ∈ w.ret then w.ret else w.ret ++ [(i, j)]
        { w with ret := ret', ledger := w.ledger - costs.cRet }
      else w
  | .addView v =>
      if costs.cEv ≤ w.ledger ∧ v < w.adm.length then
        { w with
            views := insertNewNat w.views v,
            ledger := w.ledger - costs.cEv,
            receipts := w.receipts + 1 }
      else w
  | .setBudget b =>
      { w with ledger := b }

/-- RT-12 guarded refinement (`Horizon.lean` §2–§3): when carrier-bound guards
`i < w.adm.length ∧ j < w.adm.length ∧ i ≠ j` and `v < w.adm.length` are enforced on
`.require` and `.addView`, `projToHorizon` still commutes with `stepWDPWorldGuarded`
at `horizonSpecializationCosts = ⟨0, 0, 0, 1⟩`. -/
theorem rt12_guarded_refinement_commutes_at_zero_adm_ret_cost (w : WDPWorld) (ev : HEv) :
    projToHorizon (stepWDPWorldGuarded horizonSpecializationCosts w ev) =
      stepHWorldGuarded (projToHorizon w) ev := by
  cases ev with
  | admitTok t =>
      by_cases ht : t ∈ w.adm <;>
        simp [stepWDPWorldGuarded, horizonSpecializationCosts, stepHWorldGuarded, projToHorizon, ht]
  | require i j =>
      by_cases hg : i < w.adm.length ∧ j < w.adm.length ∧ i ≠ j
      · by_cases hr : (i, j) ∈ w.ret <;>
          simp [stepWDPWorldGuarded, horizonSpecializationCosts, stepHWorldGuarded,
            projToHorizon, hg, hr]
      · simp [stepWDPWorldGuarded, horizonSpecializationCosts, stepHWorldGuarded,
          projToHorizon, hg]
  | addView v =>
      by_cases hg : 1 ≤ w.ledger ∧ v < w.adm.length <;>
        simp [stepWDPWorldGuarded, horizonSpecializationCosts, stepHWorldGuarded,
          projToHorizon, hg]
  | setBudget b =>
      rfl

end OmegaCodex.RetentionAndRefusal
