import TorsorAndOperations
import ZeroEquivalence

/-!
# Profile-Preorder Bridge, Quotient Retention, Reflection Lift, and Supplied-Rule Reflective Chain (Slice 6)

Formalizes five distinct conditional and relational components while keeping
all supplied carrier, constructor, transition, observation, and scheduling
assumptions explicit (`DER-21`, `DER-22`, `DER-23`, `DER-25`), and preserving the
unresolved operational acquisition, invocation, persistence, and endogenous
holonomy/carrier-choice obligations as `OWED` (`OWE-07`, `OWE-08`, `OWE-10`, `OWE-13`):

1. **Profile equivalence vs. mutual comparability preorder bridge** (`DER-21`,
   `docs/research_map.md` lines 350–354, `docs/zero_equivalence.md` lines 211–219):
   - *Supplied*: arbitrary carrier `α : Type u` and binary relation `E : α → α → Prop` (`S0`).
   - *Checked in Lean*: complete incoming/outgoing profile agreement `ProfileEquiv E` is
     an equivalence relation without assuming reflexivity, symmetry, or
     transitivity of `E`; when `E` is a preorder (`IsPreorder E`), `ProfileEquiv E`
     coincides iff-wise with mutual comparability `MutualComp E x y := E x y ∧ E y x`;
     when `E` is an equivalence relation, both coincide with `E` itself; on
     `boolLeq`, `¬ E` is asymmetric while `¬ MutualComp E` is symmetric; on `D2`,
     `ProfileEquiv` strictly generalizes `MutualComp`.
   - *Remains open (`OWE-10`)*: unconditional closure policies (`N23`) and
     continuum real completeness (`N26`).
2. **Quotient retention and internal symmetry multiplicity** (`DER-21`, `N25`,
   `QuotientRetention.lean`):
   - *Supplied*: carrier `α`, setoids `fine` and `coarse`, refinement proof `href`,
     and endomorphism `σ : α → α` (`S0`, `M2`).
   - *Checked in Lean*: failed coarse-to-fine identification and unabsorbed internal
     exchange symmetry retain distinct refined classes in the fiber of the
     canonical surjective factor map `collapseMap : Quotient fine → Quotient coarse`.
3. **Finite ten-stick reflection (`N19`) and four-step vs. two-step lift (`N20`)**
   (`DER-22`, `DER-25`, `OWE-08`):
   - *Supplied*: 10-slot carrier `Fin 10 → Bool` with reversal `reflectIndex10`
     and Hamming metric (`N19`), 1/2/3-slot carriers `Stick1`, `Stick2`, `Stick3`,
     and 4-state carrier `Fin 4` with cyclic step `step4` and parity projection `proj2`
     vs. product carrier `Bool × Bool` with `step4Triv` and `step4Sheet` (`N20`;
     admissions `S0`, `M2`, `M3`).
   - *Checked in Lean*: `reflect10` is involutive and separates raw Hamming disagreement
     (`2`) from reflection-quotient residual (`0` on mirror pair `stickLeft`/`stickRight`
     vs. `2` on non-mirror `stickLeft`/`stickMid`); `step4` intertwines visible
     `counterpart`, restores visible parity while flipping sheets at step 2, and
     closes at step 4, whereas `step4Triv` also intertwines `counterpart` with
     period 2 (`trivial_two_step_lift_also_intertwines`). In Section 3B (`DER-25`),
     any base-intertwining lift on `Bool × Bool` has period 4 everywhere iff it has
     no 2-step fixed points iff its 2-step fiber holonomy flips the hidden sheet
     everywhere (`period_four_iff_no_two_step_fixed_point`, `period_four_iff_sheet_flip_holonomy`),
     `(Fin 4, step4, proj2)` is equivariantly isomorphic to `(Bool × Bool, step4Sheet, Prod.fst)`
     (`fin4_sheet_equivariant_bijection`), and `n = 3` (`Stick3`) is the minimal
     carrier threshold at which 1-stick indicator configurations exhibit both mirror
     collapse (`reflResidual3 = 0` at `hamming3 = 2`) and positive reflection residual
     (`reflResidual3 = 2`), compared against `n = 1` (`n1_reflResidual_eq_hamming`) and
     `n = 2` (`n2_single_sticks_mirror_collapse_but_zero_residual`).
   - *Remains open (`OWE-08`)*: endogenous forcing of non-trivial 2-step sheet-flip
     holonomy over trivial holonomy on `Bool × Bool` and the unforced choice of
     `n = 10` (`Stick10`) over the minimal `n = 3` threshold (`OWE-08`).
4. **Supplied-rule refusal reification and reflective chain profile collisions**
   (`DER-23`, `OWE-07`, `OWE-13`, `N21`–`N22`, `RefusalFrontier.lean`,
   `Generator.lean`, `SeparationCapacity.lean`):
   - *Supplied*: two-constructor sum type `MItem` (`tok` vs `receipt`), state
     `MState`, duplicate-reifying transition `stepM`, empty seed `⟨[], []⟩`, and
     two-step schedule `[0, 0]`; subject-typed state `PState`, seed `⟨[0], [], []⟩`,
     transition `stepRefl` (which explicitly appends element `r = s.data.length`,
     tag `r`, and edge `(s.data.length - 1, r)` on invocation), iteration `reflState`,
     and observation maps `profile1`, `profile2`, `profileV`, `profileD` (`S0`, `M2`, `M3`).
   - *Checked in Lean*: within `stepM` traces from `⟨[], []⟩` measured by presentation-step
     count, `0` or `1` steps leave `rel = []` (`stepM_lower_bound_two_steps`) and
     `2` steps of token `0` inhabit `rel` (`min_witnessed_route_closes`), while
     fact-level off-diagonal pairs do not force the global `Irrefl` law
     (`bridge_facts_not_law`); iterating `stepRefl` produces initial-segment
     carriers `List.range (n + 1)` whose depth-1 profiles collide on all interior
     pairs `1 ≤ i < j < n` (`generation_never_dries`), and for every fixed radius
     `d` and `n ≥ 2 * d + 3`, all deep-interior points `d < i < n - d` share
     identical radius-`d` structural profiles (`depth_d_outrun`, `depth_d_obstruction`).
   - *Remains open (`OWE-07`, `OWE-13`)*: iterating the supplied rule `stepRefl`
     does not derive rule acquisition or invocation, and profile collisions under
     `profile1`/`profileD` are not performed internal witnessing (`OWE-07`);
     multi-round persistence of global laws and non-vacuous repair without an
     unbounded alphabet remain open (`OWE-13`).
-/
set_option autoImplicit false

namespace OmegaCodex.ProfilePreorderAndGenerator

open OmegaCodex.PrimitiveDifference
open OmegaCodex.MirrorNonIdentification
open OmegaCodex.ZeroEquivalence
open OmegaCodex.TorsorAndOperations

universe u v

/-! ## Section 1: Complete Profile Equivalence vs. Mutual Comparability Preorder Bridge -/

/-- Complete incoming and outgoing profile equality for an arbitrary binary relation `E`. -/
def ProfileEquiv {α : Type u} (E : α → α → Prop) (x y : α) : Prop :=
  (∀ z, E x z ↔ E y z) ∧ (∀ z, E z x ↔ E z y)

theorem profileEquiv_refl {α : Type u} (E : α → α → Prop) (x : α) :
    ProfileEquiv E x x :=
  ⟨fun _ => Iff.rfl, fun _ => Iff.rfl⟩

theorem profileEquiv_symm {α : Type u} (E : α → α → Prop) {x y : α}
    (h : ProfileEquiv E x y) : ProfileEquiv E y x :=
  ⟨fun z => (h.1 z).symm, fun z => (h.2 z).symm⟩

theorem profileEquiv_trans {α : Type u} (E : α → α → Prop) {x y w : α}
    (hxy : ProfileEquiv E x y) (hyw : ProfileEquiv E y w) :
    ProfileEquiv E x w :=
  ⟨fun z => (hxy.1 z).trans (hyw.1 z), fun z => (hxy.2 z).trans (hyw.2 z)⟩

/-- Profile equality is an equivalence relation for any binary relation `E`,
    with no reflexivity, symmetry, or transitivity assumptions on `E`. -/
theorem profileEquiv_equivalence {α : Type u} (E : α → α → Prop) :
    Equivalence (ProfileEquiv E) where
  refl := profileEquiv_refl E
  symm := profileEquiv_symm E
  trans := profileEquiv_trans E

/-- Reflexive and transitive binary relation (preorder). -/
structure IsPreorder {α : Type u} (E : α → α → Prop) : Prop where
  refl : ∀ x, E x x
  trans : ∀ x y z, E x y → E y z → E x z

/-- Mutual comparability (the symmetric core of a relation). -/
def MutualComp {α : Type u} (E : α → α → Prop) (x y : α) : Prop :=
  E x y ∧ E y x

theorem mutualComp_refl_of_preorder {α : Type u} {E : α → α → Prop}
    (hpre : IsPreorder E) (x : α) : MutualComp E x x :=
  ⟨hpre.refl x, hpre.refl x⟩

theorem mutualComp_symm {α : Type u} {E : α → α → Prop} {x y : α}
    (h : MutualComp E x y) : MutualComp E y x :=
  ⟨h.2, h.1⟩

theorem mutualComp_trans_of_preorder {α : Type u} {E : α → α → Prop}
    (hpre : IsPreorder E) {x y z : α}
    (hxy : MutualComp E x y) (hyz : MutualComp E y z) :
    MutualComp E x z :=
  ⟨hpre.trans x y z hxy.1 hyz.1, hpre.trans z y x hyz.2 hxy.2⟩

theorem mutualComp_equivalence_of_preorder {α : Type u} {E : α → α → Prop}
    (hpre : IsPreorder E) : Equivalence (MutualComp E) where
  refl := mutualComp_refl_of_preorder hpre
  symm := mutualComp_symm
  trans := mutualComp_trans_of_preorder hpre

/-- For any preorder `E`, complete incoming/outgoing profile equality collapses
    to mutual comparability `E x y ∧ E y x`. -/
theorem profileEquiv_iff_mutualComp_of_preorder {α : Type u} {E : α → α → Prop}
    (hpre : IsPreorder E) (x y : α) :
    ProfileEquiv E x y ↔ MutualComp E x y := by
  constructor
  · rintro ⟨hout, hin⟩
    exact ⟨(hin x).mp (hpre.refl x), (hout x).mp (hpre.refl x)⟩
  · rintro ⟨hxy, hyx⟩
    refine ⟨fun z => ⟨fun hxz => hpre.trans y x z hyx hxz,
                      fun hyz => hpre.trans x y z hxy hyz⟩,
            fun z => ⟨fun hzx => hpre.trans z x y hzx hxy,
                      fun hzy => hpre.trans z y x hzy hyx⟩⟩

theorem mutualComp_iff_rel_of_symmetric {α : Type u} {E : α → α → Prop}
    (hsym : ∀ x y, E x y → E y x) (x y : α) :
    MutualComp E x y ↔ E x y :=
  ⟨fun h => h.1, fun h => ⟨h, hsym x y h⟩⟩

/-- For any equivalence relation `E`, complete profile equality collapses
    to `E` itself. -/
theorem profileEquiv_iff_rel_of_equivalence {α : Type u} {E : α → α → Prop}
    (heqv : Equivalence E) (x y : α) :
    ProfileEquiv E x y ↔ E x y := by
  have hpre : IsPreorder E := ⟨heqv.refl, fun _ _ _ h1 h2 => heqv.trans h1 h2⟩
  exact (profileEquiv_iff_mutualComp_of_preorder hpre x y).trans
    (mutualComp_iff_rel_of_symmetric (fun _ _ h => heqv.symm h) x y)

/-- Standard directed preorder on `Bool` (`false ≤ true`). -/
def boolLeq (x y : Bool) : Prop :=
  x = false ∨ y = true

theorem boolLeq_preorder : IsPreorder boolLeq where
  refl x := by cases x <;> simp [boolLeq]
  trans x y z hxy hyz := by
    cases x <;> cases y <;> cases z <;> simp [boolLeq] at hxy hyz ⊢

/-- On a non-symmetric preorder (`boolLeq`), directed non-relation `¬ E x y` is
    asymmetric, whereas mutual-comparability class inequality `¬ MutualComp E x y`
    is symmetric on both off-diagonal directions. -/
theorem directed_not_rel_ne_class_ineq_on_preorder :
    boolLeq false true ∧ ¬ boolLeq true false ∧
      ¬ MutualComp boolLeq false true ∧ ¬ MutualComp boolLeq true false := by
  refine ⟨Or.inl rfl, ?_, ?_, ?_⟩
  · rintro (h | h) <;> cases h
  · rintro ⟨_, htf⟩
    rcases htf with h | h <;> cases h
  · rintro ⟨htf, _⟩
    rcases htf with h | h <;> cases h

/-- Without reflexivity, `ProfileEquiv` is always reflexive and separates distinct
    endpoints of `D2`, whereas `MutualComp` is empty on `D2`. -/
theorem profileEquiv_strictly_generalizes_mutualComp_without_refl :
    (∀ x y : Bool, ¬ MutualComp (fun a b => D2 a b = true) x y) ∧
      (∀ x : Bool, ProfileEquiv (fun a b => D2 a b = true) x x) ∧
      ¬ ProfileEquiv (fun a b => D2 a b = true) false true := by
  refine ⟨?_, profileEquiv_refl _, ?_⟩
  · intro x y ⟨hxy, hyx⟩
    cases x <;> cases y <;> cases hxy <;> cases hyx
  · rintro ⟨hout, _⟩
    have hft : D2 false true = true := rfl
    have htt : D2 true true = true := (hout true).mp hft
    cases htt

/-! ## Section 2: Quotient Retention and Internal Symmetry Multiplicity (`N25`) -/

/-- `fine` refines `coarse` when every fine-identification holds in `coarse`. -/
def RelationRefinement {α : Type u} (fine coarse : Setoid α) : Prop :=
  ∀ x y, fine.r x y → coarse.r x y

/-- Canonical factor map from a finer quotient to a coarser quotient. -/
def collapseMap {α : Type u} (fine coarse : Setoid α)
    (href : RelationRefinement fine coarse) :
    Quotient fine → Quotient coarse :=
  Quotient.lift (fun x => Quotient.mk coarse x)
    (fun x y hxy => Quotient.sound (href x y hxy))

theorem collapseMap_mk {α : Type u} (fine coarse : Setoid α)
    (href : RelationRefinement fine coarse) (x : α) :
    collapseMap fine coarse href (Quotient.mk fine x) = Quotient.mk coarse x :=
  rfl

theorem collapseMap_surjective {α : Type u} (fine coarse : Setoid α)
    (href : RelationRefinement fine coarse) :
    ∀ q : Quotient coarse, ∃ p : Quotient fine, collapseMap fine coarse href p = q := by
  intro q
  refine Quotient.inductionOn q ?_
  intro x
  exact ⟨Quotient.mk fine x, rfl⟩

/-- When a coarse identification `coarse.r x y` fails to hold in `fine`, the
    fiber over the single coarse class retains two distinct refined classes. -/
theorem failed_identification_retains_two_classes {α : Type u}
    (fine coarse : Setoid α) (href : RelationRefinement fine coarse)
    {x y : α} (hcoarse : coarse.r x y) (hnotfine : ¬ fine.r x y) :
    Quotient.mk fine x ≠ Quotient.mk fine y ∧
      collapseMap fine coarse href (Quotient.mk fine x) =
        collapseMap fine coarse href (Quotient.mk fine y) := by
  refine ⟨?_, ?_⟩
  · intro heq
    exact hnotfine (Quotient.exact heq)
  · exact Quotient.sound hcoarse

/-- Full collapse to the coarse quotient occurs if and only if the coarse
    identification implies the fine identification everywhere. -/
theorem collapseMap_injective_iff_reverse_refinement {α : Type u}
    (fine coarse : Setoid α) (href : RelationRefinement fine coarse) :
    (∀ p q : Quotient fine,
      collapseMap fine coarse href p = collapseMap fine coarse href q → p = q) ↔
    RelationRefinement coarse fine := by
  constructor
  · intro hinj x y hcoarse
    have hcoll :
        collapseMap fine coarse href (Quotient.mk fine x) =
          collapseMap fine coarse href (Quotient.mk fine y) :=
      Quotient.sound hcoarse
    exact Quotient.exact (hinj _ _ hcoll)
  · intro hrev p q
    refine Quotient.inductionOn₂ p q ?_
    intro x y hcoll
    have hcoarse : coarse.r x y := Quotient.exact hcoll
    exact Quotient.sound (hrev x y hcoarse)

/-- If an internal operation `σ` is absorbed by `coarse` (`coarse.r x (σ x)`)
    but not by `fine` (`¬ fine.r x (σ x)`), distinct classes survive in the
    refined quotient over the same coarse class. -/
theorem symmetry_failure_retains_multiplicity {α : Type u}
    (fine coarse : Setoid α) (href : RelationRefinement fine coarse)
    (σ : α → α) (hcoarse : ∀ x, coarse.r x (σ x))
    {x : α} (hbreak : ¬ fine.r x (σ x)) :
    Quotient.mk fine x ≠ Quotient.mk fine (σ x) ∧
      collapseMap fine coarse href (Quotient.mk fine x) =
        collapseMap fine coarse href (Quotient.mk fine (σ x)) :=
  failed_identification_retains_two_classes fine coarse href (hcoarse x) hbreak

/-- `N25` boundary: absence of difference at a coarse stage (`ZeroRel coarse x y`)
    does not force equivalence at a refined stage (`Nonzero fine x y`), while
    `Nonzero fine` remains irreflexive on every element (`¬ Nonzero fine x x`). -/
theorem coarse_zero_coexists_with_fine_nonzero {α : Type u} {β : Type v}
    (fine coarse : Kernel α β) {x y : α}
    (hcoarse : ZeroRel coarse x y) (hfine : Nonzero fine x y) :
    ZeroRel coarse x y ∧ Nonzero fine x y ∧ x ≠ y ∧ ¬ Nonzero fine x x :=
  ⟨hcoarse, hfine, nonzero_implies_ne fine hfine, nonzero_irrefl fine x⟩

/-! ## Section 3: Ten-Stick Reflection (`N19`) and Four-Step Reflective Lift (`N20`) -/

/-- A 10-slot binary stick configuration. -/
abbrev Stick10 := Fin 10 → Bool

/-- Reversed index `9 - i` on `Fin 10`. -/
def reflectIndex10 (i : Fin 10) : Fin 10 :=
  ⟨9 - i.val, by omega⟩

/-- Spatial reversal of a 10-stick configuration. -/
def reflect10 (s : Stick10) (i : Fin 10) : Bool :=
  s (reflectIndex10 i)

theorem reflectIndex10_involutive (i : Fin 10) :
    reflectIndex10 (reflectIndex10 i) = i := by
  ext
  simp [reflectIndex10]
  omega

theorem reflect10_involutive (s : Stick10) (i : Fin 10) :
    reflect10 (reflect10 s) i = s i := by
  change s (reflectIndex10 (reflectIndex10 i)) = s i
  rw [reflectIndex10_involutive]

/-- Explicit enumeration of the 10 slots for computable Hamming comparison. -/
def indices10 : List (Fin 10) :=
  [⟨0, by decide⟩, ⟨1, by decide⟩, ⟨2, by decide⟩, ⟨3, by decide⟩, ⟨4, by decide⟩,
   ⟨5, by decide⟩, ⟨6, by decide⟩, ⟨7, by decide⟩, ⟨8, by decide⟩, ⟨9, by decide⟩]

/-- Raw slot-by-slot Hamming disagreement on 10-stick configurations. -/
def hamming10 (s1 s2 : Stick10) : Nat :=
  (indices10.filter (fun i => s1 i != s2 i)).length

/-- Reflection-quotient residual: minimum disagreement before or after spatial reversal. -/
def reflResidual10 (s1 s2 : Stick10) : Nat :=
  Nat.min (hamming10 s1 s2) (hamming10 s1 (reflect10 s2))

def stickLeft : Stick10 := fun i => decide (i.val = 0)
def stickRight : Stick10 := fun i => decide (i.val = 9)
def stickMid : Stick10 := fun i => decide (i.val = 1)

theorem stickLeft_reflect_eq_stickRight :
    ∀ i : Fin 10, reflect10 stickLeft i = stickRight i := by
  decide

/-- Mirror-image 10-stick configurations have positive raw disagreement (`2`)
    but zero reflection-quotient residual (`0`). -/
theorem stickLeft_stickRight_raw_vs_reflResidual :
    hamming10 stickLeft stickRight = 2 ∧
      reflResidual10 stickLeft stickRight = 0 := by
  decide

/-- Non-mirror 10-stick configurations retain positive residual (`2`) even
    modulo spatial reflection. -/
theorem stickLeft_stickMid_reflResidual_pos :
    hamming10 stickLeft stickMid = 2 ∧
      reflResidual10 stickLeft stickMid = 2 := by
  decide

/-- Cyclic 4-step transition on `Fin 4`. -/
def step4 (x : Fin 4) : Fin 4 :=
  ⟨(x.val + 1) % 4, Nat.mod_lt _ (by decide)⟩

/-- Two-to-one parity readout `Fin 4 → Bool`. -/
def proj2 (x : Fin 4) : Bool :=
  decide (x.val % 2 = 1)

/-- Every single step of `step4` projects under `proj2` to the visible order-2
    operation `counterpart` on `Bool`. -/
theorem proj2_intertwines_counterpart :
    ∀ x : Fin 4, proj2 (step4 x) = counterpart (proj2 x) := by
  decide

/-- Two steps of `step4` restore the visible readout `proj2` (`proj2 (step4 (step4 x)) = proj2 x`)
    while moving the lifted state to the opposite sheet (`step4 (step4 x) ≠ x`). -/
theorem step4_two_projects_to_id_but_flips_sheet :
    ∀ x : Fin 4, proj2 (step4 (step4 x)) = proj2 x ∧ step4 (step4 x) ≠ x := by
  decide

/-- Four steps of `step4` restore the full lifted state on `Fin 4`. -/
theorem step4_period_four :
    ∀ x : Fin 4, step4 (step4 (step4 (step4 x))) = x := by
  decide

/-- Trivial uncoupled lift on `Bool × Bool` that flips the visible bit without
    advancing the hidden sheet. -/
def step4Triv (s : Bool × Bool) : Bool × Bool :=
  (counterpart s.1, s.2)

/-- The trivial lift also intertwines `counterpart` on the visible readout yet
    closes in 2 steps (`N20` boundary: `S2Bool` permits a 4-step lift when paired
    with sheet coupling, but does not force period 4 without that coupling). -/
theorem trivial_two_step_lift_also_intertwines (s : Bool × Bool) :
    (step4Triv s).1 = counterpart s.1 ∧
      step4Triv (step4Triv s) = s := by
  rcases s with ⟨b, sheet⟩
  cases b <;> cases sheet <;> exact ⟨rfl, rfl⟩

/-! ## Section 3B: Two-Sheet Holonomy Characterization (`N20`) and Minimal `n = 3` Reflection-Residual Carrier Threshold (`N19`, `DER-25`) -/

/-- A transition `step : Bool × Bool → Bool × Bool` on the two-sheeted cover
    `Bool × Bool → Bool` intertwines `counterpart` on the visible base coordinate. -/
def IntertwinesCounterpart (step : Bool × Bool → Bool × Bool) : Prop :=
  ∀ s : Bool × Bool, (step s).1 = counterpart s.1

/-- For any base-intertwining lift on `Bool × Bool`, two steps restore the
    visible base coordinate `(step (step s)).1 = s.1`. -/
theorem two_step_base_returns_of_intertwines {step : Bool × Bool → Bool × Bool}
    (hint : IntertwinesCounterpart step) (s : Bool × Bool) :
    (step (step s)).1 = s.1 := by
  rw [hint (step s), hint s, counterpart_involution]

/-- No base-intertwining lift on `Bool × Bool` can have a 1-step or 3-step fixed point. -/
theorem odd_steps_not_fixed_of_intertwines {step : Bool × Bool → Bool × Bool}
    (hint : IntertwinesCounterpart step) (s : Bool × Bool) :
    step s ≠ s ∧ step (step (step s)) ≠ s := by
  refine ⟨?_, ?_⟩
  · intro heq
    have h1 : (step s).1 = s.1 := congrArg Prod.fst heq
    rw [hint s] at h1
    exact counterpart_ne s.1 h1
  · intro heq
    have h1 : (step (step (step s))).1 = s.1 := congrArg Prod.fst heq
    rw [hint (step (step s)), two_step_base_returns_of_intertwines hint s] at h1
    exact counterpart_ne s.1 h1

/-- Two-step fiber holonomy dichotomy: at every state `s : Bool × Bool`, after
    two steps of a base-intertwining lift, the state either returns to `s`
    (trivial fiber holonomy) or flips the hidden sheet to `(s.1, counterpart s.2)`. -/
theorem two_step_fiber_holonomy_dichotomy {step : Bool × Bool → Bool × Bool}
    (hint : IntertwinesCounterpart step) (s : Bool × Bool) :
    step (step s) = s ∨ step (step s) = (s.1, counterpart s.2) := by
  have hbase : (step (step s)).1 = s.1 := two_step_base_returns_of_intertwines hint s
  rcases s with ⟨b0, sh0⟩
  rcases hss : step (step (b0, sh0)) with ⟨b, sh⟩
  rw [hss] at hbase
  change b = b0 at hbase
  subst hbase
  cases sh <;> cases sh0
  · exact Or.inl rfl
  · exact Or.inr rfl
  · exact Or.inr rfl
  · exact Or.inl rfl

/-- A base-intertwining lift on `Bool × Bool` has period 2 if and only if its
    2-step fiber holonomy on the second coordinate is trivial everywhere. -/
theorem period_two_iff_trivial_sheet_holonomy {step : Bool × Bool → Bool × Bool}
    (hint : IntertwinesCounterpart step) :
    (∀ s, step (step s) = s) ↔ (∀ s, (step (step s)).2 = s.2) := by
  constructor
  · intro h s
    exact congrArg Prod.snd (h s)
  · intro h s
    have h1 : (step (step s)).1 = s.1 := two_step_base_returns_of_intertwines hint s
    have h2 : (step (step s)).2 = s.2 := h s
    rcases s with ⟨b0, sh0⟩
    rcases hss : step (step (b0, sh0)) with ⟨b, sh⟩
    rw [hss] at h1 h2
    cases h1
    cases h2
    rfl

/-- A base-intertwining lift on `Bool × Bool` has no 2-step fixed points if and
    only if its 2-step map flips the hidden sheet everywhere. -/
theorem no_two_step_fixed_iff_sheet_flip_holonomy {step : Bool × Bool → Bool × Bool}
    (hint : IntertwinesCounterpart step) :
    (∀ s, step (step s) ≠ s) ↔ (∀ s, step (step s) = (s.1, counterpart s.2)) := by
  constructor
  · intro hne s
    rcases two_step_fiber_holonomy_dichotomy hint s with heq | hflip
    · exact False.elim (hne s heq)
    · exact hflip
  · intro hflip s heq
    have h2 : (step (step s)).2 = s.2 := congrArg Prod.snd heq
    have hf2 : (step (step s)).2 = counterpart s.2 := congrArg Prod.snd (hflip s)
    rw [h2] at hf2
    exact counterpart_ne s.2 hf2.symm

/-- Exact period-4 characterization on `Bool × Bool` (fixed-point form): any
    base-intertwining lift has exact period 4 everywhere if and only if it has
    no 2-step fixed points. -/
theorem period_four_iff_no_two_step_fixed_point {step : Bool × Bool → Bool × Bool}
    (hint : IntertwinesCounterpart step) :
    (∀ s, step (step s) ≠ s ∧ step (step (step (step s))) = s) ↔
      (∀ s, step (step s) ≠ s) := by
  constructor
  · intro h s
    exact (h s).1
  · intro hne s
    have hflip : ∀ t, step (step t) = (t.1, counterpart t.2) :=
      (no_two_step_fixed_iff_sheet_flip_holonomy hint).mp hne
    refine ⟨hne s, ?_⟩
    rw [hflip (step (step s)), hflip s]
    rcases s with ⟨b, sh⟩
    change (b, counterpart (counterpart sh)) = (b, sh)
    rw [counterpart_involution]

/-- Exact period-4 characterization on `Bool × Bool` (sheet-holonomy form): any
    base-intertwining lift has exact period 4 everywhere if and only if its
    2-step fiber holonomy flips the hidden sheet (`counterpart s.2`) everywhere. -/
theorem period_four_iff_sheet_flip_holonomy {step : Bool × Bool → Bool × Bool}
    (hint : IntertwinesCounterpart step) :
    (∀ s, step (step s) ≠ s ∧ step (step (step (step s))) = s) ↔
      (∀ s, (step (step s)).2 = counterpart s.2) := by
  refine (period_four_iff_no_two_step_fixed_point hint).trans ?_
  refine (no_two_step_fixed_iff_sheet_flip_holonomy hint).trans ?_
  constructor
  · intro hflip s
    exact congrArg Prod.snd (hflip s)
  · intro h2 s
    have h1 : (step (step s)).1 = s.1 := two_step_base_returns_of_intertwines hint s
    have hs2 : (step (step s)).2 = counterpart s.2 := h2 s
    rcases s with ⟨b0, sh0⟩
    rcases hss : step (step (b0, sh0)) with ⟨b, sh⟩
    rw [hss] at h1 hs2
    cases h1
    cases hs2
    rfl

/-- Canonical sheet-coupled lift on `Bool × Bool`: flips the visible coordinate
    every step and flips the hidden sheet when leaving `true`. -/
def step4Sheet (s : Bool × Bool) : Bool × Bool :=
  (counterpart s.1, if s.1 then counterpart s.2 else s.2)

/-- Binary parity-and-sheet encoding `Fin 4 → Bool × Bool`. -/
def fin4ToSheet (x : Fin 4) : Bool × Bool :=
  (decide (x.val % 2 = 1), decide (2 ≤ x.val))

/-- Inverse decoding `Bool × Bool → Fin 4`. -/
def sheetToFin4 : Bool × Bool → Fin 4
  | (false, false) => ⟨0, by decide⟩
  | (true,  false) => ⟨1, by decide⟩
  | (false, true)  => ⟨2, by decide⟩
  | (true,  true)  => ⟨3, by decide⟩

/-- `step4Sheet` intertwines `counterpart`, exhibits 2-step sheet-flip holonomy,
    and therefore has exact period 4 everywhere on `Bool × Bool`. -/
theorem step4Sheet_has_sheet_flip_holonomy_and_period_four :
    IntertwinesCounterpart step4Sheet ∧
    (∀ s, (step4Sheet (step4Sheet s)).2 = counterpart s.2) ∧
    (∀ s, step4Sheet (step4Sheet s) ≠ s ∧
      step4Sheet (step4Sheet (step4Sheet (step4Sheet s))) = s) := by
  have hint : IntertwinesCounterpart step4Sheet := fun _ => rfl
  have hflip : ∀ s, (step4Sheet (step4Sheet s)).2 = counterpart s.2 := by
    intro ⟨b, sh⟩
    cases b <;> cases sh <;> rfl
  exact ⟨hint, hflip, (period_four_iff_sheet_flip_holonomy hint).mpr hflip⟩

/-- `(Fin 4, step4, proj2)` is equivariantly isomorphic to `(Bool × Bool, step4Sheet, Prod.fst)`. -/
theorem fin4_sheet_equivariant_bijection :
    (∀ x : Fin 4, sheetToFin4 (fin4ToSheet x) = x) ∧
    (∀ s : Bool × Bool, fin4ToSheet (sheetToFin4 s) = s) ∧
    (∀ x : Fin 4, (fin4ToSheet x).1 = proj2 x) ∧
    (∀ x : Fin 4, fin4ToSheet (step4 x) = step4Sheet (fin4ToSheet x)) := by
  refine ⟨by decide, ?_, by decide, by decide⟩
  intro ⟨b, sh⟩
  cases b <;> cases sh <;> rfl

/-- 1-slot, 2-slot, and 3-slot binary stick configurations for minimal carrier threshold analysis (`N19`). -/
abbrev Stick1 := Fin 1 → Bool
abbrev Stick2 := Fin 2 → Bool
abbrev Stick3 := Fin 3 → Bool

def reflectIndex1 (i : Fin 1) : Fin 1 :=
  ⟨0 - i.val, by omega⟩

def reflect1 (s : Stick1) (i : Fin 1) : Bool :=
  s (reflectIndex1 i)

def indices1 : List (Fin 1) :=
  [⟨0, by decide⟩]

def hamming1 (s1 s2 : Stick1) : Nat :=
  (indices1.filter (fun i => s1 i != s2 i)).length

def reflResidual1 (s1 s2 : Stick1) : Nat :=
  Nat.min (hamming1 s1 s2) (hamming1 s1 (reflect1 s2))

def reflectIndex2 (i : Fin 2) : Fin 2 :=
  ⟨1 - i.val, by omega⟩

def reflect2 (s : Stick2) (i : Fin 2) : Bool :=
  s (reflectIndex2 i)

def indices2 : List (Fin 2) :=
  [⟨0, by decide⟩, ⟨1, by decide⟩]

def hamming2 (s1 s2 : Stick2) : Nat :=
  (indices2.filter (fun i => s1 i != s2 i)).length

def reflResidual2 (s1 s2 : Stick2) : Nat :=
  Nat.min (hamming2 s1 s2) (hamming2 s1 (reflect2 s2))

def singleStick2 (k : Fin 2) : Stick2 :=
  fun i => decide (i.val = k.val)

def reflectIndex3 (i : Fin 3) : Fin 3 :=
  ⟨2 - i.val, by omega⟩

def reflect3 (s : Stick3) (i : Fin 3) : Bool :=
  s (reflectIndex3 i)

def indices3 : List (Fin 3) :=
  [⟨0, by decide⟩, ⟨1, by decide⟩, ⟨2, by decide⟩]

def hamming3 (s1 s2 : Stick3) : Nat :=
  (indices3.filter (fun i => s1 i != s2 i)).length

def reflResidual3 (s1 s2 : Stick3) : Nat :=
  Nat.min (hamming3 s1 s2) (hamming3 s1 (reflect3 s2))

def singleStick3 (k : Fin 3) : Stick3 :=
  fun i => decide (i.val = k.val)

def stick3Left : Stick3 := singleStick3 ⟨0, by decide⟩
def stick3Mid : Stick3 := singleStick3 ⟨1, by decide⟩
def stick3Right : Stick3 := singleStick3 ⟨2, by decide⟩

/-- At `n = 1`, spatial reflection is the identity, so reflection residual
    equals raw Hamming distance everywhere (no mirror collapse occurs). -/
theorem n1_reflResidual_eq_hamming (s1 s2 : Stick1) :
    reflResidual1 s1 s2 = hamming1 s1 s2 := by
  change Nat.min (hamming1 s1 s2) (hamming1 s1 s2) = hamming1 s1 s2
  exact Nat.min_self (hamming1 s1 s2)

/-- At `n = 2`, distinct 1-stick configurations collapse under reflection
    (`hamming2 = 2` and `reflResidual2 = 0`), and every pair of 1-stick
    configurations has zero reflection residual (no positive 1-stick residual exists). -/
theorem n2_single_sticks_mirror_collapse_but_zero_residual :
    hamming2 (singleStick2 ⟨0, by decide⟩) (singleStick2 ⟨1, by decide⟩) = 2 ∧
    reflResidual2 (singleStick2 ⟨0, by decide⟩) (singleStick2 ⟨1, by decide⟩) = 0 ∧
    (∀ j k : Fin 2, reflResidual2 (singleStick2 j) (singleStick2 k) = 0) := by
  decide

/-- At `n = 3`, 1-stick configurations simultaneously witness mirror collapse
    (`hamming3 stick3Left stick3Right = 2`, `reflResidual3 stick3Left stick3Right = 0`)
    and positive non-mirror reflection residual
    (`hamming3 stick3Left stick3Mid = 2`, `reflResidual3 stick3Left stick3Mid = 2`),
    establishing `n = 3` as the minimal 1-stick carrier threshold (`N19`). -/
theorem n3_minimal_single_stick_reflection_witness :
    hamming3 stick3Left stick3Right = 2 ∧
    reflResidual3 stick3Left stick3Right = 0 ∧
    hamming3 stick3Left stick3Mid = 2 ∧
    reflResidual3 stick3Left stick3Mid = 2 := by
  decide

/-! ## Section 4: One-Token Refusal Reification, Reflective Chain, and Depth-`d` Outrun (`OWE-07`, `N21`–`N22`) -/

/-- Carrier items distinguishing a raw token presentation from a reified refusal receipt. -/
inductive MItem where
  | tok     : Nat → MItem
  | receipt : Nat → MItem
deriving DecidableEq, Repr

/-- State carrying distinct items and recorded off-diagonal refusal pairs. -/
structure MState where
  data : List MItem
  rel  : List (MItem × MItem)
deriving DecidableEq, Repr

/-- Single-token refusal-reification step: admitting a fresh token or reifying
    duplicate refusal as a receipt linked to the refused token. -/
def stepM (s : MState) (t : Nat) : MState :=
  if MItem.tok t ∈ s.data then
    let r := MItem.receipt s.data.length
    { data := s.data ++ [r],
      rel  := s.rel ++ [(MItem.tok t, r)] }
  else
    { s with data := s.data ++ [MItem.tok t] }

/-- Lower bound over the comparison class of `stepM` traces starting from empty
    seed `⟨[], []⟩` measured by presentation-step count: 0 steps and 1 step
    (for any token `t`) leave `rel = []` and carrier size at most `1`, so at
    least `2` presentations are required for `stepM` to inhabit `rel`. -/
theorem stepM_lower_bound_two_steps (t : Nat) :
    (⟨[], []⟩ : MState).rel = [] ∧
    (stepM ⟨[], []⟩ t).data.length = 1 ∧
    (stepM ⟨[], []⟩ t).rel = [] := by
  simp [stepM]

/-- Existence witness at the 2-step lower bound for `stepM` from `⟨[], []⟩`:
    under the supplied `MItem` constructors (`tok` vs `receipt`) and `stepM`
    transition rule, presenting token `0` twice produces a two-element carrier
    `[tok 0, receipt 1]` and one off-diagonal pair `(tok 0, receipt 1)`. -/
theorem min_witnessed_route_closes :
    let s := stepM (stepM ⟨[], []⟩ 0) 0
    s.data.length = 2 ∧
    s.rel.length = 1 ∧
    (∀ p ∈ s.rel, p.1 ≠ p.2) := by
  decide

/-- Fact-level off-diagonal witnesses in `s.rel` do not by themselves prevent
    another relation `r` from extending `s.rel` with a reflexive diagonal pair. -/
theorem bridge_facts_not_law :
    let s := stepM (stepM ⟨[], []⟩ 0) 0
    ∃ (r : MItem → MItem → Prop),
      (∀ p ∈ s.rel, r p.1 p.2) ∧
      ∃ x, r x x := by
  intro s
  exact ⟨fun _ _ => True, fun _ _ => trivial, MItem.tok 0, trivial⟩

/-- Subject-typed state for reflective chain growth (`RefusalFrontier.lean`). -/
structure PState where
  data : List Nat
  tags : List Nat
  rel  : List (Nat × Nat)
deriving DecidableEq, Repr

/-- Reflective refusal step: refuses duplicate presentation of the most recent
    frontier element `s.data.length - 1`, appends receipt `s.data.length`, tags it,
    and records the successor edge `(s.data.length - 1, s.data.length)`. -/
def stepRefl (s : PState) : PState :=
  let t := s.data.length - 1
  let r := s.data.length
  { data := s.data ++ [r],
    tags := s.tags ++ [r],
    rel  := s.rel ++ [(t, r)] }

/-- Iterated reflective chain starting from seed `[0]`. -/
def reflState : Nat → PState
  | 0     => ⟨[0], [], []⟩
  | n + 1 => stepRefl (reflState n)

theorem reflective_chain_growth :
    ∀ n, (reflState n).data.length = n + 1 := by
  intro n
  induction n with
  | zero => rfl
  | succ m ih =>
    show ((reflState m).data ++ [(reflState m).data.length]).length = m + 2
    rw [List.length_append, ih]
    rfl

theorem reflective_chain_is_initial_segment :
    ∀ n, (reflState n).data = List.range (n + 1) := by
  intro n
  induction n with
  | zero => rfl
  | succ m ih =>
    show (reflState m).data ++ [(reflState m).data.length] = List.range (m + 2)
    rw [ih, List.length_range, ← List.range_succ]

theorem reflective_chain_successor_relation :
    ∀ n, (reflState n).rel = (List.range n).map (fun k => (k, k + 1)) := by
  intro n
  induction n with
  | zero => rfl
  | succ m ih =>
    show (stepRefl (reflState m)).rel = _
    have hr : List.range (m + 1) = List.range m ++ [m] := List.range_succ
    simp only [stepRefl]
    rw [reflective_chain_growth m, ih, hr, List.map_append]
    rfl

theorem reflective_chain_irreflexive_facts :
    ∀ n p, p ∈ (reflState n).rel → p.1 ≠ p.2 := by
  intro n p hp
  rw [reflective_chain_successor_relation] at hp
  rcases List.mem_map.mp hp with ⟨k, _, rfl⟩
  omega

theorem reflective_chain_tags :
    ∀ n, (reflState n).tags = (List.range n).map (· + 1) := by
  intro n
  induction n with
  | zero => rfl
  | succ m ih =>
    show (stepRefl (reflState m)).tags = _
    have hr : List.range (m + 1) = List.range m ++ [m] := List.range_succ
    simp only [stepRefl]
    rw [reflective_chain_growth m, ih, hr, List.map_append]
    simp

/-- Depth-1 observation profile: `(isTagged, hasIncomingEdge, hasOutgoingEdge)`. -/
def profile1 (s : PState) (i : Nat) : Bool × Bool × Bool :=
  (decide (i ∈ s.tags),
   decide (∃ p ∈ s.rel, p.2 = i),
   decide (∃ p ∈ s.rel, p.1 = i))

theorem chain_tagged_iff (n i : Nat) :
    i ∈ (reflState n).tags ↔ (1 ≤ i ∧ i ≤ n) := by
  rw [reflective_chain_tags]
  simp only [List.mem_map, List.mem_range]
  constructor
  · rintro ⟨k, hk, rfl⟩
    exact ⟨by omega, by omega⟩
  · intro ⟨h1, h2⟩
    exact ⟨i - 1, by omega, by omega⟩

theorem chain_hasIn_iff (n i : Nat) :
    (∃ p ∈ (reflState n).rel, p.2 = i) ↔ (1 ≤ i ∧ i ≤ n) := by
  rw [reflective_chain_successor_relation]
  simp only [List.mem_map, List.mem_range]
  constructor
  · rintro ⟨p, ⟨k, hk, rfl⟩, h2⟩
    have hki : k + 1 = i := h2
    exact ⟨by omega, by omega⟩
  · intro ⟨h1, h2⟩
    refine ⟨(i - 1, i), ⟨i - 1, by omega, ?_⟩, rfl⟩
    rw [Nat.sub_add_cancel h1]

theorem chain_hasOut_iff (n i : Nat) :
    (∃ p ∈ (reflState n).rel, p.1 = i) ↔ i < n := by
  rw [reflective_chain_successor_relation]
  simp only [List.mem_map, List.mem_range]
  constructor
  · rintro ⟨p, ⟨k, hk, rfl⟩, h1⟩
    have hki : k = i := h1
    omega
  · intro h
    exact ⟨(i, i + 1), ⟨i, h, rfl⟩, rfl⟩

theorem middle_profile (n i : Nat) (h1 : 1 ≤ i) (h2 : i < n) :
    profile1 (reflState n) i = (true, true, true) := by
  have ht := (chain_tagged_iff n i).mpr ⟨h1, by omega⟩
  have hin := (chain_hasIn_iff n i).mpr ⟨h1, by omega⟩
  have hout := (chain_hasOut_iff n i).mpr h2
  simp only [profile1, decide_eq_true ht, decide_eq_true hin, decide_eq_true hout]

theorem endpoint0_profile (n : Nat) (h : 1 ≤ n) :
    profile1 (reflState n) 0 = (false, false, true) := by
  have ht : ¬ (0 ∈ (reflState n).tags) := by
    rw [chain_tagged_iff]; omega
  have hin : ¬ (∃ p ∈ (reflState n).rel, p.2 = 0) := by
    rw [chain_hasIn_iff]; omega
  have hout := (chain_hasOut_iff n 0).mpr (by omega)
  simp only [profile1, decide_eq_false ht, decide_eq_false hin, decide_eq_true hout]

theorem endpointN_profile (n : Nat) (h : 1 ≤ n) :
    profile1 (reflState n) n = (true, true, false) := by
  have ht := (chain_tagged_iff n n).mpr ⟨h, Nat.le_refl n⟩
  have hin := (chain_hasIn_iff n n).mpr ⟨h, Nat.le_refl n⟩
  have hout : ¬ (∃ p ∈ (reflState n).rel, p.1 = n) := fun hex =>
    absurd ((chain_hasOut_iff n n).mp hex) (Nat.lt_irrefl n)
  simp only [profile1, decide_eq_true ht, decide_eq_true hin, decide_eq_false hout]

theorem depth1_obstructions_are_exactly_middle_pairs
    (n i j : Nat) (hn : 1 ≤ n) (hi : i ≤ n) (hj : j ≤ n) (hne : i ≠ j) :
    (profile1 (reflState n) i = profile1 (reflState n) j) ↔
      (1 ≤ i ∧ i < n ∧ 1 ≤ j ∧ j < n) := by
  constructor
  · intro heq
    have tri : ∀ m : Nat, m ≤ n → m = 0 ∨ m = n ∨ (1 ≤ m ∧ m < n) := by
      intro m hm
      rcases Nat.eq_zero_or_pos m with h0 | h1
      · exact Or.inl h0
      · rcases Nat.lt_or_ge m n with hlt | hge
        · exact Or.inr (Or.inr ⟨h1, hlt⟩)
        · exact Or.inr (Or.inl (Nat.le_antisymm hm hge))
    have hI := tri i hi
    have hJ := tri j hj
    rcases hI with hi0 | hiN | hiM
    · rcases hJ with hj0 | hjN | hjM
      · exact absurd (by omega) hne
      · rw [hi0, hjN, endpoint0_profile n hn, endpointN_profile n hn] at heq
        exact absurd heq (by decide)
      · rw [hi0, endpoint0_profile n hn, middle_profile n j hjM.1 hjM.2] at heq
        exact absurd heq (by decide)
    · rcases hJ with hj0 | hjN | hjM
      · rw [hiN, hj0, endpointN_profile n hn, endpoint0_profile n hn] at heq
        exact absurd heq (by decide)
      · exact absurd (by omega) hne
      · rw [hiN, endpointN_profile n hn, middle_profile n j hjM.1 hjM.2] at heq
        exact absurd heq (by decide)
    · rcases hJ with hj0 | hjN | hjM
      · rw [hj0, middle_profile n i hiM.1 hiM.2, endpoint0_profile n hn] at heq
        exact absurd heq (by decide)
      · rw [hjN, middle_profile n i hiM.1 hiM.2, endpointN_profile n hn] at heq
        exact absurd heq (by decide)
      · exact ⟨hiM.1, hiM.2, hjM.1, hjM.2⟩
  · intro ⟨h1, h2, h3, h4⟩
    rw [middle_profile n i h1 h2, middle_profile n j h3 h4]

/-- Endogenous challenge generation: for every `n ≥ 3`, carrier elements `1` and `2`
    are distinct yet share identical depth-1 profiles. -/
theorem generation_never_dries (n : Nat) (h : 3 ≤ n) :
    (1 : Nat) ≠ 2 ∧
      profile1 (reflState n) 1 = profile1 (reflState n) 2 := by
  refine ⟨by omega, ?_⟩
  rw [middle_profile n 1 (by omega) (by omega),
      middle_profile n 2 (by omega) (by omega)]

theorem automark_presence_vacuous (n : Nat) (h : 3 ≤ n) :
    (∀ i, 1 ≤ i → i ≤ n → i ∈ (reflState n).tags) ∧
      profile1 (reflState n) 1 = profile1 (reflState n) 2 :=
  ⟨fun i h1 h2 => (chain_tagged_iff n i).mpr ⟨h1, h2⟩,
   (generation_never_dries n h).2⟩

theorem le_foldr_max (marks : List Nat) :
    ∀ x ∈ marks, x ≤ marks.foldr max 0 := by
  induction marks with
  | nil => intro x hx; cases hx
  | cons a rest ih =>
    intro x hx
    rcases List.mem_cons.mp hx with rfl | hmem
    · simp only [List.foldr]
      omega
    · have := ih x hmem
      simp only [List.foldr]
      omega

theorem finite_marks_outrun (marks : List Nat) :
    ∃ n i j, 1 ≤ i ∧ i < n ∧ 1 ≤ j ∧ j < n ∧ i ≠ j ∧
      i ∉ marks ∧ j ∉ marks ∧
      profile1 (reflState n) i = profile1 (reflState n) j := by
  refine ⟨marks.foldr max 0 + 3, marks.foldr max 0 + 1,
          marks.foldr max 0 + 2,
          by omega, by omega, by omega, by omega, by omega, ?_, ?_, ?_⟩
  · intro hmem
    have := le_foldr_max marks _ hmem
    omega
  · intro hmem
    have := le_foldr_max marks _ hmem
    omega
  · rw [middle_profile _ _ (by omega) (by omega),
        middle_profile _ _ (by omega) (by omega)]

def profileV (s : PState) (i : Nat) : (Bool × Bool × Bool) × Nat :=
  (profile1 s i, i)

theorem valued_marks_collapse_generation (n i j : Nat) (h : i ≠ j) :
    profileV (reflState n) i ≠ profileV (reflState n) j := by
  intro he
  exact h (congrArg Prod.snd he)

def swap12 (k : Nat) : Nat := if k = 1 then 2 else if k = 2 then 1 else k

theorem middle_swap_not_relation_preserving (n : Nat) (h : 2 ≤ n) :
    (0, 1) ∈ (reflState n).rel ∧
      ((swap12 0, swap12 1) ∉ (reflState n).rel) := by
  constructor
  · rw [reflective_chain_successor_relation]
    exact List.mem_map.mpr ⟨0, List.mem_range.mpr (by omega), rfl⟩
  · rw [reflective_chain_successor_relation]
    intro hmem
    have ⟨k, _, hk⟩ := List.mem_map.mp hmem
    simp [swap12, Prod.mk.injEq] at hk
    omega

def profile2 (s : PState) (i : Nat) :
    (Bool × Bool × Bool) × List (Bool × Bool × Bool) ×
      List (Bool × Bool × Bool) :=
  (profile1 s i,
   (s.rel.filter (fun p => decide (p.2 = i))).map (fun p => profile1 s p.1),
   (s.rel.filter (fun p => decide (p.1 = i))).map (fun p => profile1 s p.2))

theorem depth2_separates_near_ends_n4 :
    profile2 (reflState 4) 1 ≠ profile2 (reflState 4) 3 := by decide

theorem depth2_obstruction_n5 :
    profile2 (reflState 5) 2 = profile2 (reflState 5) 3 ∧
      (2 : Nat) ≠ 3 := by decide

theorem filter_range_decide_eq (n i : Nat) :
    (List.range n).filter (fun k => decide (k = i)) =
      if i < n then [i] else [] := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [List.range_succ, List.filter_append, ih]
    rcases Nat.lt_trichotomy i n with hlt | heq | hgt
    · have hne : ¬n = i := by omega
      have hout : i < n + 1 := by omega
      simp [hlt, hne, hout]
    · subst i
      have hnot : ¬n < n := Nat.lt_irrefl n
      have hout : n < n + 1 := by omega
      simp [hnot, hout]
    · have hnot : ¬i < n := by omega
      have hne : ¬n = i := by omega
      have hout : ¬i < n + 1 := by omega
      simp [hnot, hne, hout]

theorem filter_range_succ_eq (n i : Nat) (hpos : 0 < i) (hle : i ≤ n) :
    (List.range n).filter (fun k => decide (k + 1 = i)) = [i - 1] := by
  have hpred : (fun k => decide (k + 1 = i)) =
      (fun k => decide (k = i - 1)) := by
    funext k
    by_cases h : k + 1 = i
    · have h' : k = i - 1 := by omega
      have hrestore : i - 1 + 1 = i := Nat.sub_add_cancel (by omega)
      simp [h', hrestore]
    · have h' : ¬k = i - 1 := by omega
      simp [h, h']
  rw [hpred, filter_range_decide_eq]
  simp [show i - 1 < n by omega]

theorem filter_range_eq (n i : Nat) (hlt : i < n) :
    (List.range n).filter (fun k => decide (k = i)) = [i] := by
  rw [filter_range_decide_eq]
  simp [hlt]

/-- Ordered radius-`d` ball around `i`: `[i - d, ..., i + d]`. -/
def ball (i d : Nat) : List Nat :=
  (List.range (2 * d + 1)).map (fun k => i - d + k)

theorem ball_length (i d : Nat) : (ball i d).length = 2 * d + 1 := by
  simp [ball]

/-- Radius-`d` structural profile along the reflective chain. -/
def profileD (n i d : Nat) : List (Bool × Bool × Bool) :=
  (ball i d).map (profile1 (reflState n))

theorem profileD_deep (n i d : Nat) (hlo : d < i) (hhi : i + d < n) :
    profileD n i d =
      (List.range (2 * d + 1)).map (fun _ => (true, true, true)) := by
  unfold profileD ball
  rw [List.map_map]
  apply List.map_congr_left
  intro k hk
  have hkr := List.mem_range.mp hk
  show profile1 (reflState n) (i - d + k) = (true, true, true)
  apply middle_profile
  · omega
  · omega

/-- Every pair of deep-interior points at radius `d` has identical `profileD`. -/
theorem depth_d_outrun (n i j d : Nat)
    (hi0 : d < i) (hi1 : i + d < n) (hj0 : d < j) (hj1 : j + d < n) :
    profileD n i d = profileD n j d := by
  rw [profileD_deep n i d hi0 hi1, profileD_deep n j d hj0 hj1]

/-- For every fixed radius `d` and chain length `n ≥ 2 * d + 3`, there exist
    distinct deep-interior points `i ≠ j` with identical radius-`d` profiles. -/
theorem depth_d_obstruction (d n : Nat) (hn : 2 * d + 3 ≤ n) :
    ∃ i j, i ≠ j ∧ d < i ∧ i + d < n ∧ d < j ∧ j + d < n ∧
      profileD n i d = profileD n j d :=
  ⟨d + 1, d + 2, by omega, by omega, by omega, by omega, by omega,
   depth_d_outrun n (d + 1) (d + 2) d (by omega) (by omega) (by omega) (by omega)⟩

theorem incoming_edges_interior (n i : Nat) (hpos : 0 < i) (hle : i ≤ n) :
    (reflState n).rel.filter (fun p => decide (p.2 = i)) = [(i - 1, i)] := by
  rw [reflective_chain_successor_relation, List.filter_map]
  change List.map (fun k => (k, k + 1))
    ((List.range n).filter (fun k => decide (k + 1 = i))) = [(i - 1, i)]
  rw [filter_range_succ_eq n i hpos hle]
  simp [Nat.sub_add_cancel hpos]

theorem outgoing_edges_interior (n i : Nat) (hlt : i < n) :
    (reflState n).rel.filter (fun p => decide (p.1 = i)) = [(i, i + 1)] := by
  rw [reflective_chain_successor_relation, List.filter_map]
  change List.map (fun k => (k, k + 1))
    ((List.range n).filter (fun k => decide (k = i))) = [(i, i + 1)]
  rw [filter_range_eq n i hlt]
  rfl

theorem profile2_interior (n i : Nat) (hpos : 0 < i) (hlt : i < n) :
    profile2 (reflState n) i =
      (profile1 (reflState n) i,
       [profile1 (reflState n) (i - 1)],
       [profile1 (reflState n) (i + 1)]) := by
  unfold profile2
  rw [incoming_edges_interior n i hpos (by omega),
      outgoing_edges_interior n i hlt]
  rfl

theorem profileD_radius_one (n i : Nat) (hpos : 0 < i) :
    profileD n i 1 =
      [profile1 (reflState n) (i - 1),
       profile1 (reflState n) i,
       profile1 (reflState n) (i + 1)] := by
  have hcenter : i - 1 + 1 = i := Nat.sub_add_cancel (by omega)
  have hright : i - 1 + 2 = i + 1 := by omega
  simp [profileD, ball, List.range_succ, hcenter, hright]

theorem radius_one_agrees_with_sealed_depth2 (n i j : Nat)
    (hi0 : 0 < i) (hi1 : i < n) (hj0 : 0 < j) (hj1 : j < n) :
    (profile2 (reflState n) i = profile2 (reflState n) j ↔
      profileD n i 1 = profileD n j 1) := by
  rw [profile2_interior n i hi0 hi1, profile2_interior n j hj0 hj1,
      profileD_radius_one n i hi0, profileD_radius_one n j hj0]
  simp only [Prod.mk.injEq, List.cons.injEq, and_true]
  constructor
  · rintro ⟨hcenter, hleft, hright⟩
    exact ⟨hleft, hcenter, hright⟩
  · rintro ⟨hleft, hcenter, hright⟩
    exact ⟨hcenter, hleft, hright⟩

end OmegaCodex.ProfilePreorderAndGenerator
