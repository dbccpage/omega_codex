/-!
# Complete typed observer descent and no-recovery criteria

Every declared finite sort map with a constructive section is onto. A tuple
of sectioned sort maps has a tuple section. Total reports, predicate truth, and partial
operations descend uniquely exactly when their target-valued semantics are
constant on the input fibers. For partial operations the target semantics is
`Option.map`: undefinedness is preserved and reflected, and defined outputs
must lie in the same target fiber. Indexed families cover all declared
operation symbols, with different input/output types and arbitrary arities.

These are complete algebraic criteria on an actual typed domain, not a
claim that any forgotten layer or unrecovered source vocabulary is known.
Missing-layer no-recovery requires two admitted completions with identical
visible data and distinct missing semantics; this hypothesis is explicit.
-/

namespace WitnessedDifference.ObserverAdapterCompleteness

universe u v w z

def FiberConstant {A : Type u} {B : Type v} {T : Type w}
    (q : A → B) (f : A → T) : Prop :=
  ∀ x y, q x = q y → f x = f y

/-- Complete constructive criterion, including uniqueness, for a sectioned presentation. -/
theorem unique_factorization_iff
    {A : Type u} {B : Type v} {T : Type w}
    (q : A → B) (f : A → T) (sec : B → A) (hsec : ∀ b, q (sec b) = b) :
    (∃ g : B → T, (∀ a, g (q a) = f a) ∧
      (∀ k : B → T, (∀ a, k (q a) = f a) → k = g)) ↔ FiberConstant q f := by
  constructor
  · intro h
    obtain ⟨g, hg, _⟩ := h
    intro x y hxy
    calc
      f x = g (q x) := (hg x).symm
      _ = g (q y) := congrArg g hxy
      _ = f y := hg y
  · intro hfiber
    let g : B → T := fun b => f (sec b)
    have hg : ∀ a, g (q a) = f a := by
      intro a
      exact hfiber (sec (q a)) a (hsec (q a))
    refine ⟨g, hg, ?_⟩
    intro k hk
    funext b
    have hb := hsec b
    calc
      k b = k (q (sec b)) := congrArg k hb.symm
      _ = f (sec b) := hk (sec b)
      _ = g b := rfl

/-- Sectioned maps on declared sorts induce a surjective map on operation
input tuples. This also handles nullary operations via an empty index type. -/
theorem tuple_map_onto
    {Index : Type u} {Source Target : Index → Type v}
    (q : (i : Index) → Source i → Target i)
    (sec : (i : Index) → Target i → Source i)
    (hsec : ∀ i y, q i (sec i y) = y) :
    ∀ values : (i : Index) → Target i,
      ∃ inputs : (i : Index) → Source i, (fun i => q i (inputs i)) = values := by
  intro values
  refine ⟨fun i => sec i (values i), ?_⟩
  funext i
  exact hsec i (values i)

def PartialFiberMatch {S : Type u} {T : Type v}
    (q : S → T) (left right : Option S) : Prop :=
  match left, right with
  | none, none => True
  | some x, some y => q x = q y
  | _, _ => False

/-- Equality after output adaptation is exactly definedness agreement plus
equality of the adapted defined outputs. -/
theorem mapped_partial_eq_iff
    {S : Type u} {T : Type v} (q : S → T) (left right : Option S) :
    Option.map q left = Option.map q right ↔ PartialFiberMatch q left right := by
  cases left <;> cases right <;> simp [PartialFiberMatch]

theorem adapted_undefined_iff
    {S : Type u} {T : Type v} (q : S → T) (value : Option S) :
    Option.map q value = none ↔ value = none := by
  cases value <;> simp

/-- Necessary and sufficient partial-operation adapter criterion. No source
defined output can be hidden as undefined and no new defined output invented. -/
theorem unique_partial_operation_adapter_iff
    {A : Type u} {B : Type v} {S : Type w} {T : Type z}
    (qin : A → B) (qout : S → T) (operation : A → Option S)
    (sec : B → A) (hsec : ∀ b, qin (sec b) = b) :
    (∃ adapted : B → Option T,
      (∀ a, adapted (qin a) = Option.map qout (operation a)) ∧
      (∀ other : B → Option T,
        (∀ a, other (qin a) = Option.map qout (operation a)) → other = adapted)) ↔
      ∀ a b, qin a = qin b → PartialFiberMatch qout (operation a) (operation b) := by
  rw [unique_factorization_iff qin (fun a => Option.map qout (operation a)) sec hsec]
  constructor
  · intro h a b hab
    exact (mapped_partial_eq_iff qout (operation a) (operation b)).mp (h a b hab)
  · intro h a b hab
    exact (mapped_partial_eq_iff qout (operation a) (operation b)).mpr (h a b hab)

/-- The commuting partial adapter preserves and reflects definedness. -/
theorem partial_adapter_reflects_definedness
    {A : Type u} {B : Type v} {S : Type w} {T : Type z}
    (qin : A → B) (qout : S → T) (operation : A → Option S)
    (adapted : B → Option T)
    (hcommutes : ∀ a, adapted (qin a) = Option.map qout (operation a)) (a : A) :
    adapted (qin a) = none ↔ operation a = none := by
  rw [hcommutes a]
  exact adapted_undefined_iff qout (operation a)

/-- All typed operation symbols descend exactly when each one's input-fiber
test succeeds. Domains and codomains may vary with the operation symbol. -/
theorem partial_operation_family_adapter_iff
    {Op : Type u} {A B : Op → Type v} {S T : Op → Type w}
    (qin : (op : Op) → A op → B op) (qout : (op : Op) → S op → T op)
    (operation : (op : Op) → A op → Option (S op))
    (sec : (op : Op) → B op → A op)
    (hsec : ∀ op b, qin op (sec op b) = b) :
    (∃ adapted : (op : Op) → B op → Option (T op),
      ∀ op a, adapted op (qin op a) = Option.map (qout op) (operation op a)) ↔
      ∀ op a b, qin op a = qin op b →
        PartialFiberMatch (qout op) (operation op a) (operation op b) := by
  constructor
  · intro h
    obtain ⟨adapted, hcommutes⟩ := h
    intro op a b hab
    apply (mapped_partial_eq_iff (qout op) (operation op a) (operation op b)).mp
    calc
      Option.map (qout op) (operation op a) = adapted op (qin op a) := (hcommutes op a).symm
      _ = adapted op (qin op b) := congrArg (adapted op) hab
      _ = Option.map (qout op) (operation op b) := hcommutes op b
  · intro hfiber
    refine ⟨fun op b => Option.map (qout op) (operation op (sec op b)), ?_⟩
    intro op a
    exact (mapped_partial_eq_iff (qout op) (operation op (sec op (qin op a))) (operation op a)).mpr
      (hfiber op (sec op (qin op a)) a (hsec op (qin op a)))

theorem partial_operation_family_adapter_unique
    {Op : Type u} {A B : Op → Type v} {S T : Op → Type w}
    (qin : (op : Op) → A op → B op) (qout : (op : Op) → S op → T op)
    (operation : (op : Op) → A op → Option (S op))
    (honto : ∀ op b, ∃ a, qin op a = b)
    (left right : (op : Op) → B op → Option (T op))
    (hleft : ∀ op a, left op (qin op a) = Option.map (qout op) (operation op a))
    (hright : ∀ op a, right op (qin op a) = Option.map (qout op) (operation op a)) :
    left = right := by
  funext op b
  obtain ⟨a, ha⟩ := honto op b
  subst b
  exact (hleft op a).trans (hright op a).symm

/-- A declared predicate descends with both truth preservation and reflection
exactly when its truth value is constant on presentation fibers. -/
theorem unique_predicate_adapter_iff
    {A : Type u} {B : Type v} (q : A → B) (predicate : A → Bool)
    (sec : B → A) (hsec : ∀ b, q (sec b) = b) :
    (∃ adapted : B → Bool, (∀ a, adapted (q a) = predicate a) ∧
      (∀ other : B → Bool, (∀ a, other (q a) = predicate a) → other = adapted)) ↔
      FiberConstant q predicate := unique_factorization_iff q predicate sec hsec

/-- Simultaneous descent of every declared total report or truth-valued
relation symbol. The index set need not be finite for this algebraic theorem. -/
theorem total_semantic_family_adapter_iff
    {Symbol : Type u} {A B : Symbol → Type v} {T : Symbol → Type w}
    (q : (symbol : Symbol) → A symbol → B symbol)
    (semantics : (symbol : Symbol) → A symbol → T symbol)
    (sec : (symbol : Symbol) → B symbol → A symbol)
    (hsec : ∀ symbol b, q symbol (sec symbol b) = b) :
    (∃ adapted : (symbol : Symbol) → B symbol → T symbol,
      ∀ symbol a, adapted symbol (q symbol a) = semantics symbol a) ↔
      ∀ symbol, FiberConstant (q symbol) (semantics symbol) := by
  constructor
  · intro h
    obtain ⟨adapted, hcommutes⟩ := h
    intro symbol a b hab
    exact (hcommutes symbol a).symm.trans
      ((congrArg (adapted symbol) hab).trans (hcommutes symbol b))
  · intro hfiber
    refine ⟨fun symbol b => semantics symbol (sec symbol b), ?_⟩
    intro symbol a
    exact hfiber symbol (sec symbol (q symbol a)) a (hsec symbol (q symbol a))

theorem total_semantic_family_adapter_unique
    {Symbol : Type u} {A B : Symbol → Type v} {T : Symbol → Type w}
    (q : (symbol : Symbol) → A symbol → B symbol)
    (semantics : (symbol : Symbol) → A symbol → T symbol)
    (honto : ∀ symbol b, ∃ a, q symbol a = b)
    (left right : (symbol : Symbol) → B symbol → T symbol)
    (hleft : ∀ symbol a, left symbol (q symbol a) = semantics symbol a)
    (hright : ∀ symbol a, right symbol (q symbol a) = semantics symbol a) :
    left = right := by
  funext symbol b
  obtain ⟨a, ha⟩ := honto symbol b
  subst b
  exact (hleft symbol a).trans (hright symbol a).symm

/-- Complete source recovery is possible under a section witness exactly when a visible
projection is injective. Semantic observations can require less than identity. -/
theorem complete_recovery_iff_injective
    {Complete : Type u} {Visible : Type v}
    (forget : Complete → Visible) (sec : Visible → Complete)
    (hsec : ∀ v, forget (sec v) = v) :
    (∃ recover : Visible → Complete, (∀ c, recover (forget c) = c) ∧
      (∀ other : Visible → Complete, (∀ c, other (forget c) = c) → other = recover)) ↔
      ∀ c d, forget c = forget d → c = d := by
  exact unique_factorization_iff forget id sec hsec

/-- The joint report is the coarsest completion that retains both declared
semantic fields: its kernel is exactly their kernel intersection. -/
theorem joint_report_kernel_iff
    {A : Type u} {P : Type v} {L : Type w}
    (presentation : A → P) (layer : A → L) (x y : A) :
    (presentation x, layer x) = (presentation y, layer y) ↔
      presentation x = presentation y ∧ layer x = layer y := by
  constructor
  · intro h
    exact ⟨congrArg Prod.fst h, congrArg Prod.snd h⟩
  · intro h
    exact Prod.ext h.1 h.2

/-- Any faithful completion retaining both fields must separate every pair
the joint report separates. This is a necessary universal minimality law. -/
theorem faithful_completion_retains_joint_report
    {A : Type u} {P : Type v} {L : Type w} {C : Type z}
    (presentation : A → P) (layer : A → L) (completion : A → C)
    (recoverPresentation : C → P) (recoverLayer : C → L)
    (hp : ∀ x, recoverPresentation (completion x) = presentation x)
    (hl : ∀ x, recoverLayer (completion x) = layer x) :
    FiberConstant completion (fun x => (presentation x, layer x)) := by
  intro x y hxy
  apply (joint_report_kernel_iff presentation layer x y).mpr
  constructor
  · exact (hp x).symm.trans ((congrArg recoverPresentation hxy).trans (hp y))
  · exact (hl x).symm.trans ((congrArg recoverLayer hxy).trans (hl y))

/-- Full necessary-and-sufficient faithful completion criterion under a section witness:
both declared semantic fields are recoverable exactly when the completion's
fibers respect their joint report. -/
theorem faithful_completion_iff_joint_fiber_constancy
    {A : Type u} {P : Type v} {L : Type w} {C : Type z}
    (presentation : A → P) (layer : A → L) (completion : A → C)
    (sec : C → A) (hsec : ∀ c, completion (sec c) = c) :
    (∃ recoverPresentation : C → P, ∃ recoverLayer : C → L,
      (∀ x, recoverPresentation (completion x) = presentation x) ∧
      (∀ x, recoverLayer (completion x) = layer x)) ↔
      FiberConstant completion (fun x => (presentation x, layer x)) := by
  constructor
  · intro h
    obtain ⟨rp, rl, hp, hl⟩ := h
    exact faithful_completion_retains_joint_report presentation layer completion rp rl hp hl
  · intro hfiber
    obtain ⟨joint, hjoint, _⟩ :=
      (unique_factorization_iff completion (fun x => (presentation x, layer x)) sec hsec).mpr hfiber
    exact ⟨fun c => (joint c).1, fun c => (joint c).2,
      fun x => congrArg Prod.fst (hjoint x), fun x => congrArg Prod.snd (hjoint x)⟩

/-- Use the actual joint image, rather than inventing unused presentation/layer
pairs. This removes the surjectivity ambiguity of a full product codomain. -/
def JointImage {A : Type u} {P : Type v} {L : Type w}
    (presentation : A → P) (layer : A → L) :=
  { report : P × L // ∃ x : A, (presentation x, layer x) = report }

def jointCompletion {A : Type u} {P : Type v} {L : Type w}
    (presentation : A → P) (layer : A → L) (x : A) : JointImage presentation layer :=
  ⟨(presentation x, layer x), x, rfl⟩

theorem joint_completion_onto {A : Type u} {P : Type v} {L : Type w}
    (presentation : A → P) (layer : A → L) :
    ∀ report : JointImage presentation layer, ∃ x, jointCompletion presentation layer x = report := by
  intro report
  obtain ⟨x, hx⟩ := report.property
  refine ⟨x, ?_⟩
  exact Subtype.ext hx

theorem joint_completion_recovers_both_fields
    {A : Type u} {P : Type v} {L : Type w}
    (presentation : A → P) (layer : A → L) (x : A) :
    (jointCompletion presentation layer x).val.1 = presentation x ∧
      (jointCompletion presentation layer x).val.2 = layer x := ⟨rfl, rfl⟩

/-- Every sectioned faithful completion has a unique comparison to the actual
joint-image completion. -/
theorem unique_joint_completion_comparison_iff
    {A : Type u} {P : Type v} {L : Type w} {C : Type z}
    (presentation : A → P) (layer : A → L) (completion : A → C)
    (sec : C → A) (hsec : ∀ c, completion (sec c) = c) :
    (∃ compare : C → JointImage presentation layer,
      (∀ a, compare (completion a) = jointCompletion presentation layer a) ∧
      (∀ other : C → JointImage presentation layer,
        (∀ a, other (completion a) = jointCompletion presentation layer a) → other = compare)) ↔
      FiberConstant completion (fun x => (presentation x, layer x)) := by
  rw [unique_factorization_iff completion (jointCompletion presentation layer) sec hsec]
  constructor
  · intro h x y hxy
    exact congrArg Subtype.val (h x y hxy)
  · intro h x y hxy
    exact Subtype.ext (h x y hxy)

/-- No recovery can infer an omitted field when two admitted completions
agree visibly but differ in that field. Constraints on completions are explicit. -/
theorem indistinguishable_admitted_completions_refute_recovery
    {Complete : Type u} {Visible : Type v} {Layer : Type w}
    (forget : Complete → Visible) (semantics : Complete → Layer)
    (admitted : Complete → Prop) (left right : Complete)
    (hleft : admitted left) (hright : admitted right)
    (hvisible : forget left = forget right) (hdifferent : semantics left ≠ semantics right) :
    ¬ ∃ recover : Visible → Layer, ∀ c, admitted c → recover (forget c) = semantics c := by
  intro h
  obtain ⟨recover, hrecovers⟩ := h
  apply hdifferent
  exact (hrecovers left hleft).symm.trans ((congrArg recover hvisible).trans (hrecovers right hright))

/-- Each genuinely free missing field is independently unrecoverable even
when every other field is retained, without assuming any particular vocabulary. -/
theorem missing_product_field_cannot_be_recovered
    {Visible : Type u} {Layer : Type v}
    (visible : Visible) (left right : Layer) (hdifferent : left ≠ right) :
    ¬ ∃ recover : Visible → Layer, ∀ packet : Visible × Layer, recover packet.1 = packet.2 := by
  intro h
  obtain ⟨recover, hrecovers⟩ := h
  exact hdifferent ((hrecovers (visible, left)).symm.trans (hrecovers (visible, right)))

/-- Dropping definedness is independently fatal even with a singleton
output sort and hence no possible output-fiber mismatch. -/
theorem partial_definedness_countermodel :
    ¬ ∃ adapted : Unit → Option Unit,
      ∀ b : Bool, adapted () = (if b then some () else none) := by
  intro h
  obtain ⟨adapted, hadapted⟩ := h
  have hnone := hadapted false
  have hsome := hadapted true
  have impossible : (none : Option Unit) = some () := hnone.symm.trans hsome
  cases impossible

/-- Equal definedness does not compensate for unequal adapted outputs. -/
theorem partial_output_fiber_countermodel :
    ¬ ∃ adapted : Unit → Option Bool, ∀ b : Bool, adapted () = some b := by
  intro h
  obtain ⟨adapted, hadapted⟩ := h
  have impossible : (some false : Option Bool) = some true :=
    (hadapted false).symm.trans (hadapted true)
  cases impossible

/-- Predicate reflection is a separate obligation from operation descent. -/
theorem predicate_truth_countermodel :
    ¬ ∃ adapted : Unit → Bool, ∀ b : Bool, adapted () = b := by
  intro h
  obtain ⟨adapted, hadapted⟩ := h
  have impossible : false = true := (hadapted false).symm.trans (hadapted true)
  cases impossible

/-- A target outside the presentation image permits distinct extensions,
even when the factorization equation is satisfied on every source input. -/
theorem missing_surjectivity_refutes_uniqueness :
    ∃ q : Unit → Bool, ∃ report : Unit → Bool, ∃ left right : Bool → Bool,
      left ≠ right ∧ (∀ x, left (q x) = report x) ∧
      (∀ x, right (q x) = report x) := by
  refine ⟨fun _ => false, fun _ => false, fun _ => false, id, ?_, ?_, ?_⟩
  · intro hequal
    have impossible : false = true := congrArg (fun f => f true) hequal
    cases impossible
  · intro _
    rfl
  · intro _
    rfl

/-- Actual finite total update functions provide two different missing
memory choices while the visible packet can be exactly the same singleton. -/
theorem missing_memory_update_countermodel :
    ¬ ∃ recover : Unit → (Unit → Bool → Bool),
      ∀ packet : Unit × (Unit → Bool → Bool), recover packet.1 = packet.2 := by
  apply missing_product_field_cannot_be_recovered ()
    (fun _ b => b) (fun _ b => !b)
  intro hequal
  have impossible : false = true := congrArg (fun update => update () false) hequal
  cases impossible

/-- Terminalizer choices are not inferred from a retained presentation. -/
theorem missing_terminalizer_countermodel :
    ¬ ∃ recover : Unit → (Bool → Bool),
      ∀ packet : Unit × (Bool → Bool), recover packet.1 = packet.2 := by
  apply missing_product_field_cannot_be_recovered ()
    (fun _ => false) (fun _ => true)
  intro hequal
  have impossible : false = true := congrArg (fun terminalizer => terminalizer false) hequal
  cases impossible

inductive DeclaredAction where
  | store | emit

/-- A status-to-action policy is another independently missing function,
not a status certificate or an authority field. -/
theorem missing_policy_countermodel :
    ¬ ∃ recover : Unit → (Bool → DeclaredAction),
      ∀ packet : Unit × (Bool → DeclaredAction), recover packet.1 = packet.2 := by
  apply missing_product_field_cannot_be_recovered ()
    (fun _ => .store) (fun _ => .emit)
  intro hequal
  have impossible : DeclaredAction.store = DeclaredAction.emit :=
    congrArg (fun policy => policy false) hequal
  cases impossible

end WitnessedDifference.ObserverAdapterCompleteness
