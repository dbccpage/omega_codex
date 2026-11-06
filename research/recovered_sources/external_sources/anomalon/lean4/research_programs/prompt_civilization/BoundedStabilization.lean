/-!
Finite stabilization of the budgeted Prompt Civilization controller.

Model: one round is any deterministic population transition. A natural-number
budget decreases once for each round. At zero, the transition is the identity.
The Rust ArchipelagoV1 owns its islands, records each accepted insertion or
migration, and refuses both operations after its convergence monitor freezes.
An early plateau freeze can only reduce the number of changing rounds.

This theorem proves eventual constancy under a finite stopping policy. It does
not assert that fitness improves, that an optimum is reached, or that an
unbounded evolutionary process has an asymptotically stable equilibrium.
AuthorityEffect: None.
-/

namespace PromptCivilization

def budgetedRun (transition : α → α) : Nat → Nat → α → α
  | 0, _, state => state
  | _ + 1, 0, state => state
  | budget + 1, rounds + 1, state =>
      budgetedRun transition budget rounds (transition state)

theorem frozen_absorbing (transition : α → α) (rounds : Nat) (state : α) :
    budgetedRun transition 0 rounds state = state := rfl

theorem stabilization_after_budget (transition : α → α) (budget extra : Nat) (state : α) :
    budgetedRun transition budget (budget + extra) state =
      budgetedRun transition budget budget state := by
  induction budget generalizing state with
  | zero => rfl
  | succ budget ih =>
      simp only [Nat.succ_add, budgetedRun]
      exact ih (transition state)

#print axioms frozen_absorbing
#print axioms stabilization_after_budget

end PromptCivilization
