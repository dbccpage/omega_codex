import MinimalSeparation
import WitnessedDifference.GenesisConstruction

/-!
# Omega admission moves in the existing WDP history construction

The adapter reuses Regime4 and Item4 unchanged. Supply below is an explicit
presentation wrapper, not an Item4 constructor. Requirements are supplied at
the initialization boundary; no endogenous demand or Rust refinement is claimed.
WDP sources are byte-preserved and pinned in the slice source-custody record.
-/
set_option autoImplicit false

namespace OmegaCodex.AdmissionReplay

open OmegaCodex.MinimalSeparation
open WitnessedDifference.GenerativeHistoryCompression
open WitnessedDifference.GenesisConstruction

abbrev History := Path (transitionSignature applyItem4)

/-- WDP's head-first partial replay is exactly Omega's monadic left fold. -/
theorem replay_eq_applyDelta (events : List Item4) (initial : Regime4) :
    replay applyItem4 events initial = applyDelta4 initial events := by
  induction events generalizing initial with
  | nil => rfl
  | cons event events ih =>
      unfold applyDelta4
      simp only [replay, List.foldlM]
      cases h : applyItem4 initial event with
      | none => rfl
      | some next => exact ih next

theorem accepted_iff_history (events : List Item4) (initial final : Regime4) :
    applyDelta4 initial events = some final ↔
      ∃ path : History initial final, transitionEvents path = events := by
  constructor
  · intro h
    exact accepted_replay_has_typed_history applyItem4 events
      ((replay_eq_applyDelta events initial).trans h)
  · rintro ⟨path, hevents⟩
    rw [← replay_eq_applyDelta, ← hevents]
    exact replay_transitionEvents path

theorem history_endpoint {initial final : Regime4} (path : History initial final) :
    applyDelta4 initial (transitionEvents path) = some final := by
  rw [← replay_eq_applyDelta]
  exact replay_transitionEvents path

theorem refusal_iff_no_history (events : List Item4) (initial : Regime4) :
    applyDelta4 initial events = none ↔
      ¬ ∃ final, ∃ path : History initial final, transitionEvents path = events := by
  constructor
  · intro h ⟨final, path, hevents⟩
    have ha := (accepted_iff_history events initial final).mpr ⟨path, hevents⟩
    rw [h] at ha
    cases ha
  · intro h
    cases ha : applyDelta4 initial events with
    | none => rfl
    | some final => exact False.elim (h ⟨final, (accepted_iff_history events initial final).mp ha⟩)

def eventCost (price : Item4 → Nat) (events : List Item4) : Nat :=
  (events.map price).sum

def arityPrice : Item4 → Nat
  | .newForm arity => arity
  | _ => 0

theorem composed_events {a b c : Regime4} (p : History a b) (q : History b c) :
    transitionEvents (Path.comp p q) = transitionEvents p ++ transitionEvents q :=
  transitionEvents_comp p q

theorem composed_cost (price : Item4 → Nat) {a b c : Regime4}
    (p : History a b) (q : History b c) :
    eventCost price (transitionEvents (Path.comp p q)) =
      eventCost price (transitionEvents p) + eventCost price (transitionEvents q) := by
  simp [eventCost, transitionEvents_comp, List.sum_append]

/-- Preserve any chosen endpoint question, without selecting one for the source. -/
theorem endpoint_question {Answer : Type} (question : Regime4 → Answer)
    {initial final : Regime4} (path : History initial final) :
    (applyDelta4 initial (transitionEvents path)).map question = some (question final) := by
  rw [history_endpoint]
  rfl

theorem history_keeps_separation {initial final : Regime4} (path : History initial final)
    {x y : Nat} (hsep : separable4 final x y) :
    ∃ result, applyDelta4 initial (transitionEvents path) = some result ∧ separable4 result x y :=
  ⟨final, history_endpoint path, hsep⟩

/-- Bookkeeping extension: an opaque presentation or one unchanged Omega move. -/
inductive PresentedEvent where
  | supply (token : String)
  | move (item : Item4)
deriving Repr, DecidableEq

def presentedStep (state : Regime4) : PresentedEvent → Option Regime4
  | .supply _ => some state
  | .move item => applyItem4 state item

theorem move_step_commutes (state : Regime4) (item : Item4) :
    presentedStep state (.move item) = (applyItem4 state item).map id := by
  cases h : applyItem4 state item <;> simp [presentedStep, h]

theorem presented_moves_replay (events : List Item4) (initial : Regime4) :
    replay presentedStep (events.map PresentedEvent.move) initial = applyDelta4 initial events := by
  have h := replay_commutes applyItem4 presentedStep id PresentedEvent.move
    move_step_commutes events initial
  simpa [replay_eq_applyDelta] using h

theorem literal_prefix_replay (events : List Item4) (initial : Regime4) :
    replay presentedStep (.supply "<>" :: events.map PresentedEvent.move) initial =
      applyDelta4 initial events := by
  rw [literal_supply_replay presentedStep PresentedEvent.supply initial rfl]
  exact presented_moves_replay events initial

theorem rooted_accepted_history {events : List Item4} {initial final : Regime4}
    (h : applyDelta4 initial events = some final) :
    ∃ path : Path (transitionSignature presentedStep) initial final,
      transitionEvents path = .supply "<>" :: events.map PresentedEvent.move ∧
      replay presentedStep (transitionEvents path) initial = some final :=
  literal_root_construction presentedStep PresentedEvent.supply rfl _
    ((presented_moves_replay events initial).trans h)

theorem rooted_refusal (events : List Item4) (initial : Regime4) :
    replay presentedStep (.supply "<>" :: events.map PresentedEvent.move) initial = none ↔
      applyDelta4 initial events = none := by
  rw [literal_prefix_replay]

def emptyRegime : Regime4 := ⟨0, [], [], []⟩

theorem supply_empty : presentedStep emptyRegime (.supply "<>") = some emptyRegime := rfl

theorem datum_changes_empty : applyItem4 emptyRegime .newDatum = some ⟨1, [], [], []⟩ := rfl

inductive Reading where | L | F
deriving Repr, DecidableEq

def dataPrefix : Reading → List Item4
  | .L => [.newDatum, .newDatum]
  | .F => [.newDatum, .newDatum, .newDatum]

def dataState : Reading → Regime4
  | .L => ⟨2, [], [], []⟩
  | .F => ⟨3, [], [], []⟩

/-- A supplied requirement, explicitly outside Item4's transition alphabet. -/
def withRequirement (r : Regime4) (pair : Nat × Nat) : Regime4 :=
  { r with reqs := [pair] }

theorem data_prefix_replay (reading : Reading) :
    replay presentedStep (.supply "<>" :: (dataPrefix reading).map PresentedEvent.move)
      emptyRegime = some (dataState reading) := by
  cases reading <;> decide

theorem reading_initializations :
    withRequirement (dataState .L) (0, 1) = R2L4 ∧
    withRequirement (dataState .F) (1, 2) = R2F4 := by decide

def unaryResponse (target : Nat) : List Item4 := [.newForm 1, .newInst 0 [target]]

theorem unary_endpoints :
    applyDelta4 R2L4 (unaryResponse 0) = some U0_4 ∧
    applyDelta4 R2L4 (unaryResponse 1) = some U1_4 ∧
    applyDelta4 R2F4 (unaryResponse 1) = some U0F_4 ∧
    applyDelta4 R2F4 (unaryResponse 2) = some U2F_4 := by decide

theorem unary_separations :
    separable4 U0_4 0 1 ∧ separable4 U1_4 0 1 ∧
    separable4 U0F_4 1 2 ∧ separable4 U2F_4 1 2 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals apply (separable4_iff_collapsed4Bool_false _ _ _).mpr; decide

theorem unary_prices (target : Nat) :
    eventCost (fun _ => 1) (unaryResponse target) = 2 ∧
    eventCost arityPrice (unaryResponse target) = 1 := by simp [eventCost, unaryResponse, arityPrice]

theorem invalid_order_refuses : applyDelta4 R2L4 [.newInst 0 [0], .newForm 1] = none := by decide

theorem malformed_refuses :
    applyItem4 R2L4 (.newForm 0) = none ∧
    applyItem4 U0_4 (.newInst 0 []) = none ∧
    applyItem4 U0_4 (.newInst 0 [2]) = none := by decide

theorem same_endpoint_different_occurrences :
    applyDelta4 R2L4 (unaryResponse 0 ++ [.newInst 0 [0]]) =
      applyDelta4 R2L4 (unaryResponse 0) ∧
    eventCost (fun _ => 1) (unaryResponse 0 ++ [.newInst 0 [0]]) = 3 ∧
    eventCost (fun _ => 1) (unaryResponse 0) = 2 := by decide

/-- Same-state accepted duplicate and refusal are observably different outcomes. -/
theorem accepted_idle_not_refusal :
    applyItem4 U0_4 (.newInst 0 [0]) = some U0_4 ∧
    applyItem4 U0_4 (.newInst 0 [2]) = none := by decide

theorem fresh_response_has_history (r : Regime4) {target : Nat} (ht : target < r.data) :
    ∃ path : History r (stepFreshUnary4 r target), transitionEvents path = freshUnaryDelta4 r target :=
  (accepted_iff_history _ _ _).mp (applyDelta4_freshUnaryDelta4 r ht)

end OmegaCodex.AdmissionReplay
