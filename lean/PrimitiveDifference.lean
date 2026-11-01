/-!
# Symmetric primitive difference

A self-contained investigation using Lean core only.  No Regime, observer,
time, or physical interpretation is assumed.  Bool is a two-position
presentation; its names are not structurally preferred.

The generic law characterizes universal soundness.  The finite binary
classifier and counterpart are additional explicit constructions.  A refusal
register is an added transition specification, not a consequence of S2.
-/
namespace OmegaCodex.PrimitiveDifference

universe u v

def Irrefl {α : Type u} (r : α → α → Prop) : Prop :=
  ∀ x, ¬ r x x

theorem irrefl_witness_ne {α : Type u} {r : α → α → Prop}
    (hi : Irrefl r) {a b : α} (h : r a b) : a ≠ b :=
  fun he => hi b (he ▸ h)

/-- Exact universal soundness characterization; no finite search required. -/
theorem irrefl_iff_soundness {α : Type u} (r : α → α → Prop) :
    Irrefl r ↔ ∀ a b, r a b → a ≠ b := by
  constructor
  · intro hi a b hab
    exact irrefl_witness_ne hi hab
  · intro hs x hxx
    exact hs x x hxx rfl

/-- A semantic condition on relation axioms is universally sound precisely
when it entails irreflexivity. This does not enumerate an axiom grammar. -/
theorem universal_soundness_iff_entails_irrefl {α : Type u}
    (P : (α → α → Prop) → Prop) :
    (∀ r, P r → ∀ a b, r a b → a ≠ b) ↔
    (∀ r, P r → Irrefl r) := by
  constructor
  · intro h r hp
    exact (irrefl_iff_soundness r).mpr (h r hp)
  · intro h r hp
    exact (irrefl_iff_soundness r).mp (h r hp)

/-- One designated pair can be distinct while a different pair is a loop. -/
theorem local_pair_does_not_force_irrefl :
    ∃ r : Bool → Bool → Prop,
      r false true ∧ false ≠ true ∧ ¬ Irrefl r := by
  refine ⟨fun x y => (x = false ∧ y = true) ∨
      (x = true ∧ y = true), by decide, by decide, ?_⟩
  intro hi
  exact hi true (by decide)

def S2 (x y : Bool) : Prop := x ≠ y

instance (x y : Bool) : Decidable (S2 x y) := by
  unfold S2
  infer_instance

/-- Extensional crosswalk to the earlier symmetrized oriented edge. -/
theorem S2_legacy_reading (x y : Bool) :
    S2 x y ↔ (x = false ∧ y = true) ∨ (y = false ∧ x = true) := by
  cases x <;> cases y <;> decide

theorem S2_irrefl : Irrefl S2 := by
  intro x h
  exact h rfl

def counterpart : Bool → Bool := Bool.not

theorem counterpart_involution (x : Bool) :
    counterpart (counterpart x) = x := by
  cases x <;> rfl

theorem counterpart_ne (x : Bool) : counterpart x ≠ x := by
  cases x <;> decide

theorem counterpart_characterization (x y : Bool) :
    S2 x y ↔ y = counterpart x := by
  cases x <;> cases y <;> decide

theorem counterpart_unique (g : Bool → Bool)
    (h : ∀ x, S2 x (g x)) : ∀ x, g x = counterpart x :=
  fun x => (counterpart_characterization x (g x)).mp (h x)

theorem swap_preserves_relation (x y : Bool) :
    S2 (counterpart x) (counterpart y) ↔ S2 x y := by
  cases x <;> cases y <;> decide

/-- The counterpart commutes with every relation-preserving-and-reflecting
endomap. Thus the operation does not select a preferred participant. -/
theorem counterpart_equivariant (f : Bool → Bool)
    (hf : ∀ x y, S2 x y ↔ S2 (f x) (f y)) (x : Bool) :
    counterpart (f x) = f (counterpart x) := by
  have hx : S2 x (counterpart x) :=
    (counterpart_characterization x (counterpart x)).mpr rfl
  exact ((counterpart_characterization (f x) (f (counterpart x))).mp
    ((hf x (counterpart x)).mp hx)).symm

theorem no_swap_fixed_participant : ¬ ∃ x, counterpart x = x := by
  intro ⟨x, hx⟩
  exact counterpart_ne x hx

/-- Only unary classifiers into a trivially acted-on Bool are excluded. -/
theorem no_invariant_unary_separator (f : Bool → Bool)
    (h : ∀ x, f (counterpart x) = f x) : f false = f true :=
  (h false).symm

def difference : Bool → Bool → Bool := Bool.xor

theorem difference_correct (x y : Bool) :
    difference x y = true ↔ S2 x y := by
  cases x <;> cases y <;> decide

theorem binary_difference_swap_invariant (x y : Bool) :
    difference (counterpart x) (counterpart y) = difference x y := by
  cases x <;> cases y <;> decide

theorem binary_difference_nonconstant :
    difference false true ≠ difference false false := by decide

/-- Nontrivial output action is also possible: the identity classifier is
equivariant when outputs, too, are swapped. It is not invariant. -/
theorem nontrivial_output_action :
    (∀ x : Bool, (id : Bool → Bool) (counterpart x) =
      counterpart ((id : Bool → Bool) x)) ∧
    (id : Bool → Bool) false ≠ (id : Bool → Bool) true := by
  exact ⟨fun _ => rfl, by decide⟩

def Push {α : Type u} {β : Type v} (r : α → α → Prop)
    (c : α → β) (x y : β) : Prop :=
  ∃ a b, r a b ∧ c a = x ∧ c b = y

/-- Structural obstruction under preservation of irreflexivity. The input
witness alone creates a target loop if its endpoints are identified. -/
theorem identified_witness_violates_irrefl {α : Type u} {β : Type v}
    {r : α → α → Prop} {a b : α} (h : r a b)
    (c : α → β) (hc : c a = c b) : ¬ Irrefl (Push r c) := by
  intro hi
  exact hi (c a) ⟨a, b, h, rfl, hc.symm⟩

/-! ## An explicitly added operational extension

A candidate map is supplied to an evaluator. A Boolean register and update
rule record its refusal flag. Invocation of that rule is assumed.
S2 by itself specifies none of these mechanisms.
-/

def reject (c : Bool → Bool) : Bool := decide (c false = c true)

theorem reject_iff_identifies (c : Bool → Bool) :
    reject c = true ↔ c false = c true := by
  simp [reject]

theorem reject_invariant_under_input_swap (c : Bool → Bool) :
    reject (fun x => c (counterpart x)) = reject c := by
  simp [reject, counterpart, eq_comm]

theorem reject_invariant_under_output_swap (c : Bool → Bool) :
    reject (fun x => counterpart (c x)) = reject c := by
  cases h0 : c false <;> cases h1 : c true <;>
    simp [reject, counterpart, h0, h1]

structure Register where
  flag : Bool

def recordRefusal (c : Bool → Bool) (_previous : Register) : Register :=
  ⟨reject c⟩

theorem registered_refusal_correct (c : Bool → Bool) (s : Register) :
    (recordRefusal c s).flag = true ↔ c false = c true :=
  reject_iff_identifies c

theorem registered_refusal_on_collapse (s : Register) :
    (recordRefusal (fun _ => false) s).flag = true := by rfl

theorem registered_acceptance_on_identity (s : Register) :
    (recordRefusal id s).flag = false := by rfl

/-- A different update policy can coexist with exactly the same static S2.
The relation therefore does not uniquely determine the refusal behavior. -/
def recordNoRefusal (_c : Bool → Bool) (_previous : Register) : Register :=
  ⟨false⟩

theorem static_relation_does_not_force_refusal (s : Register) :
    Irrefl S2 ∧ S2 false true ∧
    (recordNoRefusal (fun _ => false) s).flag = false :=
  ⟨S2_irrefl, by decide, rfl⟩

end OmegaCodex.PrimitiveDifference
