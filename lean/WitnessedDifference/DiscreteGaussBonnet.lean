/-!
# Discrete Gauss-Bonnet, Bianchi Cochain Curvature, and Regge Deficit Split

Constructive Lean-core port of `CochainCurvatureReggeDeficit` and discrete
Gauss-Bonnet combinatorial identities (`zero proof placeholders`, `zero Classical.choice`,
allowed axioms restricted to `propext` and `Quot.sound`).

Main results:
1. Tetrahedral cochain curvature `d1 : Cochain1 → Cochain2`, exactness
   `d1 (d0 φ) = 0` (`cochain_curvature_of_coboundary_zero`), gauge invariance
   (`cochain_curvature_gauge_invariant`), linear scaling (`cochain_curvature_linear_scaling`),
   and the oriented discrete Bianchi identity `bianchiCycleSum (d1 ω) = 0`
   (`tetrahedral_bianchi_identity`).
2. `OBL-R03` split between cochain curvature `d1 ω` and Regge vertex deficit
   `equilateralVertexDeficit sixthTurn k = (6 - k) * sixthTurn`:
   scale-invariance dichotomy (`obl_r03_scaling_dichotomy_cochain_vs_regge`),
   flat 6-triangle hinge with arbitrary nonzero cochain curvature
   (`obl_r03_flat_hinge_with_arbitrary_cochain_curvature`), pure-gauge zero
   cochain curvature with positive tetrahedral Regge deficit
   (`obl_r03_zero_cochain_curvature_with_positive_regge_deficit`), and global
   Gauss-Bonnet vs. Bianchi sum contrast (`obl_r03_gauss_bonnet_vs_bianchi_sum_contrast`).
3. General combinatorial discrete Gauss-Bonnet identity for closed triangulated
   surfaces (`discrete_gauss_bonnet_triangulated_surface`) and Platonic solid
   instances (`platonic_triangulated_gauss_bonnet`).
4. `OBL-R01` lattice-spacing light-cone calibration underdetermination and
   Manhattan vs. Euclidean anisotropy (`obl_r01_any_light_cone_slope_by_spacing_calibration`,
   `obl_r01_spacing_calibration_injective`,
   `obl_r01_causal_character_depends_on_uncalibrated_spacing`,
   `obl_r01_manhattan_vs_euclidean_light_cone_anisotropy`).
-/

namespace WitnessedDifference.DiscreteGaussBonnet

/-- 0-cochain on the 4 vertices `(0, 1, 2, 3)` of `K_4^{(2)}`. -/
structure Cochain0 where
  p0 : Int
  p1 : Int
  p2 : Int
  p3 : Int
  deriving DecidableEq, Repr

/-- 1-cochain on the 6 oriented edges `(01, 02, 03, 12, 13, 23)` of `K_4^{(2)}`. -/
structure Cochain1 where
  e01 : Int
  e02 : Int
  e03 : Int
  e12 : Int
  e13 : Int
  e23 : Int
  deriving DecidableEq, Repr

/-- 2-cochain on the 4 oriented triangular faces `(012, 013, 023, 123)` of `K_4^{(2)}`. -/
structure Cochain2 where
  f012 : Int
  f013 : Int
  f023 : Int
  f123 : Int
  deriving DecidableEq, Repr

theorem cochain2_ext {a b : Cochain2}
    (h012 : a.f012 = b.f012) (h013 : a.f013 = b.f013)
    (h023 : a.f023 = b.f023) (h123 : a.f123 = b.f123) : a = b := by
  cases a
  cases b
  simp only [Cochain2.mk.injEq]
  exact ⟨h012, h013, h023, h123⟩

/-- Coboundary operator `d_0 : C^0 → C^1` sending `φ` to `(d_0 φ)(u,v) = φ(v) - φ(u)`. -/
def d0 (φ : Cochain0) : Cochain1 :=
  { e01 := φ.p1 - φ.p0
    e02 := φ.p2 - φ.p0
    e03 := φ.p3 - φ.p0
    e12 := φ.p2 - φ.p1
    e13 := φ.p3 - φ.p1
    e23 := φ.p3 - φ.p2 }

/-- Pointwise addition of 1-cochains. -/
def add1 (ω η : Cochain1) : Cochain1 :=
  { e01 := ω.e01 + η.e01
    e02 := ω.e02 + η.e02
    e03 := ω.e03 + η.e03
    e12 := ω.e12 + η.e12
    e13 := ω.e13 + η.e13
    e23 := ω.e23 + η.e23 }

/-- Scalar multiplication of a 1-cochain by `c : Int`. -/
def smul1 (c : Int) (ω : Cochain1) : Cochain1 :=
  { e01 := c * ω.e01
    e02 := c * ω.e02
    e03 := c * ω.e03
    e12 := c * ω.e12
    e13 := c * ω.e13
    e23 := c * ω.e23 }

/-- Scalar multiplication of a 2-cochain by `c : Int`. -/
def smul2 (c : Int) (F : Cochain2) : Cochain2 :=
  { f012 := c * F.f012
    f013 := c * F.f013
    f023 := c * F.f023
    f123 := c * F.f123 }

/-- Cochain curvature / face holonomy operator `d_1 : C^1 → C^2` on `K_4^{(2)}`:
`(d_1 ω)(u,v,w) = ω(u,v) + ω(v,w) - ω(u,w)`. -/
def d1 (ω : Cochain1) : Cochain2 :=
  { f012 := ω.e01 + ω.e12 - ω.e02
    f013 := ω.e01 + ω.e13 - ω.e03
    f023 := ω.e02 + ω.e23 - ω.e03
    f123 := ω.e12 + ω.e23 - ω.e13 }

/-- Oriented 2-cycle boundary sum `d_2 : C^2 → Int` on the closed tetrahedron `∂(0123)`:
`F(012) - F(013) + F(023) - F(123)`. -/
def bianchiCycleSum (F : Cochain2) : Int :=
  F.f012 - F.f013 + F.f023 - F.f123

def zeroCochain1 : Cochain1 :=
  { e01 := 0, e02 := 0, e03 := 0, e12 := 0, e13 := 0, e23 := 0 }

def zeroCochain2 : Cochain2 :=
  { f012 := 0, f013 := 0, f023 := 0, f123 := 0 }

theorem cochain_curvature_of_coboundary_zero (φ : Cochain0) :
    d1 (d0 φ) = zeroCochain2 := by
  apply cochain2_ext <;> dsimp [d1, d0, zeroCochain2] <;> omega

theorem cochain_curvature_gauge_invariant (ω : Cochain1) (φ : Cochain0) :
    d1 (add1 ω (d0 φ)) = d1 ω := by
  apply cochain2_ext <;> dsimp [d1, add1, d0] <;> omega

theorem cochain_curvature_linear_scaling (c : Int) (ω : Cochain1) :
    d1 (smul1 c ω) = smul2 c (d1 ω) := by
  apply cochain2_ext <;> dsimp [d1, smul1, smul2] <;>
    rw [Int.mul_sub, Int.mul_add]

theorem tetrahedral_bianchi_identity (ω : Cochain1) :
    bianchiCycleSum (d1 ω) = 0 := by
  dsimp [bianchiCycleSum, d1]
  omega

/-- Regge vertex/hinge angle deficit `fullTurn - angleSum` in integer sixth-turn units. -/
def reggeVertexDeficit (fullTurn angleSum : Int) : Int :=
  fullTurn - angleSum

/-- Regge deficit at a vertex where `k` equilateral triangles meet, measured in
integer multiples of `sixthTurn` (`fullTurn = 6 * sixthTurn`). -/
def equilateralVertexDeficit (sixthTurn k : Int) : Int :=
  reggeVertexDeficit (6 * sixthTurn) (k * sixthTurn)

def singleEdgeCochain1 (q : Int) : Cochain1 :=
  { e01 := 0, e02 := 0, e03 := 0, e12 := q, e13 := 0, e23 := 0 }

theorem obl_r03_scaling_dichotomy_cochain_vs_regge
    (sixthTurn k s q : Int) :
    reggeVertexDeficit (6 * sixthTurn) (k * sixthTurn) =
      equilateralVertexDeficit sixthTurn k ∧
    (d1 (smul1 s (singleEdgeCochain1 q))).f012 = s * q := by
  refine ⟨rfl, ?_⟩
  dsimp [d1, smul1, singleEdgeCochain1]
  omega

theorem obl_r03_flat_hinge_with_arbitrary_cochain_curvature
    (sixthTurn q : Int) (hq : q ≠ 0) :
    equilateralVertexDeficit sixthTurn 6 = 0 ∧
    (d1 (singleEdgeCochain1 q)).f012 = q ∧
    (d1 (singleEdgeCochain1 q)).f123 = q ∧
    (d1 (singleEdgeCochain1 q)).f012 ≠ 0 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · dsimp [equilateralVertexDeficit, reggeVertexDeficit]
    omega
  · dsimp [d1, singleEdgeCochain1]
    omega
  · dsimp [d1, singleEdgeCochain1]
    omega
  · dsimp [d1, singleEdgeCochain1]
    omega

theorem obl_r03_zero_cochain_curvature_with_positive_regge_deficit
    (φ : Cochain0) (sixthTurn : Int) (hTurn : 0 < sixthTurn) :
    d1 (d0 φ) = zeroCochain2 ∧
    equilateralVertexDeficit sixthTurn 3 = 3 * sixthTurn ∧
    0 < equilateralVertexDeficit sixthTurn 3 := by
  refine ⟨cochain_curvature_of_coboundary_zero φ, ?_, ?_⟩
  · dsimp [equilateralVertexDeficit, reggeVertexDeficit]
    omega
  · dsimp [equilateralVertexDeficit, reggeVertexDeficit]
    omega

theorem obl_r03_gauss_bonnet_vs_bianchi_sum_contrast
    (ω : Cochain1) (sixthTurn : Int) (hTurn : sixthTurn ≠ 0) :
    4 * equilateralVertexDeficit sixthTurn 3 = 2 * (6 * sixthTurn) ∧
    4 * equilateralVertexDeficit sixthTurn 3 ≠ 0 ∧
    bianchiCycleSum (d1 ω) = 0 := by
  refine ⟨?_, ?_, tetrahedral_bianchi_identity ω⟩
  · dsimp [equilateralVertexDeficit, reggeVertexDeficit]
    omega
  · dsimp [equilateralVertexDeficit, reggeVertexDeficit]
    omega

/-- Combinatorial discrete Gauss-Bonnet theorem for any closed triangulated surface:
if `2 * E = 3 * F` and the sum of vertex triangle-degrees is `sumK = 2 * E`, then
the total Regge deficit `6 * V - sumK` (in sixth-turn units) equals `6 * (V - E + F)`. -/
theorem discrete_gauss_bonnet_triangulated_surface
    (V E F sumK : Int)
    (htri : 2 * E = 3 * F)
    (hdeg : sumK = 2 * E) :
    6 * V - sumK = 6 * (V - E + F) := by
  omega

/-- Platonic triangulated surfaces (tetrahedron `V=4, k=3`, octahedron `V=6, k=4`,
icosahedron `V=12, k=5`) all have total Regge deficit `12 * sixthTurn = 2 * fullTurn`. -/
theorem platonic_triangulated_gauss_bonnet (sixthTurn : Int) :
    4 * equilateralVertexDeficit sixthTurn 3 = 12 * sixthTurn ∧
    6 * equilateralVertexDeficit sixthTurn 4 = 12 * sixthTurn ∧
    12 * equilateralVertexDeficit sixthTurn 5 = 12 * sixthTurn := by
  dsimp [equilateralVertexDeficit, reggeVertexDeficit]
  refine ⟨by omega, by omega, by omega⟩

/-- Cleared-denominator light-cone calibration relation `ax = cTarget * at_`. -/
def lightConeCalibrated (ax at_ cTarget : Int) : Prop :=
  ax = cTarget * at_

theorem obl_r01_any_light_cone_slope_by_spacing_calibration
    (at_ cTarget : Int) (hat : at_ ≠ 0) (hc : cTarget ≠ 0) :
    lightConeCalibrated (cTarget * at_) at_ cTarget ∧
    (cTarget * at_) ≠ 0 := by
  refine ⟨rfl, ?_⟩
  intro hmul
  rcases Int.mul_eq_zero.mp hmul with h1 | h2
  · exact hc h1
  · exact hat h2

theorem obl_r01_spacing_calibration_injective
    (at_ ax1 ax2 cTarget : Int)
    (h1 : lightConeCalibrated ax1 at_ cTarget)
    (h2 : lightConeCalibrated ax2 at_ cTarget) :
    ax1 = ax2 := by
  unfold lightConeCalibrated at h1 h2
  omega

/-- Cleared-denominator Minkowskian interval `(c * Nt * at_)^2 - (Nx * ax)^2`. -/
def discreteMinkowskiInterval (c at_ ax Nt Nx : Int) : Int :=
  (c * Nt * at_) * (c * Nt * at_) - (Nx * ax) * (Nx * ax)

/-- For displacement `(Nt, Nx) = (2, 3)` at `c = 1`:
- with `(at_, ax) = (2, 1)` (ratio `ax/at_ = 1/2`), interval is `16 - 9 = 7 > 0` (timelike);
- with `(at_, ax) = (3, 2)` (ratio `ax/at_ = 2/3`), interval is `36 - 36 = 0` (null);
- with `(at_, ax) = (1, 1)` (ratio `ax/at_ = 1`), interval is `4 - 9 = -5 < 0` (spacelike). -/
theorem obl_r01_causal_character_depends_on_uncalibrated_spacing :
    discreteMinkowskiInterval 1 2 1 2 3 = 7 ∧
    0 < discreteMinkowskiInterval 1 2 1 2 3 ∧
    discreteMinkowskiInterval 1 3 2 2 3 = 0 ∧
    discreteMinkowskiInterval 1 1 1 2 3 = -5 ∧
    discreteMinkowskiInterval 1 1 1 2 3 < 0 := by
  decide

def manhattanSteps (dx dy : Nat) : Nat :=
  dx + dy

def euclideanSqRadius (dx dy : Nat) : Nat :=
  dx * dx + dy * dy

theorem obl_r01_manhattan_vs_euclidean_light_cone_anisotropy :
    euclideanSqRadius 3 4 = 25 ∧
    euclideanSqRadius 5 0 = 25 ∧
    euclideanSqRadius 3 4 = euclideanSqRadius 5 0 ∧
    manhattanSteps 3 4 = 7 ∧
    manhattanSteps 5 0 = 5 ∧
    manhattanSteps 3 4 ≠ manhattanSteps 5 0 := by
  decide

end WitnessedDifference.DiscreteGaussBonnet
