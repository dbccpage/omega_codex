import TorsorAndOperations
import MinimalSeparation
import RetentionAndRefusal

/-!
# Constitutional initiality, no-outside dichotomy, interpreter diagonal, and acyclicity (Slice 5)

Reconstructs the 6-guard constitutional interpreter, verified self-description,
64-member behavioral uniqueness and guard-independence census (`Constitution.lean`,
`Initiality.lean`), the conservative panel retract and effectual-outside dichotomy
(`NoOutside.lean`), the diagonal non-exhaustion theorem for total evaluators,
finite code-list tower persistence, and typed-refusal extension
(`InterpreterBoundary.lean`), and strict-measure acyclicity and no-return
(`WDP-CH06-P01`, Genesis section 8).
-/
set_option autoImplicit false

namespace OmegaCodex.InternalMetatheory

open OmegaCodex.PrimitiveDifference
open OmegaCodex.TorsorAndOperations
open OmegaCodex.MinimalSeparation
open OmegaCodex.RetentionAndRefusal

universe u

/-! ## Section 1: Represented kernel and 6-guard constitutional initiality -/

abbrev View := List Nat
abbrev Req := Nat × Nat

structure World where
  data        : List Nat
  views       : List View
  reqs        : List Req
  refusals    : List Req
  budget      : Nat
  augLicensed : Bool
  notes       : List Nat
deriving Repr, DecidableEq

def genesis : World := ⟨[], [], [], [], 0, true, []⟩

def sepB (c : View) (i j : Nat) : Bool :=
  (decide (i ∈ c)) != (decide (j ∈ c))

def satB (w : World) (r : Req) : Bool :=
  w.views.any (fun c => sepB c r.1 r.2)

def violB (w : World) (r : Req) : Bool :=
  (decide (r ∈ w.reqs)) && !satB w r

def quiescentB (w : World) : Bool :=
  w.reqs.all (fun r => satB w r)

def markApply (w : World) (v : View) (p : Nat) : World :=
  { w with views := w.views.map (fun c => if c = v then p :: c else c) }

def preservesB (w w' : World) : Bool :=
  w.reqs.all (fun r => !satB w r || satB w' r)

def dischargesSomeB (w w' : World) : Bool :=
  w.reqs.any (fun r => violB w r && satB w' r)

def markOkB (w : World) (v : View) (p : Nat) : Bool :=
  (decide (v ∈ w.views)) && (decide (p < w.data.length))
    && !(decide (p ∈ v))
    && dischargesSomeB w (markApply w v p)
    && preservesB w (markApply w v p)

def augApply (w : World) (c : View) : World :=
  { w with views := w.views ++ [c] }

def increaseB (w : World) (c : View) : Bool :=
  (List.range w.data.length).any fun i =>
    (List.range w.data.length).any fun j =>
      (i != j) && sepB c i j && !satB w (i, j)

def augOkB (w : World) (c : View) : Bool :=
  c.all (fun p => decide (p < w.data.length))
    && !(decide (c ∈ w.views))
    && increaseB w c

def responseMenu (w : World) : List (View × Nat) :=
  w.views.flatMap fun v =>
    (List.range w.data.length).map fun p => (v, p)

def repairsB (w : World) (m : View × Nat) (r : Req) : Bool :=
  markOkB w m.1 m.2 && satB (markApply w m.1 m.2) r

def obstructedB (w : World) (r : Req) : Bool :=
  violB w r && (responseMenu w).all (fun m => !repairsB w m r)

inductive Event where
  | admitTok      (tok : Nat)
  | require       (i j : Nat)
  | mark          (v : View) (p : Nat)
  | addView       (c : View)
  | refuse        (i j : Nat)
  | note          (n : Nat)
  | setBudget     (n : Nat)
  | setAugLicense (b : Bool)
deriving Repr, DecidableEq

def reqOkB (w : World) (i j : Nat) : Bool :=
  (i != j) && (decide (i < w.data.length))
    && (decide (j < w.data.length)) && !(decide ((i, j) ∈ w.reqs))

def step (w : World) : Event → World
  | .admitTok t =>
      if t ∈ w.data then w else { w with data := w.data ++ [t] }
  | .require i j =>
      if reqOkB w i j then { w with reqs := w.reqs ++ [(i, j)] } else w
  | .mark v p =>
      if markOkB w v p && decide (0 < w.budget) then
        { markApply w v p with budget := w.budget - 1 }
      else w
  | .addView c =>
      if augOkB w c && w.augLicensed && decide (0 < w.budget) then
        { augApply w c with budget := w.budget - 1 }
      else w
  | .refuse i j =>
      if obstructedB w (i, j) && !(decide ((i, j) ∈ w.refusals)) then
        { w with refusals := w.refusals ++ [(i, j)] }
      else w
  | .note n => { w with notes := w.notes ++ [n] }
  | .setBudget n => { w with budget := n }
  | .setAugLicense b => { w with augLicensed := b }

def replay (h : List Event) (w : World) : World := h.foldl step w

structure Supp where
  data        : List Nat
  views       : List View
  reqs        : List Req
  refusals    : List Req
  budget      : Nat
  augLicensed : Bool
deriving Repr, DecidableEq

def supp (w : World) : Supp :=
  ⟨w.data, w.views, w.reqs, w.refusals, w.budget, w.augLicensed⟩

theorem support_determines (w w' : World) (h : supp w = supp w')
    (e : Event) : supp (step w e) = supp (step w' e) := by
  cases w with
  | mk d v r f b a nt =>
    cases w' with
    | mk d' v' r' f' b' a' nt' =>
      simp only [supp, Supp.mk.injEq] at h
      obtain ⟨h1, h2, h3, h4, h5, h6⟩ := h
      subst h1; subst h2; subst h3; subst h4; subst h5; subst h6
      cases e with
      | admitTok t =>
          simp only [step]
          split <;> rfl
      | require i j =>
          have hc : reqOkB (World.mk d v r f b a nt) i j
              = reqOkB (World.mk d v r f b a nt') i j := rfl
          simp only [step]
          rw [hc]
          split <;> rfl
      | mark vv p =>
          have hc : (markOkB (World.mk d v r f b a nt) vv p
                && decide (0 < (World.mk d v r f b a nt).budget))
              = (markOkB (World.mk d v r f b a nt') vv p
                && decide (0 < (World.mk d v r f b a nt').budget)) := rfl
          simp only [step]
          rw [hc]
          split <;> rfl
      | addView c =>
          have hc : (augOkB (World.mk d v r f b a nt) c
                && (World.mk d v r f b a nt).augLicensed
                && decide (0 < (World.mk d v r f b a nt).budget))
              = (augOkB (World.mk d v r f b a nt') c
                && (World.mk d v r f b a nt').augLicensed
                && decide (0 < (World.mk d v r f b a nt').budget)) := rfl
          simp only [step]
          rw [hc]
          split <;> rfl
      | refuse i j =>
          have hc : (obstructedB (World.mk d v r f b a nt) (i, j)
                && !(decide ((i, j) ∈ (World.mk d v r f b a nt).refusals)))
              = (obstructedB (World.mk d v r f b a nt') (i, j)
                && !(decide ((i, j) ∈ (World.mk d v r f b a nt').refusals))) := rfl
          simp only [step]
          rw [hc]
          split <;> rfl
      | note _ => rfl
      | setBudget _ => rfl
      | setAugLicense _ => rfl

theorem support_determines_replay (h : List Event) {w w' : World}
    (hs : supp w = supp w') :
    supp (replay h w) = supp (replay h w') := by
  induction h generalizing w w' with
  | nil => exact hs
  | cons e rest ih =>
      exact ih (support_determines w w' hs e)

structure ConstitutionDesc where
  dedupAdmit   : Bool
  guardRequire : Bool
  guardAccept  : Bool
  gateBudget   : Bool
  gateLicense  : Bool
  certRefusal  : Bool
deriving Repr, DecidableEq

def kernelDesc : ConstitutionDesc := ⟨true, true, true, true, true, true⟩

def interpStep (d : ConstitutionDesc) (w : World) : Event → World
  | .admitTok t =>
      if d.dedupAdmit && decide (t ∈ w.data) then w
      else { w with data := w.data ++ [t] }
  | .require i j =>
      if !d.guardRequire || reqOkB w i j then
        { w with reqs := w.reqs ++ [(i, j)] }
      else w
  | .mark v p =>
      if (!d.guardAccept || markOkB w v p)
          && (!d.gateBudget || decide (0 < w.budget)) then
        { markApply w v p with budget := w.budget - 1 }
      else w
  | .addView c =>
      if (!d.guardAccept || augOkB w c)
          && (!d.gateLicense || w.augLicensed)
          && (!d.gateBudget || decide (0 < w.budget)) then
        { augApply w c with budget := w.budget - 1 }
      else w
  | .refuse i j =>
      if (!d.certRefusal || obstructedB w (i, j))
          && !(decide ((i, j) ∈ w.refusals)) then
        { w with refusals := w.refusals ++ [(i, j)] }
      else w
  | .note n => { w with notes := w.notes ++ [n] }
  | .setBudget n => { w with budget := n }
  | .setAugLicense b => { w with augLicensed := b }

/-- `Constitution.lean:348`: the kernel's own description, executed by the
family interpreter `interpStep`, equals the sealed `step` function. -/
theorem interp_describe (w : World) (e : Event) :
    interpStep kernelDesc w e = step w e := by
  cases e with
  | admitTok t =>
      simp only [interpStep, step, kernelDesc, Bool.true_and]
      by_cases hmem : t ∈ w.data
      · rw [if_pos (by rw [decide_eq_true hmem]), if_pos hmem]
      · rw [if_neg (by rw [decide_eq_false hmem]; decide), if_neg hmem]
  | require i j =>
      simp only [interpStep, step, kernelDesc, Bool.not_true, Bool.false_or]
  | mark v p =>
      simp only [interpStep, step, kernelDesc, Bool.not_true, Bool.false_or]
  | addView c =>
      simp only [interpStep, step, kernelDesc, Bool.not_true, Bool.false_or]
  | refuse i j =>
      simp only [interpStep, step, kernelDesc, Bool.not_true, Bool.false_or]
  | note _ => rfl
  | setBudget _ => rfl
  | setAugLicense _ => rfl

def bools : List Bool := [false, true]

def allDescs : List ConstitutionDesc :=
  bools.flatMap fun a => bools.flatMap fun b =>
    bools.flatMap fun c => bools.flatMap fun e =>
      bools.flatMap fun f => bools.map fun g => ⟨a, b, c, e, f, g⟩

theorem allDescs_length : allDescs.length = 64 := by decide

theorem allDescs_complete : ∀ d : ConstitutionDesc, d ∈ allDescs := by
  intro d
  cases d with
  | mk a b c e f g =>
      cases a <;> cases b <;> cases c <;> cases e <;> cases f <;>
        cases g <;> decide

def wProbe : World :=
  { data := [10, 20], views := [[0]], reqs := [(0, 1)],
    refusals := [], budget := 1, augLicensed := true, notes := [] }

def wBudgetZero : World := { wProbe with views := [[]], budget := 0 }

def wUnlicensed : World := { wProbe with views := [], augLicensed := false }

def probeDedup (d : ConstitutionDesc) : Bool :=
  (interpStep d wProbe (.admitTok 10)).data == wProbe.data

def probeRequire (d : ConstitutionDesc) : Bool :=
  (interpStep d wProbe (.require 0 0)).reqs == wProbe.reqs

def probeAccept (d : ConstitutionDesc) : Bool :=
  satB (interpStep d wProbe (.mark [0] 1)) (0, 1)

def probeBudget (d : ConstitutionDesc) : Bool :=
  interpStep d wBudgetZero (.mark [] 0) == wBudgetZero

def probeLicense (d : ConstitutionDesc) : Bool :=
  interpStep d wUnlicensed (.addView [0]) == wUnlicensed

def probeRefusal (d : ConstitutionDesc) : Bool :=
  (interpStep d wProbe (.refuse 0 1)).refusals == []

def compliantB (d : ConstitutionDesc) : Bool :=
  probeDedup d && probeRequire d && probeAccept d &&
    probeBudget d && probeLicense d && probeRefusal d

/-- `Initiality.lean:105-113`: among all 64 descriptors in `allDescs`,
`kernelDesc` is the unique descriptor passing all six behavioral probes. -/
theorem d20_unique_compliant :
    allDescs.filter compliantB = [kernelDesc] ∧
    (∀ d : ConstitutionDesc, compliantB d = true ↔ d = kernelDesc) := by
  refine ⟨by decide, ?_⟩
  intro d
  cases d with
  | mk a b c e f g =>
      cases a <;> cases b <;> cases c <;> cases e <;> cases f <;>
        cases g <;> decide

/-- `Initiality.lean:121-155`: each of the six guards is independently
load-bearing (dropping any single toggle preserves the other five probes and
fails its dedicated behavioral probe). -/
theorem guard_independence_six_countermodels :
    (probeDedup { kernelDesc with dedupAdmit := false } = false ∧
      probeRequire { kernelDesc with dedupAdmit := false } = true ∧
      probeAccept { kernelDesc with dedupAdmit := false } = true ∧
      probeBudget { kernelDesc with dedupAdmit := false } = true ∧
      probeLicense { kernelDesc with dedupAdmit := false } = true ∧
      probeRefusal { kernelDesc with dedupAdmit := false } = true) ∧
    (probeRequire { kernelDesc with guardRequire := false } = false ∧
      probeDedup { kernelDesc with guardRequire := false } = true ∧
      probeAccept { kernelDesc with guardRequire := false } = true ∧
      probeBudget { kernelDesc with guardRequire := false } = true ∧
      probeLicense { kernelDesc with guardRequire := false } = true ∧
      probeRefusal { kernelDesc with guardRequire := false } = true) ∧
    (probeAccept { kernelDesc with guardAccept := false } = false ∧
      probeDedup { kernelDesc with guardAccept := false } = true ∧
      probeRequire { kernelDesc with guardAccept := false } = true ∧
      probeBudget { kernelDesc with guardAccept := false } = true ∧
      probeLicense { kernelDesc with guardAccept := false } = true ∧
      probeRefusal { kernelDesc with guardAccept := false } = true) ∧
    (probeBudget { kernelDesc with gateBudget := false } = false ∧
      probeDedup { kernelDesc with gateBudget := false } = true ∧
      probeRequire { kernelDesc with gateBudget := false } = true ∧
      probeAccept { kernelDesc with gateBudget := false } = true ∧
      probeLicense { kernelDesc with gateBudget := false } = true ∧
      probeRefusal { kernelDesc with gateBudget := false } = true) ∧
    (probeLicense { kernelDesc with gateLicense := false } = false ∧
      probeDedup { kernelDesc with gateLicense := false } = true ∧
      probeRequire { kernelDesc with gateLicense := false } = true ∧
      probeAccept { kernelDesc with gateLicense := false } = true ∧
      probeBudget { kernelDesc with gateLicense := false } = true ∧
      probeRefusal { kernelDesc with gateLicense := false } = true) ∧
    (probeRefusal { kernelDesc with certRefusal := false } = false ∧
      probeDedup { kernelDesc with certRefusal := false } = true ∧
      probeRequire { kernelDesc with certRefusal := false } = true ∧
      probeAccept { kernelDesc with certRefusal := false } = true ∧
      probeBudget { kernelDesc with certRefusal := false } = true ∧
      probeLicense { kernelDesc with certRefusal := false } = true) := by
  decide

/-! ## Section 2: NoOutside dichotomy, conservative retract, and panel re-entry -/

structure CWorld where
  base  : World
  panel : List (List View)
deriving Repr, DecidableEq

inductive CEvent where
  | base    (e : Event)
  | reenter (k : Nat)
deriving Repr, DecidableEq

def stepC (cw : CWorld) : CEvent → CWorld
  | .base e => { cw with base := step cw.base e }
  | .reenter k =>
      let cols := cw.panel.getD k []
      { cw with base := { cw.base with views := cw.base.views ++ cols } }

def replayC (es : List CEvent) (cw : CWorld) : CWorld :=
  es.foldl stepC cw

/-- `Initiality.lean:177-189`: the panel-extended kernel `CWorld` is a
conservative extension of `World`: base events commute strictly with the
projection `CWorld.base` both single-step and across replay. -/
theorem extension_retract_to_U0 (cw : CWorld) (e : Event) (es : List Event) :
    (stepC cw (.base e)).base = step cw.base e ∧
    (replayC (es.map CEvent.base) cw).base = replay es cw.base := by
  refine ⟨rfl, ?_⟩
  induction es generalizing cw with
  | nil => rfl
  | cons ev rest ih =>
      simp only [List.map, replayC, replay, List.foldl]
      exact ih (stepC cw (.base ev))

/-- `NoOutside.lean:45-64`: effectual-outside dichotomy — two worlds agreeing on
represented operational support (`supp w = supp w'`) replay to identical
support and identical violation/quiescence verdicts, whereas panel re-entry
increases the represented view store by `(cw.panel.getD k []).length`. -/
theorem effectual_outside_dichotomy (h : List Event) {w w' : World}
    (hs : supp w = supp w') (cw : CWorld) (k : Nat) :
    (supp (replay h w) = supp (replay h w') ∧
      (∀ r, violB (replay h w) r = violB (replay h w') r) ∧
      quiescentB (replay h w) = quiescentB (replay h w')) ∧
    (stepC cw (.reenter k)).base.views.length =
      cw.base.views.length + (cw.panel.getD k []).length := by
  have hrep := support_determines_replay h hs
  refine ⟨⟨hrep, ?_, ?_⟩, by simp [stepC, List.length_append]⟩
  · intro r
    cases hw1 : replay h w with
    | mk d1 v1 rq1 rf1 b1 a1 n1 =>
      cases hw2 : replay h w' with
      | mk d2 v2 rq2 rf2 b2 a2 n2 =>
        rw [hw1, hw2] at hrep
        simp only [supp, Supp.mk.injEq] at hrep
        obtain ⟨_, hv, hrq, _, _, _⟩ := hrep
        subst hv; subst hrq
        rfl
  · cases hw1 : replay h w with
    | mk d1 v1 rq1 rf1 b1 a1 n1 =>
      cases hw2 : replay h w' with
      | mk d2 v2 rq2 rf2 b2 a2 n2 =>
        rw [hw1, hw2] at hrep
        simp only [supp, Supp.mk.injEq] at hrep
        obtain ⟨_, hv, hrq, _, _, _⟩ := hrep
        subst hv; subst hrq
        rfl

def panelSig (panel : List (List View)) (i : Nat) : List (List Bool) :=
  panel.map (fun o => o.map (fun c => decide (i ∈ c)))

def PanelEquiv (panel : List (List View)) (i j : Nat) : Prop :=
  panelSig panel i = panelSig panel j

theorem panel_equiv (panel : List (List View)) :
    Equivalence (PanelEquiv panel) :=
  { refl  := fun _ => rfl
    symm  := fun h => h.symm
    trans := fun h1 h2 => h1.trans h2 }

structure OutsidePanel where
  extraData  : Nat
  extraForms : List Nat
  extraInsts : List Inst4
deriving DecidableEq, Repr

def reenterPanel (r : Regime4) (p : OutsidePanel) : Regime4 :=
  { data  := r.data + p.extraData
    forms := r.forms ++ p.extraForms
    insts := r.insts ++ p.extraInsts
    reqs  := r.reqs }

theorem unapplied_outside_leaves_separable_unchanged (r : Regime4) (x y : Nat) :
    applyDelta4 r [] = some r ∧
    (separable4 (reenterPanel r ⟨0, [], []⟩) x y ↔ separable4 r x y) := by
  refine ⟨rfl, ?_⟩
  have heq : reenterPanel r ⟨0, [], []⟩ = r := by
    cases r
    simp [reenterPanel]
  rw [heq]

theorem panel_reentry_preserves_counts (r : Regime4) (p : OutsidePanel) :
    (reenterPanel r p).data = r.data + p.extraData ∧
    (reenterPanel r p).forms.length = r.forms.length + p.extraForms.length ∧
    (reenterPanel r p).insts.length = r.insts.length + p.extraInsts.length := by
  simp [reenterPanel, List.length_append]

/-! ## Section 3: InterpreterBoundary diagonal non-exhaustion and tower persistence -/

def diagNeg {Code : Type u} (eval : Code → Code → Bool) (c : Code) : Bool :=
  !(eval c c)

theorem diagNeg_differs_at_self {Code : Type u}
    (eval : Code → Code → Bool) (c0 : Code) :
    eval c0 c0 ≠ diagNeg eval c0 := by
  unfold diagNeg
  cases eval c0 c0 <;> decide

theorem diagonal_non_exhaustion {Code : Type u}
    (eval : Code → Code → Bool) :
    ¬ ∃ c0 : Code, ∀ x : Code, eval c0 x = diagNeg eval x := by
  rintro ⟨c0, hc0⟩
  exact diagNeg_differs_at_self eval c0 (hc0 c0)

def extendEvaluator {n : Nat} (eval : Fin n → Fin n → Bool)
    (c : Fin (n + 1)) (x : Fin (n + 1)) : Bool :=
  if hc : c.val < n then
    if hx : x.val < n then
      eval ⟨c.val, hc⟩ ⟨x.val, hx⟩
    else
      false
  else
    if hx : x.val < n then
      diagNeg eval ⟨x.val, hx⟩
    else
      false

theorem tower_persists_at_every_stage {n : Nat}
    (eval : Fin n → Fin n → Bool) :
    (∀ x : Fin n,
      extendEvaluator eval ⟨n, Nat.lt_succ_self n⟩ ⟨x.val, Nat.lt_trans x.isLt (Nat.lt_succ_self n)⟩ =
        diagNeg eval x) ∧
    ¬ ∃ c0 : Fin (n + 1), ∀ x : Fin (n + 1),
      extendEvaluator eval c0 x = diagNeg (extendEvaluator eval) x := by
  refine ⟨?_, diagonal_non_exhaustion (extendEvaluator eval)⟩
  intro x
  unfold extendEvaluator
  have hnot : ¬ (n < n) := Nat.lt_irrefl n
  simp [hnot, x.isLt]

def maxNote : List Nat → Nat := List.foldl Nat.max 0

theorem lt_maxNote_of_mem {x : Nat} {l : List Nat} (hx : x ∈ l) :
    x < maxNote l + 1 := by
  have hle : ∀ (ls : List Nat) (a : Nat), x ∈ ls → x ≤ List.foldl Nat.max a ls := by
    intro ls
    induction ls with
    | nil => intro _ h; cases h
    | cons hd tl ih =>
        intro a hmem
        simp only [List.foldl]
        rcases List.mem_cons.mp hmem with rfl | htl
        · have h1 : x ≤ Nat.max a x := Nat.le_max_right a x
          have hmono : ∀ (ns : List Nat) (b c : Nat),
              b ≤ c → b ≤ List.foldl Nat.max c ns := by
            intro ns
            induction ns with
            | nil => intro _ _ h; exact h
            | cons y ys ihy =>
                intro b c hbc
                simp only [List.foldl]
                exact ihy b (Nat.max c y)
                  (Nat.le_trans hbc (Nat.le_max_left c y))
          exact hmono tl x (Nat.max a x) h1
        · exact ih (Nat.max a hd) htl
  have := hle l 0 hx
  unfold maxNote
  omega

def diagEvent {C : Type} (cs : List C) (ev : C → World → Event → World)
    (w : World) (e : Event) : World :=
  let ns := cs.map (fun c => (ev c w e).notes.length)
  { w with notes := List.replicate (maxNote ns + 1) 0 }

/-- `InterpreterBoundary.lean:102-119`: for any code type `C`, any finite list
of codes `cs : List C`, and any total evaluator `ev : C → World → Event → World`,
no code `c ∈ cs` reproduces `diagEvent cs ev` at `(genesis, .note 0)`. -/
theorem tower_persists {C : Type} (cs : List C)
    (ev : C → World → Event → World) :
    ∀ c ∈ cs, ev c genesis (.note 0) ≠ diagEvent cs ev genesis (.note 0) := by
  intro c hc heq
  have hlen : (ev c genesis (.note 0)).notes.length =
      (diagEvent cs ev genesis (.note 0)).notes.length :=
    congrArg (fun w : World => w.notes.length) heq
  have hmem : (ev c genesis (.note 0)).notes.length ∈
      cs.map (fun c' => (ev c' genesis (.note 0)).notes.length) :=
    List.mem_map.mpr ⟨c, hc, rfl⟩
  have hlt := lt_maxNote_of_mem hmem
  have hdiag : (diagEvent cs ev genesis (.note 0)).notes.length =
      maxNote (cs.map (fun c' => (ev c' genesis (.note 0)).notes.length)) + 1 := by
    simp [diagEvent, List.length_replicate]
  omega

def evalOpt : Option ConstitutionDesc → World → Event → Option World
  | some d, w, e => some (interpStep d w e)
  | none, _, _   => none

/-- `InterpreterBoundary.lean:155-161`: extending the code family with an
explicit uncoded/refusal element `none` yields a typed `Option World` outcome
without total self-evaluation. -/
theorem evalOpt_typed_refusal_and_embedding (d : ConstitutionDesc)
    (w : World) (e : Event) :
    evalOpt none w e = none ∧
    evalOpt (some d) w e = some (interpStep d w e) :=
  ⟨rfl, rfl⟩

/-! ## Section 4: WDP-CH06-P01 Strict-measure acyclicity and no-return -/

inductive PlusStep {S : Type u} (Step : S → S → Prop) : S → S → Prop where
  | single {a b : S} (h : Step a b) : PlusStep Step a b
  | tail {a b c : S} (hab : PlusStep Step a b) (hbc : Step b c) : PlusStep Step a c

theorem strict_measure_irrefl {S : Type u} (Step : S → S → Prop) (μ : S → Nat)
    (hmono : ∀ a b, Step a b → μ a < μ b) :
    Irrefl Step := by
  intro s hs
  exact Nat.lt_irrefl (μ s) (hmono s s hs)

theorem strict_measure_asymm {S : Type u} (Step : S → S → Prop) (μ : S → Nat)
    (hmono : ∀ a b, Step a b → μ a < μ b) {a b : S}
    (hab : Step a b) : ¬ Step b a := by
  intro hba
  exact Nat.lt_irrefl (μ a) (Nat.lt_trans (hmono a b hab) (hmono b a hba))

theorem strict_measure_plus_lt {S : Type u} (Step : S → S → Prop) (μ : S → Nat)
    (hmono : ∀ a b, Step a b → μ a < μ b) {a b : S}
    (hplus : PlusStep Step a b) : μ a < μ b := by
  induction hplus with
  | single h => exact hmono _ _ h
  | tail _ hbc ih => exact Nat.lt_trans ih (hmono _ _ hbc)

theorem strict_measure_no_return {S : Type u} (Step : S → S → Prop) (μ : S → Nat)
    (hmono : ∀ a b, Step a b → μ a < μ b) (s : S) :
    ¬ PlusStep Step s s := by
  intro hcycle
  exact Nat.lt_irrefl (μ s) (strict_measure_plus_lt Step μ hmono hcycle)

def regime4Measure (r : Regime4) : Nat :=
  r.data + r.forms.length + r.insts.length + r.reqs.length

theorem regime4Measure_newDatum_lt (r : Regime4) :
    regime4Measure r < regime4Measure { r with data := r.data + 1 } := by
  simp only [regime4Measure]
  omega

theorem regime4Measure_newForm_lt (r : Regime4) (k : Nat) :
    regime4Measure r < regime4Measure { r with forms := r.forms ++ [k] } := by
  simp only [regime4Measure, List.length_append, List.length_singleton]
  omega

/-! ## Section 5: OQ-08 Guard-Discrepancy Regressions and Full-Guard Adapted Commutation

Compares the simplified `HWorld` / `stepHWorldGuarded` model in
`RetentionAndRefusal.lean` against the fuller `Represented.World` / `step`
semantics (`19L57G1/lean4/Derivation/Represented.lean`, commit
`45bb09864f9b52ed5ecf66e977ca81f0ed623de7`), which enforces:
1. Carrier bound: `c.all (fun p => decide (p < w.data.length))`
2. View novelty: `!(decide (c ∈ w.views))`
3. Increased separation: `increaseB w c`
4. Augmentation licensing: `w.augLicensed`
5. Positive budget: `decide (0 < w.budget)`

We prove four regression theorems witnessing the concrete discrepancies between
`stepHWorldGuarded` and `Represented.step` (singleton carrier `[0]`, duplicate
views, disabled `augLicensed`, and novel views creating no new separation), and
prove commutation for an adapted full-guard 5-gate state `FullWDPWorld` over
`Represented.World` at `horizonSpecializationCosts = ⟨0, 0, 0, 1⟩`. The prose
5-gate grounding span `WDP-CH01-D03` (rational ledger `R ∈ ℚ≥0`, form/arity
admission, temporal retention fee, and `ℓ₁` cochain defect `Φ₁`) remains an
explicit `OWED` bridge (`OWE-12`). -/

/-- Regression 1 (Codex singleton discrepancy): on a singleton carrier `toks = [0]`
    with `budget = 1`, `stepHWorldGuarded` accepts `.addView 0` and decrements
    `budget` to `0`, whereas `Represented.step` on `data = [0]` rejects
    `.addView [0]` because `increaseB` is `false` (`[0]` separates no pair). -/
theorem oq08_singleton_discrepancy_regression :
    stepHWorldGuarded ⟨[0], [], [], 1⟩ (.addView 0) = ⟨[0], [], [0], 0⟩ ∧
    augOkB ⟨[0], [], [], [], 1, true, []⟩ [0] = false ∧
    step ⟨[0], [], [], [], 1, true, []⟩ (.addView [0]) =
      ⟨[0], [], [], [], 1, true, []⟩ := by
  decide

/-- Regression 2 (duplicate view): when `[1]` is already in `views` on `data = [0, 1]`
    with `budget = 1`, `Represented.step` rejects `.addView [1]` and preserves
    `budget = 1` via the novelty guard `!(decide (c ∈ w.views))`, whereas
    `stepHWorldGuarded` leaves `views = [1]` unchanged via `insertNewNat` but
    still decrements `budget` from `1` to `0`. -/
theorem oq08_duplicate_view_regression :
    let w : World := ⟨[0, 1], [[1]], [(0, 1)], [], 1, true, []⟩
    let hw : HWorld := ⟨[0, 1], [(0, 1)], [1], 1⟩
    augOkB w [1] = false ∧
    step w (.addView [1]) = w ∧
    (step w (.addView [1])).budget = 1 ∧
    stepHWorldGuarded hw (.addView 1) = ⟨[0, 1], [(0, 1)], [1], 0⟩ := by
  decide

/-- Regression 3 (disabled augmentation license): on `data = [0, 1]`, `reqs = [(0, 1)]`,
    `views = []`, `budget = 1`, `augLicensed = false`, view `[1]` satisfies
    `augOkB w [1] = true`, yet `Represented.step` rejects `.addView [1]` because
    `w.augLicensed = false`, whereas `stepHWorldGuarded` has no license guard
    and accepts `.addView 1`. -/
theorem oq08_disabled_license_regression :
    let w : World := ⟨[0, 1], [], [(0, 1)], [], 1, false, []⟩
    let hw : HWorld := ⟨[0, 1], [(0, 1)], [], 1⟩
    augOkB w [1] = true ∧
    step w (.addView [1]) = w ∧
    stepHWorldGuarded hw (.addView 1) = ⟨[0, 1], [(0, 1)], [1], 0⟩ := by
  decide

/-- Regression 4 (addition creating no new separation): on `data = [0, 1]`,
    `reqs = [(0, 1)]`, `views = [[0]]`, `budget = 1`, `augLicensed = true`,
    `(0, 1)` is already separated by `[0]`, so novel view `[1]` (`[1] ∉ [[0]]`)
    has `increaseB w [1] = false` and `Represented.step` rejects `.addView [1]`,
    whereas `stepHWorldGuarded` accepts `.addView 1` and decrements `budget`. -/
theorem oq08_no_new_separation_regression :
    let w : World := ⟨[0, 1], [[0]], [(0, 1)], [], 1, true, []⟩
    let hw : HWorld := ⟨[0, 1], [(0, 1)], [0], 1⟩
    decide ([1] ∈ w.views) = false ∧
    increaseB w [1] = false ∧
    augOkB w [1] = false ∧
    step w (.addView [1]) = w ∧
    stepHWorldGuarded hw (.addView 1) = ⟨[0, 1], [(0, 1)], [0, 1], 0⟩ := by
  decide

/-- Adapted 5-gate state carrying the full `Represented.World` fields together
    with raw ingress supply `sup` and diagnostic receipt counter `receipts`. -/
structure FullWDPWorld where
  sup         : List Nat
  adm         : List Nat
  views       : List View
  ret         : List Req
  refusals    : List Req
  ledger      : Nat
  augLicensed : Bool
  notes       : List Nat
  receipts    : Nat
deriving Repr, DecidableEq

/-- Forgetful projection from `FullWDPWorld` to the exact `Represented.World` record. -/
def projToRepresentedWorld (w : FullWDPWorld) : World :=
  { data        := w.adm
    views       := w.views
    reqs        := w.ret
    refusals    := w.refusals
    budget      := w.ledger
    augLicensed := w.augLicensed
    notes       := w.notes }

/-- Adapted 5-gate transition enforcing the exact `Represented.World` guards
    (`reqOkB`, `markOkB`, `augOkB`, `augLicensed`, `obstructedB`) alongside
    parametric gate costs `GateCosts`. -/
def stepFullWDPWorld (costs : GateCosts) (w : FullWDPWorld) : Event → FullWDPWorld
  | .admitTok t =>
      let cost := costs.cSup + costs.cAdm
      if cost ≤ w.ledger then
        let adm' := if t ∈ w.adm then w.adm else w.adm ++ [t]
        { w with sup := w.sup ++ [t], adm := adm', ledger := w.ledger - cost }
      else w
  | .require i j =>
      let pw := projToRepresentedWorld w
      if decide (costs.cRet ≤ w.ledger) && reqOkB pw i j then
        { w with ret := w.ret ++ [(i, j)], ledger := w.ledger - costs.cRet }
      else w
  | .mark v p =>
      let pw := projToRepresentedWorld w
      if markOkB pw v p && decide (costs.cEv ≤ w.ledger) then
        { w with
            views := (markApply pw v p).views,
            ledger := w.ledger - costs.cEv,
            receipts := w.receipts + 1 }
      else w
  | .addView c =>
      let pw := projToRepresentedWorld w
      if augOkB pw c && w.augLicensed && decide (costs.cEv ≤ w.ledger) then
        { w with
            views := (augApply pw c).views,
            ledger := w.ledger - costs.cEv,
            receipts := w.receipts + 1 }
      else w
  | .refuse i j =>
      let pw := projToRepresentedWorld w
      if obstructedB pw (i, j) && !(decide ((i, j) ∈ w.refusals)) then
        { w with refusals := w.refusals ++ [(i, j)] }
      else w
  | .note n =>
      { w with notes := w.notes ++ [n] }
  | .setBudget n =>
      { w with ledger := n }
  | .setAugLicense b =>
      { w with augLicensed := b }

/-- At `horizonSpecializationCosts = ⟨0, 0, 0, 1⟩`, the adapted full-guard 5-gate
    transition `stepFullWDPWorld` commutes with `projToRepresentedWorld` and
    `Represented.step` across all 8 `Event` constructors. -/
theorem oq08_full_guard_refinement_commutes_at_zero_adm_ret_cost
    (w : FullWDPWorld) (ev : Event) :
    projToRepresentedWorld (stepFullWDPWorld horizonSpecializationCosts w ev) =
      step (projToRepresentedWorld w) ev := by
  cases ev with
  | admitTok t =>
      by_cases ht : t ∈ w.adm <;>
        simp [stepFullWDPWorld, horizonSpecializationCosts, step,
          projToRepresentedWorld, ht]
  | require i j =>
      have hle : (0 : Nat) ≤ w.ledger := Nat.zero_le w.ledger
      cases hr : reqOkB (projToRepresentedWorld w) i j <;>
        simp [stepFullWDPWorld, horizonSpecializationCosts, step, hle, hr] <;>
        rfl
  | mark v p =>
      have hpos : (1 ≤ w.ledger) = (0 < w.ledger) := rfl
      cases hm : markOkB (projToRepresentedWorld w) v p <;>
        by_cases hb : 0 < w.ledger <;>
          simp [stepFullWDPWorld, horizonSpecializationCosts, step, hm, hb, hpos,
            show (projToRepresentedWorld w).budget = w.ledger from rfl] <;>
          rfl
  | addView c =>
      have hpos : (1 ≤ w.ledger) = (0 < w.ledger) := rfl
      cases ha : augOkB (projToRepresentedWorld w) c <;>
        cases hl : w.augLicensed <;>
          by_cases hb : 0 < w.ledger <;>
            simp [stepFullWDPWorld, horizonSpecializationCosts, step, ha, hl, hb, hpos,
              show (projToRepresentedWorld w).budget = w.ledger from rfl,
              show (projToRepresentedWorld w).augLicensed = w.augLicensed from rfl] <;>
            simp [projToRepresentedWorld, augApply, hl]
  | refuse i j =>
      cases ho : obstructedB (projToRepresentedWorld w) (i, j) <;>
        by_cases hr : (i, j) ∈ w.refusals <;>
          simp [stepFullWDPWorld, step, ho, hr,
            show ((i, j) ∈ (projToRepresentedWorld w).refusals) ↔ ((i, j) ∈ w.refusals) from Iff.rfl] <;>
          rfl
  | note n => rfl
  | setBudget n => rfl
  | setAugLicense b => rfl

end OmegaCodex.InternalMetatheory
