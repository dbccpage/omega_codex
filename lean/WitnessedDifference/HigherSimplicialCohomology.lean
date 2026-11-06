/-!
# Higher Simplicial Cohomology, Hollow-Sphere H² Duality, and Pentachoron Exactness

Constructive Lean-core port of `Simplicial3complexCayleyEvolution` extended with
higher simplicial cochain exactness and primal-dual `L¹` minimum defect on
`∂Δ³ ≅ S²` and `Δ⁴` (`zero proof placeholders`, `zero Classical.choice`, allowed axioms
restricted to `propext` and `Quot.sound`).

Main results:
1. 3-simplex (`Δ³`) and octahedron (`S²`) Euler characteristics and chain boundary
   cancellation `∂₂ ∘ ∂₃ = 0` (`tetrahedron_euler_characteristic`,
   `tet_chain1_zero_ext`, `tet_d2_comp_d3_nilpotent`, `tet_d2_boundary_cancellation`,
   `octahedron_euler_characteristic`, `oct_d2_boundary_cancellation`).
2. Hollow tetrahedron `∂Δ³ ≅ S²` second cohomology `H²(∂Δ³; ℤ) ≅ ℤ`:
   - `hollow_tet_exact_2cochain_iff_bianchi_zero`: a 2-cochain `F : TetChain2` is in
     `im(tet_coboundary_d1)` if and only if `bianchiCharge F = 0` (constructive
     rooted primitive `primHollowTet2`).
   - `hollow_tet_monopole_nonexact_witness`: unit face cochain `⟨1, 0, 0, 0⟩` has
     nonzero Bianchi charge `1` and cannot be written as `tet_coboundary_d1 ω`.
   - `hollow_tet_l1_weak_duality` and `hollow_tet_l1_strong_duality`: for every
     2-cochain `F`, `min_{ω ∈ C¹} ‖F - d₁ ω‖₁ = |bianchiCharge F|` attained at
     `primHollowTet2 F`.
3. 4-simplex pentachoron (`Δ⁴`) coboundaries `d₂ : C²(Δ⁴) → C³(Δ⁴)` and
   `d₃ : C³(Δ⁴) → C⁴(Δ⁴)`: `pentachoron_euler_characteristic`,
   `pentachoron_d3_comp_d2_zero` (`d₃ ∘ d₂ = 0`), and `pentachoron_3cocycle_exact_iff`
   (`ker d₃ = im d₂` on `Δ⁴` via `primPentachoron3`).
4. Discrete Cayley transform norm/orthogonality identities (`cayley_isometry_w0`,
   `cayley_isometry_w1`, `cayley_isometry_w2`, `cayley_isometry_w_neg1`,
   `cayley_isometry_w_neg2`, `cayley_orthogonality_general`).
-/

namespace WitnessedDifference.HigherSimplicialCohomology

theorem tetrahedron_euler_characteristic : (4 : Int) - 6 + 4 = 2 := by decide

structure TetChain1 where
  e01 : Int
  e02 : Int
  e03 : Int
  e12 : Int
  e13 : Int
  e23 : Int
  deriving DecidableEq, Repr

def zeroTet1 : TetChain1 := ⟨0, 0, 0, 0, 0, 0⟩

def addTet1 (c d : TetChain1) : TetChain1 :=
  ⟨c.e01 + d.e01, c.e02 + d.e02, c.e03 + d.e03,
   c.e12 + d.e12, c.e13 + d.e13, c.e23 + d.e23⟩

def subTet1 (c d : TetChain1) : TetChain1 :=
  ⟨c.e01 - d.e01, c.e02 - d.e02, c.e03 - d.e03,
   c.e12 - d.e12, c.e13 - d.e13, c.e23 - d.e23⟩

instance : Zero TetChain1 := ⟨zeroTet1⟩
instance : Add TetChain1 := ⟨addTet1⟩
instance : Sub TetChain1 := ⟨subTet1⟩

structure TetChain2 where
  f0 : Int
  f1 : Int
  f2 : Int
  f3 : Int
  deriving DecidableEq, Repr

def zeroTet2 : TetChain2 := ⟨0, 0, 0, 0⟩

def subTet2 (a b : TetChain2) : TetChain2 :=
  ⟨a.f0 - b.f0, a.f1 - b.f1, a.f2 - b.f2, a.f3 - b.f3⟩

theorem tet_chain2_ext {a b : TetChain2}
    (h0 : a.f0 = b.f0) (h1 : a.f1 = b.f1) (h2 : a.f2 = b.f2) (h3 : a.f3 = b.f3) :
    a = b := by
  cases a
  cases b
  simp only [TetChain2.mk.injEq]
  exact ⟨h0, h1, h2, h3⟩

structure TetChain3 where
  t0 : Int
  deriving DecidableEq, Repr

def tet_d2 (c : TetChain2) : TetChain1 :=
  ⟨c.f2 + c.f3,
   c.f1 - c.f3,
   -c.f1 - c.f2,
   c.f0 + c.f3,
   -c.f0 + c.f2,
   c.f0 + c.f1⟩

theorem tet_chain1_zero_ext (c : TetChain1)
    (h01 : c.e01 = 0) (h02 : c.e02 = 0) (h03 : c.e03 = 0)
    (h12 : c.e12 = 0) (h13 : c.e13 = 0) (h23 : c.e23 = 0) :
    c = zeroTet1 := by
  rcases c with ⟨e01, e02, e03, e12, e13, e23⟩
  dsimp [zeroTet1]
  congr

def tet_d3 (c : TetChain3) : TetChain2 :=
  ⟨c.t0, -c.t0, c.t0, -c.t0⟩

theorem tet_d2_comp_d3_nilpotent (c : TetChain3) :
    tet_d2 (tet_d3 c) = 0 := by
  apply tet_chain1_zero_ext <;> dsimp [tet_d2, tet_d3] <;> omega

theorem tet_d2_boundary_cancellation :
    tet_d2 (tet_d3 ⟨1⟩) = 0 := by
  apply tet_chain1_zero_ext <;> dsimp [tet_d2, tet_d3] <;> omega

/-- Coboundary `d₁ : C¹(Δ³) → C²(Δ³)` on the 4 triangular faces
`f0 = (012)`, `f1 = (013)`, `f2 = (023)`, `f3 = (123)`. -/
def tet_coboundary_d1 (ω : TetChain1) : TetChain2 :=
  ⟨ω.e01 + ω.e12 - ω.e02,
   ω.e01 + ω.e13 - ω.e03,
   ω.e02 + ω.e23 - ω.e03,
   ω.e12 + ω.e23 - ω.e13⟩

/-- Oriented 2-cycle Bianchi charge `d₂ : C²(Δ³) → ℤ`: `f0 - f1 + f2 - f3`. -/
def bianchiCharge (F : TetChain2) : Int :=
  F.f0 - F.f1 + F.f2 - F.f3

/-- Rooted 1-cochain primitive for a 2-cochain `F` on `∂Δ³`: sets all edges except
`e02, e03, e13` to `0`, and integrates `F.f0, F.f1, F.f2` on those three edges. -/
def primHollowTet2 (F : TetChain2) : TetChain1 :=
  ⟨0, -F.f0, -F.f0 - F.f2, 0, F.f1 - F.f0 - F.f2, 0⟩

/-- Exactness on `∂Δ³ ≅ S²` modulo the single global 2-cycle:
`F` is in `im(tet_coboundary_d1)` if and only if `bianchiCharge F = 0`. -/
theorem hollow_tet_exact_2cochain_iff_bianchi_zero (F : TetChain2) :
    (bianchiCharge F = 0 ↔ tet_coboundary_d1 (primHollowTet2 F) = F) ∧
    (bianchiCharge F = 0 ↔ ∃ ω : TetChain1, tet_coboundary_d1 ω = F) := by
  have hprim : bianchiCharge F = 0 ↔ tet_coboundary_d1 (primHollowTet2 F) = F := by
    constructor
    · intro hb
      apply tet_chain2_ext <;> dsimp [tet_coboundary_d1, primHollowTet2, bianchiCharge] at hb ⊢ <;> omega
    · intro heq
      rw [← heq]
      dsimp [bianchiCharge, tet_coboundary_d1]
      omega
  refine ⟨hprim, ?_⟩
  constructor
  · intro hb
    exact ⟨primHollowTet2 F, hprim.mp hb⟩
  · rintro ⟨ω, rfl⟩
    dsimp [bianchiCharge, tet_coboundary_d1]
    omega

/-- Non-exact monopole 2-cocycle on `∂Δ³ ≅ S²`: `⟨1, 0, 0, 0⟩` has nonzero Bianchi
charge `1` and lies outside `im(tet_coboundary_d1)`. -/
theorem hollow_tet_monopole_nonexact_witness :
    bianchiCharge ⟨1, 0, 0, 0⟩ = 1 ∧
    ¬ (∃ ω : TetChain1, tet_coboundary_d1 ω = ⟨1, 0, 0, 0⟩) := by
  refine ⟨rfl, ?_⟩
  intro hex
  have hb := (hollow_tet_exact_2cochain_iff_bianchi_zero ⟨1, 0, 0, 0⟩).2.mpr hex
  revert hb
  decide

def iabs (x : Int) : Int := if x < 0 then -x else x

def l1Norm2 (F : TetChain2) : Int :=
  iabs F.f0 + iabs F.f1 + iabs F.f2 + iabs F.f3

/-- Weak `L¹` duality on `C²(∂Δ³)`: for every 2-cochain `F` and every 1-cochain `ω`,
`|bianchiCharge F| ≤ ‖F - d₁ ω‖₁`. -/
theorem hollow_tet_l1_weak_duality (F : TetChain2) (ω : TetChain1) :
    iabs (bianchiCharge F) ≤ l1Norm2 (subTet2 F (tet_coboundary_d1 ω)) := by
  dsimp [bianchiCharge, l1Norm2, subTet2, tet_coboundary_d1]
  unfold iabs
  split <;> split <;> split <;> split <;> split <;> omega

/-- Strong `L¹` duality on `C²(∂Δ³)`: the rooted 1-cochain `primHollowTet2 F`
concentrates the entire 2-cochain residual on face `f3` with
`‖F - d₁ (primHollowTet2 F)‖₁ = |bianchiCharge F|`. -/
theorem hollow_tet_l1_strong_duality (F : TetChain2) :
    l1Norm2 (subTet2 F (tet_coboundary_d1 (primHollowTet2 F))) = iabs (bianchiCharge F) := by
  dsimp [l1Norm2, subTet2, tet_coboundary_d1, primHollowTet2, bianchiCharge]
  unfold iabs
  split <;> split <;> omega

theorem octahedron_euler_characteristic : (6 : Int) - 12 + 8 = 2 := by decide

structure OctChain1 where
  e0 : Int
  e1 : Int
  e2 : Int
  e3 : Int
  e4 : Int
  e5 : Int
  e6 : Int
  e7 : Int
  e8 : Int
  e9 : Int
  e10 : Int
  e11 : Int
  deriving DecidableEq, Repr

def zeroOct1 : OctChain1 := ⟨0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0⟩

instance : Zero OctChain1 := ⟨zeroOct1⟩

structure OctChain2 where
  f0 : Int
  f1 : Int
  f2 : Int
  f3 : Int
  f4 : Int
  f5 : Int
  f6 : Int
  f7 : Int
  deriving DecidableEq, Repr

def oct_d2 (c : OctChain2) : OctChain1 :=
  ⟨c.f0 - c.f4,
   c.f1 - c.f5,
   c.f2 - c.f6,
   c.f3 - c.f7,
   -c.f0 + c.f3,
   c.f0 - c.f1,
   c.f1 - c.f2,
   c.f2 - c.f3,
   c.f4 - c.f7,
   -c.f4 + c.f5,
   -c.f5 + c.f6,
   -c.f6 + c.f7⟩

theorem oct_d2_boundary_cancellation :
    oct_d2 ⟨1, 1, 1, 1, 1, 1, 1, 1⟩ = 0 := rfl

/-- 4-simplex pentachoron `Δ⁴` (`5` vertices, `10` edges, `10` triangles,
`5` tetrahedra, `1` 4-simplex): Euler characteristics of `∂Δ⁴ ≅ S³` (`0`)
and `Δ⁴` (`1`). -/
theorem pentachoron_euler_characteristic :
    (5 : Int) - 10 + 10 - 5 = 0 ∧ (5 : Int) - 10 + 10 - 5 + 1 = 1 := by decide

/-- 2-cochain on the 10 triangular faces of `Δ⁴`:
`(012, 013, 014, 023, 024, 034, 123, 124, 134, 234)`. -/
structure PentCochain2 where
  f012 : Int
  f013 : Int
  f014 : Int
  f023 : Int
  f024 : Int
  f034 : Int
  f123 : Int
  f124 : Int
  f134 : Int
  f234 : Int
  deriving DecidableEq, Repr

/-- 3-cochain on the 5 tetrahedral cells of `Δ⁴`:
`(t0123, t0124, t0134, t0234, t1234)`. -/
structure PentCochain3 where
  t0123 : Int
  t0124 : Int
  t0134 : Int
  t0234 : Int
  t1234 : Int
  deriving DecidableEq, Repr

theorem pent_cochain3_ext {a b : PentCochain3}
    (h0 : a.t0123 = b.t0123) (h1 : a.t0124 = b.t0124)
    (h2 : a.t0134 = b.t0134) (h3 : a.t0234 = b.t0234)
    (h4 : a.t1234 = b.t1234) : a = b := by
  cases a
  cases b
  simp only [PentCochain3.mk.injEq]
  exact ⟨h0, h1, h2, h3, h4⟩

/-- Coboundary `d₂ : C²(Δ⁴) → C³(Δ⁴)` on `Δ⁴`. -/
def pent_d2 (F : PentCochain2) : PentCochain3 :=
  { t0123 := F.f123 - F.f023 + F.f013 - F.f012
    t0124 := F.f124 - F.f024 + F.f014 - F.f012
    t0134 := F.f134 - F.f034 + F.f014 - F.f013
    t0234 := F.f234 - F.f034 + F.f024 - F.f023
    t1234 := F.f234 - F.f134 + F.f124 - F.f123 }

/-- Coboundary `d₃ : C³(Δ⁴) → ℤ` on the 4-simplex `(01234)`. -/
def pent_d3 (G : PentCochain3) : Int :=
  G.t1234 - G.t0234 + G.t0134 - G.t0124 + G.t0123

/-- Rooted 2-cochain primitive on `Δ⁴` (cone from vertex `0`): integrates a 3-cochain
`G` on the four faces `(f123, f124, f134, f234)` opposite vertex `0`. -/
def primPentachoron3 (G : PentCochain3) : PentCochain2 :=
  { f012 := 0, f013 := 0, f014 := 0, f023 := 0, f024 := 0, f034 := 0
    f123 := G.t0123, f124 := G.t0124, f134 := G.t0134, f234 := G.t0234 }

theorem pentachoron_d3_comp_d2_zero (F : PentCochain2) :
    pent_d3 (pent_d2 F) = 0 := by
  dsimp [pent_d3, pent_d2]
  omega

/-- Exactness of `C²(Δ⁴) → C³(Δ⁴) → C⁴(Δ⁴)` (`ker d₃ = im d₂` on `Δ⁴`). -/
theorem pentachoron_3cocycle_exact_iff (G : PentCochain3) :
    (pent_d3 G = 0 ↔ pent_d2 (primPentachoron3 G) = G) ∧
    (pent_d3 G = 0 ↔ ∃ F : PentCochain2, pent_d2 F = G) := by
  have hprim : pent_d3 G = 0 ↔ pent_d2 (primPentachoron3 G) = G := by
    constructor
    · intro h0
      apply pent_cochain3_ext <;> dsimp [pent_d2, primPentachoron3, pent_d3] at h0 ⊢ <;> omega
    · intro heq
      rw [← heq]
      exact pentachoron_d3_comp_d2_zero (primPentachoron3 G)
  refine ⟨hprim, ?_⟩
  constructor
  · intro h0
    exact ⟨primPentachoron3 G, hprim.mp h0⟩
  · rintro ⟨F, rfl⟩
    exact pentachoron_d3_comp_d2_zero F

structure Cayley2 where
  m00 : Int
  m01 : Int
  m10 : Int
  m11 : Int
  deriving DecidableEq, Repr

def cayley_step (w : Int) : Cayley2 :=
  ⟨1 - w * w, -2 * w, 2 * w, 1 - w * w⟩

def check_cayley_diag (w : Int) : Bool :=
  let C := cayley_step w
  C.m00 * C.m00 + C.m10 * C.m10 == (1 + w * w) ^ 2

def check_cayley_off_diag (w : Int) : Bool :=
  let C := cayley_step w
  C.m00 * C.m01 + C.m10 * C.m11 == 0

theorem cayley_isometry_w0 :
    check_cayley_diag 0 = true ∧ check_cayley_off_diag 0 = true := by decide

theorem cayley_isometry_w1 :
    check_cayley_diag 1 = true ∧ check_cayley_off_diag 1 = true := by decide

theorem cayley_isometry_w2 :
    check_cayley_diag 2 = true ∧ check_cayley_off_diag 2 = true := by decide

theorem cayley_isometry_w_neg1 :
    check_cayley_diag (-1) = true ∧ check_cayley_off_diag (-1) = true := by decide

theorem cayley_isometry_w_neg2 :
    check_cayley_diag (-2) = true ∧ check_cayley_off_diag (-2) = true := by decide

/-- General orthogonality of the columns of `cayley_step w` for every integer `w`. -/
theorem cayley_orthogonality_general (w : Int) :
    let C := cayley_step w
    C.m00 * C.m01 + C.m10 * C.m11 = 0 := by
  dsimp [cayley_step]
  have hneg : (-2 * w : Int) = -(2 * w) := by omega
  rw [hneg, Int.mul_neg, Int.mul_comm (1 - w * w) (2 * w), Int.add_left_neg]

end WitnessedDifference.HigherSimplicialCohomology
