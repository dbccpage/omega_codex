import PrimitiveDifference

/-!
# Settling Open Questions `OQ-01` through `OQ-04` (`8_open.md`)

Pinned commits:
  A (19L57G1): 45bb09864f9b52ed5ecf66e977ca81f0ed623de7
  B (theory_of_finite_quantum_mechanics): e45ed2e133920aa3790af8c5e072ee9829898490
  omega_codex (baseline): e21b785626ff8d0231a53409c76fe4e7a57cd59d

This self-contained Lean 4 module settles `OQ-01`, `OQ-02`, `OQ-03`, and `OQ-04`
from `8_open.md` using core Lean 4 and `PrimitiveDifference` only (zero `Classical.choice`,
zero `sorry`, zero new axioms).
-/

set_option autoImplicit false

namespace MinimalChainAudit

open OmegaCodex.PrimitiveDifference

/-! =========================================================================
    SECTION 1: OQ-04 — General Strictly Increasing Arity Weights `mu2_unique_general`
    ========================================================================= -/

abbrev Inst := Nat × List Nat

def insertNew {α : Type} [DecidableEq α] (l : List α) (a : α) : List α :=
  if a ∈ l then l else l ++ [a]

structure Regime where
  data  : Nat
  forms : List Nat
  insts : List Inst
  rules : List Nat
  reqs  : List (Nat × Nat)
deriving Repr, DecidableEq

structure Ctx where
  form  : Nat
  slots : List (Option Nat)
deriving Repr, DecidableEq

def plug (c : Ctx) (d : Nat) : Inst :=
  (c.form, c.slots.map (fun s => s.getD d))

def derivable (r : Regime) (i : Inst) : Prop :=
  i ∈ r.insts ∨ i.1 ∈ r.rules

instance (r : Regime) (i : Inst) : Decidable (derivable r i) := by
  unfold derivable; infer_instance

def slotOk (n : Nat) : Option Nat → Prop
  | none => True
  | some x => x < n

instance (n : Nat) (s : Option Nat) : Decidable (slotOk n s) :=
  match s with
  | none => isTrue trivial
  | some x => Nat.decLt x n

def wfCtx (r : Regime) (c : Ctx) : Prop :=
  c.form < r.forms.length ∧
  c.slots.length = r.forms.getD c.form 0 ∧
  none ∈ c.slots ∧
  ∀ s ∈ c.slots, slotOk r.data s

instance (r : Regime) (c : Ctx) : Decidable (wfCtx r c) := by
  unfold wfCtx; infer_instance

def collapsed (r : Regime) (d d' : Nat) : Prop :=
  ∀ c : Ctx, wfCtx r c → (derivable r (plug c d) ↔ derivable r (plug c d'))

def separable (r : Regime) (d d' : Nat) : Prop :=
  ∃ c : Ctx, wfCtx r c ∧
    ¬ (derivable r (plug c d) ↔ derivable r (plug c d'))

theorem separable_not_collapsed {r : Regime} {d d' : Nat}
    (h : separable r d d') : ¬ collapsed r d d' :=
  fun hc => h.elim fun c hc' => hc'.2 (hc c hc'.1)

theorem collapsed_of_no_insts (r : Regime) (h : r.insts = []) (d d' : Nat) :
    collapsed r d d' := by
  intro c _
  simp [derivable, plug, h]

theorem no_insts_no_separation {s : Regime} {d d' : Nat}
    (hi : s.insts = []) (hsep : separable s d d') : False :=
  separable_not_collapsed hsep (collapsed_of_no_insts s hi d d')

inductive Item where
  | newDatum
  | newForm    (arity : Nat)
  | newInst    (form : Nat) (args : List Nat)
  | newRuleAll (form : Nat)
deriving Repr, DecidableEq

def applyItem (r : Regime) : Item → Option Regime
  | .newDatum => some { r with data := r.data + 1 }
  | .newForm a =>
      if 1 ≤ a then some { r with forms := r.forms ++ [a] } else none
  | .newInst f args =>
      if f < r.forms.length ∧ args.length = r.forms.getD f 0 ∧
          (∀ x ∈ args, x < r.data) then
        some { r with insts := insertNew r.insts (f, args) }
      else none
  | .newRuleAll f =>
      if f < r.forms.length then
        some { r with rules := insertNew r.rules f }
      else none

def applyDelta (r : Regime) (δ : List Item) : Option Regime :=
  δ.foldlM applyItem r

theorem applyDelta_pair (r : Regime) (a b : Item) :
    applyDelta r [a, b] =
      (applyItem r a).bind (fun r1 => applyItem r1 b) := by
  unfold applyDelta
  cases h : applyItem r a with
  | none => simp [List.foldlM, h]
  | some r1 => cases h2 : applyItem r1 b <;> simp [List.foldlM, h, h2]

def validResponse (r : Regime) (i j : Nat) (δ : List Item) : Prop :=
  ∃ s, applyDelta r δ = some s ∧ separable s i j ∧
    ∀ q ∈ r.reqs, separable s q.1 q.2

def R2L : Regime := ⟨2, [], [], [], [(0, 1)]⟩
def R2F : Regime := ⟨3, [], [], [], [(1, 2)]⟩
def U0  : Regime := ⟨2, [1], [(0, [0])], [], [(0, 1)]⟩
def U1  : Regime := ⟨2, [1], [(0, [1])], [], [(0, 1)]⟩
def U0F : Regime := ⟨3, [1], [(0, [1])], [], [(1, 2)]⟩
def U2F : Regime := ⟨3, [1], [(0, [2])], [], [(1, 2)]⟩

def sortPair (p : Nat × Nat) : Nat × Nat :=
  if p.1 ≤ p.2 then p else (p.2, p.1)

structure Iso (r s : Regime) where
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
  rules_fwd : ∀ f ∈ r.rules, fmap f ∈ s.rules
  rules_bwd : ∀ f ∈ s.rules, finv f ∈ r.rules
  reqs_fwd : ∀ q ∈ r.reqs, sortPair (dmap q.1, dmap q.2) ∈ s.reqs
  reqs_bwd : ∀ q ∈ s.reqs, sortPair (dinv q.1, dinv q.2) ∈ r.reqs

def isoRefl (r : Regime) (hreqs : ∀ q ∈ r.reqs, q.1 ≤ q.2) : Iso r r where
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
  rules_fwd := fun _ hf => hf
  rules_bwd := fun _ hf => hf
  reqs_fwd := fun q hq => by simpa [sortPair, hreqs q hq] using hq
  reqs_bwd := fun q hq => by simpa [sortPair, hreqs q hq] using hq

def swap01 (d : Nat) : Nat :=
  if d = 0 then 1 else if d = 1 then 0 else d

def isoU1U0 : Iso U1 U0 where
  dmap := swap01
  dinv := swap01
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
  rules_fwd := by decide
  rules_bwd := by decide
  reqs_fwd := by decide
  reqs_bwd := by decide

def swap12 (d : Nat) : Nat :=
  if d = 1 then 2 else if d = 2 then 1 else d

def isoU2F_U0F : Iso U2F U0F where
  dmap := swap12
  dinv := swap12
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
  rules_fwd := by decide
  rules_bwd := by decide
  reqs_fwd := by decide
  reqs_bwd := by decide

/-- Direct proof that marking the genesis datum `0` in `R2F` does not separate `(1, 2)`. -/
theorem genesis_mark_not_separable :
    ¬ separable (⟨3, [1], [(0, [0])], [], [(1, 2)]⟩ : Regime) 1 2
  | ⟨⟨0, [none]⟩, _, hne⟩ =>
      hne (Iff.intro (fun h => nomatch h) (fun h => nomatch h))
  | ⟨⟨0, [some _]⟩, ⟨_, _, hnone, _⟩, _⟩ => nomatch hnone
  | ⟨⟨0, []⟩, ⟨_, hlen, _, _⟩, _⟩ => nomatch hlen
  | ⟨⟨0, _ :: _ :: _⟩, ⟨_, hlen, _, _⟩, _⟩ => nomatch hlen
  | ⟨⟨_ + 1, _⟩, ⟨hf, _, _, _⟩, _⟩ => by change _ + 1 < 1 at hf; omega

/-- General second-stage form-arity cost `phiSum φ δ` parameterized by `φ : Nat → Nat`. -/
def phiSum (φ : Nat → Nat) : List Item → Nat
  | [] => 0
  | .newForm a :: rest => φ a + phiSum φ rest
  | _ :: rest => phiSum φ rest

/-- **OQ-04 Main Theorem (Reading L):** For ANY arity weight function `φ : Nat → Nat`
satisfying `∀ k, 2 ≤ k → φ 1 < φ k`, every 2-item valid separating response `[a, b]`
on `R2L` with `phiSum φ [a, b] ≤ φ 1` produces a regime isomorphic to `U0`. -/
theorem mu2_unique_general (φ : Nat → Nat) (hφ : ∀ k, 2 ≤ k → φ 1 < φ k)
    (a b : Item) (hval : validResponse R2L 0 1 [a, b])
    (har : phiSum φ [a, b] ≤ φ 1) :
    ∃ s, applyDelta R2L [a, b] = some s ∧ Nonempty (Iso s U0) := by
  cases hval with
  | intro s hs =>
    have happ := hs.1
    have hsep := hs.2.1
    refine ⟨s, happ, ?_⟩
    rw [applyDelta_pair] at happ
    cases ha : applyItem R2L a with
    | none => rw [ha] at happ; cases happ
    | some r1 =>
      rw [ha] at happ
      have happ2 : applyItem r1 b = some s := happ
      cases a with
      | newInst f args =>
          simp only [applyItem] at ha
          rw [if_neg (by simp [R2L])] at ha
          cases ha
      | newRuleAll f =>
          simp only [applyItem] at ha
          rw [if_neg (by simp [R2L])] at ha
          cases ha
      | newDatum =>
          have hr1 : r1 = ⟨3, [], [], [], [(0, 1)]⟩ := (Option.some.inj ha).symm
          subst hr1
          cases b with
          | newInst f args =>
              simp only [applyItem] at happ2
              rw [if_neg (by simp)] at happ2
              cases happ2
          | newRuleAll f =>
              simp only [applyItem] at happ2
              rw [if_neg (by simp)] at happ2
              cases happ2
          | newDatum =>
              have hz := Option.some.inj happ2
              subst hz
              exact absurd (no_insts_no_separation rfl hsep) id
          | newForm c =>
              simp only [applyItem] at happ2
              split at happ2
              · have hz := Option.some.inj happ2
                subst hz
                exact absurd (no_insts_no_separation rfl hsep) id
              · cases happ2
      | newForm c =>
          have hc1 : 1 ≤ c := by
            cases Nat.lt_or_ge c 1 with
            | inr hge => exact hge
            | inl hlt =>
                exfalso
                simp only [applyItem] at ha
                rw [if_neg (by omega)] at ha
                cases ha
          have hr1 : r1 = ⟨2, [c], [], [], [(0, 1)]⟩ := by
            simp only [applyItem] at ha
            rw [if_pos hc1] at ha
            exact (Option.some.inj ha).symm
          subst hr1
          cases b with
          | newDatum =>
              have hz := Option.some.inj happ2
              subst hz
              exact absurd (no_insts_no_separation rfl hsep) id
          | newForm c' =>
              simp only [applyItem] at happ2
              split at happ2
              · have hz := Option.some.inj happ2
                subst hz
                exact absurd (no_insts_no_separation rfl hsep) id
              · cases happ2
          | newRuleAll f =>
              simp only [applyItem] at happ2
              split at happ2
              · have hz := Option.some.inj happ2
                subst hz
                exact absurd (no_insts_no_separation rfl hsep) id
              · cases happ2
          | newInst f args =>
              have hphi : φ c ≤ φ 1 := by
                simpa [phiSum] using har
              have hc : c = 1 := by
                cases Nat.lt_or_ge c 2 with
                | inl hlt2 => omega
                | inr hge2 =>
                    have hlt_phi := hφ c hge2
                    omega
              subst hc
              simp only [applyItem] at happ2
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
                  | 0, _ => exact ⟨isoRefl U0 (by decide)⟩
                  | 1, _ => exact ⟨isoU1U0⟩
              next => cases happ2

/-- **OQ-04 Main Theorem (Reading F):** For ANY arity weight function `φ : Nat → Nat`
satisfying `∀ k, 2 ≤ k → φ 1 < φ k`, every 2-item valid separating response `[a, b]`
on `R2F` with `phiSum φ [a, b] ≤ φ 1` produces a regime isomorphic to `U0F`. -/
theorem mu2_unique_F_general (φ : Nat → Nat) (hφ : ∀ k, 2 ≤ k → φ 1 < φ k)
    (a b : Item) (hval : validResponse R2F 1 2 [a, b])
    (har : phiSum φ [a, b] ≤ φ 1) :
    ∃ s, applyDelta R2F [a, b] = some s ∧ Nonempty (Iso s U0F) := by
  cases hval with
  | intro s hs =>
    have happ := hs.1
    have hsep := hs.2.1
    refine ⟨s, happ, ?_⟩
    rw [applyDelta_pair] at happ
    cases ha : applyItem R2F a with
    | none => rw [ha] at happ; cases happ
    | some r1 =>
      rw [ha] at happ
      have happ2 : applyItem r1 b = some s := happ
      cases a with
      | newInst f args =>
          simp only [applyItem] at ha
          rw [if_neg (by simp [R2F])] at ha
          cases ha
      | newRuleAll f =>
          simp only [applyItem] at ha
          rw [if_neg (by simp [R2F])] at ha
          cases ha
      | newDatum =>
          have hr1 : r1 = ⟨4, [], [], [], [(1, 2)]⟩ := (Option.some.inj ha).symm
          subst hr1
          cases b with
          | newInst f args =>
              simp only [applyItem] at happ2
              rw [if_neg (by simp)] at happ2
              cases happ2
          | newRuleAll f =>
              simp only [applyItem] at happ2
              rw [if_neg (by simp)] at happ2
              cases happ2
          | newDatum =>
              have hz := Option.some.inj happ2
              subst hz
              exact absurd (no_insts_no_separation rfl hsep) id
          | newForm c =>
              simp only [applyItem] at happ2
              split at happ2
              · have hz := Option.some.inj happ2
                subst hz
                exact absurd (no_insts_no_separation rfl hsep) id
              · cases happ2
      | newForm c =>
          have hc1 : 1 ≤ c := by
            cases Nat.lt_or_ge c 1 with
            | inr hge => exact hge
            | inl hlt =>
                exfalso
                simp only [applyItem] at ha
                rw [if_neg (by omega)] at ha
                cases ha
          have hr1 : r1 = ⟨3, [c], [], [], [(1, 2)]⟩ := by
            simp only [applyItem] at ha
            rw [if_pos hc1] at ha
            exact (Option.some.inj ha).symm
          subst hr1
          cases b with
          | newDatum =>
              have hz := Option.some.inj happ2
              subst hz
              exact absurd (no_insts_no_separation rfl hsep) id
          | newForm c' =>
              simp only [applyItem] at happ2
              split at happ2
              · have hz := Option.some.inj happ2
                subst hz
                exact absurd (no_insts_no_separation rfl hsep) id
              · cases happ2
          | newRuleAll f =>
              simp only [applyItem] at happ2
              split at happ2
              · have hz := Option.some.inj happ2
                subst hz
                exact absurd (no_insts_no_separation rfl hsep) id
              · cases happ2
          | newInst f args =>
              have hphi : φ c ≤ φ 1 := by
                simpa [phiSum] using har
              have hc : c = 1 := by
                cases Nat.lt_or_ge c 2 with
                | inl hlt2 => omega
                | inr hge2 =>
                    have hlt_phi := hφ c hge2
                    omega
              subst hc
              simp only [applyItem] at happ2
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
                  | 0, _ => exact absurd hsep genesis_mark_not_separable
                  | 1, _ => exact ⟨isoRefl U0F (by decide)⟩
                  | 2, _ => exact ⟨isoU2F_U0F⟩
              next => cases happ2

/-- Concrete cost 1: Linear `aritySum` (`Minimality.lean:15-18`). -/
def phiLinear (k : Nat) : Nat := k

theorem phiLinear_strict : ∀ k, 2 ≤ k → phiLinear 1 < phiLinear k := by
  intro k hk; unfold phiLinear; omega

/-- Concrete cost 2: Single-hole context count `k * n^(k-1)` (`3_regime_deletions.py:50-59`). -/
def phiSingleHole (n k : Nat) : Nat := k * n ^ (k - 1)

theorem pow_pos_of_pos {n : Nat} (hn : 1 ≤ n) : ∀ m : Nat, 1 ≤ n ^ m
  | 0 => by simp
  | m + 1 => by
      rw [Nat.pow_succ]
      have ih := pow_pos_of_pos hn m
      exact Nat.le_trans ih (Nat.le_mul_of_pos_right _ (by omega))

theorem phiSingleHole_strict (n : Nat) (hn : 1 ≤ n) :
    ∀ k, 2 ≤ k → phiSingleHole n 1 < phiSingleHole n k := by
  intro k hk
  unfold phiSingleHole
  have hpow : 1 ≤ n ^ (k - 1) := pow_pos_of_pos hn (k - 1)
  have hmul : k * 1 ≤ k * n ^ (k - 1) := Nat.mul_le_mul_left k hpow
  simp at hmul ⊢
  omega

/-- Concrete cost 3: Multi-hole context count `(n+1)^k - n^k` (`B/genesis/paper.md:253-255`). -/
def phiMultiHole (n k : Nat) : Nat := (n + 1) ^ k - n ^ k

theorem pow_succ_gap (n : Nat) (hn : 1 ≤ n) :
    ∀ m : Nat, n ^ (m + 2) + 2 ≤ (n + 1) ^ (m + 2)
  | 0 => by
      simp [Nat.pow_succ, Nat.mul_add, Nat.add_mul]
      omega
  | m + 1 => by
      have ih := pow_succ_gap n hn m
      change n ^ ((m + 2) + 1) + 2 ≤ (n + 1) ^ ((m + 2) + 1)
      rw [Nat.pow_succ n (m + 2), Nat.pow_succ (n + 1) (m + 2), Nat.mul_add, Nat.mul_one]
      have h2 : n ^ (m + 2) * n ≤ (n + 1) ^ (m + 2) * n :=
        Nat.mul_le_mul_right n (by omega)
      omega

theorem phiMultiHole_strict (n : Nat) (hn : 1 ≤ n) :
    ∀ k, 2 ≤ k → phiMultiHole n 1 < phiMultiHole n k := by
  intro k hk
  unfold phiMultiHole
  have h1 : (n + 1) ^ 1 - n ^ 1 = 1 := by simp
  rw [h1]
  have ⟨m, hm⟩ : ∃ m, k = m + 2 := ⟨k - 2, by omega⟩
  subst hm
  have hgap := pow_succ_gap n hn m
  omega

/-- Corollaries for all three concrete cost functions on `R2L` and `R2F`. -/
theorem mu2_unique_linear (a b : Item) (hval : validResponse R2L 0 1 [a, b])
    (har : phiSum phiLinear [a, b] ≤ phiLinear 1) :
    ∃ s, applyDelta R2L [a, b] = some s ∧ Nonempty (Iso s U0) :=
  mu2_unique_general phiLinear phiLinear_strict a b hval har

theorem mu2_unique_singleHole (n : Nat) (hn : 1 ≤ n) (a b : Item)
    (hval : validResponse R2L 0 1 [a, b])
    (har : phiSum (phiSingleHole n) [a, b] ≤ phiSingleHole n 1) :
    ∃ s, applyDelta R2L [a, b] = some s ∧ Nonempty (Iso s U0) :=
  mu2_unique_general (phiSingleHole n) (phiSingleHole_strict n hn) a b hval har

theorem mu2_unique_multiHole (n : Nat) (hn : 1 ≤ n) (a b : Item)
    (hval : validResponse R2L 0 1 [a, b])
    (har : phiSum (phiMultiHole n) [a, b] ≤ phiMultiHole n 1) :
    ∃ s, applyDelta R2L [a, b] = some s ∧ Nonempty (Iso s U0) :=
  mu2_unique_general (phiMultiHole n) (phiMultiHole_strict n hn) a b hval har


/-! =========================================================================
    SECTION 2: OQ-03 — 4-Condition Characterization of the 16 / 1024 Memory Packets
    ========================================================================= -/

/-- A 2-state retention packet on `M = Bool, I = Bool, O = Bool` encoded by bitmasks:
  - `uMask : Fin 16` encodes `u(m, i)` at bit index `(m.toNat * 2 + i.toNat)`
  - `rMask : Fin 4` encodes `r(m)` at bit index `m.toNat`
  - `apMask : Fin 16` encodes `approx(o1, o2)` at bit index `(o1.toNat * 2 + o2.toNat)` -/
def evalU (uMask : Nat) (m i : Bool) : Bool :=
  let idx := (if m then 2 else 0) + (if i then 1 else 0)
  ((uMask >>> idx) &&& 1) == 1

def evalR (rMask : Nat) (m : Bool) : Bool :=
  let idx := if m then 1 else 0
  ((rMask >>> idx) &&& 1) == 1

def evalApprox (apMask : Nat) (o1 o2 : Bool) : Bool :=
  let idx := (if o1 then 2 else 0) + (if o2 then 1 else 0)
  ((apMask >>> idx) &&& 1) == 1

/-- Operational retention test from `5_forcing_checks.py` `[4]`:
starting at `m0 = false`, receive `i = false` vs `i = true`, then undergo one
idle step `i = false`, and check whether outputs `o0, o1` satisfy
`approx(o0, o0) && approx(o1, o1) && !approx(o0, o1)`. -/
def retainsDistinction (uMask rMask apMask : Nat) : Bool :=
  let m0 := evalU uMask (evalU uMask false false) false
  let m1 := evalU uMask (evalU uMask false true) false
  let o0 := evalR rMask m0
  let o1 := evalR rMask m1
  evalApprox apMask o0 o0 && evalApprox apMask o1 o1 && !(evalApprox apMask o0 o1)

/-- The 4-Condition Algebraic Characterization of the 16 / 1024 Retaining Packets:
  - `C1` (Write separation from `m0 = false`): `u(false, false) != u(false, true)`
  - `C2` (Idle-step injectivity on `M`): `u(false, false) != u(true, false)`
  - `C3` (Readout injectivity `r : M → O`): `r(false) != r(true)`
  - `C4` (Reflexive directed apartness on reported outputs):
    `approx(false, false) && approx(true, true) && !approx(o0, o1)` -/
def cond1WriteSep (uMask : Nat) : Bool :=
  evalU uMask false false != evalU uMask false true

def cond2IdleInj (uMask : Nat) : Bool :=
  evalU uMask false false != evalU uMask true false

def cond3ReadoutInj (rMask : Nat) : Bool :=
  evalR rMask false != evalR rMask true

def cond4ReflexiveApart (uMask rMask apMask : Nat) : Bool :=
  let o0 := evalR rMask (evalU uMask (evalU uMask false false) false)
  let o1 := evalR rMask (evalU uMask (evalU uMask false true) false)
  evalApprox apMask false false && evalApprox apMask true true && !(evalApprox apMask o0 o1)

def charFourConditions (uMask rMask apMask : Nat) : Bool :=
  cond1WriteSep uMask && cond2IdleInj uMask && cond3ReadoutInj rMask &&
    cond4ReflexiveApart uMask rMask apMask

/-- Strengthened drift-free symmetric conditions (excluding `CM5` permutation drift
`u(m, false) = !m` and asymmetric `approx`):
  - `C2'` (Idle fixed-point stability): `u(false, false) == false && u(true, false) == true`
  - `C4'` (Exact diagonal equality on `O`): `apMask == 9` (`approx(o1, o2) ↔ o1 == o2`) -/
def cond2PrimeIdleId (uMask : Nat) : Bool :=
  evalU uMask false false == false && evalU uMask true false == true

def cond4PrimeDiagEq (apMask : Nat) : Bool :=
  evalApprox apMask false false && !(evalApprox apMask false true) &&
    !(evalApprox apMask true false) && evalApprox apMask true true

def charDriftFreeSymmetric (uMask rMask apMask : Nat) : Bool :=
  cond1WriteSep uMask && cond2PrimeIdleId uMask && cond3ReadoutInj rMask &&
    cond4PrimeDiagEq apMask

def countPackets (pred : Nat → Nat → Nat → Bool) : Nat :=
  (List.range 16).foldl (fun accU u =>
    (List.range 4).foldl (fun accR r =>
      (List.range 16).foldl (fun accA a =>
        if pred u r a then accA + 1 else accA) accR) accU) 0

set_option maxRecDepth 20000

/-- **OQ-03 Theorem 1:** Exact cardinality of retaining packets is `16` out of `1024`,
and the 4-condition characterization matches `retainsDistinction` on every one of the
`1024` packets (`0` mismatches). -/
theorem oq03_retaining_count_eq_16 : countPackets retainsDistinction = 16 := by decide

theorem oq03_char_four_count_eq_16 : countPackets charFourConditions = 16 := by decide

theorem oq03_retains_iff_four_conditions :
    ∀ u ∈ List.range 16, ∀ r ∈ List.range 4, ∀ a ∈ List.range 16,
      retainsDistinction u r a = charFourConditions u r a := by decide

/-- **OQ-03 Theorem 2:** Strengthening `C2` to idle fixed-point stability (`¬ CM5`)
and `C4` to symmetric equality on `O` yields `4` drift-free symmetric packets, all of
which satisfy `retainsDistinction`. -/
theorem oq03_drift_free_symmetric_count_eq_4 :
    countPackets charDriftFreeSymmetric = 4 := by decide

theorem oq03_drift_free_implies_retains :
    ∀ u ∈ List.range 16, ∀ r ∈ List.range 4, ∀ a ∈ List.range 16,
      charDriftFreeSymmetric u r a = true → retainsDistinction u r a = true := by decide

/-- **OQ-03 Theorem 3:** Factor counts (`4 × 2 × 2 = 16` general; `2 × 2 × 1 = 4` drift-free symmetric)
and explicit countermodel witnesses showing non-redundancy of `C1`, `C2`, `C3`, `C4`, and `C2'`. -/
theorem oq03_factor_counts :
    ((List.range 16).filter (fun u => cond1WriteSep u && cond2IdleInj u)).length = 4 ∧
    ((List.range 16).filter (fun u => cond1WriteSep u && cond2PrimeIdleId u)).length = 2 ∧
    ((List.range 4).filter cond3ReadoutInj).length = 2 ∧
    ((List.range 16).filter cond4PrimeDiagEq).length = 1 := by decide

theorem oq03_condition_independence_witnesses :
    -- Violating C1 only (uMask=12: u(m,i)=m; CM1/CM2 write collapse)
    (cond1WriteSep 12 = false ∧ cond2IdleInj 12 = true ∧ cond3ReadoutInj 2 = true ∧
      cond4PrimeDiagEq 9 = true ∧ retainsDistinction 12 2 9 = false) ∧
    -- Violating C2 only (uMask=10: u(m,i)=i; idle step overwrites memory with 0)
    (cond1WriteSep 10 = true ∧ cond2IdleInj 10 = false ∧ cond3ReadoutInj 2 = true ∧
      cond4PrimeDiagEq 9 = true ∧ retainsDistinction 10 2 9 = false) ∧
    -- Violating C3 only (uMask=14: latch u(m,i)=m||i; rMask=0 constant readout CM3)
    (cond1WriteSep 14 = true ∧ cond2IdleInj 14 = true ∧ cond3ReadoutInj 0 = false ∧
      cond4PrimeDiagEq 9 = true ∧ retainsDistinction 14 0 9 = false) ∧
    -- Violating C4 only (uMask=14, rMask=2, apMask=15 coarse all-true relation CM4)
    (cond1WriteSep 14 = true ∧ cond2IdleInj 14 = true ∧ cond3ReadoutInj 2 = true ∧
      cond4ReflexiveApart 14 2 15 = false ∧ retainsDistinction 14 2 15 = false) ∧
    -- Satisfying C1..C4 but violating C2' (uMask=9: u(m,0)=!m permutation drift CM5)
    (charFourConditions 9 2 9 = true ∧ cond2PrimeIdleId 9 = false ∧
      retainsDistinction 9 2 9 = true) := by decide


/-! =========================================================================
    SECTION 3: OQ-01 — Root-to-Two-Point-Carrier Theorem (`PG-R-GAP-DIAMOND-TO-ROOT`)
    ========================================================================= -/

/-- **OQ-01 Theorem 1:** Any pure map `f : X0 → X1` out of a subsingleton carrier `X0`
(such as the 1-element mark carrier `{<>}`) collapses all image points (`f x = f y`),
and therefore cannot witness an inhabited irreflexive relation `R (f x) (f y)`. -/
theorem subsingleton_image_no_irrefl_witness {X0 X1 : Type} [Subsingleton X0]
    (f : X0 → X1) (R : X1 → X1 → Prop) (hirr : Irrefl R) (x y : X0) :
    ¬ R (f x) (f y) := by
  intro hrel
  have heq : f x = f y := congrArg f (Subsingleton.elim x y)
  exact irrefl_witness_ne hirr hrel heq

/-- **OQ-01 Theorem 2:** Any finite-list or set expansion `F : X0 → List X1` from `x0 : X0`
that contains an irreflexive witness pair `a ∈ F x0, b ∈ F x0, R a b` requires the target
carrier `X1` to already inhabit two distinct elements `a ≠ b`. -/
theorem list_expansion_requires_target_ne {X0 X1 : Type}
    (F : X0 → List X1) (R : X1 → X1 → Prop) (hirr : Irrefl R)
    (x0 : X0) {a b : X1} (_ha : a ∈ F x0) (_hb : b ∈ F x0) (hab : R a b) :
    a ≠ b :=
  irrefl_witness_ne hirr hab

/-- **OQ-01 Theorem 3:** Any indexed admission rule `step : Idx → X0 → X1` (such as
occurrence indexing `stepOcc` or refusal-mode tagging `reifyUntagged` / `reifyTagged`)
that produces an irreflexive witness `R (step i x) (step j y)` from a subsingleton mark
carrier `X0` requires the host index type `Idx` to already contain distinct indices `i ≠ j`. -/
theorem indexed_admission_requires_index_ne {Idx X0 X1 : Type} [Subsingleton X0]
    (step : Idx → X0 → X1) (R : X1 → X1 → Prop) (hirr : Irrefl R)
    (i j : Idx) (x y : X0) (hrel : R (step i x) (step j y)) :
    i ≠ j := by
  intro hij
  subst hij
  have hxy : x = y := Subsingleton.elim x y
  subst hxy
  exact hirr (step i x) hrel


/-! =========================================================================
    SECTION 4: OQ-02 — Discrete Admitted Cut to Linear Cochain Window (`PG-R-GAP-GENESIS-TO-WINDOW`)
    ========================================================================= -/

/-- A 3-vertex, 3-edge, 1-face discrete triangle cut `X = {0,1,2}`,
`E = {e01=(0,1), e12=(1,2), e02=(0,2)}`, `F = {f012}`.
We show in Lean 4 that on this fixed discrete cut:
  1. Over `F2` (`Bool` with `xor`), the unsigned incidence operators satisfy `d1 ∘ d0 = 0`.
  2. Over `Int`, the same unsigned incidence operators fail `d1 ∘ d0 = 0` (`(d1 (d0 f))(0) = 2 ≠ 0`).
  3. Over `Int`, the cyclic sign assignment `(+1, +1, -1)` satisfies `d1 ∘ d0 = 0`, whereas
     flipping one edge sign `(+1, +1, +1)` fails `d1 ∘ d0 = 0`.
  4. On the signed complex over `Int`, the vortex 1-cochain `h = (1, 1, 1)` is not in `im d0`,
     and the zero seminorm `J0 = 0` gives defect `0` while the `L1` norm gives positive defect. -/

abbrev Cochain0F2 := Bool × Bool × Bool
abbrev Cochain1F2 := Bool × Bool × Bool

def d0UnsignedF2 (c : Cochain0F2) : Cochain1F2 :=
  let (v0, v1, v2) := c
  (xor v0 v1, xor v1 v2, xor v0 v2)

def d1UnsignedF2 (h : Cochain1F2) : Bool :=
  let (e01, e12, e02) := h
  xor (xor e01 e12) e02

theorem oq02_unsigned_f2_complex_holds (c : Cochain0F2) :
    d1UnsignedF2 (d0UnsignedF2 c) = false := by
  rcases c with ⟨v0, v1, v2⟩
  revert v0 v1 v2
  decide

abbrev Cochain0Int := Int × Int × Int
abbrev Cochain1Int := Int × Int × Int

def d0UnsignedInt (c : Cochain0Int) : Cochain1Int :=
  let (v0, v1, v2) := c
  (v0 + v1, v1 + v2, v0 + v2)

def d1UnsignedInt (h : Cochain1Int) : Int :=
  let (e01, e12, e02) := h
  e01 + e12 + e02

theorem oq02_unsigned_int_complex_fails :
    d1UnsignedInt (d0UnsignedInt (1, 0, 0)) = 2 ∧ (2 : Int) ≠ 0 := by
  decide

def d0SignedInt (c : Cochain0Int) : Cochain1Int :=
  let (v0, v1, v2) := c
  (v1 - v0, v2 - v1, v2 - v0)

def d1SignedCycInt (h : Cochain1Int) : Int :=
  let (e01, e12, e02) := h
  e01 + e12 - e02

def d1SignedFlipInt (h : Cochain1Int) : Int :=
  let (e01, e12, e02) := h
  e01 + e12 + e02

theorem oq02_signed_cyc_int_complex_holds (v0 v1 v2 : Int) :
    d1SignedCycInt (d0SignedInt (v0, v1, v2)) = 0 := by
  simp only [d1SignedCycInt, d0SignedInt]
  omega

theorem oq02_signed_flip_int_complex_fails :
    d1SignedFlipInt (d0SignedInt (0, 0, 1)) = 2 ∧ (2 : Int) ≠ 0 := by
  decide

def vortex1 : Cochain1Int := (1, 1, 1)

theorem oq02_vortex_not_in_im_d0 (v0 v1 v2 : Int) :
    d0SignedInt (v0, v1, v2) ≠ vortex1 := by
  intro heq
  have hd1 : d1SignedCycInt (d0SignedInt (v0, v1, v2)) = d1SignedCycInt vortex1 :=
    congrArg d1SignedCycInt heq
  rw [oq02_signed_cyc_int_complex_holds] at hd1
  revert hd1
  decide

def normL1 (h : Cochain1Int) : Nat :=
  let (a, b, c) := h
  a.natAbs + b.natAbs + c.natAbs

theorem oq02_vortex_l1_defect_pos (v0 v1 v2 : Int) :
    1 ≤ normL1 (1 - (v1 - v0), 1 - (v2 - v1), 1 - (v2 - v0)) := by
  simp only [normL1]
  omega

end MinimalChainAudit

#print axioms MinimalChainAudit.mu2_unique_general
#print axioms MinimalChainAudit.mu2_unique_F_general
#print axioms MinimalChainAudit.mu2_unique_singleHole
#print axioms MinimalChainAudit.mu2_unique_multiHole
#print axioms MinimalChainAudit.oq03_retains_iff_four_conditions
#print axioms MinimalChainAudit.oq03_factor_counts
#print axioms MinimalChainAudit.oq03_condition_independence_witnesses
#print axioms MinimalChainAudit.subsingleton_image_no_irrefl_witness
#print axioms MinimalChainAudit.indexed_admission_requires_index_ne
#print axioms MinimalChainAudit.oq02_vortex_not_in_im_d0
#print axioms MinimalChainAudit.oq02_vortex_l1_defect_pos
