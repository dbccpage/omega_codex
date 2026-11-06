import TorsorAndOperations
import ZeroEquivalence

/-!
# Pruned 4-tuple regime, general arity-weight uniqueness, and multi-round closure (Slice 2)

Reconstructs the 4-tuple Regime4 without the uniform-rule store in the core state
(while retaining a standalone rule-monotonicity bridge), connects context-plugging
indistinguishability to ZeroEquivalence.Kernel, establishes mention irrelevance and
instance-permutation invariance, checks general strictly-increasing arity-weight
uniqueness (OQ-04, with the RT-01 scope witness), and checks the explicit-pair versus
quotient-refinement multi-round bounds (OQ-05, with the RT-09 re-collapse witness).
-/
set_option autoImplicit false

namespace OmegaCodex.MinimalSeparation

open OmegaCodex.PrimitiveDifference
open OmegaCodex.ZeroEquivalence
open OmegaCodex.TorsorAndOperations

/-! ## Section 1: Pruned 4-tuple Regime4 and bridge to ZeroEquivalence.Kernel -/

abbrev Inst4 := Nat × List Nat

def insertNew4 {α : Type} [DecidableEq α] (l : List α) (a : α) : List α :=
  if a ∈ l then l else l ++ [a]

structure Regime4 where
  data  : Nat
  forms : List Nat
  insts : List Inst4
  reqs  : List (Nat × Nat)
deriving Repr, DecidableEq

structure Ctx4 where
  form  : Nat
  slots : List (Option Nat)
deriving Repr, DecidableEq

def plug4 (c : Ctx4) (d : Nat) : Inst4 :=
  (c.form, c.slots.map (fun s => s.getD d))

def derivable4 (r : Regime4) (i : Inst4) : Prop :=
  i ∈ r.insts

instance (r : Regime4) (i : Inst4) : Decidable (derivable4 r i) := by
  unfold derivable4
  infer_instance

def derivable4Bool (r : Regime4) (i : Inst4) : Bool :=
  decide (derivable4 r i)

def slotOk4 (n : Nat) : Option Nat → Prop
  | none => True
  | some x => x < n

instance (n : Nat) (s : Option Nat) : Decidable (slotOk4 n s) :=
  match s with
  | none => isTrue trivial
  | some x => Nat.decLt x n

def wfCtx4 (r : Regime4) (c : Ctx4) : Prop :=
  c.form < r.forms.length ∧
  c.slots.length = r.forms.getD c.form 0 ∧
  none ∈ c.slots ∧
  ∀ s ∈ c.slots, slotOk4 r.data s

instance (r : Regime4) (c : Ctx4) : Decidable (wfCtx4 r c) := by
  unfold wfCtx4
  infer_instance

def collapsed4 (r : Regime4) (d d' : Nat) : Prop :=
  ∀ c : Ctx4, wfCtx4 r c → (derivable4 r (plug4 c d) ↔ derivable4 r (plug4 c d'))

def separable4 (r : Regime4) (d d' : Nat) : Prop :=
  ∃ c : Ctx4, wfCtx4 r c ∧
    ¬ (derivable4 r (plug4 c d) ↔ derivable4 r (plug4 c d'))

theorem separable4_not_collapsed4 {r : Regime4} {d d' : Nat}
    (h : separable4 r d d') : ¬ collapsed4 r d d' :=
  fun hc => h.elim fun c hc' => hc'.2 (hc c hc'.1)

/-- Optional uniform-rule extension bridge (answering Q1): adding uniform all-tuple
rules can only erase separations, so any separation under `rules2` already holds
under a sub-list `rules1 ⊆ rules2` (and in particular under `rules = []` in `Regime4`). -/
def derivableWithRules (r : Regime4) (rules : List Nat) (i : Inst4) : Prop :=
  i ∈ r.insts ∨ i.1 ∈ rules

theorem separableWithRules_implies_separable4 (r : Regime4) (rules : List Nat)
    (d d' : Nat)
    (hsep : ∃ c : Ctx4, wfCtx4 r c ∧
      ¬ (derivableWithRules r rules (plug4 c d) ↔ derivableWithRules r rules (plug4 c d'))) :
    separable4 r d d' := by
  rcases hsep with ⟨c, hwf, hne⟩
  refine ⟨c, hwf, ?_⟩
  intro hiff
  apply hne
  constructor
  · intro hd
    rcases hd with hi | hr
    · exact Or.inl (hiff.mp hi)
    · exact Or.inr hr
  · intro hd'
    rcases hd' with hi' | hr'
    · exact Or.inl (hiff.mpr hi')
    · exact Or.inr hr'

def ctxKernel4 (r : Regime4) (c : Ctx4) : Kernel Nat Bool :=
  relabel binary (fun d => derivable4Bool r (plug4 c d))

theorem ctxKernel4_zeroRel_iff (r : Regime4) (c : Ctx4) (d1 d2 : Nat) :
    ZeroRel (ctxKernel4 r c) d1 d2 ↔
      (derivable4 r (plug4 c d1) ↔ derivable4 r (plug4 c d2)) := by
  unfold ctxKernel4
  rw [relabel_zeroRel, binary_zeroRel_iff_eq]
  unfold derivable4Bool
  constructor
  · intro heq
    constructor
    · intro hd1
      exact of_decide_eq_true (heq ▸ decide_eq_true hd1)
    · intro hd2
      exact of_decide_eq_true (heq.symm ▸ decide_eq_true hd2)
  · intro hiff
    by_cases hd1 : derivable4 r (plug4 c d1)
    · have hd2 : derivable4 r (plug4 c d2) := hiff.mp hd1
      rw [decide_eq_true hd1, decide_eq_true hd2]
    · have hd2 : ¬ derivable4 r (plug4 c d2) := fun h => hd1 (hiff.mpr h)
      rw [decide_eq_false hd1, decide_eq_false hd2]

theorem collapsed4_iff_all_ctxKernel4_zero (r : Regime4) (d1 d2 : Nat) :
    collapsed4 r d1 d2 ↔ ∀ c : Ctx4, wfCtx4 r c → ZeroRel (ctxKernel4 r c) d1 d2 := by
  unfold collapsed4
  constructor
  · intro h c hwf
    exact (ctxKernel4_zeroRel_iff r c d1 d2).mpr (h c hwf)
  · intro h c hwf
    exact (ctxKernel4_zeroRel_iff r c d1 d2).mp (h c hwf)

def collapsed4Setoid (r : Regime4) : Setoid Nat where
  r := collapsed4 r
  iseqv := ⟨
    fun _ _ _ => Iff.rfl,
    fun h c hwf => (h c hwf).symm,
    fun h1 h2 c hwf => (h1 c hwf).trans (h2 c hwf)
  ⟩

def collapsed4Kernel (r : Regime4) : Kernel Nat Prop :=
  fromSetoid (collapsed4Setoid r)

theorem collapsed4_equivalence (r : Regime4) : Equivalence (collapsed4 r) :=
  zeroRel_equivalence (collapsed4Kernel r)

/-! ## Section 2: Mention irrelevance and instance-permutation invariance -/

theorem collapsed4_of_no_insts (r : Regime4) (h : r.insts = []) (d d' : Nat) :
    collapsed4 r d d' := by
  intro c _
  simp [derivable4, plug4, h]

theorem no_insts_no_separation4 {s : Regime4} {d d' : Nat}
    (hi : s.insts = []) (hsep : separable4 s d d') : False :=
  separable4_not_collapsed4 hsep (collapsed4_of_no_insts s hi d d')

inductive Item4 where
  | newDatum
  | newForm (arity : Nat)
  | newInst (form : Nat) (args : List Nat)
deriving Repr, DecidableEq

def applyItem4 (r : Regime4) : Item4 → Option Regime4
  | .newDatum => some { r with data := r.data + 1 }
  | .newForm a =>
      if 1 ≤ a then some { r with forms := r.forms ++ [a] } else none
  | .newInst f args =>
      if f < r.forms.length ∧ args.length = r.forms.getD f 0 ∧
          (∀ x ∈ args, x < r.data) then
        some { r with insts := insertNew4 r.insts (f, args) }
      else none

def applyDelta4 (r : Regime4) (δ : List Item4) : Option Regime4 :=
  δ.foldlM applyItem4 r

theorem applyDelta4_pair (r : Regime4) (a b : Item4) :
    applyDelta4 r [a, b] =
      (applyItem4 r a).bind (fun r1 => applyItem4 r1 b) := by
  unfold applyDelta4
  cases h : applyItem4 r a with
  | none => simp [List.foldlM, h]
  | some r1 => cases h2 : applyItem4 r1 b <;> simp [List.foldlM, h, h2]

theorem collapsed4_fresh_datum_imp (r : Regime4) (d d' : Nat)
    (hc : collapsed4 { r with data := r.data + 1 } d d') :
    collapsed4 r d d' := by
  intro c hwf
  apply hc c
  refine ⟨hwf.1, hwf.2.1, hwf.2.2.1, ?_⟩
  intro s hs
  have hok := hwf.2.2.2 s hs
  cases s with
  | none => trivial
  | some x =>
      change x < r.data at hok
      change x < r.data + 1
      omega

theorem getD_append_left4 (forms : List Nat) (k f : Nat) (hf : f < forms.length) :
    (forms ++ [k]).getD f 0 = forms.getD f 0 := by
  induction forms generalizing f with
  | nil => cases hf
  | cons a tail ih =>
      cases f with
      | zero => rfl
      | succ f' =>
          have hf' : f' < tail.length := Nat.lt_of_succ_lt_succ hf
          exact ih f' hf'

theorem collapsed4_fresh_form_iff (r : Regime4) (k d d' : Nat)
    (hinsts : ∀ p ∈ r.insts, p.1 < r.forms.length) :
    collapsed4 { r with forms := r.forms ++ [k] } d d' ↔ collapsed4 r d d' := by
  constructor
  · intro hc c hwf
    apply hc c
    refine ⟨?_, ?_, hwf.2.2.1, hwf.2.2.2⟩
    · rw [List.length_append]
      exact Nat.lt_of_lt_of_le hwf.1 (Nat.le_add_right _ _)
    · rw [getD_append_left4 r.forms k c.form hwf.1]
      exact hwf.2.1
  · intro hc c hwf
    rcases Nat.lt_or_ge c.form r.forms.length with hlt | hge
    · apply hc c
      refine ⟨hlt, ?_, hwf.2.2.1, hwf.2.2.2⟩
      have hlen := hwf.2.1
      rw [getD_append_left4 r.forms k c.form hlt] at hlen
      exact hlen
    · constructor
      · intro hd
        exfalso
        have hlt := hinsts (plug4 c d) hd
        change c.form < r.forms.length at hlt
        omega
      · intro hd'
        exfalso
        have hlt := hinsts (plug4 c d') hd'
        change c.form < r.forms.length at hlt
        omega

theorem separable4_perm_invariant (r1 r2 : Regime4)
    (hd : r1.data = r2.data) (hf : r1.forms = r2.forms)
    (hi : ∀ p, p ∈ r1.insts ↔ p ∈ r2.insts) (x y : Nat) :
    separable4 r1 x y ↔ separable4 r2 x y := by
  have hwf_eq : ∀ c, wfCtx4 r1 c ↔ wfCtx4 r2 c := by
    intro c
    simp [wfCtx4, hd, hf]
  have hder_eq : ∀ i, derivable4 r1 i ↔ derivable4 r2 i := by
    intro i
    exact hi i
  constructor
  · rintro ⟨c, hwf, hne⟩
    refine ⟨c, (hwf_eq c).mp hwf, ?_⟩
    intro hiff
    apply hne
    exact (hder_eq (plug4 c x)).trans (hiff.trans (hder_eq (plug4 c y)).symm)
  · rintro ⟨c, hwf, hne⟩
    refine ⟨c, (hwf_eq c).mpr hwf, ?_⟩
    intro hiff
    apply hne
    exact (hder_eq (plug4 c x)).symm.trans (hiff.trans (hder_eq (plug4 c y)))

/-! ## Section 3: OQ-04 General arity-weight uniqueness and RT-01 scope witness -/

def validResponse4 (r : Regime4) (i j : Nat) (δ : List Item4) : Prop :=
  ∃ s, applyDelta4 r δ = some s ∧ separable4 s i j ∧
    ∀ q ∈ r.reqs, separable4 s q.1 q.2

def R2L4 : Regime4 := ⟨2, [], [], [(0, 1)]⟩
def R2F4 : Regime4 := ⟨3, [], [], [(1, 2)]⟩
def U0_4  : Regime4 := ⟨2, [1], [(0, [0])], [(0, 1)]⟩
def U1_4  : Regime4 := ⟨2, [1], [(0, [1])], [(0, 1)]⟩
def U0F_4 : Regime4 := ⟨3, [1], [(0, [1])], [(1, 2)]⟩
def U2F_4 : Regime4 := ⟨3, [1], [(0, [2])], [(1, 2)]⟩

def sortPair4 (p : Nat × Nat) : Nat × Nat :=
  if p.1 ≤ p.2 then p else (p.2, p.1)

structure Iso4 (r s : Regime4) where
  dmap : Nat → Nat
  dinv : Nat → Nat
  fmap : Nat → Nat
  finv : Nat → Nat
  dmap_lt : ∀ d ∈ List.range r.data, dmap d < s.data
  dinv_lt : ∀ d ∈ List.range s.data, dinv d < r.data
  dinv_dmap : ∀ d ∈ List.range r.data, dinv (dmap d) = d
  dmap_dinv : ∀ d ∈ List.range s.data, dmap (dinv d) = d
  fmap_lt : ∀ f ∈ List.range r.forms.length, fmap f < s.forms.length
  finv_lt : ∀ f ∈ List.range s.forms.length, finv f < r.forms.length
  finv_fmap : ∀ f ∈ List.range r.forms.length, finv (fmap f) = f
  fmap_finv : ∀ f ∈ List.range s.forms.length, fmap (finv f) = f
  arity : ∀ f ∈ List.range r.forms.length,
      s.forms.getD (fmap f) 0 = r.forms.getD f 0
  insts_fwd : ∀ p ∈ r.insts, (fmap p.1, p.2.map dmap) ∈ s.insts
  insts_bwd : ∀ p ∈ s.insts, (finv p.1, p.2.map dinv) ∈ r.insts
  reqs_fwd : ∀ q ∈ r.reqs, sortPair4 (dmap q.1, dmap q.2) ∈ s.reqs
  reqs_bwd : ∀ q ∈ s.reqs, sortPair4 (dinv q.1, dinv q.2) ∈ r.reqs

def iso4Refl (r : Regime4) (hreqs : ∀ q ∈ r.reqs, q.1 ≤ q.2) : Iso4 r r where
  dmap := id
  dinv := id
  fmap := id
  finv := id
  dmap_lt := fun _ hd => List.mem_range.mp hd
  dinv_lt := fun _ hd => List.mem_range.mp hd
  dinv_dmap := fun _ _ => rfl
  dmap_dinv := fun _ _ => rfl
  fmap_lt := fun _ hf => List.mem_range.mp hf
  finv_lt := fun _ hf => List.mem_range.mp hf
  finv_fmap := fun _ _ => rfl
  fmap_finv := fun _ _ => rfl
  arity := fun _ _ => rfl
  insts_fwd := fun _ hp => by simpa [List.map_id] using hp
  insts_bwd := fun _ hp => by simpa [List.map_id] using hp
  reqs_fwd := fun q hq => by simpa [sortPair4, hreqs q hq] using hq
  reqs_bwd := fun q hq => by simpa [sortPair4, hreqs q hq] using hq

def swap01_4 (d : Nat) : Nat :=
  if d = 0 then 1 else if d = 1 then 0 else d

def iso4U1U0 : Iso4 U1_4 U0_4 where
  dmap := swap01_4
  dinv := swap01_4
  fmap := id
  finv := id
  dmap_lt := by decide
  dinv_lt := by decide
  dinv_dmap := by decide
  dmap_dinv := by decide
  fmap_lt := by decide
  finv_lt := by decide
  finv_fmap := by decide
  fmap_finv := by decide
  arity := by decide
  insts_fwd := by decide
  insts_bwd := by decide
  reqs_fwd := by decide
  reqs_bwd := by decide

def swap12_4 (d : Nat) : Nat :=
  if d = 1 then 2 else if d = 2 then 1 else d

def iso4U2F_U0F : Iso4 U2F_4 U0F_4 where
  dmap := swap12_4
  dinv := swap12_4
  fmap := id
  finv := id
  dmap_lt := by decide
  dinv_lt := by decide
  dinv_dmap := by decide
  dmap_dinv := by decide
  fmap_lt := by decide
  finv_lt := by decide
  finv_fmap := by decide
  fmap_finv := by decide
  arity := by decide
  insts_fwd := by decide
  insts_bwd := by decide
  reqs_fwd := by decide
  reqs_bwd := by decide

theorem cost1_insufficient_general (it : Item4) :
    ¬ validResponse4 R2L4 0 1 [it] := by
  rintro ⟨s, happ, hsep, _⟩
  unfold applyDelta4 at happ
  simp only [List.foldlM] at happ
  cases it with
  | newDatum =>
      have hs : s = ⟨3, [], [], [(0, 1)]⟩ := (Option.some.inj happ).symm
      subst hs
      exact no_insts_no_separation4 rfl hsep
  | newForm c =>
      simp only [applyItem4] at happ
      split at happ
      · have hs := (Option.some.inj happ).symm
        subst hs
        exact no_insts_no_separation4 rfl hsep
      · cases happ
  | newInst f args =>
      simp only [applyItem4] at happ
      rw [if_neg (by simp [R2L4])] at happ
      cases happ

theorem genesis_mark_not_separable4 :
    ¬ separable4 (⟨3, [1], [(0, [0])], [(1, 2)]⟩ : Regime4) 1 2
  | ⟨⟨0, [none]⟩, _, hne⟩ =>
      hne (Iff.intro (fun h => nomatch h) (fun h => nomatch h))
  | ⟨⟨0, [some _]⟩, ⟨_, _, hnone, _⟩, _⟩ => nomatch hnone
  | ⟨⟨0, []⟩, ⟨_, hlen, _, _⟩, _⟩ => nomatch hlen
  | ⟨⟨0, _ :: _ :: _⟩, ⟨_, hlen, _, _⟩, _⟩ => nomatch hlen
  | ⟨⟨_ + 1, _⟩, ⟨hf, _, _, _⟩, _⟩ => by change _ + 1 < 1 at hf; omega

def phiSum4 (φ : Nat → Nat) : List Item4 → Nat
  | [] => 0
  | .newForm a :: rest => φ a + phiSum4 φ rest
  | _ :: rest => phiSum4 φ rest

theorem mu2_unique_general (φ : Nat → Nat) (hφ : ∀ k, 2 ≤ k → φ 1 < φ k)
    (a b : Item4) (hval : validResponse4 R2L4 0 1 [a, b])
    (har : phiSum4 φ [a, b] ≤ φ 1) :
    ∃ s, applyDelta4 R2L4 [a, b] = some s ∧ Nonempty (Iso4 s U0_4) := by
  rcases hval with ⟨s, happ, hsep, _⟩
  refine ⟨s, happ, ?_⟩
  rw [applyDelta4_pair] at happ
  cases ha : applyItem4 R2L4 a with
  | none => rw [ha] at happ; cases happ
  | some r1 =>
    rw [ha] at happ
    have happ2 : applyItem4 r1 b = some s := happ
    cases a with
    | newInst f args =>
        simp only [applyItem4] at ha
        rw [if_neg (by simp [R2L4])] at ha
        cases ha
    | newDatum =>
        have hr1 : r1 = ⟨3, [], [], [(0, 1)]⟩ := (Option.some.inj ha).symm
        subst hr1
        cases b with
        | newInst f args =>
            simp only [applyItem4] at happ2
            rw [if_neg (by simp)] at happ2
            cases happ2
        | newDatum =>
            have hz := Option.some.inj happ2
            subst hz
            exact absurd (no_insts_no_separation4 rfl hsep) id
        | newForm c =>
            simp only [applyItem4] at happ2
            split at happ2
            · have hz := Option.some.inj happ2
              subst hz
              exact absurd (no_insts_no_separation4 rfl hsep) id
            · cases happ2
    | newForm c =>
        have hc1 : 1 ≤ c := by
          cases Nat.lt_or_ge c 1 with
          | inr hge => exact hge
          | inl hlt =>
              exfalso
              simp only [applyItem4] at ha
              rw [if_neg (by omega)] at ha
              cases ha
        have hr1 : r1 = ⟨2, [c], [], [(0, 1)]⟩ := by
          simp only [applyItem4] at ha
          rw [if_pos hc1] at ha
          exact (Option.some.inj ha).symm
        subst hr1
        cases b with
        | newDatum =>
            have hz := Option.some.inj happ2
            subst hz
            exact absurd (no_insts_no_separation4 rfl hsep) id
        | newForm c' =>
            simp only [applyItem4] at happ2
            split at happ2
            · have hz := Option.some.inj happ2
              subst hz
              exact absurd (no_insts_no_separation4 rfl hsep) id
            · cases happ2
        | newInst f args =>
            have hphi : φ c ≤ φ 1 := by simpa [phiSum4] using har
            have hc : c = 1 := by
              cases Nat.lt_or_ge c 2 with
              | inl hlt2 => omega
              | inr hge2 =>
                  have hlt_phi := hφ c hge2
                  omega
            subst hc
            simp only [applyItem4] at happ2
            split at happ2
            next hcond =>
              have hz := Option.some.inj happ2
              have hf : f = 0 := by
                have := hcond.1
                simp at this
                omega
              subst hf
              have hargs1 : args.length = 1 := by
                have := hcond.2.1
                simpa using this
              match args, hargs1 with
              | [x], _ =>
                have hx2 : x < 2 := by
                  have := hcond.2.2 x (by simp)
                  simpa using this
                subst hz
                match x, hx2 with
                | 0, _ => exact ⟨iso4Refl U0_4 (by decide)⟩
                | 1, _ => exact ⟨iso4U1U0⟩
            next => cases happ2

theorem mu2_unique_F_general (φ : Nat → Nat) (hφ : ∀ k, 2 ≤ k → φ 1 < φ k)
    (a b : Item4) (hval : validResponse4 R2F4 1 2 [a, b])
    (har : phiSum4 φ [a, b] ≤ φ 1) :
    ∃ s, applyDelta4 R2F4 [a, b] = some s ∧ Nonempty (Iso4 s U0F_4) := by
  rcases hval with ⟨s, happ, hsep, _⟩
  refine ⟨s, happ, ?_⟩
  rw [applyDelta4_pair] at happ
  cases ha : applyItem4 R2F4 a with
  | none => rw [ha] at happ; cases happ
  | some r1 =>
    rw [ha] at happ
    have happ2 : applyItem4 r1 b = some s := happ
    cases a with
    | newInst f args =>
        simp only [applyItem4] at ha
        rw [if_neg (by simp [R2F4])] at ha
        cases ha
    | newDatum =>
        have hr1 : r1 = ⟨4, [], [], [(1, 2)]⟩ := (Option.some.inj ha).symm
        subst hr1
        cases b with
        | newInst f args =>
            simp only [applyItem4] at happ2
            rw [if_neg (by simp)] at happ2
            cases happ2
        | newDatum =>
            have hz := Option.some.inj happ2
            subst hz
            exact absurd (no_insts_no_separation4 rfl hsep) id
        | newForm c =>
            simp only [applyItem4] at happ2
            split at happ2
            · have hz := Option.some.inj happ2
              subst hz
              exact absurd (no_insts_no_separation4 rfl hsep) id
            · cases happ2
    | newForm c =>
        have hc1 : 1 ≤ c := by
          cases Nat.lt_or_ge c 1 with
          | inr hge => exact hge
          | inl hlt =>
              exfalso
              simp only [applyItem4] at ha
              rw [if_neg (by omega)] at ha
              cases ha
        have hr1 : r1 = ⟨3, [c], [], [(1, 2)]⟩ := by
          simp only [applyItem4] at ha
          rw [if_pos hc1] at ha
          exact (Option.some.inj ha).symm
        subst hr1
        cases b with
        | newDatum =>
            have hz := Option.some.inj happ2
            subst hz
            exact absurd (no_insts_no_separation4 rfl hsep) id
        | newForm c' =>
            simp only [applyItem4] at happ2
            split at happ2
            · have hz := Option.some.inj happ2
              subst hz
              exact absurd (no_insts_no_separation4 rfl hsep) id
            · cases happ2
        | newInst f args =>
            have hphi : φ c ≤ φ 1 := by simpa [phiSum4] using har
            have hc : c = 1 := by
              cases Nat.lt_or_ge c 2 with
              | inl hlt2 => omega
              | inr hge2 =>
                  have hlt_phi := hφ c hge2
                  omega
            subst hc
            simp only [applyItem4] at happ2
            split at happ2
            next hcond =>
              have hz := Option.some.inj happ2
              have hf : f = 0 := by
                have := hcond.1
                simp at this
                omega
              subst hf
              have hargs1 : args.length = 1 := by
                have := hcond.2.1
                simpa using this
              match args, hargs1 with
              | [x], _ =>
                have hx3 : x < 3 := by
                  have := hcond.2.2 x (by simp)
                  simpa using this
                subst hz
                match x, hx3 with
                | 0, _ => exact absurd hsep genesis_mark_not_separable4
                | 1, _ => exact ⟨iso4Refl U0F_4 (by decide)⟩
                | 2, _ => exact ⟨iso4U2F_U0F⟩
            next => cases happ2

def phiLinear4 (k : Nat) : Nat := k

theorem phiLinear4_strict : ∀ k, 2 ≤ k → phiLinear4 1 < phiLinear4 k := by
  intro k hk; unfold phiLinear4; omega

def phiSingleHole4 (n k : Nat) : Nat := k * n ^ (k - 1)

theorem pow_pos_of_pos4 {n : Nat} (hn : 1 ≤ n) : ∀ m : Nat, 1 ≤ n ^ m
  | 0 => by simp
  | m + 1 => by
      rw [Nat.pow_succ]
      have ih := pow_pos_of_pos4 hn m
      exact Nat.le_trans ih (Nat.le_mul_of_pos_right _ (by omega))

theorem phiSingleHole4_strict (n : Nat) (hn : 1 ≤ n) :
    ∀ k, 2 ≤ k → phiSingleHole4 n 1 < phiSingleHole4 n k := by
  intro k hk
  unfold phiSingleHole4
  have hpow : 1 ≤ n ^ (k - 1) := pow_pos_of_pos4 hn (k - 1)
  have hmul : k * 1 ≤ k * n ^ (k - 1) := Nat.mul_le_mul_left k hpow
  simp at hmul ⊢
  omega

def phiMultiHole4 (n k : Nat) : Nat := (n + 1) ^ k - n ^ k

theorem pow_succ_gap4 (n : Nat) (hn : 1 ≤ n) :
    ∀ m : Nat, n ^ (m + 2) + 2 ≤ (n + 1) ^ (m + 2)
  | 0 => by
      simp [Nat.pow_succ, Nat.mul_add, Nat.add_mul]
      omega
  | m + 1 => by
      have ih := pow_succ_gap4 n hn m
      change n ^ ((m + 2) + 1) + 2 ≤ (n + 1) ^ ((m + 2) + 1)
      rw [Nat.pow_succ n (m + 2), Nat.pow_succ (n + 1) (m + 2), Nat.mul_add, Nat.mul_one]
      have h2 : n ^ (m + 2) * n ≤ (n + 1) ^ (m + 2) * n :=
        Nat.mul_le_mul_right n (by omega)
      omega

theorem phiMultiHole4_strict (n : Nat) (hn : 1 ≤ n) :
    ∀ k, 2 ≤ k → phiMultiHole4 n 1 < phiMultiHole4 n k := by
  intro k hk
  unfold phiMultiHole4
  have h1 : (n + 1) ^ 1 - n ^ 1 = 1 := by simp
  rw [h1]
  have ⟨m, hm⟩ : ∃ m, k = m + 2 := ⟨k - 2, by omega⟩
  subst hm
  have hgap := pow_succ_gap4 n hn m
  omega

def phiZeroUnary (k : Nat) : Nat := if k ≤ 1 then 0 else 1

/-- RT-01 scope witness: if `φ 1 = 0` (`phiZeroUnary`) and list length is not
fixed to `|δ| = 2`, the 3-item response `[.newForm 1, .newForm 1, .newInst 0 [0]]`
achieves `phiSum4 phiZeroUnary δ = 0 ≤ phiZeroUnary 1` while producing two unary
forms `forms = [1, 1]` instead of `U0_4.forms = [1]`. -/
theorem rt01_zero_unary_weight_three_item_countermodel :
    (∀ k, 2 ≤ k → phiZeroUnary 1 < phiZeroUnary k) ∧
    phiSum4 phiZeroUnary [.newForm 1, .newForm 1, .newInst 0 [0]] ≤ phiZeroUnary 1 ∧
    applyDelta4 R2L4 [.newForm 1, .newForm 1, .newInst 0 [0]] =
      some ⟨2, [1, 1], [(0, [0])], [(0, 1)]⟩ ∧
    (⟨2, [1, 1], [(0, [0])], [(0, 1)]⟩ : Regime4).forms.length ≠ U0_4.forms.length := by
  refine ⟨?_, by decide, by decide, by decide⟩
  intro k hk
  unfold phiZeroUnary
  have hnot : ¬ (k ≤ 1) := by omega
  simp [hnot]

/-! ## Section 4: OQ-05 Multi-round closure bounds and RT-09 re-collapse witness -/

inductive ExplicitQRun (n : Nat) : Nat → Nat → Prop where
  | nil (q : Nat) (hcap : 2 * q ≤ n * (n - 1)) : ExplicitQRun n q 0
  | step {q q' m : Nat} (hinc : q + 1 ≤ q') (hrest : ExplicitQRun n q' m) :
      ExplicitQRun n q (m + 1)

theorem explicit_pair_round_bound {n q0 m : Nat}
    (hrun : ExplicitQRun n q0 m) :
    2 * (q0 + m) ≤ n * (n - 1) := by
  induction hrun with
  | nil q hcap => omega
  | step hinc _ ih => omega

inductive QuotRefRun (n : Nat) : Nat → Nat → Prop where
  | nil (c : Nat) (hcap : c ≤ n) : QuotRefRun n c 0
  | step {c c' m : Nat} (hinc : c + 1 ≤ c') (hrest : QuotRefRun n c' m) :
      QuotRefRun n c (m + 1)

theorem quotient_refinement_bound {n c0 m : Nat}
    (hrun : QuotRefRun n c0 m) :
    c0 + m ≤ n := by
  induction hrun with
  | nil c hcap => omega
  | step hinc _ ih => omega

theorem quotient_refinement_from_one {n c0 m : Nat}
    (hc0 : 1 ≤ c0) (hrun : QuotRefRun n c0 m) :
    m ≤ n - 1 := by
  have hb := quotient_refinement_bound hrun
  omega

theorem strict_gap_for_n_ge_3 (n : Nat) (hn : 3 ≤ n) :
    2 * (n - 1) < n * (n - 1) := by
  have h1 : 1 ≤ n - 1 := by omega
  have h2 : 2 * (n - 1) < 3 * (n - 1) := by omega
  have h3 : 3 * (n - 1) ≤ n * (n - 1) := Nat.mul_le_mul_right (n - 1) hn
  omega

def R3_round1 : Regime4 := ⟨3, [1], [(0, [0])], [(0, 1)]⟩
def R3_round2_recollapse : Regime4 := ⟨3, [1], [(0, [0]), (0, [2])], [(0, 1)]⟩
def ctxUnary0_4 : Ctx4 := ⟨0, [none]⟩

theorem n3_unary_splits_two_pairs :
    wfCtx4 R3_round1 ctxUnary0_4 ∧
    separable4 R3_round1 0 1 ∧
    separable4 R3_round1 0 2 ∧
    collapsed4 R3_round1 1 2 := by
  refine ⟨by decide, ⟨ctxUnary0_4, by decide, by decide⟩, ⟨ctxUnary0_4, by decide, by decide⟩, ?_⟩
  intro c hwf
  rcases c with ⟨f, slots⟩
  rcases hwf with ⟨hf, hlen, hnone, _⟩
  have hf0 : f = 0 := by change f < 1 at hf; omega
  subst hf0
  have hlen1 : slots.length = 1 := hlen
  match slots, hlen1 with
  | [s], _ =>
    have hs : s = none := by
      cases hnone with
      | head => rfl
      | tail _ h => cases h
    subst hs
    decide

/-- RT-09 witness: on `n = 3`, appending `.newInst 0 [2]` to `R3_round1` is a
valid separating response for collapsed pair `(1, 2)` that preserves `(0, 1) ∈ reqs`,
but re-collapses the unrequested pair `(0, 2)`, showing why cumulative partition
refinement (`collapsed4 s ⊆ collapsed4 r`) or fresh-form extension is required to
derive strict class-count growth. -/
theorem rt09_unrequested_pair_recollapse_witness :
    applyDelta4 R3_round1 [.newInst 0 [2]] = some R3_round2_recollapse ∧
    separable4 R3_round2_recollapse 1 2 ∧
    separable4 R3_round2_recollapse 0 1 ∧
    collapsed4 R3_round2_recollapse 0 2 := by
  refine ⟨by decide, ⟨ctxUnary0_4, by decide, by decide⟩, ⟨ctxUnary0_4, by decide, by decide⟩, ?_⟩
  intro c hwf
  rcases c with ⟨f, slots⟩
  rcases hwf with ⟨hf, hlen, hnone, _⟩
  have hf0 : f = 0 := by change f < 1 at hf; omega
  subst hf0
  have hlen1 : slots.length = 1 := hlen
  match slots, hlen1 with
  | [s], _ =>
    have hs : s = none := by
      cases hnone with
      | head => rfl
      | tail _ h => cases h
    subst hs
    decide

def R3_round2_fresh : Regime4 := ⟨3, [1, 1], [(0, [0]), (1, [1])], [(0, 1)]⟩
def ctxUnary1_4 : Ctx4 := ⟨1, [none]⟩

/-- RT-09 positive counterpart (Condition 2 of `12_post_seal_adversary_and_roadmap.md` §A.3.1):
introducing a fresh unary form `[.newForm 1, .newInst 1 [1]]` on `R3_round1`
preserves both previously separated pairs `(0, 1)` and `(0, 2)` while also
separating `(1, 2)`, completing discrete partition refinement in `2 = n - 1` rounds. -/
theorem rt09_fresh_form_strictly_refines_all_pairs :
    applyDelta4 R3_round1 [.newForm 1, .newInst 1 [1]] = some R3_round2_fresh ∧
    separable4 R3_round2_fresh 0 1 ∧
    separable4 R3_round2_fresh 0 2 ∧
    separable4 R3_round2_fresh 1 2 := by
  exact ⟨by decide,
         ⟨ctxUnary0_4, by decide, by decide⟩,
         ⟨ctxUnary0_4, by decide, by decide⟩,
         ⟨ctxUnary1_4, by decide, by decide⟩⟩

end OmegaCodex.MinimalSeparation
