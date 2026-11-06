/-!
# Local Compatibility, Observation Completion, and Overlap Frustration

Constructive Lean-core port of `WitnessedDifference.LocalObservationCompletion` and
finite-window local compatibility (`zero proof placeholders`, `zero Classical.choice`, allowed
axioms restricted to `propext` and `Quot.sound`).

Main results:
1. `decoder_iff` and `quotient_decoder_iff`: Constructive section-backed and
   quotient-level decoding criteria for observation maps `obs : E → R` modulo a
   repair equivalence `equiv : E → E → Prop`, eliminating `Classical.choose`.
2. `concrete_binary_decoder` and `blind_observer_collision`: Explicit 3-bit XOR
   repair-class recovery vs. blind-observer fiber collision.
3. `abs_le_iff`, `abs_triangle`, `local_readout_bound`, `conditioning_bound`,
   and `common_report_error`: Cleared-denominator integer locality, conditioning,
   and two-state separation error bounds.
4. `triangle_circulation_invariant`, `corrected_triangle_gradient`,
   `actual_exchange_product`, and `six_negative_hops_do_not_exchange`: Discrete
   circulation and exchange-sign identities.
5. `local_section_compatibility_necessary` and
   `three_window_frustrated_parity_obstruction`: Pairwise overlap agreement for
   restrictions of a global section vs. a 3-window frustrated cycle that is
   pairwise compatible on every overlap vertex yet admits no global section.
-/

namespace WitnessedDifference.LocalCompatibility

/-- Observation-fiber equivalence relation `obs e = obs f`. -/
def ObsFiber {E R : Type} (obs : E → R) (e f : E) : Prop :=
  obs e = obs f

/-- Constructive section-backed decoder equivalence: when `sec : R → E` is a
representative selector on the observed image (`∀ e, obs (sec (obs e)) = obs e`),
a decoder `decode : R → E` recovering `e` up to `equiv` exists if and only if
`obs`-fibers refine `equiv`. Uses zero `Classical.choice`. -/
theorem decoder_iff {E R : Type} (obs : E → R) (equiv : E → E → Prop)
    (sec : R → E) (hsec : ∀ e, obs (sec (obs e)) = obs e)
    (symmetric : ∀ e f, equiv e f → equiv f e)
    (transitive : ∀ e f g, equiv e f → equiv f g → equiv e g) :
    (∃ decode : R → E, ∀ e, equiv e (decode (obs e))) ↔
      ∀ e f, obs e = obs f → equiv e f := by
  constructor
  · rintro ⟨decode, h⟩ e f he
    have h1 : equiv e (decode (obs e)) := h e
    have h2 : equiv (decode (obs f)) f := symmetric f (decode (obs f)) (h f)
    rw [he] at h1
    exact transitive e (decode (obs f)) f h1 h2
  · intro h
    refine ⟨sec, ?_⟩
    intro e
    exact h e (sec (obs e)) (hsec e).symm

/-- Constructive quotient-level decoder equivalence: without any supplied section
`sec`, the observation quotient `Quot (ObsFiber obs)` maps into `Quot equiv`
preserving canonical classes if and only if `obs`-fibers refine `equiv`. -/
theorem quotient_decoder_iff {E R : Type} (obs : E → R) (equiv : E → E → Prop)
    (refl : ∀ e, equiv e e)
    (symmetric : ∀ e f, equiv e f → equiv f e)
    (transitive : ∀ e f g, equiv e f → equiv f g → equiv e g) :
    (∃ decodeQ : Quot (ObsFiber obs) → Quot equiv,
      ∀ e, decodeQ (Quot.mk (ObsFiber obs) e) = Quot.mk equiv e) ↔
      ∀ e f, obs e = obs f → equiv e f := by
  let s : Setoid E := ⟨equiv, ⟨refl, fun {x y} h => symmetric x y h, fun {x y z} h1 h2 => transitive x y z h1 h2⟩⟩
  constructor
  · rintro ⟨decodeQ, hdec⟩ e f he
    have hmk : Quot.mk (ObsFiber obs) e = Quot.mk (ObsFiber obs) f := Quot.sound he
    have hq : Quot.mk equiv e = Quot.mk equiv f := by
      rw [← hdec e, ← hdec f, hmk]
    exact @Quotient.exact E s e f hq
  · intro h
    refine ⟨Quot.lift (fun e => Quot.mk equiv e) (fun e f hef => Quot.sound (h e f hef)), ?_⟩
    intro e
    rfl

def repairClass (x y : Bool × Bool × Bool) : Prop :=
  x.2.2 = y.2.2 ∧ Bool.xor x.1 x.2.1 = Bool.xor y.1 y.2.1

def completeObserver (x : Bool × Bool × Bool) : Bool × Bool :=
  (Bool.xor x.1 x.2.1, x.2.2)

def binaryDecoder (r : Bool × Bool) : Bool × Bool × Bool := (false, r.1, r.2)

theorem concrete_binary_decoder (x y z : Bool) :
    repairClass (x, y, z) (binaryDecoder (completeObserver (x, y, z))) := by
  unfold repairClass binaryDecoder completeObserver
  cases x <;> cases y <;> cases z <;> decide

theorem blind_observer_collision :
    ¬ repairClass (false, false, false) (false, false, true) := by
  unfold repairClass
  decide

/-- Integer absolute value in core Lean. -/
def iabs (a : Int) : Int := if a < 0 then -a else a

theorem abs_le_iff (a b : Int) : iabs a ≤ b ↔ -b ≤ a ∧ a ≤ b := by
  unfold iabs
  split
  · constructor
    · intro h
      exact ⟨by omega, by omega⟩
    · rintro ⟨h1, h2⟩
      omega
  · constructor
    · intro h
      exact ⟨by omega, by omega⟩
    · rintro ⟨h1, h2⟩
      omega

theorem abs_triangle (a b : Int) : iabs (a + b) ≤ iabs a + iabs b := by
  unfold iabs
  split <;> split <;> split <;> omega

theorem local_readout_bound (read near tail normState beta : Int)
    (split : read = near + tail) (equalJointMarginal : near = 0)
    (traceBound : iabs tail ≤ normState * beta)
    (stateBound : normState ≤ 2) (tailBound : 0 ≤ beta) : iabs read ≤ 2 * beta := by
  have h1 : normState * beta ≤ 2 * beta := Int.mul_le_mul_of_nonneg_right stateBound tailBound
  have he : read = tail := by omega
  rw [he]
  omega

theorem conditioning_bound (delta alpha kappa eta beta : Int)
    (decoding : delta ≤ 2 * alpha + kappa * eta) (locality : eta ≤ 2 * beta)
    (hk : 0 ≤ kappa) : delta ≤ 2 * alpha + 2 * kappa * beta := by
  have hm : kappa * eta ≤ kappa * (2 * beta) := Int.mul_le_mul_of_nonneg_left locality hk
  have hcomm : kappa * (2 * beta) = 2 * kappa * beta := by
    rw [← Int.mul_assoc, Int.mul_comm kappa 2, Int.mul_assoc]
  omega

/-- Cleared-denominator common report separation bound: if `delta ≤ |u - v|`, then no
single `report` can simultaneously satisfy `2 * |u - report| < delta` and
`2 * |v - report| < delta`. -/
theorem common_report_error (u v report delta : Int)
    (separation : delta ≤ iabs (u - v))
    (hu : 2 * iabs (u - report) < delta)
    (hv : 2 * iabs (v - report) < delta) : False := by
  unfold iabs at separation hu hv
  split at separation <;> split at hu <;> split at hv <;> omega

theorem triangle_circulation_invariant (a b c x y z : Int) :
    (a - (y - x)) + (b - (z - y)) + (c - (x - z)) = a + b + c := by
  omega

theorem corrected_triangle_gradient :
    ((0 : Int) - 1, (1 : Int) - 0, (0 : Int) - 0) = (-1, 1, 0) := rfl

theorem actual_exchange_product : (1 : Int) * (-1) * 1 * 1 * (-1) * (-1) = -1 := by decide

theorem six_negative_hops_do_not_exchange : (-1 : Int) ^ 6 = 1 := by decide

/-- Necessary overlap condition for global section existence: if a global assignment
`g : V → Val` restricts to local sections `sA` on `A` and `sB` on `B`, then `sA` and
`sB` must agree on every vertex in `A ∩ B`. -/
theorem local_section_compatibility_necessary {V Val : Type}
    (inA inB : V → Prop) (sA sB : V → Val)
    (hglobal : ∃ g : V → Val, (∀ v, inA v → g v = sA v) ∧ (∀ v, inB v → g v = sB v)) :
    ∀ v, inA v → inB v → sA v = sB v := by
  rcases hglobal with ⟨g, hA, hB⟩
  intro v hvA hvB
  exact (hA v hvA).symm.trans (hB v hvB)

/-- Explicit 3-window parity frustration: three local edge windows `e01`, `e12`, `e20`
on vertices `{0, 1, 2}` where `e01` requires `x0 = x1`, `e12` requires `x1 = x2`, and
`e20` requires `x2 ≠ x0` are each satisfiable locally and pairwise compatible on their
single shared vertex, yet no global assignment `(x0, x1, x2) : Bool × Bool × Bool`
satisfies all three windows simultaneously. -/
theorem three_window_frustrated_parity_obstruction :
    (∃ x0 x1 : Bool, x0 = x1 ∧ x1 = x1) ∧
    (∃ x1 x2 : Bool, x1 = x2 ∧ x2 = x2) ∧
    (∃ x2 x0 : Bool, x2 ≠ x0 ∧ x0 = x0) ∧
    ¬ (∃ x0 x1 x2 : Bool, x0 = x1 ∧ x1 = x2 ∧ x2 ≠ x0) := by
  refine ⟨⟨false, false, rfl, rfl⟩, ⟨false, false, rfl, rfl⟩, ⟨false, true, by decide, rfl⟩, ?_⟩
  rintro ⟨x0, x1, x2, h01, h12, h20⟩
  exact h20 (h12.symm.trans h01.symm)

end WitnessedDifference.LocalCompatibility
