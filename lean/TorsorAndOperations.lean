import PrimitiveDifference
import MirrorNonIdentification

/-!
# Two-position torsor, apartness, and host operation bounds (Slice 1)

Reconstructs the two-position relational census, the two-element operation
group C2 and its free transitive torsor action on Bool, closure and
irreducibility, positive apartness and indistinguishability, the root-to-two-point
carrier bounds (OQ-01, including the RT-03 list-length bound), and the
deterministic symmetry floor versus invariant multi-element offers.
-/
set_option autoImplicit false

namespace OmegaCodex.TorsorAndOperations

open OmegaCodex.PrimitiveDifference
open OmegaCodex.MirrorNonIdentification

universe u v w

/-! ## Section 1: Two-position relational census and automorphisms -/

abbrev Rel2 := Bool → Bool → Bool

def E2 : Rel2 := fun _ _ => false

def D2 : Rel2
  | false, true => true
  | _, _ => false

def D2rev : Rel2
  | true, false => true
  | _, _ => false

def S2Bool : Rel2 := difference

def RelEq (R S : Rel2) : Prop := ∀ x y, R x y = S x y

def FunEq (f g : Bool → Bool) : Prop := ∀ x, f x = g x

theorem offdiag_nonempty_iff (R : Rel2) :
    ((R false true = true ∨ R true false = true) ∧
      R false false = false ∧ R true true = false) ↔
    (RelEq R D2 ∨ RelEq R D2rev ∨ RelEq R S2Bool) := by
  constructor
  · rintro ⟨hoff, hff, htt⟩
    cases hft : R false true <;> cases htf : R true false
    · cases hoff with
      | inl h => exact Bool.noConfusion (hft.symm.trans h)
      | inr h => exact Bool.noConfusion (htf.symm.trans h)
    · right; left
      intro x y
      cases x <;> cases y <;> simp [D2rev, hff, hft, htf, htt]
    · left
      intro x y
      cases x <;> cases y <;> simp [D2, hff, hft, htf, htt]
    · right; right
      intro x y
      cases x <;> cases y <;> simp [S2Bool, difference, hff, hft, htf, htt]
  · rintro (hD2 | hD2r | hS2)
    · refine ⟨Or.inl (hD2 false true), hD2 false false, hD2 true true⟩
    · refine ⟨Or.inr (hD2r true false), hD2r false false, hD2r true true⟩
    · refine ⟨Or.inl (hS2 false true), hS2 false false, hS2 true true⟩

theorem D2_initial_pointed (R : Rel2) (p q : Bool)
    (hpq : R p q = true) (hirr : ∀ x, R x x = false) :
    ∃ f : Bool → Bool, Function.Injective f ∧
      ∀ x y, D2 x y = true → R (f x) (f y) = true := by
  cases p <;> cases q
  · have hff : R false false = false := hirr false
    exact Bool.noConfusion (hff.symm.trans hpq)
  · refine ⟨id, fun _ _ h => h, ?_⟩
    intro x y hxy
    cases x <;> cases y
    · cases hxy
    · exact hpq
    · cases hxy
    · cases hxy
  · refine ⟨counterpart, ?_, ?_⟩
    · intro x y h
      cases x <;> cases y <;> cases h <;> rfl
    · intro x y hxy
      cases x <;> cases y
      · cases hxy
      · exact hpq
      · cases hxy
      · cases hxy
  · have htt : R true true = false := hirr true
    exact Bool.noConfusion (htt.symm.trans hpq)

theorem D2_preserve_iff_id (f : Bool → Bool) :
    (∀ x y, D2 x y = true → D2 (f x) (f y) = true) ↔ FunEq f id := by
  constructor
  · intro h x
    have hft : D2 (f false) (f true) = true := h false true rfl
    cases hf0 : f false <;> cases hf1 : f true
    · rw [hf0, hf1] at hft; cases hft
    · cases x <;> simp [id, hf0, hf1]
    · rw [hf0, hf1] at hft; cases hft
    · rw [hf0, hf1] at hft; cases hft
  · intro hf x y hxy
    rw [hf x, hf y]
    exact hxy

theorem D2_automorphism_trivial (f : Bool → Bool) :
    (∀ x y, D2 (f x) (f y) = D2 x y) ↔ FunEq f id := by
  constructor
  · intro h
    exact (D2_preserve_iff_id f).mp (fun x y hxy => (h x y).trans hxy)
  · intro hf x y
    rw [hf x, hf y]
    rfl

theorem S2_automorphism_iff (f : Bool → Bool) :
    (∀ x y, S2Bool (f x) (f y) = S2Bool x y) ↔ (FunEq f id ∨ FunEq f counterpart) := by
  constructor
  · intro h
    have hft : S2Bool (f false) (f true) = true := (h false true).trans rfl
    cases hf0 : f false <;> cases hf1 : f true
    · rw [hf0, hf1] at hft; cases hft
    · left
      intro x
      cases x <;> simp [id, hf0, hf1]
    · right
      intro x
      cases x <;> simp [counterpart, hf0, hf1]
    · rw [hf0, hf1] at hft; cases hft
  · rintro (hf | hf)
    · intro x y
      rw [hf x, hf y]
      rfl
    · intro x y
      rw [hf x, hf y]
      exact binary_difference_swap_invariant x y

/-! ## Section 2: C2 operations and the two-position C2 torsor bridge -/

inductive C2 where
  | e : C2
  | r : C2
deriving DecidableEq, Repr

def c2Mul : C2 → C2 → C2
  | .e, g => g
  | .r, .e => .r
  | .r, .r => .e

theorem c2Mul_assoc (a b c : C2) :
    c2Mul (c2Mul a b) c = c2Mul a (c2Mul b c) := by
  cases a <;> cases b <;> cases c <;> rfl

theorem c2Mul_id_left (a : C2) : c2Mul .e a = a := by
  cases a <;> rfl

theorem c2Mul_id_right (a : C2) : c2Mul a .e = a := by
  cases a <;> rfl

theorem c2Mul_self_inv (a : C2) : c2Mul a a = .e := by
  cases a <;> rfl

theorem singleton_action_trivial (act : C2 → Unit → Unit) (u : Unit) :
    act .r u = act .e u :=
  Subsingleton.elim (act .r u) (act .e u)

def c2CollapseHom : C2 → Unit := fun _ => ()

theorem c2_collapse_homomorphism (a b : C2) :
    c2CollapseHom .e = () ∧ c2CollapseHom (c2Mul a b) = c2CollapseHom a :=
  ⟨rfl, rfl⟩

theorem c2_faithful_injective {Q : Type u} (f : C2 → Q)
    (hne : f .r ≠ f .e) : Function.Injective f := by
  intro a b hab
  cases a <;> cases b
  · rfl
  · exact False.elim (hne hab.symm)
  · exact False.elim (hne hab)
  · rfl

def c2Act : C2 → Bool → Bool
  | .e, x => x
  | .r, x => counterpart x

theorem c2Act_id (x : Bool) : c2Act .e x = x := rfl

theorem c2Act_mul (g h : C2) (x : Bool) :
    c2Act (c2Mul g h) x = c2Act g (c2Act h x) := by
  cases g <;> cases h <;> cases x <;> rfl

theorem c2Act_faithful (g h : C2) (heq : ∀ x, c2Act g x = c2Act h x) :
    g = h := by
  have h0 := heq false
  cases g <;> cases h
  · rfl
  · cases h0
  · cases h0
  · rfl

theorem c2Act_free (g : C2) (x : Bool) (hfix : c2Act g x = x) :
    g = .e := by
  cases g <;> cases x <;> first | rfl | cases hfix

theorem c2Act_transitive (x y : Bool) :
    ∃ g : C2, c2Act g x = y := by
  cases x <;> cases y
  · exact ⟨.e, rfl⟩
  · exact ⟨.r, rfl⟩
  · exact ⟨.r, rfl⟩
  · exact ⟨.e, rfl⟩

def c2Displacement (x y : Bool) : C2 :=
  if difference x y then .r else .e

theorem c2Displacement_spec (x y : Bool) :
    c2Act (c2Displacement x y) x = y := by
  cases x <;> cases y <;> rfl

theorem c2Displacement_unique (x y : Bool) (g : C2) :
    c2Act g x = y ↔ g = c2Displacement x y := by
  cases g <;> cases x <;> cases y <;> decide

theorem c2Displacement_swap_invariant (x y : Bool) :
    c2Displacement (counterpart x) (counterpart y) = c2Displacement x y := by
  cases x <;> cases y <;> rfl

theorem c2Displacement_nonid_iff_S2 (x y : Bool) :
    c2Displacement x y = .r ↔ S2 x y := by
  cases x <;> cases y <;> decide

/-! ## Section 3: Closure, irreducibility, and merger erasure -/

def Clos {α : Type u} (R : α → α → Prop) (x z : α) : Prop :=
  z = x ∨ R x z ∨ R z x

def Irred {α : Type u} (R : α → α → Prop) (x y : α) : Prop :=
  ∀ z, Clos R x z → Clos R y z → False

theorem irred_empty_iff_ne {α : Type u} (x y : α) :
    Irred (fun _ _ : α => False) x y ↔ x ≠ y := by
  constructor
  · intro hirr hxy
    exact hirr x (Or.inl rfl) (Or.inl hxy)
  · intro hne z hxz hyz
    rcases hxz with rfl | h | h
    · rcases hyz with rfl | h | h
      · exact hne rfl
      · exact h
      · exact h
    · exact h
    · exact h

theorem irred_antitone {α : Type u} {R S : α → α → Prop}
    (hRS : ∀ a b, R a b → S a b) {x y : α}
    (hS : Irred S x y) : Irred R x y := by
  intro z hxz hyz
  have hxzS : Clos S x z := by
    rcases hxz with rfl | h | h
    · exact Or.inl rfl
    · exact Or.inr (Or.inl (hRS x z h))
    · exact Or.inr (Or.inr (hRS z x h))
  have hyzS : Clos S y z := by
    rcases hyz with rfl | h | h
    · exact Or.inl rfl
    · exact Or.inr (Or.inl (hRS y z h))
    · exact Or.inr (Or.inr (hRS z y h))
  exact hS z hxzS hyzS

theorem merger_erases {α : Type u} (R : α → α → Prop) (x y : α)
    (h : R x y) : ¬ Irred R x y :=
  fun hirr => hirr y (Or.inr (Or.inl h)) (Or.inl rfl)

/-! ## Section 4: Positive apartness and indistinguishability -/

structure IsApart {α : Type u} (R : α → α → Prop) : Prop where
  irrefl  : Irrefl R
  symm    : ∀ x y, R x y → R y x
  cotrans : ∀ x y z, R x y → R x z ∨ R y z

def Indist {α : Type u} (R : α → α → Prop) (x y : α) : Prop :=
  ¬ R x y

theorem indist_equivalence {α : Type u} {R : α → α → Prop}
    (hA : IsApart R) : Equivalence (Indist R) where
  refl x := hA.irrefl x
  symm hxy hyx := hxy (hA.symm _ _ hyx)
  trans hxy hyz hxz := by
    rcases hA.cotrans _ _ _ hxz with hxy' | hyz'
    · exact hxy hxy'
    · exact hyz (hA.symm _ _ hyz')

theorem s2_isApart : IsApart S2 where
  irrefl := S2_irrefl
  symm _ _ h := Ne.symm h
  cotrans x y z hxy := by
    cases x <;> cases y <;> cases z
    · exact False.elim (hxy rfl)
    · exact Or.inl (by decide)
    · exact Or.inr (by decide)
    · exact Or.inl (by decide)
    · exact Or.inl (by decide)
    · exact Or.inr (by decide)
    · exact False.elim (hxy rfl)
    · exact False.elim (hxy rfl)

def edge01OnFin3 (x y : Fin 3) : Prop :=
  (x.val = 0 ∧ y.val = 1) ∨ (x.val = 1 ∧ y.val = 0)

instance (x y : Fin 3) : Decidable (edge01OnFin3 x y) := by
  unfold edge01OnFin3
  infer_instance

theorem cotrans_not_forced_by_irrefl_symm :
    Irrefl edge01OnFin3 ∧
    (∀ x y, edge01OnFin3 x y → edge01OnFin3 y x) ∧
    ¬ (∀ x y z, edge01OnFin3 x y → edge01OnFin3 x z ∨ edge01OnFin3 y z) := by
  refine ⟨?_, ?_, ?_⟩
  · intro ⟨x, hx⟩ h
    rcases h with ⟨h0, h1⟩ | ⟨h1, h0⟩
    · exact Nat.noConfusion (h0.symm.trans h1)
    · exact Nat.noConfusion (h0.symm.trans h1)
  · intro x y h
    rcases h with h | h
    · exact Or.inr ⟨h.2, h.1⟩
    · exact Or.inl ⟨h.2, h.1⟩
  · intro hcot
    have h01 : edge01OnFin3 ⟨0, by decide⟩ ⟨1, by decide⟩ := Or.inl ⟨rfl, rfl⟩
    rcases hcot ⟨0, by decide⟩ ⟨1, by decide⟩ ⟨2, by decide⟩ h01 with h02 | h12
    · exact absurd h02 (by decide)
    · exact absurd h12 (by decide)

/-! ## Section 5: OQ-01 Root-to-two-point-carrier bounds (with RT-03 upgrade) -/

theorem subsingleton_image_no_irrefl_witness
    {X0 : Type u} {X1 : Type v} [Subsingleton X0]
    (R : X1 → X1 → Prop) (hirr : Irrefl R)
    (f : X0 → X1) (x y : X0) :
    ¬ R (f x) (f y) := by
  intro hrel
  have heq : f x = f y := congrArg f (Subsingleton.elim x y)
  exact irrefl_witness_ne hirr hrel heq

theorem indexed_admission_requires_index_ne
    {Idx : Type u} {X0 : Type v} {X1 : Type w} [Subsingleton X0]
    (R : X1 → X1 → Prop) (hirr : Irrefl R)
    (step : Idx → X0 → X1) (i j : Idx) (x y : X0)
    (hR : R (step i x) (step j y)) :
    i ≠ j := by
  intro hij
  subst hij
  have hxy : x = y := Subsingleton.elim x y
  subst hxy
  exact hirr (step i x) hR

/-- RT-03 upgrade: `ha : a ∈ F x0` and `hb : b ∈ F x0` are both required to
bound the expansion list length `2 ≤ (F x0).length`. -/
theorem list_expansion_requires_length_two
    {X0 : Type u} {X1 : Type v}
    (R : X1 → X1 → Prop) (hirr : Irrefl R)
    (F : X0 → List X1) (x0 : X0) (a b : X1)
    (ha : a ∈ F x0) (hb : b ∈ F x0) (hab : R a b) :
    a ≠ b ∧ 2 ≤ (F x0).length := by
  have hne : a ≠ b := irrefl_witness_ne hirr hab
  refine ⟨hne, ?_⟩
  cases hF : F x0 with
  | nil =>
      rw [hF] at ha
      cases ha
  | cons x rest =>
      cases rest with
      | nil =>
          rw [hF] at ha hb
          have hax : a = x := by
            cases ha with
            | head => rfl
            | tail _ h => cases h
          have hbx : b = x := by
            cases hb with
            | head => rfl
            | tail _ h => cases h
          exact False.elim (hne (hax.trans hbx.symm))
      | cons y tail =>
          exact Nat.le_add_left 2 tail.length

/-! ## Section 6: Host operation separation and SymmetryFloor -/

theorem second_token_required {Q : Type u}
    (step : Q → Bool → Q) (readout : Q → Bool) (q0 : Q)
    (hsep : readout (step q0 false) ≠ readout (step q0 true)) :
    step q0 false ≠ step q0 true :=
  fun heq => hsep (congrArg readout heq)

theorem equivariant_witness_is_S2Bool (R : Rel2)
    (hirr : ∀ x, R x x = false)
    (hne : R false true = true ∨ R true false = true)
    (heq : ∀ x y, R (counterpart x) (counterpart y) = R x y) :
    RelEq R S2Bool := by
  have hft : R false true = true := by
    cases hne with
    | inl h => exact h
    | inr h =>
        have hswap : R false true = R true false := heq true false
        exact hswap.trans h
  have htf : R true false = true := (heq false true).trans hft
  have hff : R false false = false := hirr false
  have htt : R true true = false := hirr true
  intro x y
  cases x <;> cases y <;> simp [S2Bool, difference, hff, hft, htf, htt]

theorem no_swap_fixed_offdiag_pair :
    ¬ ∃ p : Bool × Bool, p.1 ≠ p.2 ∧ (counterpart p.1, counterpart p.2) = p := by
  rintro ⟨⟨x, y⟩, hne, hfix⟩
  have hx : counterpart x = x := congrArg Prod.fst hfix
  exact counterpart_ne x hx

theorem equivariant_fixed_point_preserved {α : Type u}
    (σ : α → α) (f : α → α)
    (heq : ∀ x, f (σ x) = σ (f x)) {x : α} (hfix : σ x = x) :
    σ (f x) = f x := by
  rw [← heq x, hfix]

theorem equivariant_family_invariant {S : Type u} {R : Type v}
    (actS : S → S) (actR : R → R) (F : S → List R)
    (hequiv : ∀ s, F (actS s) = (F s).map actR) {s : S}
    (hfix : actS s = s) :
    (F s).map actR = F s := by
  calc (F s).map actR = F (actS s) := (hequiv s).symm
    _ = F s := by rw [hfix]

def swap3 : Fin 3 → Fin 3
  | ⟨0, _⟩ => ⟨0, by decide⟩
  | ⟨1, _⟩ => ⟨2, by decide⟩
  | ⟨2, _⟩ => ⟨1, by decide⟩

def offer12 : Fin 3 → Bool
  | ⟨0, _⟩ => false
  | ⟨1, _⟩ => true
  | ⟨2, _⟩ => true

/-- SymmetryFloor comparison on `Fin 3` (`10_post_seal_checks.py` [1]):
every deterministic `swap3`-equivariant endomap fixes `0`, whereas the
2-element subset `offer12 = {1, 2}` is `swap3`-invariant while containing
no `swap3`-fixed member. -/
theorem swap3_deterministic_vs_multi_offer :
    (∀ f : Fin 3 → Fin 3,
      (∀ x, f (swap3 x) = swap3 (f x)) →
      f ⟨0, by decide⟩ = ⟨0, by decide⟩) ∧
    (∀ x : Fin 3, offer12 (swap3 x) = offer12 x) ∧
    (∀ x : Fin 3, offer12 x = true → swap3 x ≠ x) := by
  refine ⟨?_, by decide, by decide⟩
  intro f heq
  have hfix : swap3 (f ⟨0, by decide⟩) = f ⟨0, by decide⟩ :=
    equivariant_fixed_point_preserved swap3 f heq rfl
  rcases h : f ⟨0, by decide⟩ with ⟨val, isLt⟩
  match val, isLt, h with
  | 0, _, _ => rfl
  | 1, _, h1 =>
      rw [h1] at hfix
      cases hfix
  | 2, _, h2 =>
      rw [h2] at hfix
      cases hfix

end OmegaCodex.TorsorAndOperations
