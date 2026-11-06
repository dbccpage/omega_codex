/-!
# Constructive Gaussian-Integer Quantum Readout, MUBs, Entanglement, and Cosmos Bridges

Lean 4.33.0 core formalization (zero `placeholders`, zero `Classical.choice`) over `Int` and `GaussianInt`
covering:
1. Gaussian-integer ring `ℤ[i]`, orientation non-selection (`±J`), and 2-point Parseval duality (`IMG-03`).
2. `2×2` Gaussian-integer matrices, Gram operators, Born frame partition, unitary `X`/`Z`/`S` gates,
   scaled Hadamard, and 2-adic `2 * a² ≠ b²` irrationality (`IMG-04`).
3. Weyl-Heisenberg `X`/`Z` anticommutation, 3-basis qubit MUB overlap constancy, and Bell-state
   determinant non-factorizability (`IMG-05`).
4. Discrete Noether conservation (`IMG-06`), Landauer 2-to-1 erasure irreversibility (`IMG-09`),
   diagonal self-hosting evaluation obstruction (`IMG-10`), and substrate admission boundary (`OWE-01`–`OWE-06`).
-/

namespace WitnessedDifference.GaussianIntQuantumReadout

set_option linter.unusedSimpArgs false

/-! ## 1. Exact Gaussian Integers `ℤ[i]` and Parseval Duality (`IMG-03`) -/

structure GaussianInt where
  re : Int
  im : Int
  deriving DecidableEq, Repr

theorem gaussian_ext {z w : GaussianInt} (hre : z.re = w.re) (him : z.im = w.im) : z = w := by
  cases z; cases w; simp only [GaussianInt.mk.injEq] at hre him ⊢; exact ⟨hre, him⟩

def gzero : GaussianInt := ⟨0, 0⟩
def gone : GaussianInt := ⟨1, 0⟩
def gi : GaussianInt := ⟨0, 1⟩
def gadd (z w : GaussianInt) : GaussianInt := ⟨z.re + w.re, z.im + w.im⟩
def gneg (z : GaussianInt) : GaussianInt := ⟨-z.re, -z.im⟩
def gmul (z w : GaussianInt) : GaussianInt :=
  ⟨z.re * w.re - z.im * w.im, z.re * w.im + z.im * w.re⟩
def gconj (z : GaussianInt) : GaussianInt := ⟨z.re, -z.im⟩
def gnorm (z : GaussianInt) : Int := z.re * z.re + z.im * z.im

theorem gi_square : gmul gi gi = gneg gone := rfl

theorem gconj_involutive (z : GaussianInt) : gconj (gconj z) = z := by
  cases z; apply gaussian_ext <;> simp only [gconj] <;> omega

theorem int_sq_nonneg (x : Int) : 0 ≤ x * x := by
  if h : 0 ≤ x then
    exact Int.mul_nonneg h h
  else
    have hn : 0 ≤ -x := by omega
    have hp : 0 ≤ (-x) * (-x) := Int.mul_nonneg hn hn
    rw [Int.neg_mul, Int.mul_neg, Int.neg_neg] at hp
    exact hp

theorem gnorm_nonneg (z : GaussianInt) : 0 ≤ gnorm z :=
  Int.add_nonneg (int_sq_nonneg z.re) (int_sq_nonneg z.im)

/-- Two-point discrete Fourier / Parseval identity on `C₂`:
`(x₀ + x₁)² + (x₀ - x₁)² = 2 * (x₀² + x₁²)`. -/
theorem parseval_two_point_identity (x0 x1 : Int) :
    (x0 + x1) * (x0 + x1) + (x0 - x1) * (x0 - x1) = 2 * (x0 * x0 + x1 * x1) := by
  have h1 : (x0 + x1) * (x0 + x1) = x0 * x0 + x0 * x1 + x1 * x0 + x1 * x1 := by
    rw [Int.add_mul, Int.mul_add, Int.mul_add]
    omega
  have h2 : (x0 - x1) * (x0 - x1) = x0 * x0 - x0 * x1 - x1 * x0 + x1 * x1 := by
    have hsub : x0 - x1 = x0 + (-x1) := Int.sub_eq_add_neg
    rw [hsub, Int.add_mul, Int.mul_add, Int.mul_add, Int.mul_neg, Int.neg_mul,
      Int.mul_neg, Int.neg_mul, Int.neg_neg]
    omega
  omega

/-- Opposite complex orientations `±J` on `ℤ²` share the same diagonal norm `1` on basis vectors
while reversing the imaginary Hermitian pairing (`+i` vs `-i`). -/
theorem orientation_reversal_changes_hermitian_pairing :
    gnorm gone = 1 ∧ gnorm gi = 1 ∧
    gmul (gconj gone) gi = gi ∧
    gmul (gconj gone) (gneg gi) = gneg gi ∧
    gi ≠ gneg gi := by
  refine ⟨rfl, rfl, rfl, rfl, ?_⟩
  intro h
  have him : (1 : Int) = -1 := congrArg GaussianInt.im h
  omega

/-! ## 2. `2×2` Gaussian-Integer Matrices, Born Readout & 2-Adic Obstruction (`IMG-04`) -/

structure GMatrix2 where
  a00 : GaussianInt
  a01 : GaussianInt
  a10 : GaussianInt
  a11 : GaussianInt
  deriving DecidableEq, Repr

def mzero : GMatrix2 := ⟨gzero, gzero, gzero, gzero⟩
def midentity : GMatrix2 := ⟨gone, gzero, gzero, gone⟩
def mneg (A : GMatrix2) : GMatrix2 := ⟨gneg A.a00, gneg A.a01, gneg A.a10, gneg A.a11⟩
def madd (A B : GMatrix2) : GMatrix2 :=
  ⟨gadd A.a00 B.a00, gadd A.a01 B.a01, gadd A.a10 B.a10, gadd A.a11 B.a11⟩
def mdagger (A : GMatrix2) : GMatrix2 :=
  ⟨gconj A.a00, gconj A.a10, gconj A.a01, gconj A.a11⟩
def mmul (A B : GMatrix2) : GMatrix2 :=
  ⟨gadd (gmul A.a00 B.a00) (gmul A.a01 B.a10),
   gadd (gmul A.a00 B.a01) (gmul A.a01 B.a11),
   gadd (gmul A.a10 B.a00) (gmul A.a11 B.a10),
   gadd (gmul A.a10 B.a01) (gmul A.a11 B.a11)⟩
def gram (A : GMatrix2) : GMatrix2 := mmul (mdagger A) A
def mtrace (A : GMatrix2) : GaussianInt := gadd A.a00 A.a11
def frobeniusSquare (A : GMatrix2) : Int :=
  gnorm A.a00 + gnorm A.a01 + gnorm A.a10 + gnorm A.a11

theorem frobenius_nonneg (A : GMatrix2) : 0 ≤ frobeniusSquare A := by
  unfold frobeniusSquare
  have h00 := gnorm_nonneg A.a00
  have h01 := gnorm_nonneg A.a01
  have h10 := gnorm_nonneg A.a10
  have h11 := gnorm_nonneg A.a11
  omega

def proj0 : GMatrix2 := ⟨gone, gzero, gzero, gzero⟩
def proj1 : GMatrix2 := ⟨gzero, gzero, gzero, gone⟩
def xGate : GMatrix2 := ⟨gzero, gone, gone, gzero⟩
def zGate : GMatrix2 := ⟨gone, gzero, gzero, gneg gone⟩
def sGate : GMatrix2 := ⟨gone, gzero, gzero, gi⟩
def scaledHadamard : GMatrix2 := ⟨gone, gone, gone, gneg gone⟩

/-- Projectors `proj0` and `proj1` form a complete binary POVM / PVM (`P₀†P₀ + P₁†P₁ = I`). -/
theorem binary_projector_completeness :
    madd (gram proj0) (gram proj1) = midentity := rfl

/-- Exact Born-rule Frobenius mass partition for any 2×2 state factor `B` under `{proj0, proj1}`. -/
theorem born_projector_mass_partition (B : GMatrix2) :
    frobeniusSquare (mmul proj0 (mdagger B)) +
      frobeniusSquare (mmul proj1 (mdagger B)) = frobeniusSquare B := by
  rcases B with ⟨⟨r00, i00⟩, ⟨r01, i01⟩, ⟨r10, i10⟩, ⟨r11, i11⟩⟩
  simp only [frobeniusSquare, mmul, proj0, proj1, mdagger, gadd, gmul, gconj, gnorm, gone, gzero,
    Int.zero_mul, Int.mul_zero, Int.one_mul, Int.mul_one, Int.add_zero, Int.zero_add,
    Int.sub_zero, Int.neg_zero]
  have h00 : (-i00) * (-i00) = i00 * i00 := by rw [Int.neg_mul, Int.mul_neg, Int.neg_neg]
  have h01 : (-i01) * (-i01) = i01 * i01 := by rw [Int.neg_mul, Int.mul_neg, Int.neg_neg]
  have h10 : (-i10) * (-i10) = i10 * i10 := by rw [Int.neg_mul, Int.mul_neg, Int.neg_neg]
  have h11 : (-i11) * (-i11) = i11 * i11 := by rw [Int.neg_mul, Int.mul_neg, Int.neg_neg]
  omega

/-- Unitary gate certificates (`X`, `Z`, `S`) and scaled Hadamard `H†H = 2I`. -/
theorem unitary_and_scaled_hadamard_certificates :
    gram xGate = midentity ∧
    gram zGate = midentity ∧
    gram sGate = midentity ∧
    gram scaledHadamard = ⟨⟨2, 0⟩, gzero, gzero, ⟨2, 0⟩⟩ :=
  ⟨rfl, rfl, rfl, rfl⟩

theorem two_mul_sq (k : Nat) : (2 * k) * (2 * k) = 4 * (k * k) := by
  calc (2 * k) * (2 * k)
    _ = 2 * (k * (2 * k)) := Nat.mul_assoc 2 k (2 * k)
    _ = 2 * (2 * k * k) := by rw [Nat.mul_comm k (2 * k)]
    _ = 2 * (2 * (k * k)) := by rw [Nat.mul_assoc 2 k k]
    _ = (2 * 2) * (k * k) := (Nat.mul_assoc 2 2 (k * k)).symm
    _ = 4 * (k * k) := rfl

theorem two_mul_add_one_sq (k : Nat) :
    (2 * k + 1) * (2 * k + 1) = 4 * (k * k) + 4 * k + 1 := by
  rw [Nat.add_mul, Nat.mul_add, Nat.mul_add, two_mul_sq]
  omega

theorem nat_sq_parity_decomp (n : Nat) :
    (n = 2 * (n / 2) ∧ n * n = 4 * ((n / 2) * (n / 2))) ∨
    (n = 2 * (n / 2) + 1 ∧ n * n = 4 * ((n / 2) * (n / 2)) + 4 * (n / 2) + 1) := by
  have hdiv : n = 2 * (n / 2) + (n % 2) := by omega
  have hmod : n % 2 = 0 ∨ n % 2 = 1 := by omega
  rcases hmod with h0 | h1
  · left
    have hn : n = 2 * (n / 2) := by omega
    refine ⟨hn, ?_⟩
    conv => lhs; rw [hn]
    exact two_mul_sq (n / 2)
  · right
    have hn : n = 2 * (n / 2) + 1 := by omega
    refine ⟨hn, ?_⟩
    conv => lhs; rw [hn]
    exact two_mul_add_one_sq (n / 2)

/-- 2-adic parity descent (`GEN-WDP-68`): for all `a b : Nat` with `b > 0`, `2 * a^2 ≠ b^2`. -/
theorem nat_two_mul_sq_ne_sq : ∀ (b a : Nat), b > 0 → 2 * (a * a) ≠ b * b
  | b, a, hb, heq => by
    rcases nat_sq_parity_decomp b with ⟨_, hbsq⟩ | ⟨_, hbsq⟩
    · rcases nat_sq_parity_decomp a with ⟨_, hasq⟩ | ⟨_, hasq⟩
      · have hdesc : 2 * ((a / 2) * (a / 2)) = (b / 2) * (b / 2) := by omega
        have hb2_pos : b / 2 > 0 := by omega
        have hb2_lt : b / 2 < b := by omega
        exact nat_two_mul_sq_ne_sq (b / 2) (a / 2) hb2_pos hdesc
      · omega
    · omega
termination_by b => b

/-- Integer form of `GEN-WDP-68`: no rational fraction `a / b` (`b ≠ 0`) satisfies `2 * a^2 = b^2`. -/
theorem int_two_mul_sq_ne_sq (a b : Int) (hb : b ≠ 0) : 2 * (a * a) ≠ b * b := by
  intro heq
  have hnat : 2 * (a.natAbs * a.natAbs) = b.natAbs * b.natAbs := by
    have h1 : (2 * (a * a)).natAbs = (b * b).natAbs := congrArg Int.natAbs heq
    rw [Int.natAbs_mul 2 (a * a), Int.natAbs_mul a a, Int.natAbs_mul b b] at h1
    exact h1
  have hb_pos : b.natAbs > 0 := Int.natAbs_pos.mpr hb
  exact nat_two_mul_sq_ne_sq b.natAbs a.natAbs hb_pos hnat

/-! ## 3. Weyl-Heisenberg Anticommutation, Qubit MUB(2), and Bell Entanglement (`IMG-05`) -/

/-- Exact Weyl-Heisenberg clock-and-shift anticommutation: `X Z = - Z X`. -/
theorem xz_anticommutation :
    mmul xGate zGate = mneg (mmul zGate xGate) := rfl

structure GVec2 where
  v0 : GaussianInt
  v1 : GaussianInt
  deriving DecidableEq, Repr

def inner2 (u v : GVec2) : GaussianInt :=
  gadd (gmul (gconj u.v0) v.v0) (gmul (gconj u.v1) v.v1)

def overlapSq (u v : GVec2) : Int := gnorm (inner2 u v)

def z0 : GVec2 := ⟨⟨1, 0⟩, ⟨0, 0⟩⟩
def z1 : GVec2 := ⟨⟨0, 0⟩, ⟨1, 0⟩⟩
def xPlus : GVec2 := ⟨⟨1, 0⟩, ⟨1, 0⟩⟩
def xMinus : GVec2 := ⟨⟨1, 0⟩, ⟨-1, 0⟩⟩
def yPlus : GVec2 := ⟨⟨1, 0⟩, ⟨0, 1⟩⟩
def yMinus : GVec2 := ⟨⟨1, 0⟩, ⟨0, -1⟩⟩

/-- Complete 3-basis MUB(2) certificate: `{z0, z1}`, `{xPlus, xMinus}`, and `{yPlus, yMinus}`
are orthogonal within each basis and have constant unbiased overlap square (`1` or `2` according to
unnormalized norm product `2` or `4`). -/
theorem mub2_three_bases_orthogonality_and_unbiasedness :
    overlapSq z0 z1 = 0 ∧
    overlapSq xPlus xMinus = 0 ∧
    overlapSq yPlus yMinus = 0 ∧
    overlapSq z0 xPlus = 1 ∧ overlapSq z0 xMinus = 1 ∧
    overlapSq z1 xPlus = 1 ∧ overlapSq z1 xMinus = 1 ∧
    overlapSq z0 yPlus = 1 ∧ overlapSq z0 yMinus = 1 ∧
    overlapSq z1 yPlus = 1 ∧ overlapSq z1 yMinus = 1 ∧
    overlapSq xPlus yPlus = 2 ∧ overlapSq xPlus yMinus = 2 ∧
    overlapSq xMinus yPlus = 2 ∧ overlapSq xMinus yMinus = 2 := by
  decide

/-- Any separable 2-qubit integer state `(a0 * b0, a0 * b1, a1 * b0, a1 * b1)` has vanishing
2×2 Schmidt determinant `(a0 * b0) * (a1 * b1) - (a0 * b1) * (a1 * b0) = 0`. -/
theorem product_state_schmidt_det_zero (a0 a1 b0 b1 : Int) :
    (a0 * b0) * (a1 * b1) - (a0 * b1) * (a1 * b0) = 0 := by
  have h1 : (a0 * b0) * (a1 * b1) = a0 * (b0 * (a1 * b1)) := Int.mul_assoc a0 b0 (a1 * b1)
  have h2 : b0 * (a1 * b1) = a1 * (b0 * b1) := by
    rw [← Int.mul_assoc b0 a1 b1, Int.mul_comm b0 a1, Int.mul_assoc a1 b0 b1]
  have h3 : (a0 * b1) * (a1 * b0) = a0 * (b1 * (a1 * b0)) := Int.mul_assoc a0 b1 (a1 * b0)
  have h4 : b1 * (a1 * b0) = a1 * (b0 * b1) := by
    rw [← Int.mul_assoc b1 a1 b0, Int.mul_comm b1 a1, Int.mul_assoc a1 b1 b0, Int.mul_comm b1 b0]
  rw [h1, h2, h3, h4, Int.sub_self]

/-- The unnormalized Bell state `(1, 0, 0, 1)` has Schmidt determinant `1 ≠ 0`, so no product state
`(a0 * b0, a0 * b1, a1 * b0, a1 * b1)` can equal `(1, 0, 0, 1)`. -/
theorem bell_state_nonfactorizable (a0 a1 b0 b1 : Int) :
    ¬ (a0 * b0 = 1 ∧ a0 * b1 = 0 ∧ a1 * b0 = 0 ∧ a1 * b1 = 1) := by
  rintro ⟨h00, h01, h10, h11⟩
  have hdet := product_state_schmidt_det_zero a0 a1 b0 b1
  rw [h00, h01, h10, h11] at hdet
  omega

/-! ## 4. Discrete Noether Conservation, Landauer Erasure, Self-Hosting & Substrate Boundaries
    (`IMG-06`, `IMG-09`, `IMG-10`, `OWE-01`–`OWE-06`) -/

/-- Discrete Noether charge conservation on a 2-vertex interval: if local continuity holds at both
sites (`(q0' - q0) + j01 = 0` and `(q1' - q1) - j01 = 0`), then total charge `q0' + q1' = q0 + q1`. -/
theorem discrete_noether_charge_conserved (q0 q1 q0' q1' j01 : Int)
    (h0 : (q0' - q0) + j01 = 0) (h1 : (q1' - q1) - j01 = 0) :
    q0' + q1' = q0 + q1 := by
  omega

/-- Landauer 2-to-1 erasure irreversibility (`IMG-09`): if a map `erase : Bool → Bool` merges
`false` and `true` (`erase false = erase true`), then no recovery map `rec : Bool → Bool` can invert
`erase` on both inputs. -/
theorem landauer_merger_irreversible (erase rec : Bool → Bool)
    (hmerge : erase false = erase true) :
    ¬ (rec (erase false) = false ∧ rec (erase true) = true) := by
  rintro ⟨hf, ht⟩
  rw [hmerge] at hf
  have hbad : false = true := hf.symm.trans ht
  cases hbad

/-- Diagonal self-hosting obstruction (`IMG-10`): no total Boolean evaluator `eval : Nat → Nat → Bool`
can represent its own negated diagonal `fun n => !(eval n n)`. -/
theorem self_hosting_diagonal_obstruction (eval : Nat → Nat → Bool) :
    ¬ ∃ code : Nat, ∀ n : Nat, eval code n = !(eval n n) := by
  rintro ⟨code, hcode⟩
  have hself := hcode code
  cases hval : eval code code <;> rw [hval] at hself <;> cases hself

/-- Substrate admission boundary certificate (`OWE-01`–`OWE-06`):
on `Unit`, no off-diagonal pair `a ≠ b` exists (`S1`), whereas `Bool` has exactly 2 elements (`false ≠ true`),
and no 3 Bool values `b0, b1, b2` can be pairwise distinct (`M1`). -/
theorem substrate_admissions_s1_m1_boundary :
    (¬ ∃ a b : Unit, a ≠ b) ∧
    (∃ a b : Bool, a ≠ b) ∧
    (∀ b0 b1 b2 : Bool, ¬ (b0 ≠ b1 ∧ b0 ≠ b2 ∧ b1 ≠ b2)) := by
  refine ⟨?_, ⟨false, true, by decide⟩, ?_⟩
  · rintro ⟨⟨⟩, ⟨⟩, hne⟩
    exact hne rfl
  · intro b0 b1 b2
    cases b0 <;> cases b1 <;> cases b2 <;> decide

end WitnessedDifference.GaussianIntQuantumReadout
