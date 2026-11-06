import ProtectedRewrite

/-!
# Retained session payloads and one concrete hint insertion

AuthorityEffect: None. Ordered field/observation bytes and the entire source are
retained, not replaced by digests. Graph positions identify occurrences. The
fixed rule retains all old parts/links and appends one hint and its context edge.
Its confluence follows from the actual deterministic, once-only rule, not DPO
adhesivity or fuel alone. This Lean decoder is a finite model: correspondence to
Python JSON, SourceDocument chunking and fresh string IDs remains a separate
implementation obligation. No hash injectivity or semantic oracle is assumed.
-/

namespace Woland.ConcretePromptRewrite

open ProtectedRewrite

structure Payload where
  source : List UInt8
  fields : List (String × List UInt8)
  observations : List (List UInt8)
  deriving DecidableEq, Repr

inductive Part where
  | source (bytes : List UInt8)
  | field (key : String) (bytes : List UInt8)
  | observation (bytes : List UInt8)
  | hint (text : String)
  deriving DecidableEq, Repr

structure Link where
  source : Nat
  target : Nat
  deriving DecidableEq, Repr

structure Graph where
  parts : List Part
  links : List Link
  deriving DecidableEq, Repr

def hintText : String := "Check each protected constraint before proposing a certificate."

def baseParts (payload : Payload) : List Part :=
  .source payload.source ::
    (payload.fields.map (fun (key, bytes) => .field key bytes) ++
      payload.observations.map .observation)

def baseLinks (payload : Payload) : List Link :=
  (List.range (payload.fields.length + payload.observations.length)).map
    (fun index => ⟨0, index + 1⟩)

def render (payload : Payload) (hint : Bool) : Graph :=
  if hint then
    ⟨baseParts payload ++ [.hint hintText],
      baseLinks payload ++ [⟨(baseParts payload).length, 0⟩]⟩
  else ⟨baseParts payload, baseLinks payload⟩

def fieldValue : Part → Option (String × List UInt8)
  | .field key bytes => some (key, bytes)
  | _ => none

def observationValue : Part → Option (List UInt8)
  | .observation bytes => some bytes
  | _ => none

def readPayload (graph : Graph) : Option Payload :=
  match graph.parts with
  | .source bytes :: rest =>
      some ⟨bytes, rest.filterMap fieldValue, rest.filterMap observationValue⟩
  | _ => none

def decode (graph : Graph) : Option (Payload × Bool) :=
  match readPayload graph with
  | none => none
  | some payload =>
      if graph = render payload false then some (payload, false)
      else if graph = render payload true then some (payload, true)
      else none

private theorem filter_none (values : List α) :
    values.filterMap (fun _ => (none : Option β)) = [] := by
  induction values with
  | nil => rfl
  | cons _ _ ih => simp [ih]

theorem read_render (payload : Payload) (hint : Bool) :
    readPayload (render payload hint) = some payload := by
  cases hint <;>
    simp [render, baseParts, readPayload, fieldValue, observationValue,
      List.filterMap_append, List.filterMap_map, Function.comp_def, List.filterMap_cons,
      List.filterMap_nil, filter_none]

theorem rendered_hint_differs (payload : Payload) :
    render payload true ≠ render payload false := by
  intro same
  have lengths := congrArg (fun graph => graph.parts.length) same
  change (baseParts payload ++ [Part.hint hintText]).length = (baseParts payload).length at lengths
  rw [List.length_append, List.length_singleton] at lengths
  exact (Nat.ne_of_gt (Nat.lt_succ_self _)) lengths

theorem decode_render (payload : Payload) (hint : Bool) :
    decode (render payload hint) = some (payload, hint) := by
  cases hint <;> simp [decode, read_render, rendered_hint_differs]

theorem decode_sound (graph : Graph) (payload : Payload) (hint : Bool)
    (accepted : decode graph = some (payload, hint)) : graph = render payload hint := by
  cases read : readPayload graph with
  | none => simp [decode, read] at accepted
  | some actual =>
      by_cases plain : graph = render actual false
      · have pair : (actual, false) = (payload, hint) := by
          simpa [decode, read, plain, read_render] using accepted
        cases pair
        exact plain
      · by_cases added : graph = render actual true
        · have pair : (actual, true) = (payload, hint) := by
            simpa [decode, read, plain, added, read_render, rendered_hint_differs] using accepted
          cases pair
          exact added
        · simp [decode, read, plain, added] at accepted

theorem render_injective {first second : Payload} {left right : Bool}
    (same : render first left = render second right) : first = second ∧ left = right := by
  have decoded := congrArg decode same
  rw [decode_render, decode_render] at decoded
  exact Prod.mk.inj (Option.some.inj decoded)

structure HintState where
  payload : Payload
  hint : Bool
  fuel : Nat
  deriving DecidableEq, Repr

def insertHint (before : HintState) : Option HintState :=
  match before.hint, before.fuel with
  | false, fuel + 1 => some ⟨before.payload, true, fuel⟩
  | _, _ => none

def HintStep (before after : HintState) : Prop := insertHint before = some after

theorem step_result {before after : HintState} (step : HintStep before after) :
    after.payload = before.payload ∧ after.hint = true ∧
      after.fuel + 1 = before.fuel ∧ before.hint = false := by
  cases before with
  | mk payload hint fuel =>
      cases hint <;> cases fuel <;> simp_all [HintStep, insertHint]
      cases step
      simp

theorem step_preserves_source {before after : HintState} (step : HintStep before after) :
    after.payload.source = before.payload.source := congrArg Payload.source (step_result step).1

theorem step_preserves_fields {before after : HintState} (step : HintStep before after) :
    after.payload.fields = before.payload.fields := congrArg Payload.fields (step_result step).1

theorem step_preserves_observations {before after : HintState} (step : HintStep before after) :
    after.payload.observations = before.payload.observations :=
  congrArg Payload.observations (step_result step).1

theorem step_exact_graph_delta {before after : HintState} (step : HintStep before after) :
    (render after.payload after.hint).parts =
      (render before.payload before.hint).parts ++ [.hint hintText] ∧
    (render after.payload after.hint).links =
      (render before.payload before.hint).links ++ [⟨(baseParts before.payload).length, 0⟩] := by
  obtain ⟨payload, hint, _, absent⟩ := step_result step
  simp [payload, hint, absent, render]

theorem step_preserves_boundary (query : Payload → ProtectedQuery)
    {before after : HintState} (step : HintStep before after) :
    query before.payload = query after.payload := congrArg query (step_result step).1.symm

theorem step_is_admitted (query : Payload → ProtectedQuery)
    {before after : HintState} (step : HintStep before after) :
    AdmittedStep HintStep (fun state => query state.payload) before after :=
  ⟨step, (boundaryAccepted_iff _ _).mpr (step_preserves_boundary query step)⟩

theorem no_second_step {before after : HintState} (step : HintStep before after) :
    insertHint after = none := by
  have hint := (step_result step).2.1
  simp [insertHint, hint]

theorem hint_normal_after_step {before after : HintState} (step : HintStep before after) :
    NormalForm HintStep after := by
  intro next attempted
  unfold HintStep at attempted
  rw [no_second_step step] at attempted
  cases attempted

theorem hint_rank_decreases {before after : HintState} (step : HintStep before after) :
    after.fuel < before.fuel := by
  have count := (step_result step).2.2.1
  rw [← count]
  exact Nat.lt_succ_self _

theorem hint_deterministic {source left right : HintState}
    (first : HintStep source left) (second : HintStep source right) : left = right :=
  Option.some.inj (first.symm.trans second)

theorem hint_locally_confluent : LocallyConfluent HintStep := by
  intro source left right first second
  have same := hint_deterministic first second
  subst right
  exact ⟨left, .refl left, .refl left⟩

theorem hint_confluent : Confluent HintStep :=
  confluent_of_rank_and_local_joins HintState.fuel hint_rank_decreases hint_locally_confluent

theorem hint_sequences_preserve_boundary (query : Payload → ProtectedQuery)
    {before after : HintState} (steps : Steps HintStep before after) :
    query before.payload = query after.payload := by
  induction steps with
  | refl => rfl
  | next step _ ih => exact (step_preserves_boundary query step).trans ih

#print axioms read_render
#print axioms decode
#print axioms rendered_hint_differs
#print axioms decode_render
#print axioms decode_sound
#print axioms render_injective
#print axioms step_result
#print axioms step_exact_graph_delta
#print axioms step_preserves_source
#print axioms step_preserves_observations
#print axioms step_is_admitted
#print axioms hint_confluent
#print axioms hint_sequences_preserve_boundary

end Woland.ConcretePromptRewrite
