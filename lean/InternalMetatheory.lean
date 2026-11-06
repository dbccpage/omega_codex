import TorsorAndOperations
import MinimalSeparation
import RetentionAndRefusal

/-!
# Constitutional initiality, no-outside dichotomy, interpreter diagonal, and acyclicity (Slice 5)

Reconstructs the 6-guard constitutional uniqueness and independence census
(Constitution.lean, Initiality.lean), the effectual-outside dichotomy and panel
re-entry conservation (NoOutside.lean), the diagonal non-exhaustion theorem for
total evaluators and its stage-by-stage persistence (InterpreterBoundary.lean),
and strict-measure acyclicity and no-return (WDP-CH06-P01, Genesis section 8).
-/
set_option autoImplicit false

namespace OmegaCodex.InternalMetatheory

open OmegaCodex.PrimitiveDifference
open OmegaCodex.TorsorAndOperations
open OmegaCodex.MinimalSeparation
open OmegaCodex.RetentionAndRefusal

universe u

/-! ## Section 1: Constitutional 6-guard initiality and independence -/

def bitAt (mask idx : Nat) : Bool :=
  ((mask >>> idx) &&& 1) == 1

def allSixGuards (mask : Nat) : Bool :=
  bitAt mask 0 && bitAt mask 1 && bitAt mask 2 &&
  bitAt mask 3 && bitAt mask 4 && bitAt mask 5

def guardsDropping (dropIdx mask : Nat) : Bool :=
  (dropIdx == 0 || bitAt mask 0) &&
  (dropIdx == 1 || bitAt mask 1) &&
  (dropIdx == 2 || bitAt mask 2) &&
  (dropIdx == 3 || bitAt mask 3) &&
  (dropIdx == 4 || bitAt mask 4) &&
  (dropIdx == 5 || bitAt mask 5)

def countMask64 (pred : Nat → Bool) : Nat :=
  (List.range 64).foldl (fun acc m => if pred m then acc + 1 else acc) 0

theorem d20_unique_compliant :
    countMask64 allSixGuards = 1 ∧
    (∀ m ∈ List.range 64, allSixGuards m = true ↔ m = 63) := by
  decide

theorem guard_independence_six_countermodels :
    countMask64 (guardsDropping 0) = 2 ∧
    countMask64 (guardsDropping 1) = 2 ∧
    countMask64 (guardsDropping 2) = 2 ∧
    countMask64 (guardsDropping 3) = 2 ∧
    countMask64 (guardsDropping 4) = 2 ∧
    countMask64 (guardsDropping 5) = 2 := by
  decide

def retractToU0 (_r : Regime4) : Regime4 := U0_4

theorem extension_retract_to_U0 (r : Regime4) :
    retractToU0 r = U0_4 ∧ separable4 (retractToU0 r) 0 1 := by
  unfold retractToU0
  exact ⟨rfl, ⟨ctxUnary0_4, by decide, by decide⟩⟩

/-! ## Section 2: NoOutside dichotomy and panel re-entry -/

structure OutsidePanel where
  extraData  : Nat
  extraForms : List Nat
  extraInsts : List Inst4
deriving DecidableEq, Repr

def reenterPanel (r : Regime4) (p : OutsidePanel) : Regime4 :=
  { data  := r.data + p.extraData
    forms := r.forms ++ p.extraForms
    insts := r.insts ++ p.extraInsts
    reqs  := r.reqs }

theorem unapplied_outside_leaves_separable_unchanged (r : Regime4) (x y : Nat) :
    applyDelta4 r [] = some r ∧
    (separable4 (reenterPanel r ⟨0, [], []⟩) x y ↔ separable4 r x y) := by
  refine ⟨rfl, ?_⟩
  have heq : reenterPanel r ⟨0, [], []⟩ = r := by
    cases r
    simp [reenterPanel]
  rw [heq]

theorem panel_reentry_preserves_counts (r : Regime4) (p : OutsidePanel) :
    (reenterPanel r p).data = r.data + p.extraData ∧
    (reenterPanel r p).forms.length = r.forms.length + p.extraForms.length ∧
    (reenterPanel r p).insts.length = r.insts.length + p.extraInsts.length := by
  simp [reenterPanel, List.length_append]

/-! ## Section 3: InterpreterBoundary diagonal non-exhaustion and tower persistence -/

def diagNeg {Code : Type u} (eval : Code → Code → Bool) (c : Code) : Bool :=
  !(eval c c)

theorem diagNeg_differs_at_self {Code : Type u}
    (eval : Code → Code → Bool) (c0 : Code) :
    eval c0 c0 ≠ diagNeg eval c0 := by
  unfold diagNeg
  cases eval c0 c0 <;> decide

theorem diagonal_non_exhaustion {Code : Type u}
    (eval : Code → Code → Bool) :
    ¬ ∃ c0 : Code, ∀ x : Code, eval c0 x = diagNeg eval x := by
  rintro ⟨c0, hc0⟩
  exact diagNeg_differs_at_self eval c0 (hc0 c0)

def extendEvaluator {n : Nat} (eval : Fin n → Fin n → Bool)
    (c : Fin (n + 1)) (x : Fin (n + 1)) : Bool :=
  if hc : c.val < n then
    if hx : x.val < n then
      eval ⟨c.val, hc⟩ ⟨x.val, hx⟩
    else
      false
  else
    if hx : x.val < n then
      diagNeg eval ⟨x.val, hx⟩
    else
      false

theorem tower_persists_at_every_stage {n : Nat}
    (eval : Fin n → Fin n → Bool) :
    (∀ x : Fin n,
      extendEvaluator eval ⟨n, Nat.lt_succ_self n⟩ ⟨x.val, Nat.lt_trans x.isLt (Nat.lt_succ_self n)⟩ =
        diagNeg eval x) ∧
    ¬ ∃ c0 : Fin (n + 1), ∀ x : Fin (n + 1),
      extendEvaluator eval c0 x = diagNeg (extendEvaluator eval) x := by
  refine ⟨?_, diagonal_non_exhaustion (extendEvaluator eval)⟩
  intro x
  unfold extendEvaluator
  have hnot : ¬ (n < n) := Nat.lt_irrefl n
  simp [hnot, x.isLt]

/-! ## Section 4: WDP-CH06-P01 Strict-measure acyclicity and no-return -/

inductive PlusStep {S : Type u} (Step : S → S → Prop) : S → S → Prop where
  | single {a b : S} (h : Step a b) : PlusStep Step a b
  | tail {a b c : S} (hab : PlusStep Step a b) (hbc : Step b c) : PlusStep Step a c

theorem strict_measure_irrefl {S : Type u} (Step : S → S → Prop) (μ : S → Nat)
    (hmono : ∀ a b, Step a b → μ a < μ b) :
    Irrefl Step := by
  intro s hs
  exact Nat.lt_irrefl (μ s) (hmono s s hs)

theorem strict_measure_asymm {S : Type u} (Step : S → S → Prop) (μ : S → Nat)
    (hmono : ∀ a b, Step a b → μ a < μ b) {a b : S}
    (hab : Step a b) : ¬ Step b a := by
  intro hba
  exact Nat.lt_irrefl (μ a) (Nat.lt_trans (hmono a b hab) (hmono b a hba))

theorem strict_measure_plus_lt {S : Type u} (Step : S → S → Prop) (μ : S → Nat)
    (hmono : ∀ a b, Step a b → μ a < μ b) {a b : S}
    (hplus : PlusStep Step a b) : μ a < μ b := by
  induction hplus with
  | single h => exact hmono _ _ h
  | tail _ hbc ih => exact Nat.lt_trans ih (hmono _ _ hbc)

theorem strict_measure_no_return {S : Type u} (Step : S → S → Prop) (μ : S → Nat)
    (hmono : ∀ a b, Step a b → μ a < μ b) (s : S) :
    ¬ PlusStep Step s s := by
  intro hcycle
  exact Nat.lt_irrefl (μ s) (strict_measure_plus_lt Step μ hmono hcycle)

def regime4Measure (r : Regime4) : Nat :=
  r.data + r.forms.length + r.insts.length + r.reqs.length

theorem regime4Measure_newDatum_lt (r : Regime4) :
    regime4Measure r < regime4Measure { r with data := r.data + 1 } := by
  simp only [regime4Measure]
  omega

theorem regime4Measure_newForm_lt (r : Regime4) (k : Nat) :
    regime4Measure r < regime4Measure { r with forms := r.forms ++ [k] } := by
  simp only [regime4Measure, List.length_append, List.length_singleton]
  omega

end OmegaCodex.InternalMetatheory
