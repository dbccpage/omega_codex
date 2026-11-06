/-!
  # Boundary-Quotient Normal Form (BQNF) Formalization
  
  Formal specification and mechanized theorems for BQNF under Genesis principles:
  1. Witnessed difference and boundary distinction prior to arithmetic.
  2. Cochain complex exactness and coboundary cancellation (d_1 ∘ d_0 = 0).
  3. Transformation group laws for internal potential repairs.
  4. Non-exact loop circulation invariants and unrepairable remainders.
  5. Report insufficiency of scalar mean under set insertion.
  6. Computability of incremental average maintenance in the extended (SUM, COUNT) regime.
  7. BQNF return path decision routing.

  AuthorityEffect: None
  Gate: Lean 4 (leanprover/lean4:v4.35.0, per lean4/lean-toolchain). Elaboration not observed in this edit.
-/

namespace ResearchPrograms.NormalForms.BQNF

/-!
  ## Section 1: Witnessed Difference Prior to Metric or Arithmetic
  A witnessed distinction w : R(x, y) with an irreflexive relation R
  strictly separates endpoints x and y without assuming coordinates or distance.
-/

theorem distinct_of_witnessed_difference {α : Type} (R : α → α → Prop) (h_irref : ∀ z, ¬ R z z)
    {x y : α} (w : R x y) : x ≠ y := by
  intro h_eq
  subst h_eq
  exact h_irref x w

/-!
  ## Section 2: Simplicial Cochains and Endpoint Cancellation
  Defines 0-cochains (potentials), 1-cochains (edge defects), and 2-cochains (triangle defects).
  Proves that d_1 ∘ d_0 = 0 follows by exact cancellation of repeated endpoints.
-/

structure Edge (V : Type) where
  src : V
  tgt : V
  deriving DecidableEq

structure Triangle (V : Type) where
  v0 : V
  v1 : V
  v2 : V
  deriving DecidableEq

def d0 {V : Type} (f : V → Int) (e : Edge V) : Int :=
  f e.tgt - f e.src

def d1 {V : Type} (g : Edge V → Int) (t : Triangle V) : Int :=
  g ⟨t.v1, t.v2⟩ - g ⟨t.v0, t.v2⟩ + g ⟨t.v0, t.v1⟩

/-- THEOREM: The composition d_1 ∘ d_0 is identically zero by endpoint cancellation. -/
theorem d1_d0_cancellation {V : Type} (f : V → Int) (t : Triangle V) :
    d1 (d0 f) t = 0 := by
  unfold d1 d0
  dsimp
  omega

/-!
  ## Section 3: Affine Repair Transformations and Group Laws
  An admitted repair potential α ∈ C^0 shifts defect ω ∈ C^1 by E_α(ω) = ω - d_0 α.
  Repairs compose additively, preserve secondary closure d_1 ω, and zero exact defects.
-/

def repair_op {V : Type} (α : V → Int) (ω : Edge V → Int) (e : Edge V) : Int :=
  ω e - d0 α e

theorem repair_composition {V : Type} (α β : V → Int) (ω : Edge V → Int) (e : Edge V) :
    repair_op α (repair_op β ω) e = repair_op (fun v => α v + β v) ω e := by
  unfold repair_op d0
  dsimp
  omega

theorem repair_identity {V : Type} (ω : Edge V → Int) (e : Edge V) :
    repair_op (fun _ => 0) ω e = ω e := by
  unfold repair_op d0
  dsimp
  omega

theorem repair_preserves_d1 {V : Type} (α : V → Int) (ω : Edge V → Int) (t : Triangle V) :
    d1 (repair_op α ω) t = d1 ω t := by
  unfold d1 repair_op d0
  dsimp
  omega

theorem exact_repair_vanishes {V : Type} (α : V → Int) (e : Edge V) :
    repair_op α (d0 α) e = 0 := by
  unfold repair_op
  omega

/-!
  ## Section 4: Loop Circulation and Invariant Remainder
  On an oriented 3-cycle, the circulation functional L evaluates the sum of edge cochains.
  L annihilates any coboundary d_0 α, so L is an invariant under all potential repairs.
  A non-zero circulation charge cannot be eliminated by any potential repair.
-/

inductive Cycle3Vertex where
  | n0
  | n1
  | n2
  deriving DecidableEq

def e01 : Edge Cycle3Vertex := ⟨Cycle3Vertex.n0, Cycle3Vertex.n1⟩
def e12 : Edge Cycle3Vertex := ⟨Cycle3Vertex.n1, Cycle3Vertex.n2⟩
def e20 : Edge Cycle3Vertex := ⟨Cycle3Vertex.n2, Cycle3Vertex.n0⟩

def circulation (ω : Edge Cycle3Vertex → Int) : Int :=
  ω e01 + ω e12 + ω e20

theorem circulation_coboundary_zero (α : Cycle3Vertex → Int) :
    circulation (d0 α) = 0 := by
  unfold circulation d0 e01 e12 e20
  dsimp
  omega

theorem circulation_invariant_under_repairs (α : Cycle3Vertex → Int) (ω : Edge Cycle3Vertex → Int) :
    circulation (repair_op α ω) = circulation ω := by
  unfold circulation repair_op d0 e01 e12 e20
  dsimp
  omega

theorem non_exact_circulation_unrepairable (ω : Edge Cycle3Vertex → Int) (h_circ : circulation ω ≠ 0)
    (α : Cycle3Vertex → Int) : ¬ (∀ e, repair_op α ω e = 0) := by
  intro h_zero
  have h_circ_zero : circulation (repair_op α ω) = 0 := by
    unfold circulation
    rw [h_zero e01, h_zero e12, h_zero e20]
    rfl
  have h_eq := circulation_invariant_under_repairs α ω
  rw [h_circ_zero] at h_eq
  exact h_circ h_eq.symm

/-!
  ## Section 5: Report Insufficiency of Scalar Mean under Set Insertion
  History A: {1, 5}, sum = 6, count = 2, mean = 3.
  History B: {2, 3, 4}, sum = 9, count = 3, mean = 3.
  Both have scalar mean 3. Upon inserting 9, History A has new mean 5, while
  History B has new mean 18/4 = 9/2.
  THEOREM: No function taking only the old mean and the inserted value can
  correctly compute the new mean for both histories.
-/

structure MeanRatio where
  num : Int
  den : Nat
  den_pos : den > 0

def MeanRatio.eqv (a b : MeanRatio) : Prop :=
  a.num * (b.den : Int) = b.num * (a.den : Int)

theorem history_a_mean_initial :
    (6 : Int) * 1 = (3 : Int) * 2 := by rfl

theorem history_b_mean_initial :
    (9 : Int) * 1 = (3 : Int) * 3 := by rfl

-- Histories after inserting 9:
-- History A': sum 15, count 3, mean 15/3 = 5/1
-- History B': sum 18, count 4, mean 18/4 = 9/2

def mean_hist_a_updated : MeanRatio := ⟨15, 3, by decide⟩
def mean_hist_b_updated : MeanRatio := ⟨18, 4, by decide⟩

theorem updated_means_distinct : ¬ MeanRatio.eqv mean_hist_a_updated mean_hist_b_updated := by
  intro h_eq
  unfold MeanRatio.eqv mean_hist_a_updated mean_hist_b_updated at h_eq
  dsimp at h_eq
  omega

/-- THEOREM (Report Insufficiency):
    A deterministic update function receives the scalar mean 3 and the inserted element 9.
    Because it is a function of those two arguments alone, it can return at most one value.
    It cannot simultaneously agree with both distinct post-insertion outcomes. -/
theorem report_insufficiency_scalar_mean
    (update_mean : Int → Int → MeanRatio)
    (hA : MeanRatio.eqv (update_mean 3 9) mean_hist_a_updated)
    (hB : MeanRatio.eqv (update_mean 3 9) mean_hist_b_updated) :
    False := by
  have h_eqA : (update_mean 3 9).num * 3 = 15 * ((update_mean 3 9).den : Int) := by
    have h := hA
    unfold MeanRatio.eqv mean_hist_a_updated at h
    dsimp at h
    exact h
  have h_eqB : (update_mean 3 9).num * 4 = 18 * ((update_mean 3 9).den : Int) := by
    have h := hB
    unfold MeanRatio.eqv mean_hist_b_updated at h
    dsimp at h
    exact h
  have h_pos : ((update_mean 3 9).den : Int) > 0 := by
    have := (update_mean 3 9).den_pos
    omega
  omega

/-!
  ## Section 6: Computability under Structural Extension to (SUM, COUNT)
  Retaining the pair (SUM, COUNT) separates the fibers of histories A and B,
  enabling exact incremental update for all CDC operations.
-/

structure SumCountState where
  sum : Int
  count : Nat
  deriving DecidableEq

def state_hist_a : SumCountState := ⟨6, 2⟩
def state_hist_b : SumCountState := ⟨9, 3⟩

theorem extended_representation_separates_fibers :
    state_hist_a ≠ state_hist_b := by
  intro h
  injection h with h_sum _
  omega

def apply_insert (st : SumCountState) (v : Int) : SumCountState :=
  ⟨st.sum + v, st.count + 1⟩

inductive SumCountDelete where
  | deleted (state : SumCountState)
  | refusedEmpty
  deriving DecidableEq

def apply_delete (st : SumCountState) (v : Int) : SumCountDelete :=
  if st.count = 0 then
    SumCountDelete.refusedEmpty
  else
    SumCountDelete.deleted ⟨st.sum - v, st.count - 1⟩

def apply_update (st : SumCountState) (v_old v_new : Int) : SumCountState :=
  ⟨st.sum + (v_new - v_old), st.count⟩

theorem extended_insert_sound_hist_a :
    apply_insert state_hist_a 9 = ⟨15, 3⟩ := rfl

theorem extended_insert_sound_hist_b :
    apply_insert state_hist_b 9 = ⟨18, 4⟩ := rfl

theorem extended_update_sound :
    apply_update ⟨15, 3⟩ 1 4 = ⟨18, 3⟩ := rfl

theorem extended_delete_sound :
    apply_delete ⟨18, 3⟩ 9 = SumCountDelete.deleted ⟨9, 2⟩ := rfl

theorem empty_sum_count_delete_is_refused :
    apply_delete ⟨0, 0⟩ 1 = SumCountDelete.refusedEmpty := rfl

/-!
  ## Section 7: BQNF Return Path Decision Procedure
  Governs routing between exact coboundary repairs, certified remainder invariants,
  justified structural extensions, and uncertified residual retention.
-/

inductive BQNFReturnRoute where
  | Preserve : BQNFReturnRoute
  | RepairExact (alpha : Cycle3Vertex → Int) : BQNFReturnRoute
  | RetainRemainder (circ : Int) : BQNFReturnRoute
  | ExtendedRegime : BQNFReturnRoute
  | UnresolvedResidual : BQNFReturnRoute

def route_transition (has_defect : Bool) (circ : Int) (has_extension : Bool) : BQNFReturnRoute :=
  if !has_defect then
    BQNFReturnRoute.Preserve
  else if circ = 0 then
    -- Circulation zero does not certify that the zero potential repairs the cochain.
    BQNFReturnRoute.UnresolvedResidual
  else if has_extension then
    -- Non-zero obstruction triggers representation extension
    BQNFReturnRoute.ExtendedRegime
  else
    -- Without extension or repair, retain certified remainder
    BQNFReturnRoute.RetainRemainder circ

theorem zero_defect_preserves :
    route_transition false 0 false = BQNFReturnRoute.Preserve := rfl

theorem exact_zero_circulation_is_not_the_zero_potential :
    route_transition true 0 false = BQNFReturnRoute.UnresolvedResidual := rfl

def balanced_defect (e : Edge Cycle3Vertex) : Int :=
  if e = e01 then 1 else if e = e12 then -1 else 0

theorem balanced_edge_values :
    balanced_defect e01 = 1 ∧ balanced_defect e12 = -1 ∧ balanced_defect e20 = 0 := by
  unfold balanced_defect e01 e12 e20
  decide

theorem balanced_defect_has_zero_circulation :
    circulation balanced_defect = 0 := by
  unfold circulation
  rcases balanced_edge_values with ⟨h01, h12, h20⟩
  rw [h01, h12, h20]
  omega

theorem zero_potential_does_not_cancel_balanced_defect :
    repair_op (fun _ => 0) balanced_defect e01 = 1 := by
  rw [repair_identity]
  exact balanced_edge_values.1

theorem obstruction_routes_to_extension (circ : Int) (h : circ ≠ 0) :
    route_transition true circ true = BQNFReturnRoute.ExtendedRegime := by
  unfold route_transition
  simp [h]

theorem unextended_obstruction_retains_remainder (circ : Int) (h : circ ≠ 0) :
    route_transition true circ false = BQNFReturnRoute.RetainRemainder circ := by
  unfold route_transition
  simp [h]

#print axioms distinct_of_witnessed_difference
#print axioms d1_d0_cancellation
#print axioms non_exact_circulation_unrepairable
#print axioms report_insufficiency_scalar_mean
#print axioms extended_insert_sound_hist_a
#print axioms obstruction_routes_to_extension

end ResearchPrograms.NormalForms.BQNF
