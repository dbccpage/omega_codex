import TorsorAndOperations
import ZeroEquivalence

/-!
# Cochain windows, L1 weights, natural sections, and local-global obstructions (Slice 4)

Reconstructs the discrete-cut to linear-cochain-window independence theorems
(OQ-02, with the RT-04 cyclic-to-simplicial orientation bridge and 3-simplex
boundary cancellation d^2 = 0), positive L1 weight non-forcing versus transitive
symmetry forcing (OQ-07, with the RT-11 non-edge-transitive countermodel),
presentation naturality and natural sections (RT-07), and the 3-locus Bool
triangle gluing obstruction and loop-holonomy descent obstruction (RT-08, RT-06).
-/
set_option autoImplicit false

namespace OmegaCodex.LocalGlobalObstruction

open OmegaCodex.PrimitiveDifference
open OmegaCodex.ZeroEquivalence
open OmegaCodex.TorsorAndOperations

/-! ## Section 1: OQ-02 Cochain window, RT-04 orientation bridge, & d^2 = 0 -/

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

def d0CyclicInt (c : Cochain0Int) : Cochain1Int :=
  let (v0, v1, v2) := c
  (v1 - v0, v2 - v1, v0 - v2)

def d1CyclicInt (h : Cochain1Int) : Int :=
  let (e01, e12, e20) := h
  e01 + e12 + e20

def cycToSimp (h : Cochain1Int) : Cochain1Int :=
  let (e01, e12, e20) := h
  (e01, e12, -e20)

/-- RT-04 orientation bridge: the sign flip `cycToSimp (e01, e12, e20) = (e01, e12, -e20)`
intertwines cyclic edge orientation `(e01, e12, e20)` with simplicial edge orientation
`(e01, e12, e02)`. -/
theorem rt04_cyclic_to_simplicial_intertwines (c : Cochain0Int) (h : Cochain1Int) :
    cycToSimp (d0CyclicInt c) = d0SignedInt c ∧
    d1SignedCycInt (cycToSimp h) = d1CyclicInt h ∧
    cycToSimp (cycToSimp h) = h := by
  rcases c with ⟨v0, v1, v2⟩
  rcases h with ⟨e01, e12, e20⟩
  simp only [cycToSimp, d0CyclicInt, d0SignedInt, d1SignedCycInt, d1CyclicInt]
  refine ⟨?_, ?_, ?_⟩
  · ext <;> simp <;> omega
  · omega
  · ext <;> simp

/-- 3-simplex (tetrahedron) 1-cochains `(e01, e02, e03, e12, e13, e23)` and
2-cochains `(f123, f023, f013, f012)` (`BoundaryCancellation.lean`). -/
abbrev Tet1Int := Int × Int × Int × Int × Int × Int
abbrev Tet2Int := Int × Int × Int × Int

def d1TetSigned (h : Tet1Int) : Tet2Int :=
  let (e01, e02, e03, e12, e13, e23) := h
  (e23 - e13 + e12, e23 - e03 + e02, e13 - e03 + e01, e12 - e02 + e01)

def d2TetSigned (f : Tet2Int) : Int :=
  let (f123, f023, f013, f012) := f
  f123 - f023 + f013 - f012

def d1TetUnsigned (h : Tet1Int) : Tet2Int :=
  let (e01, e02, e03, e12, e13, e23) := h
  (e23 + e13 + e12, e23 + e03 + e02, e13 + e03 + e01, e12 + e02 + e01)

def d2TetUnsigned (f : Tet2Int) : Int :=
  let (f123, f023, f013, f012) := f
  f123 + f023 + f013 + f012

theorem boundary_cancellation_tet_signed (h : Tet1Int) :
    d2TetSigned (d1TetSigned h) = 0 := by
  rcases h with ⟨e01, e02, e03, e12, e13, e23⟩
  simp only [d2TetSigned, d1TetSigned]
  omega

theorem boundary_cancellation_tet_unsigned_fails :
    d2TetUnsigned (d1TetUnsigned (1, 0, 0, 0, 0, 0)) = 2 ∧ (2 : Int) ≠ 0 := by
  decide

/-! ## Section 2: OQ-07 Positive L1 weights & RT-11 non-edge-transitive countermodel -/

abbrev Weight3 := Nat × Nat × Nat
abbrev Cochain3 := Int × Int × Int

def validRepair : Cochain3 → Prop
  | (v1, v2, v3) => v1 + v2 + v3 = 1

instance (v : Cochain3) : Decidable (validRepair v) := by
  rcases v with ⟨v1, v2, v3⟩
  unfold validRepair
  infer_instance

def weightedL1 : Weight3 → Cochain3 → Nat
  | (w1, w2, w3), (v1, v2, v3) =>
      w1 * v1.natAbs + w2 * v2.natAbs + w3 * v3.natAbs

def wAsym1 : Weight3 := (1, 2, 2)
def wAsym2 : Weight3 := (2, 1, 2)

def basis1 : Cochain3 := (1, 0, 0)
def basis2 : Cochain3 := (0, 1, 0)

def rotEdge : Cochain3 → Cochain3
  | (v1, v2, v3) => (v2, v3, v1)

theorem rotEdge_preserves_validRepair (v : Cochain3) :
    validRepair (rotEdge v) ↔ validRepair v := by
  rcases v with ⟨v1, v2, v3⟩
  simp only [validRepair, rotEdge]
  constructor <;> (intro h; omega)

theorem oq07_weights_not_forced_without_symmetry :
    (validRepair basis1 ∧ weightedL1 wAsym1 basis1 = 1 ∧
      ∀ v : Cochain3, validRepair v → v ≠ basis1 → 2 ≤ weightedL1 wAsym1 v) ∧
    (validRepair basis2 ∧ weightedL1 wAsym2 basis2 = 1 ∧
      ∀ v : Cochain3, validRepair v → v ≠ basis2 → 2 ≤ weightedL1 wAsym2 v) := by
  refine ⟨⟨by decide, by decide, ?_⟩, ⟨by decide, by decide, ?_⟩⟩
  · intro ⟨v1, v2, v3⟩ hval hne
    simp only [validRepair] at hval
    simp only [weightedL1, wAsym1]
    if hv2 : v2 = 0 then
      if hv3 : v3 = 0 then
        have hv1 : v1 = 1 := by omega
        exfalso
        exact hne (by subst hv1 hv2 hv3; rfl)
      else
        omega
    else
      omega
  · intro ⟨v1, v2, v3⟩ hval hne
    simp only [validRepair] at hval
    simp only [weightedL1, wAsym2]
    if hv1 : v1 = 0 then
      if hv3 : v3 = 0 then
        have hv2 : v2 = 1 := by omega
        exfalso
        exact hne (by subst hv1 hv2 hv3; rfl)
      else
        omega
    else
      omega

theorem oq07_transitive_symmetry_forces_equal_weights (w : Weight3)
    (hinv : ∀ v : Cochain3, validRepair v → weightedL1 w (rotEdge v) = weightedL1 w v) :
    w.1 = w.2.1 ∧ w.2.1 = w.2.2 := by
  rcases w with ⟨w1, w2, w3⟩
  have h1 : w3 = w1 := by
    have := hinv basis1 (by decide)
    simpa [weightedL1, rotEdge, basis1] using this
  have h2 : w1 = w2 := by
    have := hinv basis2 (by decide)
    simpa [weightedL1, rotEdge, basis2] using this
  exact ⟨h2, h2.symm.trans h1.symm⟩

def swapEdge23 : Cochain3 → Cochain3
  | (v1, v2, v3) => (v1, v3, v2)

/-- RT-11 countermodel: a non-edge-transitive symmetry (`swapEdge23`, which fixes
edge 1 and swaps edges 2 and 3) preserves `validRepair` and leaves `weightedL1 wAsym1`
invariant while allowing unequal weights `wAsym1 = (1, 2, 2)` (`1 ≠ 2`). -/
theorem rt11_non_transitive_swap23_allows_unequal_weights :
    (∀ v : Cochain3, validRepair (swapEdge23 v) ↔ validRepair v) ∧
    (∀ v : Cochain3, weightedL1 wAsym1 (swapEdge23 v) = weightedL1 wAsym1 v) ∧
    wAsym1.1 ≠ wAsym1.2.1 := by
  refine ⟨?_, ?_, by decide⟩
  · intro ⟨v1, v2, v3⟩
    simp only [validRepair, swapEdge23]
    constructor <;> (intro h; omega)
  · intro ⟨v1, v2, v3⟩
    simp only [weightedL1, wAsym1, swapEdge23]
    omega

/-! ## Section 3: RT-07 PresentationNaturality and NaturalSections -/

def AdmissiblePair {α β : Type} (obs : α → β) (p : α × α) : Prop :=
  obs p.1 ≠ obs p.2

def FixedPair {α : Type} (σ : α → α) (p : α × α) : Prop :=
  σ p.1 = p.1 ∧ σ p.2 = p.2

def NaturalSection {α β : Type} (obs : α → β) (σ : α → α)
    (sec : Unit → α × α) : Prop :=
  AdmissiblePair obs (sec ()) ∧ (σ (sec ()).1, σ (sec ()).2) = sec ()

theorem fixed_pair_of_natural_section {α β : Type} (obs : α → β) (σ : α → α)
    (sec : Unit → α × α) (hnat : NaturalSection obs σ sec) :
    AdmissiblePair obs (sec ()) ∧ FixedPair σ (sec ()) := by
  refine ⟨hnat.1, ?_⟩
  have h1 : σ (sec ()).1 = (sec ()).1 := congrArg Prod.fst hnat.2
  have h2 : σ (sec ()).2 = (sec ()).2 := congrArg Prod.snd hnat.2
  exact ⟨h1, h2⟩

theorem natural_section_exists_iff_fixed_pair {α β : Type}
    (obs : α → β) (σ : α → α) :
    (∃ sec : Unit → α × α, NaturalSection obs σ sec) ↔
    (∃ p : α × α, AdmissiblePair obs p ∧ FixedPair σ p) := by
  constructor
  · rintro ⟨sec, hnat⟩
    exact ⟨sec (), fixed_pair_of_natural_section obs σ sec hnat⟩
  · rintro ⟨⟨x, y⟩, hadm, hfix1, hfix2⟩
    refine ⟨fun _ => (x, y), hadm, ?_⟩
    exact Prod.ext hfix1 hfix2

/-- RT-07 countermodel on `Fin 3` (`10_post_seal_checks.py` [2]): `swap3` has a
fixed carrier point `0`, yet no pair `p : Fin 3 × Fin 3` is both admissible under
`id` (`p.1 ≠ p.2`) and fixed by `swap3`. -/
theorem rt07_carrier_fixed_point_insufficient_fin3 :
    swap3 ⟨0, by decide⟩ = ⟨0, by decide⟩ ∧
    ¬ ∃ p : Fin 3 × Fin 3, p.1 ≠ p.2 ∧ swap3 p.1 = p.1 ∧ swap3 p.2 = p.2 := by
  refine ⟨rfl, ?_⟩
  rintro ⟨⟨x, y⟩, hne, hx, hy⟩
  have hx0 : x = ⟨0, by decide⟩ := by
    rcases x with ⟨vx, hlt⟩
    match vx, hlt, hx with
    | 0, _, _ => rfl
    | 1, _, h1 => cases h1
    | 2, _, h2 => cases h2
  have hy0 : y = ⟨0, by decide⟩ := by
    rcases y with ⟨vy, hlt⟩
    match vy, hlt, hy with
    | 0, _, _ => rfl
    | 1, _, h1 => cases h1
    | 2, _, h2 => cases h2
  exact hne (hx0.trans hy0.symm)

/-- RT-07 (`PresentationNaturality.lean:335-339`): on `Bool` with `obs = id` and
`σ = counterpart`, raw admissible selection is possible (`(false, true)` is an
admissible pair), whereas naturality is obstructed (`¬ ∃ sec, NaturalSection id counterpart sec`). -/
theorem selection_is_possible_naturality_is_not :
    AdmissiblePair (fun x : Bool => x) (false, true) ∧
    ¬ ∃ sec : Unit → Bool × Bool,
      NaturalSection (fun x : Bool => x) counterpart sec := by
  refine ⟨Bool.noConfusion, ?_⟩
  intro hex
  rcases (natural_section_exists_iff_fixed_pair (fun x : Bool => x)
    counterpart).mp hex with
    ⟨⟨x, _⟩, _, hfix1, _⟩
  cases x <;> cases hfix1


/-! ## Section 4: RT-08 ObserverDescent Bool triangle & RT-06 FidelityClosure -/

/-- Untwisted 3-locus `Bool` triangle cover (`L01, L12, L20`): every local value
`b : Bool` extends to a unique global section `(v0, v1, v2)` with `v0 = b`,
`v0 = v1`, `v1 = v2`, and `v2 = v0`. -/
theorem untwisted_triangle_glues_uniquely (b : Bool) :
    (b = b ∧ b = b ∧ b = b) ∧
    ∀ v0 v1 v2 : Bool,
      (v0 = b ∧ v0 = v1 ∧ v1 = v2 ∧ v2 = v0) →
      (v0 = b ∧ v1 = b ∧ v2 = b) := by
  refine ⟨⟨rfl, rfl, rfl⟩, ?_⟩
  rintro v0 v1 v2 ⟨hv0, hv01, hv12, _⟩
  exact ⟨hv0, hv01.symm.trans hv0, hv12.symm.trans (hv01.symm.trans hv0)⟩

/-- RT-08 twisted 3-locus `Bool` triangle cover (`10_post_seal_checks.py` [3],
`wdp.md` §2.3): every 2-locus subcover has a valid assignment, whereas the
3-locus cover `v0 = v1 ∧ v1 = v2 ∧ v2 ≠ v0` has zero global solutions. -/
theorem twisted_triangle_pairwise_solvable_no_global :
    (∃ v0 v1 v2 : Bool, v0 = v1 ∧ v1 = v2) ∧
    (∃ v0 v1 v2 : Bool, v1 = v2 ∧ v2 ≠ v0) ∧
    (∃ v0 v1 v2 : Bool, v2 ≠ v0 ∧ v0 = v1) ∧
    ¬ (∃ v0 v1 v2 : Bool, v0 = v1 ∧ v1 = v2 ∧ v2 ≠ v0) := by
  refine ⟨⟨false, false, false, rfl, rfl⟩,
          ⟨true, false, false, rfl, by decide⟩,
          ⟨false, false, true, by decide, rfl⟩, ?_⟩
  rintro ⟨v0, v1, v2, h01, h12, h20⟩
  exact h20 (h12.symm.trans h01.symm)

/-- RT-06 (`FidelityClosure.lean:180-185`): any common network descent `(q1, q2)`
compatible with transport maps `e12 : X1 → X2` and `e21 : X2 → X1` is constant on
loop orbits `e21 (e12 x)`, so injective (`Function.Injective q1`) descent forces
trivial loop holonomy `e21 (e12 x) = x`. -/
theorem faithful_network_descent_forces_trivial_loops {X1 X2 Y : Type}
    (e12 : X1 → X2) (e21 : X2 → X1) (q1 : X1 → Y) (q2 : X2 → Y)
    (h12 : ∀ x, q2 (e12 x) = q1 x)
    (h21 : ∀ y, q1 (e21 y) = q2 y) :
    (∀ x, q1 (e21 (e12 x)) = q1 x) ∧
    (Function.Injective q1 → ∀ x, e21 (e12 x) = x) := by
  have hloop : ∀ x, q1 (e21 (e12 x)) = q1 x :=
    fun x => (h21 (e12 x)).trans (h12 x)
  exact ⟨hloop, fun hinj x => hinj (hloop x)⟩

/-! ## Section 5: Orbit-Decomposed Automorphism-Invariant L1 Cochain Weights (`DER-27` / `OWE-09`, `OQ-07` / `RT-11`) -/

/-- Involution swapping edges 1 and 2 on a 3-edge cochain while fixing edge 3. -/
def swapEdge12 : Cochain3 → Cochain3
  | (v1, v2, v3) => (v2, v1, v3)

/-- Third standard unit 3-edge cochain `(0, 0, 1)`. -/
def basis3 : Cochain3 := (0, 0, 1)

/-- Exact 2-orbit characterization under `swapEdge23`: invariance of `weightedL1 w`
    across all valid repairs (`v1 + v2 + v3 = 1`) holds if and only if `w` is
    constant on the 2-edge orbit `{2, 3}` (`w.2.1 = w.2.2`), leaving `w.1` unconstrained. -/
theorem swap23_invariant_iff_orbit_constant (w : Weight3) :
    (∀ v : Cochain3, validRepair v → weightedL1 w (swapEdge23 v) = weightedL1 w v) ↔
      w.2.1 = w.2.2 := by
  rcases w with ⟨w1, w2, w3⟩
  constructor
  · intro hinv
    have h2 : weightedL1 (w1, w2, w3) (swapEdge23 basis2) = weightedL1 (w1, w2, w3) basis2 :=
      hinv basis2 (by decide)
    simpa [weightedL1, swapEdge23, basis2] using h2.symm
  · intro heq ⟨v1, v2, v3⟩ _
    dsimp at heq
    subst heq
    dsimp [weightedL1, swapEdge23]
    rw [Nat.add_assoc, Nat.add_comm (w2 * v3.natAbs) (w2 * v2.natAbs), ← Nat.add_assoc]

/-- Under `swapEdge23` orbit constancy (`w.2.1 = w.2.2`), the weighted L1 cost decomposes
    into the two automorphism orbits `{1}` and `{2, 3}` with two independent orbit weights. -/
theorem swap23_invariant_cost_decomposition (w : Weight3) (v : Cochain3)
    (horb : w.2.1 = w.2.2) :
    weightedL1 w v = w.1 * v.1.natAbs + w.2.1 * (v.2.1.natAbs + v.2.2.natAbs) := by
  rcases w with ⟨w1, w2, w3⟩
  rcases v with ⟨v1, v2, v3⟩
  dsimp at horb
  subst horb
  dsimp [weightedL1]
  rw [Nat.mul_add, ← Nat.add_assoc]

/-- Exact 2-orbit characterization under `swapEdge12`: invariance of `weightedL1 w`
    across all valid repairs holds if and only if `w.1 = w.2.1`. -/
theorem swap12_invariant_iff_orbit_constant (w : Weight3) :
    (∀ v : Cochain3, validRepair v → weightedL1 w (swapEdge12 v) = weightedL1 w v) ↔
      w.1 = w.2.1 := by
  rcases w with ⟨w1, w2, w3⟩
  constructor
  · intro hinv
    have h1 : weightedL1 (w1, w2, w3) (swapEdge12 basis1) = weightedL1 (w1, w2, w3) basis1 :=
      hinv basis1 (by decide)
    simpa [weightedL1, swapEdge12, basis1] using h1.symm
  · intro heq ⟨v1, v2, v3⟩ _
    dsimp at heq
    subst heq
    dsimp [weightedL1, swapEdge12]
    rw [Nat.add_comm (w1 * v2.natAbs) (w1 * v1.natAbs)]

/-- Three-regime symmetry hierarchy on 3-edge cochains:
    (1) `swapEdge23` invariance forces `w2 = w3` (2 orbits `{1}`, `{2, 3}`);
    (2) `swapEdge12` invariance forces `w1 = w2` (2 orbits `{1, 2}`, `{3}`);
    (3) joint `swapEdge12` and `swapEdge23` invariance (generating `S_3`) forces `w1 = w2 = w3` (1 transitive orbit). -/
theorem three_edge_symmetry_weight_hierarchy (w : Weight3) :
    ((∀ v : Cochain3, validRepair v → weightedL1 w (swapEdge23 v) = weightedL1 w v) ↔
      w.2.1 = w.2.2) ∧
    ((∀ v : Cochain3, validRepair v → weightedL1 w (swapEdge12 v) = weightedL1 w v) ↔
      w.1 = w.2.1) ∧
    ((∀ v : Cochain3, validRepair v →
        weightedL1 w (swapEdge12 v) = weightedL1 w v ∧
        weightedL1 w (swapEdge23 v) = weightedL1 w v) ↔
      (w.1 = w.2.1 ∧ w.2.1 = w.2.2)) := by
  refine ⟨swap23_invariant_iff_orbit_constant w,
          swap12_invariant_iff_orbit_constant w, ?_⟩
  constructor
  · intro hboth
    exact ⟨(swap12_invariant_iff_orbit_constant w).mp (fun v hv => (hboth v hv).1),
           (swap23_invariant_iff_orbit_constant w).mp (fun v hv => (hboth v hv).2)⟩
  · rintro ⟨h12, h23⟩ v hv
    exact ⟨(swap12_invariant_iff_orbit_constant w).mpr h12 v hv,
           (swap23_invariant_iff_orbit_constant w).mpr h23 v hv⟩

/-- General `n`-edge weighted L1 norm summing `w k * |v k|` over edges `0 ≤ k < n`. -/
def weightedL1Gen (w : Nat → Nat) (v : Nat → Int) : Nat → Nat
  | 0 => 0
  | k + 1 => weightedL1Gen w v k + w k * (v k).natAbs

/-- General `n`-edge unweighted L1 norm summing `|v k|` over edges `0 ≤ k < n`. -/
def unweightedL1Gen (v : Nat → Int) : Nat → Nat
  | 0 => 0
  | k + 1 => unweightedL1Gen v k + (v k).natAbs

/-- Kronecker delta unit 1-cochain supported at edge `e`. -/
def unitCochain (e i : Nat) : Int :=
  if i = e then 1 else 0

/-- `k`-fold iteration of an edge endomorphism `σ : Nat → Nat`. -/
def iterEdge (σ : Nat → Nat) : Nat → Nat → Nat
  | 0, x => x
  | k + 1, x => σ (iterEdge σ k x)

/-- Below edge index `e` (`n ≤ e`), the prefix sum `weightedL1Gen w (unitCochain e) n` vanishes. -/
theorem weightedL1Gen_unitCochain_Zero_of_ge (w : Nat → Nat) (n e : Nat) (hle : n ≤ e) :
    weightedL1Gen w (unitCochain e) n = 0 := by
  induction n with
  | zero => rfl
  | succ k ih =>
    have hne : k ≠ e := Nat.ne_of_lt hle
    have hk0 : weightedL1Gen w (unitCochain e) k = 0 := ih (Nat.le_of_succ_le hle)
    dsimp [weightedL1Gen, unitCochain]
    rw [if_neg hne, hk0]
    change 0 + w k * 0 = 0
    rw [Nat.mul_zero, Nat.add_zero]

/-- Evaluating `weightedL1Gen w` on `unitCochain e` for `e < n` extracts the exact edge weight `w e`. -/
theorem weightedL1Gen_unitCochain (w : Nat → Nat) {n e : Nat} (he : e < n) :
    weightedL1Gen w (unitCochain e) n = w e := by
  induction n with
  | zero => exact absurd he (Nat.not_lt_zero e)
  | succ k ih =>
    by_cases hke : k = e
    · subst hke
      have h0 := weightedL1Gen_unitCochain_Zero_of_ge w k k (Nat.le_refl k)
      dsimp [weightedL1Gen, unitCochain]
      rw [if_pos rfl, h0]
      change 0 + w k * 1 = w k
      rw [Nat.mul_one, Nat.zero_add]
    · have hek : e < k := Nat.lt_of_le_of_ne (Nat.le_of_lt_succ he) (Ne.symm hke)
      have ihk := ih hek
      dsimp [weightedL1Gen, unitCochain]
      rw [if_neg hke, ihk]
      change w e + w k * 0 = w e
      rw [Nat.mul_zero, Nat.add_zero]

/-- If an edge map `σ` preserves `{0, ..., n - 1}` and leaves `weightedL1Gen w` invariant
    on unit cochains, then `w` is invariant under a single step of `σ` (`w (σ e) = w e`). -/
theorem symmetry_forces_step_equal_weights_general (w : Nat → Nat) (σ : Nat → Nat) (n : Nat)
    (hclosed : ∀ e < n, σ e < n)
    (hinv : ∀ e < n, weightedL1Gen w (unitCochain (σ e)) n = weightedL1Gen w (unitCochain e) n) :
    ∀ e < n, w (σ e) = w e := by
  intro e he
  have h1 := weightedL1Gen_unitCochain w (hclosed e he)
  have h2 := weightedL1Gen_unitCochain w he
  exact h1.symm.trans ((hinv e he).trans h2)

/-- Orbit-constancy theorem on `n` edges: if `σ` preserves `{0, ..., n - 1}` and leaves
    `weightedL1Gen w` invariant on unit cochains, then `w` is constant along every
    `σ`-orbit (`w (iterEdge σ k e) = w e` for all `k : Nat` and `e < n`). -/
theorem symmetry_forces_orbit_equal_weights_general (w : Nat → Nat) (σ : Nat → Nat) (n : Nat)
    (hclosed : ∀ e < n, σ e < n)
    (hinv : ∀ e < n, weightedL1Gen w (unitCochain (σ e)) n = weightedL1Gen w (unitCochain e) n) :
    ∀ k : Nat, ∀ e < n, iterEdge σ k e < n ∧ w (iterEdge σ k e) = w e := by
  have hstep := symmetry_forces_step_equal_weights_general w σ n hclosed hinv
  intro k
  induction k with
  | zero =>
    intro e he
    exact ⟨he, rfl⟩
  | succ m ih =>
    intro e he
    rcases ih e he with ⟨hm_lt, hm_eq⟩
    refine ⟨hclosed (iterEdge σ m e) hm_lt, ?_⟩
    calc
      w (σ (iterEdge σ m e)) = w (iterEdge σ m e) := hstep (iterEdge σ m e) hm_lt
      _ = w e := hm_eq

/-- Whenever `w` is uniform (`w e = w0` for all `e < n`), `weightedL1Gen w v n`
    factors as `w0 * unweightedL1Gen v n`. -/
theorem uniform_weights_factor_l1_general (w : Nat → Nat) (v : Nat → Int) (n w0 : Nat)
    (hunif : ∀ e < n, w e = w0) :
    weightedL1Gen w v n = w0 * unweightedL1Gen v n := by
  induction n with
  | zero =>
    change 0 = w0 * 0
    rw [Nat.mul_zero]
  | succ k ih =>
    have hk : w k = w0 := hunif k (Nat.lt_succ_self k)
    have ihk : weightedL1Gen w v k = w0 * unweightedL1Gen v k :=
      ih (fun e he => hunif e (Nat.lt_succ_of_lt he))
    dsimp [weightedL1Gen, unweightedL1Gen]
    rw [ihk, hk, Nat.mul_add]

/-- General transitive uniformity theorem: if `σ` acts transitively on `{0, ..., n - 1}`
    from `0` and leaves `weightedL1Gen w` invariant on unit cochains, then all `n` edge
    weights equal `w 0` and `weightedL1Gen w v n = w 0 * unweightedL1Gen v n` for every cochain `v`. -/
theorem transitive_action_forces_uniform_weights_general (w : Nat → Nat) (σ : Nat → Nat) (n : Nat)
    (hpos : 1 ≤ n)
    (hclosed : ∀ e < n, σ e < n)
    (hinv : ∀ e < n, weightedL1Gen w (unitCochain (σ e)) n = weightedL1Gen w (unitCochain e) n)
    (htrans : ∀ e < n, ∃ k : Nat, iterEdge σ k 0 = e) :
    (∀ e < n, w e = w 0) ∧
    (∀ v : Nat → Int, weightedL1Gen w v n = w 0 * unweightedL1Gen v n) := by
  have horb := symmetry_forces_orbit_equal_weights_general w σ n hclosed hinv
  have hunif : ∀ e < n, w e = w 0 := by
    intro e he
    rcases htrans e he with ⟨k, hk⟩
    have hk0 := (horb k 0 hpos).2
    rw [← hk]
    exact hk0
  exact ⟨hunif, fun v => uniform_weights_factor_l1_general w v n (w 0) hunif⟩

end OmegaCodex.LocalGlobalObstruction

