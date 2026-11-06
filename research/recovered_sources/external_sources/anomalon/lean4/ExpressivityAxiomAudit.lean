import Family
/-!
S8: axiom audit script.

`lake env lean --run 008_engine_runtime/007_the_symbol_game/omega_symbol_game/tests/expressivity_axiom_audit.lean` prints the
axioms `expressivity_norm_le_grammar_ceiling` depends on. The audited
allow-list is `propext`, `Classical.choice`, `Quot.sound`, plus any names
already present in
`003_quantum_foundations/p03_dynamics_schrodinger/qm_030_finite_weighted_transport_calculus/OmegaCosmology/Primitives/SemiringTransportAxiomAudit.lean`.

The Rust S8 AT (`expressivity_axiom_audit.rs`) consumes this output and
fails if any unaudited token appears.
-/

#print axioms OmegaCosmology.SymbolGame.expressivity_norm_le_grammar_ceiling

def main : IO Unit := pure ()
