import PrimitiveDifference

/-!
# Mirror non-identification

Approved finite slice: two shared presentations, two alternative referent
assignments, the same accessible relation, and an explicit observation interface.
No mirror apparatus, perspective, history, or mechanism obtaining extra
observations is assumed.
-/
namespace OmegaCodex.MirrorNonIdentification

open OmegaCodex.PrimitiveDifference

inductive Model where
  | oneReferent
  | twoReferents
deriving DecidableEq, Repr

def Referent : Model → Type
  | .oneReferent => Unit
  | .twoReferents => Bool

def projection : (m : Model) → Bool → Referent m
  | .oneReferent => fun _ => ()
  | .twoReferents => id

theorem one_referent_assignment :
    projection .oneReferent false = projection .oneReferent true := rfl

theorem two_referent_assignment :
    projection .twoReferents false ≠ projection .twoReferents true := by
  change (false : Bool) ≠ true
  decide

def identityAnswer : Model → Bool
  | .oneReferent => true
  | .twoReferents => false

theorem identity_answer_correct (m : Model) :
    identityAnswer m = true ↔ projection m false = projection m true := by
  cases m
  · change (true = true ↔ () = ())
    decide
  · change (false = true ↔ (false : Bool) = true)
    decide

def accessible (_m : Model) : Bool → Bool → Bool := difference

abbrev Observation := Bool × Bool × Bool × Bool

def observe (m : Model) : Observation :=
  (accessible m false false, accessible m false true,
   accessible m true false, accessible m true true)

theorem same_accessible_relation (x y : Bool) :
    accessible .oneReferent x y = accessible .twoReferents x y := rfl

theorem accessible_swap_invariant (m : Model) (x y : Bool) :
    accessible m (counterpart x) (counterpart y) = accessible m x y :=
  binary_difference_swap_invariant x y

theorem identical_observations :
    observe .oneReferent = observe .twoReferents := rfl

theorem different_identity_answers :
    identityAnswer .oneReferent ≠ identityAnswer .twoReferents := by decide

theorem observation_only_outputs_agree {X : Type} (f : Observation → X) :
    f (observe .oneReferent) = f (observe .twoReferents) := rfl

/-- No deterministic total decoder of just this observation answers both models. -/
theorem mirror_non_identification :
    ¬ ∃ f : Observation → Bool, ∀ m, f (observe m) = identityAnswer m := by
  intro ⟨f, hf⟩
  have contradiction : (true : Bool) = false :=
    (hf .oneReferent).symm.trans (hf .twoReferents)
  exact Bool.noConfusion contradiction

/-- Presentation difference cannot descend along the shared-referent
projection. No irreflexive relation on referents is being assumed. -/
theorem presentation_difference_does_not_descend :
    ¬ ∃ f : Unit → Unit → Bool,
      ∀ x y, difference x y =
        f (projection .oneReferent x) (projection .oneReferent y) := by
  intro ⟨f, hf⟩
  have contradiction : (false : Bool) = true :=
    (hf false false).trans (hf false true).symm
  exact Bool.noConfusion contradiction

universe u

def Decodes {X : Type u} (o : Model → X) : Prop :=
  ∃ f : X → Bool, ∀ m, f (o m) = identityAnswer m

def FiberConstant {X : Type u} (o : Model → X) : Prop :=
  ∀ m n, o m = o n → identityAnswer m = identityAnswer n

/-- Necessity does not require decidable equality or an available decoder. -/
theorem decoding_requires_fiber_constancy {X : Type u} (o : Model → X) :
    Decodes o → FiberConstant o := by
  intro ⟨f, hf⟩ m n he
  exact (hf m).symm.trans ((congrArg f he).trans (hf n))

theorem fiber_constant_iff_separates {X : Type u} (o : Model → X) :
    FiberConstant o ↔ o .oneReferent ≠ o .twoReferents := by
  constructor
  · intro h he
    exact different_identity_answers (h .oneReferent .twoReferents he)
  · intro h m n he
    cases m <;> cases n
    · rfl
    · exact False.elim (h he)
    · exact False.elim (h he.symm)
    · rfl

/-- Constructive sufficiency explicitly admits a decidable observation test.
Its existence does not imply that a system can obtain o(m). -/
def decoder {X : Type u} [DecidableEq X] (o : Model → X) (x : X) : Bool :=
  decide (x = o .oneReferent)

theorem decoder_correct_of_separates {X : Type u} [DecidableEq X]
    (o : Model → X) (h : o .oneReferent ≠ o .twoReferents) :
    ∀ m, decoder o (o m) = identityAnswer m := by
  intro m
  cases m
  · simp [decoder, identityAnswer]
  · have hn : o .twoReferents ≠ o .oneReferent := Ne.symm h
    simp [decoder, identityAnswer, hn]

theorem decodes_iff_fiber_constant {X : Type u} [DecidableEq X]
    (o : Model → X) : Decodes o ↔ FiberConstant o := by
  constructor
  · exact decoding_requires_fiber_constancy o
  · intro h
    exact ⟨decoder o, decoder_correct_of_separates o
      ((fiber_constant_iff_separates o).mp h)⟩

def enhanced {X : Type u} (extra : Model → X) (m : Model) :
    Observation × X := (observe m, extra m)

theorem enhancement_separates_iff {X : Type u} (extra : Model → X) :
    enhanced extra .oneReferent ≠ enhanced extra .twoReferents ↔
      extra .oneReferent ≠ extra .twoReferents := by
  constructor
  · intro h he
    exact h (Prod.ext identical_observations he)
  · intro h he
    exact h (congrArg Prod.snd he)

/-- Exact completion criterion for this two-model task and a decidable
extra-observation value type. No physical acquisition is inferred. -/
theorem extra_observation_completion {X : Type u} [DecidableEq X]
    (extra : Model → X) :
    Decodes (enhanced extra) ↔
      extra .oneReferent ≠ extra .twoReferents := by
  rw [decodes_iff_fiber_constant, fiber_constant_iff_separates,
    enhancement_separates_iff]

theorem constant_extra_fails (bit : Bool) :
    ¬ Decodes (enhanced (fun _ => bit)) := by
  intro h
  exact ((extra_observation_completion (fun _ => bit)).mp h) rfl

/-- This supplies the target as an oracle-like observation; it does not
construct a sensor or prove that the information is available internally. -/
theorem target_bit_extra_suffices :
    Decodes (enhanced identityAnswer) := by
  exact (extra_observation_completion identityAnswer).mpr different_identity_answers

theorem target_answer_has_no_preferred_presentation (m : Model) :
    (projection m (counterpart false) = projection m (counterpart true)) ↔
      projection m false = projection m true := by
  change projection m true = projection m false ↔
    projection m false = projection m true
  exact eq_comm

end OmegaCodex.MirrorNonIdentification
