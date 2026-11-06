import «core_l025_38_integration_does_not_erase_lggr»
import «lg006_primitive_spine_summary»
/-
Paper 025: the primitive EPK spine is a gate stack, not a repair shortcut.

The primitive spine summary ties quotient descent, obstruction classification,
repair certificates, terminal packets, and lift candidates together.  The
integration is conjunctive: each gate keeps its own obligation, and even a
certified spine summary does not turn local green into global green.
-/

namespace PaperAE006

universe u v w

variable {α : Type u} {β : Type v} {γ : Type w}

abbrev EpkPrimitiveSpineSummary
    (P : OmegaCore.PointedPrimitiveDifference α β)
    (C : OmegaCore.ObstructionClassifier
      (OmegaCore.PointedResidualQuotient P))
    (S : OmegaCore.PrimitiveAdmissibleRepair.AdmissibleRepairSystem
      (OmegaCore.PointedResidualQuotient P))
    (q : OmegaCore.PointedResidualQuotient P) :=
  OmegaCore.PrimitiveSpineSummary.SpineSummary P C S q

abbrev EpkPrimitiveSpineSummaryWithCertificate
    (P : OmegaCore.PointedPrimitiveDifference α β)
    (C : OmegaCore.ObstructionClassifier
      (OmegaCore.PointedResidualQuotient P))
    (S : OmegaCore.PrimitiveAdmissibleRepair.AdmissibleRepairSystem
      (OmegaCore.PointedResidualQuotient P))
    (q : OmegaCore.PointedResidualQuotient P) :=
  OmegaCore.PrimitiveSpineSummary.SpineSummaryWithCertificate P C S q

def EpkPrimitiveSpineReady
    {P : OmegaCore.PointedPrimitiveDifference α β}
    {C : OmegaCore.ObstructionClassifier
      (OmegaCore.PointedResidualQuotient P)}
    {S : OmegaCore.PrimitiveAdmissibleRepair.AdmissibleRepairSystem
      (OmegaCore.PointedResidualQuotient P)}
    {q : OmegaCore.PointedResidualQuotient P}
    (summary : EpkPrimitiveSpineSummary P C S q) : Prop :=
  OmegaCore.PrimitiveTerminalPacket.PacketReady summary.terminal_packet ∧
    OmegaCore.PrimitiveLiftCandidate.IsLicensedLiftCandidate
      summary.lift_candidate

theorem epk_spine_delta_descends_iff_congruent
    (P : OmegaCore.PrimitiveDifference α β) :
    (∃ F : P.ResidualQuotient → P.ResidualQuotient → β,
        ∀ x y : α, F (P.classOf x) (P.classOf y) = P.δ x y)
      ↔ P.DeltaCongruent :=
  OmegaCore.PrimitiveSpineSummary.spine_delta_descends_iff_congruent P

theorem epk_spine_delta_no_factor_of_not_congruent
    (P : OmegaCore.PrimitiveDifference α β)
    (hδ : ¬ P.DeltaCongruent) :
    ¬ (∃ F : P.ResidualQuotient → P.ResidualQuotient → β,
        ∀ x y : α, F (P.classOf x) (P.classOf y) = P.δ x y) :=
  OmegaCore.PrimitiveSpineSummary.spine_delta_no_factor_of_not_congruent
    P hδ

theorem epk_spine_delta_no_factor_of_zeroRel_ne
    (P : OmegaCore.PrimitiveDifference α β)
    {x x' y y' : α}
    (hxx : P.ZeroRel x x') (hyy : P.ZeroRel y y')
    (hne : P.δ x y ≠ P.δ x' y') :
    ¬ (∃ F : P.ResidualQuotient → P.ResidualQuotient → β,
        ∀ x y : α, F (P.classOf x) (P.classOf y) = P.δ x y) :=
  OmegaCore.PrimitiveSpineSummary.spine_delta_no_factor_of_zeroRel_ne
    P hxx hyy hne

theorem epk_spine_invariant_descends_iff_congruent
    (P : OmegaCore.PrimitiveDifference α β) (phi : α → γ) :
    (∃ F : P.ResidualQuotient → γ,
        ∀ x : α, F (P.classOf x) = phi x)
      ↔ P.InvariantCongruent phi :=
  OmegaCore.PrimitiveSpineSummary.spine_invariant_descends_iff_congruent
    P phi

theorem epk_spine_raw_phi_noncongruent_blocks_classifier
    (P : OmegaCore.PointedPrimitiveDifference α β)
    (phiRaw : α → Nat)
    (hnot :
      ¬ OmegaCore.PrimitiveDifference.InvariantCongruent
        P.toPrimitiveDifference phiRaw) :
    ¬ (∃ C : OmegaCore.ObstructionClassifier
          (OmegaCore.PointedResidualQuotient P),
        ∀ x : α,
          C.Phi (OmegaCore.PrimitiveDifference.classOf
            P.toPrimitiveDifference x) = phiRaw x) :=
  OmegaCore.PrimitiveSpineSummary.spine_raw_phi_noncongruent_blocks_classifier
    P phiRaw hnot

theorem epk_spine_repair_boundary_repaired_iff
    (input : OmegaCore.PrimitiveRepairBoundary.RepairBoundaryInput) :
    OmegaCore.PrimitiveRepairBoundary.repairBoundaryDecision input =
        OmegaCore.PrimitiveRepairBoundary.RepairBoundaryStatus.repaired ↔
      input.policyAllowed = true ∧
      input.hasRule = true ∧
      input.withinBudget = true ∧
      input.hasAdmissibleWitness = true :=
  OmegaCore.PrimitiveSpineSummary.spine_repair_boundary_repaired_iff input

theorem epk_spine_summary_terminal_status_matches_classifier
    (P : OmegaCore.PointedPrimitiveDifference α β)
    (C : OmegaCore.ObstructionClassifier
      (OmegaCore.PointedResidualQuotient P))
    (S : OmegaCore.PrimitiveAdmissibleRepair.AdmissibleRepairSystem
      (OmegaCore.PointedResidualQuotient P))
    (q : OmegaCore.PointedResidualQuotient P)
    (summary : EpkPrimitiveSpineSummary P C S q) :
    summary.terminal_packet.status = C.terminalize q :=
  OmegaCore.PrimitiveSpineSummary.summary_terminal_status_matches
    P C S q summary

theorem epk_spine_certificate_implies_exact
    (P : OmegaCore.PointedPrimitiveDifference α β)
    (C : OmegaCore.ObstructionClassifier
      (OmegaCore.PointedResidualQuotient P))
    (S : OmegaCore.PrimitiveAdmissibleRepair.AdmissibleRepairSystem
      (OmegaCore.PointedResidualQuotient P))
    (q : OmegaCore.PointedResidualQuotient P)
    (summary : EpkPrimitiveSpineSummaryWithCertificate P C S q) :
    C.IsExactRepair q :=
  OmegaCore.PrimitiveSpineSummary.summaryWithCertificate_implies_exact
    P C S q summary

theorem epk_spine_certificate_implies_admissible_witnessed_exact
    (P : OmegaCore.PointedPrimitiveDifference α β)
    (C : OmegaCore.ObstructionClassifier
      (OmegaCore.PointedResidualQuotient P))
    (S : OmegaCore.PrimitiveAdmissibleRepair.AdmissibleRepairSystem
      (OmegaCore.PointedResidualQuotient P))
    (q : OmegaCore.PointedResidualQuotient P)
    (summary : EpkPrimitiveSpineSummaryWithCertificate P C S q) :
    OmegaCore.PrimitiveAdmissibleRepair.AdmissibleWitnessedExactRepair
      C S P.zeroClass q :=
  OmegaCore.PrimitiveSpineSummary.summaryWithCertificate_implies_admissible_witnessed_exact
    P C S q summary

theorem epk_spine_not_ready_iff_repaired_without_certificate
    (P : OmegaCore.PointedPrimitiveDifference α β)
    (C : OmegaCore.ObstructionClassifier
      (OmegaCore.PointedResidualQuotient P))
    (S : OmegaCore.PrimitiveAdmissibleRepair.AdmissibleRepairSystem
      (OmegaCore.PointedResidualQuotient P))
    (q : OmegaCore.PointedResidualQuotient P)
    (summary : EpkPrimitiveSpineSummary P C S q) :
    ¬ OmegaCore.PrimitiveTerminalPacket.PacketReady
        summary.terminal_packet ↔
      summary.terminal_packet.boundary =
          OmegaCore.PrimitiveRepairBoundary.RepairBoundaryStatus.repaired ∧
        summary.terminal_packet.hasCertificate = false :=
  OmegaCore.PrimitiveSpineSummary.spine_packet_not_ready_iff_repaired_without_certificate
    P C q summary.terminal_packet

theorem epk_spine_ready_decomposes
    (P : OmegaCore.PointedPrimitiveDifference α β)
    (C : OmegaCore.ObstructionClassifier
      (OmegaCore.PointedResidualQuotient P))
    (S : OmegaCore.PrimitiveAdmissibleRepair.AdmissibleRepairSystem
      (OmegaCore.PointedResidualQuotient P))
    (q : OmegaCore.PointedResidualQuotient P)
    (summary : EpkPrimitiveSpineSummary P C S q) :
    EpkPrimitiveSpineReady summary →
      (OmegaCore.PrimitiveTerminalPacket.PacketBlocked
          summary.terminal_packet ∨
        OmegaCore.PrimitiveTerminalPacket.PacketRepaired
          summary.terminal_packet) ∧
      summary.lift_candidate.hasReplay = true ∧
      summary.lift_candidate.reducesPhi = true ∧
      summary.lift_candidate.preservesClosure = true := by
  intro hReady
  exact
    ⟨(OmegaCore.PrimitiveTerminalPacket.packet_ready_iff_blocked_or_repaired
        C q summary.terminal_packet).mp hReady.left,
      OmegaCore.PrimitiveSpineSummary.spine_lift_requires_replay_reduction_closure
        summary.lift_candidate hReady.right⟩

theorem missing_source_obstruction_blocks_epk_spine_ready
    (P : OmegaCore.PointedPrimitiveDifference α β)
    (C : OmegaCore.ObstructionClassifier
      (OmegaCore.PointedResidualQuotient P))
    (S : OmegaCore.PrimitiveAdmissibleRepair.AdmissibleRepairSystem
      (OmegaCore.PointedResidualQuotient P))
    (q : OmegaCore.PointedResidualQuotient P)
    (summary : EpkPrimitiveSpineSummary P C S q)
    (hSource :
      summary.lift_candidate.hasSourceObstruction = false) :
    ¬ EpkPrimitiveSpineReady summary := by
  intro hReady
  exact
    OmegaCore.PrimitiveSpineSummary.spine_lift_missing_source_blocks
      summary.lift_candidate hSource hReady.right

theorem missing_new_carrier_blocks_epk_spine_ready
    (P : OmegaCore.PointedPrimitiveDifference α β)
    (C : OmegaCore.ObstructionClassifier
      (OmegaCore.PointedResidualQuotient P))
    (S : OmegaCore.PrimitiveAdmissibleRepair.AdmissibleRepairSystem
      (OmegaCore.PointedResidualQuotient P))
    (q : OmegaCore.PointedResidualQuotient P)
    (summary : EpkPrimitiveSpineSummary P C S q)
    (hCarrier :
      summary.lift_candidate.hasNewCarrier = false) :
    ¬ EpkPrimitiveSpineReady summary := by
  intro hReady
  exact
    OmegaCore.PrimitiveSpineSummary.spine_lift_missing_new_carrier_blocks
      summary.lift_candidate hCarrier hReady.right

theorem certified_epk_spine_does_not_force_global_green
    (P : OmegaCore.PointedPrimitiveDifference α β)
    (C : OmegaCore.ObstructionClassifier
      (OmegaCore.PointedResidualQuotient P))
    (S : OmegaCore.PrimitiveAdmissibleRepair.AdmissibleRepairSystem
      (OmegaCore.PointedResidualQuotient P))
    (q : OmegaCore.PointedResidualQuotient P)
    (_summary : EpkPrimitiveSpineSummaryWithCertificate P C S q) :
    ¬ LocalGreenImpliesGlobalGreen :=
  lggr_refutes_local_green_implies_global_green

#print axioms PaperAE006.epk_spine_delta_descends_iff_congruent
#print axioms PaperAE006.epk_spine_delta_no_factor_of_not_congruent
#print axioms PaperAE006.epk_spine_delta_no_factor_of_zeroRel_ne
#print axioms PaperAE006.epk_spine_invariant_descends_iff_congruent
#print axioms PaperAE006.epk_spine_raw_phi_noncongruent_blocks_classifier
#print axioms PaperAE006.epk_spine_repair_boundary_repaired_iff
#print axioms PaperAE006.epk_spine_summary_terminal_status_matches_classifier
#print axioms PaperAE006.epk_spine_certificate_implies_exact
#print axioms PaperAE006.epk_spine_certificate_implies_admissible_witnessed_exact
#print axioms PaperAE006.epk_spine_not_ready_iff_repaired_without_certificate
#print axioms PaperAE006.epk_spine_ready_decomposes
#print axioms PaperAE006.missing_source_obstruction_blocks_epk_spine_ready
#print axioms PaperAE006.missing_new_carrier_blocks_epk_spine_ready
#print axioms PaperAE006.certified_epk_spine_does_not_force_global_green

end PaperAE006
