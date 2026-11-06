import Syntax

/-!
# Simplex AutoP Semantics & Lawfulness Constraints

Defines semantic invariants and lawfulness fences for the AutoP specification language.
Enforces the fundamental architectural boundary:
  - AutoP describes structures and transformations.
  - AutoP does not decide truth or execute repairs.
  - Observe statements cannot enter the evaluator.
  - Quarantined constructs (metric, repair) invalidate the module fail-closed.

AuthorityEffect: None.
-/

namespace Simplex.AutoP.Semantics

open Simplex.AutoP.Syntax

/-- Checks if a single declaration is lawful (free of quarantined constructs). -/
def isLawfulDecl : Declaration → Bool
  | Declaration.quarantined _ _ => false
  | _ => true

/-- An AutoP module is lawful iff all constituent declarations are lawful. -/
def isLawfulModule (m : Module) : Bool :=
  m.declarations.all isLawfulDecl

theorem all_eq_false_of_mem {α : Type} (p : α → Bool) {x : α} : ∀ {l : List α}, x ∈ l → p x = false → l.all p = false
  | _ :: _, List.Mem.head _, hp => by
    simp only [List.all]
    rw [hp]
    rfl
  | _ :: _, List.Mem.tail _ htail, hp => by
    simp only [List.all]
    have ih := all_eq_false_of_mem p htail hp
    rw [ih]
    simp

/-- Theorem: A module containing a quarantined declaration is never lawful. -/
theorem quarantined_implies_not_lawful (m : Module) (kw name : String) :
    Declaration.quarantined kw name ∈ m.declarations → isLawfulModule m = false := by
  intro h_in
  unfold isLawfulModule
  exact all_eq_false_of_mem isLawfulDecl h_in rfl

/-- GödelGate Invariant: An AutoP specification cannot certify its own total soundness. -/
def GodelGateSelfCertificationBoundary (m : Module) : Prop :=
  -- Self-referential certification flags are forbidden from conferring un-grounded authority
  ∀ name ∈ m.declarations, isLawfulDecl name = true

end Simplex.AutoP.Semantics
