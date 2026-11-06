import PlanarTree

/-!
# Numeric external-leaf selection for ordered Woland trees

AuthorityEffect: None.

Selection is structural, left to right, and counts external input occurrences.
Nullary subtrees consume zero input slots. Equal colours do not identify slots.
The proofs concern this Lean implementation; a checked translation of Rust
normalized terms and numeric substitution remains a distinct refinement task.
-/

namespace Woland.PlanarTree

universe u v
variable {Colour : Type u} {Label : Type v}

structure ForestSelection (Colour : Type u) (Label : Type v) where
  before : Forest Colour Label
  inside : Context Colour Label
  after : Forest Colour Label

def ForestSelection.skeleton (selected : ForestSelection Colour Label) : Forest Colour Label :=
  selected.before.append (.cons selected.inside.skeleton selected.after)

def ForestSelection.index (selected : ForestSelection Colour Label) : Nat :=
  selected.before.inputs.length + selected.inside.index

mutual
  def Tree.select : Tree Colour Label → Nat → Option (Context Colour Label)
    | .input colour, index => if index = 0 then some (.hole colour) else none
    | .node label children, index =>
        (children.select index).map (fun selected =>
          .under label selected.before selected.inside selected.after)

  def Forest.select : Forest Colour Label → Nat → Option (ForestSelection Colour Label)
    | .nil, _ => none
    | .cons tree rest, index =>
        if index < tree.inputs.length then
          (tree.select index).map (fun inside => ⟨.nil, inside, rest⟩)
        else
          (rest.select (index - tree.inputs.length)).map (fun selected =>
            ⟨.cons tree selected.before, selected.inside, selected.after⟩)
end

mutual
  theorem Tree.select_correct (tree : Tree Colour Label) (index : Nat)
      (context : Context Colour Label) (selected : tree.select index = some context) :
      context.skeleton = tree ∧ context.index = index := by
    cases tree with
    | input colour =>
        by_cases zero : index = 0
        · simp [Tree.select, zero] at selected
          subst context
          exact ⟨rfl, zero.symm⟩
        · simp [Tree.select, zero] at selected
    | node label children =>
        cases selection : children.select index with
        | none => simp [Tree.select, selection] at selected
        | some entry =>
            simp [Tree.select, selection] at selected
            subst context
            obtain ⟨skeleton, position⟩ := Forest.select_correct children index entry selection
            refine ⟨congrArg (Tree.node label) skeleton, ?_⟩
            simpa [Context.index, Context.prefix, List.length_append,
              ForestSelection.index] using position

  theorem Forest.select_correct (forest : Forest Colour Label) (index : Nat)
      (entry : ForestSelection Colour Label) (selected : forest.select index = some entry) :
      entry.skeleton = forest ∧ entry.index = index := by
    cases forest with
    | nil => simp [Forest.select] at selected
    | cons tree rest =>
        by_cases in_head : index < tree.inputs.length
        · cases selection : tree.select index with
          | none => simp [Forest.select, in_head, selection] at selected
          | some context =>
              simp [Forest.select, in_head, selection] at selected
              subst entry
              obtain ⟨skeleton, position⟩ := Tree.select_correct tree index context selection
              constructor
              · exact congrArg (fun head => Forest.cons head rest) skeleton
              · simpa [ForestSelection.index, Forest.inputs] using position
        · cases selection : rest.select (index - tree.inputs.length) with
          | none => simp [Forest.select, in_head, selection] at selected
          | some tail =>
              simp [Forest.select, in_head, selection] at selected
              subst entry
              obtain ⟨skeleton, position⟩ :=
                Forest.select_correct rest (index - tree.inputs.length) tail selection
              constructor
              · exact congrArg (Forest.cons tree) skeleton
              · simp only [ForestSelection.index, Forest.inputs, List.length_append]
                simp only [ForestSelection.index] at position
                omega
end

mutual
  theorem Tree.select_complete (tree : Tree Colour Label) (index : Nat)
      (in_range : index < tree.inputs.length) :
      ∃ context, tree.select index = some context := by
    cases tree with
    | input colour =>
        have zero : index = 0 := by simpa [Tree.inputs] using in_range
        exact ⟨.hole colour, by simp [Tree.select, zero]⟩
    | node label children =>
        obtain ⟨entry, selected⟩ := Forest.select_complete children index in_range
        exact ⟨.under label entry.before entry.inside entry.after, by simp [Tree.select, selected]⟩

  theorem Forest.select_complete (forest : Forest Colour Label) (index : Nat)
      (in_range : index < forest.inputs.length) :
      ∃ entry, forest.select index = some entry := by
    cases forest with
    | nil => simp [Forest.inputs] at in_range
    | cons tree rest =>
        by_cases in_head : index < tree.inputs.length
        · obtain ⟨context, selected⟩ := Tree.select_complete tree index in_head
          exact ⟨⟨.nil, context, rest⟩, by simp [Forest.select, in_head, selected]⟩
        · have in_tail : index - tree.inputs.length < rest.inputs.length := by
            simp only [Forest.inputs, List.length_append] at in_range
            omega
          obtain ⟨entry, selected⟩ := Forest.select_complete rest _ in_tail
          exact ⟨⟨.cons tree entry.before, entry.inside, entry.after⟩,
            by simp [Forest.select, in_head, selected]⟩
end

/-- A failed lookup is exactly an out-of-range occurrence, including nullary trees. -/
theorem Tree.select_none_iff (tree : Tree Colour Label) (index : Nat) :
    tree.select index = none ↔ tree.inputs.length ≤ index := by
  constructor
  · intro absent
    by_cases below : index < tree.inputs.length
    · obtain ⟨context, selected⟩ := tree.select_complete index below
      rw [absent] at selected
      cases selected
    · omega
  · intro outside
    cases selected : tree.select index with
    | none => rfl
    | some context =>
        obtain ⟨skeleton, position⟩ := tree.select_correct index context selected
        have bound := context.index_in_bounds
        rw [skeleton, position] at bound
        omega

/-- Earlier side branches consume their full external arity, including zero. -/
theorem Forest.select_after (before after : Forest Colour Label)
    (tree : Tree Colour Label) (index : Nat) (context : Context Colour Label)
    (in_range : index < tree.inputs.length) (selected : tree.select index = some context) :
    (before.append (.cons tree after)).select (before.inputs.length + index) =
      some ⟨before, context, after⟩ := by
  cases before with
  | nil => simp [Forest.append, Forest.inputs, Forest.select, in_range, selected]
  | cons head rest =>
      have branch : ¬ head.inputs.length + rest.inputs.length + index < head.inputs.length := by omega
      have difference : head.inputs.length + rest.inputs.length + index - head.inputs.length =
          rest.inputs.length + index := by omega
      have recursive := Forest.select_after rest after tree index context in_range selected
      simp [Forest.append, Forest.inputs, List.length_append, Forest.select,
        branch, difference, recursive]

/-- Every concrete context is recovered exactly, not merely up to its colour. -/
theorem Context.select_skeleton (context : Context Colour Label) :
    context.skeleton.select context.index = some context := by
  induction context with
  | hole colour => simp [Context.skeleton, Context.index, Context.prefix, Tree.select]
  | under label before inside after ih =>
      have recursive := Forest.select_after before after inside.skeleton inside.index inside
        inside.index_in_bounds ih
      have position : (Context.under label before inside after).index =
          before.inputs.length + inside.index := by
        simp [Context.index, Context.prefix, List.length_append]
      rw [position]
      simp [Context.skeleton, Tree.select, recursive]

theorem Tree.select_of_context (tree : Tree Colour Label) (index : Nat)
    (context : Context Colour Label) (skeleton : context.skeleton = tree)
    (position : context.index = index) : tree.select index = some context := by
  rw [← skeleton, ← position]
  exact context.select_skeleton

theorem Context.unique_at_index (first second : Context Colour Label)
    (same_tree : first.skeleton = second.skeleton) (same_index : first.index = second.index) :
    first = second := by
  have first_selected := first.select_skeleton
  have second_selected := second.select_skeleton
  rw [← same_tree, ← same_index] at second_selected
  exact Option.some.inj (first_selected.symm.trans second_selected)

/-- Selection is both a complete decision procedure and a unique reconstruction. -/
theorem Tree.select_unique_complete (tree : Tree Colour Label) (index : Nat)
    (in_range : index < tree.inputs.length) :
    ∃ context : Context Colour Label, context.skeleton = tree ∧ context.index = index ∧
      ∀ other : Context Colour Label, other.skeleton = tree → other.index = index → other = context := by
  obtain ⟨context, selected⟩ := tree.select_complete index in_range
  obtain ⟨skeleton, position⟩ := tree.select_correct index context selected
  refine ⟨context, skeleton, position, ?_⟩
  intro other other_skeleton other_position
  exact other.unique_at_index context (other_skeleton.trans skeleton.symm)
    (other_position.trans position.symm)

theorem Context.skeleton_wellTyped_iff (signature : Label → GateIdeal.Profile Colour)
    (context : Context Colour Label) :
    context.skeleton.WellTyped signature ↔ context.WellTyped signature := by
  induction context with
  | hole colour => rfl
  | under label before inside after ih =>
      simp [Context.skeleton, Tree.WellTyped, Forest.wellTyped_append, Forest.WellTyped,
        Forest.outputs_append, Forest.outputs, Context.WellTyped, Context.skeleton_output,
        ih, and_assoc]

/-- A total, still executable selector is available under the proven range check. -/
def Tree.selectTotal (tree : Tree Colour Label) (index : Nat)
    (in_range : index < tree.inputs.length) : Context Colour Label :=
  (tree.select index).get (by
    cases selected : tree.select index with
    | none =>
        have outside := (tree.select_none_iff index).mp selected
        omega
    | some context => rfl)

theorem Tree.selectTotal_selected (tree : Tree Colour Label) (index : Nat)
    (in_range : index < tree.inputs.length) :
    tree.select index = some (tree.selectTotal index in_range) := by
  unfold Tree.selectTotal
  exact (Option.some_get _).symm

theorem Tree.selectTotal_correct (tree : Tree Colour Label) (index : Nat)
    (in_range : index < tree.inputs.length) :
    (tree.selectTotal index in_range).skeleton = tree ∧
      (tree.selectTotal index in_range).index = index :=
  tree.select_correct index _ (tree.selectTotal_selected index in_range)

/-- An occurrence is determined by its position even when all colours coincide. -/
theorem input_split_unique : (left left' : List Colour) → (colour colour' : Colour) →
    (right right' : List Colour) → left.length = left'.length →
    left ++ [colour] ++ right = left' ++ [colour'] ++ right' →
    left = left' ∧ colour = colour' ∧ right = right'
  | [], [], _, _, _, _, _, same_boundary =>
      ⟨rfl, (List.cons.inj same_boundary).1, (List.cons.inj same_boundary).2⟩
  | [], _ :: _, _, _, _, _, same_length, _ => False.elim (Nat.noConfusion same_length)
  | _ :: _, [], _, _, _, _, same_length, _ => False.elim (Nat.noConfusion same_length)
  | _head :: tail, head' :: tail', colour, colour', right, right', same_length, same_boundary =>
      let head_tail := List.cons.inj same_boundary
      let recursive := input_split_unique tail tail' colour colour' right right'
        (Nat.succ.inj same_length) head_tail.2
      ⟨(congrArg (fun value => value :: tail) head_tail.1).trans
        (congrArg (List.cons head') recursive.1), recursive.2.1, recursive.2.2⟩

/-- Concrete operations indexed by their validated ordered boundary. -/
structure TypedTree (signature : Label → GateIdeal.Profile Colour)
    (profile : GateIdeal.Profile Colour) where
  tree : Tree Colour Label
  wellTyped : tree.WellTyped signature
  inputs : tree.inputs = profile.inputs
  output : tree.output signature = profile.output

def TypedTree.compositionContext (signature : Label → GateIdeal.Profile Colour)
    {outer inner : GateIdeal.Profile Colour} (slot : GateIdeal.Slot outer inner)
    (tree : TypedTree signature outer) : Context Colour Label :=
  tree.tree.selectTotal slot.before.length (by
    rw [tree.inputs, slot.boundary_eq]
    simp only [List.length_append, List.length_singleton]
    omega)

theorem TypedTree.compositionContext_correct (signature : Label → GateIdeal.Profile Colour)
    {outer inner : GateIdeal.Profile Colour} (slot : GateIdeal.Slot outer inner)
    (tree : TypedTree signature outer) :
    (TypedTree.compositionContext signature slot tree).skeleton = tree.tree ∧
      (TypedTree.compositionContext signature slot tree).index = slot.before.length :=
  tree.tree.selectTotal_correct slot.before.length _

theorem TypedTree.compositionContext_boundary (signature : Label → GateIdeal.Profile Colour)
    {outer inner : GateIdeal.Profile Colour} (slot : GateIdeal.Slot outer inner)
    (tree : TypedTree signature outer) :
    let context := TypedTree.compositionContext signature slot tree
    context.prefix = slot.before ∧ context.input = inner.output ∧ context.suffix = slot.after := by
  let context := TypedTree.compositionContext signature slot tree
  have correct := TypedTree.compositionContext_correct signature slot tree
  apply input_split_unique context.prefix slot.before context.input inner.output
    context.suffix slot.after correct.2
  rw [← context.skeleton_inputs, correct.1, tree.inputs, slot.boundary_eq]

/-- The body is numeric selection followed by structural filling, with no choice. -/
def TypedTree.compose (signature : Label → GateIdeal.Profile Colour)
    {outer inner : GateIdeal.Profile Colour} (slot : GateIdeal.Slot outer inner)
    (f : TypedTree signature outer) (g : TypedTree signature inner) :
    TypedTree signature slot.result := by
  let context := TypedTree.compositionContext signature slot f
  have correct := TypedTree.compositionContext_correct signature slot f
  have boundary := TypedTree.compositionContext_boundary signature slot f
  have compatible : g.tree.output signature = context.input := g.output.trans boundary.2.1.symm
  have context_typed : context.WellTyped signature := by
    apply (context.skeleton_wellTyped_iff signature).mp
    rw [correct.1]
    exact f.wellTyped
  refine ⟨context.fill g.tree,
    context.fill_wellTyped signature g.tree context_typed g.wellTyped compatible, ?_, ?_⟩
  · change (context.fill g.tree).inputs = slot.before ++ inner.inputs ++ slot.after
    rw [context.fill_inputs, boundary.1, boundary.2.2, g.inputs]
  · change (context.fill g.tree).output signature = outer.output
    rw [context.fill_output signature g.tree compatible, ← context.skeleton_output signature,
      correct.1]
    exact f.output

def typedTreeSystem (signature : Label → GateIdeal.Profile Colour) :
    GateIdeal.PartialSystem Colour where
  Op := TypedTree signature
  compose := TypedTree.compose signature

/-- The failure predicate is on retained bound labels, not final output text. -/
def typedTreeIdeal (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop) :
    GateIdeal.Ideal (typedTreeSystem signature) where
  rejected := fun {_} tree => tree.tree.Rejected bad
  outer_closed := by
    intro outer inner slot f g failed
    change ((TypedTree.compositionContext signature slot f).fill g.tree).Rejected bad
    apply Context.outer_rejection_preserved bad
    rw [(TypedTree.compositionContext_correct signature slot f).1]
    exact failed
  inner_closed := by
    intro outer inner slot f g failed
    change ((TypedTree.compositionContext signature slot f).fill g.tree).Rejected bad
    exact Context.inner_rejection_preserved bad _ _ failed

def typedIdentity (signature : Label → GateIdeal.Profile Colour) (colour : Colour) :
    TypedTree signature ⟨[colour], colour⟩ :=
  ⟨.input colour, True.intro, rfl, rfl⟩

theorem typedIdentity_not_rejected (signature : Label → GateIdeal.Profile Colour)
    (bad : Label → Prop) (colour : Colour) :
    ¬ (typedTreeIdeal signature bad).rejected (typedIdentity signature colour) :=
  identity_not_rejected bad colour

/-- The prior Rees construction now has a concrete typed tree carrier. -/
theorem typed_quotient_identity_survives (signature : Label → GateIdeal.Profile Colour)
    (bad : Label → Prop) (colour : Colour) :
    GateIdeal.project (typedTreeIdeal signature bad) (typedIdentity signature colour) ≠
      GateIdeal.bottom (typedTreeIdeal signature bad) ⟨[colour], colour⟩ :=
  GateIdeal.identity_survives (typedTreeIdeal signature bad) (typedIdentity signature)
    (typedIdentity_not_rejected signature bad) colour

theorem TypedTree.right_identity_tree (signature : Label → GateIdeal.Profile Colour)
    {outer : GateIdeal.Profile Colour} (colour : Colour)
    (slot : GateIdeal.Slot outer ⟨[colour], colour⟩) (f : TypedTree signature outer) :
    (TypedTree.compose signature slot f (typedIdentity signature colour)).tree = f.tree := by
  let context := TypedTree.compositionContext signature slot f
  have boundary := TypedTree.compositionContext_boundary signature slot f
  have hole_colour : context.input = colour := boundary.2.1
  change context.fill (.input colour) = f.tree
  rw [← hole_colour, context.right_identity]
  exact (TypedTree.compositionContext_correct signature slot f).1

theorem Context.eq_hole_of_skeleton_input (context : Context Colour Label) (colour : Colour)
    (skeleton : context.skeleton = Tree.input colour) : context = .hole colour := by
  cases context with
  | hole value =>
      have equal := Tree.input.inj skeleton
      cases equal
      rfl
  | under label before inside after => cases skeleton

theorem TypedTree.left_identity_tree (signature : Label → GateIdeal.Profile Colour)
    {inner : GateIdeal.Profile Colour} (colour : Colour)
    (slot : GateIdeal.Slot ⟨[colour], colour⟩ inner) (g : TypedTree signature inner) :
    (TypedTree.compose signature slot (typedIdentity signature colour) g).tree = g.tree := by
  let context := TypedTree.compositionContext signature slot (typedIdentity signature colour)
  have skeleton : context.skeleton = Tree.input colour :=
    (TypedTree.compositionContext_correct signature slot (typedIdentity signature colour)).1
  change context.fill g.tree = g.tree
  rw [context.eq_hole_of_skeleton_input colour skeleton]
  rfl

theorem Context.skeleton_compose (outer inner : Context Colour Label) :
    (outer.compose inner).skeleton = outer.fill inner.skeleton := by
  induction outer with
  | hole colour => rfl
  | under label before inside after ih => simp [Context.compose, Context.skeleton, Context.fill, ih]

/-- The executable lookup selects the nested occurrence at i+j after grafting. -/
theorem Tree.select_nested_index (outer inner : Context Colour Label) :
    (outer.fill inner.skeleton).select (outer.index + inner.index) = some (outer.compose inner) := by
  rw [← outer.skeleton_compose inner, ← outer.compose_index inner]
  exact (outer.compose inner).select_skeleton

/-- The executable lookup selects the later disjoint occurrence at its shifted index. -/
theorem Fork.select_disjoint_reindexed (fork : Fork Colour Label) (tree : Tree Colour Label) :
    ((fork.leftContext (.input fork.right.input)).fill tree).select
        ((fork.rightContext (.input fork.left.input)).index + tree.inputs.length - 1) =
      some (fork.rightContext tree) := by
  have skeleton : (fork.leftContext (.input fork.right.input)).fill tree =
      (fork.rightContext tree).skeleton := by
    rw [fork.disjoint_substitution tree (.input fork.right.input)]
    have input : (fork.rightContext tree).input = fork.right.input := by
      simp [Fork.rightContext, Context.compose_input, Context.input]
    rw [← input, Context.right_identity]
  rw [skeleton, ← fork.right_index_reindexed tree]
  exact (fork.rightContext tree).select_skeleton

theorem typed_quotient_substitution (signature : Label → GateIdeal.Profile Colour)
    (bad : Label → Prop) {outer inner : GateIdeal.Profile Colour}
    (slot : GateIdeal.Slot outer inner) (f : TypedTree signature outer) (g : TypedTree signature inner) :
    GateIdeal.project (typedTreeIdeal signature bad) (TypedTree.compose signature slot f g) =
      GateIdeal.quotientSubstitute (typedTreeIdeal signature bad) slot
        (GateIdeal.project (typedTreeIdeal signature bad) f)
        (GateIdeal.project (typedTreeIdeal signature bad) g) :=
  GateIdeal.project_substitution (typedTreeIdeal signature bad) slot f g

namespace Controls

theorem numeric_repeated_colour :
    first.skeleton.select 0 = some first ∧ first.skeleton.select 1 = some second := ⟨rfl, rfl⟩

theorem numeric_nullary_out_of_range : closedTree.select 0 = none := rfl

theorem numeric_nullary_side_branch_skipped :
    (Tree.node Operation.pair (.cons closedTree (.cons (.input ()) .nil))).select 0 =
      some (.under .pair (.cons closedTree .nil) (.hole ()) .nil) := rfl

end Controls

#print axioms Tree.select_correct
#print axioms Tree.select_complete
#print axioms Tree.select_none_iff
#print axioms Context.select_skeleton
#print axioms Context.unique_at_index
#print axioms Tree.select_unique_complete
#print axioms Context.skeleton_wellTyped_iff
#print axioms Tree.selectTotal_correct
#print axioms input_split_unique
#print axioms TypedTree.compositionContext_boundary
#print axioms TypedTree.compose
#print axioms typedTreeIdeal
#print axioms typed_quotient_identity_survives
#print axioms TypedTree.right_identity_tree
#print axioms TypedTree.left_identity_tree
#print axioms Tree.select_nested_index
#print axioms Fork.select_disjoint_reindexed
#print axioms typed_quotient_substitution
#print axioms Controls.numeric_repeated_colour
#print axioms Controls.numeric_nullary_out_of_range
#print axioms Controls.numeric_nullary_side_branch_skipped

end Woland.PlanarTree
