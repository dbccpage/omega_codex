import «core_l025_38_integration_does_not_erase_lggr»
import «lg006_primitive_lift_candidate»
/-
Paper 025: carrier/theory lifts require declared lift gates.

Changing carrier language is not a free repair of LGGR.  A licensed primitive
lift candidate must declare the source obstruction, the new carrier, replay
evidence, residual reduction, and closure preservation.  The checklist itself
is still diagnostic infrastructure: by itself it does not imply that local
green forces global green.
-/

namespace PaperAE006

abbrev EpkLiftCandidate :=
  OmegaCore.PrimitiveLiftCandidate.LiftCandidate

def IsLicensedEpkLiftCandidate (L : EpkLiftCandidate) : Prop :=
  OmegaCore.PrimitiveLiftCandidate.IsLicensedLiftCandidate L

def fullEpkLiftCandidate : EpkLiftCandidate :=
  { hasSourceObstruction := true,
    hasNewCarrier := true,
    hasReplay := true,
    reducesPhi := true,
    preservesClosure := true }

def carrierOnlyEpkLiftCandidate : EpkLiftCandidate :=
  { hasSourceObstruction := true,
    hasNewCarrier := true,
    hasReplay := false,
    reducesPhi := false,
    preservesClosure := false }

theorem licensed_epk_lift_requires_all_lift_fields
    (L : EpkLiftCandidate) :
    IsLicensedEpkLiftCandidate L ↔
      L.hasSourceObstruction = true ∧
      L.hasNewCarrier = true ∧
      L.hasReplay = true ∧
      L.reducesPhi = true ∧
      L.preservesClosure = true :=
  OmegaCore.PrimitiveLiftCandidate.licensed_lift_iff_all_fields_true L

theorem licensed_epk_lift_requires_source_obstruction
    (L : EpkLiftCandidate) :
    IsLicensedEpkLiftCandidate L →
      L.hasSourceObstruction = true :=
  OmegaCore.PrimitiveLiftCandidate.licensed_lift_requires_source_obstruction L

theorem licensed_epk_lift_requires_new_carrier
    (L : EpkLiftCandidate) :
    IsLicensedEpkLiftCandidate L →
      L.hasNewCarrier = true :=
  OmegaCore.PrimitiveLiftCandidate.licensed_lift_requires_new_carrier L

theorem licensed_epk_lift_requires_replay_reduction_closure
    (L : EpkLiftCandidate) :
    IsLicensedEpkLiftCandidate L →
      L.hasReplay = true ∧
        L.reducesPhi = true ∧
        L.preservesClosure = true := by
  intro hLicensed
  exact
    ⟨OmegaCore.PrimitiveLiftCandidate.licensed_lift_requires_replay
        L hLicensed,
      OmegaCore.PrimitiveLiftCandidate.licensed_lift_requires_residual_reduction
        L hLicensed,
      OmegaCore.PrimitiveLiftCandidate.licensed_lift_requires_closure_preservation
        L hLicensed⟩

theorem missing_source_obstruction_refuses_epk_lift
    (L : EpkLiftCandidate)
    (hSource : L.hasSourceObstruction = false) :
    ¬ IsLicensedEpkLiftCandidate L :=
  OmegaCore.PrimitiveLiftCandidate.missing_source_obstruction_blocks_lift
    L hSource

theorem missing_new_carrier_refuses_epk_lift
    (L : EpkLiftCandidate)
    (hCarrier : L.hasNewCarrier = false) :
    ¬ IsLicensedEpkLiftCandidate L :=
  OmegaCore.PrimitiveLiftCandidate.missing_new_carrier_blocks_lift
    L hCarrier

theorem missing_replay_refuses_epk_lift
    (L : EpkLiftCandidate)
    (hReplay : L.hasReplay = false) :
    ¬ IsLicensedEpkLiftCandidate L :=
  OmegaCore.PrimitiveLiftCandidate.missing_replay_blocks_lift L hReplay

theorem carrier_change_alone_does_not_license_epk_lift :
    ¬ IsLicensedEpkLiftCandidate carrierOnlyEpkLiftCandidate :=
  missing_replay_refuses_epk_lift carrierOnlyEpkLiftCandidate rfl

theorem full_epk_lift_candidate_is_licensed :
    IsLicensedEpkLiftCandidate fullEpkLiftCandidate := by
  exact ⟨rfl, rfl, rfl, rfl, rfl⟩

theorem licensed_epk_lift_compatible_with_lggr :
    ∃ (L : EpkLiftCandidate) (e1 e2 eg : Bool),
      IsLicensedEpkLiftCandidate L ∧
        PaperAE004.localProduct e1 e2 = 1 ∧
        PaperAE004.b2i eg = 0 ∧
        PaperAE004.deltaEval e1 e2 eg = -1 := by
  exact
    ⟨fullEpkLiftCandidate, true, true, false,
      full_epk_lift_candidate_is_licensed,
      rfl,
      rfl,
      PaperAE004.local_green_global_red_counterexample⟩

theorem licensed_epk_lift_does_not_force_global_green :
    ∃ L : EpkLiftCandidate,
      IsLicensedEpkLiftCandidate L ∧
        ¬ LocalGreenImpliesGlobalGreen := by
  exact
    ⟨fullEpkLiftCandidate,
      full_epk_lift_candidate_is_licensed,
      lggr_refutes_local_green_implies_global_green⟩

#print axioms PaperAE006.licensed_epk_lift_requires_all_lift_fields
#print axioms PaperAE006.licensed_epk_lift_requires_source_obstruction
#print axioms PaperAE006.licensed_epk_lift_requires_new_carrier
#print axioms PaperAE006.licensed_epk_lift_requires_replay_reduction_closure
#print axioms PaperAE006.missing_source_obstruction_refuses_epk_lift
#print axioms PaperAE006.missing_new_carrier_refuses_epk_lift
#print axioms PaperAE006.missing_replay_refuses_epk_lift
#print axioms PaperAE006.carrier_change_alone_does_not_license_epk_lift
#print axioms PaperAE006.full_epk_lift_candidate_is_licensed
#print axioms PaperAE006.licensed_epk_lift_compatible_with_lggr
#print axioms PaperAE006.licensed_epk_lift_does_not_force_global_green

end PaperAE006
