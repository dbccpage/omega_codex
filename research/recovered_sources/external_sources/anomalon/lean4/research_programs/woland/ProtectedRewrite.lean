import Init

/-!
# Protected Woland rewrite sequences

This module models the complete protected prompt query: the ordered list of
source-slot identities, roles and bytes, together with the source identity.
It corresponds to the observation checked by `protected_query` and
`judge_preserved_prompt` in the existing ACSet prompt-rewriting pilot. It does
not replace that extraction/validation code with a proof about individual
protected vertices: inserting an additional protected slot changes this query.

An admitted step is a supplied raw rewrite whose computed whole-query equality
check succeeds. Sequence preservation follows from that checked contract.
Newman's lemma is proved separately, from a decreasing natural-number rank and
local joining derivations for the selected relation. Neither premise follows
from the name DPO, from structural validity, nor from a finite execution budget.

Runtime bridge still required: show that the Python graph/query decoder and its
accepted steps refine these values and this relation, including source identity,
slot ordering, UTF-8 validation and all refusal cases. No DPO pushout,
adhesivity, graph-isomorphism normalization or cochain-BQNF realization is proved
here. In particular, graph digests with fresh IDs are not semantic normal forms.
The abstract equality result applies only to its declared state representation.

AuthorityEffect: None.
-/

namespace Woland.ProtectedRewrite

/-- Position in this list is significant; bytes are compared without decoding. -/
structure ProtectedSlot where
  sourceSlot : String
  role : String
  bytes : List UInt8
  deriving DecidableEq, Repr

/-- The retained source node and its declared identity, not a hash-soundness axiom. -/
structure SourceIdentity where
  partId : String
  sourceId : String
  sourceSha256 : String
  deriving DecidableEq, Repr

structure ProtectedQuery where
  source : SourceIdentity
  slots : List ProtectedSlot
  deriving DecidableEq, Repr

/-- An executable comparison of all protected fields, including the slot order. -/
def boundaryAccepted (before after : ProtectedQuery) : Bool :=
  decide (before = after)

theorem boundaryAccepted_iff (before after : ProtectedQuery) :
    boundaryAccepted before after = true ↔ before = after := by
  simp [boundaryAccepted]

/-- A raw rewrite is not admitted on structural success alone. -/
def AdmittedStep {State : Type u} (raw : State → State → Prop)
    (query : State → ProtectedQuery) (before after : State) : Prop :=
  raw before after ∧ boundaryAccepted (query before) (query after) = true

theorem admittedStep_preserves_boundary {raw : State → State → Prop}
    {query : State → ProtectedQuery} {before after : State}
    (h : AdmittedStep raw query before after) : query before = query after :=
  (boundaryAccepted_iff _ _).mp h.2

/-- Finite rewrite sequences, including an empty sequence. -/
inductive Steps {State : Type u} (step : State → State → Prop) : State → State → Prop
  | refl (state : State) : Steps step state state
  | next {before middle after : State} :
      step before middle → Steps step middle after → Steps step before after

theorem Steps.single {step : State → State → Prop} {before after : State}
    (h : step before after) : Steps step before after :=
  .next h (.refl after)

theorem Steps.trans {step : State → State → Prop} {a b c : State}
    (hab : Steps step a b) (hbc : Steps step b c) : Steps step a c := by
  induction hab with
  | refl => exact hbc
  | next hstep _ ih => exact .next hstep (ih hbc)

/-- The computed whole-query check is preserved through every admitted sequence. -/
theorem admitted_steps_preserve_boundary {raw : State → State → Prop}
    {query : State → ProtectedQuery} {before after : State}
    (h : Steps (AdmittedStep raw query) before after) :
    query before = query after := by
  induction h with
  | refl => rfl
  | next hstep _ ih => exact (admittedStep_preserves_boundary hstep).trans ih

def Joinable {State : Type u} (step : State → State → Prop) (left right : State) : Prop :=
  ∃ joined, Steps step left joined ∧ Steps step right joined

def LocallyConfluent {State : Type u} (step : State → State → Prop) : Prop :=
  ∀ {source left right}, step source left → step source right → Joinable step left right

def Confluent {State : Type u} (step : State → State → Prop) : Prop :=
  ∀ {source left right}, Steps step source left → Steps step source right →
    Joinable step left right

def NormalForm {State : Type u} (step : State → State → Prop) (state : State) : Prop :=
  ∀ next, ¬ step state next

/-- Forward rewrites decrease rank; the well-founded relation therefore reverses them. -/
theorem wellFounded_of_rank {step : State → State → Prop} (rank : State → Nat)
    (decreases : ∀ {before after}, step before after → rank after < rank before) :
    WellFounded (fun after before => step before after) :=
  Subrelation.wf (fun h => decreases h) (measure rank).wf

theorem steps_rank_nonincreasing {step : State → State → Prop} (rank : State → Nat)
    (decreases : ∀ {before after}, step before after → rank after < rank before)
    {before after : State} (h : Steps step before after) : rank after ≤ rank before := by
  induction h with
  | refl => exact Nat.le_refl _
  | next hstep _ ih => exact Nat.le_trans ih (Nat.le_of_lt (decreases hstep))

/-- Newman's lemma for a rule-specific decreasing rank and actual local joins.

The induction joins each branch with a local common descendant, then joins
those descendants below the original rank. No global confluence assumption is
used. For DPO, obtaining `localJoin` remains a separate proof obligation; merely
joining critical endpoints need not supply the required persistent-node tracks.
-/
theorem confluent_of_rank_and_local_joins {step : State → State → Prop}
    (rank : State → Nat)
    (decreases : ∀ {before after}, step before after → rank after < rank before)
    (localJoin : LocallyConfluent step) : Confluent step := by
  intro source left right
  revert left right
  change ∀ (left right : State), Steps step source left →
    Steps step source right → Joinable step left right
  refine (measure rank).wf.induction
    (C := fun source => ∀ (left right : State), Steps step source left →
      Steps step source right → Joinable step left right) source ?_
  intro source ih left right hleft hright
  cases hleft with
  | refl => exact ⟨right, hright, .refl right⟩
  | next firstLeft restLeft =>
    cases hright with
    | refl => exact ⟨left, .refl left, .next firstLeft restLeft⟩
    | next firstRight restRight =>
      obtain ⟨middle, leftMiddle, rightMiddle⟩ := localJoin firstLeft firstRight
      obtain ⟨joinedLeft, leftJoined, middleJoinedLeft⟩ :=
        ih _ (decreases firstLeft) _ _ restLeft leftMiddle
      obtain ⟨joinedRight, rightJoined, middleJoinedRight⟩ :=
        ih _ (decreases firstRight) _ _ restRight rightMiddle
      have middleBelow : rank middle < rank source :=
        Nat.lt_of_le_of_lt (steps_rank_nonincreasing rank decreases leftMiddle)
          (decreases firstLeft)
      obtain ⟨joined, leftFinal, rightFinal⟩ :=
        ih middle middleBelow _ _ middleJoinedLeft middleJoinedRight
      exact ⟨joined, leftJoined.trans leftFinal, rightJoined.trans rightFinal⟩

theorem steps_from_normal_form {step : State → State → Prop} {before after : State}
    (normal : NormalForm step before) (h : Steps step before after) : after = before := by
  cases h with
  | refl => rfl
  | next hstep _ => exact False.elim (normal _ hstep)

theorem reachable_normal_forms_unique {step : State → State → Prop}
    (confluent : Confluent step) {source left right : State}
    (hleft : Steps step source left) (hright : Steps step source right)
    (leftNormal : NormalForm step left) (rightNormal : NormalForm step right) :
    left = right := by
  obtain ⟨joined, leftJoined, rightJoined⟩ := confluent hleft hright
  exact (steps_from_normal_form leftNormal leftJoined).symm.trans
    (steps_from_normal_form rightNormal rightJoined)

/-- The combined result still requires local joins for the *admitted* relation.
Rejecting steps or exhausting a budget can remove joins of an ungated relation.
-/
theorem admitted_normal_forms_unique_with_boundary
    {raw : State → State → Prop} {query : State → ProtectedQuery}
    (rank : State → Nat)
    (decreases : ∀ {before after}, AdmittedStep raw query before after →
      rank after < rank before)
    (localJoin : LocallyConfluent (AdmittedStep raw query))
    {source left right : State}
    (hleft : Steps (AdmittedStep raw query) source left)
    (hright : Steps (AdmittedStep raw query) source right)
    (leftNormal : NormalForm (AdmittedStep raw query) left)
    (rightNormal : NormalForm (AdmittedStep raw query) right) :
    left = right ∧ query source = query left := by
  exact ⟨reachable_normal_forms_unique
    (confluent_of_rank_and_local_joins rank decreases localJoin)
    hleft hright leftNormal rightNormal, admitted_steps_preserve_boundary hleft⟩

/-! Concrete controls: whole-query equality, not only retained vertex equality. -/

private def exampleSource : SourceIdentity := ⟨"source", "seed-v1", "declared-digest"⟩
private def taskSlot : ProtectedSlot := ⟨"slot0", "task", [65, 66]⟩
private def constraintSlot : ProtectedSlot := ⟨"slot1", "constraint", [67]⟩
private def exampleQuery : ProtectedQuery := ⟨exampleSource, [taskSlot, constraintSlot]⟩

theorem reordered_slots_refused :
    boundaryAccepted exampleQuery ⟨exampleSource, [constraintSlot, taskSlot]⟩ = false := by
  decide

theorem added_protected_slot_refused :
    boundaryAccepted exampleQuery
      ⟨exampleSource, [taskSlot, constraintSlot, ⟨"slot2", "output", [68]⟩]⟩ = false := by
  decide

theorem changed_source_identity_refused :
    boundaryAccepted exampleQuery
      ⟨⟨"source", "different-seed", "declared-digest"⟩, [taskSlot, constraintSlot]⟩ = false := by
  decide

theorem changed_protected_bytes_refused :
    boundaryAccepted exampleQuery
      ⟨exampleSource, [⟨"slot0", "task", [66, 65]⟩, constraintSlot]⟩ = false := by
  decide

/-! A finite terminating boundary-preserving relation need not be confluent.

For each fixed query this has exactly three states. It represents the existing
executor's counterexample: a protected context plus an unprotected vertex `a`,
with two registered empty-interface rules replacing it by `b` or `c`. The Lean
result concerns the stated relation, not an unproved graph-executor refinement.
-/

inductive Branch where
  | a | b | c
  deriving DecidableEq, Repr

structure BranchState where
  boundary : ProtectedQuery
  branch : Branch
  deriving DecidableEq, Repr

inductive BranchRewrite : BranchState → BranchState → Prop
  | toB (query : ProtectedQuery) : BranchRewrite ⟨query, .a⟩ ⟨query, .b⟩
  | toC (query : ProtectedQuery) : BranchRewrite ⟨query, .a⟩ ⟨query, .c⟩

abbrev CheckedBranch := AdmittedStep BranchRewrite BranchState.boundary

def branchRank (state : BranchState) : Nat :=
  match state.branch with
  | .a => 1
  | .b | .c => 0

theorem branch_rank_decreases {before after : BranchState}
    (h : CheckedBranch before after) : branchRank after < branchRank before := by
  cases h.1 <;> change 0 < 1 <;> decide

theorem branch_terminating : WellFounded (fun after before => CheckedBranch before after) :=
  wellFounded_of_rank branchRank branch_rank_decreases

theorem branch_to_b (query : ProtectedQuery) : CheckedBranch ⟨query, .a⟩ ⟨query, .b⟩ :=
  ⟨.toB query, (boundaryAccepted_iff _ _).mpr rfl⟩

theorem branch_to_c (query : ProtectedQuery) : CheckedBranch ⟨query, .a⟩ ⟨query, .c⟩ :=
  ⟨.toC query, (boundaryAccepted_iff _ _).mpr rfl⟩

theorem branch_b_normal (query : ProtectedQuery) : NormalForm CheckedBranch ⟨query, .b⟩ := by
  intro next h
  cases h.1

theorem branch_c_normal (query : ProtectedQuery) : NormalForm CheckedBranch ⟨query, .c⟩ := by
  intro next h
  cases h.1

theorem branch_peak_not_joinable (query : ProtectedQuery) :
    ¬ Joinable CheckedBranch ⟨query, .b⟩ ⟨query, .c⟩ := by
  intro ⟨joined, hb, hc⟩
  have equal : (⟨query, .b⟩ : BranchState) = ⟨query, .c⟩ :=
    (steps_from_normal_form (branch_b_normal query) hb).symm.trans
      (steps_from_normal_form (branch_c_normal query) hc)
  have impossible : Branch.b = Branch.c := congrArg BranchState.branch equal
  cases impossible

theorem branch_not_confluent : ¬ Confluent CheckedBranch := by
  intro confluent
  exact branch_peak_not_joinable exampleQuery
    (confluent (.single (branch_to_b exampleQuery)) (.single (branch_to_c exampleQuery)))

theorem branch_not_locally_confluent : ¬ LocallyConfluent CheckedBranch := by
  intro localJoin
  exact branch_peak_not_joinable exampleQuery
    (localJoin (branch_to_b exampleQuery) (branch_to_c exampleQuery))

#print axioms boundaryAccepted_iff
#print axioms admitted_steps_preserve_boundary
#print axioms wellFounded_of_rank
#print axioms confluent_of_rank_and_local_joins
#print axioms reachable_normal_forms_unique
#print axioms admitted_normal_forms_unique_with_boundary
#print axioms reordered_slots_refused
#print axioms added_protected_slot_refused
#print axioms changed_source_identity_refused
#print axioms changed_protected_bytes_refused
#print axioms branch_terminating
#print axioms branch_peak_not_joinable
#print axioms branch_not_confluent
#print axioms branch_not_locally_confluent

end Woland.ProtectedRewrite
