/-
  Native Omega HoTT encoding shell: PrimitiveDifference shape.
  RS (related): `omega_engine/crates/omega_engine_native_hott/src/primitive_difference.rs`
  Full axiomatics live under PrimitiveAxiomatics / shared_kernel.
  AuthorityEffect: None. Shape-only; no PROVED claim.
-/
namespace OmegaEngineNativeHott.PrimitiveDifference

/-- Opaque finite carrier id (domain-scoped; not a global totality). -/
structure CarrierId where
  name : String
  deriving DecidableEq, Repr

/-- Zero-relation witness flag (certificate shape only). -/
structure ZeroRelWitness where
  holds : Bool
  deriving DecidableEq, Repr

/-- Finite PD packet shell: domain size + zero-law flags (no quotient proof). -/
structure FinitePrimitiveDifferenceShell where
  carrier : CarrierId
  domainLen : Nat
  zeroReflexive : Bool
  zeroSymmetric : Bool
  zeroTransitive : Bool
  deriving Repr

def FinitePrimitiveDifferenceShell.zeroLawsOk (s : FinitePrimitiveDifferenceShell) : Bool :=
  s.zeroReflexive && s.zeroSymmetric && s.zeroTransitive

end OmegaEngineNativeHott.PrimitiveDifference
