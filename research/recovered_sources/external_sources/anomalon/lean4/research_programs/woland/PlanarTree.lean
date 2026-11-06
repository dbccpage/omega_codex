import GateIdeal

/-!
# Concrete ordered trees and typed context substitution

AuthorityEffect: None.

The constructors below retain operation labels and ordered child occurrences.
The intended colour is `(colour_id, schema_ref)`: `port_id` is not part of type
equality, as in Rust `PortSpec.same_type`. A context selects one external leaf,
not the first leaf with a matching colour. Its zero-based index is the number
of preceding external leaves. Filling contexts is concrete structural recursion.

This proves tree/context laws, not correctness of a deserializer or the Rust
implementation. A refinement still has to relate Rust normalized terms, numeric
slot lookup, operation labels, port provenance and canonical serialization to
this model. No symmetric action, evaluation correctness, receipt authentication
or general mathematical truth follows from these structural results.
-/

namespace Woland.PlanarTree

universe u v

mutual
  inductive Tree (Colour : Type u) (Label : Type v) where
    | input : Colour → Tree Colour Label
    | node : Label → Forest Colour Label → Tree Colour Label

  inductive Forest (Colour : Type u) (Label : Type v) where
    | nil : Forest Colour Label
    | cons : Tree Colour Label → Forest Colour Label → Forest Colour Label
end

variable {Colour : Type u} {Label : Type v}

def Forest.append : Forest Colour Label → Forest Colour Label → Forest Colour Label
  | .nil, right => right
  | .cons tree rest, right => .cons tree (rest.append right)

theorem Forest.append_assoc : (a b c : Forest Colour Label) →
    (a.append b).append c = a.append (b.append c)
  | .nil, _, _ => rfl
  | .cons tree rest, b, c => congrArg (Forest.cons tree) (Forest.append_assoc rest b c)

theorem Forest.append_nil : (forest : Forest Colour Label) → forest.append .nil = forest
  | .nil => rfl
  | .cons tree rest => congrArg (Forest.cons tree) (Forest.append_nil rest)

mutual
  def Tree.inputs : Tree Colour Label → List Colour
    | .input colour => [colour]
    | .node _ children => children.inputs

  def Forest.inputs : Forest Colour Label → List Colour
    | .nil => []
    | .cons tree rest => tree.inputs ++ rest.inputs
end

def Tree.output (signature : Label → GateIdeal.Profile Colour) : Tree Colour Label → Colour
  | .input colour => colour
  | .node label _ => (signature label).output

def Forest.outputs (signature : Label → GateIdeal.Profile Colour) : Forest Colour Label → List Colour
  | .nil => []
  | .cons tree rest => tree.output signature :: rest.outputs signature

theorem Forest.inputs_append : (a b : Forest Colour Label) →
    (a.append b).inputs = a.inputs ++ b.inputs
  | .nil, _ => rfl
  | .cons tree rest, b => by
      simp [Forest.append, Forest.inputs, Forest.inputs_append rest b, List.append_assoc]

theorem Forest.outputs_append (signature : Label → GateIdeal.Profile Colour) :
    (a b : Forest Colour Label) →
      (a.append b).outputs signature = a.outputs signature ++ b.outputs signature
  | .nil, _ => rfl
  | .cons tree rest, b => by
      simp [Forest.append, Forest.outputs, Forest.outputs_append signature rest b]

mutual
  def Tree.WellTyped (signature : Label → GateIdeal.Profile Colour) : Tree Colour Label → Prop
    | .input _ => True
    | .node label children => children.WellTyped signature ∧
        children.outputs signature = (signature label).inputs

  def Forest.WellTyped (signature : Label → GateIdeal.Profile Colour) : Forest Colour Label → Prop
    | .nil => True
    | .cons tree rest => tree.WellTyped signature ∧ rest.WellTyped signature
end

theorem Forest.wellTyped_append (signature : Label → GateIdeal.Profile Colour) :
    (a b : Forest Colour Label) →
      ((a.append b).WellTyped signature ↔ a.WellTyped signature ∧ b.WellTyped signature)
  | .nil, _ => by simp [Forest.append, Forest.WellTyped]
  | .cons tree rest, b => by
      simp [Forest.append, Forest.WellTyped, Forest.wellTyped_append signature rest b, and_assoc]

/-- A path to exactly one external input occurrence, retaining all side branches. -/
inductive Context (Colour : Type u) (Label : Type v) where
  | hole : Colour → Context Colour Label
  | under : Label → Forest Colour Label → Context Colour Label →
      Forest Colour Label → Context Colour Label

def Context.input : Context Colour Label → Colour
  | .hole colour => colour
  | .under _ _ inside _ => inside.input

def Context.output (signature : Label → GateIdeal.Profile Colour) : Context Colour Label → Colour
  | .hole colour => colour
  | .under label _ _ _ => (signature label).output

def Context.fill : Context Colour Label → Tree Colour Label → Tree Colour Label
  | .hole _, tree => tree
  | .under label before inside after, tree =>
      .node label (before.append (.cons (inside.fill tree) after))

/-- The original tree, with its selected input still present. -/
def Context.skeleton : Context Colour Label → Tree Colour Label
  | .hole colour => .input colour
  | .under label before inside after =>
      .node label (before.append (.cons inside.skeleton after))

def Context.prefix : Context Colour Label → List Colour
  | .hole _ => []
  | .under _ before inside _ => before.inputs ++ inside.prefix

def Context.suffix : Context Colour Label → List Colour
  | .hole _ => []
  | .under _ _ inside after => inside.suffix ++ after.inputs

def Context.index (context : Context Colour Label) : Nat := context.prefix.length

def Context.WellTyped (signature : Label → GateIdeal.Profile Colour) : Context Colour Label → Prop
  | .hole _ => True
  | .under label before inside after =>
      before.WellTyped signature ∧ inside.WellTyped signature ∧ after.WellTyped signature ∧
        before.outputs signature ++ [inside.output signature] ++ after.outputs signature =
          (signature label).inputs

theorem Context.fill_output (signature : Label → GateIdeal.Profile Colour)
    (context : Context Colour Label) (tree : Tree Colour Label)
    (compatible : tree.output signature = context.input) :
    (context.fill tree).output signature = context.output signature := by
  cases context with
  | hole colour => exact compatible
  | under label before inside after => rfl

/-- Exact ordered external boundary, including repeated-colour occurrences. -/
theorem Context.fill_inputs (context : Context Colour Label) (tree : Tree Colour Label) :
    (context.fill tree).inputs = context.prefix ++ tree.inputs ++ context.suffix := by
  induction context with
  | hole colour => simp [Context.fill, Context.prefix, Context.suffix]
  | under label before inside after ih =>
      simp [Context.fill, Tree.inputs, Forest.inputs_append, Forest.inputs,
        Context.prefix, Context.suffix, ih, List.append_assoc]

theorem Context.fill_wellTyped (signature : Label → GateIdeal.Profile Colour)
    (context : Context Colour Label) (tree : Tree Colour Label)
    (context_typed : context.WellTyped signature) (tree_typed : tree.WellTyped signature)
    (compatible : tree.output signature = context.input) :
    (context.fill tree).WellTyped signature := by
  induction context with
  | hole colour => exact tree_typed
  | under label before inside after ih =>
      obtain ⟨before_typed, inside_typed, after_typed, boundary⟩ := context_typed
      have inside_output := Context.fill_output signature inside tree compatible
      constructor
      · exact (Forest.wellTyped_append signature _ _).mpr
          ⟨before_typed, ih inside_typed compatible, after_typed⟩
      · simpa [Context.fill, Forest.outputs_append, Forest.outputs, inside_output,
          List.append_assoc] using boundary

theorem Context.right_identity (context : Context Colour Label) :
    context.fill (.input context.input) = context.skeleton := by
  induction context with
  | hole colour => rfl
  | under label before inside after ih => simp [Context.fill, Context.skeleton, Context.input, ih]

theorem Context.left_identity (colour : Colour) (tree : Tree Colour Label) :
    (Context.hole colour).fill tree = tree := rfl

theorem Context.skeleton_inputs (context : Context Colour Label) :
    context.skeleton.inputs = context.prefix ++ [context.input] ++ context.suffix := by
  rw [← context.right_identity]
  exact context.fill_inputs (.input context.input)

/-- Every context index is a genuine external leaf position. -/
theorem Context.index_in_bounds (context : Context Colour Label) :
    context.index < context.skeleton.inputs.length := by
  rw [context.skeleton_inputs]
  simp only [Context.index, List.length_append, List.length_singleton]
  omega

def Context.compose : Context Colour Label → Context Colour Label → Context Colour Label
  | .hole _, inner => inner
  | .under label before inside after, inner =>
      .under label before (inside.compose inner) after

theorem Context.fill_compose (outer inner : Context Colour Label) (tree : Tree Colour Label) :
    (outer.compose inner).fill tree = outer.fill (inner.fill tree) := by
  induction outer with
  | hole colour => rfl
  | under label before inside after ih => simp [Context.compose, Context.fill, ih]

theorem Context.compose_assoc (outer middle inner : Context Colour Label) :
    (outer.compose middle).compose inner = outer.compose (middle.compose inner) := by
  induction outer with
  | hole colour => rfl
  | under label before inside after ih => simp [Context.compose, ih]

theorem Context.compose_left_identity (colour : Colour) (context : Context Colour Label) :
    (Context.hole colour).compose context = context := rfl

theorem Context.compose_right_identity (context : Context Colour Label) :
    context.compose (.hole context.input) = context := by
  induction context with
  | hole colour => rfl
  | under label before inside after ih => simp [Context.compose, Context.input, ih]

theorem Context.compose_input (outer inner : Context Colour Label) :
    (outer.compose inner).input = inner.input := by
  induction outer with
  | hole colour => rfl
  | under label before inside after ih => exact ih

theorem Context.compose_prefix (outer inner : Context Colour Label) :
    (outer.compose inner).prefix = outer.prefix ++ inner.prefix := by
  induction outer with
  | hole colour => rfl
  | under label before inside after ih =>
      simp [Context.compose, Context.prefix, ih, List.append_assoc]

theorem Context.compose_suffix (outer inner : Context Colour Label) :
    (outer.compose inner).suffix = inner.suffix ++ outer.suffix := by
  induction outer with
  | hole colour => simp [Context.compose, Context.suffix]
  | under label before inside after ih =>
      simp [Context.compose, Context.suffix, ih, List.append_assoc]

/-- The nested selected position is i+j, measured in external leaf order. -/
theorem Context.compose_index (outer inner : Context Colour Label) :
    (outer.compose inner).index = outer.index + inner.index := by
  simp [Context.index, Context.compose_prefix, List.length_append]

theorem Context.nested_substitution (outer inner : Context Colour Label)
    (tree : Tree Colour Label) :
    (outer.compose inner).fill tree = outer.fill (inner.fill tree) ∧
      (outer.compose inner).index = outer.index + inner.index :=
  ⟨outer.fill_compose inner tree, outer.compose_index inner⟩

theorem Context.compose_output (signature : Label → GateIdeal.Profile Colour)
    (outer inner : Context Colour Label)
    (compatible : inner.output signature = outer.input) :
    (outer.compose inner).output signature = outer.output signature := by
  cases outer with
  | hole colour => exact compatible
  | under label before inside after => rfl

theorem Context.compose_wellTyped (signature : Label → GateIdeal.Profile Colour)
    (outer inner : Context Colour Label)
    (outer_typed : outer.WellTyped signature) (inner_typed : inner.WellTyped signature)
    (compatible : inner.output signature = outer.input) :
    (outer.compose inner).WellTyped signature := by
  induction outer with
  | hole colour => exact inner_typed
  | under label before inside after ih =>
      obtain ⟨before_typed, inside_typed, after_typed, boundary⟩ := outer_typed
      refine ⟨before_typed, ih inside_typed compatible, after_typed, ?_⟩
      simpa [Context.compose, Context.compose_output signature inside inner compatible] using boundary

def Tree.profile (signature : Label → GateIdeal.Profile Colour)
    (tree : Tree Colour Label) : GateIdeal.Profile Colour :=
  ⟨tree.inputs, tree.output signature⟩

theorem Context.skeleton_output (signature : Label → GateIdeal.Profile Colour)
    (context : Context Colour Label) :
    context.skeleton.output signature = context.output signature := by
  rw [← context.right_identity]
  exact context.fill_output signature (.input context.input) rfl

/-- The context determines an actual admissible slot in the profile-indexed API. -/
def Context.toSlot (signature : Label → GateIdeal.Profile Colour)
    (context : Context Colour Label) (tree : Tree Colour Label)
    (compatible : tree.output signature = context.input) :
    GateIdeal.Slot (context.skeleton.profile signature) (tree.profile signature) where
  before := context.prefix
  after := context.suffix
  boundary_eq := by
    change context.skeleton.inputs = context.prefix ++ [tree.output signature] ++ context.suffix
    rw [compatible]
    exact context.skeleton_inputs

theorem Context.fill_profile (signature : Label → GateIdeal.Profile Colour)
    (context : Context Colour Label) (tree : Tree Colour Label)
    (compatible : tree.output signature = context.input) :
    (context.fill tree).profile signature = (context.toSlot signature tree compatible).result := by
  simp [Tree.profile, Context.toSlot, GateIdeal.Slot.result, Context.fill_inputs,
    Context.fill_output signature context tree compatible, Context.skeleton_output]

/-- Syntax, typing and the exact multiary boundary are checked together. -/
theorem Context.typed_substitution (signature : Label → GateIdeal.Profile Colour)
    (context : Context Colour Label) (tree : Tree Colour Label)
    (context_typed : context.WellTyped signature) (tree_typed : tree.WellTyped signature)
    (compatible : tree.output signature = context.input) :
    (context.fill tree).WellTyped signature ∧
      (context.fill tree).profile signature = (context.toSlot signature tree compatible).result :=
  ⟨context.fill_wellTyped signature tree context_typed tree_typed compatible,
    context.fill_profile signature tree compatible⟩

/-! Disjoint holes are represented at their common branching node. The ordinary
single-hole contexts on each side may themselves have arbitrary depth. -/

structure Fork (Colour : Type u) (Label : Type v) where
  outside : Context Colour Label
  operation : Label
  before : Forest Colour Label
  left : Context Colour Label
  middle : Forest Colour Label
  right : Context Colour Label
  after : Forest Colour Label

def Fork.leftContext (fork : Fork Colour Label) (rightTree : Tree Colour Label) :
    Context Colour Label :=
  fork.outside.compose (.under fork.operation fork.before fork.left
    (fork.middle.append (.cons (fork.right.fill rightTree) fork.after)))

def Fork.rightContext (fork : Fork Colour Label) (leftTree : Tree Colour Label) :
    Context Colour Label :=
  fork.outside.compose (.under fork.operation
    (fork.before.append (.cons (fork.left.fill leftTree) fork.middle)) fork.right fork.after)

/-- Filling disjoint occurrences in either order retains the exact labelled tree. -/
theorem Fork.disjoint_substitution (fork : Fork Colour Label) (leftTree rightTree : Tree Colour Label) :
    (fork.leftContext rightTree).fill leftTree = (fork.rightContext leftTree).fill rightTree := by
  simp [Fork.leftContext, Fork.rightContext, Context.fill_compose, Context.fill,
    Forest.append_assoc, Forest.append]

theorem Fork.left_index (fork : Fork Colour Label) (tree : Tree Colour Label) :
    (fork.leftContext tree).index =
      fork.outside.index + fork.before.inputs.length + fork.left.index := by
  simp [Fork.leftContext, Context.compose_prefix, Context.index, Context.prefix,
    List.length_append, Nat.add_assoc]

theorem Fork.right_index (fork : Fork Colour Label) (tree : Tree Colour Label) :
    (fork.rightContext tree).index = fork.outside.index + fork.before.inputs.length +
      (fork.left.fill tree).inputs.length + fork.middle.inputs.length + fork.right.index := by
  simp [Fork.rightContext, Context.compose_prefix, Context.index, Context.prefix,
    Forest.inputs_append, Forest.inputs, List.length_append, Nat.add_assoc]

/-- A later disjoint substitution leaves the earlier slot index unchanged. -/
theorem Fork.left_index_unchanged (fork : Fork Colour Label) (a b : Tree Colour Label) :
    (fork.leftContext a).index = (fork.leftContext b).index := by
  rw [fork.left_index, fork.left_index]

/-- The second original slot k moves to k + arity(g) - 1 after the first graft. -/
theorem Fork.right_index_reindexed (fork : Fork Colour Label) (tree : Tree Colour Label) :
    (fork.rightContext tree).index =
      (fork.rightContext (.input fork.left.input)).index + tree.inputs.length - 1 := by
  rw [fork.right_index, fork.right_index]
  simp only [Context.fill_inputs, List.length_append, Tree.inputs, List.length_singleton]
  omega

theorem Fork.left_precedes_right (fork : Fork Colour Label) :
    (fork.leftContext (.input fork.right.input)).index <
      (fork.rightContext (.input fork.left.input)).index := by
  rw [fork.left_index, fork.right_index]
  simp only [Context.fill_inputs, List.length_append, Tree.inputs, List.length_singleton,
    Context.index]
  omega

/-! Persistent failed bound occurrences, not a predicate on the final output.
`bad` must classify immutable node labels with the relevant bound attempt and
checked evidence. A change to inputs or evidence needs a new node/attempt. -/

mutual
  def Tree.Rejected (bad : Label → Prop) : Tree Colour Label → Prop
    | .input _ => False
    | .node label children => bad label ∨ children.Rejected bad

  def Forest.Rejected (bad : Label → Prop) : Forest Colour Label → Prop
    | .nil => False
    | .cons tree rest => tree.Rejected bad ∨ rest.Rejected bad
end

theorem Forest.rejected_append (bad : Label → Prop) : (a b : Forest Colour Label) →
    ((a.append b).Rejected bad ↔ a.Rejected bad ∨ b.Rejected bad)
  | .nil, _ => by simp [Forest.append, Forest.Rejected]
  | .cons tree rest, b => by
      simp [Forest.append, Forest.Rejected, Forest.rejected_append bad rest b, or_assoc]

def Context.Rejected (bad : Label → Prop) : Context Colour Label → Prop
  | .hole _ => False
  | .under label before inside after =>
      bad label ∨ before.Rejected bad ∨ inside.Rejected bad ∨ after.Rejected bad

theorem Context.fill_rejected_iff (bad : Label → Prop)
    (context : Context Colour Label) (tree : Tree Colour Label) :
    (context.fill tree).Rejected bad ↔ context.Rejected bad ∨ tree.Rejected bad := by
  induction context with
  | hole colour => simp [Context.fill, Context.Rejected]
  | under label before inside after ih =>
      simp [Context.fill, Tree.Rejected, Forest.rejected_append, Forest.Rejected,
        Context.Rejected, ih, or_assoc, or_left_comm, or_comm]

theorem Context.inner_rejection_preserved (bad : Label → Prop)
    (context : Context Colour Label) (tree : Tree Colour Label)
    (failed : tree.Rejected bad) : (context.fill tree).Rejected bad :=
  (context.fill_rejected_iff bad tree).mpr (Or.inr failed)

theorem Context.outer_rejection_preserved (bad : Label → Prop)
    (context : Context Colour Label) (tree : Tree Colour Label)
    (failed : context.skeleton.Rejected bad) : (context.fill tree).Rejected bad := by
  rw [← context.right_identity] at failed
  have inherited := (context.fill_rejected_iff bad (.input context.input)).mp failed
  cases inherited with
  | inl context_failed => exact (context.fill_rejected_iff bad tree).mpr (Or.inl context_failed)
  | inr impossible => exact False.elim impossible

theorem identity_not_rejected (bad : Label → Prop) (colour : Colour) :
    ¬ (Tree.input colour : Tree Colour Label).Rejected bad := fun h => h

/-! Finite controls make repeated colours and nullary insertion nonvacuous.
These are syntax/typing controls, not LLM or gate-accuracy experiments. -/

namespace Controls

inductive Operation where
  | pair
  | closed

def signature : Operation → GateIdeal.Profile Unit
  | .pair => ⟨[(), ()], ()⟩
  | .closed => ⟨[], ()⟩

def first : Context Unit Operation :=
  .under .pair .nil (.hole ()) (.cons (.input ()) .nil)

def second : Context Unit Operation :=
  .under .pair (.cons (.input ()) .nil) (.hole ()) .nil

theorem repeated_colour_does_not_identify_slots :
    first.skeleton = second.skeleton ∧ first.input = second.input ∧
      first.index = 0 ∧ second.index = 1 ∧ first.index ≠ second.index := by
  exact ⟨rfl, rfl, rfl, rfl, by decide⟩

theorem both_repeated_colour_slots_wellTyped :
    first.WellTyped signature ∧ second.WellTyped signature := by
  simp [first, second, Context.WellTyped, Context.output, Forest.WellTyped,
    Forest.outputs, Tree.WellTyped, Tree.output, signature]

def closedTree : Tree Unit Operation := .node .closed .nil

theorem nullary_substitution_retains_other_occurrence :
    (first.fill closedTree).WellTyped signature ∧
      (first.fill closedTree).inputs = [()] := by
  constructor
  · apply first.fill_wellTyped signature closedTree
      both_repeated_colour_slots_wellTyped.left
    · exact ⟨True.intro, rfl⟩
    · rfl
  · rfl

def pairFork : Fork Unit Operation where
  outside := .hole ()
  operation := .pair
  before := .nil
  left := .hole ()
  middle := .nil
  right := .hole ()
  after := .nil

theorem nullary_disjoint_shift :
    (pairFork.rightContext (.input ())).index = 1 ∧
      (pairFork.rightContext closedTree).index = 0 := ⟨rfl, rfl⟩

end Controls

#print axioms Context.fill_wellTyped
#print axioms Context.typed_substitution
#print axioms Context.right_identity
#print axioms Context.compose_assoc
#print axioms Context.compose_right_identity
#print axioms Context.nested_substitution
#print axioms Context.compose_wellTyped
#print axioms Fork.disjoint_substitution
#print axioms Fork.left_index_unchanged
#print axioms Fork.right_index_reindexed
#print axioms Fork.left_precedes_right
#print axioms Context.fill_rejected_iff
#print axioms Context.inner_rejection_preserved
#print axioms Context.outer_rejection_preserved
#print axioms Controls.repeated_colour_does_not_identify_slots
#print axioms Controls.nullary_substitution_retains_other_occurrence
#print axioms Controls.nullary_disjoint_shift

end Woland.PlanarTree
