import ConcretePromptRewrite

/-!
# The selected protected hint is a concrete attributed-graph DPO step

AuthorityEffect: None. This proves both pushout universal properties for the
existing `woland_session_hint_v1` construction. Objects live in one fixed
immutable ordered source-document fibre; morphisms preserve incidence and exact
kind/attribute values. The ambient graph carriers are not resource bounded.
Runtime size limits are eligibility checks, not a claim of categorical closure.

The deletion complement is the unchanged host because L=K is the root. The
second pushout adds exactly one hint and its hint-to-root context edge. Its
mediator and uniqueness are constructed, not assumed from adhesivity. No
general DPO confluence, graph-changing cochain BQNF, hash injectivity, compiler
or Python/Lean serialization refinement is claimed. The runtime occurrence
readback checks this particular shape and retains every source document.
-/

namespace Woland.ConcreteHintDPO

structure Document where
  sourceId : String
  artifactId : String
  bytes : List UInt8
  coordinateProfile : String
  deriving DecidableEq

abbrev Store := List Document

structure Attributes where
  kind : String
  fields : List (String × String)
  deriving DecidableEq

/-- All graphs in a selected diagram retain this entire ordered document store. -/
structure Graph (documents : Store) where
  Vertex : Type
  Edge : Type
  source : Edge → Vertex
  target : Edge → Vertex
  vertexAttributes : Vertex → Attributes
  edgeAttributes : Edge → Attributes

structure Hom {documents : Store} (source target : Graph documents) where
  vertices : source.Vertex → target.Vertex
  edges : source.Edge → target.Edge
  source_eq : ∀ edge, target.source (edges edge) = vertices (source.source edge)
  target_eq : ∀ edge, target.target (edges edge) = vertices (source.target edge)
  vertex_eq : ∀ vertex, target.vertexAttributes (vertices vertex) = source.vertexAttributes vertex
  edge_eq : ∀ edge, target.edgeAttributes (edges edge) = source.edgeAttributes edge

namespace Hom

variable {documents : Store} {A B C : Graph documents}

theorem ext (first second : Hom A B) (vertices : first.vertices = second.vertices)
    (edges : first.edges = second.edges) : first = second := by
  cases first
  cases second
  cases vertices
  cases edges
  rfl

def identity (graph : Graph documents) : Hom graph graph :=
  ⟨id, id, fun _ => rfl, fun _ => rfl, fun _ => rfl, fun _ => rfl⟩

def comp (after : Hom B C) (before : Hom A B) : Hom A C where
  vertices vertex := after.vertices (before.vertices vertex)
  edges edge := after.edges (before.edges edge)
  source_eq edge := by rw [after.source_eq, before.source_eq]
  target_eq edge := by rw [after.target_eq, before.target_eq]
  vertex_eq vertex := (after.vertex_eq _).trans (before.vertex_eq vertex)
  edge_eq edge := (after.edge_eq _).trans (before.edge_eq edge)

theorem comp_identity (map : Hom A B) : map.comp (identity A) = map :=
  ext _ _ rfl rfl

theorem identity_comp (map : Hom A B) : (identity B).comp map = map :=
  ext _ _ rfl rfl

theorem comp_assoc {D : Graph documents} (third : Hom C D) (second : Hom B C) (first : Hom A B) :
    (third.comp second).comp first = third.comp (second.comp first) := ext _ _ rfl rfl

/-- Injectivity is about occurrences, not hashes or attribute equality. -/
def Injective (map : Hom A B) : Prop :=
  (∀ first second, map.vertices first = map.vertices second → first = second) ∧
  (∀ first second, map.edges first = map.edges second → first = second)

theorem injective_left_cancel (map : Hom A B) (injective : map.Injective)
    {X : Graph documents} (first second : Hom X A) (same : map.comp first = map.comp second) :
    first = second := by
  apply ext
  · funext vertex
    exact injective.1 _ _ (congrArg (fun value => value.vertices vertex) same)
  · funext edge
    exact injective.2 _ _ (congrArg (fun value => value.edges edge) same)

end Hom

/-- The exact selected square, stated by its commuting cocones and unique mediator. -/
def IsPushout {documents : Store} {K R G H : Graph documents}
    (right : Hom K R) (matched : Hom K G) (fromRule : Hom R H) (fromHost : Hom G H) : Prop :=
  fromRule.comp right = fromHost.comp matched ∧
  ∀ (target : Graph documents) (hostMap : Hom G target) (ruleMap : Hom R target),
    ruleMap.comp right = hostMap.comp matched →
    ∃ mediator : Hom H target,
      mediator.comp fromHost = hostMap ∧ mediator.comp fromRule = ruleMap ∧
      ∀ other : Hom H target, other.comp fromHost = hostMap →
        other.comp fromRule = ruleMap → other = mediator

def hintAttributes : Attributes :=
  ⟨"hint", [("rule_id", "woland_session_hint_v1"), ("text", ConcretePromptRewrite.hintText)]⟩

def contextAttributes : Attributes := ⟨"context", []⟩

inductive RuleVertex where
  | root | hint
  deriving DecidableEq

variable {documents : Store}

def interface (host : Graph documents) (root : host.Vertex) : Graph documents where
  Vertex := Unit
  Edge := Empty
  source edge := nomatch edge
  target edge := nomatch edge
  vertexAttributes _ := host.vertexAttributes root
  edgeAttributes edge := nomatch edge

def repairedRedex (host : Graph documents) (root : host.Vertex) : Graph documents where
  Vertex := RuleVertex
  Edge := Unit
  source _ := .hint
  target _ := .root
  vertexAttributes
    | .root => host.vertexAttributes root
    | .hint => hintAttributes
  edgeAttributes _ := contextAttributes

def attachHint (host : Graph documents) (root : host.Vertex) : Graph documents where
  Vertex := Sum host.Vertex Unit
  Edge := Sum host.Edge Unit
  source
    | .inl edge => .inl (host.source edge)
    | .inr _ => .inr ()
  target
    | .inl edge => .inl (host.target edge)
    | .inr _ => .inl root
  vertexAttributes
    | .inl vertex => host.vertexAttributes vertex
    | .inr _ => hintAttributes
  edgeAttributes
    | .inl edge => host.edgeAttributes edge
    | .inr _ => contextAttributes

def matchRoot (host : Graph documents) (root : host.Vertex) : Hom (interface host root) host where
  vertices _ := root
  edges edge := nomatch edge
  source_eq edge := nomatch edge
  target_eq edge := nomatch edge
  vertex_eq _ := rfl
  edge_eq edge := nomatch edge

def includeRoot (host : Graph documents) (root : host.Vertex) :
    Hom (interface host root) (repairedRedex host root) where
  vertices _ := .root
  edges edge := nomatch edge
  source_eq edge := nomatch edge
  target_eq edge := nomatch edge
  vertex_eq _ := rfl
  edge_eq edge := nomatch edge

def includeHost (host : Graph documents) (root : host.Vertex) : Hom host (attachHint host root) where
  vertices := Sum.inl
  edges := Sum.inl
  source_eq _ := rfl
  target_eq _ := rfl
  vertex_eq _ := rfl
  edge_eq _ := rfl

def includeRedex (host : Graph documents) (root : host.Vertex) :
    Hom (repairedRedex host root) (attachHint host root) where
  vertices
    | .root => .inl root
    | .hint => .inr ()
  edges _ := .inr ()
  source_eq _ := rfl
  target_eq _ := rfl
  vertex_eq vertex := by cases vertex <;> rfl
  edge_eq _ := rfl

theorem root_match_injective (host : Graph documents) (root : host.Vertex) :
    (matchRoot host root).Injective := by
  constructor
  · intro first second _
    cases first
    cases second
    rfl
  · intro edge
    cases edge

theorem root_inclusion_injective (host : Graph documents) (root : host.Vertex) :
    (includeRoot host root).Injective := by
  constructor
  · intro first second _
    cases first
    cases second
    rfl
  · intro edge
    cases edge

theorem host_inclusion_injective (host : Graph documents) (root : host.Vertex) :
    (includeHost host root).Injective :=
  ⟨fun _ _ equal => Sum.inl.inj equal, fun _ _ equal => Sum.inl.inj equal⟩

theorem selected_square_commutes (host : Graph documents) (root : host.Vertex) :
    (includeRedex host root).comp (includeRoot host root) =
      (includeHost host root).comp (matchRoot host root) := by
  apply Hom.ext
  · funext vertex
    cases vertex
    rfl
  · funext edge
    cases edge

def mediator (host : Graph documents) (root : host.Vertex) (target : Graph documents)
    (hostMap : Hom host target) (ruleMap : Hom (repairedRedex host root) target)
    (agree : ruleMap.comp (includeRoot host root) = hostMap.comp (matchRoot host root)) :
    Hom (attachHint host root) target where
  vertices
    | .inl vertex => hostMap.vertices vertex
    | .inr _ => ruleMap.vertices .hint
  edges
    | .inl edge => hostMap.edges edge
    | .inr _ => ruleMap.edges ()
  source_eq edge := by
    cases edge with
    | inl edge => exact hostMap.source_eq edge
    | inr _ => exact ruleMap.source_eq ()
  target_eq edge := by
    cases edge with
    | inl edge => exact hostMap.target_eq edge
    | inr _ =>
        have root_agreement := congrArg (fun map => map.vertices ()) agree
        exact (ruleMap.target_eq ()).trans root_agreement
  vertex_eq vertex := by
    cases vertex with
    | inl vertex => exact hostMap.vertex_eq vertex
    | inr _ => exact ruleMap.vertex_eq .hint
  edge_eq edge := by
    cases edge with
    | inl edge => exact hostMap.edge_eq edge
    | inr _ => exact ruleMap.edge_eq ()

theorem mediator_host (host : Graph documents) (root : host.Vertex) (target : Graph documents)
    (hostMap : Hom host target) (ruleMap : Hom (repairedRedex host root) target)
    (agree : ruleMap.comp (includeRoot host root) = hostMap.comp (matchRoot host root)) :
    (mediator host root target hostMap ruleMap agree).comp (includeHost host root) = hostMap :=
  Hom.ext _ _ rfl rfl

theorem mediator_rule (host : Graph documents) (root : host.Vertex) (target : Graph documents)
    (hostMap : Hom host target) (ruleMap : Hom (repairedRedex host root) target)
    (agree : ruleMap.comp (includeRoot host root) = hostMap.comp (matchRoot host root)) :
    (mediator host root target hostMap ruleMap agree).comp (includeRedex host root) = ruleMap := by
  apply Hom.ext
  · funext vertex
    cases vertex with
    | root => exact (congrArg (fun map => map.vertices ()) agree).symm
    | hint => rfl
  · funext edge
    cases edge
    rfl

theorem mediator_unique (host : Graph documents) (root : host.Vertex) (target : Graph documents)
    (hostMap : Hom host target) (ruleMap : Hom (repairedRedex host root) target)
    (agree : ruleMap.comp (includeRoot host root) = hostMap.comp (matchRoot host root))
    (other : Hom (attachHint host root) target)
    (onHost : other.comp (includeHost host root) = hostMap)
    (onRule : other.comp (includeRedex host root) = ruleMap) :
    other = mediator host root target hostMap ruleMap agree := by
  apply Hom.ext
  · funext vertex
    cases vertex with
    | inl vertex => exact congrArg (fun map => map.vertices vertex) onHost
    | inr _ => exact congrArg (fun map => map.vertices .hint) onRule
  · funext edge
    cases edge with
    | inl edge => exact congrArg (fun map => map.edges edge) onHost
    | inr _ => exact congrArg (fun map => map.edges ()) onRule

theorem hint_pushout (host : Graph documents) (root : host.Vertex) :
    IsPushout (includeRoot host root) (matchRoot host root)
      (includeRedex host root) (includeHost host root) := by
  refine ⟨selected_square_commutes host root, ?_⟩
  intro target hostMap ruleMap agree
  exact ⟨mediator host root target hostMap ruleMap agree,
    mediator_host host root target hostMap ruleMap agree,
    mediator_rule host root target hostMap ruleMap agree,
    mediator_unique host root target hostMap ruleMap agree⟩

theorem identity_complement_pushout (host : Graph documents) (root : host.Vertex) :
    IsPushout (Hom.identity (interface host root)) (matchRoot host root)
      (matchRoot host root) (Hom.identity host) := by
  constructor
  · rw [Hom.comp_identity, Hom.identity_comp]
  · intro target hostMap ruleMap agree
    refine ⟨hostMap, Hom.comp_identity _, ?_, ?_⟩
    · exact (Hom.comp_identity ruleMap).symm.trans agree |>.symm
    · intro other onHost _
      exact (Hom.comp_identity other).symm.trans onHost

/-- Both universal properties for this concrete monic-interface rule. -/
theorem selected_hint_dpo (host : Graph documents) (root : host.Vertex) :
    IsPushout (Hom.identity (interface host root)) (matchRoot host root)
      (matchRoot host root) (Hom.identity host) ∧
    IsPushout (includeRoot host root) (matchRoot host root)
      (includeRedex host root) (includeHost host root) :=
  ⟨identity_complement_pushout host root, hint_pushout host root⟩

/-- Full documents are retained as the fixed attribute environment, not reconstructed from hashes. -/
def sourceDocuments (_ : Graph documents) : Store := documents

theorem source_documents_preserved (host : Graph documents) (root : host.Vertex) :
    sourceDocuments (attachHint host root) = sourceDocuments host := rfl

theorem retained_attributes (host : Graph documents) (root : host.Vertex) :
    (∀ vertex, (attachHint host root).vertexAttributes (.inl vertex) = host.vertexAttributes vertex) ∧
    (∀ edge, (attachHint host root).edgeAttributes (.inl edge) = host.edgeAttributes edge) :=
  ⟨fun _ => rfl, fun _ => rfl⟩

/-- Actual fresh names need only be absent from the old occurrences. -/
def withFresh {Occurrence : Type} (name : Occurrence → String) (fresh : String) :
    Sum Occurrence Unit → String
  | .inl old => name old
  | .inr _ => fresh

theorem withFresh_injective {Occurrence : Type} (name : Occurrence → String) (fresh : String)
    (old_unique : ∀ first second, name first = name second → first = second)
    (not_old : ∀ old, name old ≠ fresh) :
    ∀ first second, withFresh name fresh first = withFresh name fresh second → first = second := by
  intro first second equal
  cases first with
  | inl first =>
      cases second with
      | inl second => exact congrArg Sum.inl (old_unique first second equal)
      | inr _ => exact False.elim (not_old first equal)
  | inr first =>
      cases second with
      | inl second => exact False.elim (not_old second equal.symm)
      | inr second => cases first; cases second; rfl

theorem withFresh_coverage {Occurrence : Type} (name : Occurrence → String) (fresh value : String) :
    (∃ occurrence, withFresh name fresh occurrence = value) ↔
      (∃ old, name old = value) ∨ fresh = value := by
  constructor
  · rintro ⟨occurrence, equal⟩
    cases occurrence with
    | inl old => exact Or.inl ⟨old, equal⟩
    | inr _ => exact Or.inr equal
  · rintro (⟨old, equal⟩ | equal)
    · exact ⟨.inl old, equal⟩
    · exact ⟨.inr (), equal⟩

#print axioms Hom.ext
#print axioms Hom.injective_left_cancel
#print axioms root_match_injective
#print axioms root_inclusion_injective
#print axioms host_inclusion_injective
#print axioms mediator
#print axioms mediator_unique
#print axioms identity_complement_pushout
#print axioms hint_pushout
#print axioms selected_hint_dpo
#print axioms source_documents_preserved
#print axioms retained_attributes
#print axioms withFresh_injective
#print axioms withFresh_coverage

end Woland.ConcreteHintDPO
