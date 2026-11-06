/-
Paper 025: diagonal shortcuts refuse clean boundary factorization.

At a representation boundary, clean EPK composition needs a declared one-hit
cut and declared left/right segment factors.  Treating an undecomposed diagonal
trace as if it were a clean boundary factorization is refused.
-/

namespace PaperAE006

inductive BoundaryFactorizationStatus where
  | cleanFactorization
  | factorizationRefused
  deriving DecidableEq

structure BoundaryFactorizationPacket where
  oneHitCutDeclared : Bool
  leftSegmentDeclared : Bool
  rightSegmentDeclared : Bool
  diagonalShortcutUsed : Bool

def boundaryFactorizationStatus (p : BoundaryFactorizationPacket) :
    BoundaryFactorizationStatus :=
  if p.oneHitCutDeclared &&
      p.leftSegmentDeclared &&
      p.rightSegmentDeclared &&
      !p.diagonalShortcutUsed then
    BoundaryFactorizationStatus.cleanFactorization
  else
    BoundaryFactorizationStatus.factorizationRefused

def HasCleanBoundaryFactorization
    (p : BoundaryFactorizationPacket) : Prop :=
  p.oneHitCutDeclared = true ∧
    p.leftSegmentDeclared = true ∧
    p.rightSegmentDeclared = true ∧
    p.diagonalShortcutUsed = false

def MissingBoundaryFactorizationData
    (p : BoundaryFactorizationPacket) : Prop :=
  p.oneHitCutDeclared = false ∨
    p.leftSegmentDeclared = false ∨
    p.rightSegmentDeclared = false

theorem clean_boundary_factorization_requires_declared_cut
    (p : BoundaryFactorizationPacket) :
    boundaryFactorizationStatus p =
        BoundaryFactorizationStatus.cleanFactorization →
      HasCleanBoundaryFactorization p := by
  cases p with
  | mk oneHit left right diagonal =>
      cases oneHit <;> cases left <;> cases right <;>
        cases diagonal <;> intro hClean
      all_goals try cases hClean
      all_goals exact ⟨rfl, rfl, rfl, rfl⟩

theorem missing_factorization_data_blocks_clean_boundary
    (p : BoundaryFactorizationPacket) :
    MissingBoundaryFactorizationData p →
      boundaryFactorizationStatus p ≠
        BoundaryFactorizationStatus.cleanFactorization := by
  intro hMissing hClean
  have hFactor :=
    clean_boundary_factorization_requires_declared_cut p hClean
  cases hMissing with
  | inl hOneHit =>
      have hOneHitReady := hFactor.1
      rw [hOneHit] at hOneHitReady
      cases hOneHitReady
  | inr hRest =>
      cases hRest with
      | inl hLeft =>
          have hLeftReady := hFactor.2.1
          rw [hLeft] at hLeftReady
          cases hLeftReady
      | inr hRight =>
          have hRightReady := hFactor.2.2.1
          rw [hRight] at hRightReady
          cases hRightReady

theorem missing_factorization_data_refuses_clean_boundary
    (p : BoundaryFactorizationPacket) :
    MissingBoundaryFactorizationData p →
      boundaryFactorizationStatus p =
        BoundaryFactorizationStatus.factorizationRefused := by
  intro hMissing
  have hNotClean :
      boundaryFactorizationStatus p ≠
        BoundaryFactorizationStatus.cleanFactorization :=
    missing_factorization_data_blocks_clean_boundary p hMissing
  cases hStatus : boundaryFactorizationStatus p with
  | cleanFactorization =>
      exact False.elim (hNotClean hStatus)
  | factorizationRefused =>
      rfl

theorem diagonal_shortcut_blocks_clean_boundary_factorization
    (p : BoundaryFactorizationPacket)
    (hDiagonal : p.diagonalShortcutUsed = true) :
    boundaryFactorizationStatus p ≠
      BoundaryFactorizationStatus.cleanFactorization := by
  intro hClean
  have hFactor :=
    clean_boundary_factorization_requires_declared_cut p hClean
  have hNoDiagonal := hFactor.2.2.2
  rw [hDiagonal] at hNoDiagonal
  cases hNoDiagonal

theorem diagonal_shortcut_refuses_clean_boundary_factorization
    (p : BoundaryFactorizationPacket)
    (hDiagonal : p.diagonalShortcutUsed = true) :
    boundaryFactorizationStatus p =
      BoundaryFactorizationStatus.factorizationRefused := by
  have hNotClean :=
    diagonal_shortcut_blocks_clean_boundary_factorization p hDiagonal
  cases hStatus : boundaryFactorizationStatus p with
  | cleanFactorization =>
      exact False.elim (hNotClean hStatus)
  | factorizationRefused =>
      rfl

theorem undeclared_diagonal_trace_refuses_clean_factorization :
    boundaryFactorizationStatus
      { oneHitCutDeclared := false,
        leftSegmentDeclared := false,
        rightSegmentDeclared := false,
        diagonalShortcutUsed := true } =
      BoundaryFactorizationStatus.factorizationRefused := by
  rfl

#print axioms PaperAE006.clean_boundary_factorization_requires_declared_cut
#print axioms PaperAE006.missing_factorization_data_blocks_clean_boundary
#print axioms PaperAE006.missing_factorization_data_refuses_clean_boundary
#print axioms PaperAE006.diagonal_shortcut_blocks_clean_boundary_factorization
#print axioms PaperAE006.diagonal_shortcut_refuses_clean_boundary_factorization
#print axioms PaperAE006.undeclared_diagonal_trace_refuses_clean_factorization

end PaperAE006
