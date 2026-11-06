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

/-! ## Section 5: OQ-05 General Regime4 Transition-to-Class-Count Growth Bridge -/

theorem mem_foldr_append_iff {α β : Type} (xs : List α) (f : α → List β) (y : β) :
    y ∈ xs.foldr (fun x acc => f x ++ acc) [] ↔ ∃ x ∈ xs, y ∈ f x := by
  induction xs with
  | nil =>
      simp only [List.foldr]
      constructor
      · intro h; cases h
      · rintro ⟨_, hx, _⟩; cases hx
  | cons a tail ih =>
      simp only [List.foldr, List.mem_append, List.mem_cons]
      constructor
      · rintro (hhead | htail)
        · exact ⟨a, Or.inl rfl, hhead⟩
        · rcases ih.mp htail with ⟨x, hx, hy⟩
          exact ⟨x, Or.inr hx, hy⟩
      · rintro ⟨x, rfl | hx, hy⟩
        · exact Or.inl hy
        · exact Or.inr (ih.mpr ⟨x, hx, hy⟩)

def allSlotOptions4 (n : Nat) : List (Option Nat) :=
  none :: (List.range n).map some

theorem mem_allSlotOptions4_iff (n : Nat) (s : Option Nat) :
    s ∈ allSlotOptions4 n ↔ slotOk4 n s := by
  unfold allSlotOptions4
  cases s with
  | none =>
      simp [slotOk4]
  | some x =>
      simp [slotOk4, List.mem_map, List.mem_range]

def allSlotLists4 (n : Nat) : Nat → List (List (Option Nat))
  | 0 => [[]]
  | k + 1 =>
      (allSlotOptions4 n).foldr (fun s acc =>
        (allSlotLists4 n k).map (fun rest => s :: rest) ++ acc) []

theorem mem_allSlotLists4_iff (n k : Nat) (slots : List (Option Nat)) :
    slots ∈ allSlotLists4 n k ↔
      slots.length = k ∧ ∀ s ∈ slots, slotOk4 n s := by
  induction k generalizing slots with
  | zero =>
      cases slots with
      | nil =>
          simp [allSlotLists4]
      | cons s rest =>
          simp [allSlotLists4]
  | succ k ih =>
      unfold allSlotLists4
      rw [mem_foldr_append_iff]
      constructor
      · rintro ⟨s, hs, hmem⟩
        rcases List.mem_map.mp hmem with ⟨rest, hrest, rfl⟩
        rcases (ih rest).mp hrest with ⟨hlen, hall⟩
        have hsok : slotOk4 n s := (mem_allSlotOptions4_iff n s).mp hs
        refine ⟨by simp [hlen], ?_⟩
        intro x hx
        rcases List.mem_cons.mp hx with rfl | hx'
        · exact hsok
        · exact hall x hx'
      · rintro ⟨hlen, hall⟩
        cases slots with
        | nil => cases hlen
        | cons s rest =>
            have hlen' : rest.length = k := by simpa using hlen
            have hs : s ∈ allSlotOptions4 n :=
              (mem_allSlotOptions4_iff n s).mpr (hall s (List.Mem.head _))
            have hrest : rest ∈ allSlotLists4 n k :=
              (ih rest).mpr ⟨hlen', fun x hx => hall x (List.Mem.tail _ hx)⟩
            exact ⟨s, hs, List.mem_map.mpr ⟨rest, hrest, rfl⟩⟩

def allWfCtxs4 (r : Regime4) : List Ctx4 :=
  (List.range r.forms.length).foldr (fun f acc =>
    (((allSlotLists4 r.data (r.forms.getD f 0)).filter (fun slots => decide (none ∈ slots))).map
      (fun slots => (⟨f, slots⟩ : Ctx4))) ++ acc) []

theorem mem_allWfCtxs4_iff (r : Regime4) (c : Ctx4) :
    c ∈ allWfCtxs4 r ↔ wfCtx4 r c := by
  rcases c with ⟨f, slots⟩
  unfold allWfCtxs4 wfCtx4
  rw [mem_foldr_append_iff]
  constructor
  · rintro ⟨f', hf', hmem⟩
    rcases List.mem_map.mp hmem with ⟨slots', hfilt, hceq⟩
    rcases Ctx4.mk.inj hceq with ⟨rfl, rfl⟩
    rcases List.mem_filter.mp hfilt with ⟨hsl, hnone⟩
    rcases (mem_allSlotLists4_iff r.data (r.forms.getD f' 0) slots').mp hsl with ⟨hlen, hall⟩
    exact ⟨List.mem_range.mp hf', hlen, of_decide_eq_true hnone, hall⟩
  · rintro ⟨hf, hlen, hnone, hall⟩
    refine ⟨f, List.mem_range.mpr hf, ?_⟩
    apply List.mem_map.mpr
    refine ⟨slots, List.mem_filter.mpr ⟨?_, decide_eq_true hnone⟩, rfl⟩
    exact (mem_allSlotLists4_iff r.data (r.forms.getD f 0) slots).mpr ⟨hlen, hall⟩

theorem list_all_eq_true_iff4 {α : Type} (xs : List α) (p : α → Bool) :
    xs.all p = true ↔ ∀ x ∈ xs, p x = true := by
  induction xs with
  | nil =>
      simp only [List.all]
      constructor
      · intro _ x hx; cases hx
      · intro _; trivial
  | cons a tail ih =>
      simp only [List.all, Bool.and_eq_true, List.mem_cons]
      constructor
      · rintro ⟨hpa, htail⟩ x (rfl | hx)
        · exact hpa
        · exact ih.mp htail x hx
      · intro hall
        exact ⟨hall a (Or.inl rfl), ih.mpr (fun x hx => hall x (Or.inr hx))⟩

theorem list_all_eq_false_iff4 {α : Type} (xs : List α) (p : α → Bool) :
    xs.all p = false ↔ ∃ x ∈ xs, p x = false := by
  induction xs with
  | nil =>
      simp only [List.all]
      constructor
      · intro h; cases h
      · rintro ⟨_, hx, _⟩; cases hx
  | cons a tail ih =>
      simp only [List.all, List.mem_cons]
      cases hpa : p a with
      | false =>
          simp only [Bool.false_and]
          exact ⟨fun _ => ⟨a, Or.inl rfl, hpa⟩, fun _ => trivial⟩
      | true =>
          simp only [Bool.true_and]
          constructor
          · intro htail
            rcases ih.mp htail with ⟨x, hx, hpx⟩
            exact ⟨x, Or.inr hx, hpx⟩
          · rintro ⟨x, rfl | hx, hpx⟩
            · rw [hpa] at hpx; cases hpx
            · exact ih.mpr ⟨x, hx, hpx⟩

theorem derivable4Bool_beq_eq_true_iff (r : Regime4) (i1 i2 : Inst4) :
    (derivable4Bool r i1 == derivable4Bool r i2) = true ↔
      (derivable4 r i1 ↔ derivable4 r i2) := by
  unfold derivable4Bool
  by_cases h1 : derivable4 r i1 <;> by_cases h2 : derivable4 r i2 <;>
    simp [h1, h2]

theorem derivable4Bool_beq_eq_false_iff (r : Regime4) (i1 i2 : Inst4) :
    (derivable4Bool r i1 == derivable4Bool r i2) = false ↔
      ¬ (derivable4 r i1 ↔ derivable4 r i2) := by
  cases hbeq : (derivable4Bool r i1 == derivable4Bool r i2) with
  | false =>
      constructor
      · intro _ hiff
        have htrue := (derivable4Bool_beq_eq_true_iff r i1 i2).mpr hiff
        rw [hbeq] at htrue
        cases htrue
      · intro _; rfl
  | true =>
      have hiff := (derivable4Bool_beq_eq_true_iff r i1 i2).mp hbeq
      constructor
      · intro h; cases h
      · intro hne; exact False.elim (hne hiff)

def collapsed4Bool (r : Regime4) (d d' : Nat) : Bool :=
  (allWfCtxs4 r).all (fun c => derivable4Bool r (plug4 c d) == derivable4Bool r (plug4 c d'))

theorem collapsed4_iff_collapsed4Bool (r : Regime4) (d d' : Nat) :
    collapsed4 r d d' ↔ collapsed4Bool r d d' = true := by
  unfold collapsed4 collapsed4Bool
  rw [list_all_eq_true_iff4]
  constructor
  · intro h c hc
    exact (derivable4Bool_beq_eq_true_iff r (plug4 c d) (plug4 c d')).mpr
      (h c ((mem_allWfCtxs4_iff r c).mp hc))
  · intro h c hwf
    exact (derivable4Bool_beq_eq_true_iff r (plug4 c d) (plug4 c d')).mp
      (h c ((mem_allWfCtxs4_iff r c).mpr hwf))

theorem separable4_iff_collapsed4Bool_false (r : Regime4) (d d' : Nat) :
    separable4 r d d' ↔ collapsed4Bool r d d' = false := by
  unfold separable4 collapsed4Bool
  rw [list_all_eq_false_iff4]
  constructor
  · rintro ⟨c, hwf, hne⟩
    exact ⟨c, (mem_allWfCtxs4_iff r c).mpr hwf,
      (derivable4Bool_beq_eq_false_iff r (plug4 c d) (plug4 c d')).mpr hne⟩
  · rintro ⟨c, hc, hfalse⟩
    exact ⟨c, (mem_allWfCtxs4_iff r c).mp hc,
      (derivable4Bool_beq_eq_false_iff r (plug4 c d) (plug4 c d')).mp hfalse⟩

instance (r : Regime4) (d d' : Nat) : Decidable (collapsed4 r d d') :=
  decidable_of_iff (collapsed4Bool r d d' = true) (collapsed4_iff_collapsed4Bool r d d').symm

instance (r : Regime4) (d d' : Nat) : Decidable (separable4 r d d') :=
  decidable_of_iff (collapsed4Bool r d d' = false) (separable4_iff_collapsed4Bool_false r d d').symm

def hasEarlierEquiv4 (eqv : Nat → Nat → Bool) (x : Nat) : Nat → Bool
  | 0 => false
  | y + 1 => eqv y x || hasEarlierEquiv4 eqv x y

theorem hasEarlierEquiv4_iff (eqv : Nat → Nat → Bool) (x bound : Nat) :
    hasEarlierEquiv4 eqv x bound = true ↔ ∃ y < bound, eqv y x = true := by
  induction bound with
  | zero =>
      simp only [hasEarlierEquiv4]
      constructor
      · intro h; cases h
      · rintro ⟨y, hy, _⟩; omega
  | succ y ih =>
      simp only [hasEarlierEquiv4, Bool.or_eq_true]
      constructor
      · rintro (hyx | hprev)
        · exact ⟨y, Nat.lt_succ_self y, hyx⟩
        · rcases ih.mp hprev with ⟨z, hz, hzx⟩
          exact ⟨z, Nat.lt_trans hz (Nat.lt_succ_self y), hzx⟩
      · rintro ⟨z, hz, hzx⟩
        rcases Nat.lt_or_eq_of_le (Nat.le_of_lt_succ hz) with hlt | rfl
        · exact Or.inr (ih.mpr ⟨z, hlt, hzx⟩)
        · exact Or.inl hzx

theorem hasEarlierEquiv4_eq_false_iff (eqv : Nat → Nat → Bool) (x bound : Nat) :
    hasEarlierEquiv4 eqv x bound = false ↔ ∀ y < bound, eqv y x = false := by
  cases h : hasEarlierEquiv4 eqv x bound with
  | false =>
      constructor
      · intro _ y hy
        cases hyx : eqv y x with
        | false => rfl
        | true =>
            have htrue := (hasEarlierEquiv4_iff eqv x bound).mpr ⟨y, hy, hyx⟩
            rw [h] at htrue
            cases htrue
      · intro _; rfl
  | true =>
      rcases (hasEarlierEquiv4_iff eqv x bound).mp h with ⟨y, hy, hyx⟩
      constructor
      · intro hfalse; cases hfalse
      · intro hall
        have hfalse := hall y hy
        rw [hyx] at hfalse
        cases hfalse

def isRep4 (eqv : Nat → Nat → Bool) (x : Nat) : Bool :=
  !hasEarlierEquiv4 eqv x x

theorem isRep4_iff (eqv : Nat → Nat → Bool) (x : Nat) :
    isRep4 eqv x = true ↔ ∀ y < x, eqv y x = false := by
  unfold isRep4
  rw [Bool.not_eq_true']
  exact hasEarlierEquiv4_eq_false_iff eqv x x

theorem isRep4_eq_false_iff (eqv : Nat → Nat → Bool) (x : Nat) :
    isRep4 eqv x = false ↔ ∃ y < x, eqv y x = true := by
  unfold isRep4
  rw [Bool.not_eq_false']
  exact hasEarlierEquiv4_iff eqv x x

def boolToNat4 : Bool → Nat
  | false => 0
  | true  => 1

def classCount4 (eqv : Nat → Nat → Bool) : Nat → Nat
  | 0 => 0
  | k + 1 => classCount4 eqv k + boolToNat4 (isRep4 eqv k)

theorem classCount4_le (eqv : Nat → Nat → Bool) (n : Nat) :
    classCount4 eqv n ≤ n := by
  induction n with
  | zero => exact Nat.le_refl 0
  | succ k ih =>
      unfold classCount4
      cases isRep4 eqv k <;> simp [boolToNat4] <;> omega

theorem classCount4_pos_of_pos (eqv : Nat → Nat → Bool) {n : Nat} (hn : 1 ≤ n) :
    1 ≤ classCount4 eqv n := by
  induction n with
  | zero => omega
  | succ k ih =>
      cases k with
      | zero =>
          change 1 ≤ 0 + 1
          exact Nat.le_refl 1
      | succ k' =>
          have ih' := ih (by omega)
          unfold classCount4
          omega

theorem classCount4_mono_of_imp (p q : Nat → Nat → Bool) (n : Nat)
    (himp : ∀ x < n, isRep4 p x = true → isRep4 q x = true) :
    classCount4 p n ≤ classCount4 q n := by
  induction n with
  | zero => exact Nat.le_refl 0
  | succ k ih =>
      have hsub : classCount4 p k ≤ classCount4 q k :=
        ih (fun x hx => himp x (Nat.lt_trans hx (Nat.lt_succ_self k)))
      have hk := himp k (Nat.lt_succ_self k)
      unfold classCount4
      cases hp : isRep4 p k with
      | false =>
          cases hq : isRep4 q k <;> simp [boolToNat4] <;> omega
      | true =>
          have hq : isRep4 q k = true := hk hp
          rw [hq]
          simp [boolToNat4]
          omega

theorem classCount4_strict_mono_of_witness (p q : Nat → Nat → Bool) (n : Nat)
    (himp : ∀ x < n, isRep4 p x = true → isRep4 q x = true)
    (hwit : ∃ w < n, isRep4 p w = false ∧ isRep4 q w = true) :
    classCount4 p n + 1 ≤ classCount4 q n := by
  induction n with
  | zero =>
      rcases hwit with ⟨w, hw, _⟩
      omega
  | succ k ih =>
      rcases hwit with ⟨w, hw, hpw, hqw⟩
      rcases Nat.lt_or_eq_of_le (Nat.le_of_lt_succ hw) with hlt | heq
      · have ih' := ih (fun x hx => himp x (Nat.lt_trans hx (Nat.lt_succ_self k)))
          ⟨w, hlt, hpw, hqw⟩
        have hk := himp k (Nat.lt_succ_self k)
        unfold classCount4
        cases hp : isRep4 p k with
        | false =>
            cases hq : isRep4 q k <;> simp [boolToNat4] <;> omega
        | true =>
            have hq : isRep4 q k = true := hk hp
            rw [hq]
            simp [boolToNat4]
            omega
      · subst w
        have hmono := classCount4_mono_of_imp p q k
          (fun x hx => himp x (Nat.lt_trans hx (Nat.lt_succ_self k)))
        unfold classCount4
        rw [hpw, hqw]
        simp [boolToNat4]
        omega

structure BoolEquivOn4 (n : Nat) (eqv : Nat → Nat → Bool) : Prop where
  refl  : ∀ x < n, eqv x x = true
  symm  : ∀ x < n, ∀ y < n, eqv x y = true → eqv y x = true
  trans : ∀ x < n, ∀ y < n, ∀ z < n, eqv x y = true → eqv y z = true → eqv x z = true

theorem collapsed4Bool_boolEquivOn4 (r : Regime4) :
    BoolEquivOn4 r.data (collapsed4Bool r) where
  refl := fun x _ =>
    (collapsed4_iff_collapsed4Bool r x x).mp ((collapsed4_equivalence r).refl x)
  symm := fun x _ y _ h =>
    (collapsed4_iff_collapsed4Bool r y x).mp
      ((collapsed4_equivalence r).symm ((collapsed4_iff_collapsed4Bool r x y).mpr h))
  trans := fun x _ y _ z _ h1 h2 =>
    (collapsed4_iff_collapsed4Bool r x z).mp
      ((collapsed4_equivalence r).trans
        ((collapsed4_iff_collapsed4Bool r x y).mpr h1)
        ((collapsed4_iff_collapsed4Bool r y z).mpr h2))

theorem exists_rep_of_equiv4_aux {n : Nat} {eqv : Nat → Nat → Bool}
    (heqv : BoolEquivOn4 n eqv) :
    ∀ bound a : Nat, a < bound → a < n → ∃ r ≤ a, eqv r a = true ∧ isRep4 eqv r = true
  | 0, _, hlt, _ => by omega
  | bound + 1, a, hlt, han => by
      cases hrep : isRep4 eqv a with
      | true =>
          exact ⟨a, Nat.le_refl a, heqv.refl a han, hrep⟩
      | false =>
          rcases (isRep4_eq_false_iff eqv a).mp hrep with ⟨y, hya, heqv_ya⟩
          have hy_bound : y < bound := by omega
          have hy_n : y < n := by omega
          rcases exists_rep_of_equiv4_aux heqv bound y hy_bound hy_n with ⟨r, hry, heqv_ry, hrep_r⟩
          have hr_n : r < n := by omega
          exact ⟨r, by omega, heqv.trans r hr_n y hy_n a han heqv_ry heqv_ya, hrep_r⟩

theorem exists_rep_of_equiv4 {n : Nat} {eqv : Nat → Nat → Bool}
    (heqv : BoolEquivOn4 n eqv) {a : Nat} (ha : a < n) :
    ∃ r ≤ a, eqv r a = true ∧ isRep4 eqv r = true :=
  exists_rep_of_equiv4_aux heqv (a + 1) a (Nat.lt_succ_self a) ha

structure StrictRefinementOn4 (n : Nat) (eqv eqv' : Nat → Nat → Bool) : Prop where
  equiv_old : BoolEquivOn4 n eqv
  equiv_new : BoolEquivOn4 n eqv'
  refines   : ∀ x < n, ∀ y < n, eqv' x y = true → eqv x y = true
  new_sep   : ∃ a < n, ∃ b < n, eqv a b = true ∧ eqv' a b = false

theorem isRep4_imp_of_refines {n : Nat} {eqv eqv' : Nat → Nat → Bool}
    (href : ∀ x < n, ∀ y < n, eqv' x y = true → eqv x y = true) :
    ∀ x < n, isRep4 eqv x = true → isRep4 eqv' x = true := by
  intro x hx hrep
  rw [isRep4_iff] at hrep ⊢
  intro y hyx
  have hy : y < n := by omega
  have hold : eqv y x = false := hrep y hyx
  cases hnew : eqv' y x with
  | false => rfl
  | true =>
      have := href y hy x hx hnew
      rw [hold] at this
      cases this

theorem exists_new_rep_of_strictRefinementOn4 {n : Nat} {eqv eqv' : Nat → Nat → Bool}
    (h : StrictRefinementOn4 n eqv eqv') :
    ∃ w < n, isRep4 eqv w = false ∧ isRep4 eqv' w = true := by
  rcases h.new_sep with ⟨a, ha, b, hb, heqv_ab, hneqv'_ab⟩
  rcases exists_rep_of_equiv4 h.equiv_new ha with ⟨ra, hra_le, heqv'_ra, hrep'_ra⟩
  rcases exists_rep_of_equiv4 h.equiv_new hb with ⟨rb, hrb_le, heqv'_rb, hrep'_rb⟩
  have hra_n : ra < n := by omega
  have hrb_n : rb < n := by omega
  have heqv_ra_a : eqv ra a = true := h.refines ra hra_n a ha heqv'_ra
  have heqv_rb_b : eqv rb b = true := h.refines rb hrb_n b hb heqv'_rb
  have heqv_ra_b : eqv ra b = true :=
    h.equiv_old.trans ra hra_n a ha b hb heqv_ra_a heqv_ab
  have heqv_b_rb : eqv b rb = true :=
    h.equiv_old.symm rb hrb_n b hb heqv_rb_b
  have heqv_ra_rb : eqv ra rb = true :=
    h.equiv_old.trans ra hra_n b hb rb hrb_n heqv_ra_b heqv_b_rb
  have heqv_rb_ra : eqv rb ra = true :=
    h.equiv_old.symm ra hra_n rb hrb_n heqv_ra_rb
  have hne : ra ≠ rb := by
    intro heq
    subst heq
    have ha_ra : eqv' a ra = true := h.equiv_new.symm ra hra_n a ha heqv'_ra
    have hab' : eqv' a b = true := h.equiv_new.trans a ha ra hra_n b hb ha_ra heqv'_rb
    rw [hneqv'_ab] at hab'
    cases hab'
  rcases Nat.lt_or_gt_of_ne hne with hlt | hgt
  · refine ⟨rb, hrb_n, ?_, hrep'_rb⟩
    exact (isRep4_eq_false_iff eqv rb).mpr ⟨ra, hlt, heqv_ra_rb⟩
  · refine ⟨ra, hra_n, ?_, hrep'_ra⟩
    exact (isRep4_eq_false_iff eqv ra).mpr ⟨rb, hgt, heqv_rb_ra⟩

theorem strict_refinement_classCount4_inc {n : Nat} {eqv eqv' : Nat → Nat → Bool}
    (h : StrictRefinementOn4 n eqv eqv') :
    classCount4 eqv n + 1 ≤ classCount4 eqv' n ∧ classCount4 eqv' n ≤ n :=
  ⟨classCount4_strict_mono_of_witness eqv eqv' n
     (isRep4_imp_of_refines h.refines)
     (exists_new_rep_of_strictRefinementOn4 h),
   classCount4_le eqv' n⟩

def regimeClassCount4 (r : Regime4) : Nat :=
  classCount4 (collapsed4Bool r) r.data

theorem regimeClassCount4_le (r : Regime4) :
    regimeClassCount4 r ≤ r.data :=
  classCount4_le (collapsed4Bool r) r.data

theorem regimeClassCount4_pos (r : Regime4) (hdata : 1 ≤ r.data) :
    1 ≤ regimeClassCount4 r :=
  classCount4_pos_of_pos (collapsed4Bool r) hdata

structure StrictRegimeTransition4 (r s : Regime4) : Prop where
  same_data     : s.data = r.data
  preserves_sep : ∀ x < r.data, ∀ y < r.data, separable4 r x y → separable4 s x y
  new_sep       : ∃ a < r.data, ∃ b < r.data, collapsed4 r a b ∧ separable4 s a b

theorem strictRegimeTransition4_to_strictRefinementOn4 {r s : Regime4}
    (h : StrictRegimeTransition4 r s) :
    StrictRefinementOn4 r.data (collapsed4Bool r) (collapsed4Bool s) where
  equiv_old := collapsed4Bool_boolEquivOn4 r
  equiv_new := h.same_data ▸ collapsed4Bool_boolEquivOn4 s
  refines := by
    intro x hx y hy hs_col
    cases hr_col : collapsed4Bool r x y with
    | true => rfl
    | false =>
        have hsep_r : separable4 r x y :=
          (separable4_iff_collapsed4Bool_false r x y).mpr hr_col
        have hsep_s : separable4 s x y := h.preserves_sep x hx y hy hsep_r
        have hs_false : collapsed4Bool s x y = false :=
          (separable4_iff_collapsed4Bool_false s x y).mp hsep_s
        rw [hs_false] at hs_col
        cases hs_col
  new_sep := by
    rcases h.new_sep with ⟨a, ha, b, hb, hcol_r, hsep_s⟩
    exact ⟨a, ha, b, hb,
      (collapsed4_iff_collapsed4Bool r a b).mp hcol_r,
      (separable4_iff_collapsed4Bool_false s a b).mp hsep_s⟩

theorem regime4_strict_class_count_growth {r s : Regime4}
    (h : StrictRegimeTransition4 r s) :
    regimeClassCount4 r + 1 ≤ regimeClassCount4 s ∧
    regimeClassCount4 s ≤ s.data := by
  unfold regimeClassCount4
  rw [h.same_data]
  exact strict_refinement_classCount4_inc (strictRegimeTransition4_to_strictRefinementOn4 h)

def freshUnaryDelta4 (r : Regime4) (target : Nat) : List Item4 :=
  [.newForm 1, .newInst r.forms.length [target]]

def stepFreshUnary4 (r : Regime4) (target : Nat) : Regime4 :=
  ⟨r.data, r.forms ++ [1], insertNew4 r.insts (r.forms.length, [target]), r.reqs⟩

theorem getD_append_last4 (forms : List Nat) (k : Nat) :
    (forms ++ [k]).getD forms.length 0 = k := by
  induction forms with
  | nil => rfl
  | cons _ tail ih => exact ih

theorem mem_insertNew4_iff {α : Type} [DecidableEq α] (l : List α) (a x : α) :
    x ∈ insertNew4 l a ↔ x ∈ l ∨ x = a := by
  unfold insertNew4
  by_cases ha : a ∈ l
  · rw [if_pos ha]
    constructor
    · intro hx; exact Or.inl hx
    · rintro (hx | rfl)
      · exact hx
      · exact ha
  · rw [if_neg ha, List.mem_append, List.mem_singleton]

theorem applyDelta4_freshUnaryDelta4 (r : Regime4) {target : Nat} (ht : target < r.data) :
    applyDelta4 r (freshUnaryDelta4 r target) = some (stepFreshUnary4 r target) := by
  unfold freshUnaryDelta4
  rw [applyDelta4_pair]
  have h1 : applyItem4 r (.newForm 1) = some ⟨r.data, r.forms ++ [1], r.insts, r.reqs⟩ := rfl
  rw [h1]
  simp only [Option.bind, applyItem4]
  have hcond :
      r.forms.length < (r.forms ++ [1]).length ∧
      ([target] : List Nat).length = (r.forms ++ [1]).getD r.forms.length 0 ∧
      (∀ x ∈ ([target] : List Nat), x < r.data) := by
    refine ⟨?_, ?_, ?_⟩
    · simp [List.length_append]
    · rw [getD_append_last4 r.forms 1]
      rfl
    · intro x hx
      rcases List.mem_singleton.mp hx with rfl
      exact ht
  rw [if_pos hcond]
  rfl

theorem stepFreshUnary4_strict_transition (r : Regime4)
    (hwf : ∀ p ∈ r.insts, p.1 < r.forms.length)
    {target other : Nat} (ht : target < r.data) (ho : other < r.data)
    (hcol : collapsed4 r target other) (hne : target ≠ other) :
    StrictRegimeTransition4 r (stepFreshUnary4 r target) where
  same_data := rfl
  preserves_sep := by
    intro x _ y _ ⟨c, hwfc, hnec⟩
    refine ⟨c, ?_, ?_⟩
    · refine ⟨?_, ?_, hwfc.2.2.1, hwfc.2.2.2⟩
      · show c.form < (r.forms ++ [1]).length
        have := hwfc.1
        simp [List.length_append]
        omega
      · show c.slots.length = (r.forms ++ [1]).getD c.form 0
        rw [getD_append_left4 r.forms 1 c.form hwfc.1]
        exact hwfc.2.1
    · have hder_eq : ∀ d, derivable4 (stepFreshUnary4 r target) (plug4 c d) ↔
          derivable4 r (plug4 c d) := by
        intro d
        unfold derivable4 stepFreshUnary4
        rw [mem_insertNew4_iff]
        constructor
        · rintro (hmem | heq)
          · exact hmem
          · have hform : c.form = r.forms.length := congrArg Prod.fst heq
            have hlt := hwfc.1
            omega
        · intro hmem
          exact Or.inl hmem
      intro hiff
      exact hnec ((hder_eq x).symm.trans (hiff.trans (hder_eq y)))
  new_sep := by
    refine ⟨target, ht, other, ho, hcol, ?_⟩
    refine ⟨⟨r.forms.length, [none]⟩, ?_, ?_⟩
    · refine ⟨?_, ?_, List.Mem.head _, ?_⟩
      · show r.forms.length < (r.forms ++ [1]).length
        simp [List.length_append]
      · show ([none] : List (Option Nat)).length = (r.forms ++ [1]).getD r.forms.length 0
        rw [getD_append_last4 r.forms 1]
        rfl
      · intro s hs
        rcases List.mem_singleton.mp hs with rfl
        trivial
    · intro hiff
      have h_target : derivable4 (stepFreshUnary4 r target) (plug4 ⟨r.forms.length, [none]⟩ target) := by
        unfold derivable4 stepFreshUnary4 plug4
        exact (mem_insertNew4_iff r.insts (r.forms.length, [target]) (r.forms.length, [target])).mpr
          (Or.inr rfl)
      have h_other := hiff.mp h_target
      unfold derivable4 stepFreshUnary4 plug4 at h_other
      rcases (mem_insertNew4_iff r.insts (r.forms.length, [target]) (r.forms.length, [other])).mp h_other with
        hmem | heq
      · have hlt := hwf (r.forms.length, [other]) hmem
        change r.forms.length < r.forms.length at hlt
        omega
      · have harg : ([other] : List Nat) = [target] := congrArg Prod.snd heq
        cases harg
        exact hne rfl

theorem stepFreshUnary4_class_count_growth (r : Regime4)
    (hwf : ∀ p ∈ r.insts, p.1 < r.forms.length)
    {target other : Nat} (ht : target < r.data) (ho : other < r.data)
    (hcol : collapsed4 r target other) (hne : target ≠ other) :
    regimeClassCount4 r + 1 ≤ regimeClassCount4 (stepFreshUnary4 r target) ∧
    regimeClassCount4 (stepFreshUnary4 r target) ≤ r.data :=
  regime4_strict_class_count_growth
    (stepFreshUnary4_strict_transition r hwf ht ho hcol hne)

inductive RegimeRefinementRun4 : Regime4 → Nat → Prop where
  | nil (r : Regime4) : RegimeRefinementRun4 r 0
  | step {r s : Regime4} {m : Nat}
      (htrans : StrictRegimeTransition4 r s)
      (hrest : RegimeRefinementRun4 s m) :
      RegimeRefinementRun4 r (m + 1)

theorem regimeRefinementRun4_to_quotRefRun {r : Regime4} {m : Nat}
    (hrun : RegimeRefinementRun4 r m) :
    QuotRefRun r.data (regimeClassCount4 r) m := by
  induction hrun with
  | nil r =>
      exact QuotRefRun.nil (regimeClassCount4 r) (regimeClassCount4_le r)
  | step htrans _ ih =>
      have hgrowth := (regime4_strict_class_count_growth htrans).1
      rw [← htrans.same_data]
      exact QuotRefRun.step hgrowth ih

theorem regimeRefinementRun4_round_bound {r : Regime4} {m : Nat}
    (hdata : 1 ≤ r.data) (hrun : RegimeRefinementRun4 r m) :
    m ≤ r.data - 1 :=
  quotient_refinement_from_one
    (regimeClassCount4_pos r hdata)
    (regimeRefinementRun4_to_quotRefRun hrun)

theorem rt09_class_count_comparison :
    regimeClassCount4 R3_round1 = 2 ∧
    regimeClassCount4 R3_round2_recollapse = 2 ∧
    regimeClassCount4 R3_round2_fresh = 3 := by
  decide

end OmegaCodex.MinimalSeparation

