import AdmissionReplay
import Lean

open Lean OmegaCodex.MinimalSeparation OmegaCodex.AdmissionReplay
open WitnessedDifference.GenerativeHistoryCompression

def stateJson (s : Regime4) : Json := Json.mkObj [
  ("data", toJson s.data), ("forms", toJson s.forms),
  ("instances", toJson (s.insts.map fun (f, args) => (f, args))),
  ("requirements", toJson s.reqs)]

def itemJson : Item4 → Json
  | .newDatum => Json.mkObj [("kind", toJson "datum")]
  | .newForm k => Json.mkObj [("kind", toJson "form"), ("arity", toJson k)]
  | .newInst f args => Json.mkObj [("kind", toJson "instance"), ("form", toJson f), ("args", toJson args)]

def resultJson : Option Regime4 → Json
  | none => Json.null
  | some s => stateJson s

def separatedJson (s : Regime4) : Json := toJson <|
  (List.range s.data).flatMap fun x =>
    (List.range s.data).filterMap fun y =>
      if x < y && !(collapsed4Bool s x y) then some (x, y) else none

/-- Attempt log stops at first refusal, retaining the pre-attempt state. -/
def attemptLog (s : Regime4) : List Item4 → List Json
  | [] => []
  | e :: es =>
    let outcome := applyItem4 s e
    let row := Json.mkObj [("event", itemJson e), ("before", stateJson s),
      ("result", resultJson outcome), ("accepted", toJson outcome.isSome)]
    row :: (match outcome with | none => [] | some next => attemptLog next es)

def runJson (name : String) (s : Regime4) (es : List Item4) : Json :=
  let out := applyDelta4 s es
  Json.mkObj [("name", toJson name), ("initial", stateJson s),
    ("events", toJson (es.map itemJson)), ("result", resultJson out),
    ("wdp_replay", resultJson (replay applyItem4 es s)),
    ("rooted_replay", resultJson (replay presentedStep (.supply "<>" :: es.map PresentedEvent.move) s)),
    ("proposed_item_cost", toJson (eventCost (fun _ => 1) es)),
    ("proposed_arity_cost", toJson (eventCost arityPrice es)),
    ("attempts", toJson (attemptLog s es)),
    ("separated", match out with | none => Json.null | some next => separatedJson next)]

def prefixJson (reading : Reading) : Json := Json.mkObj [
  ("reading", toJson (match reading with | .L => "L" | .F => "F")),
  ("literal_supply", toJson "<>"),
  ("after_supply", resultJson (presentedStep emptyRegime (.supply "<>"))),
  ("data_trace", runJson "datum admissions" emptyRegime (dataPrefix reading)),
  ("supplied_requirement", toJson (match reading with | .L => (0, 1) | .F => (1, 2))),
  ("after_requirement", stateJson (match reading with | .L => R2L4 | .F => R2F4)),
  ("requirement_is_Item4_event", toJson false)]

def fixtures : List Json := [
  runJson "L-left" R2L4 (unaryResponse 0),
  runJson "L-right" R2L4 (unaryResponse 1),
  runJson "F-left" R2F4 (unaryResponse 1),
  runJson "F-right" R2F4 (unaryResponse 2),
  runJson "reversed" R2L4 [.newInst 0 [0], .newForm 1],
  runJson "zero-arity" R2L4 [.newForm 0],
  runJson "wrong-arity" U0_4 [.newInst 0 []],
  runJson "outside-carrier" U0_4 [.newInst 0 [2]],
  runJson "undeclared-form" U0_4 [.newInst 1 [0]],
  runJson "duplicate" R2L4 (unaryResponse 0 ++ [.newInst 0 [0]]),
  runJson "accepted-idle" U0_4 [.newInst 0 [0]],
  runJson "recollapse" R3_round1 [.newInst 0 [2]],
  runJson "fresh-preserves" R3_round1 (freshUnaryDelta4 R3_round1 1)]

def alphabet : List Item4 := [.newDatum, .newForm 0, .newForm 1, .newForm 2,
  .newInst 0 [], .newInst 0 [0], .newInst 0 [2], .newInst 1 [0]]

def boundedCases : List Json :=
  let words := [[]] ++ alphabet.map (fun x => [x]) ++
    alphabet.flatMap (fun x => alphabet.map fun y => [x, y])
  [emptyRegime, R2L4, R2F4, U0_4, R3_round1].flatMap fun s =>
    words.map (runJson "bounded" s)

def main : IO Unit := do
  IO.println (Json.mkObj [("prefixes", toJson [prefixJson .L, prefixJson .F]),
    ("fixtures", toJson fixtures), ("bounded", toJson boundedCases)]).compress
