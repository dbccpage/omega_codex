import SlotSelection

/-!
# Explicit finite input actions over an unchanged planar tree

AuthorityEffect: None.

An input action reindexes external occurrences. It does not reorder operation
children or erase labels. The concrete finite splice below enumerates outer
prefix, inner boundary, outer suffix; colours may repeat and the inner boundary
may be empty. These results concern this Lean implementation, not compiled Rust,
canonical bytes, arbitrary graph symmetry, evaluation, or receipt authority.
-/

namespace Woland.InputAction

universe u v

/-- Explicit inverse data, with no choice or assumed action laws. -/
structure IndexEquiv (A : Type u) (B : Type v) where
  toFun : A → B
  invFun : B → A
  left_inv : ∀ x, invFun (toFun x) = x
  right_inv : ∀ x, toFun (invFun x) = x

namespace IndexEquiv

variable {A B C D : Type}

theorem ext (first second : IndexEquiv A B)
    (same : ∀ x, first.toFun x = second.toFun x) : first = second := by
  have forward : first.toFun = second.toFun := funext same
  have backward : first.invFun = second.invFun := by
    funext value
    calc
      first.invFun value = first.invFun (second.toFun (second.invFun value)) :=
        congrArg first.invFun (second.right_inv value).symm
      _ = first.invFun (first.toFun (second.invFun value)) :=
        congrArg first.invFun (same _).symm
      _ = second.invFun value := first.left_inv _
  cases first
  cases second
  cases forward
  cases backward
  rfl

def refl (A : Type) : IndexEquiv A A := ⟨id, id, fun _ => rfl, fun _ => rfl⟩

def comp (first : IndexEquiv B C) (second : IndexEquiv A B) : IndexEquiv A C where
  toFun x := first.toFun (second.toFun x)
  invFun x := second.invFun (first.invFun x)
  left_inv x := by rw [first.left_inv, second.left_inv]
  right_inv x := by rw [second.right_inv, first.right_inv]

def symm (permutation : IndexEquiv A B) : IndexEquiv B A :=
  ⟨permutation.invFun, permutation.toFun, permutation.right_inv, permutation.left_inv⟩

theorem comp_assoc (first : IndexEquiv C D) (second : IndexEquiv B C)
    (third : IndexEquiv A B) : (first.comp second).comp third = first.comp (second.comp third) :=
  ext _ _ (fun _ => rfl)

theorem comp_refl (permutation : IndexEquiv A B) :
    permutation.comp (refl A) = permutation := ext _ _ (fun _ => rfl)

theorem refl_comp (permutation : IndexEquiv A B) :
    (refl B).comp permutation = permutation := ext _ _ (fun _ => rfl)

theorem comp_symm (permutation : IndexEquiv A B) :
    permutation.comp permutation.symm = refl B := ext _ _ permutation.right_inv

theorem symm_comp (permutation : IndexEquiv A B) :
    permutation.symm.comp permutation = refl A := ext _ _ permutation.left_inv

theorem injective (permutation : IndexEquiv A B) {first second : A}
    (same : permutation.toFun first = permutation.toFun second) : first = second := by
  have inverse := congrArg permutation.invFun same
  simpa [permutation.left_inv] using inverse

end IndexEquiv

abbrev Permutation (arity : Nat) := IndexEquiv (Fin arity) (Fin arity)

/-- An outer occurrence other than the replaced one, or a new inner occurrence. -/
abbrev Replacement (arity inner : Nat) (slot : Fin arity) :=
  Sum {index : Fin arity // index ≠ slot} (Fin inner)

def replacementSize (arity inner : Nat) : Nat := arity + inner - 1

def flatten {arity inner : Nat} (slot : Fin arity) :
    Replacement arity inner slot → Fin (replacementSize arity inner)
  | .inl ⟨index, different⟩ =>
      if earlier : index.val < slot.val then
        ⟨index.val, by have := slot.isLt; unfold replacementSize; omega⟩
      else
        ⟨index.val + inner - 1, by
          have := index.isLt
          have : index.val ≠ slot.val := fun equal => different (Fin.ext equal)
          unfold replacementSize
          omega⟩
  | .inr index =>
      ⟨slot.val + index.val, by
        have := slot.isLt
        have := index.isLt
        unfold replacementSize
        omega⟩

def unflatten {arity inner : Nat} (slot : Fin arity)
    (index : Fin (replacementSize arity inner)) : Replacement arity inner slot :=
  if earlier : index.val < slot.val then
    .inl ⟨⟨index.val, by have := slot.isLt; omega⟩, by
      intro same
      have equal := congrArg Fin.val same
      change index.val = slot.val at equal
      omega⟩
  else if inserted : index.val < slot.val + inner then
    .inr ⟨index.val - slot.val, by omega⟩
  else
    .inl ⟨⟨index.val + 1 - inner, by
      have := index.isLt
      have := slot.isLt
      unfold replacementSize at *
      omega⟩, by
      intro same
      have equal := congrArg Fin.val same
      change index.val + 1 - inner = slot.val at equal
      omega⟩

theorem unflatten_flatten {arity inner : Nat} (slot : Fin arity)
    (index : Replacement arity inner slot) : unflatten slot (flatten slot index) = index := by
  cases index with
  | inl outer =>
      obtain ⟨index, different⟩ := outer
      have unequal : index.val ≠ slot.val := fun equal => different (Fin.ext equal)
      by_cases earlier : index.val < slot.val
      · simp [flatten, earlier, unflatten]
      · have later : slot.val < index.val := by omega
        have not_earlier : ¬ index.val + inner - 1 < slot.val := by omega
        have not_inserted : ¬ index.val + inner - 1 < slot.val + inner := by omega
        simp only [flatten, earlier, ↓reduceDIte, unflatten, not_earlier, not_inserted]
        congr 2
        apply Fin.ext
        simp
        omega
  | inr inner_index =>
      have not_earlier : ¬ slot.val + inner_index.val < slot.val := by omega
      have inserted : slot.val + inner_index.val < slot.val + inner := by omega
      simp [flatten, unflatten, not_earlier, inserted]

theorem flatten_unflatten {arity inner : Nat} (slot : Fin arity)
    (index : Fin (replacementSize arity inner)) : flatten slot (unflatten slot index) = index := by
  by_cases earlier : index.val < slot.val
  · simp [unflatten, earlier, flatten]
  · by_cases inserted : index.val < slot.val + inner
    · simp [unflatten, earlier, inserted, flatten]
      apply Fin.ext
      simp
      omega
    · have later : ¬ index.val + 1 - inner < slot.val := by omega
      simp only [unflatten, earlier, inserted, ↓reduceDIte, flatten, later]
      apply Fin.ext
      simp
      omega

def replacementOrder {arity inner : Nat} (slot : Fin arity) :
    IndexEquiv (Replacement arity inner slot) (Fin (replacementSize arity inner)) :=
  ⟨flatten slot, unflatten slot, unflatten_flatten slot, flatten_unflatten slot⟩

def replacementMap {arity inner : Nat} (outer : Permutation arity)
    (inside : Permutation inner) (slot : Fin arity) :
    Replacement arity inner slot → Replacement arity inner (outer.toFun slot)
  | .inl ⟨index, different⟩ =>
      .inl ⟨outer.toFun index, fun same => different (outer.injective same)⟩
  | .inr index => .inr (inside.toFun index)

def replacementInverse {arity inner : Nat} (outer : Permutation arity)
    (inside : Permutation inner) (slot : Fin arity) :
    Replacement arity inner (outer.toFun slot) → Replacement arity inner slot
  | .inl ⟨index, different⟩ => .inl ⟨outer.invFun index, by
      intro same
      apply different
      calc
        index = outer.toFun (outer.invFun index) := (outer.right_inv index).symm
        _ = outer.toFun slot := congrArg outer.toFun same⟩
  | .inr index => .inr (inside.invFun index)

def replacementTransport {arity inner : Nat} (outer : Permutation arity)
    (inside : Permutation inner) (slot : Fin arity) :
    IndexEquiv (Replacement arity inner slot) (Replacement arity inner (outer.toFun slot)) where
  toFun := replacementMap outer inside slot
  invFun := replacementInverse outer inside slot
  left_inv index := by
    cases index with
    | inl external =>
        apply congrArg Sum.inl
        apply Subtype.ext
        exact outer.left_inv external.val
    | inr internal => exact congrArg Sum.inr (inside.left_inv internal)
  right_inv index := by
    cases index with
    | inl external =>
        apply congrArg Sum.inl
        apply Subtype.ext
        exact outer.right_inv external.val
    | inr internal => exact congrArg Sum.inr (inside.right_inv internal)

theorem replacementMap_comp {arity inner : Nat}
    (outer first : Permutation arity) (inside second : Permutation inner)
    (slot : Fin arity) (index : Replacement arity inner slot) :
    replacementMap (outer.comp first) (inside.comp second) slot index =
      replacementMap outer inside (first.toFun slot) (replacementMap first second slot index) := by
  cases index <;> rfl

/-- The complete external-to-planar bijection after replacing one external slot. -/
def splice {arity inner : Nat} (outer : Permutation arity)
    (inside : Permutation inner) (slot : Fin arity) : Permutation (replacementSize arity inner) :=
  (replacementOrder (outer.toFun slot)).comp
    ((replacementTransport outer inside slot).comp (replacementOrder slot).symm)

theorem splice_flatten {arity inner : Nat} (outer : Permutation arity)
    (inside : Permutation inner) (slot : Fin arity) (index : Replacement arity inner slot) :
    (splice outer inside slot).toFun (flatten slot index) =
      flatten (outer.toFun slot) (replacementMap outer inside slot index) := by
  change flatten (outer.toFun slot)
    (replacementMap outer inside slot (unflatten slot (flatten slot index))) = _
  rw [unflatten_flatten]

theorem splice_refl {arity inner : Nat} (slot : Fin arity) :
    splice (IndexEquiv.refl (Fin arity)) (IndexEquiv.refl (Fin inner)) slot =
      IndexEquiv.refl (Fin (replacementSize arity inner)) := by
  apply IndexEquiv.ext
  intro index
  change flatten slot (replacementMap (IndexEquiv.refl _) (IndexEquiv.refl _) slot
    (unflatten slot index)) = index
  have unchanged : ∀ value : Replacement arity inner slot,
      replacementMap (IndexEquiv.refl _) (IndexEquiv.refl _) slot value = value := by
    intro value
    cases value <;> rfl
  rw [unchanged, flatten_unflatten]

/-- Equivariance is derived from the explicit finite maps, not a structure field. -/
theorem splice_comp {arity inner : Nat}
    (outer first : Permutation arity) (inside second : Permutation inner)
    (slot : Fin arity) :
    splice (outer.comp first) (inside.comp second) slot =
      (splice outer inside (first.toFun slot)).comp (splice first second slot) := by
  apply IndexEquiv.ext
  intro index
  change flatten (outer.toFun (first.toFun slot))
      (replacementMap (outer.comp first) (inside.comp second) slot (unflatten slot index)) =
    flatten (outer.toFun (first.toFun slot))
      (replacementMap outer inside (first.toFun slot)
        (unflatten (first.toFun slot)
          (flatten (first.toFun slot) (replacementMap first second slot (unflatten slot index)))))
  rw [unflatten_flatten, replacementMap_comp]

theorem splice_outer_action {arity inner : Nat} (outer action : Permutation arity)
    (inside : Permutation inner) (slot : Fin arity) :
    splice (outer.comp action) inside slot =
      (splice outer inside (action.toFun slot)).comp
        (splice action (IndexEquiv.refl (Fin inner)) slot) := by
  simpa [IndexEquiv.comp_refl] using
    splice_comp outer action inside (IndexEquiv.refl (Fin inner)) slot

theorem splice_inner_action {arity inner : Nat} (outer : Permutation arity)
    (inside action : Permutation inner) (slot : Fin arity) :
    splice outer (inside.comp action) slot =
      (splice outer inside slot).comp (splice (IndexEquiv.refl (Fin arity)) action slot) := by
  have composed := splice_comp outer (IndexEquiv.refl (Fin arity)) inside action slot
  rw [IndexEquiv.comp_refl] at composed
  exact composed

open PlanarTree

/-- Arity counts occurrences; the underlying labelled planar tree is retained. -/
structure ExplicitTree (Colour : Type u) (Label : Type v) (arity : Nat) where
  tree : Tree Colour Label
  input_length : tree.inputs.length = arity
  order : Permutation arity

namespace ExplicitTree

variable {Colour : Type u} {Label : Type v} {arity inner : Nat}

def act (tree : ExplicitTree Colour Label arity) (action : Permutation arity) :
    ExplicitTree Colour Label arity :=
  ⟨tree.tree, tree.input_length, tree.order.comp action⟩

theorem act_tree (tree : ExplicitTree Colour Label arity) (action : Permutation arity) :
    (tree.act action).tree = tree.tree := rfl

theorem act_identity (tree : ExplicitTree Colour Label arity) :
    tree.act (IndexEquiv.refl (Fin arity)) = tree := by
  cases tree
  simp [act, IndexEquiv.comp_refl]

theorem act_composition (tree : ExplicitTree Colour Label arity)
    (first second : Permutation arity) :
    (tree.act first).act second = tree.act (first.comp second) := by
  simp [act, IndexEquiv.comp_assoc]

theorem act_inverse (tree : ExplicitTree Colour Label arity) (action : Permutation arity) :
    (tree.act action).act action.symm = tree := by
  rw [act_composition, IndexEquiv.comp_symm, act_identity]

def externalColour (tree : ExplicitTree Colour Label arity) (index : Fin arity) : Colour :=
  tree.tree.inputs[tree.order.toFun index |>.val]'(by
    rw [tree.input_length]
    exact (tree.order.toFun index).isLt)

theorem action_boundary (tree : ExplicitTree Colour Label arity)
    (action : Permutation arity) (index : Fin arity) :
    (tree.act action).externalColour index = tree.externalColour (action.toFun index) := rfl

def selected (tree : ExplicitTree Colour Label arity) (slot : Fin arity) : Context Colour Label :=
  tree.tree.selectTotal (tree.order.toFun slot).val (by
    rw [tree.input_length]
    exact (tree.order.toFun slot).isLt)

theorem selected_correct (tree : ExplicitTree Colour Label arity) (slot : Fin arity) :
    (tree.selected slot).skeleton = tree.tree ∧
      (tree.selected slot).index = (tree.order.toFun slot).val :=
  tree.tree.selectTotal_correct _ _

theorem action_selection (tree : ExplicitTree Colour Label arity)
    (action : Permutation arity) (slot : Fin arity) :
    (tree.act action).selected slot = tree.selected (action.toFun slot) := rfl

theorem graft_length (outer : ExplicitTree Colour Label arity)
    (inside : ExplicitTree Colour Label inner) (slot : Fin arity) :
    ((outer.selected slot).fill inside.tree).inputs.length = replacementSize arity inner := by
  have original := congrArg List.length (outer.selected slot).skeleton_inputs
  rw [(outer.selected_correct slot).1, outer.input_length] at original
  rw [Context.fill_inputs]
  simp only [List.length_append, List.length_singleton, inside.input_length] at *
  unfold replacementSize
  omega

def graft (outer : ExplicitTree Colour Label arity)
    (inside : ExplicitTree Colour Label inner) (slot : Fin arity) :
    ExplicitTree Colour Label (replacementSize arity inner) :=
  ⟨(outer.selected slot).fill inside.tree, outer.graft_length inside slot,
    splice outer.order inside.order slot⟩

theorem graft_outer_action (outer : ExplicitTree Colour Label arity)
    (inside : ExplicitTree Colour Label inner) (action : Permutation arity) (slot : Fin arity) :
    (outer.act action).graft inside slot =
      (outer.graft inside (action.toFun slot)).act
        (splice action (IndexEquiv.refl (Fin inner)) slot) := by
  simp only [graft, act]
  congr 1
  exact splice_outer_action outer.order action inside.order slot

theorem graft_inner_action (outer : ExplicitTree Colour Label arity)
    (inside : ExplicitTree Colour Label inner) (action : Permutation inner) (slot : Fin arity) :
    outer.graft (inside.act action) slot =
      (outer.graft inside slot).act (splice (IndexEquiv.refl (Fin arity)) action slot) := by
  simp only [graft, act]
  congr 1
  exact splice_inner_action outer.order inside.order action slot

theorem graft_wellTyped (signature : Label → GateIdeal.Profile Colour)
    (outer : ExplicitTree Colour Label arity) (inside : ExplicitTree Colour Label inner)
    (slot : Fin arity) (outer_typed : outer.tree.WellTyped signature)
    (inside_typed : inside.tree.WellTyped signature)
    (compatible : inside.tree.output signature = (outer.selected slot).input) :
    (outer.graft inside slot).tree.WellTyped signature := by
  apply Context.fill_wellTyped signature _ _ _ inside_typed compatible
  apply ((outer.selected slot).skeleton_wellTyped_iff signature).mp
  rw [(outer.selected_correct slot).1]
  exact outer_typed

end ExplicitTree

section Boundary

variable {Colour : Type u}

theorem prefix_lookup (before inside after : List Colour) (index : Nat)
    (bound : index < before.length) :
    (before ++ inside ++ after)[index]'(by simp only [List.length_append]; omega) = before[index] := by
  rw [List.getElem_append_left (by simp only [List.length_append]; omega),
    List.getElem_append_left bound]

theorem inserted_lookup (before inside after : List Colour) (index : Nat)
    (bound : index < inside.length) :
    (before ++ inside ++ after)[before.length + index]'(by
      simp only [List.length_append]; omega) = inside[index] := by
  rw [List.getElem_append_left (by simp only [List.length_append]; omega),
    List.getElem_append_right (by omega)]
  simp

theorem suffix_lookup (before inside after : List Colour) (index : Nat)
    (bound : index < after.length) :
    (before ++ inside ++ after)[before.length + inside.length + index]'(by
      simp only [List.length_append]; omega) = after[index] := by
  rw [List.getElem_append_right (by simp only [List.length_append]; omega)]
  simp

theorem outside_lookup (before inside after : List Colour) (hole : Colour)
    (index : Nat) (bound : index < before.length + 1 + after.length)
    (different : index ≠ before.length) :
    (before ++ inside ++ after)[if index < before.length then index else index + inside.length - 1]'(by
      simp only [List.length_append]; split <;> omega) =
    (before ++ [hole] ++ after)[index]'(by
      simp only [List.length_append, List.length_singleton]; omega) := by
  by_cases earlier : index < before.length
  · simp only [earlier, ↓reduceIte]
    rw [prefix_lookup before inside after index earlier, prefix_lookup before [hole] after index earlier]
  · have later : before.length < index := by omega
    have suffix_bound : index - before.length - 1 < after.length := by omega
    have original : index = before.length + [hole].length + (index - before.length - 1) := by
      simp
      omega
    have changed : index + inside.length - 1 =
        before.length + inside.length + (index - before.length - 1) := by omega
    simp only [earlier, ↓reduceIte]
    calc
      _ = after[index - before.length - 1] := by
        simpa only [changed] using suffix_lookup before inside after _ suffix_bound
      _ = _ := by
        simpa only [← original] using (suffix_lookup before [hole] after _ suffix_bound).symm

end Boundary

namespace ExplicitTree

variable {Colour : Type u} {Label : Type v} {arity inner : Nat}

theorem selected_colour (outer : ExplicitTree Colour Label arity) (slot : Fin arity) :
    (outer.selected slot).input = outer.externalColour slot := by
  symm
  unfold externalColour
  have selected_lookup : (outer.selected slot).skeleton.inputs[(outer.selected slot).index]'(
      (outer.selected slot).index_in_bounds) = (outer.selected slot).input := by
    simp [Context.index, Context.skeleton_inputs]
  simpa only [(outer.selected_correct slot).1, (outer.selected_correct slot).2] using selected_lookup

theorem graft_boundary (outer : ExplicitTree Colour Label arity)
    (inside : ExplicitTree Colour Label inner) (slot : Fin arity)
    (index : Replacement arity inner slot) :
    (outer.graft inside slot).externalColour (flatten slot index) =
      match index with
      | .inl external => outer.externalColour external.val
      | .inr internal => inside.externalColour internal := by
  change ((outer.selected slot).fill inside.tree).inputs[
    (splice outer.order inside.order slot).toFun (flatten slot index) |>.val]'(by
      rw [outer.graft_length inside slot]
      exact ((splice outer.order inside.order slot).toFun (flatten slot index)).isLt) = _
  simp only [splice_flatten]
  have position : (outer.selected slot).prefix.length = (outer.order.toFun slot).val :=
    (outer.selected_correct slot).2
  cases index with
  | inl external =>
      have different : (outer.order.toFun external.val).val ≠ (outer.selected slot).prefix.length := by
        intro same
        apply external.property
        apply outer.order.injective
        apply Fin.ext
        exact same.trans position
      have bound : (outer.order.toFun external.val).val <
          (outer.selected slot).prefix.length + 1 + (outer.selected slot).suffix.length := by
        have source_length := congrArg List.length (outer.selected slot).skeleton_inputs
        rw [(outer.selected_correct slot).1, outer.input_length] at source_length
        simp only [List.length_append, List.length_singleton] at source_length
        have := (outer.order.toFun external.val).isLt
        omega
      have lookup := outside_lookup (outer.selected slot).prefix inside.tree.inputs
        (outer.selected slot).suffix (outer.selected slot).input
        (outer.order.toFun external.val).val bound different
      simp only [← Context.fill_inputs, ← Context.skeleton_inputs,
        (outer.selected_correct slot).1, inside.input_length, position] at lookup
      by_cases earlier : (outer.order.toFun external.val).val < (outer.order.toFun slot).val
      · simpa only [replacementMap, flatten, earlier, ↓reduceDIte, ↓reduceIte,
          externalColour] using lookup
      · simpa only [replacementMap, flatten, earlier, ↓reduceDIte, ↓reduceIte,
          externalColour] using lookup
  | inr internal =>
      have lookup := inserted_lookup (outer.selected slot).prefix inside.tree.inputs
        (outer.selected slot).suffix (inside.order.toFun internal).val (by
          rw [inside.input_length]
          exact (inside.order.toFun internal).isLt)
      simp only [← Context.fill_inputs, position] at lookup
      exact lookup

theorem graft_output (signature : Label → GateIdeal.Profile Colour)
    (outer : ExplicitTree Colour Label arity) (inside : ExplicitTree Colour Label inner)
    (slot : Fin arity) (compatible : inside.tree.output signature = outer.externalColour slot) :
    (outer.graft inside slot).tree.output signature = outer.tree.output signature := by
  change ((outer.selected slot).fill inside.tree).output signature = _
  rw [Context.fill_output signature _ _ (compatible.trans (outer.selected_colour slot).symm),
    ← Context.skeleton_output, (outer.selected_correct slot).1]

theorem action_wellTyped (signature : Label → GateIdeal.Profile Colour)
    (tree : ExplicitTree Colour Label arity) (action : Permutation arity) :
    (tree.act action).tree.WellTyped signature ↔ tree.tree.WellTyped signature := Iff.rfl

end ExplicitTree

namespace Controls

def swapTwo : Permutation 2 where
  toFun index := ⟨1 - index.val, by omega⟩
  invFun index := ⟨1 - index.val, by omega⟩
  left_inv index := by
    apply Fin.ext
    change 1 - (1 - index.val) = index.val
    have := index.isLt
    omega
  right_inv index := by
    apply Fin.ext
    change 1 - (1 - index.val) = index.val
    have := index.isLt
    omega

def repeated : ExplicitTree Unit PlanarTree.Controls.Operation 2 :=
  ⟨PlanarTree.Controls.first.skeleton, rfl, swapTwo⟩

def closed : ExplicitTree Unit PlanarTree.Controls.Operation 0 :=
  ⟨PlanarTree.Controls.closedTree, rfl, IndexEquiv.refl (Fin 0)⟩

theorem repeated_colour_slots_remain_distinct :
    (repeated.selected ⟨0, by decide⟩).index = 1 ∧
      (repeated.selected ⟨1, by decide⟩).index = 0 := ⟨rfl, rfl⟩

theorem swapped_nullary_graft :
    (repeated.graft closed ⟨0, by decide⟩).tree =
      .node .pair (.cons (.input ()) (.cons PlanarTree.Controls.closedTree .nil)) := rfl

theorem nullary_graft_remaining_occurrence :
    (repeated.graft closed ⟨0, by decide⟩).order.toFun ⟨0, by decide⟩ = ⟨0, by decide⟩ := rfl

end Controls

#print axioms IndexEquiv.ext
#print axioms unflatten_flatten
#print axioms flatten_unflatten
#print axioms replacementTransport
#print axioms splice_comp
#print axioms splice_outer_action
#print axioms splice_inner_action
#print axioms ExplicitTree.act_identity
#print axioms ExplicitTree.act_composition
#print axioms ExplicitTree.act_inverse
#print axioms ExplicitTree.action_boundary
#print axioms ExplicitTree.action_selection
#print axioms ExplicitTree.graft_outer_action
#print axioms ExplicitTree.graft_inner_action
#print axioms ExplicitTree.graft_wellTyped
#print axioms ExplicitTree.selected_colour
#print axioms ExplicitTree.graft_boundary
#print axioms ExplicitTree.graft_output
#print axioms Controls.repeated_colour_slots_remain_distinct
#print axioms Controls.swapped_nullary_graft
#print axioms Controls.nullary_graft_remaining_occurrence

end Woland.InputAction
