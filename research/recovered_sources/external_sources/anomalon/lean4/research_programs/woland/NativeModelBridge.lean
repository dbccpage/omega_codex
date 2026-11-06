import SymmetricGateQuotient
import Lean.Data.Json.Basic
import Init.Data.List.Nat.Pairwise

/-!
# The existing native normal form, decoded into the concrete Woland tree

AuthorityEffect: None.

This codec consumes the current Rust `NormalizedTerm.to_canonical` and
`ReindexedTerm.to_canonical` JSON constructors. It preserves declaration and
port provenance while type equality uses only colour and schema. Postorder
occurrence coordinates describe the whole structural tree, not a claim that
every node executed. The runtime separately checks inventory, plan, task,
candidate, checker and native-source bindings before using a negative finding.

The proofs concern this exact JSON codec and its construction of the existing
`ExplicitTree`. They do not prove Rust/compiler correctness, SHA injectivity,
receipt authentication, identifier admission or the truth of a gate finding.
The standard-library JSON object functions import `Classical.choice`; the
finite permutation reconstruction and occurrence quotient proofs do not use it.
-/

namespace Woland.NativeModelBridge

open Lean PlanarTree InputAction SymmetricGateQuotient

def modelProfile : String := "omega.oewas.native-model.v1"
def reindexedProfileName : String := "omega.oewas.operation-term.reindexed.v1"

structure PortWire where
  portId : String
  colourId : String
  schemaRef : String
  deriving DecidableEq, Repr

abbrev Colour := String × String

def PortWire.type (port : PortWire) : Colour := (port.colourId, port.schemaRef)

private def fields : Json → List (String × Json)
  | .obj object => object.toList
  | _ => []

def encodePort (port : PortWire) : Json := Json.mkObj [
  ("colour_id", .str port.colourId), ("port_id", .str port.portId),
  ("schema_ref", .str port.schemaRef)]

def decodePort (value : Json) : Option PortWire :=
  match fields value with
  | [("colour_id", .str colour), ("port_id", .str port), ("schema_ref", .str schema)] =>
      some ⟨port, colour, schema⟩
  | _ => none

theorem decodePort_encode (port : PortWire) : decodePort (encodePort port) = some port := by
  rfl

private def decodeList {α : Type} (read : Json → Option α) : List Json → Option (List α)
  | [] => some []
  | value :: rest => do
      let first ← read value
      let tail ← decodeList read rest
      pure (first :: tail)

private theorem decodeList_map {α : Type} (read : Json → Option α) (write : α → Json)
    (roundtrip : ∀ value, read (write value) = some value) :
    ∀ values, decodeList read (values.map write) = some values
  | [] => rfl
  | value :: rest => by simp [decodeList, roundtrip, decodeList_map read write roundtrip rest]

private def decodeArray {α : Type} (read : Json → Option α) : Json → Option (List α)
  | .arr values => decodeList read values.toList
  | _ => none

private def encodeArray {α : Type} (write : α → Json) (values : List α) : Json :=
  .arr (values.map write).toArray

private theorem decodeArray_encode {α : Type} (read : Json → Option α) (write : α → Json)
    (roundtrip : ∀ value, read (write value) = some value) (values : List α) :
    decodeArray read (encodeArray write values) = some values := by
  simp only [decodeArray, encodeArray]
  exact decodeList_map read write roundtrip values

private def decodeString : Json → Option String
  | .str value => some value
  | _ => none

inductive InvocationGrade where
  | entry | discipline
  deriving DecidableEq, Repr

def InvocationGrade.text : InvocationGrade → String
  | .entry => "entry"
  | .discipline => "discipline"

private def decodeGrade : Json → Option InvocationGrade
  | .str "entry" => some .entry
  | .str "discipline" => some .discipline
  | _ => none

private theorem decodeGrade_text (grade : InvocationGrade) :
    decodeGrade (.str grade.text) = some grade := by cases grade <;> rfl

inductive AuthorityEffect where
  | none | evidenceOnly | factOnly | stateTransition
  deriving DecidableEq, Repr

def AuthorityEffect.text : AuthorityEffect → String
  | .none => "None"
  | .evidenceOnly => "EvidenceOnly"
  | .factOnly => "FactOnly"
  | .stateTransition => "StateTransition"

private def decodeAuthority : Json → Option AuthorityEffect
  | .str "None" => some .none
  | .str "EvidenceOnly" => some .evidenceOnly
  | .str "FactOnly" => some .factOnly
  | .str "StateTransition" => some .stateTransition
  | _ => none

private theorem decodeAuthority_text (effect : AuthorityEffect) :
    decodeAuthority (.str effect.text) = some effect := by cases effect <;> rfl

structure OperationWire where
  operationId : String
  version : String
  inputPorts : List PortWire
  outputPort : PortWire
  executorRef : String
  executorDigest : String
  toolRefs : List String
  effects : List String
  invocationGrade : InvocationGrade
  authorityEffect : AuthorityEffect
  authorityCeiling : AuthorityEffect
  deriving DecidableEq, Repr

def encodeOperation (operation : OperationWire) : Json := Json.mkObj [
  ("authority_ceiling", .str operation.authorityCeiling.text),
  ("authority_effect", .str operation.authorityEffect.text),
  ("effects", encodeArray Json.str operation.effects),
  ("executor_digest", .str operation.executorDigest),
  ("executor_ref", .str operation.executorRef),
  ("input_ports", encodeArray encodePort operation.inputPorts),
  ("invocation_grade", .str operation.invocationGrade.text),
  ("operation_id", .str operation.operationId),
  ("output_port", encodePort operation.outputPort),
  ("tool_refs", encodeArray Json.str operation.toolRefs),
  ("version", .str operation.version)]

def decodeOperation (value : Json) : Option OperationWire :=
  match fields value with
  | [("authority_ceiling", ceiling), ("authority_effect", effect), ("effects", effects),
      ("executor_digest", .str digest), ("executor_ref", .str executor),
      ("input_ports", inputs), ("invocation_grade", grade), ("operation_id", .str name),
      ("output_port", output), ("tool_refs", tools), ("version", .str version)] => do
      let ceiling ← decodeAuthority ceiling
      let effect ← decodeAuthority effect
      let effects ← decodeArray decodeString effects
      let inputs ← decodeArray decodePort inputs
      let grade ← decodeGrade grade
      let output ← decodePort output
      let tools ← decodeArray decodeString tools
      pure ⟨name, version, inputs, output, executor, digest, tools, effects,
        grade, effect, ceiling⟩
  | _ => none

private theorem operation_fields (operation : OperationWire) : fields (encodeOperation operation) = [
    ("authority_ceiling", .str operation.authorityCeiling.text),
    ("authority_effect", .str operation.authorityEffect.text),
    ("effects", encodeArray Json.str operation.effects),
    ("executor_digest", .str operation.executorDigest), ("executor_ref", .str operation.executorRef),
    ("input_ports", encodeArray encodePort operation.inputPorts),
    ("invocation_grade", .str operation.invocationGrade.text),
    ("operation_id", .str operation.operationId), ("output_port", encodePort operation.outputPort),
    ("tool_refs", encodeArray Json.str operation.toolRefs), ("version", .str operation.version)] := by
  rfl

theorem decodeOperation_encode (operation : OperationWire) :
    decodeOperation (encodeOperation operation) = some operation := by
  simp only [decodeOperation, operation_fields, decodeAuthority_text, decodeGrade_text,
    decodePort_encode, decodeArray_encode decodePort encodePort decodePort_encode,
    decodeArray_encode decodeString Json.str (fun _ => rfl)]
  rfl

structure BoundaryWire where
  inputs : List PortWire
  output : PortWire
  deriving DecidableEq, Repr

def encodeBoundary (boundary : BoundaryWire) : Json := Json.mkObj [
  ("inputs", encodeArray encodePort boundary.inputs), ("output", encodePort boundary.output)]

def decodeBoundary (value : Json) : Option BoundaryWire :=
  match fields value with
  | [("inputs", inputs), ("output", output)] => do
      let inputs ← decodeArray decodePort inputs
      let output ← decodePort output
      pure ⟨inputs, output⟩
  | _ => none

private theorem boundary_fields (boundary : BoundaryWire) : fields (encodeBoundary boundary) = [
    ("inputs", encodeArray encodePort boundary.inputs), ("output", encodePort boundary.output)] := by
  rfl

theorem decodeBoundary_encode (boundary : BoundaryWire) :
    decodeBoundary (encodeBoundary boundary) = some boundary := by
  simp only [decodeBoundary, boundary_fields,
    decodeArray_encode decodePort encodePort decodePort_encode, decodePort_encode]
  rfl

abbrev RawTree := Tree PortWire OperationWire
abbrev RawForest := Forest PortWire OperationWire

mutual
  def encodeTree (root : Bool) : RawTree → Json
    | .input port => Json.mkObj [(if root then "identity" else "input", encodePort port)]
    | .node operation children => Json.mkObj [
        ("children", .arr (encodeForest children).toArray), ("operation", encodeOperation operation)]

  def encodeForest : RawForest → List Json
    | .nil => []
    | .cons tree rest => encodeTree false tree :: encodeForest rest
end

mutual
  def decodeTree : Nat → Bool → Json → Option RawTree
    | 0, _, _ => none
    | fuel + 1, root, value =>
      match fields value with
      | [("identity", port)] => if root then Tree.input <$> decodePort port else none
      | [("input", port)] => if root then none else Tree.input <$> decodePort port
      | [("children", .arr children), ("operation", operation)] => do
          let operation ← decodeOperation operation
          let children ← decodeForest fuel children.toList
          pure (.node operation children)
      | _ => none

  def decodeForest : Nat → List Json → Option RawForest
    | _, [] => some .nil
    | 0, _ :: _ => none
    | fuel + 1, value :: rest => do
        let tree ← decodeTree fuel false value
        let rest ← decodeForest fuel rest
        pure (.cons tree rest)
end

mutual
  def treeFuel : RawTree → Nat
    | .input _ => 1
    | .node _ children => forestFuel children + 1

  def forestFuel : RawForest → Nat
    | .nil => 0
    | .cons tree rest => max (treeFuel tree) (forestFuel rest) + 1
end

private theorem input_fields (root : Bool) (port : PortWire) :
    fields (encodeTree root (.input port)) = [(if root then "identity" else "input", encodePort port)] := by
  cases root <;> rfl

private theorem node_fields (root : Bool) (operation : OperationWire) (children : RawForest) :
    fields (encodeTree root (.node operation children)) = [
      ("children", .arr (encodeForest children).toArray), ("operation", encodeOperation operation)] := by
  rfl

mutual
  theorem decodeTree_encode (tree : RawTree) (fuel : Nat) (root : Bool)
      (enough : treeFuel tree ≤ fuel) : decodeTree fuel root (encodeTree root tree) = some tree := by
    cases fuel with
    | zero => cases tree <;> simp [treeFuel] at enough
    | succ fuel =>
      cases tree with
      | input port =>
          cases root <;> simp [decodeTree, input_fields, decodePort_encode]
      | node operation children =>
          have childFuel : forestFuel children ≤ fuel := by simpa [treeFuel] using enough
          simp only [decodeTree, node_fields, decodeOperation_encode]
          simp [decodeForest_encode children fuel childFuel]

  theorem decodeForest_encode (forest : RawForest) (fuel : Nat)
      (enough : forestFuel forest ≤ fuel) : decodeForest fuel (encodeForest forest) = some forest := by
    cases forest with
    | nil => cases fuel <;> rfl
    | cons tree rest =>
      cases fuel with
      | zero => simp [forestFuel] at enough
      | succ fuel =>
        have firstFuel : treeFuel tree ≤ fuel := by simp [forestFuel] at enough; omega
        have restFuel : forestFuel rest ≤ fuel := by simp [forestFuel] at enough; omega
        simp [encodeForest, decodeForest, decodeTree_encode tree fuel false firstFuel,
          decodeForest_encode rest fuel restFuel]
end

structure OccurrenceLabel where
  ordinal : Nat
  operation : OperationWire
  deriving DecidableEq, Repr

def signature (label : OccurrenceLabel) : GateIdeal.Profile Colour :=
  ⟨label.operation.inputPorts.map PortWire.type, label.operation.outputPort.type⟩

def rawSignature (operation : OperationWire) : GateIdeal.Profile PortWire :=
  ⟨operation.inputPorts, operation.outputPort⟩

mutual
  def operationCount : RawTree → Nat
    | .input _ => 0
    | .node _ children => forestOperationCount children + 1

  def forestOperationCount : RawForest → Nat
    | .nil => 0
    | .cons tree rest => operationCount tree + forestOperationCount rest
end

mutual
  def labelTree : RawTree → Nat → Tree Colour OccurrenceLabel
    | .input port, _ => .input port.type
    | .node operation children, start =>
        .node ⟨start + forestOperationCount children, operation⟩ (labelForest children start)

  def labelForest : RawForest → Nat → Forest Colour OccurrenceLabel
    | .nil, _ => .nil
    | .cons tree rest, start =>
        .cons (labelTree tree start) (labelForest rest (start + operationCount tree))
end

mutual
  theorem labelTree_inputs : ∀ (tree : RawTree) (start : Nat),
      (labelTree tree start).inputs = tree.inputs.map PortWire.type
    | .input _, _ => rfl
    | .node _ children, start => labelForest_inputs children start

  theorem labelForest_inputs : ∀ (forest : RawForest) (start : Nat),
      (labelForest forest start).inputs = forest.inputs.map PortWire.type
    | .nil, _ => rfl
    | .cons tree rest, start => by
        simp only [labelForest, Forest.inputs, labelTree_inputs, labelForest_inputs, List.map_append]
end

theorem labelTree_output (tree : RawTree) (start : Nat) :
    (labelTree tree start).output signature = (tree.output rawSignature).type := by
  cases tree <;> rfl

mutual
  def decidableTypedTree : (tree : Tree Colour OccurrenceLabel) → Decidable (tree.WellTyped signature)
    | .input _ => isTrue True.intro
    | .node label children => by
        change Decidable (children.WellTyped signature ∧ children.outputs signature = (signature label).inputs)
        letI := decidableTypedForest children
        infer_instance

  def decidableTypedForest : (forest : Forest Colour OccurrenceLabel) → Decidable (forest.WellTyped signature)
    | .nil => isTrue True.intro
    | .cons tree rest => by
        change Decidable (tree.WellTyped signature ∧ rest.WellTyped signature)
        letI := decidableTypedTree tree
        letI := decidableTypedForest rest
        infer_instance
end

private def lookup (values : List Nat) (index : Nat) : Nat := values[index]?.getD 0

/-- Both inverse equations are checked over the actual finite vector; no choice is used. -/
def PermutationValid (values : List Nat) (arity : Nat) : Prop :=
  values.length = arity ∧
  (∀ index : Fin arity, lookup values index.val < arity) ∧
  (∀ index : Fin arity, values.idxOf index.val < arity) ∧
  (∀ index : Fin arity, values.idxOf (lookup values index.val) = index.val) ∧
  (∀ index : Fin arity, lookup values (values.idxOf index.val) = index.val)

instance (values : List Nat) (arity : Nat) : Decidable (PermutationValid values arity) :=
  inferInstanceAs (Decidable (_ ∧ _ ∧ _ ∧ _ ∧ _))

def checkedPermutation (values : List Nat) (arity : Nat) (valid : PermutationValid values arity) :
    Permutation arity where
  toFun index := ⟨lookup values index.val, valid.2.1 index⟩
  invFun index := ⟨values.idxOf index.val, valid.2.2.1 index⟩
  left_inv index := Fin.ext (valid.2.2.2.1 index)
  right_inv index := Fin.ext (valid.2.2.2.2 index)

def permutationVector {arity : Nat} (permutation : Permutation arity) : List Nat :=
  List.ofFn (fun index => (permutation.toFun index).val)

private theorem lookup_permutationVector {arity : Nat} (permutation : Permutation arity) (index : Fin arity) :
    lookup (permutationVector permutation) index.val = (permutation.toFun index).val := by
  simp [lookup, permutationVector]

private theorem permutationVector_nodup {arity : Nat} (permutation : Permutation arity) :
    (permutationVector permutation).Nodup := by
  rw [List.nodup_iff_eq_of_getElem_eq]
  intro i j hi hj same
  simp only [permutationVector, List.length_ofFn] at hi hj
  have equal : permutation.toFun ⟨i, hi⟩ = permutation.toFun ⟨j, hj⟩ := by
    apply Fin.ext
    simpa [permutationVector] using same
  exact congrArg Fin.val (permutation.injective equal)

private theorem inverse_permutationVector {arity : Nat} (permutation : Permutation arity) (index : Fin arity) :
    (permutationVector permutation).idxOf index.val = (permutation.invFun index).val := by
  have roundtrip := (permutationVector_nodup permutation).idxOf_getElem
    (permutation.invFun index).val (by simp [permutationVector])
  simpa [permutationVector, permutation.right_inv] using roundtrip

theorem permutationVector_valid {arity : Nat} (permutation : Permutation arity) :
    PermutationValid (permutationVector permutation) arity := by
  refine ⟨by simp [permutationVector], ?_, ?_, ?_, ?_⟩
  · intro index; rw [lookup_permutationVector]; exact (permutation.toFun index).isLt
  · intro index; rw [inverse_permutationVector]; exact (permutation.invFun index).isLt
  · intro index
    rw [lookup_permutationVector, inverse_permutationVector, permutation.left_inv]
  · intro index
    rw [inverse_permutationVector, lookup_permutationVector, permutation.right_inv]

theorem checkedPermutation_roundtrip {arity : Nat} (permutation : Permutation arity) :
    checkedPermutation (permutationVector permutation) arity (permutationVector_valid permutation) = permutation := by
  apply IndexEquiv.ext
  intro index
  apply Fin.ext
  exact lookup_permutationVector permutation index

theorem checkedPermutation_vector (values : List Nat) (arity : Nat) (valid : PermutationValid values arity) :
    permutationVector (checkedPermutation values arity valid) = values := by
  apply List.ext_getElem (by simp [permutationVector, valid.1])
  intro index firstBound secondBound
  simp [permutationVector, checkedPermutation, lookup, List.getElem?_eq_getElem secondBound]

def planarBoundary (tree : RawTree) : BoundaryWire :=
  ⟨tree.inputs, tree.output rawSignature⟩

def externalBoundary (tree : RawTree) (order : List Nat) : BoundaryWire :=
  ⟨order.filterMap (fun index => tree.inputs[index]?), tree.output rawSignature⟩

def encodePlanar (tree : RawTree) : Json := Json.mkObj [
  ("boundary", encodeBoundary (planarBoundary tree)), ("tree", encodeTree true tree)]

def decodePlanar (fuel : Nat) (value : Json) : Option RawTree :=
  match fields value with
  | [("boundary", boundary), ("tree", tree)] => do
      let tree ← decodeTree fuel true tree
      let boundary ← decodeBoundary boundary
      if boundary = planarBoundary tree then pure tree else none
  | _ => none

private theorem planar_fields (tree : RawTree) : fields (encodePlanar tree) = [
    ("boundary", encodeBoundary (planarBoundary tree)), ("tree", encodeTree true tree)] := by rfl

theorem decodePlanar_encode (tree : RawTree) (fuel : Nat) (enough : treeFuel tree ≤ fuel) :
    decodePlanar fuel (encodePlanar tree) = some tree := by
  simp [decodePlanar, planar_fields, decodeTree_encode tree fuel true enough, decodeBoundary_encode]

private def decodeNat : Json → Option Nat
  | .num ⟨.ofNat number, 0⟩ => some number
  | _ => none

private def encodeNat (number : Nat) : Json := .num ⟨.ofNat number, 0⟩

structure ParsedNormalForm where
  tree : RawTree
  externalToPlanar : List Nat
  explicitOrder : Bool

def encodeNormalForm (value : ParsedNormalForm) : Json :=
  if value.explicitOrder then Json.mkObj [
    ("boundary", encodeBoundary (externalBoundary value.tree value.externalToPlanar)),
    ("external_to_planar", encodeArray encodeNat value.externalToPlanar),
    ("planar", encodePlanar value.tree),
    ("schema_version", .str reindexedProfileName)]
  else encodePlanar value.tree

def decodeParsedNormalForm (fuel : Nat) (value : Json) : Option ParsedNormalForm :=
  match fields value with
  | [("boundary", _), ("tree", _)] => do
      let tree ← decodePlanar fuel value
      pure ⟨tree, List.range tree.inputs.length, false⟩
  | [("boundary", boundary), ("external_to_planar", order), ("planar", planar),
      ("schema_version", .str "omega.oewas.operation-term.reindexed.v1")] => do
      let tree ← decodePlanar fuel planar
      let order ← decodeArray decodeNat order
      let boundary ← decodeBoundary boundary
      if boundary = externalBoundary tree order then pure ⟨tree, order, true⟩ else none
  | _ => none

private theorem explicit_fields (tree : RawTree) (order : List Nat) :
    fields (encodeNormalForm ⟨tree, order, true⟩) = [
      ("boundary", encodeBoundary (externalBoundary tree order)),
      ("external_to_planar", encodeArray encodeNat order),
      ("planar", encodePlanar tree), ("schema_version", .str reindexedProfileName)] := by rfl

theorem decodeParsedNormalForm_encode (value : ParsedNormalForm) (fuel : Nat)
    (enough : treeFuel value.tree ≤ fuel)
    (planarOrder : value.explicitOrder = false → value.externalToPlanar = List.range value.tree.inputs.length) :
    decodeParsedNormalForm fuel (encodeNormalForm value) = some value := by
  rcases value with ⟨tree, order, explicit⟩
  cases explicit with
  | false =>
      have same := planarOrder rfl
      change order = List.range tree.inputs.length at same
      subst order
      simp only [encodeNormalForm, Bool.false_eq_true, ↓reduceIte, decodeParsedNormalForm, planar_fields]
      simp [decodePlanar_encode tree fuel enough]
  | true =>
      simp only [decodeParsedNormalForm, explicit_fields, reindexedProfileName,
        decodePlanar_encode tree fuel enough,
        decodeArray_encode decodeNat encodeNat (fun _ => rfl), decodeBoundary_encode]
      simp

def ModelConditions (value : ParsedNormalForm) : Prop :=
  PermutationValid value.externalToPlanar value.tree.inputs.length ∧
  (labelTree value.tree 0).WellTyped signature ∧
  (value.explicitOrder = false → value.externalToPlanar = List.range value.tree.inputs.length)

instance (value : ParsedNormalForm) : Decidable (ModelConditions value) := by
  letI := decidableTypedTree (labelTree value.tree 0)
  exact inferInstanceAs (Decidable (_ ∧ _ ∧ _))

abbrev DecodedModel := {value : ParsedNormalForm // ModelConditions value}

def decodeNormalForm (fuel : Nat) (value : Json) : Option DecodedModel := do
  let parsed ← decodeParsedNormalForm fuel value
  if valid : ModelConditions parsed then pure ⟨parsed, valid⟩ else none

theorem decodeNormalForm_roundtrip (value : DecodedModel) (fuel : Nat)
    (enough : treeFuel value.val.tree ≤ fuel) :
    decodeNormalForm fuel (encodeNormalForm value.val) = some value := by
  simp only [decodeNormalForm,
    decodeParsedNormalForm_encode value.val fuel enough value.property.2.2]
  change (if valid : ModelConditions value.val then some (⟨value.val, valid⟩ : DecodedModel) else none) = some value
  rw [dite_eq_left value.property]

theorem decodeNormalForm_source {fuel : Nat} {value : Json} {decoded : DecodedModel}
    (accepted : decodeNormalForm fuel value = some decoded) :
    decodeParsedNormalForm fuel value = some decoded.val := by
  unfold decodeNormalForm at accepted
  cases parsed : decodeParsedNormalForm fuel value with
  | none => simp [parsed] at accepted
  | some raw =>
      rw [parsed] at accepted
      change (if valid : ModelConditions raw then some (⟨raw, valid⟩ : DecodedModel) else none) =
        some decoded at accepted
      split at accepted
      next valid =>
        have same : (⟨raw, valid⟩ : DecodedModel) = decoded := Option.some.inj accepted
        exact congrArg (fun item : DecodedModel => some item.val) same
      next invalid => cases accepted

def DecodedModel.explicitTree (value : DecodedModel) :
    ExplicitTree Colour OccurrenceLabel value.val.tree.inputs.length where
  tree := labelTree value.val.tree 0
  input_length := by simp only [labelTree_inputs, List.length_map]
  order := checkedPermutation value.val.externalToPlanar value.val.tree.inputs.length value.property.1

theorem decodeNormalForm_wellTyped {fuel : Nat} {json : Json} {value : DecodedModel}
    (_accepted : decodeNormalForm fuel json = some value) : value.explicitTree.tree.WellTyped signature :=
  value.property.2.1

theorem decodeNormalForm_order {fuel : Nat} {json : Json} {value : DecodedModel}
    (_accepted : decodeNormalForm fuel json = some value) (index : Fin value.val.tree.inputs.length) :
    (value.explicitTree.order.toFun index).val = lookup value.val.externalToPlanar index.val := rfl

theorem decodeNormalForm_portProvenance {fuel : Nat} {json : Json} {value : DecodedModel}
    (_accepted : decodeNormalForm fuel json = some value) :
    value.explicitTree.tree.inputs = value.val.tree.inputs.map PortWire.type :=
  labelTree_inputs value.val.tree 0

def DecodedModel.profile (value : DecodedModel) : GateIdeal.Profile Colour :=
  ⟨List.ofFn value.explicitTree.externalColour, value.explicitTree.tree.output signature⟩

def DecodedModel.typed (value : DecodedModel) : TypedExternal signature value.profile := by
  let tree := value.explicitTree
  have length : value.profile.inputs.length = value.val.tree.inputs.length := by
    simp [DecodedModel.profile]
  let order : Permutation value.profile.inputs.length := {
    toFun := fun index => Fin.cast length.symm (tree.order.toFun (Fin.cast length index))
    invFun := fun index => Fin.cast length.symm (tree.order.invFun (Fin.cast length index))
    left_inv := by intro index; apply Fin.ext; simp [tree.order.left_inv]
    right_inv := by intro index; apply Fin.ext; simp [tree.order.right_inv]
  }
  refine ⟨⟨tree.tree, tree.input_length.trans length.symm, order⟩, value.property.2.1, ?_, rfl⟩
  intro index
  simp only [ExplicitTree.externalColour, DecodedModel.profile, List.getElem_ofFn, order]
  rfl

theorem decoded_typed_tree (value : DecodedModel) :
    value.typed.term.tree = labelTree value.val.tree 0 := rfl

theorem decoded_external_boundary (value : DecodedModel) :
    (externalBoundary value.val.tree value.val.externalToPlanar).inputs.map PortWire.type =
      value.profile.inputs := by
  let permutation := value.explicitTree.order
  have vector : value.val.externalToPlanar = permutationVector permutation :=
    (checkedPermutation_vector _ _ value.property.1).symm
  have asMap : permutationVector permutation =
      (List.finRange value.val.tree.inputs.length).map (fun index => (permutation.toFun index).val) := by
    simp [permutationVector, List.finRange, List.map_ofFn, Function.comp_def]
  have readback : (fun index : Fin value.val.tree.inputs.length =>
      value.val.tree.inputs[(permutation.toFun index).val]?) =
      (fun index => some (value.val.tree.inputs[(permutation.toFun index).val])) := by
    funext index
    exact List.getElem?_eq_getElem (permutation.toFun index).isLt
  unfold externalBoundary
  rw [vector, asMap, List.filterMap_map]
  change List.map PortWire.type
    (List.filterMap (fun index : Fin value.val.tree.inputs.length =>
      value.val.tree.inputs[(permutation.toFun index).val]?)
      (List.finRange value.val.tree.inputs.length)) = _
  rw [readback, List.filterMap_eq_map']
  simp only [List.finRange, List.map_ofFn, DecodedModel.profile]
  congr 1
  funext index
  simp only [ExplicitTree.externalColour, DecodedModel.explicitTree, labelTree_inputs, List.getElem_map]
  rfl

theorem decoded_output_boundary (value : DecodedModel) :
    value.profile.output = (planarBoundary value.val.tree).output.type :=
  labelTree_output value.val.tree 0

mutual
  def postorder : Tree Colour OccurrenceLabel → List OccurrenceLabel
    | .input _ => []
    | .node label children => forestPostorder children ++ [label]

  def forestPostorder : Forest Colour OccurrenceLabel → List OccurrenceLabel
    | .nil => []
    | .cons tree rest => postorder tree ++ forestPostorder rest
end

mutual
  theorem labelTree_ordinals : ∀ (tree : RawTree) (start : Nat),
      (postorder (labelTree tree start)).map OccurrenceLabel.ordinal = List.range' start (operationCount tree)
    | .input _, _ => rfl
    | .node operation children, start => by
        simp only [labelTree, postorder, List.map_append, List.map_cons, List.map_nil,
          labelForest_ordinals, operationCount]
        exact List.range'_1_concat.symm

  theorem labelForest_ordinals : ∀ (forest : RawForest) (start : Nat),
      (forestPostorder (labelForest forest start)).map OccurrenceLabel.ordinal =
        List.range' start (forestOperationCount forest)
    | .nil, _ => rfl
    | .cons tree rest, start => by
        simp only [labelForest, forestPostorder, List.map_append, labelTree_ordinals,
          labelForest_ordinals, forestOperationCount, List.range'_append_1]
end

theorem decoded_postorder_ordinals (value : DecodedModel) :
    (postorder value.typed.term.tree).map OccurrenceLabel.ordinal = List.range (operationCount value.val.tree) := by
  rw [decoded_typed_tree, labelTree_ordinals, List.range_eq_range']

def DecodedModel.occurrence (value : DecodedModel) (ordinal : Nat) : Option OccurrenceLabel :=
  (postorder value.typed.term.tree).find? (fun label => label.ordinal == ordinal)

theorem decoded_occurrence_member (value : DecodedModel) (ordinal : Nat) (label : OccurrenceLabel)
    (found : value.occurrence ordinal = some label) : label ∈ postorder value.typed.term.tree := by
  exact List.mem_of_find?_eq_some found

theorem decoded_occurrence_ordinal (value : DecodedModel) (ordinal : Nat) (label : OccurrenceLabel)
    (found : value.occurrence ordinal = some label) : label.ordinal = ordinal := by
  simpa only [beq_iff_eq] using List.find?_some found

mutual
  theorem rejected_iff_postorder (bad : OccurrenceLabel → Prop) :
      ∀ tree : Tree Colour OccurrenceLabel,
        tree.Rejected bad ↔ ∃ label ∈ postorder tree, bad label
    | .input _ => by simp [Tree.Rejected, postorder]
    | .node label children => by
        simp only [Tree.Rejected, postorder, forestRejected_iff_postorder, List.mem_append,
          List.mem_singleton, or_and_right, exists_or, exists_eq_left]
        exact or_comm

  theorem forestRejected_iff_postorder (bad : OccurrenceLabel → Prop) :
      ∀ forest : Forest Colour OccurrenceLabel,
        forest.Rejected bad ↔ ∃ label ∈ forestPostorder forest, bad label
    | .nil => by simp [Forest.Rejected, forestPostorder]
    | .cons tree rest => by
        simp only [Forest.Rejected, forestPostorder, rejected_iff_postorder,
          forestRejected_iff_postorder, List.mem_append, or_and_right, exists_or]
end

/-- A gate finding is still a premise supplied by its independently checked runtime owner.
    Lookup ties it to an actual decoded operation occurrence, including an executed child
    whose unexecuted parent is retained in the whole structural tree. -/
theorem decoded_occurrence_projects_to_bottom (value : DecodedModel)
    (gates : GateFamily22 OccurrenceLabel) (gate : Fin 22) (ordinal : Nat) (label : OccurrenceLabel)
    (found : value.occurrence ordinal = some label) (failed : gates gate label) :
    GateIdeal.project (gateIdeal22 signature gates) value.typed =
      GateIdeal.bottom (gateIdeal22 signature gates) value.profile := by
  apply any_gate_projects_to_bottom signature gates gate value.typed
  exact (rejected_iff_postorder (gates gate) value.typed.term.tree).mpr
    ⟨label, decoded_occurrence_member value ordinal label found, failed⟩

theorem identity_has_no_occurrence (port : PortWire) (start ordinal : Nat) :
    (postorder (labelTree (.input port) start)).find? (fun label => label.ordinal == ordinal) = none := rfl

namespace Gate14

def projectionProfile : String := "woland.gate14-transport-projection.v1"

/-- A finite view of natasha_legacy after the existing pool.v2 expansion.
    Byte lists are decoded UTF-8 bytes, not token identities or semantic scores. -/
structure Transport where
  transportProfile : String
  snapshotId : String
  originBytes : List UInt8
  receivedBytes : List UInt8
  originCoordinates : List String
  retainedCoordinates : List String
  droppedCoordinates : List String
  deriving DecidableEq, Repr

def coordinatesPreserved (wire : Transport) : Bool :=
  wire.originCoordinates.all (fun name => wire.retainedCoordinates.contains name) &&
  wire.retainedCoordinates.all (fun name => wire.originCoordinates.contains name)

/-- Exactly byte equality, no drops, and coordinate-set equality; order and
    multiplicity of coordinate names are immaterial, as in the native BTreeSet. -/
def preserves (wire : Transport) : Bool :=
  decide (wire.originBytes = wire.receivedBytes) &&
  decide (wire.droppedCoordinates = []) && coordinatesPreserved wire

private def decodeByte (value : Json) : Option UInt8 := do
  let number ← decodeNat value
  if number < 256 then some (UInt8.ofNat number) else none

/-- This is a projection of retained native fields, not another execution wire.
    Checksum/authentication, nonempty native strings and source selection remain
    obligations of the host that produces it. The decoder grants no trust. -/
def decodeProjection (value : Json) : Option Transport :=
  match fields value with
  | [("dropped_coordinates", dropped), ("origin_bytes", origin),
      ("origin_coordinates", coordinates), ("received_bytes", received),
      ("retained_coordinates", retained),
      ("schema_version", .str "woland.gate14-transport-projection.v1"),
      ("snapshot_id", .str snapshot), ("transport_profile", .str profile)] => do
      if profile != "legacy-utf8" && profile != "woland.pfp-transport-pool.v2" then none else do
        let origin ← decodeArray decodeByte origin
        let received ← decodeArray decodeByte received
        let coordinates ← decodeArray decodeString coordinates
        let retained ← decodeArray decodeString retained
        let dropped ← decodeArray decodeString dropped
        pure ⟨profile, snapshot, origin, received, coordinates, retained, dropped⟩
  | _ => none

def encodeProjection (wire : Transport) : Json := Json.mkObj [
  ("dropped_coordinates", encodeArray Json.str wire.droppedCoordinates),
  ("origin_bytes", encodeArray (fun byte => encodeNat byte.toNat) wire.originBytes),
  ("origin_coordinates", encodeArray Json.str wire.originCoordinates),
  ("received_bytes", encodeArray (fun byte => encodeNat byte.toNat) wire.receivedBytes),
  ("retained_coordinates", encodeArray Json.str wire.retainedCoordinates),
  ("schema_version", .str projectionProfile), ("snapshot_id", .str wire.snapshotId),
  ("transport_profile", .str wire.transportProfile)]

theorem byte_mismatch_refuses (wire : Transport) (changed : wire.originBytes ≠ wire.receivedBytes) :
    preserves wire = false := by simp [preserves, changed]

theorem dropped_coordinate_refuses (wire : Transport) (dropped : wire.droppedCoordinates ≠ []) :
    preserves wire = false := by simp [preserves, dropped]

theorem coordinate_mismatch_refuses (wire : Transport) (changed : coordinatesPreserved wire = false) :
    preserves wire = false := by simp [preserves, changed]

/-- These strings name existing retained bindings. Their equalities do not prove
    SHA collision resistance, executable authenticity or compiler correctness. -/
structure Scope where
  taskId : String
  attemptId : String
  taskSha256 : String
  invocationSha256 : String
  inputSha256 : String
  outputSha256 : String
  operationId : String
  operationSha256 : String
  ordinal : Nat
  sourceProfile : String
  nativeModelSha256 : String
  nativeBinarySha256 : String
  checkerSourceSha256 : String
  gateSpecificationSha256 : String
  deriving DecidableEq, Repr

/-- Explicit environmental assumptions, not axioms and not gate-failure flags.
    Runtime code must establish these using current source/raw replay/model
    checks. Lean does not authenticate OS captures, hashes or compiled code. -/
structure TrustBoundary where
  nativeReplayTrusted : Scope → Prop
  projectionFaithful : Scope → Transport → Prop
  modelBindingFaithful : Scope → DecodedModel → Prop

def checkedFailure (trust : TrustBoundary) (model : DecodedModel)
    (expected observed : Scope) (projectionJson : Json) (wire : Transport) (label : OccurrenceLabel) : Prop :=
  observed = expected ∧ observed.ordinal = label.ordinal ∧
  observed.operationId = label.operation.operationId ∧
  observed.sourceProfile = "woland.native-checked-occurrence.v2" ∧
  decodeProjection projectionJson = some wire ∧
  trust.nativeReplayTrusted observed ∧ trust.projectionFaithful observed wire ∧
  trust.modelBindingFaithful observed model ∧ preserves wire = false

def family (trust : TrustBoundary) (model : DecodedModel)
    (expected observed : Scope) (projectionJson : Json) (wire : Transport) : GateFamily22 OccurrenceLabel :=
  fun gate label => gate.val = 13 ∧ checkedFailure trust model expected observed projectionJson wire label

/-- A concrete byte counterexample supplies the finite negative. No arbitrary
    `gates gate label` or claimed REFUSE is assumed. The actual decoded lookup,
    complete scope and named external replay/projection/model premises remain. -/
theorem byte_mismatch_projects_to_bottom (model : DecodedModel)
    (trust : TrustBoundary) (expected observed : Scope) (projectionJson : Json) (wire : Transport)
    (ordinal : Nat) (label : OccurrenceLabel)
    (found : model.occurrence ordinal = some label)
    (scopeBound : observed = expected) (ordinalBound : observed.ordinal = ordinal)
    (operationBound : observed.operationId = label.operation.operationId)
    (sourceProfile : observed.sourceProfile = "woland.native-checked-occurrence.v2")
    (decodedProjection : decodeProjection projectionJson = some wire)
    (nativeReplay : trust.nativeReplayTrusted observed)
    (projection : trust.projectionFaithful observed wire)
    (modelBinding : trust.modelBindingFaithful observed model)
    (changed : wire.originBytes ≠ wire.receivedBytes) :
    GateIdeal.project (gateIdeal22 signature (family trust model expected observed projectionJson wire)) model.typed =
      GateIdeal.bottom (gateIdeal22 signature (family trust model expected observed projectionJson wire)) model.profile := by
  apply decoded_occurrence_projects_to_bottom model
    (family trust model expected observed projectionJson wire) ⟨13, by decide⟩ ordinal label found
  exact ⟨rfl, scopeBound,
    ordinalBound.trans (decoded_occurrence_ordinal model ordinal label found).symm,
    operationBound, sourceProfile, decodedProjection, nativeReplay, projection, modelBinding,
    byte_mismatch_refuses wire changed⟩

namespace Controls

def benign : Transport := ⟨"legacy-utf8", "actual-turn", [65, 66], [65, 66],
  ["system", "user"], ["user", "system", "system"], []⟩

theorem finite_projection_decodes : decodeProjection (encodeProjection benign) = some benign := by decide

theorem pooled_projection_decodes :
    decodeProjection (encodeProjection { benign with transportProfile := "woland.pfp-transport-pool.v2" }) =
      some { benign with transportProfile := "woland.pfp-transport-pool.v2" } := by decide

theorem reordered_duplicate_coordinates_preserved : preserves benign = true := by decide

theorem changed_byte_refuses : preserves { benign with receivedBytes := [66, 65] } = false := by decide

theorem omitted_coordinate_refuses :
    preserves { benign with retainedCoordinates := ["system"] } = false := by decide

theorem dropped_coordinate_refuses :
    preserves { benign with droppedCoordinates := ["user"] } = false := by decide

theorem unknown_projection_refuses : decodeProjection (Json.mkObj [
    ("schema_version", .str "unknown.v9")]) = none := by decide

end Controls
end Gate14

namespace Controls

def codePort : PortWire := ⟨"slot0", "Code", "inventory:Code:v1"⟩
def proofPort : PortWire := ⟨"slot1", "Proof", "inventory:Proof:v1"⟩

def identityJson : Json := encodePlanar (.input codePort)

theorem identity_decodes : (decodeNormalForm 8 identityJson).isSome = true := by decide

theorem empty_fuel_refuses : decodeNormalForm 0 identityJson = none := by decide

theorem unknown_profile_refuses : decodeNormalForm 8 (Json.mkObj [
    ("boundary", encodeBoundary (planarBoundary (.input codePort))),
    ("external_to_planar", .arr #[encodeNat 0]), ("planar", identityJson),
    ("schema_version", .str "omega.oewas.operation-term.reindexed.v9")]) = none := by decide

theorem stale_boundary_refuses : decodeNormalForm 8 (Json.mkObj [
    ("boundary", encodeBoundary ⟨[proofPort], codePort⟩),
    ("tree", encodeTree true (.input codePort))]) = none := by decide

theorem extra_port_field_refuses : decodePort (Json.mkObj [
    ("colour_id", .str "Code"), ("port_id", .str "slot0"), ("schema_ref", .str "inventory:Code:v1"),
    ("ignored", .bool true)]) = none := by decide

def unary : OperationWire := ⟨"repeat", "v3", [codePort], codePort,
  "inventory-binding", "sha256:0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef",
  [], [], .discipline, .none, .none⟩

def repeated : RawTree := .node unary (.cons (.node unary (.cons (.input codePort) .nil)) .nil)

theorem repeated_operation_occurrences :
    (postorder (labelTree repeated 0)).map (fun label => (label.ordinal, label.operation.operationId)) =
      [(0, "repeat"), (1, "repeat")] := by decide

theorem repeated_decodes : (decodeNormalForm 16 (encodePlanar repeated)).isSome = true := by decide

theorem ill_typed_child_refuses :
    decodeNormalForm 16 (encodePlanar (.node unary (.cons (.input proofPort) .nil))) = none := by decide

def nullary : RawTree := .node { unary with operationId := "constant", inputPorts := [] } .nil

theorem nullary_decodes :
    (decodeNormalForm 8 (encodeNormalForm ⟨nullary, [], true⟩)).isSome = true := by decide

def binary : RawTree := .node { unary with operationId := "pair", inputPorts := [codePort, {codePort with portId := "slot1"}] }
  (.cons (.input codePort) (.cons (.input {codePort with portId := "slot1"}) .nil))

theorem repeated_colour_swap_decodes :
    (decodeNormalForm 16 (encodeNormalForm ⟨binary, [1, 0], true⟩)).isSome = true := by decide

theorem duplicate_permutation_refuses :
    decodeNormalForm 16 (encodeNormalForm ⟨binary, [0, 0], true⟩) = none := by decide

theorem out_of_range_permutation_refuses :
    decodeNormalForm 16 (encodeNormalForm ⟨binary, [0, 2], true⟩) = none := by decide

theorem boolean_permutation_refuses : decodeNormalForm 16 (Json.mkObj [
    ("boundary", encodeBoundary (externalBoundary binary [0, 1])),
    ("external_to_planar", .arr #[.bool false, .bool true]), ("planar", encodePlanar binary),
    ("schema_version", .str reindexedProfileName)]) = none := by decide

end Controls

#print axioms decodePort_encode
#print axioms decodeOperation_encode
#print axioms decodeBoundary_encode
#print axioms decodeTree_encode
#print axioms decodeForest_encode
#print axioms checkedPermutation_roundtrip
#print axioms checkedPermutation_vector
#print axioms decodeParsedNormalForm_encode
#print axioms decodeNormalForm_roundtrip
#print axioms decodeNormalForm_source
#print axioms decodeNormalForm_wellTyped
#print axioms decoded_external_boundary
#print axioms decoded_postorder_ordinals
#print axioms decoded_occurrence_projects_to_bottom
#print axioms identity_has_no_occurrence
#print axioms decoded_output_boundary
#print axioms decoded_occurrence_ordinal
#print axioms Controls.identity_decodes
#print axioms Controls.empty_fuel_refuses
#print axioms Controls.unknown_profile_refuses
#print axioms Controls.stale_boundary_refuses
#print axioms Controls.extra_port_field_refuses
#print axioms Controls.repeated_operation_occurrences
#print axioms Controls.repeated_decodes
#print axioms Controls.ill_typed_child_refuses
#print axioms Controls.nullary_decodes
#print axioms Controls.repeated_colour_swap_decodes
#print axioms Controls.duplicate_permutation_refuses
#print axioms Controls.out_of_range_permutation_refuses
#print axioms Controls.boolean_permutation_refuses
#print axioms Gate14.byte_mismatch_refuses
#print axioms Gate14.dropped_coordinate_refuses
#print axioms Gate14.coordinate_mismatch_refuses
#print axioms Gate14.byte_mismatch_projects_to_bottom
#print axioms Gate14.Controls.reordered_duplicate_coordinates_preserved
#print axioms Gate14.Controls.changed_byte_refuses
#print axioms Gate14.Controls.omitted_coordinate_refuses
#print axioms Gate14.Controls.dropped_coordinate_refuses
#print axioms Gate14.Controls.unknown_projection_refuses
#print axioms Gate14.Controls.finite_projection_decodes
#print axioms Gate14.Controls.pooled_projection_decodes

end Woland.NativeModelBridge
