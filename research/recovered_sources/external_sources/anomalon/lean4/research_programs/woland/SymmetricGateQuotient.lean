import ExplicitGraftLaws

/-!
# Typed symmetric actions on the concrete rejected-occurrence quotient

AuthorityEffect: None.

The carrier is the existing labelled ExplicitTree, refined by its external
colour/schema profile and its unchanged output. `bad` classifies immutable,
already checked gate-bound invocation labels (task, attempt, candidate/input,
inventory, checker and scope bindings). It is not a predicate on final prose.
This module does not derive rejection from metadata or authenticate receipts.
Changed invocation inputs require fresh checking; retained history is not an
active tree child. GateIdeal.Generated remains substitution closure only.

All actions and rejection laws below are constructed on concrete trees. No
symmetric action law, runtime refinement, or generic seed action closure is
assumed. Fin 22 names the primary-gate family, not intergates or missing evidence.
The named unit, nested and disjoint laws below lift the actual complete graft
equations, with explicit equality transport between the resulting profiles.
Disjoint slots use a prefix/middle/suffix decomposition of two distinct external
occurrences; this does not require their underlying planar order to agree.
-/

namespace Woland.SymmetricGateQuotient

open PlanarTree InputAction

universe u v
variable {Colour : Type u} {Label : Type v}

private def finCast {n m : Nat} (same : n = m) : IndexEquiv (Fin n) (Fin m) where
  toFun := Fin.cast same
  invFun := Fin.cast same.symm
  left_inv _ := by apply Fin.ext; rfl
  right_inv _ := by apply Fin.ext; rfl

/-- A concrete input bijection between two actual ordered boundary profiles. -/
structure ProfileAction (source target : GateIdeal.Profile Colour) where
  length_eq : target.inputs.length = source.inputs.length
  positions : IndexEquiv (Fin target.inputs.length) (Fin source.inputs.length)
  output_eq : source.output = target.output
  colours : ∀ index, source.inputs[(positions.toFun index).val] = target.inputs[index.val]

namespace ProfileAction

variable {source middle target final : GateIdeal.Profile Colour}

theorem ext (first second : ProfileAction source target)
    (same : first.positions = second.positions) : first = second := by
  cases first
  cases second
  cases same
  rfl

def identity (profile : GateIdeal.Profile Colour) : ProfileAction profile profile :=
  ⟨rfl, IndexEquiv.refl _, rfl, fun _ => rfl⟩

def comp (first : ProfileAction source middle) (second : ProfileAction middle target) :
    ProfileAction source target where
  length_eq := second.length_eq.trans first.length_eq
  positions := first.positions.comp second.positions
  output_eq := first.output_eq.trans second.output_eq
  colours index := (first.colours (second.positions.toFun index)).trans (second.colours index)

def inverse (action : ProfileAction source target) : ProfileAction target source where
  length_eq := action.length_eq.symm
  positions := action.positions.symm
  output_eq := action.output_eq.symm
  colours index := by
    change target.inputs[(action.positions.invFun index).val] = source.inputs[index.val]
    have colour := action.colours (action.positions.invFun index)
    simpa only [action.positions.right_inv] using colour.symm

theorem comp_identity (action : ProfileAction source target) :
    action.comp (identity target) = action :=
  ext _ _ (IndexEquiv.comp_refl _)

theorem identity_comp (action : ProfileAction source target) :
    (identity source).comp action = action :=
  ext _ _ (IndexEquiv.refl_comp _)

theorem comp_assoc (first : ProfileAction source middle) (second : ProfileAction middle target)
    (third : ProfileAction target final) :
    (first.comp second).comp third = first.comp (second.comp third) :=
  ext _ _ (IndexEquiv.comp_assoc _ _ _)

theorem comp_inverse (action : ProfileAction source target) :
    action.comp action.inverse = identity source :=
  ext _ _ (IndexEquiv.comp_symm _)

theorem inverse_comp (action : ProfileAction source target) :
    action.inverse.comp action = identity target :=
  ext _ _ (IndexEquiv.symm_comp _)

end ProfileAction

def reindexedProfile (profile : GateIdeal.Profile Colour)
    (action : Permutation profile.inputs.length) : GateIdeal.Profile Colour :=
  ⟨List.ofFn (fun index => profile.inputs[(action.toFun index).val]), profile.output⟩

def canonicalAction (profile : GateIdeal.Profile Colour)
    (action : Permutation profile.inputs.length) : ProfileAction profile (reindexedProfile profile action) where
  length_eq := by simp [reindexedProfile]
  positions := action.comp (finCast (by simp [reindexedProfile]))
  output_eq := rfl
  colours index := by
    simp only [reindexedProfile, IndexEquiv.comp, finCast, List.getElem_ofFn]
    apply congrArg (fun value : Fin profile.inputs.length => profile.inputs[(action.toFun value).val])
    apply Fin.ext
    rfl

/-- The external ordered boundary refines the existing concrete tree. -/
structure TypedExternal (signature : Label → GateIdeal.Profile Colour)
    (profile : GateIdeal.Profile Colour) where
  term : ExplicitTree Colour Label profile.inputs.length
  wellTyped : term.tree.WellTyped signature
  boundary : ∀ index, term.externalColour index = profile.inputs[index.val]
  output : term.tree.output signature = profile.output

private theorem explicit_ext {arity : Nat} (first second : ExplicitTree Colour Label arity)
    (tree_eq : first.tree = second.tree) (order_eq : first.order = second.order) : first = second := by
  cases first
  cases second
  cases tree_eq
  cases order_eq
  rfl

namespace TypedExternal

variable {signature : Label → GateIdeal.Profile Colour}
variable {source middle target : GateIdeal.Profile Colour}

theorem ext (first second : TypedExternal signature source)
    (tree_eq : first.term.tree = second.term.tree)
    (order_eq : first.term.order = second.term.order) : first = second := by
  have same := explicit_ext first.term second.term tree_eq order_eq
  cases first
  cases second
  cases same
  rfl

def act (action : ProfileAction source target) (value : TypedExternal signature source) :
    TypedExternal signature target where
  term := ⟨value.term.tree, value.term.input_length.trans action.length_eq.symm,
    (finCast action.length_eq.symm).comp (value.term.order.comp action.positions)⟩
  wellTyped := value.wellTyped
  boundary index := (value.boundary (action.positions.toFun index)).trans (action.colours index)
  output := value.output.trans action.output_eq

theorem act_tree (action : ProfileAction source target) (value : TypedExternal signature source) :
    (value.act action).term.tree = value.term.tree := rfl

theorem act_identity (value : TypedExternal signature source) :
    value.act (ProfileAction.identity source) = value := by
  apply TypedExternal.ext
  · rfl
  · apply IndexEquiv.ext
    intro index
    apply Fin.ext
    rfl

theorem act_comp (first : ProfileAction source middle) (second : ProfileAction middle target)
    (value : TypedExternal signature source) :
    (value.act first).act second = value.act (first.comp second) := by
  apply TypedExternal.ext
  · rfl
  · apply IndexEquiv.ext
    intro index
    apply Fin.ext
    rfl

theorem act_inverse (action : ProfileAction source target) (value : TypedExternal signature source) :
    (value.act action).act action.inverse = value := by
  rw [act_comp, ProfileAction.comp_inverse, act_identity]

theorem act_rejected_iff (bad : Label → Prop) (action : ProfileAction source target)
    (value : TypedExternal signature source) :
    (value.act action).term.tree.Rejected bad ↔ value.term.tree.Rejected bad := Iff.rfl

end TypedExternal

theorem graft_rejected_iff (bad : Label → Prop) {arity inner : Nat}
    (outer : ExplicitTree Colour Label arity) (inside : ExplicitTree Colour Label inner)
    (slot : Fin arity) :
    (outer.graft inside slot).tree.Rejected bad ↔
      outer.tree.Rejected bad ∨ inside.tree.Rejected bad := by
  let context := outer.selected slot
  have retained : context.Rejected bad ↔ outer.tree.Rejected bad := by
    have original := context.fill_rejected_iff bad (.input context.input)
    rw [context.right_identity, (outer.selected_correct slot).1] at original
    simpa only [Tree.Rejected, or_false] using original.symm
  exact (context.fill_rejected_iff bad inside.tree).trans (or_congr retained Iff.rfl)

mutual
  theorem tree_rejection_mono (small large : Label → Prop)
      (included : ∀ label, small label → large label) :
      ∀ tree : Tree Colour Label, tree.Rejected small → tree.Rejected large
    | .input _, failed => False.elim failed
    | .node label children, failed => by
        rcases failed with local_failure | nested
        · exact Or.inl (included label local_failure)
        · exact Or.inr (forest_rejection_mono small large included children nested)

  theorem forest_rejection_mono (small large : Label → Prop)
      (included : ∀ label, small label → large label) :
      ∀ forest : Forest Colour Label, forest.Rejected small → forest.Rejected large
    | .nil, failed => False.elim failed
    | .cons tree rest, failed => by
        rcases failed with head | tail
        · exact Or.inl (tree_rejection_mono small large included tree head)
        · exact Or.inr (forest_rejection_mono small large included rest tail)
end

/-- Fixed primary-gate predicates on the same immutable bound invocation labels. -/
abbrev GateFamily22 (Label : Type v) := Fin 22 → Label → Prop

def combinedBad (gates : GateFamily22 Label) (label : Label) : Prop :=
  ∃ gate, gates gate label

theorem combinedBad_iff (gates : GateFamily22 Label) (label : Label) :
    combinedBad gates label ↔ ∃ gate : Fin 22, gates gate label := Iff.rfl

theorem any_gate_occurrence_rejected (gates : GateFamily22 Label) (gate : Fin 22)
    (tree : Tree Colour Label) (failed : tree.Rejected (gates gate)) :
    tree.Rejected (combinedBad gates) :=
  tree_rejection_mono (gates gate) (combinedBad gates) (fun _ proof => ⟨gate, proof⟩) tree failed

private def castTerm {n m : Nat} (same : n = m) (term : ExplicitTree Colour Label n) :
    ExplicitTree Colour Label m :=
  ⟨term.tree, term.input_length.trans same,
    (finCast same).comp (term.order.comp (finCast same.symm))⟩

private theorem castTerm_colour {n m : Nat} (same : n = m)
    (term : ExplicitTree Colour Label n) (index : Fin m) :
    (castTerm same term).externalColour index = term.externalColour (Fin.cast same.symm index) := rfl

def slotIndex {outer inner : GateIdeal.Profile Colour} (slot : GateIdeal.Slot outer inner) :
    Fin outer.inputs.length :=
  ⟨slot.before.length, by
    rw [slot.boundary_eq]
    simp only [List.length_append, List.length_singleton]
    omega⟩

theorem slotResultLength {outer inner : GateIdeal.Profile Colour}
    (slot : GateIdeal.Slot outer inner) :
    replacementSize outer.inputs.length inner.inputs.length = slot.result.inputs.length := by
  have length := congrArg List.length slot.boundary_eq
  simp only [List.length_append, List.length_singleton] at length
  simp only [replacementSize, GateIdeal.Slot.result, List.length_append]
  omega

theorem slot_boundary {outer inner : GateIdeal.Profile Colour}
    (slot : GateIdeal.Slot outer inner)
    (index : Replacement outer.inputs.length inner.inputs.length (slotIndex slot)) :
    slot.result.inputs[(flatten (slotIndex slot) index).val]'(by
      rw [← slotResultLength slot]
      exact (flatten (slotIndex slot) index).isLt) =
      match index with
      | .inl external => outer.inputs[external.val.val]
      | .inr internal => inner.inputs[internal.val] := by
  cases index with
  | inl external =>
      have different : external.val.val ≠ slot.before.length := by
        intro same
        exact external.property (Fin.ext same)
      have bound : external.val.val < slot.before.length + 1 + slot.after.length := by
        have original := congrArg List.length slot.boundary_eq
        simp only [List.length_append, List.length_singleton] at original
        have := external.val.isLt
        omega
      have lookup := outside_lookup slot.before inner.inputs slot.after inner.output
        external.val.val bound different
      simp only [← slot.boundary_eq] at lookup
      by_cases earlier : external.val.val < slot.before.length
      · simpa only [flatten, slotIndex, earlier, ↓reduceDIte, ↓reduceIte,
          GateIdeal.Slot.result] using lookup
      · simpa only [flatten, slotIndex, earlier, ↓reduceDIte, ↓reduceIte,
          GateIdeal.Slot.result] using lookup
  | inr internal =>
      exact inserted_lookup slot.before inner.inputs slot.after internal.val internal.isLt

namespace TypedExternal

variable {signature : Label → GateIdeal.Profile Colour}
variable {outer inner : GateIdeal.Profile Colour}

def compose (slot : GateIdeal.Slot outer inner) (first : TypedExternal signature outer)
    (second : TypedExternal signature inner) : TypedExternal signature slot.result := by
  let index := slotIndex slot
  let raw := first.term.graft second.term index
  have compatible : second.term.tree.output signature = (first.term.selected index).input := by
    rw [first.term.selected_colour, first.boundary]
    have colour := inserted_lookup slot.before [inner.output] slot.after 0 (by simp)
    have at_slot : outer.inputs[index.val] = inner.output := by
      simpa only [← slot.boundary_eq, Nat.add_zero, List.getElem_singleton, index, slotIndex] using colour
    exact second.output.trans at_slot.symm
  refine ⟨castTerm (slotResultLength slot) raw,
    first.term.graft_wellTyped signature second.term index first.wellTyped second.wellTyped compatible,
    ?_, ?_⟩
  · intro result_index
    rw [castTerm_colour]
    let uncast := Fin.cast (slotResultLength slot).symm result_index
    let replacement := unflatten index uncast
    have recovered : flatten index replacement = uncast := flatten_unflatten index uncast
    have tree_boundary := first.term.graft_boundary second.term index replacement
    have profile_boundary := slot_boundary slot replacement
    cases choice : replacement with
    | inl external =>
        simp only [choice] at recovered tree_boundary profile_boundary
        have actual : raw.externalColour uncast = outer.inputs[external.val.val] := by
          simpa only [recovered] using tree_boundary.trans (first.boundary external.val)
        have expected : slot.result.inputs[result_index.val] = outer.inputs[external.val.val] := by
          have position : (flatten (slotIndex slot) (.inl external)).val = result_index.val :=
            congrArg Fin.val recovered
          simpa only [position] using profile_boundary
        exact actual.trans expected.symm
    | inr internal =>
        simp only [choice] at recovered tree_boundary profile_boundary
        have actual : raw.externalColour uncast = inner.inputs[internal.val] := by
          simpa only [recovered] using tree_boundary.trans (second.boundary internal)
        have expected : slot.result.inputs[result_index.val] = inner.inputs[internal.val] := by
          have position : (flatten (slotIndex slot) (.inr internal)).val = result_index.val :=
            congrArg Fin.val recovered
          simpa only [position] using profile_boundary
        exact actual.trans expected.symm
  · exact (first.term.graft_output signature second.term index
      (compatible.trans (first.term.selected_colour index))).trans first.output

theorem compose_rejected_iff (bad : Label → Prop) (slot : GateIdeal.Slot outer inner)
    (first : TypedExternal signature outer) (second : TypedExternal signature inner) :
    (compose slot first second).term.tree.Rejected bad ↔
      first.term.tree.Rejected bad ∨ second.term.tree.Rejected bad :=
  graft_rejected_iff bad first.term second.term (slotIndex slot)

end TypedExternal

def concreteSystem (signature : Label → GateIdeal.Profile Colour) : GateIdeal.PartialSystem Colour where
  Op := TypedExternal signature
  compose := TypedExternal.compose

def occurrenceIdeal (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop) :
    GateIdeal.Ideal (concreteSystem signature) where
  rejected := fun {_} value => value.term.tree.Rejected bad
  outer_closed slot first second failed :=
    (TypedExternal.compose_rejected_iff bad slot first second).mpr (Or.inl failed)
  inner_closed slot first second failed :=
    (TypedExternal.compose_rejected_iff bad slot first second).mpr (Or.inr failed)

def gateIdeal22 (signature : Label → GateIdeal.Profile Colour) (gates : GateFamily22 Label) :
    GateIdeal.Ideal (concreteSystem signature) := occurrenceIdeal signature (combinedBad gates)

theorem any_gate_projects_to_bottom (signature : Label → GateIdeal.Profile Colour)
    (gates : GateFamily22 Label) (gate : Fin 22) {profile : GateIdeal.Profile Colour}
    (value : TypedExternal signature profile) (failed : value.term.tree.Rejected (gates gate)) :
    GateIdeal.project (gateIdeal22 signature gates) value =
      GateIdeal.bottom (gateIdeal22 signature gates) profile :=
  (GateIdeal.project_eq_bottom_iff _ _).mpr
    (any_gate_occurrence_rejected gates gate value.term.tree failed)

def optionalAction {signature : Label → GateIdeal.Profile Colour}
    {source target : GateIdeal.Profile Colour} (action : ProfileAction source target) :
    Option (TypedExternal signature source) → Option (TypedExternal signature target) :=
  Option.map (TypedExternal.act action)

theorem optional_rejected_iff (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop)
    {source target : GateIdeal.Profile Colour} (action : ProfileAction source target)
    (value : Option (TypedExternal signature source)) :
    (GateIdeal.pointedIdeal (occurrenceIdeal signature bad)).rejected (optionalAction action value) ↔
      (GateIdeal.pointedIdeal (occurrenceIdeal signature bad)).rejected value := by
  cases value <;> rfl

theorem action_respects_rees (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop)
    {source target : GateIdeal.Profile Colour} (action : ProfileAction source target)
    {first second : Option (TypedExternal signature source)}
    (related : GateIdeal.ReesRel (GateIdeal.pointedIdeal (occurrenceIdeal signature bad)) first second) :
    GateIdeal.ReesRel (GateIdeal.pointedIdeal (occurrenceIdeal signature bad))
      (optionalAction action first) (optionalAction action second) := by
  rcases related with rfl | ⟨first_failed, second_failed⟩
  · exact Or.inl rfl
  · exact Or.inr ⟨(optional_rejected_iff signature bad action first).mpr first_failed,
      (optional_rejected_iff signature bad action second).mpr second_failed⟩

/-- A map between the two exact profile fibres, respecting rejected representatives. -/
def quotientAction (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop)
    {source target : GateIdeal.Profile Colour} (action : ProfileAction source target)
    (value : GateIdeal.Rees (occurrenceIdeal signature bad) source) :
    GateIdeal.Rees (occurrenceIdeal signature bad) target :=
  Quotient.liftOn value (fun representative => Quotient.mk _ (optionalAction action representative))
    (fun _ _ related => Quotient.sound (action_respects_rees signature bad action related))

theorem quotientAction_project (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop)
    {source target : GateIdeal.Profile Colour} (action : ProfileAction source target)
    (value : TypedExternal signature source) :
    quotientAction signature bad action (GateIdeal.project (occurrenceIdeal signature bad) value) =
      GateIdeal.project (occurrenceIdeal signature bad) (value.act action) := rfl

theorem quotientAction_bottom (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop)
    {source target : GateIdeal.Profile Colour} (action : ProfileAction source target) :
    quotientAction signature bad action (GateIdeal.bottom (occurrenceIdeal signature bad) source) =
      GateIdeal.bottom (occurrenceIdeal signature bad) target := rfl

theorem quotientAction_identity (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop)
    {profile : GateIdeal.Profile Colour} (value : GateIdeal.Rees (occurrenceIdeal signature bad) profile) :
    quotientAction signature bad (ProfileAction.identity profile) value = value := by
  refine Quotient.inductionOn value ?_
  intro representative
  cases representative with
  | none => rfl
  | some term =>
      exact congrArg (fun item : TypedExternal signature profile =>
        GateIdeal.project (occurrenceIdeal signature bad) item) (TypedExternal.act_identity term)

theorem quotientAction_comp (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop)
    {source middle target : GateIdeal.Profile Colour}
    (first : ProfileAction source middle) (second : ProfileAction middle target)
    (value : GateIdeal.Rees (occurrenceIdeal signature bad) source) :
    quotientAction signature bad second (quotientAction signature bad first value) =
      quotientAction signature bad (first.comp second) value := by
  refine Quotient.inductionOn value ?_
  intro representative
  cases representative with
  | none => rfl
  | some term =>
      exact congrArg (fun item : TypedExternal signature target =>
        GateIdeal.project (occurrenceIdeal signature bad) item) (TypedExternal.act_comp first second term)

theorem quotientAction_inverse (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop)
    {source target : GateIdeal.Profile Colour} (action : ProfileAction source target)
    (value : GateIdeal.Rees (occurrenceIdeal signature bad) source) :
    quotientAction signature bad action.inverse (quotientAction signature bad action value) = value := by
  rw [quotientAction_comp, ProfileAction.comp_inverse, quotientAction_identity]

theorem quotientAction_inverse_other (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop)
    {source target : GateIdeal.Profile Colour} (action : ProfileAction source target)
    (value : GateIdeal.Rees (occurrenceIdeal signature bad) target) :
    quotientAction signature bad action (quotientAction signature bad action.inverse value) = value := by
  rw [quotientAction_comp, ProfileAction.inverse_comp, quotientAction_identity]

theorem gate22_quotientAction_bottom (signature : Label → GateIdeal.Profile Colour)
    (gates : GateFamily22 Label) {source target : GateIdeal.Profile Colour}
    (action : ProfileAction source target) :
    quotientAction signature (combinedBad gates) action (GateIdeal.bottom (gateIdeal22 signature gates) source) =
      GateIdeal.bottom (gateIdeal22 signature gates) target := rfl

/-- The concrete old/new occurrence map, including a possibly empty inserted boundary. -/
def replacementAcross {n m newN newM : Nat}
    (outer : IndexEquiv (Fin newN) (Fin n)) (inner : IndexEquiv (Fin newM) (Fin m))
    (oldSlot : Fin n) (newSlot : Fin newN) (at_slot : outer.toFun newSlot = oldSlot) :
    IndexEquiv (Replacement newN newM newSlot) (Replacement n m oldSlot) where
  toFun
    | .inl external => .inl ⟨outer.toFun external.val, by
        intro equal
        exact external.property (outer.injective (equal.trans at_slot.symm))⟩
    | .inr internal => .inr (inner.toFun internal)
  invFun
    | .inl external => .inl ⟨outer.invFun external.val, by
        intro equal
        apply external.property
        calc
          external.val = outer.toFun (outer.invFun external.val) := (outer.right_inv _).symm
          _ = outer.toFun newSlot := congrArg outer.toFun equal
          _ = oldSlot := at_slot⟩
    | .inr internal => .inr (inner.invFun internal)
  left_inv index := by
    cases index with
    | inl external =>
        apply congrArg Sum.inl
        apply Subtype.ext
        exact outer.left_inv external.val
    | inr internal => exact congrArg Sum.inr (inner.left_inv internal)
  right_inv index := by
    cases index with
    | inl external =>
        apply congrArg Sum.inl
        apply Subtype.ext
        exact outer.right_inv external.val
    | inr internal => exact congrArg Sum.inr (inner.right_inv internal)

/-- Coordinate transport is determined by the slots and actions, never by representatives. -/
def compositePositions {outer inner newOuter newInner : GateIdeal.Profile Colour}
    (oldSlot : GateIdeal.Slot outer inner) (newSlot : GateIdeal.Slot newOuter newInner)
    (outerAction : ProfileAction outer newOuter) (innerAction : ProfileAction inner newInner)
    (at_slot : outerAction.positions.toFun (slotIndex newSlot) = slotIndex oldSlot) :
    IndexEquiv (Fin newSlot.result.inputs.length) (Fin oldSlot.result.inputs.length) :=
  (finCast (slotResultLength oldSlot)).comp
    ((replacementOrder (slotIndex oldSlot)).comp
      ((replacementAcross outerAction.positions innerAction.positions
        (slotIndex oldSlot) (slotIndex newSlot) at_slot).comp
          ((replacementOrder (slotIndex newSlot)).symm.comp
            (finCast (slotResultLength newSlot).symm))))

def compositeAction {outer inner newOuter newInner : GateIdeal.Profile Colour}
    (oldSlot : GateIdeal.Slot outer inner) (newSlot : GateIdeal.Slot newOuter newInner)
    (outerAction : ProfileAction outer newOuter) (innerAction : ProfileAction inner newInner)
    (at_slot : outerAction.positions.toFun (slotIndex newSlot) = slotIndex oldSlot) :
    ProfileAction oldSlot.result newSlot.result where
  length_eq := by
    rw [← slotResultLength oldSlot, ← slotResultLength newSlot,
      outerAction.length_eq, innerAction.length_eq]
  positions := compositePositions oldSlot newSlot outerAction innerAction at_slot
  output_eq := outerAction.output_eq
  colours index := by
    let rawIndex := Fin.cast (slotResultLength newSlot).symm index
    let coordinate := unflatten (slotIndex newSlot) rawIndex
    have recovered := flatten_unflatten (slotIndex newSlot) rawIndex
    have oldBoundary := slot_boundary oldSlot
      ((replacementAcross outerAction.positions innerAction.positions
        (slotIndex oldSlot) (slotIndex newSlot) at_slot).toFun coordinate)
    have newBoundary := slot_boundary newSlot coordinate
    change oldSlot.result.inputs[(flatten (slotIndex oldSlot)
      ((replacementAcross outerAction.positions innerAction.positions
        (slotIndex oldSlot) (slotIndex newSlot) at_slot).toFun coordinate)).val]'(by
          rw [← slotResultLength oldSlot]
          exact (flatten (slotIndex oldSlot) _).isLt) = _
    rw [oldBoundary]
    have indexValue : (flatten (slotIndex newSlot) coordinate).val = index.val :=
      congrArg Fin.val recovered
    cases choice : coordinate with
    | inl external =>
        have position : (flatten (inner := newInner.inputs.length) (slotIndex newSlot) (.inl external)).val = index.val :=
          by simpa only [choice] using indexValue
        simp only [choice] at newBoundary
        have newBoundary' : newSlot.result.inputs[index.val] = newOuter.inputs[external.val.val] := by
          simpa only [position] using newBoundary
        simp only [replacementAcross]
        exact (outerAction.colours external.val).trans newBoundary'.symm
    | inr internal =>
        have position : (flatten (slotIndex newSlot) (.inr internal)).val = index.val :=
          by simpa only [choice] using indexValue
        simp only [choice] at newBoundary
        have newBoundary' : newSlot.result.inputs[index.val] = newInner.inputs[internal.val] := by
          simpa only [position] using newBoundary
        simp only [replacementAcross]
        exact (innerAction.colours internal).trans newBoundary'.symm

namespace TypedExternal

theorem compose_action {signature : Label → GateIdeal.Profile Colour}
    {outer inner newOuter newInner : GateIdeal.Profile Colour}
    (oldSlot : GateIdeal.Slot outer inner) (newSlot : GateIdeal.Slot newOuter newInner)
    (outerAction : ProfileAction outer newOuter) (innerAction : ProfileAction inner newInner)
    (at_slot : outerAction.positions.toFun (slotIndex newSlot) = slotIndex oldSlot)
    (first : TypedExternal signature outer) (second : TypedExternal signature inner) :
    compose newSlot (first.act outerAction) (second.act innerAction) =
      (compose oldSlot first second).act
        (compositeAction oldSlot newSlot outerAction innerAction at_slot) := by
  apply TypedExternal.ext
  · change (((first.act outerAction).term.selected (slotIndex newSlot)).fill second.term.tree) =
      ((first.term.selected (slotIndex oldSlot)).fill second.term.tree)
    have selection : (first.act outerAction).term.selected (slotIndex newSlot) =
        first.term.selected (slotIndex oldSlot) := by
      simp only [act, ExplicitTree.selected, IndexEquiv.comp, finCast]
      congr 1
      exact congrArg (fun index => (first.term.order.toFun index).val) at_slot
    rw [selection]
  · apply IndexEquiv.ext
    intro index
    apply Fin.ext
    let rawIndex := Fin.cast (slotResultLength newSlot).symm index
    let coordinate := unflatten (slotIndex newSlot) rawIndex
    have recovered : flatten (slotIndex newSlot) coordinate = rawIndex :=
      flatten_unflatten (slotIndex newSlot) rawIndex
    change ((splice (first.act outerAction).term.order (second.act innerAction).term.order
        (slotIndex newSlot)).toFun rawIndex).val =
      ((splice first.term.order second.term.order (slotIndex oldSlot)).toFun
        (flatten (slotIndex oldSlot)
          ((replacementAcross outerAction.positions innerAction.positions
            (slotIndex oldSlot) (slotIndex newSlot) at_slot).toFun coordinate))).val
    rw [← recovered, splice_flatten, splice_flatten]
    have planarSlot := congrArg (fun index => (first.term.order.toFun index).val) at_slot
    cases coordinate with
    | inl external =>
        simp only [act, IndexEquiv.comp, finCast, replacementMap, replacementAcross, flatten]
        simp only [Fin.val_cast, planarSlot, innerAction.length_eq]
        split <;> rfl
    | inr internal =>
        simp only [act, IndexEquiv.comp, finCast, replacementMap, replacementAcross, flatten]
        simp only [Fin.val_cast, planarSlot]

end TypedExternal

/-- The complete typed graft transport descends to all quotient values, including bottom. -/
theorem quotientSubstitute_action (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop)
    {outer inner newOuter newInner : GateIdeal.Profile Colour}
    (oldSlot : GateIdeal.Slot outer inner) (newSlot : GateIdeal.Slot newOuter newInner)
    (outerAction : ProfileAction outer newOuter) (innerAction : ProfileAction inner newInner)
    (at_slot : outerAction.positions.toFun (slotIndex newSlot) = slotIndex oldSlot)
    (first : GateIdeal.Rees (occurrenceIdeal signature bad) outer)
    (second : GateIdeal.Rees (occurrenceIdeal signature bad) inner) :
    GateIdeal.quotientSubstitute (occurrenceIdeal signature bad) newSlot
      (quotientAction signature bad outerAction first) (quotientAction signature bad innerAction second) =
    quotientAction signature bad (compositeAction oldSlot newSlot outerAction innerAction at_slot)
      (GateIdeal.quotientSubstitute (occurrenceIdeal signature bad) oldSlot first second) := by
  refine Quotient.inductionOn₂ first second ?_
  intro firstRepresentative secondRepresentative
  cases firstRepresentative with
  | none => rfl
  | some firstTerm =>
      cases secondRepresentative with
      | none => rfl
      | some secondTerm =>
          exact congrArg (fun item : TypedExternal signature newSlot.result =>
            GateIdeal.project (occurrenceIdeal signature bad) item)
              (TypedExternal.compose_action oldSlot newSlot outerAction innerAction at_slot firstTerm secondTerm)

/-- A genuine structural identity contains no invocation label to reject. -/
def identity (signature : Label → GateIdeal.Profile Colour) (colour : Colour) :
    TypedExternal signature ⟨[colour], colour⟩ where
  term := ⟨.input colour, rfl, IndexEquiv.refl _⟩
  wellTyped := True.intro
  boundary index := by
    simp [ExplicitTree.externalColour, IndexEquiv.refl, Tree.inputs]
  output := rfl

theorem identity_not_rejected (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop)
    (colour : Colour) : ¬ (identity signature colour).term.tree.Rejected bad := by
  exact id

theorem identity_survives (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop)
    (colour : Colour) :
    GateIdeal.project (occurrenceIdeal signature bad) (identity signature colour) ≠
      GateIdeal.bottom (occurrenceIdeal signature bad) ⟨[colour], colour⟩ := by
  intro collapsed
  exact identity_not_rejected signature bad colour ((GateIdeal.project_eq_bottom_iff _ _).mp collapsed)

/-- Equality transport changes a fibre; it does not permute any input occurrence. -/
def profileTransport {signature : Label → GateIdeal.Profile Colour}
    {source target : GateIdeal.Profile Colour} (same : source = target)
    (value : TypedExternal signature source) : TypedExternal signature target := same ▸ value

theorem profileTransport_eq {signature : Label → GateIdeal.Profile Colour}
    {source target : GateIdeal.Profile Colour} (same : source = target)
    (first : TypedExternal signature source) (second : TypedExternal signature target)
    (trees : first.term.tree = second.term.tree)
    (orders : ∀ index, (first.term.order.toFun index).val =
      (second.term.order.toFun (Fin.cast (congrArg (fun profile => profile.inputs.length) same) index)).val) :
    profileTransport same first = second := by
  cases same
  apply TypedExternal.ext _ _ trees
  apply IndexEquiv.ext
  intro index
  exact Fin.ext (orders index)

def quotientTransport (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop)
    {source target : GateIdeal.Profile Colour} (same : source = target)
    (value : GateIdeal.Rees (occurrenceIdeal signature bad) source) :
    GateIdeal.Rees (occurrenceIdeal signature bad) target := same ▸ value

theorem quotientTransport_project (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop)
    {source target : GateIdeal.Profile Colour} (same : source = target)
    (value : TypedExternal signature source) :
    quotientTransport signature bad same (GateIdeal.project (occurrenceIdeal signature bad) value) =
      GateIdeal.project (occurrenceIdeal signature bad) (profileTransport same value) := by
  cases same
  rfl

theorem quotientTransport_bottom (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop)
    {source target : GateIdeal.Profile Colour} (same : source = target) :
    quotientTransport signature bad same (GateIdeal.bottom (occurrenceIdeal signature bad) source) =
      GateIdeal.bottom (occurrenceIdeal signature bad) target := by
  cases same
  rfl

def leftUnitSlot (profile : GateIdeal.Profile Colour) :
    GateIdeal.Slot ⟨[profile.output], profile.output⟩ profile := ⟨[], [], by simp⟩

theorem leftUnitResult (profile : GateIdeal.Profile Colour) : (leftUnitSlot profile).result = profile := by
  cases profile
  simp [leftUnitSlot, GateIdeal.Slot.result]

theorem compose_left_unit {signature : Label → GateIdeal.Profile Colour}
    {profile : GateIdeal.Profile Colour} (value : TypedExternal signature profile) :
    profileTransport (leftUnitResult profile)
      (TypedExternal.compose (leftUnitSlot profile) (identity signature profile.output) value) = value := by
  have raw := ExplicitTree.graft_left_unit profile.output value.term
  apply profileTransport_eq
  · exact congrArg ExplicitTree.tree raw
  · intro index
    have order := congrArg (fun tree => (tree.order.toFun
      (Fin.cast (congrArg (fun profile => profile.inputs.length) (leftUnitResult profile)) index)).val) raw
    simp only [ExplicitTree.transportArity, transportPermutation_value] at order
    change ((splice (IndexEquiv.refl _) value.term.order ⟨0, by change 0 < 1; decide⟩).toFun
      (Fin.cast (slotResultLength (leftUnitSlot profile)).symm index)).val = _
    exact order

theorem quotient_left_unit (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop)
    {profile : GateIdeal.Profile Colour} (value : GateIdeal.Rees (occurrenceIdeal signature bad) profile) :
    quotientTransport signature bad (leftUnitResult profile)
      (GateIdeal.quotientSubstitute (occurrenceIdeal signature bad) (leftUnitSlot profile)
        (GateIdeal.project (occurrenceIdeal signature bad) (identity signature profile.output)) value) = value := by
  refine Quotient.inductionOn value ?_
  intro representative
  cases representative with
  | none => exact quotientTransport_bottom signature bad (leftUnitResult profile)
  | some term =>
      change quotientTransport signature bad (leftUnitResult profile)
        (GateIdeal.project (occurrenceIdeal signature bad)
          (TypedExternal.compose (leftUnitSlot profile) (identity signature profile.output) term)) = _
      rw [quotientTransport_project]
      exact congrArg (fun item : TypedExternal signature profile =>
        GateIdeal.project (occurrenceIdeal signature bad) item) (compose_left_unit term)

theorem rightUnitResult {profile : GateIdeal.Profile Colour} {colour : Colour}
    (slot : GateIdeal.Slot profile ⟨[colour], colour⟩) : slot.result = profile := by
  cases profile
  have boundary := slot.boundary_eq
  simp only [GateIdeal.Slot.result]
  congr 1
  exact boundary.symm

theorem compose_right_unit {signature : Label → GateIdeal.Profile Colour}
    {profile : GateIdeal.Profile Colour} {colour : Colour}
    (slot : GateIdeal.Slot profile ⟨[colour], colour⟩) (value : TypedExternal signature profile) :
    profileTransport (rightUnitResult slot)
      (TypedExternal.compose slot value (identity signature colour)) = value := by
  have colour_at_slot : value.term.externalColour (slotIndex slot) = colour := by
    rw [value.boundary]
    have found := inserted_lookup slot.before [colour] slot.after 0 (by simp)
    simpa only [← slot.boundary_eq, slotIndex, Nat.add_zero, List.getElem_singleton] using found
  have raw := ExplicitTree.graft_right_unit value.term (slotIndex slot)
  rw [colour_at_slot] at raw
  apply profileTransport_eq
  · exact congrArg ExplicitTree.tree raw
  · intro index
    have order := congrArg (fun tree => (tree.order.toFun
      (Fin.cast (congrArg (fun profile => profile.inputs.length) (rightUnitResult slot)) index)).val) raw
    simp only [ExplicitTree.transportArity, transportPermutation_value] at order
    change ((splice value.term.order (IndexEquiv.refl _) (slotIndex slot)).toFun
      (Fin.cast (slotResultLength slot).symm index)).val = _
    exact order

theorem quotient_right_unit (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop)
    {profile : GateIdeal.Profile Colour} {colour : Colour}
    (slot : GateIdeal.Slot profile ⟨[colour], colour⟩)
    (value : GateIdeal.Rees (occurrenceIdeal signature bad) profile) :
    quotientTransport signature bad (rightUnitResult slot)
      (GateIdeal.quotientSubstitute (occurrenceIdeal signature bad) slot value
        (GateIdeal.project (occurrenceIdeal signature bad) (identity signature colour))) = value := by
  refine Quotient.inductionOn value ?_
  intro representative
  cases representative with
  | none => exact quotientTransport_bottom signature bad (rightUnitResult slot)
  | some term =>
      change quotientTransport signature bad (rightUnitResult slot)
        (GateIdeal.project (occurrenceIdeal signature bad)
          (TypedExternal.compose slot term (identity signature colour))) = _
      rw [quotientTransport_project]
      exact congrArg (fun item : TypedExternal signature profile =>
        GateIdeal.project (occurrenceIdeal signature bad) item) (compose_right_unit slot term)

def nestedInnerSlot {outer inner innermost : GateIdeal.Profile Colour}
    (first : GateIdeal.Slot outer inner) (second : GateIdeal.Slot inner innermost) :
    GateIdeal.Slot first.result innermost where
  before := first.before ++ second.before
  after := second.after ++ first.after
  boundary_eq := by
    simp only [GateIdeal.Slot.result, second.boundary_eq, List.append_assoc]

def nestedOuterSlot {outer inner innermost : GateIdeal.Profile Colour}
    (first : GateIdeal.Slot outer inner) (second : GateIdeal.Slot inner innermost) :
    GateIdeal.Slot outer second.result := ⟨first.before, first.after, first.boundary_eq⟩

theorem nestedResult {outer inner innermost : GateIdeal.Profile Colour}
    (first : GateIdeal.Slot outer inner) (second : GateIdeal.Slot inner innermost) :
    (nestedInnerSlot first second).result = (nestedOuterSlot first second).result := by
  simp only [GateIdeal.Slot.result, nestedInnerSlot, nestedOuterSlot, List.append_assoc]

private theorem castTerm_eq_transport {n m : Nat} (same : n = m) (term : ExplicitTree Colour Label n) :
    castTerm same term = ExplicitTree.transportArity same term := by
  cases same
  apply explicit_ext
  · rfl
  · apply IndexEquiv.ext
    intro index
    apply Fin.ext
    rfl

private theorem castTerm_graft {n m newN newM : Nat}
    (outerEq : n = newN) (innerEq : m = newM)
    (outer : ExplicitTree Colour Label n) (inner : ExplicitTree Colour Label m) (slot : Fin n) :
    (castTerm outerEq outer).graft (castTerm innerEq inner) (Fin.cast outerEq slot) =
      castTerm (by rw [outerEq, innerEq]) (outer.graft inner slot) := by
  cases outerEq
  cases innerEq
  simp only [castTerm_eq_transport, ExplicitTree.transportArity, transportPermutation]
  rfl

private theorem splice_transport {n m newN newM : Nat}
    (outerEq : n = newN) (innerEq : m = newM)
    (outer : Permutation n) (inner : Permutation m) (slot : Fin n) :
    splice (transportPermutation outerEq outer) (transportPermutation innerEq inner) (Fin.cast outerEq slot) =
      transportPermutation (by rw [outerEq, innerEq]) (splice outer inner slot) := by
  cases outerEq
  cases innerEq
  rfl

theorem compose_nested {signature : Label → GateIdeal.Profile Colour}
    {outer inner innermost : GateIdeal.Profile Colour}
    (firstSlot : GateIdeal.Slot outer inner) (secondSlot : GateIdeal.Slot inner innermost)
    (first : TypedExternal signature outer) (second : TypedExternal signature inner)
    (third : TypedExternal signature innermost) :
    profileTransport (nestedResult firstSlot secondSlot)
      (TypedExternal.compose (nestedInnerSlot firstSlot secondSlot)
        (TypedExternal.compose firstSlot first second) third) =
      TypedExternal.compose (nestedOuterSlot firstSlot secondSlot) first
        (TypedExternal.compose secondSlot second third) := by
  have raw := ExplicitTree.graft_nested first.term second.term third.term
    (slotIndex firstSlot) (slotIndex secondSlot)
  have indexEq : slotIndex (nestedInnerSlot firstSlot secondSlot) =
      Fin.cast (slotResultLength firstSlot) (newSlot (slotIndex firstSlot) (slotIndex secondSlot)) := by
    apply Fin.ext
    simp only [slotIndex, nestedInnerSlot, List.length_append, newSlot, flatten, Fin.val_cast]
  apply profileTransport_eq
  · change (((castTerm (slotResultLength firstSlot) (first.term.graft second.term (slotIndex firstSlot))).selected
      (slotIndex (nestedInnerSlot firstSlot secondSlot))).fill third.term.tree) =
        ((first.term.selected (slotIndex (nestedOuterSlot firstSlot secondSlot))).fill
          ((second.term.selected (slotIndex secondSlot)).fill third.term.tree))
    rw [indexEq]
    have treeEq := congrArg ExplicitTree.tree raw
    exact treeEq
  · intro index
    have rawOrder := congrArg (fun tree => (tree.order.toFun
      (Fin.cast ((congrArg (fun profile => profile.inputs.length) (nestedResult firstSlot secondSlot)).trans
        ((slotResultLength (nestedOuterSlot firstSlot secondSlot)).symm.trans
          (congrArg (replacementSize outer.inputs.length) (slotResultLength secondSlot).symm))) index)).val) raw
    simp only [ExplicitTree.transportArity, transportPermutation_value] at rawOrder
    change ((splice (TypedExternal.compose firstSlot first second).term.order third.term.order
      (slotIndex (nestedInnerSlot firstSlot secondSlot))).toFun
        (Fin.cast (slotResultLength (nestedInnerSlot firstSlot secondSlot)).symm index)).val = _
    have firstOrder : (TypedExternal.compose firstSlot first second).term.order =
        transportPermutation (slotResultLength firstSlot)
          (splice first.term.order second.term.order (slotIndex firstSlot)) :=
      congrArg ExplicitTree.order (castTerm_eq_transport (slotResultLength firstSlot)
        (first.term.graft second.term (slotIndex firstSlot)))
    have secondOrder : (TypedExternal.compose secondSlot second third).term.order =
        transportPermutation (slotResultLength secondSlot)
          (splice second.term.order third.term.order (slotIndex secondSlot)) :=
      congrArg ExplicitTree.order (castTerm_eq_transport (slotResultLength secondSlot)
        (second.term.graft third.term (slotIndex secondSlot)))
    rw [firstOrder, indexEq]
    change ((splice (transportPermutation (slotResultLength firstSlot)
        (splice first.term.order second.term.order (slotIndex firstSlot)))
      (transportPermutation rfl third.term.order)
      (Fin.cast (slotResultLength firstSlot) (newSlot (slotIndex firstSlot) (slotIndex secondSlot)))).toFun _).val =
        ((splice (transportPermutation rfl first.term.order)
          (TypedExternal.compose secondSlot second third).term.order (Fin.cast rfl (slotIndex firstSlot))).toFun _).val
    rw [secondOrder, splice_transport, splice_transport]
    simp only [transportPermutation_value]
    exact rawOrder

theorem quotient_nested (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop)
    {outer inner innermost : GateIdeal.Profile Colour}
    (firstSlot : GateIdeal.Slot outer inner) (secondSlot : GateIdeal.Slot inner innermost)
    (first : GateIdeal.Rees (occurrenceIdeal signature bad) outer)
    (second : GateIdeal.Rees (occurrenceIdeal signature bad) inner)
    (third : GateIdeal.Rees (occurrenceIdeal signature bad) innermost) :
    quotientTransport signature bad (nestedResult firstSlot secondSlot)
      (GateIdeal.quotientSubstitute (occurrenceIdeal signature bad) (nestedInnerSlot firstSlot secondSlot)
        (GateIdeal.quotientSubstitute (occurrenceIdeal signature bad) firstSlot first second) third) =
      GateIdeal.quotientSubstitute (occurrenceIdeal signature bad) (nestedOuterSlot firstSlot secondSlot) first
        (GateIdeal.quotientSubstitute (occurrenceIdeal signature bad) secondSlot second third) := by
  refine Quotient.inductionOn₂ first second ?_
  intro firstRepresentative secondRepresentative
  refine Quotient.inductionOn third ?_
  intro thirdRepresentative
  cases firstRepresentative <;> cases secondRepresentative <;> cases thirdRepresentative
  all_goals first
  | exact quotientTransport_bottom signature bad (nestedResult firstSlot secondSlot)
  | exact (quotientTransport_project signature bad (nestedResult firstSlot secondSlot) _).trans
      (congrArg (fun item => GateIdeal.project (occurrenceIdeal signature bad) item)
        (compose_nested firstSlot secondSlot _ _ _))

/-- Two distinct external occurrences, explicitly ordered from left to right. -/
structure DisjointSlots (outer inner other : GateIdeal.Profile Colour) where
  before : List Colour
  between : List Colour
  after : List Colour
  boundary_eq : outer.inputs = before ++ [inner.output] ++ between ++ [other.output] ++ after

namespace DisjointSlots

variable {outer inner other : GateIdeal.Profile Colour}

def first (slots : DisjointSlots outer inner other) : GateIdeal.Slot outer inner where
  before := slots.before
  after := slots.between ++ [other.output] ++ slots.after
  boundary_eq := by simpa only [List.append_assoc] using slots.boundary_eq

def second (slots : DisjointSlots outer inner other) : GateIdeal.Slot outer other where
  before := slots.before ++ [inner.output] ++ slots.between
  after := slots.after
  boundary_eq := slots.boundary_eq

def afterFirst (slots : DisjointSlots outer inner other) : GateIdeal.Slot slots.first.result other where
  before := slots.before ++ inner.inputs ++ slots.between
  after := slots.after
  boundary_eq := by simp only [first, GateIdeal.Slot.result, List.append_assoc]

def afterSecond (slots : DisjointSlots outer inner other) : GateIdeal.Slot slots.second.result inner where
  before := slots.before
  after := slots.between ++ other.inputs ++ slots.after
  boundary_eq := by simp only [second, GateIdeal.Slot.result, List.append_assoc]

theorem resultEq (slots : DisjointSlots outer inner other) :
    slots.afterFirst.result = slots.afterSecond.result := by
  simp only [afterFirst, afterSecond, first, second, GateIdeal.Slot.result, List.append_assoc]

theorem indices (slots : DisjointSlots outer inner other) :
    (slotIndex slots.first).val < (slotIndex slots.second).val := by
  simp only [slotIndex, first, second, List.length_append, List.length_singleton]
  omega

theorem different (slots : DisjointSlots outer inner other) : slotIndex slots.second ≠ slotIndex slots.first := by
  intro same
  have equal := congrArg Fin.val same
  have earlier := slots.indices
  omega

theorem afterFirst_index (slots : DisjointSlots outer inner other) :
    slotIndex slots.afterFirst = Fin.cast (slotResultLength slots.first)
      (oldSlot (m := inner.inputs.length) (slotIndex slots.first) (slotIndex slots.second) slots.different) := by
  apply Fin.ext
  change (slots.before ++ inner.inputs ++ slots.between).length =
    (oldSlot (m := inner.inputs.length) (slotIndex slots.first) (slotIndex slots.second) slots.different).val
  rw [oldSlot_val]
  simp only [slotIndex, first, second, List.length_append, List.length_singleton]
  have later : ¬ slots.before.length + 1 + slots.between.length < slots.before.length := by omega
  simp only [later, ite_false]
  omega

theorem afterSecond_index (slots : DisjointSlots outer inner other) :
    slotIndex slots.afterSecond = Fin.cast (slotResultLength slots.second)
      (oldSlot (m := other.inputs.length) (slotIndex slots.second) (slotIndex slots.first)
        (Ne.symm slots.different)) := by
  apply Fin.ext
  change slots.before.length =
    (oldSlot (m := other.inputs.length) (slotIndex slots.second) (slotIndex slots.first)
      (Ne.symm slots.different)).val
  rw [oldSlot_val]
  simp only [slotIndex, first, second, List.length_append, List.length_singleton]
  have earlier : slots.before.length < slots.before.length + 1 + slots.between.length := by omega
  simp only [earlier, ite_true]

end DisjointSlots

theorem compose_disjoint {signature : Label → GateIdeal.Profile Colour}
    {outer inner other : GateIdeal.Profile Colour} (slots : DisjointSlots outer inner other)
    (first : TypedExternal signature outer) (second : TypedExternal signature inner)
    (third : TypedExternal signature other) :
    profileTransport slots.resultEq
      (TypedExternal.compose slots.afterFirst (TypedExternal.compose slots.first first second) third) =
      TypedExternal.compose slots.afterSecond (TypedExternal.compose slots.second first third) second := by
  have raw := ExplicitTree.graft_disjoint first.term second.term third.term
    (slotIndex slots.first) (slotIndex slots.second) slots.different
  apply profileTransport_eq
  · change (((castTerm (slotResultLength slots.first) (first.term.graft second.term (slotIndex slots.first))).selected
      (slotIndex slots.afterFirst)).fill third.term.tree) =
        (((castTerm (slotResultLength slots.second) (first.term.graft third.term (slotIndex slots.second))).selected
          (slotIndex slots.afterSecond)).fill second.term.tree)
    rw [slots.afterFirst_index, slots.afterSecond_index]
    exact congrArg ExplicitTree.tree raw
  · intro index
    have rawOrder := congrArg (fun tree => (tree.order.toFun
      (Fin.cast ((congrArg (fun profile => profile.inputs.length) slots.resultEq).trans
        ((slotResultLength slots.afterSecond).symm.trans
          (congrArg (fun size => replacementSize size inner.inputs.length) (slotResultLength slots.second).symm)))
        index)).val) raw
    simp only [ExplicitTree.transportArity, transportPermutation_value] at rawOrder
    change ((splice (TypedExternal.compose slots.first first second).term.order third.term.order
      (slotIndex slots.afterFirst)).toFun (Fin.cast (slotResultLength slots.afterFirst).symm index)).val = _
    have firstOrder : (TypedExternal.compose slots.first first second).term.order =
        transportPermutation (slotResultLength slots.first)
          (splice first.term.order second.term.order (slotIndex slots.first)) :=
      congrArg ExplicitTree.order (castTerm_eq_transport (slotResultLength slots.first)
        (first.term.graft second.term (slotIndex slots.first)))
    have secondOrder : (TypedExternal.compose slots.second first third).term.order =
        transportPermutation (slotResultLength slots.second)
          (splice first.term.order third.term.order (slotIndex slots.second)) :=
      congrArg ExplicitTree.order (castTerm_eq_transport (slotResultLength slots.second)
        (first.term.graft third.term (slotIndex slots.second)))
    rw [firstOrder, slots.afterFirst_index]
    change ((splice (transportPermutation (slotResultLength slots.first)
        (splice first.term.order second.term.order (slotIndex slots.first)))
      (transportPermutation rfl third.term.order)
      (Fin.cast (slotResultLength slots.first)
        (oldSlot (slotIndex slots.first) (slotIndex slots.second) slots.different))).toFun _).val =
          ((splice (TypedExternal.compose slots.second first third).term.order second.term.order
            (slotIndex slots.afterSecond)).toFun _).val
    rw [secondOrder, slots.afterSecond_index]
    change _ = ((splice (transportPermutation (slotResultLength slots.second)
        (splice first.term.order third.term.order (slotIndex slots.second)))
      (transportPermutation rfl second.term.order)
      (Fin.cast (slotResultLength slots.second)
        (oldSlot (slotIndex slots.second) (slotIndex slots.first) (Ne.symm slots.different)))).toFun _).val
    rw [splice_transport, splice_transport]
    simp only [transportPermutation_value]
    exact rawOrder

theorem quotient_disjoint (signature : Label → GateIdeal.Profile Colour) (bad : Label → Prop)
    {outer inner other : GateIdeal.Profile Colour} (slots : DisjointSlots outer inner other)
    (first : GateIdeal.Rees (occurrenceIdeal signature bad) outer)
    (second : GateIdeal.Rees (occurrenceIdeal signature bad) inner)
    (third : GateIdeal.Rees (occurrenceIdeal signature bad) other) :
    quotientTransport signature bad slots.resultEq
      (GateIdeal.quotientSubstitute (occurrenceIdeal signature bad) slots.afterFirst
        (GateIdeal.quotientSubstitute (occurrenceIdeal signature bad) slots.first first second) third) =
      GateIdeal.quotientSubstitute (occurrenceIdeal signature bad) slots.afterSecond
        (GateIdeal.quotientSubstitute (occurrenceIdeal signature bad) slots.second first third) second := by
  refine Quotient.inductionOn₂ first second ?_
  intro firstRepresentative secondRepresentative
  refine Quotient.inductionOn third ?_
  intro thirdRepresentative
  cases firstRepresentative <;> cases secondRepresentative <;> cases thirdRepresentative
  all_goals first
  | exact quotientTransport_bottom signature bad slots.resultEq
  | exact (quotientTransport_project signature bad slots.resultEq _).trans
      (congrArg (fun item => GateIdeal.project (occurrenceIdeal signature bad) item)
        (compose_disjoint slots _ _ _))

#print axioms ProfileAction.comp_inverse
#print axioms TypedExternal.act_comp
#print axioms graft_rejected_iff
#print axioms occurrenceIdeal
#print axioms any_gate_projects_to_bottom
#print axioms action_respects_rees
#print axioms quotientAction_identity
#print axioms quotientAction_comp
#print axioms quotientAction_inverse
#print axioms quotientAction_inverse_other
#print axioms compositeAction
#print axioms TypedExternal.compose_action
#print axioms quotientSubstitute_action
#print axioms identity_survives
#print axioms compose_left_unit
#print axioms compose_right_unit
#print axioms compose_nested
#print axioms compose_disjoint
#print axioms quotient_left_unit
#print axioms quotient_right_unit
#print axioms quotient_nested
#print axioms quotient_disjoint

end Woland.SymmetricGateQuotient
