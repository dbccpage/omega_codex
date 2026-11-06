# Authorization / Turing source lead — 2026-11-06

Separate research branch from the MSS-N tower/zeta recovery.

Source: `C:\.ana\coda_university\authorization_an_incompleteness_theory`.
Preserved 11 Lean files and 6 contextual documents (142,812 bytes), with exact
local source paths and SHA-256 hashes in the
[manifest](../recovered_sources/2026-11-06-authorization-incompleteness/manifest.json).
All 17 copies were compared byte-for-byte. These are local snapshots; a source
revision for the whole snapshot was not established. No Lean build was run.

## Existing route and its boundaries

1. **Primitive Difference quotient → report obstruction.**
   `primitive_difference_p0_bridge.lean` imports `J011_minimal_publication`
   and specializes the report-factorization argument to `pdProj P` and
   `ZeroRel P`. Validity is explicitly supplied, not derived from Primitive
   Difference. The external J011 module is not included in this small recovery.
2. **Report obstruction → authorization limitation.**
   `authorization_incompleteness_core.lean:46` proves that a report fiber
   containing two different validity values prevents any report-only function
   from returning the correct validity for every proposal. This is the same
   factorization argument already used by projection obstruction, specialized
   to authorization. Its general theorem is not restricted to finite carriers;
   its concrete Packet/Bool/Unit examples are finite.
3. **Direct machine operations.**
   `direct_turing_machine_models.lean` supplies a two-symbol alphabet, integer
   tape positions, natural-number control states, finite ordered rule lists,
   a designated halt state, left-biased rule lookup and fuel-bounded execution.
   It proves specific execution and halt facts. These structures are admitted
   here, not recovered from Primitive Difference by this module.
4. **Machine token grammar.**
   `direct_turing_machine_token_code_models.lean` proves decoder-after-encoder
   round trips for the supplied finite List Nat grammar and rejection of named
   malformed codes. This does not supply universality or arbitrary-input
   execution correspondence.
5. **Undecidability → authorization, conditionally.**
   `global_computability_lift_models.lean:79` takes a validity-preserving
   reduction, closure of the allowed procedure classes under precomposition,
   and a source NoTotalDecider premise. It transports that premise to proposal
   validity. It does not itself prove the source undecidability or instantiate
   computability.
6. **Conditional terminal boundary.**
   `terminal_authorization_boundary_models.lean` extracts an acceptance bit.
   Under the supplied no-decider and allowed-class assumptions, acceptance
   soundness, rejection soundness and absence of unresolved results cannot
   all hold. Its Boolean example explicitly permits closed sound local
   terminalization when the no-decider assumption does not apply.

## Concrete open bridge in this snapshot

The README and ledger stop at DTM1. The August 21 DTM2 support packet is
explicitly an implementation plan targeting v0.14, with base revision
`bcf932a5a1a636f687cbdd931c46d1084d5c61cb`. It proposes
`direct_turing_machine_input_execution_models.lean`, an initial-input grammar
and encoded-request execution agreement. That named module is absent from
the supplied directory. This identifies a search lead for a later revision;
it does not prove the work was never completed elsewhere.

Global carrier admission, universality, an effective reduction and the local
Rice/Goedel formalizations remain open in the inspected ledger. Existing
historical build/axiom reports were read as source claims, not rerun results.

## Review scope

Read the README, formal README, relevant ledger entries, source-map excerpts,
the information-core and reduction proofs, terminal-boundary proofs, the
direct-machine carrier definitions, quotient-bridge statements/proof, and
DTM2 proposal. Other preserved Lean files were inventoried, not given a full
proof-level audit in this pass. No new reconstruction, tests, theorem claims,
commits or remote changes were introduced.
