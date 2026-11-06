"""
Dual-Adversary Critiques and Missing Test Prescriptions for DER-57 through DER-75.
Witnessed Difference Programme (WDP) Layer 6 derivation nodes.
Strict claim hygiene: zero forbidden words.
"""

ADV1_WDP_CRITIQUES = {
    "DER-57": {
        "soundness": (
            "Verified across 29 Lean theorems in GuardedScheduleTopology.lean using core axioms propext and Quot.sound. "
            "Formalizes task start/finish scheduling and prefix-safety under finite capacity. "
            "Vulnerability: Operates on simplified boolean words (List Bool) where false is start and true is finish; "
            "it does not model concurrent task execution, overlapping memory access, or dynamic priority preemption."
        ),
        "prose_vs_code": (
            "Prose characterizes this as an exact 5-gate admission-and-view guard topology for full schedule complexes. "
            "Lean formalization models a single integer supply counter tracking net start/finish events in a sequential trace."
        ),
        "boundaries_assumptions": (
            "Boundary conditions: Supply = 0 (refuses start); empty trace; maximal capacity. "
            "Unstated assumption: tasks cannot fail or abort abnormally; every started task emits a finish event."
        ),
        "missing_unit": (
            "Unit: (1) Lean theorem formalizing task abort/cancellation semantics and capacity reclamation; "
            "(2) Python unit test verifying 5-gate transition table against non-boolean task payloads."
        ),
        "missing_integration": (
            "Integration: Seam test between DER-57 schedule safety and DER-72 WDP Batch 10 transport composition."
        ),
        "missing_e2e": (
            "End-to-End: Replay test verifying that capacity refusal halts execution when supply is exhausted across multi-phase schedule executions."
        ),
        "missing_mutation": (
            "Mutation: Invert capacity decrement on task start (e.g. supply + 1 instead of supply - 1); verify that prefix-safety validation fails closed."
        ),
    },
    "DER-58": {
        "soundness": (
            "Verified across 18 Lean theorems in FoundationalBridges.lean with propext and Quot.sound. "
            "Formalizes distinction between empty inscription and nested empty inscription (markA vs markB) and height bounds. "
            "Vulnerability: Inscription distinction is established for exactly two syntactic constructors (empty vs nest empty); "
            "it does not establish distinction over arbitrary inductive terms without external syntactic decidability."
        ),
        "prose_vs_code": (
            "Prose presents substrate certificates as establishing endogenous orbit-weight forcing across arbitrary carriers. "
            "Lean code establishes inequality for two fixed inscriptions and finite tree height properties."
        ),
        "boundaries_assumptions": (
            "Boundary conditions: Tree height 0; two-element mark alphabet. "
            "Unstated assumption: mark identity is syntactically decidable via pattern matching on inductive constructors."
        ),
        "missing_unit": (
            "Unit: (1) Lean theorem generalizing mark separation to arbitrary nested terms under constructor injectivity; "
            "(2) Python unit test testing orbit weight conservation under group actions on finite carriers."
        ),
        "missing_integration": (
            "Integration: Seam test linking DER-58 height bounds with DER-67 dyadic refinement towers."
        ),
        "missing_e2e": (
            "End-to-End: Derivation test tracking substrate certificate issuance from initial mark to OWE-05/OWE-06 bridge targets."
        ),
        "missing_mutation": (
            "Mutation: Force markA = markB in mock evaluator; verify that substrate certificate generation immediately refuses."
        ),
    },
    "DER-59": {
        "soundness": (
            "Verified across 27 Lean theorems in ObserverAdapterCompleteness.lean. "
            "Establishes that sectioned sort maps have constructive sections and that fiber-constant predicates descend uniquely. "
            "Vulnerability: Requires the existence of a global constructive section (splitting); "
            "it does not cover observers where sections are only locally defined or obstructed by topological torsion."
        ),
        "prose_vs_code": (
            "Prose asserts observer adapter completeness across broad observation domains. "
            "Lean formalization assumes an explicit retraction map (section) is provided as a hypothesis."
        ),
        "boundaries_assumptions": (
            "Boundary conditions: Identity observer; empty fibers; constant functions. "
            "Unstated assumption: target observation sorts have decidable equality."
        ),
        "missing_unit": (
            "Unit: (1) Lean theorem showing obstruction to factorization when fiber-constancy fails on a 2-point fiber; "
            "(2) Python unit test testing observer adapter tables on non-surjective mappings."
        ),
        "missing_integration": (
            "Integration: Seam test connecting DER-59 readout factorization to DER-66 finite constraint representations."
        ),
        "missing_e2e": (
            "End-to-End: Multi-observer composition test verifying kernel inclusion preservation across cascaded adapters."
        ),
        "missing_mutation": (
            "Mutation: Mutate section map to return an out-of-fiber element; verify that unique factorization tests fail closed."
        ),
    },
    "DER-60": {
        "soundness": (
            "Verified across 54 Lean theorems in AdditiveTensorCompletion.lean. "
            "Constructs free commutative monoid over generators, quotiented by interchange laws, and signed Grothendieck completion. "
            "Vulnerability: Cancellativity is verified for free formal sums; "
            "it does not establish Grothendieck completion for non-cancellative monoids (which would collapse the group structure)."
        ),
        "prose_vs_code": (
            "Prose discusses independent-subsystem tensor costs in quantum-like systems. "
            "Lean code models formal lists of generators with quotiented permutation equivalence and integer pairing."
        ),
        "boundaries_assumptions": (
            "Boundary conditions: Empty tensor product (unit); single generator carrier; zero cost. "
            "Unstated assumption: generator type X has decidable equality."
        ),
        "missing_unit": (
            "Unit: (1) Lean theorem showing collapse of the Grothendieck completion under non-cancellative addition; "
            "(2) Python unit test verifying tensor cost additivity on multi-generator combinations."
        ),
        "missing_integration": (
            "Integration: Seam test between DER-60 Grothendieck completion and DER-61 dagger involution."
        ),
        "missing_e2e": (
            "End-to-End: Tensor factorization test checking that composite system costs equal sum of subsystem costs across update chains."
        ),
        "missing_mutation": (
            "Mutation: Mutate list equivalence quotient by removing the symmetry rule; verify that monoid completion validation fails."
        ),
    },
    "DER-61": {
        "soundness": (
            "Verified across 16 Lean theorems in DaggerObserverPairing.lean. "
            "Formalizes involutive dagger operation on signed carrier and positive-semidefinite bilinear pairing into 2D integer coordinates. "
            "Vulnerability: Positive-semidefiniteness is established over integer coordinates (Z x Z) using quadratic forms; "
            "it does not establish C*-algebraic positivity or continuous Hilbert space spectral decompositions."
        ),
        "prose_vs_code": (
            "Prose characterizes this as adjoint involution and conjugate bilinear symmetry for relational observers. "
            "Lean code formalizes an involution on discrete basis vectors with integer cross-multiplication."
        ),
        "boundaries_assumptions": (
            "Boundary conditions: Self-adjoint generators; zero vector; orthogonal basis pairs. "
            "Unstated assumption: involution is an automorphism of the underlying free additive carrier."
        ),
        "missing_unit": (
            "Unit: (1) Lean theorem showing that non-involutive maps violate dagger symmetry; "
            "(2) Python unit test evaluating positive-semidefinite matrix representations for small generators."
        ),
        "missing_integration": (
            "Integration: Seam test between DER-61 dagger pairing and DER-62 Gaussian integer quantum readout."
        ),
        "missing_e2e": (
            "End-to-End: Verification that composite adjoint operations satisfy (A . B)^dagger = B^dagger . A^dagger across multi-stage observer transformations."
        ),
        "missing_mutation": (
            "Mutation: Alter dagger involution to not invert composition order; verify that adjoint tests fail closed."
        ),
    },
    "DER-62": {
        "soundness": (
            "Verified across 24 Lean theorems in GaussianIntQuantumReadout.lean. "
            "Formalizes Gaussian integers Z[i], 2-point Parseval identity, 2-adic valuation obstruction preventing unnormalized unitary Hadamard in Z[i], 3 mutually unbiased bases for a qubit toy model, and discrete Noether conservation. "
            "Vulnerability: Operates on Gaussian integers Z[i] without square roots; Hadamard is unnormalized (factor of 2), and MUB overlap is scaled by 2 rather than 1/sqrt(2)."
        ),
        "prose_vs_code": (
            "Prose claims discharge of quantum readout, Bell entanglement, and Landauer erasure. "
            "Lean formalization establishes arithmetic identities over Z[i] integer components with cleared denominators."
        ),
        "boundaries_assumptions": (
            "Boundary conditions: 2D state space (qubit toy model); integer division roundoff; 3 discrete bases. "
            "Unstated assumption: unnormalized state vectors represent physical probability distributions through integer scaling."
        ),
        "missing_unit": (
            "Unit: (1) Lean theorem showing that normalization in Z[i] cannot be constructed for the vector (1, 1); "
            "(2) Python unit test testing discrete Bell inequality violation thresholds in cleared-denominator arithmetic."
        ),
        "missing_integration": (
            "Integration: Seam test between DER-62 Gaussian readout and DER-63 complex tensor balancing."
        ),
        "missing_e2e": (
            "End-to-End: Qubit transformation test executing Pauli X, Y, Z rotations on Gaussian integer state vectors."
        ),
        "missing_mutation": (
            "Mutation: Perturb the imaginary unit square i^2 = -1 to i^2 = +1 (split-complex); verify that Parseval and Hadamard obstruction tests fail closed."
        ),
    },
    "DER-63": {
        "soundness": (
            "Verified across 14 Lean theorems in ComplexTensorBalancing.lean. "
            "Covers two-component and four-component integer coefficient identities under Z_4 cyclic phase action. "
            "Vulnerability: Restricts phase rotations to the discrete fourth roots of unity {1, i, -1, -i}; "
            "continuous U(1) phase invariance is unaddressed."
        ),
        "prose_vs_code": (
            "Prose describes complex tensor balancing and broad phase equivalence. "
            "Lean code establishes finite cyclic group Z_4 action on 4-tuples of integers with integer division by 2."
        ),
        "boundaries_assumptions": (
            "Boundary conditions: Zero vector; 4-element phase orbit; division by 2 exactness. "
            "Unstated assumption: integer components are even whenever division by 2 is performed."
        ),
        "missing_unit": (
            "Unit: (1) Lean theorem showing failure of division by 2 on odd integer coordinates; "
            "(2) Python unit test testing Z_4 orbit invariants on randomly generated integer 4-tuples."
        ),
        "missing_integration": (
            "Integration: Seam test between DER-63 phase action and DER-62 Gaussian quantum readout."
        ),
        "missing_e2e": (
            "End-to-End: Cyclic phase invariance test asserting that four successive phase shifts return to the initial state vector."
        ),
        "missing_mutation": (
            "Mutation: Mutate fourth-root phase shift by omitting the negative sign on i^2; verify phase equivalence tests fail."
        ),
    },
    "DER-64": {
        "soundness": (
            "Verified across 19 Lean theorems in MarkedGaugeTransport.lean. "
            "Analyzes gauge transport along rooted spanning trees and fundamental cycle holonomies on Source-25 graphs. "
            "Vulnerability: Tree transport is path-independent because spanning trees contain zero cycles; "
            "holonomy invariance is established relative to fixed cycle bases rather than dynamic network re-topologization."
        ),
        "prose_vs_code": (
            "Prose claims gauge transport and tree defect invariance across general graphs. "
            "Lean formalization uses fixed cyclic triple renamings on natural number lookups from Source-25."
        ),
        "boundaries_assumptions": (
            "Boundary conditions: Trivial tree (single node); zero gauge shift; acyclic subgraphs. "
            "Unstated assumption: spanning trees are fixed and statically partitioned."
        ),
        "missing_unit": (
            "Unit: (1) Lean theorem showing non-trivial holonomy on non-tree chord edges; "
            "(2) Python unit test calculating cycle holonomies on non-planar graph benchmarks."
        ),
        "missing_integration": (
            "Integration: Seam test between DER-64 gauge transport and DER-75 terminal capstone replay."
        ),
        "missing_e2e": (
            "End-to-End: Gauge transformation invariance test verifying that global gauge shifts leave physical holonomies unchanged across the graph."
        ),
        "missing_mutation": (
            "Mutation: Invert sign of gauge connection on tree edges; verify tree defect invariance checks detect failure."
        ),
    },
    "DER-65": {
        "soundness": (
            "Verified across 18 Lean theorems in MeronThermoLimitConstants.lean. "
            "Establishes integer identities for cleared-denominator Meron actions and plaquette frustration lower bounds. "
            "Vulnerability: Meron configurations are modeled via discrete rational constants with cleared denominators; "
            "it does not evaluate the thermodynamic limit N -> infinity via continuous path integrals."
        ),
        "prose_vs_code": (
            "Prose speaks of thermodynamic scaling bounds and Meron action limits in field theory. "
            "Lean code establishes inequalities between fixed integer constants and rational multipliers."
        ),
        "boundaries_assumptions": (
            "Boundary conditions: Single plaquette; zero field frustration; minimal lattice volume. "
            "Unstated assumption: thermodynamic scaling coefficients can be bounded uniformly by rational numbers."
        ),
        "missing_unit": (
            "Unit: (1) Lean theorem showing stability of the frustration bound under localized perturbation; "
            "(2) Python unit test testing plaquette action sums on N x N 2D lattices."
        ),
        "missing_integration": (
            "Integration: Seam test between DER-65 Meron constants and DER-53 discrete Gauss-Bonnet curvature."
        ),
        "missing_e2e": (
            "End-to-End: Thermodynamic scaling simulation measuring total action divergence as lattice size scales up."
        ),
        "missing_mutation": (
            "Mutation: Mutate plaquette frustration lower bound constant to exceed maximum action; verify validation fails closed."
        ),
    },
    "DER-66": {
        "soundness": (
            "Verified across 26 Lean theorems in FiniteConstraintRepresentation.lean. "
            "Formalizes constructive sheaf gluing for constraints over explicitly covered finite scopes with row tables. "
            "Vulnerability: Sheaf condition is verified for finite discrete covers where overlap compatibility is decidable by exhaustive search; "
            "it does not extend to infinite open coverings or non-Hausdorff sites."
        ),
        "prose_vs_code": (
            "Prose claims canonical evaluation embedding and comprehensive constraint representation. "
            "Lean code models finite tables with list lookups and decidable row equality."
        ),
        "boundaries_assumptions": (
            "Boundary conditions: Empty cover; singleton scope; disjoint scopes. "
            "Unstated assumption: all constraint evaluations terminate in finite time."
        ),
        "missing_unit": (
            "Unit: (1) Lean theorem showing failure of gluing when pairwise compatibility holds on triple overlaps but fails on intersection; "
            "(2) Python unit test testing constraint satisfaction solver on SAT instances."
        ),
        "missing_integration": (
            "Integration: Seam test between DER-59 observer factorization and DER-66 canonical covers."
        ),
        "missing_e2e": (
            "End-to-End: Constraint verification test asserting that local solutions glue to a unique global assignment."
        ),
        "missing_mutation": (
            "Mutation: Corrupt overlap compatibility check by ignoring one boundary coordinate; verify gluing check fails."
        ),
    },
    "DER-67": {
        "soundness": (
            "Verified across 15 Lean theorems in DyadicPresentation.lean. "
            "Formalizes dyadic level orders (2^n), binary inclusion maps, and arithmetic residue pairing across refinement levels. "
            "Vulnerability: Operates with dyadic residue integers; "
            "it does not formalize 2-adic completions, Cantor space topology, or continuous projective limits."
        ),
        "prose_vs_code": (
            "Prose claims projective limits of refinement towers and compatible cochains. "
            "Lean code establishes integer inequalities and modulo arithmetic laws between levels n and n+1."
        ),
        "boundaries_assumptions": (
            "Boundary conditions: Level 0 (single point); level 1 (binary); level n -> infinity (unformalized). "
            "Unstated assumption: refinement steps are dyadic (branching factor 2)."
        ),
        "missing_unit": (
            "Unit: (1) Lean theorem showing injectivity of binary restriction fibers; "
            "(2) Python unit test testing dyadic tree traversal and bit-level arithmetic."
        ),
        "missing_integration": (
            "Integration: Seam test between DER-67 dyadic towers and OWE-10 open bridge obligation."
        ),
        "missing_e2e": (
            "End-to-End: Multi-level projective sequence test checking that restriction maps commute across level jumps (n -> n+2 vs n -> n+1 -> n+2)."
        ),
        "missing_mutation": (
            "Mutation: Mutate dyadic order formula 2^n to 2*n; verify that inclusion and order tests fail closed."
        ),
    },
    "DER-68": {
        "soundness": (
            "Verified across 10 Lean theorems in SelfReferenceBridges.lean. "
            "Formalizes self-reference bridges where reports factorize through presentation fibers without circular self-validation. "
            "Vulnerability: Avoids reflective paradoxes by staging report horizons through deferral; "
            "it does not formalize full reflective fixed-point combinators."
        ),
        "prose_vs_code": (
            "Prose describes self-reference bridges and linked-report factorizations. "
            "Lean code establishes that deterministic links imply fiber constancy on designated observation tables."
        ),
        "boundaries_assumptions": (
            "Boundary conditions: Trivial link (identity); undefined report; empty presentation fiber. "
            "Unstated assumption: evaluation horizons can be ordered to prevent cyclic dependency."
        ),
        "missing_unit": (
            "Unit: (1) Lean theorem showing that non-deferred self-reference causes ill-founded recursion; "
            "(2) Python unit test testing report cache invalidation on circular links."
        ),
        "missing_integration": (
            "Integration: Seam test between DER-68 linked reports and DER-69 functional classifications."
        ),
        "missing_e2e": (
            "End-to-End: Horizon evaluation test verifying that reports remain stable across cascading self-inspections."
        ),
        "missing_mutation": (
            "Mutation: Remove the deferral guard in the report evaluation loop; verify circularity detection raises exception."
        ),
    },
    "DER-69": {
        "soundness": (
            "Verified across 11 Lean theorems in FunctionalClassification.lean. "
            "Formalizes observer classification into linked, stable, and blind-spot states, showing that linked observers have no blind spots. "
            "Vulnerability: Blind-spot elimination is established relative to a declared finite set of presentation fibers; "
            "it does not establish zero blind spots against unanticipated external perturbations."
        ),
        "prose_vs_code": (
            "Prose claims zero-tolerance faithfulness and functional classification. "
            "Lean code defines three predicates and establishes implication lemmas between them."
        ),
        "boundaries_assumptions": (
            "Boundary conditions: All-blind observer (empty report); faithful observer (bijective); singleton state. "
            "Unstated assumption: observer classification is decidable for all declared predicates."
        ),
        "missing_unit": (
            "Unit: (1) Lean theorem showing that partial observers admit non-empty blind spots; "
            "(2) Python unit test classifying randomly generated observer tables into functional types."
        ),
        "missing_integration": (
            "Integration: Seam test between DER-68 self-reference and DER-69 blind-spot linkage."
        ),
        "missing_e2e": (
            "End-to-End: Observer robustness test measuring report stability under noise injection into blind-spot fibers."
        ),
        "missing_mutation": (
            "Mutation: Invert the blind-spot condition (e.g. blind_spot = true when report is faithful); verify classification tests fail."
        ),
    },
    "DER-70": {
        "soundness": (
            "Verified across 12 Lean theorems in AdmissionCount.lean. "
            "Formalizes monotone accumulation of admission mass and potential bounds across step histories for Source-16 states. "
            "Vulnerability: Operates on discrete integer potential functions (n, sum r, sum s, sum leftovers); "
            "it does not model non-monotone budget replenishment or continuous resource dissipation."
        ),
        "prose_vs_code": (
            "Prose claims substrate budget accounting and conservation identities. "
            "Lean code establishes that each of the 8 enabled transitions monotonically increments mass or preserves potential."
        ),
        "boundaries_assumptions": (
            "Boundary conditions: Initial empty state (zero mass); single step; maximal budget bound. "
            "Unstated assumption: admission costs cannot be negative or retroactive."
        ),
        "missing_unit": (
            "Unit: (1) Lean theorem showing that non-enabled transitions violate monotone ledger accumulation; "
            "(2) Python unit test testing mass and potential updates across 10,000 random transition sequences."
        ),
        "missing_integration": (
            "Integration: Seam test between DER-70 budget accounting and DER-45 primitive context floor."
        ),
        "missing_e2e": (
            "End-to-End: Budget exhaustion test verifying that execution terminates when cumulative admissions hit declared upper bound."
        ),
        "missing_mutation": (
            "Mutation: Mutate step mass update from mass + 1 to mass - 1; verify monotonicity assertions trigger immediately."
        ),
    },
    "DER-71": {
        "soundness": (
            "Verified across 10 Lean theorems in BalancePreservingEdits.lean. "
            "Establishes integer cycle laws and coboundary perturbation invariance for Source-25 directed tetrahedra. "
            "Vulnerability: Scoped to local tetrahedral edits on fixed graph topologies; "
            "it does not establish cycle space invariance under topological surgery (edge contraction or face splitting)."
        ),
        "prose_vs_code": (
            "Prose characterizes this as balance-preserving cochain edits and cycle space invariance. "
            "Lean code establishes that adding a gradient cochain preserves zero-sum cycle values on a fixed 4-vertex tetrahedron."
        ),
        "boundaries_assumptions": (
            "Boundary conditions: Trivial cycle (length 0); zero edit; orthogonal cycles. "
            "Unstated assumption: edge orientations are anti-symmetric under reversal."
        ),
        "missing_unit": (
            "Unit: (1) Lean theorem showing that non-gradient edits alter cycle sums; "
            "(2) Python unit test testing cycle conservation under random integer gradient perturbations."
        ),
        "missing_integration": (
            "Integration: Seam test between DER-71 balance preservation and DER-47 cochain transport."
        ),
        "missing_e2e": (
            "End-to-End: Network circulation test verifying that balanced cochains remain divergence-free under local updates."
        ),
        "missing_mutation": (
            "Mutation: Add a non-zero constant to a single edge in a closed cycle; verify cycle balance assertions detect the deficit."
        ),
    },
    "DER-72": {
        "soundness": (
            "Verified across 18 Lean theorems in WdpBatch10.lean. "
            "Synthesizes L1-to-L2 complex field embeddings, rational norm multiplicativity (gratNormSq), and multi-step transport composition. "
            "Vulnerability: Complex numbers are constructed as rational pairs Q x Q (gratMul), avoiding real analysis; "
            "topological completeness and convergence are absent."
        ),
        "prose_vs_code": (
            "Prose presents Batch 10 as canonical transport synthesis. "
            "Lean formalization establishes algebraic identities for rational complex arithmetic and quotient coherence lemmas."
        ),
        "boundaries_assumptions": (
            "Boundary conditions: Zero norm vector; identity transport; 1-step vs n-step chains. "
            "Unstated assumption: field characteristic is zero (Q arithmetic)."
        ),
        "missing_unit": (
            "Unit: (1) Lean theorem showing non-degeneracy of the rational complex norm; "
            "(2) Python unit test testing multi-step transport compositions against random rational coordinates."
        ),
        "missing_integration": (
            "Integration: Seam test connecting DER-72 transport composition to DER-73 window synthesis."
        ),
        "missing_e2e": (
            "End-to-End: Transport test asserting quotient coherence holds after 50 successive composition steps."
        ),
        "missing_mutation": (
            "Mutation: Mutate gratNormSq (x, y) = x^2 + y^2 to x^2 - y^2 (hyperbolic norm); verify norm multiplicativity checks fail."
        ),
    },
    "DER-73": {
        "soundness": (
            "Verified across 12 Lean theorems in WdpBatch11.lean. "
            "Synthesizes Genesis succession element counts, admitting count inequalities (admittingCount <= everyCount), and windowed obstruction bounds. "
            "Vulnerability: Windowed obstruction bounds are derived on 3-window overlap configurations; "
            "it does not establish obstruction scaling on arbitrarily large window covers."
        ),
        "prose_vs_code": (
            "Prose describes Batch 11 as synthesizing windowed obstruction bounds and local-global gluing certificates. "
            "Lean code establishes arithmetic inequalities on event count histories and finite window overlaps."
        ),
        "boundaries_assumptions": (
            "Boundary conditions: Zero change events; single window (zero obstruction); 3-window maximal frustration. "
            "Unstated assumption: window partitions have finite overlap intersections."
        ),
        "missing_unit": (
            "Unit: (1) Lean theorem showing strict positivity of obstruction on frustrated 3-window systems; "
            "(2) Python unit test testing succession counts against simulated execution traces."
        ),
        "missing_integration": (
            "Integration: Seam test between DER-73 window bounds and DER-74 higher cohomology synthesis."
        ),
        "missing_e2e": (
            "End-to-End: Local-global gluing simulation verifying that certified windows assemble into a consistent global state."
        ),
        "missing_mutation": (
            "Mutation: Flip inequality admittingCount <= everyCount to >=; verify that theorem validation rejects the mutation."
        ),
    },
    "DER-74": {
        "soundness": (
            "Verified across 18 Lean theorems in WdpBatch12.lean. "
            "Synthesizes Genesis engine class 144 capacities, rule observation counts, simplicial Bianchi identities (d^2 = 0), and curvature-holonomy coupling. "
            "Vulnerability: Operates on combinatorial 2-complexes and tetrahedral boundary operators; "
            "continuous differential forms, Riemann curvature tensors, and smooth manifolds are not modeled."
        ),
        "prose_vs_code": (
            "Prose asserts higher cohomology and curvature synthesis. "
            "Lean code establishes combinatorial identities over finite integer vectors and table lookups for 144 engine configurations."
        ),
        "boundaries_assumptions": (
            "Boundary conditions: Trivial coboundary; zero curvature; flat tetrahedral complex. "
            "Unstated assumption: simplicial orientations satisfy standard algebraic topology boundary conventions."
        ),
        "missing_unit": (
            "Unit: (1) Lean theorem showing that non-zero curvature prevents exact coboundary trivialization; "
            "(2) Python unit test testing the d^2 = 0 nilpotency condition on arbitrary simplicial meshes."
        ),
        "missing_integration": (
            "Integration: Seam test between DER-74 curvature coupling and DER-75 terminal capstone synthesis."
        ),
        "missing_e2e": (
            "End-to-End: Curvature conservation test asserting that total simplicial Bianchi sums vanish over closed 3-surfaces."
        ),
        "missing_mutation": (
            "Mutation: Invert sign of one face in the tetrahedral boundary operator; verify that d^2 != 0 triggers test failure."
        ),
    },
    "DER-75": {
        "soundness": (
            "Verified across 13 Lean theorems in WdpBatch13.lean. "
            "Formalizes institutional boundary authorization firewalls (RespectsInstitutionalBoundary), guarded software projections, and end-to-end replay closure for the Witnessed Difference Programme. "
            "Vulnerability: Operates as an authorization gate between software-only packets and institutional packets based on discrete tag bits; "
            "it does not model side-channel leaks, cryptographic vulnerabilities, or adversarial memory tampering."
        ),
        "prose_vs_code": (
            "Prose proclaims terminal capstone synthesis and end-to-end replay closure. "
            "Lean code establishes tag-filtering lemmas and predicate preservation across an abstract projection map."
        ),
        "boundaries_assumptions": (
            "Boundary conditions: All-software packet stream; all-institutional stream; empty packet. "
            "Unstated assumption: packet tags cannot be forged or mutated in transit between execution units."
        ),
        "missing_unit": (
            "Unit: (1) Lean theorem showing that untagged institutional packets are rejected by the firewall; "
            "(2) Python unit test testing boundary enforcement against malformed packet streams."
        ),
        "missing_integration": (
            "Integration: Seam test between DER-74 higher cohomology outputs and DER-75 capstone closure."
        ),
        "missing_e2e": (
            "End-to-End: Full-chain replay test from initial mark through all 75 derivation nodes to DER-75 terminal verification."
        ),
        "missing_mutation": (
            "Mutation: Disable packet tag inspection in firewall filter; verify security boundary tests fail closed."
        ),
    },
}

ADV2_WDP_NODES = {
    "DER-57": {
        "id": "DER-57",
        "code": "WDP-GUARDED-SCHEDULE-TOPOLOGY-AND-ONE-BIT-RETENTION",
        "layer": "6_WDP_CANONICAL_REPLAY_AND_BRIDGE",
        "bucket": "DERIVED",
        "status_detail": "LEAN4_AND_PYTHON_VERIFIED",
        "title": "Exact 5-Gate Guarded Schedule Topology, Validated One-Bit Retention Automaton, and Positive-Cost Commutation Limits",
        "current_coverage": {
            "lean_theorems_count": 29,
            "python_checks": [
                "scripts/check_primitive_difference.py",
                "scripts/check_admission_replay.py"
            ],
            "standalone_python_mechanization": False,
            "meta_validation_only": True,
            "incoming_edge_count": 4,
            "outgoing_edge_count": 3
        },
        "missing_unit_tests": [
            "Dedicated standalone Python unit tests mechanizing the 2-state retention automaton and 5-gate guard topology.",
            "Boundary unit tests evaluating schedule prefix safety when initial capacity supply is zero.",
            "Invariance unit tests checking task permutation equivalence against Lean theorem startsFirst_perm."
        ],
        "missing_integration_tests": [
            "Upstream integration tests verifying event streams from DER-33 and DER-42 conform to guard capacity preconditions.",
            "Downstream integration tests confirming that OWE-12 receives verified positive-cost commutation boundaries.",
            "Admission integration tests verifying that S0, S4, and S5 admissions are enforced across schedule execution."
        ],
        "missing_end_to_end_tests": [
            "Full schedule execution end-to-end tests evaluating 5-gate transitions across repeated update cycles.",
            "Capacity exhaustion end-to-end tests confirming that start events are refused when supply reaches zero.",
            "Cross-facet correspondence tests verifying Lean theorem bounds match Python execution counters."
        ],
        "missing_mutation_tests": [
            "Capacity decrement mutation tests replacing supply - 1 with supply + 1 in task start handler.",
            "Guard comparison mutation tests changing starts <= supply to starts < supply.",
            "Event reordering mutation tests checking that unsorted task traces trigger prefix-safety violations."
        ]
    },
    "DER-58": {
        "id": "DER-58",
        "code": "WDP-FOUNDATIONAL-BRIDGES-AND-SUBSTRATE-CERTIFICATES",
        "layer": "6_WDP_CANONICAL_REPLAY_AND_BRIDGE",
        "bucket": "DERIVED",
        "status_detail": "LEAN4_AND_PYTHON_VERIFIED",
        "title": "Formal Substrate Admission Certificates, Strict Refinement Height Bounds, and Endogenous Orbit-Weight Forcing",
        "current_coverage": {
            "lean_theorems_count": 18,
            "python_checks": [
                "scripts/check_primitive_difference.py",
                "scripts/check_admission_replay.py"
            ],
            "standalone_python_mechanization": False,
            "meta_validation_only": True,
            "incoming_edge_count": 5,
            "outgoing_edge_count": 5
        },
        "missing_unit_tests": [
            "Dedicated standalone Python unit tests computing substrate tree heights and orbit weight sums.",
            "Boundary unit tests evaluating mark separation on minimal syntax trees of depth zero and one.",
            "Property unit tests verifying orbit weight positivity across group actions on finite carriers."
        ],
        "missing_integration_tests": [
            "Upstream integration tests checking that inputs from DER-27 and DER-56 satisfy certificate preconditions.",
            "Downstream integration tests confirming that OWE-05, OWE-06, OWE-09, and OWE-10 receive valid substrate certificates.",
            "Refinement integration tests verifying that height bounds enforce termination in DER-67 dyadic towers."
        ],
        "missing_end_to_end_tests": [
            "End-to-end certificate issuance tests tracing substrate generation from markA/markB to bridge targets.",
            "Multi-step orbit evolution end-to-end tests checking mass conservation across successive rewrites.",
            "Cross-facet correspondence tests matching Lean height bounds with Python syntax tree traversals."
        ],
        "missing_mutation_tests": [
            "Mark equality mutation tests injecting markA == markB into the certificate evaluator.",
            "Height bound mutation tests relaxing strict tree height inequalities from <= to <.",
            "Orbit weight mutation tests altering positive weight coefficients to negative values."
        ]
    },
    "DER-59": {
        "id": "DER-59",
        "code": "WDP-OBSERVER-ADAPTER-COMPLETENESS-AND-READOUT-FACTORIZATION",
        "layer": "6_WDP_CANONICAL_REPLAY_AND_BRIDGE",
        "bucket": "DERIVED",
        "status_detail": "LEAN4_AND_PYTHON_VERIFIED",
        "title": "Constructive Observer Adapter Completeness, Section-Backed Readout Factorization, and Kernel Inclusion",
        "current_coverage": {
            "lean_theorems_count": 27,
            "python_checks": [
                "scripts/check_primitive_difference.py",
                "scripts/check_admission_replay.py"
            ],
            "standalone_python_mechanization": False,
            "meta_validation_only": True,
            "incoming_edge_count": 4,
            "outgoing_edge_count": 2
        },
        "missing_unit_tests": [
            "Dedicated standalone Python unit tests computing observer fiber decompositions and section inversions.",
            "Boundary unit tests verifying adapter behavior on singleton and empty observation fibers.",
            "Property unit tests asserting that tuple sections preserve componentwise section properties."
        ],
        "missing_integration_tests": [
            "Upstream integration tests verifying that adapters from DER-39 and DER-43 compose associatively.",
            "Downstream integration tests ensuring that sectioned observer maps partition constraint scopes in DER-66.",
            "Context integration tests checking that indexed context families satisfy sectioned sort map requirements."
        ],
        "missing_end_to_end_tests": [
            "End-to-end readout factorization tests confirming unique descent of fiber-constant predicates.",
            "Multi-stage observer cascade tests verifying zero information loss across sectioned adapters.",
            "Cross-facet correspondence tests matching Lean unique_factorization_iff with Python lookup tables."
        ],
        "missing_mutation_tests": [
            "Section map mutation tests altering section outputs to return elements outside the fiber.",
            "Fiber constancy mutation tests perturbing predicate values on a single fiber element.",
            "Kernel inclusion mutation tests dropping transitivity in kernel equivalence checking."
        ]
    },
    "DER-60": {
        "id": "DER-60",
        "code": "WDP-ADDITIVE-TENSOR-COMPLETION-AND-GROTHENDIECK-FACTORIZATION",
        "layer": "6_WDP_CANONICAL_REPLAY_AND_BRIDGE",
        "bucket": "DERIVED",
        "status_detail": "LEAN4_AND_PYTHON_VERIFIED",
        "title": "Cancellative Commutative Monoid Grothendieck Group Completion and Independent-Subsystem Tensor Costs",
        "current_coverage": {
            "lean_theorems_count": 54,
            "python_checks": [
                "scripts/check_primitive_difference.py",
                "scripts/check_admission_replay.py"
            ],
            "standalone_python_mechanization": False,
            "meta_validation_only": True,
            "incoming_edge_count": 4,
            "outgoing_edge_count": 2
        },
        "missing_unit_tests": [
            "Dedicated standalone Python unit tests implementing free abelian group terms and Grothendieck cancellation.",
            "Boundary unit tests checking monoid completion on empty list units and single generators.",
            "Algebraic property unit tests evaluating tensor cost additivity on multi-generator combinations."
        ],
        "missing_integration_tests": [
            "Upstream integration tests confirming cost metrics from DER-34 and DER-51 embed into the Grothendieck carrier.",
            "Downstream integration tests verifying that signed Grothendieck groups provide valid bases for DER-61 dagger pairing.",
            "Admission integration tests asserting additive cost target S5 conservation across tensor products."
        ],
        "missing_end_to_end_tests": [
            "End-to-end tensor factorization tests checking subsystem cost additivity across multi-agent processes.",
            "Grothendieck group reduction tests verifying canonical representation uniqueness under formal difference cancellation.",
            "Cross-facet correspondence tests matching Lean CommMonoid.interchange with Python tensor contractions."
        ],
        "missing_mutation_tests": [
            "Grothendieck addition mutation tests replacing (a+c, b+d) with (a+d, b+c).",
            "Permutation quotient mutation tests removing the interchange law from formal list equivalence.",
            "Cancellativity mutation tests introducing non-cancellative absorbing elements into generator lists."
        ]
    },
    "DER-61": {
        "id": "DER-61",
        "code": "WDP-DAGGER-OBSERVER-PAIRING-AND-ADJOINT-INVOLUTION",
        "layer": "6_WDP_CANONICAL_REPLAY_AND_BRIDGE",
        "bucket": "DERIVED",
        "status_detail": "LEAN4_AND_PYTHON_VERIFIED",
        "title": "Dagger Relational Observer Pairing, Contra-Involutive Composition, and Conjugate Bilinear Symmetry",
        "current_coverage": {
            "lean_theorems_count": 16,
            "python_checks": [
                "scripts/check_primitive_difference.py",
                "scripts/check_admission_replay.py"
            ],
            "standalone_python_mechanization": False,
            "meta_validation_only": True,
            "incoming_edge_count": 5,
            "outgoing_edge_count": 4
        },
        "missing_unit_tests": [
            "Dedicated standalone Python unit tests computing bilinear pairing Gram matrices and verifying positive-semidefiniteness.",
            "Boundary unit tests checking dagger involution on self-adjoint and skew-adjoint basis generators.",
            "Property unit tests verifying contra-involutive composition laws (A . B)^dagger = B^dagger . A^dagger."
        ],
        "missing_integration_tests": [
            "Upstream integration tests checking that Grothendieck group outputs from DER-60 feed valid inputs to DER-61.",
            "Downstream integration tests verifying that dagger pairing Gram matrices parameterize DER-62 quantum readouts.",
            "Relational observer integration tests linking DER-43 observer projections with DER-61 bilinear forms."
        ],
        "missing_end_to_end_tests": [
            "End-to-end adjoint consistency tests verifying that measurement expectation values remain positive across operations.",
            "Observer reciprocity end-to-end tests checking bilinear pairing symmetry under observer exchange.",
            "Cross-facet correspondence tests matching Lean signedDagger_unit with Python matrix conjugates."
        ],
        "missing_mutation_tests": [
            "Dagger composition mutation tests omitting the order reversal in adjoint composition.",
            "Gram matrix symmetry mutation tests swapping off-diagonal elements with unequal values.",
            "Positive-semidefiniteness mutation tests injecting negative eigenvalues into the observer metric."
        ]
    },
    "DER-62": {
        "id": "DER-62",
        "code": "WDP-GAUSSIAN-INT-QUANTUM-READOUT-AND-FINITE-MODEL-DISCHARGES",
        "layer": "6_WDP_CANONICAL_REPLAY_AND_BRIDGE",
        "bucket": "DERIVED",
        "status_detail": "LEAN4_AND_PYTHON_VERIFIED",
        "title": "Gaussian Integer Parseval Identity, 2-Adic Unnormalized Hadamard Obstruction, 3-Basis Qubit MUBs, Bell Schmidt Determinant, Discrete Noether Conservation, and Landauer Erasure",
        "current_coverage": {
            "lean_theorems_count": 24,
            "python_checks": [
                "scripts/check_primitive_difference.py",
                "scripts/check_admission_replay.py"
            ],
            "standalone_python_mechanization": False,
            "meta_validation_only": True,
            "incoming_edge_count": 7,
            "outgoing_edge_count": 8
        },
        "missing_unit_tests": [
            "Dedicated standalone Python unit tests implementing Gaussian integer arithmetic, 2-point Parseval identity, and MUB checks.",
            "Boundary unit tests evaluating 2-adic valuation obstruction preventing normalized Hadamard in Z[i].",
            "Discrete Bell determinant unit tests computing Schmidt decomposition on 2-qubit Gaussian integer states."
        ],
        "missing_integration_tests": [
            "Upstream integration tests confirming that curvature from DER-53 and pairing from DER-61 construct valid Z[i] states.",
            "Downstream integration tests verifying that Gaussian state vectors provide valid inputs for DER-63 tensor balancing and DER-75 capstone.",
            "Conservation integration tests linking discrete Noether charges with step transitions from DER-25."
        ],
        "missing_end_to_end_tests": [
            "End-to-end quantum readout simulation tracing from initial mark to Bell state correlation checks.",
            "Landauer erasure dissipation end-to-end tests tracking integer cost accumulation during state reset.",
            "Cross-facet correspondence tests matching Lean gaussian_ext and parseval identities with Python numerical runs."
        ],
        "missing_mutation_tests": [
            "Gaussian multiplication mutation tests altering i^2 = -1 to i^2 = +1.",
            "Parseval identity mutation tests altering the cleared-denominator factor 2 to 1.",
            "Hadamard obstruction mutation tests forcing odd determinant on unnormalized Hadamard matrices."
        ]
    },
    "DER-63": {
        "id": "DER-63",
        "code": "WDP-COMPLEX-TENSOR-BALANCING-AND-PHASE-EQUIVALENCE",
        "layer": "6_WDP_CANONICAL_REPLAY_AND_BRIDGE",
        "bucket": "DERIVED",
        "status_detail": "LEAN4_AND_PYTHON_VERIFIED",
        "title": "Bilinear Tensor Balancing Quotient and Fourth-Root Phase Action Equivalence",
        "current_coverage": {
            "lean_theorems_count": 14,
            "python_checks": [
                "scripts/check_primitive_difference.py",
                "scripts/check_admission_replay.py"
            ],
            "standalone_python_mechanization": False,
            "meta_validation_only": True,
            "incoming_edge_count": 4,
            "outgoing_edge_count": 2
        },
        "missing_unit_tests": [
            "Dedicated standalone Python unit tests implementing 4-tuple balancing quotients and fourth-root phase actions.",
            "Boundary unit tests checking behavior on zero vectors and orthogonal basis pairs under integer division by 2.",
            "Property unit tests verifying that four successive phase shifts return the identity transformation."
        ],
        "missing_integration_tests": [
            "Upstream integration tests confirming that Gaussian states from DER-62 satisfy even coordinate parity for division by 2.",
            "Downstream integration tests verifying that balanced tensor outputs conform to IMG-03 and IMG-05 cosmos interfaces.",
            "Carrier integration tests checking multiplicity M1 consistency across bilinear quotient reductions."
        ],
        "missing_end_to_end_tests": [
            "End-to-end phase rotation tests tracking 4-phase cyclic equivalence across composite state vectors.",
            "Multi-particle tensor balancing tests verifying quotient stability under tensor product composition.",
            "Cross-facet correspondence tests matching Lean sectionMap_project with Python array balancing."
        ],
        "missing_mutation_tests": [
            "Phase cycle mutation tests altering the 4-cycle permutation (a,b,c,d) -> (-b,a,-d,c).",
            "Integer division mutation tests replacing integer floor division with round-to-nearest in balance projection.",
            "Norm conservation mutation tests altering the doubleQuad_norm identity scaling factor."
        ]
    },
    "DER-64": {
        "id": "DER-64",
        "code": "WDP-MARKED-GAUGE-TRANSPORT-AND-TREE-DEFECT-INVARIANCE",
        "layer": "6_WDP_CANONICAL_REPLAY_AND_BRIDGE",
        "bucket": "DERIVED",
        "status_detail": "LEAN4_AND_PYTHON_VERIFIED",
        "title": "Marked Gauge Transport over Rooted Spanning Trees and Fundamental Cycle Holonomy Invariance",
        "current_coverage": {
            "lean_theorems_count": 19,
            "python_checks": [
                "scripts/check_primitive_difference.py",
                "scripts/check_admission_replay.py"
            ],
            "standalone_python_mechanization": False,
            "meta_validation_only": True,
            "incoming_edge_count": 5,
            "outgoing_edge_count": 2
        },
        "missing_unit_tests": [
            "Dedicated standalone Python unit tests computing spanning tree gauge transport and fundamental cycle holonomies.",
            "Boundary unit tests evaluating transport on trees with a single edge and trees with maximal branching.",
            "Invariance unit tests checking that gauge shifts leave fundamental cycle holonomies invariant."
        ],
        "missing_integration_tests": [
            "Upstream integration tests confirming that cochain transports from DER-37 and DER-47 feed valid gauge connections.",
            "Downstream integration tests verifying that tree defect invariants satisfy preconditions for DER-75 terminal capstone.",
            "Admissions integration tests checking that gauge transport respects additive cost targets S5."
        ],
        "missing_end_to_end_tests": [
            "End-to-end gauge transport simulations on Source-25 graph instances verifying path independence on trees.",
            "Holonomy invariance end-to-end tests evaluating cycle sums under random node gauge renamings.",
            "Cross-facet correspondence tests matching Lean diagnostic_after_shift with Python graph holonomy calculations."
        ],
        "missing_mutation_tests": [
            "Gauge shift mutation tests omitting the node potential difference in link transport.",
            "Tree chord mutation tests applying tree-transport rules to non-tree chord edges.",
            "Holonomy accumulation mutation tests flipping sign on fundamental cycle boundary orientations."
        ]
    },
    "DER-65": {
        "id": "DER-65",
        "code": "WDP-MERON-THERMO-LIMIT-CONSTANTS-AND-WILSON-ACTION-BOUNDS",
        "layer": "6_WDP_CANONICAL_REPLAY_AND_BRIDGE",
        "bucket": "DERIVED",
        "status_detail": "LEAN4_AND_PYTHON_VERIFIED",
        "title": "Cleared-Denominator Meron Action Constants, Plaquette Frustration Thresholds, and Thermodynamic Scaling Bounds",
        "current_coverage": {
            "lean_theorems_count": 18,
            "python_checks": [
                "scripts/check_primitive_difference.py",
                "scripts/check_admission_replay.py"
            ],
            "standalone_python_mechanization": False,
            "meta_validation_only": True,
            "incoming_edge_count": 5,
            "outgoing_edge_count": 2
        },
        "missing_unit_tests": [
            "Dedicated standalone Python unit tests computing cleared-denominator Meron actions and plaquette frustration lower bounds.",
            "Boundary unit tests evaluating frustration thresholds on unfrustrated vs maximally frustrated plaquettes.",
            "Scaling property unit tests checking that thermodynamic action bounds grow monotonically with lattice area."
        ],
        "missing_integration_tests": [
            "Upstream integration tests confirming that Trotter polynomial data from DER-49 and curvature from DER-53 match action inputs.",
            "Downstream integration tests verifying that action bounds inform IMG-07 and IMG-08 cosmos extensions.",
            "Carrier integration tests checking multiplicity M1 scaling across thermodynamic limit calculations."
        ],
        "missing_end_to_end_tests": [
            "End-to-end lattice action simulations tracking total Wilson action across increasing lattice sizes.",
            "Frustration bound end-to-end tests confirming that no field configuration dips below the frustration threshold.",
            "Cross-facet correspondence tests matching Lean meron_action_cleared constants with Python lattice action evaluations."
        ],
        "missing_mutation_tests": [
            "Frustration threshold mutation tests setting the lower bound to zero.",
            "Cleared denominator mutation tests omitting the integer clearing factor in action comparisons.",
            "Action scaling mutation tests changing monotonic growth from <= to >= in lattice enlargement checks."
        ]
    },
    "DER-66": {
        "id": "DER-66",
        "code": "WDP-FINITE-CONSTRAINT-REPRESENTATION-AND-CANONICAL-COVER",
        "layer": "6_WDP_CANONICAL_REPLAY_AND_BRIDGE",
        "bucket": "DERIVED",
        "status_detail": "LEAN4_AND_PYTHON_VERIFIED",
        "title": "Constructive Sum-Indexed Constraint Representation and Canonical Evaluation Embedding",
        "current_coverage": {
            "lean_theorems_count": 26,
            "python_checks": [
                "scripts/check_primitive_difference.py",
                "scripts/check_admission_replay.py"
            ],
            "standalone_python_mechanization": False,
            "meta_validation_only": True,
            "incoming_edge_count": 4,
            "outgoing_edge_count": 0
        },
        "missing_unit_tests": [
            "Dedicated standalone Python unit tests implementing constraint table gluing, row filtering, and canonical embeddings.",
            "Boundary unit tests evaluating gluing theorems on empty constraint families and singleton scopes.",
            "Exhaustive search unit tests verifying that finite row enumeration covers all satisfiable local assignments."
        ],
        "missing_integration_tests": [
            "Upstream integration tests checking that constraint definitions from DER-41 and adapters from DER-59 glue consistently.",
            "Context integration tests ensuring indexed context family M2 supplies compatible constraint scopes.",
            "Terminal leaf integration tests asserting that DER-66 exports stable evaluation tables without open bridge requirements."
        ],
        "missing_end_to_end_tests": [
            "End-to-end constraint satisfaction tests verifying that local solutions assemble into a consistent global assignment.",
            "Evaluation embedding end-to-end tests confirming that row injections preserve satisfaction status.",
            "Cross-facet correspondence tests matching Lean gluing_theorem_effective with Python constraint solvers."
        ],
        "missing_mutation_tests": [
            "Gluing compatibility mutation tests dropping pairwise overlap checks between intersecting scopes.",
            "Row membership mutation tests altering row equality validation to ignore unbound variables.",
            "Embedding injectivity mutation tests collapsing distinct local assignments into a single canonical row."
        ]
    },
    "DER-67": {
        "id": "DER-67",
        "code": "WDP-DYADIC-PRESENTATION-AND-REFINEMENT-TOWER-PROJECTIVE-LIMITS",
        "layer": "6_WDP_CANONICAL_REPLAY_AND_BRIDGE",
        "bucket": "DERIVED",
        "status_detail": "LEAN4_AND_PYTHON_VERIFIED",
        "title": "Constructive Dyadic Refinement Towers, Binary Restriction Fibers, and Compatible Projective Cochains",
        "current_coverage": {
            "lean_theorems_count": 15,
            "python_checks": [
                "scripts/check_primitive_difference.py",
                "scripts/check_admission_replay.py"
            ],
            "standalone_python_mechanization": False,
            "meta_validation_only": True,
            "incoming_edge_count": 4,
            "outgoing_edge_count": 2
        },
        "missing_unit_tests": [
            "Dedicated standalone Python unit tests implementing dyadic tower addresses, inclusion maps, and residue pairings.",
            "Boundary unit tests checking inclusion maps at base level 0 and single-step refinement level 1.",
            "Property unit tests verifying that dyadic orders grow strictly as 2^n across refinement heights."
        ],
        "missing_integration_tests": [
            "Upstream integration tests confirming that substrate certificates from DER-58 bound refinement heights in DER-67.",
            "Downstream integration tests verifying that compatible projective cochains satisfy open bridge OWE-10 preconditions.",
            "Step dynamics integration tests ensuring step history dynamics M3 provide well-ordered refinement transitions."
        ],
        "missing_end_to_end_tests": [
            "End-to-end dyadic refinement tests tracing address resolution from level N back to base mark.",
            "Projective limit compatibility tests asserting that restriction maps commute across level jumps (n -> n+2).",
            "Cross-facet correspondence tests matching Lean pairing_inclusion with Python bit-shift arithmetic."
        ],
        "missing_mutation_tests": [
            "Dyadic order mutation tests replacing 2^n with 2*n in level capacity calculation.",
            "Inclusion map mutation tests altering bit-shift offsets in binary address embedding.",
            "Residue pairing mutation tests omitting the modulo 2^n reduction in character pairing."
        ]
    },
    "DER-68": {
        "id": "DER-68",
        "code": "WDP-SELF-REFERENCE-BRIDGES-AND-LINKED-REPORT-FACTORIZATION",
        "layer": "6_WDP_CANONICAL_REPLAY_AND_BRIDGE",
        "bucket": "DERIVED",
        "status_detail": "LEAN4_AND_PYTHON_VERIFIED",
        "title": "Constructive Self-Reference Bridges, Partial Section Factorization, and Deferred Linked-Report Horizon",
        "current_coverage": {
            "lean_theorems_count": 10,
            "python_checks": [
                "scripts/check_primitive_difference.py",
                "scripts/check_admission_replay.py"
            ],
            "standalone_python_mechanization": False,
            "meta_validation_only": True,
            "incoming_edge_count": 4,
            "outgoing_edge_count": 3
        },
        "missing_unit_tests": [
            "Dedicated standalone Python unit tests implementing linked-report factorizations and deferred evaluation horizons.",
            "Boundary unit tests evaluating behavior on empty reports and trivial identity links.",
            "Acyclicity unit tests asserting that deferred evaluation graphs contain zero dependency cycles."
        ],
        "missing_integration_tests": [
            "Upstream integration tests checking that initiality retracts from DER-16 embed into DER-68 self-reference structures.",
            "Downstream integration tests verifying that linked reports satisfy functional classification preconditions in DER-69.",
            "Bridge integration tests ensuring that self-reference bridges support discharge requirements for OWE-07."
        ],
        "missing_end_to_end_tests": [
            "End-to-end self-inspection tests confirming that reports remain consistent across cascading evaluation rounds.",
            "Deferred horizon stability tests asserting that deferred reports evaluate identically to direct reports on convergence.",
            "Cross-facet correspondence tests matching Lean linked_report_available with Python graph report caches."
        ],
        "missing_mutation_tests": [
            "Deferral guard mutation tests removing the horizon staging check to trigger immediate cyclic self-reference.",
            "Fiber constancy mutation tests returning divergent report values on presentation fibers.",
            "Link verification mutation tests accepting unvalidated links as verified links."
        ]
    },
    "DER-69": {
        "id": "DER-69",
        "code": "WDP-FUNCTIONAL-CLASSIFICATION-AND-BLIND-SPOT-LINKAGE",
        "layer": "6_WDP_CANONICAL_REPLAY_AND_BRIDGE",
        "bucket": "DERIVED",
        "status_detail": "LEAN4_AND_PYTHON_VERIFIED",
        "title": "Decidable Functional Observer Classification, Zero-Tolerance Faithfulness, and Blind-Spot Linkage",
        "current_coverage": {
            "lean_theorems_count": 11,
            "python_checks": [
                "scripts/check_primitive_difference.py",
                "scripts/check_admission_replay.py"
            ],
            "standalone_python_mechanization": False,
            "meta_validation_only": True,
            "incoming_edge_count": 4,
            "outgoing_edge_count": 1
        },
        "missing_unit_tests": [
            "Dedicated standalone Python unit tests classifying observers into linked, stable, and blind-spot states.",
            "Boundary unit tests evaluating observers with zero reports (complete blind spot) and bijective observers (zero blind spot).",
            "Property unit tests checking that composite linked observers preserve linked classification."
        ],
        "missing_integration_tests": [
            "Upstream integration tests confirming that behavioral quotients from DER-39 and links from DER-68 construct valid classifiers.",
            "Downstream integration tests verifying that observer classification results feed into cosmos extension IMG-10.",
            "Context integration tests ensuring context family M2 supports all required observation fiber partitions."
        ],
        "missing_end_to_end_tests": [
            "End-to-end observer classification tests evaluating synthetic observer suites under noise injection.",
            "Zero-tolerance faithfulness tests asserting that any readout discrepancy immediately reclassifies the observer as unlinked.",
            "Cross-facet correspondence tests matching Lean no_blind_spot_linked with Python classification audits."
        ],
        "missing_mutation_tests": [
            "Blind spot partition mutation tests classifying observers with missing fibers as faithful.",
            "Faithfulness threshold mutation tests relaxing zero-tolerance discrepancy check to tolerate single errors.",
            "Stability mutation tests removing the prerequisite of fiber constancy from observer linking."
        ]
    },
    "DER-70": {
        "id": "DER-70",
        "code": "WDP-ADMISSION-COUNT-AND-SUBSTRATE-BUDGET-ACCOUNTING",
        "layer": "6_WDP_CANONICAL_REPLAY_AND_BRIDGE",
        "bucket": "DERIVED",
        "status_detail": "LEAN4_AND_PYTHON_VERIFIED",
        "title": "Exact Admission Event Counting, Monotone Ledger Accumulation, and Budget Conservation Identities",
        "current_coverage": {
            "lean_theorems_count": 12,
            "python_checks": [
                "scripts/check_primitive_difference.py",
                "scripts/check_admission_replay.py"
            ],
            "standalone_python_mechanization": False,
            "meta_validation_only": True,
            "incoming_edge_count": 5,
            "outgoing_edge_count": 1
        },
        "missing_unit_tests": [
            "Dedicated standalone Python unit tests tracking admission counts, potential functions, and ledger mass.",
            "Boundary unit tests evaluating potential and mass calculations on empty states and single-step histories.",
            "Monotonicity unit tests verifying that mass never decreases across all 8 enabled transition types."
        ],
        "missing_integration_tests": [
            "Upstream integration tests checking that step transitions from DER-33 and floor constraints from DER-45 increment ledger correctly.",
            "Downstream integration tests verifying that budget bounds enforce conservation in cosmos extension IMG-06.",
            "Admission integration tests asserting that S0 and S5 budget limits are respected across run executions."
        ],
        "missing_end_to_end_tests": [
            "End-to-end accounting audits tracking cumulative admission expenditures across complete derivation replays.",
            "Budget exhaustion end-to-end tests confirming that executions halt cleanly when declared budget limits are met.",
            "Cross-facet correspondence tests matching Lean every_step_mass_monotone with Python ledger logs."
        ],
        "missing_mutation_tests": [
            "Ledger mass mutation tests decrementing mass on state transitions (mass - 1 instead of mass + 1).",
            "Potential upper bound mutation tests altering potential update bounds to permit unbounded growth.",
            "Transition enabling mutation tests allowing unadmitted events to execute without incrementing admission counters."
        ]
    },
    "DER-71": {
        "id": "DER-71",
        "code": "WDP-BALANCE-PRESERVING-EDITS-AND-CYCLE-SPACE-INVARIANCE",
        "layer": "6_WDP_CANONICAL_REPLAY_AND_BRIDGE",
        "bucket": "DERIVED",
        "status_detail": "LEAN4_AND_PYTHON_VERIFIED",
        "title": "Balance-Preserving Cochain Edits, Coboundary Perturbation Invariance, and Zero-Sum Cycle Conservation",
        "current_coverage": {
            "lean_theorems_count": 10,
            "python_checks": [
                "scripts/check_primitive_difference.py",
                "scripts/check_admission_replay.py"
            ],
            "standalone_python_mechanization": False,
            "meta_validation_only": True,
            "incoming_edge_count": 4,
            "outgoing_edge_count": 2
        },
        "missing_unit_tests": [
            "Dedicated standalone Python unit tests computing directed tetrahedral cycle spaces and testing gradient balance preservation.",
            "Boundary unit tests evaluating cochain edits on trivial zero-cycles and isolated tetrahedral faces.",
            "Invariance unit tests checking that coboundary perturbations leave fundamental cycle evaluations unchanged."
        ],
        "missing_integration_tests": [
            "Upstream integration tests confirming that cochain edits from DER-38 and transports from DER-47 preserve tetrahedral balance.",
            "Downstream integration tests verifying that balanced cochains feed valid invariants to IMG-06 and IMG-07 cosmos interfaces.",
            "Cost target integration tests asserting that balance-preserving edits maintain zero-cost targets S5."
        ],
        "missing_end_to_end_tests": [
            "End-to-end cochain evolution tests executing 500 successive balanced edits and asserting zero-sum cycle conservation.",
            "Coboundary invariance end-to-end tests checking that gradient edits produce zero circulation across closed cycles.",
            "Cross-facet correspondence tests matching Lean gradient_balanced with Python cochain algebra."
        ],
        "missing_mutation_tests": [
            "Cycle balance mutation tests injecting non-zero circulation into gradient cochain updates.",
            "Tetrahedral orientation mutation tests flipping edge sign in the boundary differential operator.",
            "Update scope mutation tests modifying edges inside a cycle while asserting update_outside_cycle holds."
        ]
    },
    "DER-72": {
        "id": "DER-72",
        "code": "WDP-BATCH-10-CANONICAL-TRANSPORT-SYNTHESIS",
        "layer": "6_WDP_CANONICAL_REPLAY_AND_BRIDGE",
        "bucket": "DERIVED",
        "status_detail": "LEAN4_AND_PYTHON_VERIFIED",
        "title": "WDP Batch 10 Synthesis: Multi-Step Transport Composition and Quotient Coherence",
        "current_coverage": {
            "lean_theorems_count": 18,
            "python_checks": [
                "scripts/check_primitive_difference.py",
                "scripts/check_admission_replay.py"
            ],
            "standalone_python_mechanization": False,
            "meta_validation_only": True,
            "incoming_edge_count": 4,
            "outgoing_edge_count": 1
        },
        "missing_unit_tests": [
            "Dedicated standalone Python unit tests implementing rational complex arithmetic, gratNormSq, and multi-step transport.",
            "Boundary unit tests checking transport composition on identity transports and zero norm vectors.",
            "Algebraic unit tests verifying norm multiplicativity gratNormSq(z * w) = gratNormSq(z) * gratNormSq(w)."
        ],
        "missing_integration_tests": [
            "Upstream integration tests verifying that transport structures from DER-50 and schedule guards from DER-57 compose into DER-72.",
            "Downstream integration tests confirming that Batch 10 quotient coherence satisfies preconditions for DER-73 window synthesis.",
            "Retention integration tests asserting that one-bit retention state S4 commutes across transport compositions."
        ],
        "missing_end_to_end_tests": [
            "End-to-end transport chain simulations evaluating quotient coherence across 20-step composite paths.",
            "Multi-step commutativity end-to-end tests checking that path alternatives evaluate to identical quotient states.",
            "Cross-facet correspondence tests matching Lean gratNormSq_mul with Python rational field arithmetic."
        ],
        "missing_mutation_tests": [
            "Complex multiplication mutation tests altering cross-terms in rational complex multiplication.",
            "Norm squared mutation tests changing x^2 + y^2 to x^2 - y^2 (hyperbolic norm).",
            "Transport composition mutation tests dropping associativity in chained transport maps."
        ]
    },
    "DER-73": {
        "id": "DER-73",
        "code": "WDP-BATCH-11-OBSTRUCTION-AND-WINDOW-SYNTHESIS",
        "layer": "6_WDP_CANONICAL_REPLAY_AND_BRIDGE",
        "bucket": "DERIVED",
        "status_detail": "LEAN4_AND_PYTHON_VERIFIED",
        "title": "WDP Batch 11 Synthesis: Windowed Obstruction Bounds and Local-Global Glueing Certificates",
        "current_coverage": {
            "lean_theorems_count": 12,
            "python_checks": [
                "scripts/check_primitive_difference.py",
                "scripts/check_admission_replay.py"
            ],
            "standalone_python_mechanization": False,
            "meta_validation_only": True,
            "incoming_edge_count": 6,
            "outgoing_edge_count": 1
        },
        "missing_unit_tests": [
            "Dedicated standalone Python unit tests calculating windowed obstruction indices and local-global gluing certificates.",
            "Boundary unit tests evaluating obstruction bounds on single windows (zero obstruction) and 3-window overlaps.",
            "Event count unit tests checking stepRung change differences against admitting count inequalities."
        ],
        "missing_integration_tests": [
            "Upstream integration tests confirming that overlap frustration from DER-52 and transport from DER-72 construct valid Batch 11 certificates.",
            "Downstream integration tests verifying that window obstruction bounds feed into DER-74 higher cohomology synthesis.",
            "Carrier integration tests checking multiplicity M1 scaling across windowed partition overlaps."
        ],
        "missing_end_to_end_tests": [
            "End-to-end local-global gluing tests verifying that certified window families assemble into consistent global states.",
            "Obstruction bound end-to-end tests checking that total frustration remains bounded under window mesh refinement.",
            "Cross-facet correspondence tests matching Lean stepRung_change_eq_elems_diff with Python event counters."
        ],
        "missing_mutation_tests": [
            "Admitting count mutation tests inverting the inequality admittingCount <= everyCount to >=.",
            "Window obstruction mutation tests setting the frustration lower bound to negative infinity.",
            "Gluing certificate mutation tests omitting boundary consistency checks between overlapping windows."
        ]
    },
    "DER-74": {
        "id": "DER-74",
        "code": "WDP-BATCH-12-HIGHER-COHOMOLOGY-AND-CURVATURE-SYNTHESIS",
        "layer": "6_WDP_CANONICAL_REPLAY_AND_BRIDGE",
        "bucket": "DERIVED",
        "status_detail": "LEAN4_AND_PYTHON_VERIFIED",
        "title": "WDP Batch 12 Synthesis: Simplicial Bianchi Conservation and Curvature-Holonomy Coupling",
        "current_coverage": {
            "lean_theorems_count": 18,
            "python_checks": [
                "scripts/check_primitive_difference.py",
                "scripts/check_admission_replay.py"
            ],
            "standalone_python_mechanization": False,
            "meta_validation_only": True,
            "incoming_edge_count": 6,
            "outgoing_edge_count": 3
        },
        "missing_unit_tests": [
            "Dedicated standalone Python unit tests implementing simplicial boundary differentials, verifying d^2 = 0 nilpotency.",
            "Boundary unit tests evaluating Bianchi identities on flat complexes vs complexes with localized curvature defects.",
            "Engine capacity unit tests checking rule observation counts across all 144 Genesis engine classes."
        ],
        "missing_integration_tests": [
            "Upstream integration tests confirming that discrete curvature splits from DER-53 and window bounds from DER-73 feed into DER-74.",
            "Downstream integration tests verifying that curvature-holonomy couplings satisfy preconditions for DER-75 capstone synthesis.",
            "Cosmos integration tests linking Bianchi conservation with IMG-01 and IMG-08 higher-dimensional cosmos models."
        ],
        "missing_end_to_end_tests": [
            "End-to-end simplicial cohomology simulations checking that total Bianchi curvature sums vanish on closed 3-surfaces.",
            "Curvature-holonomy coupling end-to-end tests verifying holonomy changes match enclosed curvature integrals.",
            "Cross-facet correspondence tests matching Lean bianchi_conservation_tetrahedral with Python boundary matrix calculations."
        ],
        "missing_mutation_tests": [
            "Coboundary nilpotency mutation tests altering boundary operator signs so that d^2 != 0.",
            "Curvature-holonomy coupling mutation tests decoupling link holonomies from face curvature values.",
            "Engine capacity mutation tests exceeding declared capacity limits for class 144 engines."
        ]
    },
    "DER-75": {
        "id": "DER-75",
        "code": "WDP-BATCH-13-TERMINAL-CAPSTONE-SYNTHESIS",
        "layer": "6_WDP_CANONICAL_REPLAY_AND_BRIDGE",
        "bucket": "DERIVED",
        "status_detail": "LEAN4_AND_PYTHON_VERIFIED",
        "title": "WDP Batch 13 Terminal Synthesis: End-to-End Witnessed Difference Programme Replay Closure",
        "current_coverage": {
            "lean_theorems_count": 13,
            "python_checks": [
                "scripts/check_primitive_difference.py",
                "scripts/check_admission_replay.py"
            ],
            "standalone_python_mechanization": False,
            "meta_validation_only": True,
            "incoming_edge_count": 6,
            "outgoing_edge_count": 3
        },
        "missing_unit_tests": [
            "Dedicated standalone Python unit tests implementing the institutional boundary authorization firewall and software projection.",
            "Boundary unit tests evaluating firewall behavior on empty packet streams and all-software vs all-institutional packets.",
            "Tag validation unit tests verifying that packet tag filtering strictly enforces security boundaries."
        ],
        "missing_integration_tests": [
            "Upstream integration tests confirming that outputs from DER-62 (quantum), DER-64 (gauge), and DER-74 (cohomology) are accepted by DER-75.",
            "Downstream integration tests verifying that terminal replay closure supports cosmos extensions IMG-04, IMG-09, and IMG-10.",
            "Full admission integration tests asserting that S0, S4, S5, and M1 admissions are accounted for at terminal capstone."
        ],
        "missing_end_to_end_tests": [
            "Comprehensive end-to-end replay test verifying entire derivation DAG from mark to DER-75 capstone under non-zero costs.",
            "Security firewall end-to-end tests asserting that institutional packets cannot bypass software projection gates.",
            "Cross-facet correspondence tests matching Lean guardedEnforcement_respects_boundary with Python firewall logs."
        ],
        "missing_mutation_tests": [
            "Firewall bypass mutation tests allowing untagged institutional packets to pass software projections.",
            "Boundary respect mutation tests inverting the boolean outcome of RespectsInstitutionalBoundary.",
            "Terminal closure mutation tests marking replay verification successful when intermediate assertions fail."
        ]
    }
}
