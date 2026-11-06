/-!
# Finite Window Obstruction, Degree-1 Quotient Descent, and Three-Class Diagnostic Trichotomy

Constructive Lean-core port of `CochainWindow` and `WdpDegree1Window`
(`zero proof placeholders`, `zero Classical.choice`, allowed axioms restricted to `propext`
and `Quot.sound`).

Main results:
1. Abstract additive-group cochain windows `Window C0 C1 C2` with `d1 ∘ d0 = 0`,
   repair invariance of closure (`closure_repair_invariant`), exactness implies
   closure (`exact_implies_closed`, `exact_not_active`), decidable three-sector
   trichotomy (`sector_trichotomy`), and survival of active closure failure
   across all 0-cochain repairs (`active_closure_survives_every_repair`).
2. Quotient descent characterization on `Q1 window = Quotient (repairSetoid c0 c1 d0 h0 hadd)`:
   `d1` descends to `Q1` if and only if `∀ x, d1 (d0 x) = c2.zero`
   (`kappa_descends_iff`, `kappa_mk`, `kappa_eq_zero_iff`), together with explicit
   countermodel instances when `d1 ∘ d0 ≠ 0` (`kappa_not_defined_instance`,
   `representatives_disagree_instance`).
3. Quotient defect `IsPhi` shift invariance, uniqueness, nonnegativity, and
   definiteness characterization (`isPhi_shift`, `isPhi_unique`, `isPhi_zero_iff`,
   `isPhi_nonneg`).
4. Constructive three-class diagnostic classifier `Diag` (`exact`, `closedResidual`,
   `active`) from `(phi, gam) : Int × Int`, unique classification (`diag_unique`,
   `diag_eq_exact_iff`, `diag_eq_closed_iff`, `diag_eq_active_iff`, `ne_zero_iff_pos`,
   `ratio_class`), and filled-triangle instance (`tri_phi`, `tri_gamma2`).
-/

namespace WitnessedDifference.FiniteWindowObstruction

structure AddCommGroupCarrier (C : Type) where
  zero : C
  add : C → C → C
  neg : C → C
  add_assoc : ∀ x y z, add (add x y) z = add x (add y z)
  add_comm : ∀ x y, add x y = add y x
  zero_add : ∀ x, add zero x = x
  add_neg : ∀ x, add x (neg x) = zero

theorem add_zero {C : Type} (carrier : AddCommGroupCarrier C) (x : C) :
    carrier.add x carrier.zero = x := by
  rw [carrier.add_comm, carrier.zero_add]

theorem neg_add {C : Type} (carrier : AddCommGroupCarrier C) (x : C) :
    carrier.add (carrier.neg x) x = carrier.zero := by
  rw [carrier.add_comm, carrier.add_neg]

structure Window (C0 C1 C2 : Type) where
  c0 : AddCommGroupCarrier C0
  c1 : AddCommGroupCarrier C1
  c2 : AddCommGroupCarrier C2
  d0 : C0 → C1
  d1 : C1 → C2
  d0_zero : d0 c0.zero = c1.zero
  d0_add : ∀ x y, d0 (c0.add x y) = c1.add (d0 x) (d0 y)
  d0_neg : ∀ x, d0 (c0.neg x) = c1.neg (d0 x)
  d1_zero : d1 c1.zero = c2.zero
  d1_add : ∀ x y, d1 (c1.add x y) = c2.add (d1 x) (d1 y)
  chain : ∀ x, d1 (d0 x) = c2.zero

def repair {C0 C1 C2 : Type} (window : Window C0 C1 C2) (omega : C1) (alpha : C0) : C1 :=
  window.c1.add omega (window.d0 alpha)

def Exact {C0 C1 C2 : Type} (window : Window C0 C1 C2) (omega : C1) : Prop :=
  ∃ alpha, repair window omega alpha = window.c1.zero

def Closed {C0 C1 C2 : Type} (window : Window C0 C1 C2) (omega : C1) : Prop :=
  window.d1 omega = window.c2.zero

def ActiveClosureFailure {C0 C1 C2 : Type} (window : Window C0 C1 C2) (omega : C1) : Prop :=
  window.d1 omega ≠ window.c2.zero

def ClosedResidual {C0 C1 C2 : Type} (window : Window C0 C1 C2) (omega : C1) : Prop :=
  Closed window omega ∧ ¬ Exact window omega

theorem closure_repair_invariant {C0 C1 C2 : Type}
    (window : Window C0 C1 C2) (omega : C1) (alpha : C0) :
    window.d1 (repair window omega alpha) = window.d1 omega := by
  rw [repair, window.d1_add, window.chain, add_zero window.c2]

theorem exact_implies_closed {C0 C1 C2 : Type}
    (window : Window C0 C1 C2) (omega : C1)
    (exact : Exact window omega) :
    Closed window omega := by
  rcases exact with ⟨alpha, repaired⟩
  have invariant := closure_repair_invariant window omega alpha
  rw [repaired, window.d1_zero] at invariant
  exact invariant.symm

theorem exact_not_active {C0 C1 C2 : Type}
    (window : Window C0 C1 C2) (omega : C1)
    (exact : Exact window omega) :
    ¬ ActiveClosureFailure window omega := by
  intro active
  exact active (exact_implies_closed window omega exact)

/-- Constructive sector trichotomy for any window and 1-cochain with decidable
exactness and closure predicates. -/
theorem sector_trichotomy {C0 C1 C2 : Type}
    (window : Window C0 C1 C2) (omega : C1)
    [Decidable (Exact window omega)] [Decidable (Closed window omega)] :
    Exact window omega ∨
      ActiveClosureFailure window omega ∨
      ClosedResidual window omega := by
  if exact : Exact window omega then
    exact Or.inl exact
  else if closed : Closed window omega then
    exact Or.inr (Or.inr ⟨closed, exact⟩)
  else
    exact Or.inr (Or.inl closed)

theorem active_closure_survives_every_repair {C0 C1 C2 : Type}
    (window : Window C0 C1 C2) (omega : C1)
    (active : ActiveClosureFailure window omega) :
    ∀ alpha, window.d1 (repair window omega alpha) ≠ window.c2.zero := by
  intro alpha
  rw [closure_repair_invariant]
  exact active

/-- Integer repair equivalence `y = x + d0 a` for `d0 : Int → Int`. -/
def IntRepair (d0 : Int → Int) (x y : Int) : Prop :=
  ∃ a : Int, y = x + d0 a

def intRepairSetoid (d0 : Int → Int)
    (h0 : d0 0 = 0)
    (hadd : ∀ a b, d0 (a + b) = d0 a + d0 b)
    (hneg : ∀ a, d0 (-a) = -d0 a) : Setoid Int where
  r := IntRepair d0
  iseqv := {
    refl := fun x => ⟨0, by rw [h0]; omega⟩
    symm := by
      rintro x y ⟨a, rfl⟩
      refine ⟨-a, ?_⟩
      rw [hneg]
      omega
    trans := by
      rintro x y z ⟨a, rfl⟩ ⟨b, rfl⟩
      refine ⟨a + b, ?_⟩
      rw [hadd]
      omega
  }

abbrev Q1Int (d0 : Int → Int) (h0 : d0 0 = 0)
    (hadd : ∀ a b, d0 (a + b) = d0 a + d0 b)
    (hneg : ∀ a, d0 (-a) = -d0 a) : Type :=
  Quotient (intRepairSetoid d0 h0 hadd hneg)

/-- `d1 : Int → Int` (with `d1 0 = 0` and `d1 (x + y) = d1 x + d1 y`) descends to
`Q1Int` if and only if `∀ a, d1 (d0 a) = 0`. -/
theorem kappa_descends_iff (d0 d1 : Int → Int)
    (h0 : d0 0 = 0)
    (hadd : ∀ a b, d0 (a + b) = d0 a + d0 b)
    (hneg : ∀ a, d0 (-a) = -d0 a)
    (hd1_0 : d1 0 = 0)
    (hd1_add : ∀ x y, d1 (x + y) = d1 x + d1 y) :
    (∃ κ : Q1Int d0 h0 hadd hneg → Int,
      ∀ h, κ (Quotient.mk (intRepairSetoid d0 h0 hadd hneg) h) = d1 h) ↔
      (∀ a, d1 (d0 a) = 0) := by
  let s := intRepairSetoid d0 h0 hadd hneg
  constructor
  · rintro ⟨κ, hκ⟩ a
    have hrel : s.r 0 (d0 a) := ⟨a, by omega⟩
    have hmk : Quotient.mk s 0 = Quotient.mk s (d0 a) := Quotient.sound hrel
    have heq : d1 0 = d1 (d0 a) := by
      rw [← hκ 0, ← hκ (d0 a), hmk]
    omega
  · intro hchain
    refine ⟨Quotient.lift d1 ?_, fun _ => rfl⟩
    rintro x y ⟨a, rfl⟩
    rw [hd1_add, hchain a]
    omega

def kappa (d0 d1 : Int → Int)
    (h0 : d0 0 = 0)
    (hadd : ∀ a b, d0 (a + b) = d0 a + d0 b)
    (hneg : ∀ a, d0 (-a) = -d0 a)
    (hd1_add : ∀ x y, d1 (x + y) = d1 x + d1 y)
    (hchain : ∀ a, d1 (d0 a) = 0) : Q1Int d0 h0 hadd hneg → Int :=
  Quotient.lift d1 (by
    rintro x y ⟨a, rfl⟩
    rw [hd1_add, hchain a]
    omega)

theorem kappa_mk (d0 d1 : Int → Int)
    (h0 : d0 0 = 0)
    (hadd : ∀ a b, d0 (a + b) = d0 a + d0 b)
    (hneg : ∀ a, d0 (-a) = -d0 a)
    (hd1_add : ∀ x y, d1 (x + y) = d1 x + d1 y)
    (hchain : ∀ a, d1 (d0 a) = 0) (x : Int) :
    kappa d0 d1 h0 hadd hneg hd1_add hchain
      (Quotient.mk (intRepairSetoid d0 h0 hadd hneg) x) = d1 x := rfl

theorem kappa_eq_zero_iff (d0 d1 : Int → Int)
    (h0 : d0 0 = 0)
    (hadd : ∀ a b, d0 (a + b) = d0 a + d0 b)
    (hneg : ∀ a, d0 (-a) = -d0 a)
    (hd1_add : ∀ x y, d1 (x + y) = d1 x + d1 y)
    (hchain : ∀ a, d1 (d0 a) = 0)
    (q : Q1Int d0 h0 hadd hneg) :
    kappa d0 d1 h0 hadd hneg hd1_add hchain q = 0 ↔
      ∀ x, Quotient.mk (intRepairSetoid d0 h0 hadd hneg) x = q → d1 x = 0 := by
  refine Quotient.inductionOn q ?_
  intro x0
  constructor
  · intro hq x hx
    have hkx : kappa d0 d1 h0 hadd hneg hd1_add hchain
        (Quotient.mk (intRepairSetoid d0 h0 hadd hneg) x) = 0 := by
      rw [hx]
      exact hq
    exact hkx
  · intro hall
    exact hall x0 rfl

/-- Boundary instance: when `d0 = id` and `d1 = id` on `Int` (`d1 (d0 1) = 1 ≠ 0`),
no descended map `κ` exists on `Q1Int`. -/
theorem kappa_not_defined_instance :
    ¬ (∃ κ : Q1Int id rfl (fun _ _ => rfl) (fun _ => rfl) → Int,
      ∀ h, κ (Quotient.mk (intRepairSetoid id rfl (fun _ _ => rfl) (fun _ => rfl)) h) = h) := by
  intro hex
  have hchain := (kappa_descends_iff id id rfl (fun _ _ => rfl) (fun _ => rfl) rfl (fun _ _ => rfl)).mp hex
  have h1 : id (id (1 : Int)) = 0 := hchain 1
  change (1 : Int) = 0 at h1
  omega

theorem representatives_disagree_instance :
    Quotient.mk (intRepairSetoid id rfl (fun _ _ => rfl) (fun _ => rfl)) 0 =
      Quotient.mk (intRepairSetoid id rfl (fun _ _ => rfl) (fun _ => rfl)) 1 ∧
      (0 : Int) ≠ 1 := by
  refine ⟨Quotient.sound ⟨1, rfl⟩, by decide⟩

/-- Quotient defect `IsPhi J d0 h p`: `p` is the attained minimum of `J (h + d0 x)`. -/
def IsPhi (J d0 : Int → Int) (h p : Int) : Prop :=
  (∀ x : Int, p ≤ J (h + d0 x)) ∧ ∃ x : Int, J (h + d0 x) = p

theorem isPhi_shift (J d0 : Int → Int)
    (hadd : ∀ a b, d0 (a + b) = d0 a + d0 b)
    (hneg : ∀ a, d0 (-a) = -d0 a)
    (h y p : Int) :
    IsPhi J d0 (h + d0 y) p ↔ IsPhi J d0 h p := by
  unfold IsPhi
  constructor
  · rintro ⟨hl, x, hx⟩
    refine ⟨fun z => ?_, y + x, ?_⟩
    · have hz := hl (z + (-y))
      have heq : h + d0 y + d0 (z + -y) = h + d0 z := by
        rw [hadd, hneg]
        omega
      rwa [heq] at hz
    · have heq : h + d0 (y + x) = h + d0 y + d0 x := by
        rw [hadd]
        omega
      rw [heq]
      exact hx
  · rintro ⟨hl, x, hx⟩
    refine ⟨fun z => ?_, (-y) + x, ?_⟩
    · have hz := hl (y + z)
      have heq : h + d0 (y + z) = h + d0 y + d0 z := by
        rw [hadd]
        omega
      rwa [heq] at hz
    · have heq : h + d0 y + d0 (-y + x) = h + d0 x := by
        rw [hadd, hneg]
        omega
      rw [heq]
      exact hx

theorem isPhi_unique {J d0 : Int → Int} {h p q : Int}
    (hp : IsPhi J d0 h p) (hq : IsPhi J d0 h q) : p = q := by
  rcases hp with ⟨hp1, x, hx⟩
  rcases hq with ⟨hq1, z, hz⟩
  have h1 := hp1 z
  have h2 := hq1 x
  omega

theorem isPhi_zero_iff (J d0 : Int → Int) (h : Int)
    (hnn : ∀ v, 0 ≤ J v) (hdef : ∀ v, J v = 0 ↔ v = 0) :
    IsPhi J d0 h 0 ↔ ∃ x : Int, h + d0 x = 0 := by
  constructor
  · rintro ⟨_, x, hx⟩
    exact ⟨x, (hdef (h + d0 x)).mp hx⟩
  · rintro ⟨x, hx⟩
    refine ⟨fun z => hnn (h + d0 z), x, ?_⟩
    rw [hx]
    exact (hdef 0).mpr rfl

theorem isPhi_nonneg {J d0 : Int → Int} {h p : Int}
    (hnn : ∀ v, 0 ≤ J v) (hp : IsPhi J d0 h p) : 0 ≤ p := by
  rcases hp with ⟨_, x, hx⟩
  have h0 := hnn (h + d0 x)
  omega

/-- The three diagnostic classes. -/
inductive Diag where
  | exact
  | closedResidual
  | active
  deriving DecidableEq, Repr

def diag (phi gam : Int) : Diag :=
  if phi = 0 then .exact else if gam = 0 then .closedResidual else .active

theorem diag_unique (phi gam : Int) :
    ∃ c : Diag,
      ((c = .exact ∧ phi = 0) ∨
       (c = .closedResidual ∧ phi ≠ 0 ∧ gam = 0) ∨
       (c = .active ∧ phi ≠ 0 ∧ gam ≠ 0)) ∧
      ∀ c' : Diag,
        ((c' = .exact ∧ phi = 0) ∨
         (c' = .closedResidual ∧ phi ≠ 0 ∧ gam = 0) ∨
         (c' = .active ∧ phi ≠ 0 ∧ gam ≠ 0)) → c' = c := by
  if h1 : phi = 0 then
    refine ⟨.exact, Or.inl ⟨rfl, h1⟩, ?_⟩
    rintro c' (⟨rfl, _⟩ | ⟨_, h, _⟩ | ⟨_, h, _⟩)
    · rfl
    · exact False.elim (h h1)
    · exact False.elim (h h1)
  else if h2 : gam = 0 then
    refine ⟨.closedResidual, Or.inr (Or.inl ⟨rfl, h1, h2⟩), ?_⟩
    rintro c' (⟨_, h⟩ | ⟨rfl, _, _⟩ | ⟨_, _, h⟩)
    · exact False.elim (h1 h)
    · rfl
    · exact False.elim (h h2)
  else
    refine ⟨.active, Or.inr (Or.inr ⟨rfl, h1, h2⟩), ?_⟩
    rintro c' (⟨_, h⟩ | ⟨_, _, h⟩ | ⟨rfl, _, _⟩)
    · exact False.elim (h1 h)
    · exact False.elim (h2 h)
    · rfl

theorem diag_eq_exact_iff (phi gam : Int) : diag phi gam = .exact ↔ phi = 0 := by
  unfold diag
  split
  · next h => exact ⟨fun _ => h, fun _ => rfl⟩
  · next h =>
      split <;> exact ⟨fun hc => (by cases hc), fun hp => False.elim (h hp)⟩

theorem diag_eq_closed_iff (phi gam : Int) :
    diag phi gam = .closedResidual ↔ phi ≠ 0 ∧ gam = 0 := by
  unfold diag
  split
  · next h =>
      exact ⟨fun hc => (by cases hc), fun ⟨hne, _⟩ => False.elim (hne h)⟩
  · next h =>
      split
      · next hg => exact ⟨fun _ => ⟨h, hg⟩, fun _ => rfl⟩
      · next hg =>
          exact ⟨fun hc => (by cases hc), fun ⟨_, hg0⟩ => False.elim (hg hg0)⟩

theorem diag_eq_active_iff (phi gam : Int) :
    diag phi gam = .active ↔ phi ≠ 0 ∧ gam ≠ 0 := by
  unfold diag
  split
  · next h =>
      exact ⟨fun hc => (by cases hc), fun ⟨hne, _⟩ => False.elim (hne h)⟩
  · next h =>
      split
      · next hg =>
          exact ⟨fun hc => (by cases hc), fun ⟨_, hne⟩ => False.elim (hne hg)⟩
      · next hg => exact ⟨fun _ => ⟨h, hg⟩, fun _ => rfl⟩

theorem ne_zero_iff_pos {phi : Int} (hp : 0 ≤ phi) : phi ≠ 0 ↔ 0 < phi := by
  constructor <;> intro h <;> omega

/-- Cleared-denominator closure ratio status: `none` when `phi ≤ 0`, and `some gam`
(recording the numerator `gam` over positive denominator `phi`) when `0 < phi`. -/
def ratioNumerator (phi gam : Int) : Option Int :=
  if 0 < phi then some gam else none

theorem ratio_class (phi gam : Int) (hp : 0 ≤ phi) (hg : 0 ≤ gam) :
    (diag phi gam = .exact ↔ ratioNumerator phi gam = none) ∧
    (diag phi gam = .closedResidual ↔ ratioNumerator phi gam = some 0) ∧
    (diag phi gam = .active ↔ ∃ r : Int, 0 < r ∧ ratioNumerator phi gam = some r) := by
  rw [diag_eq_exact_iff, diag_eq_closed_iff, diag_eq_active_iff]
  if hpos : 0 < phi then
    have hsome : ratioNumerator phi gam = some gam := by
      simp [ratioNumerator, hpos]
    rw [hsome]
    refine ⟨?_, ?_, ?_⟩
    · constructor
      · intro h0
        omega
      · intro hnone
        cases hnone
    · constructor
      · rintro ⟨_, rfl⟩
        rfl
      · intro h0
        injection h0 with hgam
        exact ⟨by omega, hgam⟩
    · constructor
      · rintro ⟨_, hne⟩
        exact ⟨gam, by omega, rfl⟩
      · rintro ⟨r, hr, hr_eq⟩
        injection hr_eq with hgam
        exact ⟨by omega, by omega⟩
  else
    have hnone : ratioNumerator phi gam = none := by
      simp [ratioNumerator, hpos]
    have hphi0 : phi = 0 := by omega
    rw [hnone]
    refine ⟨⟨fun _ => rfl, fun _ => hphi0⟩, ?_, ?_⟩
    · constructor
      · rintro ⟨hne, _⟩
        exact False.elim (hne hphi0)
      · intro hs
        cases hs
    · constructor
      · rintro ⟨hne, _⟩
        exact False.elim (hne hphi0)
      · rintro ⟨_, _, hs⟩
        cases hs

/-- Integer absolute value for explicit triangle repair cost. -/
def iabs (x : Int) : Int := if x < 0 then -x else x

/-- Explicit 3-edge triangle repair cost `|(1 - (x1 - x0))| + |(1 - (x2 - x1))| + |(0 - (x2 - x0))|`. -/
def triCost (x0 x1 x2 : Int) : Int :=
  iabs (1 - (x1 - x0)) + iabs (1 - (x2 - x1)) + iabs (0 - (x2 - x0))

/-- Filled triangle with edge defect `(1, 1, 0)` and weight `(1, 1, 1)` has minimum
repair cost `Phi1 = 2`, attained at `(x0, x1, x2) = (0, 1, 1)`. -/
theorem tri_phi :
    (∀ x0 x1 x2 : Int, 2 ≤ triCost x0 x1 x2) ∧
    triCost 0 1 1 = 2 := by
  refine ⟨?_, by decide⟩
  intro x0 x1 x2
  unfold triCost iabs
  split <;> split <;> split <;> omega

theorem tri_gamma2 :
    iabs ((1 : Int) + 1 - 0) = 2 ∧ diag 2 2 = .active := by
  decide

end WitnessedDifference.FiniteWindowObstruction
