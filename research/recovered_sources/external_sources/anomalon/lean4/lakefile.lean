import Lake
open Lake DSL

package «mssn_sn_tower» where
  version := v!"0.1.0"

@[default_target]
lean_lib «MssnSnTower» where
  srcDir := "."
  roots := #[
    `PrimitiveDifference,
    `SnTower,
    `SLevel,
    `RuntimeLimits,
    `TowerZeta,
    `TriggerNotLicense,
    `TypedPacketShadow,
    `ShadowBoundary,
    `ShadowFactorization,
    `LiftPatchSemantics,
    `Expressivity,
    `ExpressivityNorm,
    `GrammarCeiling,
    `GrammarDepthCeiling,
    `SymbolGame,
    `ConfluenceFlip,
    `LGGR1,
    `LGGR2,
    `LGGR3,
    `Master,
    `Level17HodgeDecomposition,
    `Level18ZeroFloatLaw,
    `TokenFrontier,
    `AntimorphicInvolution,
    `Demo3ProtocolInvariants,
    `NormalFormsCore,
    `ExactRat
  ]

lean_lib «QmCarrierTests» where
  srcDir := "quantum_mechanics"
  roots := #[
    `DerivationDagQMClosure,
    `C750Definitions,
    `C750Reduction,
    `C750Purity
  ]

@[default_target]
lean_lib «LevelEngine» where
  srcDir := "research_programs/level_engine"
  roots := #[
    `AnswerKeeping,
    `AssociatorTables,
    `BoundAxioms,
    `BudgetedReleases,
    `ClassOperations,
    `ClosedFaces,
    `CommutingChecks,
    `ConfirmedRuns,
    `CycleWords,
    `DistanceForm,
    `DualEndpoints,
    `FaceProducts,
    `FarBlind,
    `FilteredPages,
    `FlowCertificate,
    `ForcedDifferences,
    `HingeDeficits,
    `IsolatedRoots,
    `JointPayoffs,
    `JointRank,
    `LoopProducts,
    `MirrorPairs,
    `NamedFrames,
    `OrderedLog,
    `OrderedSplits,
    `OutwardBounds,
    `OverlapChoices,
    `PatchedViews,
    `RatedLimits,
    `RefinedSums,
    `ReindexedFibres,
    `RimCochains,
    `SameBackground,
    `ScaleSteps,
    `ScopeFence,
    `SideReduction,
    `SignedCells,
    `SignedTotals,
    `SizeKeeping,
    `SplitWeights,
    `SquareOne,
    `StableProfiles,
    `StepWeights,
    `TablePolynomial,
    `TableRoots,
    `ThreeWaySplit,
    `TwoPartyBound,
    `UnitRows,
    `UseOnceTerms,
    `WalkTransport,
    `WeightedUpdate,
    `WitnessedTriples,
    `AxiomReport
  ]

@[default_target]
lean_lib «SimplexAutop» where
  srcDir := "simplex/autop"
  roots := #[
    `Syntax,
    `Semantics,
    `Kernel
  ]

@[default_target]
lean_lib «NormalFormsResearch» where
  srcDir := "research_programs/normal_forms"
  roots := #[
    `BQNF
  ]

lean_lib «WolandFormal» where
  srcDir := "research_programs/woland"
  roots := #[`GateIdeal, `ProtectedRewrite, `PlanarTree, `SlotSelection, `ExplicitInputAction,
    `ExplicitGraftLaws, `SymmetricGateQuotient, `ConcretePromptRewrite, `ConcreteHintDPO,
    `NativeModelBridge]

lean_lib «WdpReasoning» where
  srcDir := "research_programs/wdp_reasoning"
  roots := #[`WitnessedReasoning, `ReasoningAxioms, `ExecutableReasoning, `RefinementAxioms]
