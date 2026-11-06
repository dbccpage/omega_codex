# Two-Person Adversarial Test Gap Catalog across 97 Derivation DAG Nodes

## Claim Hygiene Summary

1. **What it supports**: A structured catalog of missing unit, integration, end-to-end, and mutation tests across all 97 derivation DAG nodes, identifying formal soundness limitations, unstated boundaries, check script assertion deficits, mechanization inflation, admission chain bypasses, and disconnected bridge obligations.
2. **What it does not support**: Any implementation of new test suites (strictly precluded by Milestone 4), any assertion that cataloging substitutes for empirical test execution, or any claim that toy-model checks establish continuum physics or general domain properties.
3. **Narrowest defensible claim**: The derivation DAG contains 71 unconditionally perfected, 3 conditionally perfected, and 23 non-perfected nodes; 45 nodes lack standalone executable Python simulation (binding only to Lean meta-validation scripts), 3 check scripts in audit/ contain zero assertions, and 51 of 56 derived nodes drop transitive admission dependencies.
4. **Next test needed**: Execution of prioritized unit and integration test suites during downstream test engineering cycles, restoration of the Trotter char poly calculator in DER-49, hardening of zero-assertion audit check scripts, and explicit transitive wiring of open bridge admissions.

## 1. Executive Summary & Audit Census

This catalog synthesizes the independent adversarial investigations conducted by **Adversary 1** (`challenger_adv_1`: Formal Soundness and Mathematical Prose) and **Adversary 2** (`challenger_adv_2`: Mechanization and Integration Architecture) across all 97 nodes of the derivation DAG (`dag/derivation_dag.json`) and the tri-partite correspondence audit (`dag/tripartite_correspondence_audit.json`).

| Metric | Count | Proportion |
|---|---:|---:|
| Total Derivation DAG Nodes Audited | 97 | 100.0% |
| Unconditionally Perfected Nodes | 71 | 73.2% |
| Conditionally Perfected Nodes (Bridge-Dependent) | 3 | 3.1% |
| Non-Perfected Nodes (Admissions / Bridges / Imagined) | 23 | 23.7% |
| Nodes Missing Standalone Python Simulation (Meta-Only) | 45 | 46.4% |
| Zero-Assertion Audit Check Scripts | 3 | N/A |
| Total Missing Unit Test Prescriptions | 485 | N/A |
| Total Missing Integration Test Prescriptions | 388 | N/A |
| Total Missing End-to-End Test Prescriptions | 388 | N/A |
| Total Missing Mutation Test Prescriptions | 493 | N/A |
| **Grand Total Cataloged Test Prescriptions** | **1754** | **100.0%** |

## 2. Systemic Vulnerabilities

### VULN-01: Zero-Assertion and Superficial Check Scripts in Audit Suite

- **Severity**: `CRITICAL`
- **Affected Files**: `audit/2026-11-05_minimal_chain/2_mark_checks.py, audit/2026-11-05_minimal_chain/4_frozen_checks.py, audit/2026-11-05_minimal_chain/5_forcing_checks.py, audit/2026-11-05_minimal_chain/9_oq01_to_oq04_checks.py, audit/2026-11-05_minimal_chain/3_regime_deletions.py`
- **Description**: Three of the seven audit check scripts in audit/2026-11-05_minimal_chain/ (2_mark_checks.py, 4_frozen_checks.py, 5_forcing_checks.py) contain exactly zero assert statements, exception raises, or non-zero exit codes. They execute print statements and terminate with exit code 0 unconditionally. For example, 2_mark_checks.py:246-273 computes soundness_holds = all(...), prints the boolean to stdout, and exits with code 0 even if the invariant evaluates to False. Script 9_oq01_to_oq04_checks.py has only 1 assertion across 266 lines, and 3_regime_deletions.py has only 2 superficial 'is not None' checks across 476 lines.
- **Epistemic Impact**: Validation via scripts/validate_derivation_dag.py --run-checks reports false green success, masking runtime invariant breakages as successful runs.
- **Remediation**: Convert all stdout print checks into explicit boolean assertions and structured exceptions that exit with non-zero status upon evaluation failure.

### VULN-02: Mechanization Facet Inflation in WDP Layer 6 and Host Admissions

- **Severity**: `HIGH`
- **Affected Files**: `scripts/check_primitive_difference.py, scripts/check_admission_replay.py, dag/derivation_dag.json`
- **Description**: Exactly 26 nodes (host admission OWE-01 and 25 derived nodes in WDP Layer 6: DER-31, DER-32, DER-34 through DER-56) declare python_checks restricted to scripts/check_primitive_difference.py and scripts/check_admission_replay.py. These scripts only verify Lean toolchain compilation hashes and inspect #print axioms. There is zero executable Python code performing numerical simulation or runtime property testing for discrete Gauss-Bonnet splits (DER-53), cochain window trichotomy (DER-54), pentachoron monopoles (DER-55), rooted tree gauge normalization (DER-47), sparse chain transport norms (DER-48), or primal-dual repair quotients (DER-50, DER-51).
- **Epistemic Impact**: 24 of the 52 nodes classified as PERFECTED in the tri-partite correspondence audit have never been executed or tested in Python; their mechanization facet is administrative meta-validation rather than behavioral execution.
- **Remediation**: Author dedicated Python calculation modules and property-based test suites in tests/ covering each mathematical structure in WDP Layer 6.

### VULN-03: Missing Response Matrix Calculator in Trotter Characteristic Polynomials (DER-49)

- **Severity**: `CRITICAL`
- **Affected Files**: `lean/WitnessedDifference/TrotterCharPoly.lean, dag/derivation_dag.json`
- **Description**: The header of lean/WitnessedDifference/TrotterCharPoly.lean (lines 11-14) states: 'This file does not build the response matrix and does not derive a characteristic polynomial. The Python module code/trotter_characteristic_polynomials.py is the calculator for those matrices.' However, code/trotter_characteristic_polynomials.py does not exist in omega_codex, and the code/ directory is completely absent. All 33 theorems in TrotterCharPoly.lean only evaluate constant fraction identities of the form a * num - b * den = 0 via rfl (e.g., evalCleared 21 10 m1_root_pos1 = 0 checks 21*10 - 10*21 = 0).
- **Epistemic Impact**: DER-49 is cataloged as PERFECTED, but its declared computational calculator was never integrated into omega_codex.
- **Remediation**: Port code/trotter_characteristic_polynomials.py from reference Repository B into scripts/ or a dedicated package, and bind dedicated unit tests in tests/.

### VULN-04: Integer Linear Arithmetic Substitutions in Discrete Gauss-Bonnet (DER-53) and Cohomology (DER-55)

- **Severity**: `HIGH`
- **Affected Files**: `lean/WitnessedDifference/DiscreteGaussBonnet.lean, lean/WitnessedDifference/HigherSimplicialCohomology.lean`
- **Description**: In DiscreteGaussBonnet.lean:201-206, discrete_gauss_bonnet_triangulated_surface is a 4-variable integer linear identity 6*V - sumK = 6*(V - E + F) discharged in one step by the integer linear arithmetic tactic omega from hypotheses 2*E = 3*F and sumK = 2*E. There is no triangulated geometric surface, curvature form, or boundary operator. In HigherSimplicialCohomology.lean, Euler characteristics are proven by 'by decide' on static integer arithmetic expressions ((4:Int) - 6 + 4 = 2, (6:Int) - 12 + 8 = 2, (5:Int) - 10 + 10 - 5 = 0) on single Platonic simplices.
- **Epistemic Impact**: Mathematical prose discusses continuum Regge calculus and General Relativity, whereas formal proofs operate strictly on static integer arithmetic expressions over single small graphs.
- **Remediation**: Implement generic simplicial mesh data structures and boundary operators in Python and Lean to verify deficit angle sums on non-equilateral and multi-cell meshes.

### VULN-05: Memoryless Refusal Register in Primitive Difference (DER-01)

- **Severity**: `MEDIUM`
- **Affected Files**: `lean/PrimitiveDifference.lean`
- **Description**: In lean/PrimitiveDifference.lean:166-168, def recordRefusal (c : Bool -> Bool) (_previous : Register) : Register := ⟨reject c⟩ discards the _previous register state completely. The refusal register is a stateless boolean wrapper evaluating an instantaneous function equality rather than accumulating operational history or state transitions.
- **Epistemic Impact**: Downstream prose describes cumulative refusal tracking, whereas the formalized code implements a stateless check.
- **Remediation**: Formalize stateful refusal registers accumulating historical candidate maps over input sequences, with tests verifying persistence across sequential updates.

### VULN-06: Admission Chain Bypasses and Transitive Admission Dropping

- **Severity**: `HIGH`
- **Affected Files**: `dag/derivation_dag.json, dag/tripartite_correspondence_audit.json`
- **Description**: (1) DER-22 is marked DERIVED_CONDITIONALLY on open bridge OWE-08. DER-49 derives directly from DER-22, yet DER-49 is classified as unconditionally PERFECTED without inheriting OWE-08 or an incoming admission edge. (2) 51 of 56 DERIVED nodes drop transitive OWED admission dependencies from their unpriced_inputs_or_admissions (such as OWE-02 S1-S3 substrate, declared only on DER-01 and DER-02).
- **Epistemic Impact**: Downstream derivations appear unconditionally established despite depending transitively on open bridge debts or unpriced foundational admissions.
- **Remediation**: Compute transitive closures of admission dependencies during DAG validation and propagate open bridge debts downstream.

### VULN-07: Disconnected Open Bridge Obligations in Derivation DAG

- **Severity**: `HIGH`
- **Affected Files**: `dag/derivation_dag.json`
- **Description**: Open bridge obligations OWE-05 (diamond-to-root gap), OWE-06 (genesis-to-window gap), and OWE-10 (infinite completion) have zero outgoing edges in dag/derivation_dag.json. Downstream nodes bypass them completely by assuming restricted finite carriers without explicit graph dependency edges.
- **Epistemic Impact**: The DAG topology masks open foundational debts by isolating bridge nodes rather than explicitly wiring them to consumers.
- **Remediation**: Connect open bridge obligations to their downstream recipient nodes with explicit requires_admission or motivates_bridge edges.

### VULN-08: Toy-Model Cost Restrictions in Replay Commutation (DER-12, DER-28, DER-33)

- **Severity**: `MEDIUM`
- **Affected Files**: `lean/AdmissionReplay.lean, lean/WitnessedDifference/GuardedHistoryCoherence.lean, audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py`
- **Description**: Commutation between HWorld and Represented.World is evaluated strictly at zero admission and retention cost (cSup = 0, cAdm = 0, cRet = 0, cEv = 1) and singleton views. Non-zero costs, multi-locus views, and non-trivial memory limits remain untested in executable code.
- **Epistemic Impact**: Commutation and replay properties are verified only under degenerate zero-cost conditions, leaving behavior under non-zero costs unexamined.
- **Remediation**: Author property-based simulation suites sweeping across non-zero cost vectors and multi-locus configurations.

### VULN-09: Scale Divergence between Mathematical Prose and Constructive Formalization

- **Severity**: `MEDIUM`
- **Affected Files**: `docs/research_map.md, dag/README.md, lean/*`
- **Description**: Mathematical prose documents employ terminology from continuous physics, differential geometry, and quantum field theory (e.g., Einstein-Hilbert action, Regge calculus, cosmological horizons, quantum state spaces), whereas formal code implements strictly discrete, finite combinatorial structures (e.g., Bool, Fin 3, single Platonic solids, hardcoded fractions).
- **Epistemic Impact**: Creates semantic inflation where readers may confuse toy combinatorial models with continuous physical theories.
- **Remediation**: Align mathematical prose strictly with finite discrete structures and explicitly label all continuum descriptions as non-formalized conjectures.

## 3. Comprehensive Per-Node Test Gap Properties

### Layer: 4_LOCAL_GLOBAL_AND_L1_GEOMETRY (16 Nodes)

#### `DER-52` — WDP-LOCAL-COMPATIBILITY-AND-OVERLAP-FRUSTRATION: Constructive Section-Backed and Quotient-Level Decoder Equivalence, Cleared-Denominator Readout Bounds, and 3-Window Overlap Frustration

- **Layer**: `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 15 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 15 Lean theorems in WitnessedDifference.LocalCompatibility. Formalizes section-backed and quotient-level decoder criteria modulo repair equivale...
- Prose vs code gap: Prose describes local-global compatibility and frustration in sheaf-theoretic terms. Lean code formalizes this directly as a 3-window parity obstruction....
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S4_retention_state_bit', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 15 Lean theorems in WitnessedDifference.LocalCompatibility. Formalizes section-backed and quotient-level decoder criteria modulo repair equivalence, concrete 3-bit XOR recovery, and a 3-window frustrated cycle that is pairwise compatible on every overlap but admits no global section. Vulnerability: Zero dedicated Python tests in tests/. The 3-window frustration is demonstrated on an explicit 3-element cycle with parity twist; it does not generalize to arbitrary non-orientable sheaves.
- *Prose vs Code*: Prose describes local-global compatibility and frustration in sheaf-theoretic terms. Lean code formalizes this directly as a 3-window parity obstruction.
- *Boundaries & Assumptions*: Boundary conditions: Compatible overlaps that admit a global section vs frustrated overlaps that do not. Unstated assumption: overlap intersections are non-empty.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 7, Outgoing edges: 0.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S4_retention_state_bit', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ for LocalCompatibility
- [Adversary 1 - Formal Soundness] Lean theorem establishing general Cech cohomology obstruction for n-window cycles.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-LOCAL-COMPATIBILITY-AND-OVERLAP-FRUSTRATION (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-52.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (15 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-52 local compatibility and DER-53 discrete Gauss-Bonnet.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-52.
- [Adversary 2 - Mechanization] Terminal boundary integration tests checking that DER-52 exports valid terminal invariants or extension interfaces.
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S4_retention_state_bit']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Sheaf section reconstruction test verifying that global section search aborts upon encountering frustrated cycle.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 4_LOCAL_GLOBAL_AND_L1_GEOMETRY including DER-52.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-LOCAL-COMPATIBILITY-AND-OVERLAP-FRUSTRATION across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-52 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Untwist the parity obstruction on the third window; verify that global section existence succeeds.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-LOCAL-COMPATIBILITY-AND-OVERLAP-FRUSTRATION checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-52).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-52 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-52 causes check failure).

---

#### `DER-53` — WDP-DISCRETE-GAUSS-BONNET-AND-REGGE-CURVATURE-SPLIT: Tetrahedral Bianchi Identity, Cochain Curvature vs. Regge Deficit Split, Combinatorial Discrete Gauss-Bonnet, and Lattice Light-Cone Calibration

- **Layer**: `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 15 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 15 Lean theorems in WitnessedDifference.DiscreteGaussBonnet. CRITICAL STRUCTURAL FINDING: Discrete Gauss-Bonnet (theorem discrete_gauss_bonnet_t...
- Prose vs code gap: Prose invokes differential geometry, Regge calculus, General Relativity, and curvature splits on 2-surfaces and 3-manifolds. The Lean formalization consists of ...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 15 Lean theorems in WitnessedDifference.DiscreteGaussBonnet. CRITICAL STRUCTURAL FINDING: Discrete Gauss-Bonnet (theorem discrete_gauss_bonnet_triangulated_surface) is formalized as the elementary integer arithmetic identity `6 * V - sumK = 6 * (V - E + F)` under hypotheses `2 * E = 3 * F` and `sumK = 2 * E`, proven in one step by `omega`! The 0-, 1-, and 2-cochains are hardcoded to the 4 vertices, 6 edges, and 4 faces of a single tetrahedron K4. The Platonic solid theorem checks arithmetic: 4*(6-3)=12, 6*(6-4)=12, 12*(6-5)=12. There is NO simplicial complex topology, no triangulation data structure, and no curved manifold limit in Lean! In addition, this module has ZERO dedicated Python tests in tests/.
- *Prose vs Code*: Prose invokes differential geometry, Regge calculus, General Relativity, and curvature splits on 2-surfaces and 3-manifolds. The Lean formalization consists of integer arithmetic substitutions and single tetrahedron identities.
- *Boundaries & Assumptions*: Boundary conditions: Closed triangular meshes (2E = 3F); equilateral triangles (angle = 60 deg). Unstated assumptions: Surface has no boundary edges; all faces are equilateral triangles.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 6, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python test suite verifying deficit angle sums on non-equilateral and non-spherical meshes
- [Adversary 1 - Formal Soundness] Lean theorem for surfaces with boundary (2E != 3F) incorporating geodesic curvature sum.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-DISCRETE-GAUSS-BONNET-AND-REGGE-CURVATURE-SPLIT (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-53.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (15 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking DER-53 cochain curvature with DER-55 higher simplicial cohomology.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-53.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-53 satisfy input contracts for dependent nodes ['IMG-08', 'DER-55'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S5_additive_cost_target']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Complete mesh evaluation pipeline taking 3D OBJ mesh file, computing Regge deficits at vertices, and verifying Euler characteristic.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 4_LOCAL_GLOBAL_AND_L1_GEOMETRY including DER-53.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-DISCRETE-GAUSS-BONNET-AND-REGGE-CURVATURE-SPLIT across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-53 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate 2E = 3F to 2E = 4F (quadrilateral mesh); verify that triangulated Gauss-Bonnet fails
- [Adversary 1 - Formal Soundness] Invert Bianchi cycle sum sign; verify that tetrahedral Bianchi identity fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-DISCRETE-GAUSS-BONNET-AND-REGGE-CURVATURE-SPLIT checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-53).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-53 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-53 causes check failure).

---

#### `DER-54` — WDP-FINITE-WINDOW-OBSTRUCTION-AND-DIAGNOSTIC-TRICHOTOMY: Abstract Cochain Window Trichotomy, Degree-1 Quotient Descent iff d1 o d0 = 0, and Three-Class Diagnostic Classifier

- **Layer**: `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 24 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 24 Lean theorems in WitnessedDifference.FiniteWindowObstruction. Formalizes additive-group cochain windows, repair invariance of closure, three-...
- Prose vs code gap: Prose presents the diagnostic trichotomy as an operational diagnostic partition. Lean formalization is sound for the abstract Window structure, but unexercised ...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 24 Lean theorems in WitnessedDifference.FiniteWindowObstruction. Formalizes additive-group cochain windows, repair invariance of closure, three-sector diagnostic trichotomy (Exact, ClosedResidual, ActiveClosureFailure), and quotient descent. Vulnerability: Zero dedicated Python tests in tests/. Trichotomy decidability requires Decidable instances for Exact and Closed, which are supplied as hypotheses rather than derived constructively for arbitrary groups.
- *Prose vs Code*: Prose presents the diagnostic trichotomy as an operational diagnostic partition. Lean formalization is sound for the abstract Window structure, but unexercised dynamically in Python.
- *Boundaries & Assumptions*: Boundary conditions: Exact cochain; closed non-exact cochain; active closure failure. Unstated assumption: group carrier addition is commutative.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 6, Outgoing edges: 0.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ for FiniteWindowObstruction
- [Adversary 1 - Formal Soundness] Lean theorem establishing that trichotomy sectors are pairwise disjoint.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-FINITE-WINDOW-OBSTRUCTION-AND-DIAGNOSTIC-TRICHOTOMY (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-54.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (24 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-54 diagnostic trichotomy and DER-50 primal-dual repair.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-54.
- [Adversary 2 - Mechanization] Terminal boundary integration tests checking that DER-54 exports valid terminal invariants or extension interfaces.
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S5_additive_cost_target']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Automated diagnostic run classifying 100 sample cochains into exact, residual, and active sectors.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 4_LOCAL_GLOBAL_AND_L1_GEOMETRY including DER-54.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-FINITE-WINDOW-OBSTRUCTION-AND-DIAGNOSTIC-TRICHOTOMY across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-54 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate chain condition d1 o d0 != 0; verify that quotient descent theorem kappa_descends_iff fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-FINITE-WINDOW-OBSTRUCTION-AND-DIAGNOSTIC-TRICHOTOMY checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-54).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-54 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-54 causes check failure).

---

#### `DER-55` — WDP-HIGHER-SIMPLICIAL-COHOMOLOGY-AND-PENTACHORON-EXACTNESS: Hollow-Tetrahedron H^2(S^2; Z) Monopole Obstruction and Primal-Dual L1 Duality, 4-Simplex Pentachoron Exactness, and Discrete Cayley Orthogonality

- **Layer**: `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 21 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 21 Lean theorems in WitnessedDifference.HigherSimplicialCohomology. CRITICAL STRUCTURAL FINDING: Euler characteristics are evaluated by `decide`...
- Prose vs code gap: Prose claims higher simplicial cohomology, hollow-sphere H2 duality, and pentachoron 3-cocycle exactness. Lean formalization establishes this for single concret...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 21 Lean theorems in WitnessedDifference.HigherSimplicialCohomology. CRITICAL STRUCTURAL FINDING: Euler characteristics are evaluated by `decide` on integer arithmetic: `4 - 6 + 4 = 2` for tetrahedron, `6 - 12 + 8 = 2` for octahedron, `5 - 10 + 10 - 5 = 0` for hollow 4-simplex, and `5 - 10 + 10 - 5 + 1 = 1` for 4-simplex pentachoron! Chains and cochains are hardcoded records with fixed integer fields (TetChain1 has 6 fields, TetChain2 has 4 fields, PentCochain2 has 10 fields). Zero dedicated Python tests in tests/.
- *Prose vs Code*: Prose claims higher simplicial cohomology, hollow-sphere H2 duality, and pentachoron 3-cocycle exactness. Lean formalization establishes this for single concrete simplicial structures rather than a general simplicial engine.
- *Boundaries & Assumptions*: Boundary conditions: Single tetrahedron Delta3; single octahedron; single pentachoron Delta4. Unstated assumption: simplices are embedded with standard combinatorial orientation.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 7, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python test suite verifying higher coboundary operators on general n-simplices
- [Adversary 1 - Formal Soundness] Lean theorem establishing boundary nilpotence d o d = 0 for general graded chain complexes.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-HIGHER-SIMPLICIAL-COHOMOLOGY-AND-PENTACHORON-EXACTNESS (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-55.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (21 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking DER-55 pentachoron exactness with DER-56 bridge obligation reductions.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-55.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-55 satisfy input contracts for dependent nodes ['OWE-10', 'IMG-01'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S5_additive_cost_target']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Full chain boundary verification starting from 4-simplex pentachoron through faces to edges to vertices.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 4_LOCAL_GLOBAL_AND_L1_GEOMETRY including DER-55.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-HIGHER-SIMPLICIAL-COHOMOLOGY-AND-PENTACHORON-EXACTNESS across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-55 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Flip a sign in pentachoron d3 coboundary; verify that d3 o d2 = 0 fails closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-HIGHER-SIMPLICIAL-COHOMOLOGY-AND-PENTACHORON-EXACTNESS checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-55).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-55 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-55 causes check failure).

---

#### `DER-13` — OQ-02-RT-04-SIMPLICIAL-COBOUNDARY-AND-VORTEX: F2 vs Z Triangle/Tetrahedron Coboundary d^2 = 0, Orientation Intertwiner, and Vortex Defect (OQ-02 / RT-04)

- **Layer**: `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 9 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/9_oq01_to_oq04_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 9 Lean theorems in LocalGlobalObstruction.lean with propext and Quot.sound. Formalizes simplicial coboundary on a 3-edge cycle, establishing d1 ...
- Prose vs code gap: Prose presents OQ-02 / RT-04 as establishing general simplicial coboundary and gauge obstruction theory. Lean formalization is restricted to a single closed 3-c...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M1_carrier_multiplicity', 'S5_additive_cost_target'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 9 Lean theorems in LocalGlobalObstruction.lean with propext and Quot.sound. Formalizes simplicial coboundary on a 3-edge cycle, establishing d1 o d0 = 0 and detecting vortices. Vulnerability: Hardcoded to a single triangle (3 edges, 3 vertices). Does not generalize constructively to arbitrary cell complexes or higher-dimensional simplices in this module.
- *Prose vs Code*: Prose presents OQ-02 / RT-04 as establishing general simplicial coboundary and gauge obstruction theory. Lean formalization is restricted to a single closed 3-cycle with integer coefficients.
- *Boundaries & Assumptions*: Boundary conditions: Flat cochain (d1 omega = 0); vortex cochain (d1 omega != 0). Unstated assumption: orientation of edges is fixed by index ordering.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 5, Outgoing edges: 15.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M1_carrier_multiplicity', 'S5_additive_cost_target'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem evaluating coboundary on n-gon cycles for arbitrary n >= 3
- [Adversary 1 - Formal Soundness] Python unit test verifying coboundary matrices across all 2^3 = 8 binary cochain configurations.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-13 in existing check script audit/2026-11-05_minimal_chain/9_oq01_to_oq04_checks.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for OQ-02-RT-04-SIMPLICIAL-COBOUNDARY-AND-VORTEX.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking DER-13 cycle coboundary with DER-14 L1 weight symmetry.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-04', 'OWE-03'] satisfy type preconditions and invariants of DER-13.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-13 satisfy input contracts for dependent nodes ['DER-14', 'DER-15', 'IMG-01'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'M1_carrier_multiplicity']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Verification of gauge field propagation around closed cycles in an integrated lattice network.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 4_LOCAL_GLOBAL_AND_L1_GEOMETRY including DER-13.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating OQ-02-RT-04-SIMPLICIAL-COBOUNDARY-AND-VORTEX across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-13 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate d1 definition to add instead of subtract the return edge; verify that d1 (d0 phi) = 0 fails
- [Adversary 1 - Formal Soundness] Alter orientation sign on edge 12; verify that cycle sum fails closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in OQ-02-RT-04-SIMPLICIAL-COBOUNDARY-AND-VORTEX checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-13).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-13 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-13 causes check failure).

---

#### `DER-14` — OQ-07-RT-11-L1-WEIGHT-SYMMETRY: Edge-Transitive vs Non-Transitive Positive L1 Weight Forcing (OQ-07 / RT-11)

- **Layer**: `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 4 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 4 Lean theorems in LocalGlobalObstruction.lean. Establishes L1 weight symmetry on edge-transitive graphs under group actions. Vulnerability: Req...
- Prose vs code gap: Prose suggests general L1 weight symmetry. The Lean theorems explicitly require an transitive edge automorphism group....
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 4 Lean theorems in LocalGlobalObstruction.lean. Establishes L1 weight symmetry on edge-transitive graphs under group actions. Vulnerability: Requires graph to be edge-transitive; on non-edge-transitive graphs, L1 weights can diverge arbitrarily across orbits (as noted in open bridge OWE-09).
- *Prose vs Code*: Prose suggests general L1 weight symmetry. The Lean theorems explicitly require an transitive edge automorphism group.
- *Boundaries & Assumptions*: Boundary conditions: Edge-transitive graphs (single weight); multi-orbit graphs (requires calibration). Unstated assumption: weights are rational scalars.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 3, Outgoing edges: 3.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem demonstrating failure of weight symmetry on bipartite non-regular graphs
- [Adversary 1 - Formal Soundness] Python unit test testing L1 weight allocations across complete vs Petersen graphs.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-14 in existing check script audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for OQ-07-RT-11-L1-WEIGHT-SYMMETRY.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-14 weight symmetry and DER-27 orbit-decomposed weights.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'DER-13'] satisfy type preconditions and invariants of DER-14.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-14 satisfy input contracts for dependent nodes ['OWE-09', 'DER-27', 'DER-49'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S5_additive_cost_target']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Evaluation of L1 weight propagation under graph expansion operations.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 4_LOCAL_GLOBAL_AND_L1_GEOMETRY including DER-14.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating OQ-07-RT-11-L1-WEIGHT-SYMMETRY across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-14 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate automorphism invariance check; verify that weight symmetry theorems fail closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in OQ-07-RT-11-L1-WEIGHT-SYMMETRY checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-14).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-14 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-14 causes check failure).

---

#### `DER-15` — RT-07-RT-08-NATURAL-SECTION-AND-HOLONOMY: Off-Diagonal Fixed-Pair Criterion for Natural Sections and Twisted Holonomy Obstruction (RT-07 / RT-08)

- **Layer**: `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 7 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['scripts/check_primitive_difference.py', 'audit/2026-11-05_minimal_chain/10_post_seal_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 7 Lean theorems in LocalGlobalObstruction.lean. Formalizes natural sections and discrete holonomy around closed loops. Vulnerability: Evaluates ...
- Prose vs code gap: Prose invokes gauge connections and fiber bundle holonomy. The Lean code computes integer sums around cycles of length 3 and 4....
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M1_carrier_multiplicity'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 7 Lean theorems in LocalGlobalObstruction.lean. Formalizes natural sections and discrete holonomy around closed loops. Vulnerability: Evaluates holonomy only for abelian integer gauge groups; does not address non-abelian gauge groups like SU(2) or non-trivial bundles.
- *Prose vs Code*: Prose invokes gauge connections and fiber bundle holonomy. The Lean code computes integer sums around cycles of length 3 and 4.
- *Boundaries & Assumptions*: Boundary conditions: Trivial holonomy (cycle sum = 0); non-trivial holonomy (integer circulation != 0). Unstated assumption: connection coefficients are integer valued.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 3, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M1_carrier_multiplicity'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem establishing non-abelian holonomy composition for 2x2 matrix representations
- [Adversary 1 - Formal Soundness] Python property-based test checking loop holonomy gauge invariance across random gauge transformations.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-15 in existing check script scripts/check_primitive_difference.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for RT-07-RT-08-NATURAL-SECTION-AND-HOLONOMY.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-15 holonomy and DER-52 overlap frustration.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-04', 'DER-13'] satisfy type preconditions and invariants of DER-15.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-15 satisfy input contracts for dependent nodes ['IMG-01', 'DER-52'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'M1_carrier_multiplicity']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Closed-path holonomy tracking verifying that path independence holds iff curvature vanishes.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 4_LOCAL_GLOBAL_AND_L1_GEOMETRY including DER-15.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating RT-07-RT-08-NATURAL-SECTION-AND-HOLONOMY across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-15 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Inject a non-zero flux through a face; verify that natural section existence fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in RT-07-RT-08-NATURAL-SECTION-AND-HOLONOMY checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-15).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-15 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-15 causes check failure).

---

#### `DER-27` — SLICE-XII-ORBIT-DECOMPOSED-COCHAIN-WEIGHTS-GENERAL: Orbit-Decomposed Automorphism-Invariant L1 Cochain Weights on 3-Edge and General n-Edge Cochains (OQ-07 / RT-11)

- **Layer**: `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 10 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py', 'tests/test_orbit_decomposed_l1_weights.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 10 Lean theorems in LocalGlobalObstruction.lean. Formalizes orbit-decomposed cochain weights for general non-edge-transitive graphs. Tested in t...
- Prose vs code gap: Prose claims general orbit-decomposed cochain weighting. Lean formalization confirms orbit constancy, acknowledging that relative scale between distinct orbits ...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 10 Lean theorems in LocalGlobalObstruction.lean. Formalizes orbit-decomposed cochain weights for general non-edge-transitive graphs. Tested in tests/test_orbit_decomposed_l1_weights.py. Vulnerability: Weights are partitioned by orbits, but the cross-orbit weight ratio remains uncalibrated without external fundamental cycle inputs (OWE-09).
- *Prose vs Code*: Prose claims general orbit-decomposed cochain weighting. Lean formalization confirms orbit constancy, acknowledging that relative scale between distinct orbits is not fixed by group symmetry alone.
- *Boundaries & Assumptions*: Boundary conditions: Single-orbit graph (transitive case); two-orbit graph; n-orbit graph with no symmetries. Unstated assumption: orbit decomposition is pre-computed.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 3.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem establishing unique weight determination given k independent cycle cost equations
- [Adversary 1 - Formal Soundness] Python unit test testing orbit decomposition across all small graphs with 4 to 6 vertices.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-27 in existing check script audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for SLICE-XII-ORBIT-DECOMPOSED-COCHAIN-WEIGHTS-GENERAL.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking DER-27 orbit weights with OWE-09 calibration reduction in DER-56.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'DER-13'] satisfy type preconditions and invariants of DER-27.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-27 satisfy input contracts for dependent nodes ['OWE-09', 'DER-48', 'DER-56'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S5_additive_cost_target']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Pipeline test allocating weights to multi-orbit graph and running L1 minimization.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 4_LOCAL_GLOBAL_AND_L1_GEOMETRY including DER-27.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating SLICE-XII-ORBIT-DECOMPOSED-COCHAIN-WEIGHTS-GENERAL across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-27 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Perturb weight on one edge within an orbit; verify that orbit constancy theorems fail closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in SLICE-XII-ORBIT-DECOMPOSED-COCHAIN-WEIGHTS-GENERAL checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-27).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-27 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-27 causes check failure).

---

#### `DER-30` — SLICE-XV-SIMPLICIAL-COCHAIN-EXACTNESS-AND-PRIMAL-DUAL-L1-MIN: Triangle and Tetrahedron Simplicial Cochain Exactness (ker d1 = im d0 on Δ², ker d2 = im d1 on Δ³) and Primal-Dual L1 Minimum Defect Theorem

- **Layer**: `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 6 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py', 'tests/test_orbit_decomposed_l1_weights.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 6 Lean theorems in LocalGlobalObstruction.lean. Formalizes primal-dual L1 minimization on simplicial cochains. Vulnerability: Lean proofs establ...
- Prose vs code gap: Prose claims exact rational primal-dual certified solving. The repository contains no LP solver code; formalization checks duality on pre-selected analytic mini...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M1_carrier_multiplicity', 'S5_additive_cost_target'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 6 Lean theorems in LocalGlobalObstruction.lean. Formalizes primal-dual L1 minimization on simplicial cochains. Vulnerability: Lean proofs establish weak and strong duality on explicit small finite simplicial models; does not implement an executable primal-dual linear programming solver in Lean or Python.
- *Prose vs Code*: Prose claims exact rational primal-dual certified solving. The repository contains no LP solver code; formalization checks duality on pre-selected analytic minimum configurations.
- *Boundaries & Assumptions*: Boundary conditions: Exact cochain (minimum cost = 0); non-exact cochain with positive defect. Unstated assumption: duality gap is zero for L1 norms on finite networks.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 7.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M1_carrier_multiplicity', 'S5_additive_cost_target'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem verifying strong duality on arbitrary finite acyclic cochain complexes
- [Adversary 1 - Formal Soundness] Python unit test implementing an exact rational simplex solver checking duality receipts.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-30 in existing check script audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for SLICE-XV-SIMPLICIAL-COCHAIN-EXACTNESS-AND-PRIMAL-DUAL-L1-MIN.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-30 L1 minimization and DER-51 weak/strong duality.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-30.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-30 satisfy input contracts for dependent nodes ['OWE-10', 'IMG-01', 'DER-47'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'M1_carrier_multiplicity']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Execution of end-to-end defect extraction, linear program generation, and dual certificate verification.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 4_LOCAL_GLOBAL_AND_L1_GEOMETRY including DER-30.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating SLICE-XV-SIMPLICIAL-COCHAIN-EXACTNESS-AND-PRIMAL-DUAL-L1-MIN across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-30 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate primal objective by shifting one coefficient; verify that duality gap becomes positive.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in SLICE-XV-SIMPLICIAL-COCHAIN-EXACTNESS-AND-PRIMAL-DUAL-L1-MIN checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-30).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-30 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-30 causes check failure).

---

#### `DER-38` — WDP-COCHAIN-TRANSPORT-NATURALITY: Witnessed-Difference Contravariant Cochain Pullback, Coboundary Commutation, and Repair-Relation Transport

- **Layer**: `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 4 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 4 Lean theorems in WitnessedDifference.CochainTransport. Formalizes naturality of cochain transport under simplicial maps. Vulnerability: Zero d...
- Prose vs code gap: Prose describes cochain transport naturality as ensuring functorial consistency across reference frames. Lean proofs confirm algebraic functoriality, but runtim...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 4 Lean theorems in WitnessedDifference.CochainTransport. Formalizes naturality of cochain transport under simplicial maps. Vulnerability: Zero dedicated Python tests in tests/ (relies on check_primitive_difference.py). Formalization checks commutativity of pullback with coboundary for declared maps.
- *Prose vs Code*: Prose describes cochain transport naturality as ensuring functorial consistency across reference frames. Lean proofs confirm algebraic functoriality, but runtime mechanization is completely absent in Python.
- *Boundaries & Assumptions*: Boundary conditions: Identity map; constant map; degenerate simplex collapse. Unstated assumption: simplicial maps preserve vertex order.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 5, Outgoing edges: 5.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ for CochainTransport
- [Adversary 1 - Formal Soundness] Lean theorem checking transport under order-reversing maps.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-COCHAIN-TRANSPORT-NATURALITY (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-38.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (4 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test connecting DER-38 cochain transport to DER-48 chain transport bounds.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-38.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-38 satisfy input contracts for dependent nodes ['DER-42', 'DER-47', 'DER-48'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S5_additive_cost_target']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Functorial transport test pulling back a cochain through a composite chain of 5 simplicial morphisms.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 4_LOCAL_GLOBAL_AND_L1_GEOMETRY including DER-38.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-COCHAIN-TRANSPORT-NATURALITY across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-38 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Swap target indices in simplicial pullback; verify that d (f* omega) = f* (d omega) fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-COCHAIN-TRANSPORT-NATURALITY checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-38).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-38 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-38 causes check failure).

---

#### `DER-42` — WDP-GUARDED-HISTORY-COHERENCE-EXACT-BOUNDARIES: Witnessed-Difference Guarded History Coherence, Exact Boundary Annihilation, and Paid Defect Lower Bound

- **Layer**: `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 11 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 11 Lean theorems in WitnessedDifference.GuardedHistoryCoherence. Establishes exact boundaries for guarded history coherence. Vulnerability: Zero...
- Prose vs code gap: Prose describes guarded history coherence as an unassailable boundary protection. Lean formalization establishes coherence for the declared guarded predicate....
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 11 Lean theorems in WitnessedDifference.GuardedHistoryCoherence. Establishes exact boundaries for guarded history coherence. Vulnerability: Zero dedicated Python tests in tests/. Guard conditions are assumed decidable and evaluated at every step without cost modeling.
- *Prose vs Code*: Prose describes guarded history coherence as an unassailable boundary protection. Lean formalization establishes coherence for the declared guarded predicate.
- *Boundaries & Assumptions*: Boundary conditions: Vacuously guarded history; boundary transition violating guard. Unstated assumption: guards cannot be bypassed by asynchronous events.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 6, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ for GuardedHistoryCoherence
- [Adversary 1 - Formal Soundness] Lean theorem establishing non-bypassability under arbitrary event interleavings.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-GUARDED-HISTORY-COHERENCE-EXACT-BOUNDARIES (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-42.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (11 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking DER-42 guarded history with DER-47 root gauge normalization.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-42.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-42 satisfy input contracts for dependent nodes ['DER-50'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S5_additive_cost_target']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Execution trace attempting to inject an unguarded history event, verifying immediate refusal.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 4_LOCAL_GLOBAL_AND_L1_GEOMETRY including DER-42.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-GUARDED-HISTORY-COHERENCE-EXACT-BOUNDARIES across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-42 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Weak guard predicate to permit boundary crossing; verify that coherence proofs fail closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-GUARDED-HISTORY-COHERENCE-EXACT-BOUNDARIES checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-42).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-42 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-42 causes check failure).

---

#### `DER-47` — WDP-ROOT-GAUGE-NORMALIZATION-SPANNING-TREE: Witnessed-Difference Rooted Spanning-Tree Gauge Normalization, Fundamental Cycle Basis, and Unique Tree-Zero Gauge Representative

- **Layer**: `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 16 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 16 Lean theorems in WitnessedDifference.RootGaugeNormalization. Formalizes gauge normalization of integer tables (Table V := V -> V -> Int) rela...
- Prose vs code gap: Prose claims root gauge normalization fixes gauge freedom on spanning trees. Lean code implements a table potential subtraction e(x, y) - e(x, root) + e(y, root...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 16 Lean theorems in WitnessedDifference.RootGaugeNormalization. Formalizes gauge normalization of integer tables (Table V := V -> V -> Int) relative to a designated root. Vulnerability: Zero dedicated Python tests in tests/. Operates on complete tables V -> V -> Int rather than sparse graphs; assumes root is a distinguished element.
- *Prose vs Code*: Prose claims root gauge normalization fixes gauge freedom on spanning trees. Lean code implements a table potential subtraction e(x, y) - e(x, root) + e(y, root), which explicitly preserves loop values and round sums on arbitrary types V.
- *Boundaries & Assumptions*: Boundary conditions: Singleton carrier V (normal is 0); empty carrier; root loops (unaffected by gauge). Unstated assumption: root potential is zero.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 6, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ for RootGaugeNormalization
- [Adversary 1 - Formal Soundness] Lean theorem verifying gauge normalization on sparse edge tables.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-ROOT-GAUGE-NORMALIZATION-SPANNING-TREE (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-47.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (16 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-47 gauge normalization and DER-52 local compatibility.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-47.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-47 satisfy input contracts for dependent nodes ['DER-50'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S5_additive_cost_target']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Table normalization test taking a random 10x10 integer matrix, applying random gauge transformations, and verifying that normal form is invariant.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 4_LOCAL_GLOBAL_AND_L1_GEOMETRY including DER-47.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-ROOT-GAUGE-NORMALIZATION-SPANNING-TREE across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-47 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate normal formula to add instead of subtract potential; verify that idempotence fails
- [Adversary 1 - Formal Soundness] Mutate potential at root to non-zero; verify that normal_column_at_nonroot fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-ROOT-GAUGE-NORMALIZATION-SPANNING-TREE checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-47).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-47 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-47 causes check failure).

---

#### `DER-48` — WDP-SPARSE-CHAIN-TRANSPORT-OPERATOR-BOUNDS: Witnessed-Difference Sparse Chain Transport, Column/Row L1-Linfinity Operator Norm Bounds, and Submultiplicative Composition

- **Layer**: `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 45 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 45 Lean theorems in WitnessedDifference.SparseChainTransportBounds. Establishes operator norm and transport bounds on sparse chain complexes. Vu...
- Prose vs code gap: Prose claims rigorous operator norm bounds governing transport along sparse complexes. The absence of Python numerical checks leaves the bound values unexercise...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 45 Lean theorems in WitnessedDifference.SparseChainTransportBounds. Establishes operator norm and transport bounds on sparse chain complexes. Vulnerability: Zero dedicated Python tests in tests/. While Lean formalization is extensive (45 theorems), there is no executable Python mechanization constructing sparse matrices or computing operator norms.
- *Prose vs Code*: Prose claims rigorous operator norm bounds governing transport along sparse complexes. The absence of Python numerical checks leaves the bound values unexercised dynamically.
- *Boundaries & Assumptions*: Boundary conditions: Zero operator; identity operator; disconnected chain complex. Unstated assumption: matrices have finite bandwidth.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 6, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ evaluating sparse matrix bounds via scipy/numpy
- [Adversary 1 - Formal Soundness] Lean theorem checking tightness of operator norm bounds on extremal graphs.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-SPARSE-CHAIN-TRANSPORT-OPERATOR-BOUNDS (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-48.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (45 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking DER-48 chain transport bounds with DER-49 Trotter characteristic polynomials.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-48.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-48 satisfy input contracts for dependent nodes ['DER-49', 'DER-51'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S5_additive_cost_target']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Simulation of multi-step wave packet transport along a sparse chain verifying that energy bounds are satisfied.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 4_LOCAL_GLOBAL_AND_L1_GEOMETRY including DER-48.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-SPARSE-CHAIN-TRANSPORT-OPERATOR-BOUNDS across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-48 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Perturb a sparse matrix entry above the declared bound; verify that transport inequality fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-SPARSE-CHAIN-TRANSPORT-OPERATOR-BOUNDS checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-48).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-48 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-48 causes check failure).

---

#### `DER-49` — WDP-TROTTER-CHAR-POLY-SPECTRAL-INVARIANCE: Witnessed-Difference Cyclic Product Trace/Determinant Invariance, 3x3 Characteristic Polynomial Identity, and Word-Reversal Transpose Law

- **Layer**: `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 33 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 33 Lean theorems in WitnessedDifference.TrotterCharPoly. CRITICAL STRUCTURAL FINDING: All 33 theorems in TrotterCharPoly.lean check trivial inte...
- Prose vs code gap: Prose claims spectral invariance of Trotter characteristic polynomials. Lean formalization only checks arithmetic identities on hardcoded rational constants. Th...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S3_endomorphism_composition', 'M1_carrier_multiplicity', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 33 Lean theorems in WitnessedDifference.TrotterCharPoly. CRITICAL STRUCTURAL FINDING: All 33 theorems in TrotterCharPoly.lean check trivial integer identities of the form `den * num - num * den = 0` (evalCleared) on pre-declared rational constants for M = 1, 2, 3! The module docstring explicitly states: 'This file does not build the response matrix and does not derive a characteristic polynomial. The Python module code/trotter_characteristic_polynomials.py is the calculator for those matrices.' However, code/trotter_characteristic_polynomials.py DOES NOT EXIST in this repository! The repository has ZERO mechanization code computing Trotter response matrices, characteristic polynomials, or eigenvalues.
- *Prose vs Code*: Prose claims spectral invariance of Trotter characteristic polynomials. Lean formalization only checks arithmetic identities on hardcoded rational constants. The mechanization facet is missing its calculator.
- *Boundaries & Assumptions*: Boundary conditions: M = 1 (dim 8); M = 2 (dim 16); M = 3 (dim 24). Unstated assumption: rational root constants imported from external calculations are correct.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 6, Outgoing edges: 0.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S3_endomorphism_composition', 'M1_carrier_multiplicity', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Port and integrate code/trotter_characteristic_polynomials.py into scripts/ with unit tests in tests/
- [Adversary 1 - Formal Soundness] Lean theorem verifying that the characteristic polynomial has the declared roots.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-TROTTER-CHAR-POLY-SPECTRAL-INVARIANCE (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-49.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (33 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test connecting Trotter polynomial calculation with DER-48 operator bounds.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-49.
- [Adversary 2 - Mechanization] Terminal boundary integration tests checking that DER-49 exports valid terminal invariants or extension interfaces.
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S3_endomorphism_composition']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Full pipeline building Trotter response matrix from graph laplacians, evaluating char poly, and confirming root spectrum invariance.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 4_LOCAL_GLOBAL_AND_L1_GEOMETRY including DER-49.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-TROTTER-CHAR-POLY-SPECTRAL-INVARIANCE across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-49 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate one declared numerator constant by +1; verify that evalCleared fails closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-TROTTER-CHAR-POLY-SPECTRAL-INVARIANCE checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-49).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-49 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-49 causes check failure).

---

#### `DER-50` — WDP-BATCH9-PRIMAL-DUAL-REPAIR-SYNTHESIS: Witnessed-Difference Batch-9 Primal-Dual Repair Synthesis, Quotient Descent Stability, and Holonomy Defect Certification

- **Layer**: `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 18 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 18 Lean theorems in WitnessedDifference.WdpBatch9. Formalizes primal-dual repair synthesis and L1 gauge optimization. Vulnerability: Zero dedica...
- Prose vs code gap: Prose describes Batch 9 primal-dual repair synthesis as an algorithmic resolution of gauge defects. Lean proofs confirm optimality for declared witness pairs wi...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 18 Lean theorems in WitnessedDifference.WdpBatch9. Formalizes primal-dual repair synthesis and L1 gauge optimization. Vulnerability: Zero dedicated Python tests in tests/. Formalization is an analytic verification of dual feasibility for declared solutions; it contains no solver algorithm.
- *Prose vs Code*: Prose describes Batch 9 primal-dual repair synthesis as an algorithmic resolution of gauge defects. Lean proofs confirm optimality for declared witness pairs without mechanizing the synthesis search.
- *Boundaries & Assumptions*: Boundary conditions: Zero defect (no repair needed); maximal defect. Unstated assumption: primal and dual feasible sets are non-empty.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 6, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ for WdpBatch9 repair synthesis
- [Adversary 1 - Formal Soundness] Lean theorem checking complementary slackness conditions.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-BATCH9-PRIMAL-DUAL-REPAIR-SYNTHESIS (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-50.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (18 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-50 repair synthesis and DER-51 obstruction cohomology.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-50.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-50 satisfy input contracts for dependent nodes ['DER-51'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S5_additive_cost_target']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] End-to-end synthesis run taking an obstructed cochain and generating certified primal and dual receipts.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 4_LOCAL_GLOBAL_AND_L1_GEOMETRY including DER-50.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-BATCH9-PRIMAL-DUAL-REPAIR-SYNTHESIS across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-50 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate dual witness so that feasibility is violated; verify that duality gap check fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-BATCH9-PRIMAL-DUAL-REPAIR-SYNTHESIS checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-50).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-50 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-50 causes check failure).

---

#### `DER-51` — WDP-OBSTRUCTION-COHOMOLOGY-AND-WEAK-STRONG-DUALITY: Witnessed-Difference Repair Quotient H^1 = C^1 / im(d0), Exact Sequence ker(kappa) = im(d0), Weak/Strong L1-Linfinity Duality, and Filled-Triangle Operator Norm

- **Layer**: `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 31 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 31 Lean theorems in WitnessedDifference.Obstruction. Establishes obstruction cohomology, weak duality, and strong duality for 1-cochains and 2-c...
- Prose vs code gap: Prose presents obstruction cohomology and duality as the definitive mathematical spine of the program. Lean formalization is sound for the declared finite windo...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 31 Lean theorems in WitnessedDifference.Obstruction. Establishes obstruction cohomology, weak duality, and strong duality for 1-cochains and 2-cochains. Vulnerability: Zero dedicated Python tests in tests/. Duality is established on designated combinatorial windows; does not generalize to infinite cell complexes.
- *Prose vs Code*: Prose presents obstruction cohomology and duality as the definitive mathematical spine of the program. Lean formalization is sound for the declared finite window complexes, but lacks dynamic Python execution.
- *Boundaries & Assumptions*: Boundary conditions: Closed cochains; exact cochains; non-closed cochains. Unstated assumption: coboundary operators are linear maps over Int.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 8, Outgoing edges: 4.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ for Obstruction module
- [Adversary 1 - Formal Soundness] Lean theorem verifying that weak duality holds for arbitrary real-valued cochains.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-OBSTRUCTION-COHOMOLOGY-AND-WEAK-STRONG-DUALITY (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-51.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (31 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking DER-51 obstruction cohomology with DER-52 local compatibility.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-51.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-51 satisfy input contracts for dependent nodes ['DER-52', 'DER-53', 'DER-54'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S5_additive_cost_target']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Cohomology calculation on a multi-simplex complex verifying that Betti numbers match topological invariants.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 4_LOCAL_GLOBAL_AND_L1_GEOMETRY including DER-51.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-OBSTRUCTION-COHOMOLOGY-AND-WEAK-STRONG-DUALITY across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-51 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Flip a sign in the coboundary operator; verify that d1 o d0 = 0 and strong duality fail.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-OBSTRUCTION-COHOMOLOGY-AND-WEAK-STRONG-DUALITY checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-51).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-51 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-51 causes check failure).

---

### Layer: 5_INTERNAL_METATHEORY (7 Nodes)

#### `DER-56` — WDP-BRIDGE-OBLIGATION-REDUCTIONS-OWE07-TO-OWE13: Constructive Five-Obligation Ledger Algebra and Minimal-Premise Reductions for OWE-07, OWE-08, OWE-09, OWE-12, and OWE-13

- **Layer**: `5_INTERNAL_METATHEORY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 18 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 18 Lean theorems in WitnessedDifference.BridgeObligationReductions with propext only. Formalizes minimal-premise algebraic reductions for the 5 ...
- Prose vs code gap: Prose treats DER-56 as isolating the exact minimal premises needed to close the remaining gaps. Lean formalization confirms the mathematical equivalences, but t...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S4_retention_state_bit', 'S5_additive_cost_target', 'M1_carrier_multiplicity', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 18 Lean theorems in WitnessedDifference.BridgeObligationReductions with propext only. Formalizes minimal-premise algebraic reductions for the 5 open bridge obligations: OWE-07 (fixed-point witness exhaustion), OWE-08 (sheet-flip holonomy selection via 2-step irreflexivity), OWE-09 (2-orbit cycle calibration), OWE-12 (multi-locus view decomposition and cost budget compensation), and OWE-13 (shortcut-edge repair). Vulnerability: These are conditional reductions, not unconditional discharges. The 5 bridge obligations remain OPEN in the DAG.
- *Prose vs Code*: Prose treats DER-56 as isolating the exact minimal premises needed to close the remaining gaps. Lean formalization confirms the mathematical equivalences, but the premises themselves remain unsupplied.
- *Boundaries & Assumptions*: Boundary conditions: Five-obligation status vector; rank 0 (Open), rank 1 (ControlOnly), rank 2 (Discharged). Unstated assumption: bridge obligations are mutually independent.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 7, Outgoing edges: 5.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S4_retention_state_bit', 'S5_additive_cost_target', 'M1_carrier_multiplicity', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ for BridgeObligationReductions
- [Adversary 1 - Formal Soundness] Lean theorem demonstrating that Status.rank is strictly monotonic.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-BRIDGE-OBLIGATION-REDUCTIONS-OWE07-TO-OWE13 (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-56.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (18 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test verifying that DER-56 references all 5 open bridge IDs in its audit schema.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-56.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-56 satisfy input contracts for dependent nodes ['OWE-07', 'OWE-08', 'OWE-09'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S4_retention_state_bit']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Status vector audit confirming that no derivation claims discharge without all 5 obligations reaching rank 2.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 5_INTERNAL_METATHEORY including DER-56.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-BRIDGE-OBLIGATION-REDUCTIONS-OWE07-TO-OWE13 across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-56 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate two_step_irreflexivity condition in OWE-08 reduction; verify that step4Sheet uniqueness fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-BRIDGE-OBLIGATION-REDUCTIONS-OWE07-TO-OWE13 checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-56).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-56 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-56 causes check failure).

---

#### `DER-16` — WDP-CH03-CONSTITUTIONAL-INITIALITY-AND-RETRACT: Six-Guard Constitutional Self-Description, Behavioral Initiality, and Conservative Retract

- **Layer**: `5_INTERNAL_METATHEORY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 8 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['scripts/check_primitive_difference.py', 'audit/2026-11-05_minimal_chain/10_post_seal_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 8 Lean theorems in InternalMetatheory.lean with propext and Quot.sound. Formalizes constitutional initiality and retract properties. Vulnerabili...
- Prose vs code gap: Prose claims constitutional initiality as an overarching metatheoretical property. Lean formalization establishes retract properties for designated endomorphism...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S1_off_diagonal_pair_witness'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 8 Lean theorems in InternalMetatheory.lean with propext and Quot.sound. Formalizes constitutional initiality and retract properties. Vulnerability: Initiality is established within a restricted sub-category of models defined in the module; it does not establish initiality across the entirety of constructive type theory.
- *Prose vs Code*: Prose claims constitutional initiality as an overarching metatheoretical property. Lean formalization establishes retract properties for designated endomorphisms.
- *Boundaries & Assumptions*: Boundary conditions: Identity retract; trivial initial object. Unstated assumption: category of models has well-defined morphisms.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 3, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S1_off_diagonal_pair_witness'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem establishing uniqueness of the initial morphism up to unique isomorphism
- [Adversary 1 - Formal Soundness] Python unit test verifying retract composition laws on finite models.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-16 in existing check script scripts/check_primitive_difference.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for WDP-CH03-CONSTITUTIONAL-INITIALITY-AND-RETRACT.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-16 initiality and DER-17 diagonal tower.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-02', 'DER-02'] satisfy type preconditions and invariants of DER-16.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-16 satisfy input contracts for dependent nodes ['DER-19'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S1_off_diagonal_pair_witness']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Verification of retract stability across layered model extensions.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 5_INTERNAL_METATHEORY including DER-16.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-CH03-CONSTITUTIONAL-INITIALITY-AND-RETRACT across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-16 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate retract projection to not be identity on the retract image; verify that initiality checks fail closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-CH03-CONSTITUTIONAL-INITIALITY-AND-RETRACT checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-16).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-16 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-16 causes check failure).

---

#### `DER-17` — WDP-CH04-NO-OUTSIDE-AND-DIAGONAL-TOWER: Effectual-Outside Dichotomy, Panel Equivalence, and Interpreter Diagonal Non-Exhaustion

- **Layer**: `5_INTERNAL_METATHEORY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 10 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['scripts/check_primitive_difference.py', 'audit/2026-11-05_minimal_chain/10_post_seal_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 10 Lean theorems in InternalMetatheory.lean. Formalizes the 'no-outside' condition and diagonal tower construction. Vulnerability: Operates with...
- Prose vs code gap: Prose claims that the model admits no external ambient space. Lean code establishes that diagonal embeddings are self-contained within the declared carrier hier...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 10 Lean theorems in InternalMetatheory.lean. Formalizes the 'no-outside' condition and diagonal tower construction. Vulnerability: Operates within internal type-theoretic reflection; assumes inductive types do not leak untracked indices.
- *Prose vs Code*: Prose claims that the model admits no external ambient space. Lean code establishes that diagonal embeddings are self-contained within the declared carrier hierarchy.
- *Boundaries & Assumptions*: Boundary conditions: Tower base level 0; tower level n -> n + 1. Unstated assumption: universe levels are finite.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 3, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem verifying that tower steps cannot be bypassed by diagonal projections
- [Adversary 1 - Formal Soundness] Python unit test testing diagonal tower indexing.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-17 in existing check script scripts/check_primitive_difference.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for WDP-CH04-NO-OUTSIDE-AND-DIAGONAL-TOWER.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-17 diagonal tower and DER-18 monotonic no-return.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'DER-06', 'DER-09'] satisfy type preconditions and invariants of DER-17.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-17 satisfy input contracts for dependent nodes ['DER-19', 'IMG-10'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Multi-level tower traversal checking that higher levels embed lower levels without leakage.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 5_INTERNAL_METATHEORY including DER-17.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-CH04-NO-OUTSIDE-AND-DIAGONAL-TOWER across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-17 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate tower step to allow downward projection; verify that no-outside invariants fail.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-CH04-NO-OUTSIDE-AND-DIAGONAL-TOWER checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-17).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-17 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-17 causes check failure).

---

#### `DER-18` — WDP-CH06-MONOTONIC-NO-RETURN: Monotonic Cumulative Measure and Strict No-Return Law

- **Layer**: `5_INTERNAL_METATHEORY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 6 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['scripts/check_primitive_difference.py', 'audit/2026-11-05_minimal_chain/10_post_seal_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 6 Lean theorems in InternalMetatheory.lean. Establishes monotonic no-return, ensuring that state transitions along designated trajectories never...
- Prose vs code gap: Prose describes monotonic no-return as an intrinsic arrow of operational time. Lean formalization establishes strict inequality along a declared integer progres...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 6 Lean theorems in InternalMetatheory.lean. Establishes monotonic no-return, ensuring that state transitions along designated trajectories never return to previously occupied states. Vulnerability: Monotonicity depends on an external progress measure; if the progress measure is bounded or non-strictly increasing, cycle recurrence is not precluded.
- *Prose vs Code*: Prose describes monotonic no-return as an intrinsic arrow of operational time. Lean formalization establishes strict inequality along a declared integer progress function.
- *Boundaries & Assumptions*: Boundary conditions: Constant progress measure (fails no-return); strictly increasing measure. Unstated assumption: progress measure codomain is an ordered set with no infinite descending chains.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 3, Outgoing edges: 3.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem checking that any non-strict progress measure admits cycle formation
- [Adversary 1 - Formal Soundness] Python property-based test checking monotonicity across random transition traces.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-18 in existing check script scripts/check_primitive_difference.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for WDP-CH06-MONOTONIC-NO-RETURN.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking DER-18 no-return with DER-35 acyclic reachability.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-04', 'DER-06'] satisfy type preconditions and invariants of DER-18.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-18 satisfy input contracts for dependent nodes ['DER-19', 'IMG-09', 'DER-35'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'M3_step_history_dynamics']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Cycle detection audit across a 1000-step trace verifying that no state hash repeats.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 5_INTERNAL_METATHEORY including DER-18.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-CH06-MONOTONIC-NO-RETURN across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-18 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate progress measure increment from +1 to 0; verify that monotonic no-return theorem fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-CH06-MONOTONIC-NO-RETURN checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-18).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-18 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-18 causes check failure).

---

#### `DER-19` — AUDIT-MINIMAL-CHAIN-CAMPAIGNS-1-TO-3: Minimal Chain Audit, OQ-08 Guard Discrepancy Regressions, and Adapted 5-Gate Commutation (OQ-01 to OQ-08, RT-01 to RT-12)

- **Layer**: `5_INTERNAL_METATHEORY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 5 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/2_mark_checks.py', 'audit/2026-11-05_minimal_chain/3_regime_deletions.py', 'audit/2026-11-05_minimal_chain/4_frozen_checks.py', 'audit/2026-11-05_minimal_chain/5_forcing_checks.py', 'audit/2026-11-05_minimal_chain/9_oq01_to_oq04_checks.py', 'audit/2026-11-05_minimal_chain/10_post_seal_checks.py', 'audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 5 Lean theorems in InternalMetatheory.lean. Formalizes multi-campaign consistency checks across audit campaigns 1, 2, and 3. Vulnerability: Chec...
- Prose vs code gap: Prose presents this as cross-campaign audit validation. Lean code verifies equality of summary record fields....
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 5 Lean theorems in InternalMetatheory.lean. Formalizes multi-campaign consistency checks across audit campaigns 1, 2, and 3. Vulnerability: Checks consistency of designated campaign summary records; does not re-execute the campaigns.
- *Prose vs Code*: Prose presents this as cross-campaign audit validation. Lean code verifies equality of summary record fields.
- *Boundaries & Assumptions*: Boundary conditions: Empty campaign ledger; mismatched campaign checksums. Unstated assumption: campaign records are immutable.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem verifying that campaign reconciliation fails upon record mutation
- [Adversary 1 - Formal Soundness] Python unit test testing campaign record schema validation.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-19 in existing check script audit/2026-11-05_minimal_chain/2_mark_checks.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for AUDIT-MINIMAL-CHAIN-CAMPAIGNS-1-TO-3.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-19 campaign audit and DER-20 genesis baseline.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'DER-16', 'DER-17'] satisfy type preconditions and invariants of DER-19.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-19 satisfy input contracts for dependent nodes ['DER-28'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Complete campaign hash tree recomputation from genesis to present.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 5_INTERNAL_METATHEORY including DER-19.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating AUDIT-MINIMAL-CHAIN-CAMPAIGNS-1-TO-3 across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-19 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Alter a checksum in campaign 2 summary; verify that audit validation raises an error.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in AUDIT-MINIMAL-CHAIN-CAMPAIGNS-1-TO-3 checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-19).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-19 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-19 causes check failure).

---

#### `DER-20` — EVIDENCE-SEED-AUDIT-BASELINE: Anchored Historical Seed Audit Record and Hash Manifest

- **Layer**: `5_INTERNAL_METATHEORY` | **Bucket**: `DERIVED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['scripts/verify_genesis_record.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as NON_PERFECTED (lacks Lean 4 formalization; 0 Lean theorems). Verified exclusively in Python via scripts/verify_genesis_record.py and tests/test_ve...
- Prose vs code gap: Prose acknowledges DER-20 as an empirical seed-record baseline. Python checks confirm hash integrity, but no type-theoretic formalization exists....
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as NON_PERFECTED (lacks Lean 4 formalization; 0 Lean theorems). Verified exclusively in Python via scripts/verify_genesis_record.py and tests/test_verify_genesis_record.py. Audits cryptographic SHA-256 hashes of the original chat transcript and genesis records. Vulnerability: Entirely unformalized in Lean; functions as an empirical historical anchor rather than a mathematical derivation.
- *Prose vs Code*: Prose acknowledges DER-20 as an empirical seed-record baseline. Python checks confirm hash integrity, but no type-theoretic formalization exists.
- *Boundaries & Assumptions*: Boundary conditions: Corrupted transcript; altered publication anchor hash. Unstated assumption: SHA-256 is collision-resistant.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 1, Outgoing edges: 0.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Constructive Lean 4 formalization of transcript merkle tree verification
- [Adversary 1 - Formal Soundness] Python unit tests for partial transcript corruption and byte-level bit flips.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-20 in existing check script scripts/verify_genesis_record.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for EVIDENCE-SEED-AUDIT-BASELINE.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test verifying that DER-20 hash outputs feed into DER-32 genesis construction.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01'] satisfy type preconditions and invariants of DER-20.
- [Adversary 2 - Mechanization] Terminal boundary integration tests checking that DER-20 exports valid terminal invariants or extension interfaces.
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Full raw-file hash audit verifying that genesis files match published external hashes.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 5_INTERNAL_METATHEORY including DER-20.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating EVIDENCE-SEED-AUDIT-BASELINE across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-20 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Flip a single bit in the genesis transcript JSON; verify that verify_genesis_record.py exits with non-zero code.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in EVIDENCE-SEED-AUDIT-BASELINE checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-20).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-20 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-20 causes check failure).

---

#### `DER-28` — SLICE-XIII-SINGLETON-VIEW-EMBEDDING-AND-FULL-REPLAY-BRIDGE: FullWDPWorld Multi-Step Trace Replay Commutation and Exact Singleton-View HWorld-to-Represented Guard Equivalence

- **Layer**: `5_INTERNAL_METATHEORY` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 6 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py', 'tests/test_orbit_decomposed_l1_weights.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 6 Lean theorems in InternalMetatheory.lean. Formalizes singleton view embedding and full replay verification. Vulnerability: Embeds singleton vi...
- Prose vs code gap: Prose describes this as demonstrating that single-point views capture full multi-locus information. Lean theorems establish the embedding for declared singleton...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S4_retention_state_bit', 'S5_additive_cost_target'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 6 Lean theorems in InternalMetatheory.lean. Formalizes singleton view embedding and full replay verification. Vulnerability: Embeds singleton views into full guard traces under the assumption that views commute.
- *Prose vs Code*: Prose describes this as demonstrating that single-point views capture full multi-locus information. Lean theorems establish the embedding for declared singleton projection maps.
- *Boundaries & Assumptions*: Boundary conditions: Empty view; singleton view; multi-point view. Unstated assumption: view projections are surjective.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S4_retention_state_bit', 'S5_additive_cost_target'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem evaluating view embedding failure when views overlap non-trivially
- [Adversary 1 - Formal Soundness] Python unit test testing view reconstruction across multiple overlapping windows.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-28 in existing check script audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for SLICE-XIII-SINGLETON-VIEW-EMBEDDING-AND-FULL-REPLAY-BRIDGE.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-28 view embedding and DER-12 horizon morphisms.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'DER-09'] satisfy type preconditions and invariants of DER-28.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-28 satisfy input contracts for dependent nodes ['OWE-12', 'DER-56'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S4_retention_state_bit']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Replay execution reconstructing full system trajectory from singleton observation slices.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 5_INTERNAL_METATHEORY including DER-28.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating SLICE-XIII-SINGLETON-VIEW-EMBEDDING-AND-FULL-REPLAY-BRIDGE across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-28 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Perturb view projection function; verify that embedding commutativity fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in SLICE-XIII-SINGLETON-VIEW-EMBEDDING-AND-FULL-REPLAY-BRIDGE checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-28).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-28 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-28 causes check failure).

---

### Layer: 0_HOST_AND_ADMISSIONS (4 Nodes)

#### `OWE-01` — S0-HOST-SUBSTRATE: Constructive Type-Theoretic Host Substrate (S0)

- **Layer**: `0_HOST_AND_ADMISSIONS` | **Bucket**: `OWED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Carries 0 Lean 4 theorems. The entire formal framework relies on the constructive dependent type theory of Lean 4.33.0 (inductive types, function types, equalit...
- Prose vs code gap: Mathematical prose correctly catalogs S0 as an explicit admission, but downstream narratives frequently appeal to type-theoretic naturality without acknowledgin...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Carries 0 Lean 4 theorems. The entire formal framework relies on the constructive dependent type theory of Lean 4.33.0 (inductive types, function types, equality, quotients, and axioms propext and Quot.sound) as an extrinsic host environment. This substrate is an unpriced structural admission rather than a derived consequence of the initial mark. There is no internal proof of consistency or independence for this host substrate within the formalization.
- *Prose vs Code*: Mathematical prose correctly catalogs S0 as an explicit admission, but downstream narratives frequently appeal to type-theoretic naturality without acknowledging that all constructive operations presuppose this multi-universe foundation. The Python check script (check_primitive_difference.py) checks only that forbidden axioms like Classical.choice are absent, rather than verifying any property of S0 itself.
- *Boundaries & Assumptions*: Assumes the standard Lean 4 core kernel semantics. Implicitly assumes the consistency of constructive type theory with propositional extensionality and quotient computation. Boundary condition: any attempt to formalize omega_codex on a weaker constructive system (e.g., pure intuitionistic logic without quotients) would immediately break all quotient-based residual constructions.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 0, Outgoing edges: 56.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean core minimal-axiom test checking whether any proof genuinely requires both propext and Quot.sound, or if a strict subset suffices
- [Adversary 1 - Formal Soundness] Python unit test validating that host environment configuration parameters (recursion depth, memory limit) fail closed upon degradation.
- [Adversary 2 - Mechanization] Unit tests validating formal specification and boundary conditions for OWE-01 (S0-HOST-SUBSTRATE).
- [Adversary 2 - Mechanization] Negative control unit tests verifying that violating declared admission ['S0_lean_core_host'] triggers explicit validation failure.
- [Adversary 2 - Mechanization] Parametric variation unit tests over candidate carrier and pricing bounds for OWE-01.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Integration contract between host substrate S0 and mark instantiation OWE-02, testing whether type-level definitions in S0 cleanly isolate from object-level relations.
- [Adversary 2 - Mechanization] Root substrate initialization integration tests ensuring host admissions cleanly bootstrap OWE-01.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of OWE-01 satisfy input contracts for dependent nodes ['DER-01', 'DER-02', 'DER-03'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Toolchain version reproducibility test confirming that bootstrapping the derivation graph under a different Lean toolchain release reproduces identical theorem hashes without behavioral drift.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 0_HOST_AND_ADMISSIONS including OWE-01.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating S0-HOST-SUBSTRATE across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for OWE-01 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Inject Classical.choice into the environment; verify that check_primitive_difference.py rejects the build with non-zero exit
- [Adversary 1 - Formal Soundness] Disable Quot.sound; verify that quotient-dependent modules fail closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in S0-HOST-SUBSTRATE checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in OWE-01).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into OWE-01 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in OWE-01 causes check failure).

---

#### `OWE-02` — S1-INHABITED-OFFDIAGONAL-PAIR: Inhabited Off-Diagonal Mark Witness (S1)

- **Layer**: `0_HOST_AND_ADMISSIONS` | **Bucket**: `OWED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 1 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/2_mark_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Contains 1 Lean theorem (offdiag_nonempty_iff in TorsorAndOperations.lean). While sound for the concrete two-element type Bool, the formalization establishes of...
- Prose vs code gap: Prose describes S1 as the initial mark witness required to instantiate concrete difference from '<>'. The Lean formalization, however, begins with Bool as an al...
- Admissions dependency: Relies on unpriced inputs ['S1_off_diagonal_pair_witness'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Contains 1 Lean theorem (offdiag_nonempty_iff in TorsorAndOperations.lean). While sound for the concrete two-element type Bool, the formalization establishes off-diagonal classification exclusively for binary relations on Bool. It does not establish why an inhabited off-diagonal witness must exist in an arbitrary constructive type, nor does it derive the emergence of an off-diagonal pair from an empty substrate.
- *Prose vs Code*: Prose describes S1 as the initial mark witness required to instantiate concrete difference from '<>'. The Lean formalization, however, begins with Bool as an already-instantiated two-constructor inductive type, bypassing the genesis problem of how distinct constructors arise.
- *Boundaries & Assumptions*: Boundary conditions: Empty type (Empty) and singleton type (Unit), where no irreflexive binary relation can be non-empty. Unstated assumption: carrier cardinality is at least 2.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 0, Outgoing edges: 5.
- *Admission Traceability*: Declared unpriced admissions: ['S1_off_diagonal_pair_witness'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem establishing that for any type alpha with Subsingleton alpha, every irreflexive relation is empty
- [Adversary 1 - Formal Soundness] Python property-based test checking refusal of singleton and empty carrier inputs.
- [Adversary 2 - Mechanization] Unit tests validating formal specification and boundary conditions for OWE-02 (S1-INHABITED-OFFDIAGONAL-PAIR).
- [Adversary 2 - Mechanization] Negative control unit tests verifying that violating declared admission ['S1_off_diagonal_pair_witness'] triggers explicit validation failure.
- [Adversary 2 - Mechanization] Parametric variation unit tests over candidate carrier and pricing bounds for OWE-02.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between S1 pair witness admission and DER-01 primitive difference, verifying that passing an empty witness raises a formal refusal.
- [Adversary 2 - Mechanization] Root substrate initialization integration tests ensuring host admissions cleanly bootstrap OWE-02.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of OWE-02 satisfy input contracts for dependent nodes ['DER-01', 'DER-02', 'DER-16'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S1_off_diagonal_pair_witness']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Trace verification ensuring that no node in Layers 1 through 5 can be evaluated if the S1 admission edge is severed.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 0_HOST_AND_ADMISSIONS including OWE-02.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating S1-INHABITED-OFFDIAGONAL-PAIR across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for OWE-02 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate the witness (a, b) to an identical pair (a, a); verify that irreflexivity checking fails immediately
- [Adversary 1 - Formal Soundness] Flip offdiag_nonempty_iff disjunction to conjunction; verify that census test fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in S1-INHABITED-OFFDIAGONAL-PAIR checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in OWE-02).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into OWE-02 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in OWE-02 causes check failure).

---

#### `OWE-03` — S2-S5-SYMMETRY-COMPOSITION-RETENTION-COST: Symmetry Extension, Composition Law, Retention Axis, and Cost Target Admissions (S2-S5)

- **Layer**: `0_HOST_AND_ADMISSIONS` | **Bucket**: `OWED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/10_post_seal_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Carries 0 Lean 4 theorems. Represents four bundled structural admissions: symmetric closure (S2), endomorphism composition (S3), retention state bit (S4), and a...
- Prose vs code gap: Prose treats S2 through S5 as foundational structural admissions. Mechanization in 10_post_seal_checks.py evaluates toy arithmetic pricing for selected traces, ...
- Admissions dependency: Relies on unpriced inputs ['S2_symmetric_closure', 'S3_endomorphism_composition', 'S4_retention_state_bit', 'S5_additive_cost_target'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Carries 0 Lean 4 theorems. Represents four bundled structural admissions: symmetric closure (S2), endomorphism composition (S3), retention state bit (S4), and additive norm cost target (S5). Bundling these four distinct operations masks their independent structural costs and obscures whether a subset could suffice for intermediate stages.
- *Prose vs Code*: Prose treats S2 through S5 as foundational structural admissions. Mechanization in 10_post_seal_checks.py evaluates toy arithmetic pricing for selected traces, but provides no formalization of the algebraic properties of composition or metric norms.
- *Boundaries & Assumptions*: Boundary conditions: Zero additive cost target (c = 0), which permits unbounded unpriced state generation; stateless systems (absence of S4 bit), which collapse multi-round memory. Unstated assumption: cost addition satisfies Archimedean ordering over the integers.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 0, Outgoing edges: 34.
- *Admission Traceability*: Declared unpriced admissions: ['S2_symmetric_closure', 'S3_endomorphism_composition', 'S4_retention_state_bit', 'S5_additive_cost_target'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Formal pairwise independence proofs for S2, S3, S4, and S5
- [Adversary 1 - Formal Soundness] Python property-based tests checking cost monotonicity under strictly positive additive weights.
- [Adversary 2 - Mechanization] Unit tests validating formal specification and boundary conditions for OWE-03 (S2-S5-SYMMETRY-COMPOSITION-RETENTION-COST).
- [Adversary 2 - Mechanization] Negative control unit tests verifying that violating declared admission ['S2_symmetric_closure', 'S3_endomorphism_composition', 'S4_retention_state_bit', 'S5_additive_cost_target'] triggers explicit validation failure.
- [Adversary 2 - Mechanization] Parametric variation unit tests over candidate carrier and pricing bounds for OWE-03.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam tests verifying that disabling S4 (retention bit) disables multi-round separation in DER-06, and disabling S5 disables L1 weight minimization in DER-30.
- [Adversary 2 - Mechanization] Root substrate initialization integration tests ensuring host admissions cleanly bootstrap OWE-03.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of OWE-03 satisfy input contracts for dependent nodes ['DER-02', 'DER-04', 'DER-07'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S2_symmetric_closure', 'S3_endomorphism_composition']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Cost-accounting audit tracing cumulative S5 budget consumption across full execution paths from Layer 1 to Layer 5.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 0_HOST_AND_ADMISSIONS including OWE-03.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating S2-S5-SYMMETRY-COMPOSITION-RETENTION-COST across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for OWE-03 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate cost target from additive norm to non-subadditive pseudo-norm; verify that triangle inequalities fail
- [Adversary 1 - Formal Soundness] Set c_adm = 0 and c_ret = 0; verify that budget-gated pruning permits unbounded loops.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in S2-S5-SYMMETRY-COMPOSITION-RETENTION-COST checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in OWE-03).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into OWE-03 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in OWE-03 causes check failure).

---

#### `OWE-04` — M1-M3-UNFREEZING-MECHANISMS: Post-Seal Unfreezing Mechanisms: Multiplicity, Indexed Family, or Dynamics (M1-M3)

- **Layer**: `0_HOST_AND_ADMISSIONS` | **Bucket**: `OWED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/4_frozen_checks.py', 'audit/2026-11-05_minimal_chain/10_post_seal_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Carries 0 Lean 4 theorems. Catalogs three post-seal unfreezing mechanisms: carrier multiplicity |alpha| >= 3 (M1), indexed family of contexts (M2), and step/his...
- Prose vs code gap: Prose emphasizes that S2Bool is completely frozen at cardinality 2 under C2 automorphisms. Mechanization in 4_frozen_checks.py and 10_post_seal_checks.py verifi...
- Admissions dependency: Relies on unpriced inputs ['M1_carrier_multiplicity', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Carries 0 Lean 4 theorems. Catalogs three post-seal unfreezing mechanisms: carrier multiplicity |alpha| >= 3 (M1), indexed family of contexts (M2), and step/history dynamics (M3). It is an extrinsic selection catalog rather than a constructive derivation.
- *Prose vs Code*: Prose emphasizes that S2Bool is completely frozen at cardinality 2 under C2 automorphisms. Mechanization in 4_frozen_checks.py and 10_post_seal_checks.py verifies that C2 has only one non-identity involution, but provides no mechanized criterion for choosing among M1, M2, or M3.
- *Boundaries & Assumptions*: Boundary conditions: Cardinality |alpha| = 2 (system remains frozen); single static context without indexing; zero execution steps. Unstated assumption: unfreezing mechanisms are independent and composable.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 0, Outgoing edges: 39.
- *Admission Traceability*: Declared unpriced admissions: ['M1_carrier_multiplicity', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem establishing that any relation-preserving endomap on (Bool, S2Bool) has order dividing 2
- [Adversary 1 - Formal Soundness] Python unit test verifying that frozen state space admits no non-trivial 3-cycles.
- [Adversary 2 - Mechanization] Unit tests validating formal specification and boundary conditions for OWE-04 (M1-M3-UNFREEZING-MECHANISMS).
- [Adversary 2 - Mechanization] Negative control unit tests verifying that violating declared admission ['M1_carrier_multiplicity', 'M2_indexed_context_family', 'M3_step_history_dynamics'] triggers explicit validation failure.
- [Adversary 2 - Mechanization] Parametric variation unit tests over candidate carrier and pricing bounds for OWE-04.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Audit edge check verifying that every node in Layer 3 and above declares incoming dependencies on at least one of M1, M2, or M3.
- [Adversary 2 - Mechanization] Root substrate initialization integration tests ensuring host admissions cleanly bootstrap OWE-04.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of OWE-04 satisfy input contracts for dependent nodes ['DER-03', 'DER-05', 'DER-06'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['M1_carrier_multiplicity', 'M2_indexed_context_family']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Negative control execution demonstrating that a model restricted to |alpha| = 2 without M2 or M3 cannot reach Layer 4 simplicial geometry.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 0_HOST_AND_ADMISSIONS including OWE-04.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating M1-M3-UNFREEZING-MECHANISMS across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for OWE-04 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate carrier size to 2 in an unfreezing context; verify that multi-class separation checks in DER-06 and DER-24 fail closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in M1-M3-UNFREEZING-MECHANISMS checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in OWE-04).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into OWE-04 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in OWE-04 causes check failure).

---

### Layer: 1_PRE_SEAL_MARK_AND_TORSOR (6 Nodes)

#### `DER-01` — N03-N09-PRIMITIVE-DIFFERENCE: Primitive Difference, Soundness Equivalence, and Two-Slot Counterpart Involution

- **Layer**: `1_PRE_SEAL_MARK_AND_TORSOR` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 26 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['scripts/check_primitive_difference.py', 'audit/2026-11-05_minimal_chain/2_mark_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 26 Lean theorems in PrimitiveDifference.lean with propext only. A structural vulnerability is present in recordRefusal (lines 166-168): the func...
- Prose vs code gap: Prose claims that primitive difference forces an operational refusal register. In the Lean formalization, static_relation_does_not_force_refusal explicitly esta...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S1_off_diagonal_pair_witness'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 26 Lean theorems in PrimitiveDifference.lean with propext only. A structural vulnerability is present in recordRefusal (lines 166-168): the function accepts _previous : Register but discards it without examination, instantiating a stateless structure. The formalization demonstrates a memoryless boolean check rather than stateful history retention. Furthermore, while irrefl_iff_soundness holds for general types, the counterpart involution and difference operations are strictly specialized to Bool.
- *Prose vs Code*: Prose claims that primitive difference forces an operational refusal register. In the Lean formalization, static_relation_does_not_force_refusal explicitly establishes that S2 coexists with an update policy that never records refusal (recordNoRefusal), confirming that operational refusal is an extrinsic addition.
- *Boundaries & Assumptions*: Boundary conditions: Constant functions c(x) = b; identity map c = id; carrier restricted to Bool. Unstated assumption: observation maps are total functions evaluated synchronously.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 2, Outgoing edges: 4.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S1_off_diagonal_pair_witness'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem demonstrating refusal register behavior under non-trivial state accumulation over a sequence of inputs
- [Adversary 1 - Formal Soundness] Python property-based test testing all 4 endomaps on Bool under random input sequences.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-01 in existing check script scripts/check_primitive_difference.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for N03-N09-PRIMITIVE-DIFFERENCE.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Cross-module pipeline test passing the output of DER-01 counterpart into DER-02 torsor displacement, verifying that equivariant actions compose without signature mismatch.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-02'] satisfy type preconditions and invariants of DER-01.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-01 satisfy input contracts for dependent nodes ['DER-02', 'DER-04', 'DER-36'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S1_off_diagonal_pair_witness']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Sequence execution trace evaluating multi-step candidate map submissions through refusal recording to verify persistent state transitions.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 1_PRE_SEAL_MARK_AND_TORSOR including DER-01.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating N03-N09-PRIMITIVE-DIFFERENCE across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-01 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate reject c from `c false = c true` to `c false != c true`; verify that registered_refusal_on_collapse fails
- [Adversary 1 - Formal Soundness] Invert counterpart definition (id instead of not); verify that counterpart_ne fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in N03-N09-PRIMITIVE-DIFFERENCE checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-01).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-01 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-01 causes check failure).

---

#### `DER-02` — N04-N08-TORSOR-AND-OPERATIONS: Two-Position Relation Census, C2 Torsor Displacement, and Closure/Merger Algebra

- **Layer**: `1_PRE_SEAL_MARK_AND_TORSOR` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 27 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['scripts/check_primitive_difference.py', 'audit/2026-11-05_minimal_chain/2_mark_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 27 Lean theorems in TorsorAndOperations.lean with propext only. Soundly characterizes the 16 binary relations on Bool, C2 multiplication, and to...
- Prose vs code gap: Prose characterizes C2 as a torsor displacement group arising from distinction alone. The Lean code explicitly depends on the predefined Bool type and its two i...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S1_off_diagonal_pair_witness', 'S2_symmetric_closure', 'S3_endomorphism_composition'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 27 Lean theorems in TorsorAndOperations.lean with propext only. Soundly characterizes the 16 binary relations on Bool, C2 multiplication, and torsor displacement. However, the torsor displacement action is defined exclusively on Bool, and cotransitivity is shown not to be forced by irreflexivity and symmetry (cotrans_not_forced_by_irrefl_symm), leaving apartness unclosed on general carriers without extra axioms.
- *Prose vs Code*: Prose characterizes C2 as a torsor displacement group arising from distinction alone. The Lean code explicitly depends on the predefined Bool type and its two inductive constructors to construct the torsor.
- *Boundaries & Assumptions*: Boundary conditions: The 4 irreflexive relations on Bool (empty, D2, D2rev, S2Bool); trivial action on singleton carrier. Unstated assumption: group action is free and transitive only because carrier cardinality equals group order.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 7.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S1_off_diagonal_pair_witness', 'S2_symmetric_closure', 'S3_endomorphism_composition'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem extending torsor displacement uniqueness to arbitrary sets of cardinality 2
- [Adversary 1 - Formal Soundness] Python unit test verifying full Cayley table properties and transitivity of C2 action on Bool.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-02 in existing check script scripts/check_primitive_difference.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for N04-N08-TORSOR-AND-OPERATIONS.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-02 torsor displacement and DER-04 mirror observation, verifying that displacement preserves observable invariants.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-02', 'OWE-03'] satisfy type preconditions and invariants of DER-02.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-02 satisfy input contracts for dependent nodes ['DER-03', 'DER-06', 'DER-09'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S1_off_diagonal_pair_witness']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Full permutation walk on Bool x Bool verifying that iterated torsor actions generate expected orbits without state leakage.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 1_PRE_SEAL_MARK_AND_TORSOR including DER-02.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating N04-N08-TORSOR-AND-OPERATIONS across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-02 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate c2Mul by setting flip * flip = flip; verify that group identity and inverse theorems fail
- [Adversary 1 - Formal Soundness] Mutate D2 by adding true -> true; verify that irreflexivity checks fail closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in N04-N08-TORSOR-AND-OPERATIONS checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-02).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-02 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-02 causes check failure).

---

#### `DER-03` — OQ-01-RT-03-N16-CARRIER-BOUNDS-AND-SYMMETRY-FLOOR: Root-to-Two-Point Carrier Bounds, List-Length Radix Bound, and Symmetry Floor (OQ-01 / RT-03 / N16)

- **Layer**: `1_PRE_SEAL_MARK_AND_TORSOR` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 9 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/9_oq01_to_oq04_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 9 Lean theorems in TorsorAndOperations.lean. Establishes subsingleton bounds, list-length expansion requiring length >= 2, and the symmetry floo...
- Prose vs code gap: Prose presents OQ-01 / RT-03 / N16 as general carrier bounds and radix constraints. The Lean mechanization demonstrates this principle through concrete toy mode...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 9 Lean theorems in TorsorAndOperations.lean. Establishes subsingleton bounds, list-length expansion requiring length >= 2, and the symmetry floor on Fin 3 where swap3-equivariant deterministic choice collapses to 0 whereas multi-element offer {1, 2} is invariant and contains no fixed point. Vulnerability: the symmetry floor is demonstrated on the specific permutation swap3 on Fin 3; it does not generalize in Lean to arbitrary permutation groups or larger finite carriers.
- *Prose vs Code*: Prose presents OQ-01 / RT-03 / N16 as general carrier bounds and radix constraints. The Lean mechanization demonstrates this principle through concrete toy models: List.length for list expansion and Fin 3 for swap3.
- *Boundaries & Assumptions*: Boundary conditions: List lengths 0, 1, 2; carrier sizes Fin 1, Fin 2, Fin 3; swap3 fixed point at index 0. Unstated assumption: deterministic choice functions are total.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 3, Outgoing edges: 4.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem generalizing swap3_deterministic_vs_multi_offer to arbitrary odd cycles on Fin n
- [Adversary 1 - Formal Soundness] Python property-based test generating random permutations and evaluating invariant offer stability.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-03 in existing check script audit/2026-11-05_minimal_chain/9_oq01_to_oq04_checks.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for OQ-01-RT-03-N16-CARRIER-BOUNDS-AND-SYMMETRY-FLOOR.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test connecting DER-03 carrier bounds to DER-29 pair-quotient map, ensuring consistency of the Fin 3 symmetry floor across representations.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-04', 'DER-02'] satisfy type preconditions and invariants of DER-03.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-03 satisfy input contracts for dependent nodes ['OWE-08', 'DER-21', 'DER-26'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'M3_step_history_dynamics']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Execution trace testing selection algorithms under symmetry-preserving constraints to verify that multi-element offers prevent premature deterministic collapse.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 1_PRE_SEAL_MARK_AND_TORSOR including DER-03.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating OQ-01-RT-03-N16-CARRIER-BOUNDS-AND-SYMMETRY-FLOOR across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-03 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate swap3 to the identity permutation; verify that deterministic choice is no longer forced to fix 0
- [Adversary 1 - Formal Soundness] Mutate list expansion length check from 2 to 1; verify that second_token_required fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in OQ-01-RT-03-N16-CARRIER-BOUNDS-AND-SYMMETRY-FLOOR checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-03).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-03 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-03 causes check failure).

---

#### `DER-04` — N11-MIRROR-NON-IDENTIFICATION: Mirror Non-Identification and Internal-vs-External Asymmetry

- **Layer**: `1_PRE_SEAL_MARK_AND_TORSOR` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 19 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['scripts/check_primitive_difference.py', 'audit/2026-11-05_minimal_chain/4_frozen_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 19 Lean theorems in MirrorNonIdentification.lean with propext only. Soundly demonstrates that internal observation-only procedures cannot distin...
- Prose vs code gap: Prose describes mirror non-identification as a foundational barrier between internal observers and external reference. The Lean code formalizes this specificall...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S2_symmetric_closure'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 19 Lean theorems in MirrorNonIdentification.lean with propext only. Soundly demonstrates that internal observation-only procedures cannot distinguish the two slots of S2Bool, whereas external referent-indexed queries do. Vulnerability: relies on a two-model setup where 'accessible relations' are hardcoded to symmetric forms. Does not formalize continuous or infinite observation channels.
- *Prose vs Code*: Prose describes mirror non-identification as a foundational barrier between internal observers and external reference. The Lean code formalizes this specifically as fiber constancy under counterpart involution.
- *Boundaries & Assumptions*: Boundary conditions: Unary observation functions into Bool; constant extra channels (fail to separate) vs target bit channels (successfully separate).

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 3, Outgoing edges: 3.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S2_symmetric_closure'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem establishing that no composition of symmetric boolean channels separates the mirror pair
- [Adversary 1 - Formal Soundness] Python property-based test evaluating all 16 boolean channels under input transposition.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-04 in existing check script scripts/check_primitive_difference.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for N11-MIRROR-NON-IDENTIFICATION.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking DER-04 mirror non-identification with DER-05 zero-equivalence kernel, verifying that unseparated observation fibers map into non-trivial kernel classes.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'DER-01'] satisfy type preconditions and invariants of DER-04.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-04 satisfy input contracts for dependent nodes ['OWE-06', 'DER-22', 'DER-25'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S2_symmetric_closure']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Protocol simulation testing observer agents attempting identification solely through internal observation tables, verifying that distinction succeeds only when an external anchor is provided.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 1_PRE_SEAL_MARK_AND_TORSOR including DER-04.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating N11-MIRROR-NON-IDENTIFICATION across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-04 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate accessible observation table to be asymmetric; verify that mirror_non_identification fails
- [Adversary 1 - Formal Soundness] Flip target_bit_extra channel output; verify that decoding correctness fails closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in N11-MIRROR-NON-IDENTIFICATION checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-04).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-04 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-04 causes check failure).

---

#### `DER-29` — SLICE-XIV-PAIR-QUOTIENT-MULTIPLICITY-AND-SYMMETRY-FLOOR-BRIDGE: Endogenous Pair-Quotient Multiplicity Bridge (Bool × Bool → Fin 3) and S2Bool × S2Bool Symmetry-Floor Intertwiners

- **Layer**: `1_PRE_SEAL_MARK_AND_TORSOR` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 6 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py', 'tests/test_orbit_decomposed_l1_weights.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 6 Lean theorems in TorsorAndOperations.lean. Constructs 4-element pair space Bool x Bool and two canonical surjective quotients onto Fin 3 (pair...
- Prose vs code gap: Prose describes this as an endogenous carrier-multiplicity bridge (narrowing OWE-06) that extracts a 3-element carrier from product formation. The formalization...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S2_symmetric_closure'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 6 Lean theorems in TorsorAndOperations.lean. Constructs 4-element pair space Bool x Bool and two canonical surjective quotients onto Fin 3 (pairToFin3 and pairToFin3Dual) intertwining diagSwap and transposePair with swap3 and offer12. Vulnerability: formalization is restricted to product of two Bools; it does not generalize to products of arbitrary finite sets.
- *Prose vs Code*: Prose describes this as an endogenous carrier-multiplicity bridge (narrowing OWE-06) that extracts a 3-element carrier from product formation. The formalization establishes the surjective quotient maps, but product formation itself relies on host pairing.
- *Boundaries & Assumptions*: Boundary conditions: The 4 points of Bool x Bool; fixed point 0 on Fin 3; 2-orbit {1, 2}. Unstated assumption: cartesian product Bool x Bool is an available type constructor.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S2_symmetric_closure'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem establishing that no surjective map Bool x Bool -> Fin 4 exists preserving diagonal swap
- [Adversary 1 - Formal Soundness] Python unit test verifying fiber sizes (2, 1, 1) and intertwining across all permutations.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-29 in existing check script audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for SLICE-XIV-PAIR-QUOTIENT-MULTIPLICITY-AND-SYMMETRY-FLOOR-BRIDGE.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test connecting DER-29 pair-quotient map with DER-27 orbit-decomposed cochain weights.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'DER-02'] satisfy type preconditions and invariants of DER-29.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-29 satisfy input contracts for dependent nodes ['OWE-06'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S2_symmetric_closure']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Verification that a 2-point mark stepping to a 4-point pair space descends cleanly to a 3-point quotient without losing symmetry-floor protections.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 1_PRE_SEAL_MARK_AND_TORSOR including DER-29.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating SLICE-XIV-PAIR-QUOTIENT-MULTIPLICITY-AND-SYMMETRY-FLOOR-BRIDGE across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-29 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate pairToFin3 by sending (true, false) to 2 instead of 1; verify that intertwining with swap3 fails
- [Adversary 1 - Formal Soundness] Invert diagSwap definition; verify that involution property fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in SLICE-XIV-PAIR-QUOTIENT-MULTIPLICITY-AND-SYMMETRY-FLOOR-BRIDGE checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-29).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-29 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-29 causes check failure).

---

#### `DER-45` — WDP-PRIMITIVE-ADMISSION-FLOOR-NO-PHANTOM-REDUCTION: Witnessed-Difference Primitive Admission Floor, Non-Empty Token Supply Requirement, and No-Phantom-Reduction Witnesses

- **Layer**: `1_PRE_SEAL_MARK_AND_TORSOR` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 8 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 8 Lean theorems in WitnessedDifference.PrimitiveAdmissionFloor. Establishes that primitive admissions cannot be eliminated without losing formal...
- Prose vs code gap: Prose claims a rigorous admission floor preventing phantom reductions. Lean formalization checks specific reduction obstructions, but lack of runtime mechanizat...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S1_off_diagonal_pair_witness', 'S3_endomorphism_composition'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 8 Lean theorems in WitnessedDifference.PrimitiveAdmissionFloor. Establishes that primitive admissions cannot be eliminated without losing formal distinguishability. Vulnerability: This module has zero dedicated Python tests in tests/; it relies entirely on check_primitive_difference.py.
- *Prose vs Code*: Prose claims a rigorous admission floor preventing phantom reductions. Lean formalization checks specific reduction obstructions, but lack of runtime mechanization leaves evaluation unexercised in Python.
- *Boundaries & Assumptions*: Boundary conditions: Zero admissions (complete collapse of distinction); singleton admission sets. Unstated assumption: admissions are discrete propositions.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 6, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S1_off_diagonal_pair_witness', 'S3_endomorphism_composition'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ for PrimitiveAdmissionFloor
- [Adversary 1 - Formal Soundness] Lean boundary theorem for zero-admission reduction.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-PRIMITIVE-ADMISSION-FLOOR-NO-PHANTOM-REDUCTION (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-45.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (8 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test verifying that all downstream WDP nodes inherit the admission floor without bypass.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-02', 'OWE-03'] satisfy type preconditions and invariants of DER-45.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-45 satisfy input contracts for dependent nodes ['DER-46'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S1_off_diagonal_pair_witness']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Replay test checking that stripping S1 or S2 from the dependency graph blocks all downstream builds.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 1_PRE_SEAL_MARK_AND_TORSOR including DER-45.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-PRIMITIVE-ADMISSION-FLOOR-NO-PHANTOM-REDUCTION across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-45 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate admission floor condition by omitting one required admission witness; verify that the proof fails closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-PRIMITIVE-ADMISSION-FLOOR-NO-PHANTOM-REDUCTION checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-45).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-45 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-45 causes check failure).

---

### Layer: 2_SEAL_AND_ZERO_EQUIVALENCE (4 Nodes)

#### `DER-05` — N28-N33-ZERO-EQUIVALENCE-AND-RESIDUAL-QUOTIENT: Kernel Zero-Equivalence, Residual Quotient Factorization, and Boundary Non-Determination

- **Layer**: `2_SEAL_AND_ZERO_EQUIVALENCE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 62 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['scripts/check_primitive_difference.py', 'audit/2026-11-05_minimal_chain/5_forcing_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 62 Lean theorems in ZeroEquivalence.lean with propext and Quot.sound. Formalizes kernels, zeroSetoid, and residual quotients. Vulnerability: The...
- Prose vs code gap: Prose describes zero-equivalence as an operational seal that collapses unobservable fluctuations. The Lean mechanization formalizes this via standard Lean core ...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M2_indexed_context_family'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 62 Lean theorems in ZeroEquivalence.lean with propext and Quot.sound. Formalizes kernels, zeroSetoid, and residual quotients. Vulnerability: The setoid construction assumes that delta is a reflexive, symmetric, transitive equivalence on the carrier. When the kernel laws are relaxed to tolerance relations or non-transitive metrics, the canonical quotient construction fails. In addition, descent theorems require exact congruence rather than metric approximation.
- *Prose vs Code*: Prose describes zero-equivalence as an operational seal that collapses unobservable fluctuations. The Lean mechanization formalizes this via standard Lean core quotients (Quotient.sound), which depends directly on host-supplied quotient semantics rather than an internal constructive algorithm.
- *Boundaries & Assumptions*: Boundary conditions: Trivial kernel where delta(x, y) = 0 for all x, y (collapses entire space to a single class); discrete kernel where delta(x, y) = 0 iff x = y (no collapse); empty carrier. Unstated assumption: carrier equivalence classes are decidable.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 2, Outgoing edges: 11.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M2_indexed_context_family'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem characterizing residual quotient cardinality under finite carrier partitions
- [Adversary 1 - Formal Soundness] Python property-based tests verifying quotient descent for randomized finite kernels.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-05 in existing check script scripts/check_primitive_difference.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for N28-N33-ZERO-EQUIVALENCE-AND-RESIDUAL-QUOTIENT.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking DER-05 residual quotient with DER-06 minimal separation, verifying that quotient classes preserve distinguishability under form applications.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-04'] satisfy type preconditions and invariants of DER-05.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-05 satisfy input contracts for dependent nodes ['DER-06', 'DER-09', 'DER-11'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'M2_indexed_context_family']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Verification that raw observation traces passing through zero-equivalence collapse to minimal certified state representations.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 2_SEAL_AND_ZERO_EQUIVALENCE including DER-05.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating N28-N33-ZERO-EQUIVALENCE-AND-RESIDUAL-QUOTIENT across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-05 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate zero_symm in Kernel structure to an asymmetric relation; verify that zeroSetoid fails to typecheck
- [Adversary 1 - Formal Soundness] Invert Zero predicate; verify that classOf_eq_iff_zeroRel fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in N28-N33-ZERO-EQUIVALENCE-AND-RESIDUAL-QUOTIENT checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-05).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-05 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-05 causes check failure).

---

#### `DER-21` — SLICE-IX-PROFILE-PREORDER-EQUIVALENCE-BRIDGE: Profile-Equality vs. Mutual-Comparability Preorder and Quotient Retention Bridge (N19)

- **Layer**: `2_SEAL_AND_ZERO_EQUIVALENCE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 20 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['scripts/profile_preorder_and_generator_models.py', 'tests/test_profile_preorder_and_generator.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 20 Lean theorems in ProfilePreorderAndGenerator.lean. Establishes that complete profile agreement ProfileEquiv E is an equivalence relation for ...
- Prose vs code gap: Prose presents this as a bridge to continuum real completeness (referencing OWE-10 / N26). The Lean code formalizes finite and relational preorder equivalence; ...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 20 Lean theorems in ProfilePreorderAndGenerator.lean. Establishes that complete profile agreement ProfileEquiv E is an equivalence relation for any binary relation E, and coincides with mutual comparability when E is a preorder. Vulnerability: The formalization operates on arbitrary relations, but mutual comparability agreement strictly requires transitivity. On non-transitive relations, ProfileEquiv separates points that mutual comparability falsely equates.
- *Prose vs Code*: Prose presents this as a bridge to continuum real completeness (referencing OWE-10 / N26). The Lean code formalizes finite and relational preorder equivalence; it does not construct the real continuum or Dedekind completeness.
- *Boundaries & Assumptions*: Boundary conditions: Directed preorder boolLeq on {0, 1}; irreflexive relation D2; empty relation. Unstated assumption: relations are globally accessible binary propositions.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 7.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem characterizing profile equivalence classes on general cyclic tournaments
- [Adversary 1 - Formal Soundness] Python unit test enumerating all 512 binary relations on 3 elements to verify profile agreement.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-21 in existing check script scripts/profile_preorder_and_generator_models.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for SLICE-IX-PROFILE-PREORDER-EQUIVALENCE-BRIDGE.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-21 profile preorder equivalence and DER-34 distinction horizons, verifying that finite observation horizons preserve preorder classes.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-04', 'DER-03'] satisfy type preconditions and invariants of DER-21.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-21 satisfy input contracts for dependent nodes ['DER-22', 'DER-23', 'DER-25'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'M2_indexed_context_family']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Pipeline test evaluating preorder profiles across growing relational networks.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 2_SEAL_AND_ZERO_EQUIVALENCE including DER-21.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating SLICE-IX-PROFILE-PREORDER-EQUIVALENCE-BRIDGE across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-21 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Drop the incoming profile condition in ProfileEquiv (leaving only outgoing); verify that symmetry of ProfileEquiv fails on asymmetric relations like boolLeq
- [Adversary 1 - Formal Soundness] Mutate mutual comparability definition; verify that preorder equivalence fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in SLICE-IX-PROFILE-PREORDER-EQUIVALENCE-BRIDGE checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-21).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-21 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-21 causes check failure).

---

#### `DER-22` — SLICE-IX-TEN-STICK-RESIDUAL-AND-PHASE-LIFT-MODELS: Conditional Ten-Stick Reflection Residual and Four-Step vs. Two-Step Phase Lift Models (N19-N20)

- **Layer**: `2_SEAL_AND_ZERO_EQUIVALENCE` | **Bucket**: `DERIVED` | **Tripartite Status**: `CONDITIONALLY_PERFECTED`
- **Current Coverage**: 9 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['scripts/profile_preorder_and_generator_models.py', 'tests/test_profile_preorder_and_generator.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as CONDITIONALLY_PERFECTED (requires open bridge OWE-08). Verified across 9 Lean theorems in ProfilePreorderAndGenerator.lean. Formalizes the 10-stic...
- Prose vs code gap: Prose suggests that 10-stick reflection and 4-step phase lifts reflect deep physical geometry. The Lean formalization constructs concrete finite combinatorial i...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M2_indexed_context_family', 'M3_step_history_dynamics', 'ten_stick_carrier_and_period_four_necessity_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as CONDITIONALLY_PERFECTED (requires open bridge OWE-08). Verified across 9 Lean theorems in ProfilePreorderAndGenerator.lean. Formalizes the 10-stick carrier (Fin 10 -> Bool) with reflection involution and 4-step cyclic lift. Vulnerability: Carrier size n = 10 and 4-step period are supplied parameters. The Lean code establishes properties of these supplied models, but does not endogenously derive why n = 10 is selected over n = 3, or why 4-step holonomy is forced over the trivial 2-step lift.
- *Prose vs Code*: Prose suggests that 10-stick reflection and 4-step phase lifts reflect deep physical geometry. The Lean formalization constructs concrete finite combinatorial indicators and explicit index permutations.
- *Boundaries & Assumptions*: Boundary conditions: Carrier sizes n = 1, 2, 3, 10; mirror pairs vs non-mirror pairs; trivial 2-step lift vs 4-step cyclic lift. Unstated assumption: reflection axis is fixed at the array center.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 6, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M2_indexed_context_family', 'M3_step_history_dynamics', 'ten_stick_carrier_and_period_four_necessity_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorems establishing reflection residual properties for all intermediate lengths n in 4..9
- [Adversary 1 - Formal Soundness] Python unit test verifying Burnside orbit counting across all 1024 configurations.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-22 in existing check script scripts/profile_preorder_and_generator_models.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for SLICE-IX-TEN-STICK-RESIDUAL-AND-PHASE-LIFT-MODELS.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test verifying that DER-22 carries an explicit requires_admission dependency on OWE-08, and that removing the dependency flag triggers an audit error.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-04', 'OWE-08'] satisfy type preconditions and invariants of DER-22.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-22 satisfy input contracts for dependent nodes ['DER-49'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'M2_indexed_context_family']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Verification of phase lift stability under iterated cycles, comparing trivial lift against sheet-flip holonomy over long run horizons.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 2_SEAL_AND_ZERO_EQUIVALENCE including DER-22.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating SLICE-IX-TEN-STICK-RESIDUAL-AND-PHASE-LIFT-MODELS across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-22 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate reflectIndex10 from `9 - i` to `10 - i`; verify that reflection involution fails
- [Adversary 1 - Formal Soundness] Mutate step4 transition table; verify that period 4 property fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in SLICE-IX-TEN-STICK-RESIDUAL-AND-PHASE-LIFT-MODELS checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-22).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-22 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-22 causes check failure).

---

#### `DER-25` — SLICE-X-HOLONOMY-PERIOD-FOUR-AND-STICK-THRESHOLD-CHARACTERIZATION: Exact Period-4 Two-Sheet Holonomy Characterization and Minimal n = 3 Reflection-Residual Carrier Threshold (N19-N20)

- **Layer**: `2_SEAL_AND_ZERO_EQUIVALENCE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 12 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['scripts/profile_preorder_and_generator_models.py', 'tests/test_profile_preorder_and_generator.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 12 Lean theorems in ProfilePreorderAndGenerator.lean. Establishes that base-intertwining lifts on Bool x Bool have period 4 everywhere iff they ...
- Prose vs code gap: Prose presents holonomy period-4 as an emergence of complex phase / spinorial sign change. The formalization establishes an exact combinatorial cycle property o...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 12 Lean theorems in ProfilePreorderAndGenerator.lean. Establishes that base-intertwining lifts on Bool x Bool have period 4 everywhere iff they have no 2-step fixed points iff their 2-step holonomy flips the hidden sheet everywhere. Also demonstrates that n = 3 is the minimal threshold for positive reflection residual on single-stick configurations. Vulnerability: Characterization is sound for the supplied product model, but does not derive the hidden sheet from distinction alone.
- *Prose vs Code*: Prose presents holonomy period-4 as an emergence of complex phase / spinorial sign change. The formalization establishes an exact combinatorial cycle property on the 4-element set Bool x Bool.
- *Boundaries & Assumptions*: Boundary conditions: n = 1 (residual equals Hamming distance); n = 2 (mirror collapse with zero residual); n = 3 (first positive non-mirror residual). Unstated assumption: sheet interaction is deterministic.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 3.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem generalizing period-4 characterization to arbitrary finite base spaces with an involution
- [Adversary 1 - Formal Soundness] Python property-based test testing all 256 endomaps on Bool x Bool for sheet-flip holonomy.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-25 in existing check script scripts/profile_preorder_and_generator_models.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for SLICE-X-HOLONOMY-PERIOD-FOUR-AND-STICK-THRESHOLD-CHARACTERIZATION.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-25 threshold characterization and OWE-08 bridge reduction in DER-56.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-04', 'DER-04'] satisfy type preconditions and invariants of DER-25.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-25 satisfy input contracts for dependent nodes ['DER-22', 'OWE-08', 'DER-56'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'M2_indexed_context_family']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Full chain execution tracing carrier size growth from n = 1 through n = 3 to n = 10 under reflection residual evaluation.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 2_SEAL_AND_ZERO_EQUIVALENCE including DER-25.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating SLICE-X-HOLONOMY-PERIOD-FOUR-AND-STICK-THRESHOLD-CHARACTERIZATION across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-25 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate step4Sheet so that one state does not flip the sheet; verify that period_four_iff_sheet_flip_holonomy fails
- [Adversary 1 - Formal Soundness] Invert Stick3 single-stick indicator; verify that minimal threshold condition fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in SLICE-X-HOLONOMY-PERIOD-FOUR-AND-STICK-THRESHOLD-CHARACTERIZATION checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-25).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-25 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-25 causes check failure).

---

### Layer: 3_POST_SEAL_SEPARATION_AND_RETENTION (23 Nodes)

#### `DER-06` — WDP-CH01-MINIMAL-SEPARATION-REGIME4: Pruned 4-Tuple Regime4, Mention Irrelevance, Permutation Invariance, and Kernel Bridge

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 12 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['scripts/check_primitive_difference.py', 'audit/2026-11-05_minimal_chain/10_post_seal_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 12 Lean theorems in MinimalSeparation.lean with propext and Quot.sound. Formalizes Regime 4 minimal separation, establishing that 4 distinct for...
- Prose vs code gap: Prose presents Regime 4 as an unavoidable minimal separation threshold. The Lean code formalizes the specific finite context setup without demonstrating uniquen...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M2_indexed_context_family'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 12 Lean theorems in MinimalSeparation.lean with propext and Quot.sound. Formalizes Regime 4 minimal separation, establishing that 4 distinct forms separate 4 data points. Vulnerability: Forms and arities are hardcoded to unary and binary forms on a 4-element carrier. Does not generalize constructively to arbitrary finite or infinite relational contexts.
- *Prose vs Code*: Prose presents Regime 4 as an unavoidable minimal separation threshold. The Lean code formalizes the specific finite context setup without demonstrating uniqueness over non-isomorphic contexts.
- *Boundaries & Assumptions*: Boundary conditions: Empty context; carrier size < 4 (fails separation); arity = 1 vs arity = 2. Unstated assumption: observation contexts are static and evaluated synchronously.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 14.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M2_indexed_context_family'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem establishing that no 3-form context can separate 4 data points
- [Adversary 1 - Formal Soundness] Python unit test verifying separation matrices across all permutations of the 4 forms.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-06 in existing check script scripts/check_primitive_difference.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for WDP-CH01-MINIMAL-SEPARATION-REGIME4.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking DER-06 separation outputs into DER-08 multi-round closure.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-04', 'DER-05'] satisfy type preconditions and invariants of DER-06.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-06 satisfy input contracts for dependent nodes ['DER-07', 'DER-08', 'DER-17'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'M2_indexed_context_family']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Verification that data points separated in Regime 4 remain distinguished throughout downstream quotienting.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-06.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-CH01-MINIMAL-SEPARATION-REGIME4 across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-06 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Delete one form from Regime 4 context; verify that separation count drops below 4
- [Adversary 1 - Formal Soundness] Invert evaluation truth table; verify that minimal separation checks fail closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-CH01-MINIMAL-SEPARATION-REGIME4 checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-06).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-06 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-06 causes check failure).

---

#### `DER-07` — OQ-04-RT-01-ARITY-COST-UNIQUENESS: Unary Separator Uniqueness at Cost 2 and Zero-Unary-Weight Three-Item Countermodel (OQ-04 / RT-01)

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 10 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/9_oq01_to_oq04_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 10 Lean theorems in MinimalSeparation.lean. Establishes arity cost uniqueness under an additive norm. Vulnerability: Depends on the explicit cho...
- Prose vs code gap: Prose claims cost uniqueness as an inherent consequence of arity. Formalization establishes this under the declared admission S5 (additive cost target)....
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 10 Lean theorems in MinimalSeparation.lean. Establishes arity cost uniqueness under an additive norm. Vulnerability: Depends on the explicit choice of an additive linear cost model; non-linear or sub-additive cost models would yield different uniqueness classes.
- *Prose vs Code*: Prose claims cost uniqueness as an inherent consequence of arity. Formalization establishes this under the declared admission S5 (additive cost target).
- *Boundaries & Assumptions*: Boundary conditions: Arity k = 0 (constant nullary forms); arity k = 1 (unary forms); zero cost c = 0. Unstated assumption: costs are strictly non-negative integers.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 3, Outgoing edges: 0.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem evaluating arity cost bounds under sub-additive norm variants
- [Adversary 1 - Formal Soundness] Python property-based test testing cost monotonicity across random arity vectors.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-07 in existing check script audit/2026-11-05_minimal_chain/9_oq01_to_oq04_checks.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for OQ-04-RT-01-ARITY-COST-UNIQUENESS.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-07 arity cost and DER-30 L1 optimization.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'DER-06'] satisfy type preconditions and invariants of DER-07.
- [Adversary 2 - Mechanization] Terminal boundary integration tests checking that DER-07 exports valid terminal invariants or extension interfaces.
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S5_additive_cost_target']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Cumulative budget tracking test ensuring that high-arity forms are penalized correctly in execution paths.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-07.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating OQ-04-RT-01-ARITY-COST-UNIQUENESS across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-07 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate arity cost to be constant across all arities; verify that arity_cost_uniqueness fails
- [Adversary 1 - Formal Soundness] Set cost of binary form lower than unary form; verify that cost ranking checks fail.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in OQ-04-RT-01-ARITY-COST-UNIQUENESS checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-07).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-07 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-07 causes check failure).

---

#### `DER-08` — OQ-05-RT-09-MULTI-ROUND-CLOSURE: Quotient-Refinement Round Bound and Explicit-vs-Derived Accounting Gap (OQ-05 / RT-09)

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 7 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 7 Lean theorems in MinimalSeparation.lean. Establishes multi-round context closure under step-wise refinement. Vulnerability: Assumes a finite r...
- Prose vs code gap: Prose describes multi-round closure as ensuring long-term operational persistence. Lean formalization establishes closure properties for bounded step increments...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 7 Lean theorems in MinimalSeparation.lean. Establishes multi-round context closure under step-wise refinement. Vulnerability: Assumes a finite round bound; does not establish stabilization or Noetherian termination for unbounded multi-round execution.
- *Prose vs Code*: Prose describes multi-round closure as ensuring long-term operational persistence. Lean formalization establishes closure properties for bounded step increments.
- *Boundaries & Assumptions*: Boundary conditions: 0 rounds (identity); 1 round; round saturation where no new forms can be added. Unstated assumption: context addition is monotonic.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem establishing finite stabilization of multi-round closure on finite carriers
- [Adversary 1 - Formal Soundness] Python property-based test simulating 100 random multi-round addition steps.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-08 in existing check script audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for OQ-05-RT-09-MULTI-ROUND-CLOSURE.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-08 multi-round closure and DER-24 class count bridge.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-04', 'DER-06'] satisfy type preconditions and invariants of DER-08.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-08 satisfy input contracts for dependent nodes ['DER-33'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'M2_indexed_context_family']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Multi-round simulation verifying that context growth stabilizes without infinite cyclic branching.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-08.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating OQ-05-RT-09-MULTI-ROUND-CLOSURE across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-08 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Allow non-monotonic context removal; verify that multi-round closure fails to accumulate
- [Adversary 1 - Formal Soundness] Invert round index check; verify that trace verification fails closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in OQ-05-RT-09-MULTI-ROUND-CLOSURE checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-08).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-08 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-08 causes check failure).

---

#### `DER-09` — WDP-CH02-FIVE-MODE-REFUSAL-HIERARCHY: Five-Mode Refusal Hierarchy and Tagged vs Untagged Reification

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 5 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['scripts/check_primitive_difference.py', 'audit/2026-11-05_minimal_chain/10_post_seal_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 5 Lean theorems in RetentionAndRefusal.lean. Constructs a 5-mode refusal hierarchy classifying evaluation failures. Vulnerability: The hierarchy...
- Prose vs code gap: Prose presents the 5-mode hierarchy as a comprehensive operational classification. Lean code defines the five constructors and shows their ordered ranking on sa...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S4_retention_state_bit'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 5 Lean theorems in RetentionAndRefusal.lean. Constructs a 5-mode refusal hierarchy classifying evaluation failures. Vulnerability: The hierarchy is an axiomatic partition; formalization lacks negative controls establishing that no sixth mode is possible or that modes are mutually exclusive under partial information.
- *Prose vs Code*: Prose presents the 5-mode hierarchy as a comprehensive operational classification. Lean code defines the five constructors and shows their ordered ranking on sample instances.
- *Boundaries & Assumptions*: Boundary conditions: Complete acceptance (mode 0); total refusal (mode 4); borderline partial refusal. Unstated assumption: refusal evaluation terminates in finite steps.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 9.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S4_retention_state_bit'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem establishing mutual exclusivity and exhaustiveness of the 5 refusal modes
- [Adversary 1 - Formal Soundness] Python unit test evaluating refusal mode assignments across all failure branches.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-09 in existing check script scripts/check_primitive_difference.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for WDP-CH02-FIVE-MODE-REFUSAL-HIERARCHY.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking DER-09 refusal modes with DER-11 report factorization.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'DER-02'] satisfy type preconditions and invariants of DER-09.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-09 satisfy input contracts for dependent nodes ['DER-10', 'DER-12', 'DER-17'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S4_retention_state_bit']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Execution trace checking that all evaluation failures in Layers 3 and 4 map to valid refusal modes.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-09.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-CH02-FIVE-MODE-REFUSAL-HIERARCHY across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-09 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Swap the severity ranking of mode 2 and mode 3; verify that monotonic refusal filtering fails
- [Adversary 1 - Formal Soundness] Drop one mode constructor; verify that pattern matches fail closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-CH02-FIVE-MODE-REFUSAL-HIERARCHY checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-09).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-09 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-09 causes check failure).

---

#### `DER-10` — OQ-03-RT-02-MEMORY-PACKET-16-OF-1024: Exact 16/1024 Two-Step Retaining Laws, 4/1024 Drift-Free Law, and Multi-Step Idle Drift (OQ-03 / RT-02)

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 9 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/9_oq01_to_oq04_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 9 Lean theorems in RetentionAndRefusal.lean. Establishes that exactly 16 out of 1024 memory packets satisfy retention invariants. Vulnerability:...
- Prose vs code gap: Prose emphasizes 16/1024 as a fundamental constraint on memory packet admissibility. The Lean proof operates by exhaustive finite case analysis (decide)....
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S4_retention_state_bit', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 9 Lean theorems in RetentionAndRefusal.lean. Establishes that exactly 16 out of 1024 memory packets satisfy retention invariants. Vulnerability: Strictly hardcoded to a 10-bit memory packet (2^10 = 1024). Does not generalize to arbitrary packet widths n or non-binary memory cells.
- *Prose vs Code*: Prose emphasizes 16/1024 as a fundamental constraint on memory packet admissibility. The Lean proof operates by exhaustive finite case analysis (decide).
- *Boundaries & Assumptions*: Boundary conditions: All-zeros packet; all-ones packet; the 16 valid packets. Unstated assumption: packet structure is fixed at 10 bits.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S4_retention_state_bit', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem establishing general formula for valid packet count as a function of packet width n
- [Adversary 1 - Formal Soundness] Python test verifying all 1024 packets against retention predicates.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-10 in existing check script audit/2026-11-05_minimal_chain/9_oq01_to_oq04_checks.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for OQ-03-RT-02-MEMORY-PACKET-16-OF-1024.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test connecting DER-10 packet filtering with DER-26 adaptive horizon scaling.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-10.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-10 satisfy input contracts for dependent nodes ['IMG-09', 'DER-36'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S4_retention_state_bit']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Tracking packet stream validation ensuring that corrupt packets are filtered prior to state update.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-10.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating OQ-03-RT-02-MEMORY-PACKET-16-OF-1024 across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-10 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate valid packet condition to accept an invalid 17th packet; verify that count check fails
- [Adversary 1 - Formal Soundness] Invert bitmask check; verify that all-zeros packet is rejected.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in OQ-03-RT-02-MEMORY-PACKET-16-OF-1024 checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-10).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-10 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-10 causes check failure).

---

#### `DER-11` — OQ-06-RT-05-RT-10-CHOICE-FREE-REPORT-FACTORIZATION: Choice-Free Finite Report Decoding, Image Invariance, and Global-vs-Finite Congruence (OQ-06 / RT-05 / RT-10)

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 7 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 7 Lean theorems in RetentionAndRefusal.lean. Establishes choice-free report factorization through canonical quotient projections. Vulnerability:...
- Prose vs code gap: Prose presents choice-free factorization as an elimination of arbitrary observer discretion. Lean formalization implements this via Quotient.lift under demonstr...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 7 Lean theorems in RetentionAndRefusal.lean. Establishes choice-free report factorization through canonical quotient projections. Vulnerability: Eliminates choice only because quotients are taken over equivalence relations with canonical constructive representatives on finite types.
- *Prose vs Code*: Prose presents choice-free factorization as an elimination of arbitrary observer discretion. Lean formalization implements this via Quotient.lift under demonstrated congruence.
- *Boundaries & Assumptions*: Boundary conditions: Identity factorization; constant report factorization. Unstated assumption: report equivalence classes are decidable.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 2, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem checking that choice-free factorization fails if congruence condition is relaxed
- [Adversary 1 - Formal Soundness] Python unit test testing report factorization on non-congruent candidate functions.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-11 in existing check script audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for OQ-06-RT-05-RT-10-CHOICE-FREE-REPORT-FACTORIZATION.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-11 report factorization and DER-43 observer descent.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'DER-05'] satisfy type preconditions and invariants of DER-11.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-11 satisfy input contracts for dependent nodes ['DER-52'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Verification of end-to-end report delivery from multiple independent observers yielding identical factorized classes.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-11.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating OQ-06-RT-05-RT-10-CHOICE-FREE-REPORT-FACTORIZATION across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-11 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate report function to return non-congruent values on equivalent inputs; verify that lift fails
- [Adversary 1 - Formal Soundness] Invert quotient map projection; verify that factorization commutativity fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in OQ-06-RT-05-RT-10-CHOICE-FREE-REPORT-FACTORIZATION checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-11).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-11 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-11 causes check failure).

---

#### `DER-12` — RT-06-OQ-08-RT-12-CLOSURE-DUALITY-AND-HORIZON-MORPHISM: Simplified-Model WDPWorld / HWorld Guarded Commutation at Zero Admission/Retention Cost (OQ-08)

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `CONDITIONALLY_PERFECTED`
- **Current Coverage**: 8 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as CONDITIONALLY_PERFECTED (requires open bridge OWE-12). Verified across 8 Lean theorems in RetentionAndRefusal.lean. Formalizes closure duality and...
- Prose vs code gap: Prose discusses general horizon morphisms and closure duality. Lean theorems explicitly carry the hypothesis cAdm = 0 and cRet = 0, indicating that unconditiona...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S4_retention_state_bit', 'S5_additive_cost_target', 'wdp_ch01_d03_full_represented_world_bridge_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as CONDITIONALLY_PERFECTED (requires open bridge OWE-12). Verified across 8 Lean theorems in RetentionAndRefusal.lean. Formalizes closure duality and horizon morphisms, establishing replay commutation. Critical vulnerability: Commutation is established under the explicit premise that admission and retention costs are zero (cAdm = 0, cRet = 0) and views are singletons. In any realistic setting with positive costs, commutation fails without the compensated budget bridge OWE-12.
- *Prose vs Code*: Prose discusses general horizon morphisms and closure duality. Lean theorems explicitly carry the hypothesis cAdm = 0 and cRet = 0, indicating that unconditional discharge is not achieved.
- *Boundaries & Assumptions*: Boundary conditions: Zero costs vs positive costs; singleton views vs multi-locus views. Unstated assumption: horizon translations preserve budget admissibility.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 5, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S4_retention_state_bit', 'S5_additive_cost_target', 'wdp_ch01_d03_full_represented_world_bridge_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem showing failure of replay commutation when cAdm > 0 without budget compensation
- [Adversary 1 - Formal Soundness] Python unit test checking cost accounting across non-zero admission events.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-12 in existing check script audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for RT-06-OQ-08-RT-12-CLOSURE-DUALITY-AND-HORIZON-MORPHISM.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test ensuring that DER-12 flags conditional dependency on OWE-12 in all audit manifests.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-12'] satisfy type preconditions and invariants of DER-12.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-12 satisfy input contracts for dependent nodes ['IMG-02'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S4_retention_state_bit']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Simulation of multi-locus view translations comparing zero-cost traces against compensated positive-cost traces.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-12.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating RT-06-OQ-08-RT-12-CLOSURE-DUALITY-AND-HORIZON-MORPHISM across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-12 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Set cAdm = 1 in oq08_refinement_commutes_at_zero_adm_ret_cost; verify that commutation proof fails
- [Adversary 1 - Formal Soundness] Mutate multi-locus view decomposition; verify that horizon morphism checks fail closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in RT-06-OQ-08-RT-12-CLOSURE-DUALITY-AND-HORIZON-MORPHISM checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-12).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-12 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-12 causes check failure).

---

#### `DER-23` — SLICE-IX-SUPPLIED-GENERATOR-TRACE-AND-RADIUS-PROFILE-COLLISION: Conditional Supplied-Rule Generator Growth, Lower Bound, and Radius-d Profile Collision (N21-N22)

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `CONDITIONALLY_PERFECTED`
- **Current Coverage**: 35 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['scripts/profile_preorder_and_generator_models.py', 'tests/test_profile_preorder_and_generator.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as CONDITIONALLY_PERFECTED (requires open bridges OWE-07 and OWE-13). Verified across 35 Lean theorems in ProfilePreorderAndGenerator.lean. Formalize...
- Prose vs code gap: Prose presents profile collision as an inescapable geometric obstruction. The Lean code demonstrates this for initial-segment chains List.range (n + 1) where ch...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M2_indexed_context_family', 'M3_step_history_dynamics', 'operational_witness_acquisition_invocation_admission', 'multi_round_law_and_repair_persistence_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as CONDITIONALLY_PERFECTED (requires open bridges OWE-07 and OWE-13). Verified across 35 Lean theorems in ProfilePreorderAndGenerator.lean. Formalizes supplied generator traces (stepM, stepRefl) and interior profile collisions. Critical vulnerability: Relies on supplied two-constructor sum types (tok vs receipt) and external step invocation. It does not constructively derive rule acquisition (OWE-07) or state repair persistence (OWE-13).
- *Prose vs Code*: Prose presents profile collision as an inescapable geometric obstruction. The Lean code demonstrates this for initial-segment chains List.range (n + 1) where chain length outruns fixed observation radius d.
- *Boundaries & Assumptions*: Boundary conditions: Observation radius d = 0, 1, 2; chain length n < 2d + 3 (no interior points) vs n >= 2d + 3 (interior points share identical profiles). Unstated assumption: graph topology is a linear chain.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 7, Outgoing edges: 0.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M2_indexed_context_family', 'M3_step_history_dynamics', 'operational_witness_acquisition_invocation_admission', 'multi_round_law_and_repair_persistence_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem evaluating profile collision on tree and grid topologies rather than linear chains
- [Adversary 1 - Formal Soundness] Python property-based test testing radius-d profile collisions on random graphs.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-23 in existing check script scripts/profile_preorder_and_generator_models.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for SLICE-IX-SUPPLIED-GENERATOR-TRACE-AND-RADIUS-PROFILE-COLLISION.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test verifying that DER-23 audit records incoming requires_admission edges from OWE-07 and OWE-13.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-04', 'OWE-07'] satisfy type preconditions and invariants of DER-23.
- [Adversary 2 - Mechanization] Terminal boundary integration tests checking that DER-23 exports valid terminal invariants or extension interfaces.
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'M2_indexed_context_family']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Full chain generation trace demonstrating that deep-interior points produce collision errors under fixed-radius observation unless repaired.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-23.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating SLICE-IX-SUPPLIED-GENERATOR-TRACE-AND-RADIUS-PROFILE-COLLISION across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-23 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate depth_d_obstruction threshold from `2*d + 3` to `2*d`; verify that collision theorem fails
- [Adversary 1 - Formal Soundness] Alter stepRefl transition rule; verify that chain growth invariants fail.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in SLICE-IX-SUPPLIED-GENERATOR-TRACE-AND-RADIUS-PROFILE-COLLISION checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-23).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-23 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-23 causes check failure).

---

#### `DER-24` — OQ-05-REGIME4-TRANSITION-TO-CLASS-COUNT-BRIDGE: General Regime4 Transition-to-Class-Count Growth Bridge and Fresh-Unary Refinement Bound (OQ-05 / RT-09)

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 36 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 36 Lean theorems in MinimalSeparation.lean. Establishes class count growth from 2 to 4 under Regime 4 transition. Tested in test_oq05_regime4_cl...
- Prose vs code gap: Prose describes this as the definitive bridge between primitive 2-point difference and 4-point structure. Lean formalization confirms the strict trajectory of c...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 36 Lean theorems in MinimalSeparation.lean. Establishes class count growth from 2 to 4 under Regime 4 transition. Tested in test_oq05_regime4_class_count.py. Vulnerability: Transition sequence is hand-constructed; does not evaluate branching transitions or adversarial inputs.
- *Prose vs Code*: Prose describes this as the definitive bridge between primitive 2-point difference and 4-point structure. Lean formalization confirms the strict trajectory of class counts along a designated sequence of forms.
- *Boundaries & Assumptions*: Boundary conditions: Initial count = 2; final count = 4; intermediate count = 3. Unstated assumption: added forms are strictly informative.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 3, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem establishing that uninformative form additions leave class count unchanged
- [Adversary 1 - Formal Soundness] Python property-based test generating all 256 possible form sequences to identify non-separating paths.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-24 in existing check script audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for OQ-05-REGIME4-TRANSITION-TO-CLASS-COUNT-BRIDGE.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-24 class count bridge and DER-08 multi-round closure.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-04', 'DER-06'] satisfy type preconditions and invariants of DER-24.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-24 satisfy input contracts for dependent nodes ['DER-08', 'DER-33'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'M2_indexed_context_family']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Verification that class count trajectory 2 -> 3 -> 4 executes without state rollback.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-24.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating OQ-05-REGIME4-TRANSITION-TO-CLASS-COUNT-BRIDGE across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-24 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate intermediate form to be identical to initial form; verify that strict growth fails
- [Adversary 1 - Formal Soundness] Invert class count comparison operator; verify that tests fail closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in OQ-05-REGIME4-TRANSITION-TO-CLASS-COUNT-BRIDGE checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-24).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-24 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-24 causes check failure).

---

#### `DER-26` — SLICE-XI-MULTI-ROUND-CAPACITY-SCALING-AND-ADAPTIVE-HORIZON: Exact Radius-d Separation Threshold, Endogenous Tag-Count Adaptive Horizon, and 2^k Memory Capacity Scaling (N22)

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 8 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['scripts/profile_preorder_and_generator_models.py', 'tests/test_profile_preorder_and_generator.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 8 Lean theorems in ProfilePreorderAndGenerator.lean. Establishes multi-round capacity scaling and adaptive horizon expansion. Vulnerability: Sca...
- Prose vs code gap: Prose describes adaptive horizon scaling as dynamically overcoming finite distinction limits. Lean code checks that incrementing horizon d by 1 expands the dist...
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 8 Lean theorems in ProfilePreorderAndGenerator.lean. Establishes multi-round capacity scaling and adaptive horizon expansion. Vulnerability: Scaling bounds are established under linear horizon incrementation; does not formalize sub-linear or exponential capacity limits.
- *Prose vs Code*: Prose describes adaptive horizon scaling as dynamically overcoming finite distinction limits. Lean code checks that incrementing horizon d by 1 expands the distinguishable boundary by a constant factor.
- *Boundaries & Assumptions*: Boundary conditions: Static horizon (d constant); infinite horizon limit; zero capacity growth. Unstated assumption: horizon expansion incurs linear cost.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 5, Outgoing edges: 4.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem establishing lower bounds on horizon cost under bounded memory
- [Adversary 1 - Formal Soundness] Python unit test testing capacity curves across varying horizon expansion rates.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-26 in existing check script scripts/profile_preorder_and_generator_models.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for SLICE-XI-MULTI-ROUND-CAPACITY-SCALING-AND-ADAPTIVE-HORIZON.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-26 capacity scaling and DER-34 distinction horizons.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-04', 'DER-03'] satisfy type preconditions and invariants of DER-26.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-26 satisfy input contracts for dependent nodes ['DER-23', 'OWE-13', 'DER-34'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'M2_indexed_context_family']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Simulation of adaptive horizon expansion under budget constraints, checking that expansion halts when cost exceeds budget.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-26.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating SLICE-XI-MULTI-ROUND-CAPACITY-SCALING-AND-ADAPTIVE-HORIZON across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-26 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate horizon scaling formula to zero growth; verify that adaptive capacity theorem fails
- [Adversary 1 - Formal Soundness] Invert budget inequality; verify that expansion termination fails closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in SLICE-XI-MULTI-ROUND-CAPACITY-SCALING-AND-ADAPTIVE-HORIZON checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-26).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-26 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-26 causes check failure).

---

#### `DER-31` — WDP-GENERATIVE-HISTORY-COMPRESSION: Witnessed-Difference Free Path Category, Question-Preserving Context Congruence, and Compressed History Quotient

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 21 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 21 Lean theorems in WitnessedDifference.GenerativeHistoryCompression. Formalizes compression of history traces into generative equivalence profi...
- Prose vs code gap: Prose claims optimal history compression preserving all future distinctness. Lean code establishes that generative equivalence profiles refine behavioral congru...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S3_endomorphism_composition', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 21 Lean theorems in WitnessedDifference.GenerativeHistoryCompression. Formalizes compression of history traces into generative equivalence profiles. Vulnerability: Zero dedicated Python tests in tests/ (only check_primitive_difference.py). Compression fidelity has not been exercised dynamically in Python.
- *Prose vs Code*: Prose claims optimal history compression preserving all future distinctness. Lean code establishes that generative equivalence profiles refine behavioral congruence on declared models.
- *Boundaries & Assumptions*: Boundary conditions: Empty history trace; cyclic history trace; unbounded linear trace. Unstated assumption: traces are sequences of discrete events.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 4.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S3_endomorphism_composition', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ verifying history compression algorithms
- [Adversary 1 - Formal Soundness] Lean theorem establishing that compressed profiles are minimal in length.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-GENERATIVE-HISTORY-COMPRESSION (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-31.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (21 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking DER-31 history compression with DER-32 genesis construction.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-31.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-31 satisfy input contracts for dependent nodes ['DER-32', 'DER-33', 'DER-37'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S3_endomorphism_composition']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Trace compression of 1000-step event history verifying that compressed state produces identical future observations as raw trace.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-31.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-GENERATIVE-HISTORY-COMPRESSION across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-31 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate compression function to drop a distinction bit; verify that profile equivalence fails
- [Adversary 1 - Formal Soundness] Invert trace order; verify that non-commutative history check fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-GENERATIVE-HISTORY-COMPRESSION checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-31).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-31 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-31 causes check failure).

---

#### `DER-32` — WDP-GENESIS-CONSTRUCTION-LITERAL-ROOT: Witnessed-Difference Genesis Replay, Typed History Extraction, and Literal Supply Root Construction

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 7 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 7 Lean theorems in WitnessedDifference.GenesisConstruction. Constructs literal root transition from compressed initial history. Vulnerability: Z...
- Prose vs code gap: Prose presents genesis construction as the foundational instantiation of distinction. Lean code verifies that the literal root satisfies base case inductive def...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 7 Lean theorems in WitnessedDifference.GenesisConstruction. Constructs literal root transition from compressed initial history. Vulnerability: Zero dedicated Python tests in tests/. Formalization is tightly coupled to GenerativeHistoryCompression.
- *Prose vs Code*: Prose presents genesis construction as the foundational instantiation of distinction. Lean code verifies that the literal root satisfies base case inductive definitions.
- *Boundaries & Assumptions*: Boundary conditions: Root node; first transition step. Unstated assumption: root node is unique.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 3, Outgoing edges: 3.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python test suite checking genesis state properties
- [Adversary 1 - Formal Soundness] Lean theorem establishing uniqueness of the literal root up to isomorphism.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-GENESIS-CONSTRUCTION-LITERAL-ROOT (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-32.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (7 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test connecting DER-32 genesis construction to DER-33 admission replay bridge.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-04', 'DER-31'] satisfy type preconditions and invariants of DER-32.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-32 satisfy input contracts for dependent nodes ['DER-33', 'DER-44', 'DER-45'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'M3_step_history_dynamics']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Verification of derivation graph initialization starting from DER-32 literal root.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-32.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-GENESIS-CONSTRUCTION-LITERAL-ROOT across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-32 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate literal root state initialization; verify that all downstream inductive proofs fail.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-GENESIS-CONSTRUCTION-LITERAL-ROOT checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-32).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-32 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-32 causes check failure).

---

#### `DER-33` — OMEGA-ADMISSION-REPLAY-WDP-BRIDGE: Omega Regime4-to-WitnessedDifference Admission Replay Adapter, Occurrence Pricing, and 365-Case Bounded Corpus

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 25 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py', 'tests/test_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 25 Lean theorems in AdmissionReplay.lean. Tested in tests/test_admission_replay.py (365 test cases). Soundly checks event traces (data, forms, i...
- Prose vs code gap: Prose describes admission replay as certifying operational reproducibility. Lean and Python implementations match closely for the declared 365 benchmark cases....
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 25 Lean theorems in AdmissionReplay.lean. Tested in tests/test_admission_replay.py (365 test cases). Soundly checks event traces (data, forms, instances) against independent context oracle. Vulnerability: Oracle evaluates finite instances by exhaustive iteration; does not test non-terminating or concurrent trace interleavings.
- *Prose vs Code*: Prose describes admission replay as certifying operational reproducibility. Lean and Python implementations match closely for the declared 365 benchmark cases.
- *Boundaries & Assumptions*: Boundary conditions: Empty trace; trace with malformed form indices; trace exceeding data bounds. Unstated assumption: events are strictly serialized.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 8, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Property-based tests generating random malformed event sequences
- [Adversary 1 - Formal Soundness] Lean theorem verifying that concurrent reordering of disjoint events preserves final state.
- [Adversary 2 - Mechanization] Assertion-hardened unit tests for DER-33 in existing check script scripts/check_primitive_difference.py (replacing print statements with explicit assertions).
- [Adversary 2 - Mechanization] Boundary condition unit tests on extreme input parameters and degenerate cases for OMEGA-ADMISSION-REPLAY-WDP-BRIDGE.
- [Adversary 2 - Mechanization] Negative control unit tests asserting that invalid states or malformed inputs raise structured exceptions.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test verifying that DER-33 validates traces produced by DER-31 compression.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-33.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-33 satisfy input contracts for dependent nodes ['DER-37'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S5_additive_cost_target']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Full replay of the 365-case corpus checking zero state divergence.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-33.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating OMEGA-ADMISSION-REPLAY-WDP-BRIDGE across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-33 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Inject corrupted event into replay trace; verify that verify_case raises ValueError
- [Adversary 1 - Formal Soundness] Mutate arity check from `arity < 1` to `arity < 0`; verify that zero-arity forms are rejected.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in OMEGA-ADMISSION-REPLAY-WDP-BRIDGE checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-33).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-33 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-33 causes check failure).

---

#### `DER-34` — WDP-FINITE-DISTINCTION-HORIZON-AND-MINIMAL-QUOTIENT: Witnessed-Difference Finite Horizon Relations, Stabilization Pigeonhole Bound, No-Escape Congruence, and Minimal Deterministic Quotient

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 34 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 34 Lean theorems in WitnessedDifference.FiniteDistinction. Constructs minimal quotients on finite distinction horizons. Vulnerability: Zero dedi...
- Prose vs code gap: Prose claims minimal quotient construction for finite distinction horizons. Lean proofs verify quotient properties on finite structures, but lack dynamic Python...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M1_carrier_multiplicity', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 34 Lean theorems in WitnessedDifference.FiniteDistinction. Constructs minimal quotients on finite distinction horizons. Vulnerability: Zero dedicated Python tests in tests/. Relies on Wd2 namespace; formalization assumes finite horizons without testing horizon boundary overflow.
- *Prose vs Code*: Prose claims minimal quotient construction for finite distinction horizons. Lean proofs verify quotient properties on finite structures, but lack dynamic Python execution.
- *Boundaries & Assumptions*: Boundary conditions: Horizon radius 0; radius exceeding graph diameter. Unstated assumption: distinction relations are decidable on the horizon.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 6, Outgoing edges: 3.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M1_carrier_multiplicity', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ for FiniteDistinction
- [Adversary 1 - Formal Soundness] Lean theorem establishing minimality of the quotient partition.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-FINITE-DISTINCTION-HORIZON-AND-MINIMAL-QUOTIENT (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-34.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (34 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-34 distinction horizons and DER-35 relational retention.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-04', 'DER-05'] satisfy type preconditions and invariants of DER-34.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-34 satisfy input contracts for dependent nodes ['DER-39', 'DER-40', 'DER-41'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'M1_carrier_multiplicity']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Verification of distinction horizon evaluation on growing relational structures.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-34.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-FINITE-DISTINCTION-HORIZON-AND-MINIMAL-QUOTIENT across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-34 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate distinction horizon radius; verify that quotient class collapse matches expected bounds.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-FINITE-DISTINCTION-HORIZON-AND-MINIMAL-QUOTIENT checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-34).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-34 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-34 causes check failure).

---

#### `DER-35` — WDP-RELATIONAL-RETENTION-BISIMULATION-AND-ACYCLIC-REACHABILITY: Witnessed-Difference Relational Retention, Greatest Bisimulation Quotient, Descending Refinement Stabilization, and Reachability Acyclicity

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 19 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 19 Lean theorems in WitnessedDifference.RelationalRetention. Establishes bisimulation and acyclic reachability invariants. Vulnerability: Zero d...
- Prose vs code gap: Prose claims general relational retention and reachability. Lean formalization restricts scope to acyclic directed structures....
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S4_retention_state_bit', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 19 Lean theorems in WitnessedDifference.RelationalRetention. Establishes bisimulation and acyclic reachability invariants. Vulnerability: Zero dedicated Python tests in tests/. Assumes relation is acyclic; does not handle cyclic retention networks.
- *Prose vs Code*: Prose claims general relational retention and reachability. Lean formalization restricts scope to acyclic directed structures.
- *Boundaries & Assumptions*: Boundary conditions: Empty relation; single-edge reachability; cyclic graph input. Unstated assumption: reachability is well-founded.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 7, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S4_retention_state_bit', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ for RelationalRetention
- [Adversary 1 - Formal Soundness] Lean theorem detecting cycle formation and returning refusal.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-RELATIONAL-RETENTION-BISIMULATION-AND-ACYCLIC-REACHABILITY (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-35.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (19 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test connecting DER-35 reachability invariants to DER-37 pair transport.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-35.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-35 satisfy input contracts for dependent nodes ['DER-36', 'DER-39'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S4_retention_state_bit']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Reachability trace evaluation across multi-node retention networks.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-35.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-RELATIONAL-RETENTION-BISIMULATION-AND-ACYCLIC-REACHABILITY across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-35 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Add a backward edge creating a cycle; verify that acyclic reachability checks fail closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-RELATIONAL-RETENTION-BISIMULATION-AND-ACYCLIC-REACHABILITY checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-35).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-35 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-35 causes check failure).

---

#### `DER-36` — WDP-RETENTION-CHOICES-AND-NONTRANSITIVE-TOLERANCE: Witnessed-Difference Structural Retention Packets, All-Word Tolerance Compatibility, Readout Descent, and Nontransitive Tolerance Countermodel

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 17 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 17 Lean theorems in WitnessedDifference.RetentionChoices. Formalizes tolerance relations violating transitivity under retention choices. Vulnera...
- Prose vs code gap: Prose discusses retention choices as introducing non-transitive tolerance. Lean formalization exhibits explicit counterexamples to transitivity....
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S4_retention_state_bit', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 17 Lean theorems in WitnessedDifference.RetentionChoices. Formalizes tolerance relations violating transitivity under retention choices. Vulnerability: Zero dedicated Python tests in tests/. Shows transitivity failure, but does not provide a constructive repair for non-transitive tolerance partitions.
- *Prose vs Code*: Prose discusses retention choices as introducing non-transitive tolerance. Lean formalization exhibits explicit counterexamples to transitivity.
- *Boundaries & Assumptions*: Boundary conditions: Transitive equivalence (special case); total non-transitive tolerance. Unstated assumption: tolerance relation is reflexive and symmetric.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 7, Outgoing edges: 0.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S4_retention_state_bit', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ for RetentionChoices
- [Adversary 1 - Formal Soundness] Lean theorem characterizing maximal cliques in non-transitive tolerance graphs.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-RETENTION-CHOICES-AND-NONTRANSITIVE-TOLERANCE (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-36.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (17 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-36 tolerance relations and DER-40 context reflection.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-36.
- [Adversary 2 - Mechanization] Terminal boundary integration tests checking that DER-36 exports valid terminal invariants or extension interfaces.
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S4_retention_state_bit']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Verification of non-transitive tolerance tracking across multi-step observation choices.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-36.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-RETENTION-CHOICES-AND-NONTRANSITIVE-TOLERANCE across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-36 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Force transitivity on tolerance relation; verify that countermodel theorems fail closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-RETENTION-CHOICES-AND-NONTRANSITIVE-TOLERANCE checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-36).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-36 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-36 causes check failure).

---

#### `DER-37` — WDP-SOURCE25-PAIR-TRANSPORT-AND-PAID-TRACE-PRESERVATION: Witnessed-Difference Seed-25 Pair Transport across Identification/Projection and Paid Partial-Run Trace Equivalence

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 10 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 10 Lean theorems in WitnessedDifference.Source25PairTransport. Formalizes pair transport along paid traces. Vulnerability: Zero dedicated Python...
- Prose vs code gap: Prose claims rigorous pair transport along paid operational traces. Lean code checks transport invariance under pre-paid hypotheses....
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 10 Lean theorems in WitnessedDifference.Source25PairTransport. Formalizes pair transport along paid traces. Vulnerability: Zero dedicated Python tests in tests/. Assumes cost target S5 is pre-paid; does not model budget exhaustion.
- *Prose vs Code*: Prose claims rigorous pair transport along paid operational traces. Lean code checks transport invariance under pre-paid hypotheses.
- *Boundaries & Assumptions*: Boundary conditions: Zero-length trace; trace with unpaid hops. Unstated assumption: transport along composition of paths is associative.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 7, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ for Source25PairTransport
- [Adversary 1 - Formal Soundness] Lean theorem evaluating transport failure under budget deficit.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-SOURCE25-PAIR-TRANSPORT-AND-PAID-TRACE-PRESERVATION (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-37.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (10 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-37 pair transport and DER-38 cochain transport.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-37.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-37 satisfy input contracts for dependent nodes ['DER-38'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S5_additive_cost_target']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Paid transport execution over a multi-hop path verifying endpoint distinction preservation.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-37.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-SOURCE25-PAIR-TRANSPORT-AND-PAID-TRACE-PRESERVATION across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-37 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Decrement allocated trace payment below required cost; verify that transport theorem fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-SOURCE25-PAIR-TRANSPORT-AND-PAID-TRACE-PRESERVATION checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-37).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-37 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-37 causes check failure).

---

#### `DER-39` — WDP-BEHAVIORAL-QUOTIENT-FINITE-WORDS: Witnessed-Difference Finite-Word Behavioral Equivalence, Bounded Refinement Stabilization, and Coarsest Observable Quotient

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 17 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 17 Lean theorems in WitnessedDifference.BehavioralQuotient. Formalizes behavioral quotients on finite words. Vulnerability: Zero dedicated Pytho...
- Prose vs code gap: Prose describes behavioral quotients on operational languages. Lean code demonstrates Nerode-style equivalence on finite word lists....
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S4_retention_state_bit', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 17 Lean theorems in WitnessedDifference.BehavioralQuotient. Formalizes behavioral quotients on finite words. Vulnerability: Zero dedicated Python tests in tests/. Word alphabet is assumed finite; does not formalize infinite words or omega-automata.
- *Prose vs Code*: Prose describes behavioral quotients on operational languages. Lean code demonstrates Nerode-style equivalence on finite word lists.
- *Boundaries & Assumptions*: Boundary conditions: Empty word; single-letter alphabet; word length exceeding memory bound. Unstated assumption: word concatenation is associative.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 6, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S4_retention_state_bit', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ for BehavioralQuotient
- [Adversary 1 - Formal Soundness] Lean theorem checking Myhill-Nerode finite index characterization.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-BEHAVIORAL-QUOTIENT-FINITE-WORDS (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-39.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (17 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-39 word quotients and DER-41 faithful representation.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-39.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-39 satisfy input contracts for dependent nodes ['DER-40', 'DER-41'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S4_retention_state_bit']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Language acceptance pipeline checking behavioral quotient state minimization.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-39.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-BEHAVIORAL-QUOTIENT-FINITE-WORDS across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-39 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Alter word transition rule to produce non-deterministic outputs; verify that quotient uniqueness fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-BEHAVIORAL-QUOTIENT-FINITE-WORDS checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-39).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-39 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-39 causes check failure).

---

#### `DER-40` — WDP-CONTEXT-REFLECTION-KERNEL-REFINEMENT: Witnessed-Difference Context-Word Kernel Refinement, Pair-Resolution Budget Lower Bounds, and Unconditional Refinement Failure

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 14 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 14 Lean theorems in WitnessedDifference.ContextReflection. Formalizes kernel refinement under context reflection. Vulnerability: Zero dedicated ...
- Prose vs code gap: Prose claims context reflection refines observer kernels. Lean theorems establish kernel inclusion relations under context mapping....
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 14 Lean theorems in WitnessedDifference.ContextReflection. Formalizes kernel refinement under context reflection. Vulnerability: Zero dedicated Python tests in tests/. Refinement is demonstrated for static context pairs; does not evaluate dynamic context adaptation.
- *Prose vs Code*: Prose claims context reflection refines observer kernels. Lean theorems establish kernel inclusion relations under context mapping.
- *Boundaries & Assumptions*: Boundary conditions: Trivial context reflection (identity); orthogonal context reflection. Unstated assumption: context maps are endomorphisms.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 5, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ for ContextReflection
- [Adversary 1 - Formal Soundness] Lean theorem demonstrating failure of kernel refinement under non-congruent context shifts.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-CONTEXT-REFLECTION-KERNEL-REFINEMENT (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-40.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (14 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking DER-40 context reflection with DER-41 faithful representations.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-04', 'DER-06'] satisfy type preconditions and invariants of DER-40.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-40 satisfy input contracts for dependent nodes ['DER-46'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'M2_indexed_context_family']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Refinement cascade test checking that successive context reflections monotonically shrink kernel fibers.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-40.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-CONTEXT-REFLECTION-KERNEL-REFINEMENT across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-40 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Invert context reflection direction; verify that kernel refinement inclusion is violated.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-CONTEXT-REFLECTION-KERNEL-REFINEMENT checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-40).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-40 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-40 causes check failure).

---

#### `DER-41` — WDP-FAITHFUL-REPRESENTATION-PROFILE-INJECTIVITY: Witnessed-Difference Faithful Profile Representation, Quotient Profile Injectivity, and 3-State Unfaithful Escape Countermodels

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 20 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 20 Lean theorems in WitnessedDifference.FaithfulRepresentation. Establishes profile injectivity for faithful representations. Vulnerability: Zer...
- Prose vs code gap: Prose claims faithful representation profile injectivity as a general property. Lean formalization establishes injectivity conditionally on representation faith...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S4_retention_state_bit', 'M1_carrier_multiplicity', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 20 Lean theorems in WitnessedDifference.FaithfulRepresentation. Establishes profile injectivity for faithful representations. Vulnerability: Zero dedicated Python tests in tests/. Injectivity is proven under the assumption that the representation separates all points; it does not derive when such representations exist.
- *Prose vs Code*: Prose claims faithful representation profile injectivity as a general property. Lean formalization establishes injectivity conditionally on representation faithfulness.
- *Boundaries & Assumptions*: Boundary conditions: Unfaithful representation (collapses points); minimal faithful representation. Unstated assumption: representation codomain has decidable equality.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 6, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S4_retention_state_bit', 'M1_carrier_multiplicity', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ for FaithfulRepresentation
- [Adversary 1 - Formal Soundness] Lean theorem characterizing minimal faithful representation dimension.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-FAITHFUL-REPRESENTATION-PROFILE-INJECTIVITY (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-41.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (20 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-41 profile injectivity and DER-43 observer descent.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-41.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-41 satisfy input contracts for dependent nodes ['DER-43'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S4_retention_state_bit']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Full representation check verifying that distinct system states map to distinct observable profiles.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-41.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-FAITHFUL-REPRESENTATION-PROFILE-INJECTIVITY across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-41 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Force representation to collapse two points; verify that profile injectivity theorem fails closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-FAITHFUL-REPRESENTATION-PROFILE-INJECTIVITY checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-41).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-41 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-41 causes check failure).

---

#### `DER-43` — WDP-OBSERVER-DESCENT-KERNEL-FACTORS: Witnessed-Difference Observer Kernel Descent, Unique Quotient Factorization, and Cross-Fiber Collapse Obstruction

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 6 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 6 Lean theorems in WitnessedDifference.ObserverDescent. Formalizes descent of operations through observer kernels. Vulnerability: Zero dedicated...
- Prose vs code gap: Prose describes observer descent as projecting operations onto observable quotients. Lean theorems establish existence of the factored map via Quotient.lift....
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S4_retention_state_bit'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 6 Lean theorems in WitnessedDifference.ObserverDescent. Formalizes descent of operations through observer kernels. Vulnerability: Zero dedicated Python tests in tests/. Establishes factorization only when kernel congruence is already satisfied; does not provide an algorithm for computing the descent map.
- *Prose vs Code*: Prose describes observer descent as projecting operations onto observable quotients. Lean theorems establish existence of the factored map via Quotient.lift.
- *Boundaries & Assumptions*: Boundary conditions: Discrete observer (every point observable); blind observer (single observation). Unstated assumption: operations commute with observation fibers.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 5, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S4_retention_state_bit'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ for ObserverDescent
- [Adversary 1 - Formal Soundness] Lean theorem demonstrating failure of descent when operation violates fiber invariance.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-OBSERVER-DESCENT-KERNEL-FACTORS (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-43.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (6 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking DER-43 observer descent with DER-44 original genesis observer.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'DER-05'] satisfy type preconditions and invariants of DER-43.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of DER-43 satisfy input contracts for dependent nodes ['DER-44', 'DER-52'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S4_retention_state_bit']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Operation execution test verifying that commuting operations descend identically on quotient spaces.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-43.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-OBSERVER-DESCENT-KERNEL-FACTORS across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-43 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Perturb operation on one fiber element; verify that descent factorization fails closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-OBSERVER-DESCENT-KERNEL-FACTORS checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-43).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-43 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-43 causes check failure).

---

#### `DER-44` — WDP-ORIGINAL-GENESIS-OBSERVER-SIX-FIELD-SIGNATURE: Witnessed-Difference Six-Field Original Genesis Observer, Reachable-Memory Quotient Descent, and O1/O2 Grammar-Replacement Invariance

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 18 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 18 Lean theorems in WitnessedDifference.OriginalGenesisObserver. Formalizes the six-field observer signature. Vulnerability: Zero dedicated Pyth...
- Prose vs code gap: Prose presents the six-field signature as the constitutional observer specification. Lean code defines the structure and demonstrates field preservation across ...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S4_retention_state_bit', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 18 Lean theorems in WitnessedDifference.OriginalGenesisObserver. Formalizes the six-field observer signature. Vulnerability: Zero dedicated Python tests in tests/. The six fields are an axiomatic bundle; formalization does not demonstrate minimality or independence of the six fields.
- *Prose vs Code*: Prose presents the six-field signature as the constitutional observer specification. Lean code defines the structure and demonstrates field preservation across transitions.
- *Boundaries & Assumptions*: Boundary conditions: Initial six-field state; saturated six-field state. Unstated assumption: the six fields are synchronous.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 6, Outgoing edges: 0.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S4_retention_state_bit', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ for OriginalGenesisObserver
- [Adversary 1 - Formal Soundness] Lean theorem establishing pairwise independence of the six observer fields.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-ORIGINAL-GENESIS-OBSERVER-SIX-FIELD-SIGNATURE (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-44.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (18 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-44 genesis observer and DER-46 context floor.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-03', 'OWE-04'] satisfy type preconditions and invariants of DER-44.
- [Adversary 2 - Mechanization] Terminal boundary integration tests checking that DER-44 exports valid terminal invariants or extension interfaces.
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'S4_retention_state_bit']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Observer lifecycle simulation updating all six fields across a 50-step run.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-44.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-ORIGINAL-GENESIS-OBSERVER-SIX-FIELD-SIGNATURE across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-44 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Omit one of the six observer fields; verify that observer update contracts fail.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-ORIGINAL-GENESIS-OBSERVER-SIX-FIELD-SIGNATURE checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-44).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-44 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-44 causes check failure).

---

#### `DER-46` — WDP-PRIMITIVE-CONTEXT-FLOOR-SEPARATION: Witnessed-Difference Primitive Context Floor, Context-Driven Separation, and Non-Collapsible Guarded Readings

- **Layer**: `3_POST_SEAL_SEPARATION_AND_RETENTION` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 11 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 11 Lean theorems in WitnessedDifference.PrimitiveContextFloor. Establishes primitive context floor separation. Vulnerability: Zero dedicated Pyt...
- Prose vs code gap: Prose claims an unalterable primitive context floor. Lean code demonstrates that context reductions below the floor fail to separate primitive differences....
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 11 Lean theorems in WitnessedDifference.PrimitiveContextFloor. Establishes primitive context floor separation. Vulnerability: Zero dedicated Python tests in tests/. Assumes discrete context floor; does not evaluate continuous or infinite context limits.
- *Prose vs Code*: Prose claims an unalterable primitive context floor. Lean code demonstrates that context reductions below the floor fail to separate primitive differences.
- *Boundaries & Assumptions*: Boundary conditions: Contexts at the floor vs below the floor. Unstated assumption: contexts are finite collections of tests.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 5, Outgoing edges: 0.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Dedicated Python unit test suite in tests/ for PrimitiveContextFloor
- [Adversary 1 - Formal Soundness] Lean theorem establishing that sub-floor contexts collapse distinction.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the mathematical structures of WDP-PRIMITIVE-CONTEXT-FLOOR-SEPARATION (currently binds only to Lean meta-validation scripts).
- [Adversary 2 - Mechanization] Input validation unit tests for edge-case carriers (empty sets, singletons, boundary dimensions) in DER-46.
- [Adversary 2 - Mechanization] Direct computation unit tests checking theorem invariants (11 theorems) in an executable Python engine.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test connecting DER-46 context floor to DER-45 admission floor.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-01', 'OWE-04', 'DER-06'] satisfy type preconditions and invariants of DER-46.
- [Adversary 2 - Mechanization] Terminal boundary integration tests checking that DER-46 exports valid terminal invariants or extension interfaces.
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['S0_lean_core_host', 'M2_indexed_context_family']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Verification that no context pruning algorithm can reduce context depth below the floor.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 3_POST_SEAL_SEPARATION_AND_RETENTION including DER-46.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-PRIMITIVE-CONTEXT-FLOOR-SEPARATION across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for DER-46 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate context floor threshold by decrementing by 1; verify that separation proofs fail.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-PRIMITIVE-CONTEXT-FLOOR-SEPARATION checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in DER-46).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into DER-46 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in DER-46 causes check failure).

---

### Layer: 6_OWED_BRIDGES (8 Nodes)

#### `OWE-05` — PG-R-GAP-DIAMOND-TO-ROOT: Pre-Genesis Diamond-to-Root Bridge Obligation

- **Layer**: `6_OWED_BRIDGES` | **Bucket**: `OWED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `False`; Checks: `[]`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Represents the open bridge from causal diamonds to the literal root. Awaiting...
- Prose vs code gap: Prose describes this bridge as connecting causal diamond boundaries to the genesis root. No formalization or mechanization exists in the codebase....
- Mechanization vulnerability: Missing dedicated executable Python property tests.
- Admissions dependency: Relies on unpriced inputs ['pg_r_gap_diamond_to_root_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Represents the open bridge from causal diamonds to the literal root. Awaiting constructive derivation or minimal-premise reduction.
- *Prose vs Code*: Prose describes this bridge as connecting causal diamond boundaries to the genesis root. No formalization or mechanization exists in the codebase.
- *Boundaries & Assumptions*: Boundary conditions: Single diamond vs intersecting diamond network. Unstated assumption: causal horizons admit constructive boundary definitions.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 1, Outgoing edges: 0.
- *Admission Traceability*: Declared unpriced admissions: ['pg_r_gap_diamond_to_root_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Constructive Lean formalization of diamond-to-root boundary reduction
- [Adversary 1 - Formal Soundness] Python unit test verifying diamond interval intersections.
- [Adversary 2 - Mechanization] Unit tests validating formal specification and boundary conditions for OWE-05 (PG-R-GAP-DIAMOND-TO-ROOT).
- [Adversary 2 - Mechanization] Negative control unit tests verifying that violating declared admission ['pg_r_gap_diamond_to_root_admission'] triggers explicit validation failure.
- [Adversary 2 - Mechanization] Parametric variation unit tests over candidate carrier and pricing bounds for OWE-05.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test connecting OWE-05 to DER-32 genesis construction.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-02'] satisfy type preconditions and invariants of OWE-05.
- [Adversary 2 - Mechanization] Terminal boundary integration tests checking that OWE-05 exports valid terminal invariants or extension interfaces.
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['pg_r_gap_diamond_to_root_admission']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Verification of diamond-based event propagation reaching the root mark.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 6_OWED_BRIDGES including OWE-05.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating PG-R-GAP-DIAMOND-TO-ROOT across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for OWE-05 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Inject spatial discontinuity into causal diamond; verify that reduction checks fail closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in PG-R-GAP-DIAMOND-TO-ROOT checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in OWE-05).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into OWE-05 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in OWE-05 causes check failure).

---

#### `OWE-06` — PG-R-GAP-GENESIS-TO-WINDOW: Genesis-to-Window Multiplicity and Finite Carrier Selection Bridge

- **Layer**: `6_OWED_BRIDGES` | **Bucket**: `OWED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/4_frozen_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems. Mechanization in 4_frozen_checks.py. Represents the bridge from genesis mark to non-quotient carrier exp...
- Prose vs code gap: Prose describes the transition from cardinality 2 to 3. Lean formalization achieves this through products (Bool x Bool), leaving the non-product route open....
- Admissions dependency: Relies on unpriced inputs ['pg_r_gap_genesis_to_window_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems. Mechanization in 4_frozen_checks.py. Represents the bridge from genesis mark to non-quotient carrier expansion beyond cardinality 2 without product formation. Narrowed by DER-29 (pair quotient), but single-copy carrier growth remains unclosed.
- *Prose vs Code*: Prose describes the transition from cardinality 2 to 3. Lean formalization achieves this through products (Bool x Bool), leaving the non-product route open.
- *Boundaries & Assumptions*: Boundary conditions: Binary carrier (cardinality 2); ternary carrier (cardinality 3). Unstated assumption: carrier expansion preserves distinction without auxiliary dimensions.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 2, Outgoing edges: 0.
- *Admission Traceability*: Declared unpriced admissions: ['pg_r_gap_genesis_to_window_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean formalization of endogenous single-carrier expansion
- [Adversary 1 - Formal Soundness] Python unit test testing non-product 3-state state machine.
- [Adversary 2 - Mechanization] Unit tests validating formal specification and boundary conditions for OWE-06 (PG-R-GAP-GENESIS-TO-WINDOW).
- [Adversary 2 - Mechanization] Negative control unit tests verifying that violating declared admission ['pg_r_gap_genesis_to_window_admission'] triggers explicit validation failure.
- [Adversary 2 - Mechanization] Parametric variation unit tests over candidate carrier and pricing bounds for OWE-06.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between OWE-06 and DER-29 pair quotient.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['DER-04', 'DER-29'] satisfy type preconditions and invariants of OWE-06.
- [Adversary 2 - Mechanization] Terminal boundary integration tests checking that OWE-06 exports valid terminal invariants or extension interfaces.
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['pg_r_gap_genesis_to_window_admission']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Verification of single-copy carrier growth without product-space embedding.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 6_OWED_BRIDGES including OWE-06.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating PG-R-GAP-GENESIS-TO-WINDOW across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for OWE-06 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Force carrier cardinality to 2; verify that non-product expansion checks fail closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in PG-R-GAP-GENESIS-TO-WINDOW checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in OWE-06).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into OWE-06 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in OWE-06 causes check failure).

---

#### `OWE-07` — N21-N22-INTERNAL-WITNESSING-AND-PERSISTENCE: Operational Internal Witness Acquisition and Endogenous Rule Invocation (N21)

- **Layer**: `6_OWED_BRIDGES` | **Bucket**: `OWED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `False`; Checks: `[]`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts in its own entry (reduced conditionally in DER-56). Represents internal witnes...
- Prose vs code gap: Prose describes autonomous witness acquisition. Formalization in DER-56 establishes that autonomous two-state systems exhaust their observation orbits by step 2...
- Mechanization vulnerability: Missing dedicated executable Python property tests.
- Admissions dependency: Relies on unpriced inputs ['operational_witness_acquisition_invocation_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts in its own entry (reduced conditionally in DER-56). Represents internal witnessing rule acquisition without external caller or constructor splitting. Awaiting constructive discharge.
- *Prose vs Code*: Prose describes autonomous witness acquisition. Formalization in DER-56 establishes that autonomous two-state systems exhaust their observation orbits by step 2, confirming that novel witness acquisition requires external unfreezing.
- *Boundaries & Assumptions*: Boundary conditions: Autonomous 2-state system (orbit exhausted at step 2); multi-state system. Unstated assumption: witness generation requires non-empty internal memory.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 2, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['operational_witness_acquisition_invocation_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean constructive formalization of endogenous rule acquisition on n-state carriers
- [Adversary 1 - Formal Soundness] Python unit test simulating autonomous witness generation without external inputs.
- [Adversary 2 - Mechanization] Unit tests validating formal specification and boundary conditions for OWE-07 (N21-N22-INTERNAL-WITNESSING-AND-PERSISTENCE).
- [Adversary 2 - Mechanization] Negative control unit tests verifying that violating declared admission ['operational_witness_acquisition_invocation_admission'] triggers explicit validation failure.
- [Adversary 2 - Mechanization] Parametric variation unit tests over candidate carrier and pricing bounds for OWE-07.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking OWE-07 resolution to conditional node DER-23.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['DER-06', 'DER-56'] satisfy type preconditions and invariants of OWE-07.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of OWE-07 satisfy input contracts for dependent nodes ['DER-23'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['operational_witness_acquisition_invocation_admission']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Multi-step run demonstrating autonomous rule generation without constructor splitting.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 6_OWED_BRIDGES including OWE-07.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating N21-N22-INTERNAL-WITNESSING-AND-PERSISTENCE across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for OWE-07 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Inhibit state transition; verify that autonomous witness acquisition fails immediately.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in N21-N22-INTERNAL-WITNESSING-AND-PERSISTENCE checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in OWE-07).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into OWE-07 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in OWE-07 causes check failure).

---

#### `OWE-08` — N19-N20-TEN-STICK-REFLECTION-AND-FOUR-STEP-LIFT: Endogenous Sheet-Flip Holonomy Forcing and Ten-Stick Carrier Selection Beyond Minimal n = 3 (N19-N20)

- **Layer**: `6_OWED_BRIDGES` | **Bucket**: `OWED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/3_regime_deletions.py', 'scripts/profile_preorder_and_generator_models.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems in its own entry (reduced conditionally in DER-56; checked in 3_regime_deletions.py and profile_preorder_...
- Prose vs code gap: Prose emphasizes the necessity of 4-step holonomy and 10-stick carriers. Lean code in DER-56 demonstrates that 2-step irreflexivity uniquely selects sheet-flip ...
- Admissions dependency: Relies on unpriced inputs ['ten_stick_carrier_and_period_four_necessity_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems in its own entry (reduced conditionally in DER-56; checked in 3_regime_deletions.py and profile_preorder_and_generator_models.py). Represents endogenous forcing of 4-step sheet-flip holonomy over 2-step trivial lift, and endogenous selection of n = 10 over the minimal n = 3 threshold.
- *Prose vs Code*: Prose emphasizes the necessity of 4-step holonomy and 10-stick carriers. Lean code in DER-56 demonstrates that 2-step irreflexivity uniquely selects sheet-flip holonomy, but the choice of 2-step irreflexivity itself remains an unforced premise.
- *Boundaries & Assumptions*: Boundary conditions: Carrier sizes n = 3 (minimal threshold) vs n = 10 (disjoint probes threshold). Unstated assumption: probes must be pairwise disjoint.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 3, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['ten_stick_carrier_and_period_four_necessity_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem establishing endogenous necessity of 2-step irreflexivity
- [Adversary 1 - Formal Soundness] Python property-based test testing holonomy across all 2-step lifts.
- [Adversary 2 - Mechanization] Unit tests validating formal specification and boundary conditions for OWE-08 (N19-N20-TEN-STICK-REFLECTION-AND-FOUR-STEP-LIFT).
- [Adversary 2 - Mechanization] Negative control unit tests verifying that violating declared admission ['ten_stick_carrier_and_period_four_necessity_admission'] triggers explicit validation failure.
- [Adversary 2 - Mechanization] Parametric variation unit tests over candidate carrier and pricing bounds for OWE-08.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking OWE-08 discharge to conditional node DER-22.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['DER-03', 'DER-25', 'DER-56'] satisfy type preconditions and invariants of OWE-08.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of OWE-08 satisfy input contracts for dependent nodes ['DER-22', 'OWE-10'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['ten_stick_carrier_and_period_four_necessity_admission']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Verification of end-to-end phase evolution under endogenous sheet-flip forcing.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 6_OWED_BRIDGES including OWE-08.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating N19-N20-TEN-STICK-REFLECTION-AND-FOUR-STEP-LIFT across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for OWE-08 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Permit 2-step fixed points; verify that trivial lift becomes admissible and sheet-flip uniqueness fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in N19-N20-TEN-STICK-REFLECTION-AND-FOUR-STEP-LIFT checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in OWE-08).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into OWE-08 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in OWE-08 causes check failure).

---

#### `OWE-09` — L1-R-RESIDUAL-TO-WEIGHTS: Cross-Orbit Positive Cochain Weight Ratio Selection on Non-Transitive Quotients (OQ-07 / RT-11)

- **Layer**: `6_OWED_BRIDGES` | **Bucket**: `OWED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 4 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as NON_PERFECTED. Carries 4 Lean theorems in LocalGlobalObstruction.lean and Python checks in 11_oq05_to_oq08_checks.py. Represents cross-orbit weigh...
- Prose vs code gap: Prose notes that L1 weights are uniquely determined once independent fundamental cycle costs are supplied. The Lean formalization in DER-56 confirms uniqueness ...
- Admissions dependency: Relies on unpriced inputs ['canonical_admissibility_pricing_functional_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as NON_PERFECTED. Carries 4 Lean theorems in LocalGlobalObstruction.lean and Python checks in 11_oq05_to_oq08_checks.py. Represents cross-orbit weight ratio calibration on non-edge-transitive graphs. Automorphism invariance leaves weight ratios free; calibration requires external loop cost inputs.
- *Prose vs Code*: Prose notes that L1 weights are uniquely determined once independent fundamental cycle costs are supplied. The Lean formalization in DER-56 confirms uniqueness for declared cycle incidence matrices.
- *Boundaries & Assumptions*: Boundary conditions: Linearly dependent cycle incidences (calibration fails); singular incidence matrix. Unstated assumption: loop costs are strictly positive rational values.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 3, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['canonical_admissibility_pricing_functional_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem establishing full Cramer rule solvability for k-orbit calibration
- [Adversary 1 - Formal Soundness] Python unit test testing weight calibration on random non-edge-transitive graphs.
- [Adversary 2 - Mechanization] Unit tests validating formal specification and boundary conditions for OWE-09 (L1-R-RESIDUAL-TO-WEIGHTS).
- [Adversary 2 - Mechanization] Negative control unit tests verifying that violating declared admission ['canonical_admissibility_pricing_functional_admission'] triggers explicit validation failure.
- [Adversary 2 - Mechanization] Parametric variation unit tests over candidate carrier and pricing bounds for OWE-09.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test connecting OWE-09 weight calibration with DER-27 orbit cochain weights.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['DER-14', 'DER-27', 'DER-56'] satisfy type preconditions and invariants of OWE-09.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of OWE-09 satisfy input contracts for dependent nodes ['IMG-03'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['canonical_admissibility_pricing_functional_admission']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Full calibration pipeline taking cycle costs and outputting calibrated edge weights for L1 minimization.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 6_OWED_BRIDGES including OWE-09.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating L1-R-RESIDUAL-TO-WEIGHTS across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for OWE-09 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Make two cycle incidence vectors linearly dependent; verify that weight determination fails closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in L1-R-RESIDUAL-TO-WEIGHTS checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in OWE-09).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into OWE-09 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in OWE-09 causes check failure).

---

#### `OWE-10` — N23-N26-PROFILE-PREORDER-AND-CONTINUUM-ADMISSION: Profile Preorder, Unconditional Closure, and Continuum Completeness Bridge (N23, N25, N26)

- **Layer**: `6_OWED_BRIDGES` | **Bucket**: `OWED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/5_forcing_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems. Checked in 5_forcing_checks.py. Represents the bridge from discrete profile preorders (N23) to continuum...
- Prose vs code gap: Prose discusses continuous emergence and real completeness. No formalization of Dedekind cuts, Cauchy sequences, or continuum topology exists in the repository....
- Admissions dependency: Relies on unpriced inputs ['infinite_completion_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems. Checked in 5_forcing_checks.py. Represents the bridge from discrete profile preorders (N23) to continuum real completeness (N26) and continuous limits. Awaiting formalization.
- *Prose vs Code*: Prose discusses continuous emergence and real completeness. No formalization of Dedekind cuts, Cauchy sequences, or continuum topology exists in the repository.
- *Boundaries & Assumptions*: Boundary conditions: Discrete rational values vs continuous real numbers. Unstated assumption: discrete lattices converge to continuum manifolds.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 3, Outgoing edges: 0.
- *Admission Traceability*: Declared unpriced admissions: ['infinite_completion_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Constructive Lean formalization of Cauchy completeness on discrete metric quotients
- [Adversary 1 - Formal Soundness] Python numerical test checking continuum convergence rates.
- [Adversary 2 - Mechanization] Unit tests validating formal specification and boundary conditions for OWE-10 (N23-N26-PROFILE-PREORDER-AND-CONTINUUM-ADMISSION).
- [Adversary 2 - Mechanization] Negative control unit tests verifying that violating declared admission ['infinite_completion_admission'] triggers explicit validation failure.
- [Adversary 2 - Mechanization] Parametric variation unit tests over candidate carrier and pricing bounds for OWE-10.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between OWE-10 and DER-21 profile preorder equivalence.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['OWE-08', 'DER-30', 'DER-55'] satisfy type preconditions and invariants of OWE-10.
- [Adversary 2 - Mechanization] Terminal boundary integration tests checking that OWE-10 exports valid terminal invariants or extension interfaces.
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['infinite_completion_admission']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Continuum scaling limit test checking convergence of discrete defect sums to smooth integrals.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 6_OWED_BRIDGES including OWE-10.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating N23-N26-PROFILE-PREORDER-AND-CONTINUUM-ADMISSION across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for OWE-10 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Introduce non-Cauchy oscillation in refinement sequence; verify that continuum limit check fails closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in N23-N26-PROFILE-PREORDER-AND-CONTINUUM-ADMISSION checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in OWE-10).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into OWE-10 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in OWE-10 causes check failure).

---

#### `OWE-12` — OQ-08-LEGACY-REPRESENTED-HORIZON-BRIDGE: Source-Level Bridge Between Prose WDP-CH01-D03 and Pinned Legacy Represented/Horizon (OQ-08)

- **Layer**: `6_OWED_BRIDGES` | **Bucket**: `OWED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems in its own entry (reduced conditionally in DER-56; checked in 11_oq05_to_oq08_checks.py). Represents mult...
- Prose vs code gap: Prose describes OWE-12 as the bridge removing the zero-cost restriction from DER-12. Lean formalization in DER-56 establishes that positive-cost traces are admi...
- Admissions dependency: Relies on unpriced inputs ['wdp_ch01_d03_full_represented_world_bridge_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems in its own entry (reduced conditionally in DER-56; checked in 11_oq05_to_oq08_checks.py). Represents multi-locus view decomposition and positive-cost budget compensation for replay commutation. Awaiting unconditional discharge.
- *Prose vs Code*: Prose describes OWE-12 as the bridge removing the zero-cost restriction from DER-12. Lean formalization in DER-56 establishes that positive-cost traces are admissible iff zero-cost traces are admissible under a compensated budget.
- *Boundaries & Assumptions*: Boundary conditions: Zero auxiliary costs (cSup=cAdm=cRet=0) vs positive unit costs. Unstated assumption: cost compensation is strictly additive.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 3, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['wdp_ch01_d03_full_represented_world_bridge_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem verifying budget compensation under variable cost rates
- [Adversary 1 - Formal Soundness] Python unit test evaluating compensated budgets across 100 random traces.
- [Adversary 2 - Mechanization] Unit tests validating formal specification and boundary conditions for OWE-12 (OQ-08-LEGACY-REPRESENTED-HORIZON-BRIDGE).
- [Adversary 2 - Mechanization] Negative control unit tests verifying that violating declared admission ['wdp_ch01_d03_full_represented_world_bridge_admission'] triggers explicit validation failure.
- [Adversary 2 - Mechanization] Parametric variation unit tests over candidate carrier and pricing bounds for OWE-12.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test connecting OWE-12 resolution to conditional node DER-12.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['DER-09', 'DER-28', 'DER-56'] satisfy type preconditions and invariants of OWE-12.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of OWE-12 satisfy input contracts for dependent nodes ['DER-12'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['wdp_ch01_d03_full_represented_world_bridge_admission']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Multi-locus trace replay under positive costs verifying commutation under compensated budgets.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 6_OWED_BRIDGES including OWE-12.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating OQ-08-LEGACY-REPRESENTED-HORIZON-BRIDGE across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for OWE-12 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Under-compensate the budget by 1 unit; verify that admissibility of positive-cost trace fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in OQ-08-LEGACY-REPRESENTED-HORIZON-BRIDGE checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in OWE-12).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into OWE-12 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in OWE-12 causes check failure).

---

#### `OWE-13` — N22-MULTI-ROUND-LAW-AND-REPAIR-PERSISTENCE-BRIDGE: Endogenous Non-Supplied Multi-Round Rule Acquisition and Repair Persistence (N22)

- **Layer**: `6_OWED_BRIDGES` | **Bucket**: `OWED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `True`; Meta-Validation Only: `False`; Checks: `['scripts/profile_preorder_and_generator_models.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems in its own entry (reduced conditionally in DER-56; checked in profile_preorder_and_generator_models.py). ...
- Prose vs code gap: Prose describes state-mutation repair under fixed-radius observation. Lean formalization in DER-56 establishes that adding a shortcut edge restores radius-1 vis...
- Admissions dependency: Relies on unpriced inputs ['multi_round_law_and_repair_persistence_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems in its own entry (reduced conditionally in DER-56; checked in profile_preorder_and_generator_models.py). Represents multi-round law persistence and repair without an unbounded alphabet. Awaiting unconditional discharge.
- *Prose vs Code*: Prose describes state-mutation repair under fixed-radius observation. Lean formalization in DER-56 establishes that adding a shortcut edge restores radius-1 visibility, whereas vertex-label mutations cannot.
- *Boundaries & Assumptions*: Boundary conditions: Graph distance n < 2d + 3 vs n >= 2d + 3; shortcut edge addition (distance = 1). Unstated assumption: graph rewiring is an admissible operational transition.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 3, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['multi_round_law_and_repair_persistence_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem demonstrating that shortcut-edge addition preserves overall graph planar topology
- [Adversary 1 - Formal Soundness] Python unit test verifying repair persistence across 50 multi-round steps.
- [Adversary 2 - Mechanization] Unit tests validating formal specification and boundary conditions for OWE-13 (N22-MULTI-ROUND-LAW-AND-REPAIR-PERSISTENCE-BRIDGE).
- [Adversary 2 - Mechanization] Negative control unit tests verifying that violating declared admission ['multi_round_law_and_repair_persistence_admission'] triggers explicit validation failure.
- [Adversary 2 - Mechanization] Parametric variation unit tests over candidate carrier and pricing bounds for OWE-13.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test connecting OWE-13 resolution to conditional node DER-23.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['DER-26', 'DER-06', 'DER-56'] satisfy type preconditions and invariants of OWE-13.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of OWE-13 satisfy input contracts for dependent nodes ['DER-23'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['multi_round_law_and_repair_persistence_admission']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Multi-round repair execution demonstrating persistent distinctness under bounded alphabet.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 6_OWED_BRIDGES including OWE-13.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating N22-MULTI-ROUND-LAW-AND-REPAIR-PERSISTENCE-BRIDGE across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for OWE-13 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Restrict repairs to vertex relabeling only; verify that depth-d collision persists.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in N22-MULTI-ROUND-LAW-AND-REPAIR-PERSISTENCE-BRIDGE checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in OWE-13).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into OWE-13 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in OWE-13 causes check failure).

---

### Layer: 7_IMAGINED_COSMOS_EXTENSION (10 Nodes)

#### `IMG-01` — WDP-HIGHER-SEMI-SIMPLICIAL-COHOMOLOGY: Higher k-Simplex WDP Cochain Complexes and Non-Abelian Presheaf Cohomology

- **Layer**: `7_IMAGINED_COSMOS_EXTENSION` | **Bucket**: `IMAGINED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `False`; Checks: `[]`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Prospective downstream stage targeting higher semi-simplicial cochain complex...
- Prose vs code gap: Prose roadmap envisions higher semi-simplicial extensions. Zero lines of code exist in this repository....
- Mechanization vulnerability: Missing dedicated executable Python property tests.
- Admissions dependency: Relies on unpriced inputs ['higher_simplicial_carrier_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Prospective downstream stage targeting higher semi-simplicial cochain complexes and non-abelian presheaf cohomology. Entirely unformalized and unmechanized.
- *Prose vs Code*: Prose roadmap envisions higher semi-simplicial extensions. Zero lines of code exist in this repository.
- *Boundaries & Assumptions*: Boundary conditions: Unspecified simplicial dimensions; non-abelian group structures. Unstated assumption: semi-simplicial sets admit constructive coboundary definitions.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['higher_simplicial_carrier_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Constructive Lean formalization of semi-simplicial cochain complexes
- [Adversary 1 - Formal Soundness] Python unit test verifying coboundary nilpotence d^2 = 0 on presheaves.
- [Adversary 2 - Mechanization] Specification unit tests checking interface signatures and mathematical type contracts for proposed stage IMG-01.
- [Adversary 2 - Mechanization] Boundary unit tests for initial state configurations and dimension parameters of WDP-HIGHER-SEMI-SIMPLICIAL-COHOMOLOGY.
- [Adversary 2 - Mechanization] Negative control unit tests ensuring unverified downstream conjectures in IMG-01 are not accepted by mock evaluators.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking IMG-01 with DER-55 pentachoron exactness.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['DER-13', 'DER-15', 'DER-30'] satisfy type preconditions and invariants of IMG-01.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of IMG-01 satisfy input contracts for dependent nodes ['IMG-07', 'IMG-08'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['higher_simplicial_carrier_admission']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Presheaf cohomology calculation on a triangulated manifold.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 7_IMAGINED_COSMOS_EXTENSION including IMG-01.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating WDP-HIGHER-SEMI-SIMPLICIAL-COHOMOLOGY across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for IMG-01 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Inject non-associative groupoid into presheaf; verify that cochain exactness fails closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in WDP-HIGHER-SEMI-SIMPLICIAL-COHOMOLOGY checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in IMG-01).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into IMG-01 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in IMG-01 causes check failure).

---

#### `IMG-02` — STAGE-05-OBSERVER-FUNCTOR-CAUSAL-DIAMONDS: Observer Functor, Causal Diamonds, and Local Clock Synchronization

- **Layer**: `7_IMAGINED_COSMOS_EXTENSION` | **Bucket**: `IMAGINED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `False`; Checks: `[]`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Prospective downstream stage targeting observer functors, causal diamonds, an...
- Prose vs code gap: Prose discusses causal diamonds and clock synchronization. Zero formal code exists in the repository....
- Mechanization vulnerability: Missing dedicated executable Python property tests.
- Admissions dependency: Relies on unpriced inputs ['causal_poset_window_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Prospective downstream stage targeting observer functors, causal diamonds, and local clock synchronization.
- *Prose vs Code*: Prose discusses causal diamonds and clock synchronization. Zero formal code exists in the repository.
- *Boundaries & Assumptions*: Boundary conditions: Single observer clock; distributed asynchronous observer network. Unstated assumption: partial order of causal events is locally finite.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 1, Outgoing edges: 0.
- *Admission Traceability*: Declared unpriced admissions: ['causal_poset_window_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean formalization of poset causal diamond topologies
- [Adversary 1 - Formal Soundness] Python simulation of Lamport / vector clock synchronization.
- [Adversary 2 - Mechanization] Specification unit tests checking interface signatures and mathematical type contracts for proposed stage IMG-02.
- [Adversary 2 - Mechanization] Boundary unit tests for initial state configurations and dimension parameters of STAGE-05-OBSERVER-FUNCTOR-CAUSAL-DIAMONDS.
- [Adversary 2 - Mechanization] Negative control unit tests ensuring unverified downstream conjectures in IMG-02 are not accepted by mock evaluators.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test connecting IMG-02 to OWE-05 causal diamond gap.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['DER-12'] satisfy type preconditions and invariants of IMG-02.
- [Adversary 2 - Mechanization] Terminal boundary integration tests checking that IMG-02 exports valid terminal invariants or extension interfaces.
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['causal_poset_window_admission']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Multi-observer causal network simulation verifying synchronization without global clock.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 7_IMAGINED_COSMOS_EXTENSION including IMG-02.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating STAGE-05-OBSERVER-FUNCTOR-CAUSAL-DIAMONDS across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for IMG-02 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Inject acausal cycle; verify that clock synchronization rejects the network.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in STAGE-05-OBSERVER-FUNCTOR-CAUSAL-DIAMONDS checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in IMG-02).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into IMG-02 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in IMG-02 causes check failure).

---

#### `IMG-03` — STAGE-06-L1-TO-L2-COMPLEX-AMPLITUDE-LIFT: L1-to-L2 Parseval Phase Bridge and Complex Hilbert Amplitude Emergence

- **Layer**: `7_IMAGINED_COSMOS_EXTENSION` | **Bucket**: `IMAGINED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `False`; Checks: `[]`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Prospective downstream stage targeting L1-to-L2 Parseval phase bridge and com...
- Prose vs code gap: Prose envisions deriving complex quantum amplitudes from discrete L1 defect norms. Zero formal definitions or proofs exist in the repository....
- Mechanization vulnerability: Missing dedicated executable Python property tests.
- Admissions dependency: Relies on unpriced inputs ['parseval_l2_pairing_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Prospective downstream stage targeting L1-to-L2 Parseval phase bridge and complex Hilbert amplitude emergence.
- *Prose vs Code*: Prose envisions deriving complex quantum amplitudes from discrete L1 defect norms. Zero formal definitions or proofs exist in the repository.
- *Boundaries & Assumptions*: Boundary conditions: L1 norm vs L2 norm; phase emergence threshold. Unstated assumption: discrete L1 defects map isometrically into complex Hilbert space.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 2, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['parseval_l2_pairing_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean formalization of Parseval identity on discrete finite sequences
- [Adversary 1 - Formal Soundness] Python property-based test testing L1-to-L2 norm inequalities.
- [Adversary 2 - Mechanization] Specification unit tests checking interface signatures and mathematical type contracts for proposed stage IMG-03.
- [Adversary 2 - Mechanization] Boundary unit tests for initial state configurations and dimension parameters of STAGE-06-L1-TO-L2-COMPLEX-AMPLITUDE-LIFT.
- [Adversary 2 - Mechanization] Negative control unit tests ensuring unverified downstream conjectures in IMG-03 are not accepted by mock evaluators.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between IMG-03 and DER-30 L1 optimization.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['DER-13', 'OWE-09'] satisfy type preconditions and invariants of IMG-03.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of IMG-03 satisfy input contracts for dependent nodes ['IMG-04', 'IMG-06'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['parseval_l2_pairing_admission']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Verification of amplitude extraction from discrete defect distributions.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 7_IMAGINED_COSMOS_EXTENSION including IMG-03.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating STAGE-06-L1-TO-L2-COMPLEX-AMPLITUDE-LIFT across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for IMG-03 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Alter inner product definition; verify that unitary norm preservation fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in STAGE-06-L1-TO-L2-COMPLEX-AMPLITUDE-LIFT checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in IMG-03).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into IMG-03 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in IMG-03 causes check failure).

---

#### `IMG-04` — STAGE-07-FINITE-QM-BORN-GLEASON-CPTP: Finite Quantum Mechanics: Born Rule, Finite Gleason Frame, and CPTP Channels

- **Layer**: `7_IMAGINED_COSMOS_EXTENSION` | **Bucket**: `IMAGINED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `False`; Checks: `[]`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Prospective downstream stage targeting finite quantum mechanics: Born rule, f...
- Prose vs code gap: Prose outlines quantum measurement foundations. No quantum state vectors, density matrices, or CPTP channel formalizations exist in this codebase....
- Mechanization vulnerability: Missing dedicated executable Python property tests.
- Admissions dependency: Relies on unpriced inputs ['frame_additivity_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Prospective downstream stage targeting finite quantum mechanics: Born rule, finite Gleason frame, and CPTP channels.
- *Prose vs Code*: Prose outlines quantum measurement foundations. No quantum state vectors, density matrices, or CPTP channel formalizations exist in this codebase.
- *Boundaries & Assumptions*: Boundary conditions: Pure states; mixed states; completely positive maps. Unstated assumption: dimension is at least 3 for Gleason theorem applicability.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 1, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['frame_additivity_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean constructive formalization of finite frame functions on C^3
- [Adversary 1 - Formal Soundness] Python unit test verifying Choi-Jamiolkowski isomorphism for CPTP maps.
- [Adversary 2 - Mechanization] Specification unit tests checking interface signatures and mathematical type contracts for proposed stage IMG-04.
- [Adversary 2 - Mechanization] Boundary unit tests for initial state configurations and dimension parameters of STAGE-07-FINITE-QM-BORN-GLEASON-CPTP.
- [Adversary 2 - Mechanization] Negative control unit tests ensuring unverified downstream conjectures in IMG-04 are not accepted by mock evaluators.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between IMG-04 and IMG-03 Hilbert amplitude emergence.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['IMG-03'] satisfy type preconditions and invariants of IMG-04.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that outputs of IMG-04 satisfy input contracts for dependent nodes ['IMG-05'].
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['frame_additivity_admission']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Quantum state tomography simulation validating Born rule probabilities.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 7_IMAGINED_COSMOS_EXTENSION including IMG-04.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating STAGE-07-FINITE-QM-BORN-GLEASON-CPTP across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for IMG-04 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Inject non-positive eigenvalue into Choi matrix; verify that CPTP verification fails closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in STAGE-07-FINITE-QM-BORN-GLEASON-CPTP checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in IMG-04).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into IMG-04 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in IMG-04 causes check failure).

---

#### `IMG-05` — STAGE-08-MUB-TENSOR-ENTANGLEMENT: Mutually Unbiased Bases (MUB), Tensor Composite Systems, and Entanglement

- **Layer**: `7_IMAGINED_COSMOS_EXTENSION` | **Bucket**: `IMAGINED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `False`; Checks: `[]`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Prospective downstream stage targeting Mutually Unbiased Bases (MUB), tensor ...
- Prose vs code gap: Prose references MUB existence across prime power dimensions. Zero formal code exists in the repository....
- Mechanization vulnerability: Missing dedicated executable Python property tests.
- Admissions dependency: Relies on unpriced inputs ['composite_tensor_pairing_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Prospective downstream stage targeting Mutually Unbiased Bases (MUB), tensor composite systems, and entanglement.
- *Prose vs Code*: Prose references MUB existence across prime power dimensions. Zero formal code exists in the repository.
- *Boundaries & Assumptions*: Boundary conditions: Dimension d = 2, 3, 4, 6 (open MUB(6) problem). Unstated assumption: tensor product distributes over direct sums.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 1, Outgoing edges: 0.
- *Admission Traceability*: Declared unpriced admissions: ['composite_tensor_pairing_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean formalization of MUB overlap condition |<u|v>|^2 = 1/d
- [Adversary 1 - Formal Soundness] Python unit test verifying MUB construction for prime power dimensions.
- [Adversary 2 - Mechanization] Specification unit tests checking interface signatures and mathematical type contracts for proposed stage IMG-05.
- [Adversary 2 - Mechanization] Boundary unit tests for initial state configurations and dimension parameters of STAGE-08-MUB-TENSOR-ENTANGLEMENT.
- [Adversary 2 - Mechanization] Negative control unit tests ensuring unverified downstream conjectures in IMG-05 are not accepted by mock evaluators.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking IMG-05 with IMG-04 finite quantum mechanics.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['IMG-04'] satisfy type preconditions and invariants of IMG-05.
- [Adversary 2 - Mechanization] Terminal boundary integration tests checking that IMG-05 exports valid terminal invariants or extension interfaces.
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['composite_tensor_pairing_admission']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Bell inequality violation simulation on bipartite entangled MUB states.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 7_IMAGINED_COSMOS_EXTENSION including IMG-05.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating STAGE-08-MUB-TENSOR-ENTANGLEMENT across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for IMG-05 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Perturb MUB matrix entry by epsilon; verify that mutual unbiasedness check fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in STAGE-08-MUB-TENSOR-ENTANGLEMENT checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in IMG-05).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into IMG-05 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in IMG-05 causes check failure).

---

#### `IMG-06` — STAGE-09-DISCRETE-NOETHER-AND-CANONICAL-PAIRS: Discrete Action Variational Principle, Noether Conservation, and Canonical Pairs

- **Layer**: `7_IMAGINED_COSMOS_EXTENSION` | **Bucket**: `IMAGINED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `False`; Checks: `[]`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Prospective downstream stage targeting discrete action variational principle,...
- Prose vs code gap: Prose describes discrete variational principles. Zero formal code exists in the repository....
- Mechanization vulnerability: Missing dedicated executable Python property tests.
- Admissions dependency: Relies on unpriced inputs ['discrete_variational_stationarity_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Prospective downstream stage targeting discrete action variational principle, Noether conservation, and canonical pairs.
- *Prose vs Code*: Prose describes discrete variational principles. Zero formal code exists in the repository.
- *Boundaries & Assumptions*: Boundary conditions: Discrete time steps dt; boundary variations. Unstated assumption: Lagrangian differences approximate smooth action.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 1, Outgoing edges: 0.
- *Admission Traceability*: Declared unpriced admissions: ['discrete_variational_stationarity_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean formalization of discrete Euler-Lagrange equations on graphs
- [Adversary 1 - Formal Soundness] Python unit test testing discrete Noether charge conservation across time steps.
- [Adversary 2 - Mechanization] Specification unit tests checking interface signatures and mathematical type contracts for proposed stage IMG-06.
- [Adversary 2 - Mechanization] Boundary unit tests for initial state configurations and dimension parameters of STAGE-09-DISCRETE-NOETHER-AND-CANONICAL-PAIRS.
- [Adversary 2 - Mechanization] Negative control unit tests ensuring unverified downstream conjectures in IMG-06 are not accepted by mock evaluators.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between IMG-06 and DER-18 monotonic no-return.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['IMG-03'] satisfy type preconditions and invariants of IMG-06.
- [Adversary 2 - Mechanization] Terminal boundary integration tests checking that IMG-06 exports valid terminal invariants or extension interfaces.
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['discrete_variational_stationarity_admission']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Discrete trajectory simulation confirming energy and momentum conservation.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 7_IMAGINED_COSMOS_EXTENSION including IMG-06.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating STAGE-09-DISCRETE-NOETHER-AND-CANONICAL-PAIRS across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for IMG-06 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Add non-symmetric potential term; verify that discrete Noether conservation fails.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in STAGE-09-DISCRETE-NOETHER-AND-CANONICAL-PAIRS checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in IMG-06).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into IMG-06 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in IMG-06 causes check failure).

---

#### `IMG-07` — STAGE-10-FINITE-GAUGE-SECTORS: Finite Lattice Gauge Theory: U(1) QED, SU(2)xU(1) Electroweak, and SU(3) Color

- **Layer**: `7_IMAGINED_COSMOS_EXTENSION` | **Bucket**: `IMAGINED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `False`; Checks: `[]`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Prospective downstream stage targeting finite lattice gauge theory: U(1) QED,...
- Prose vs code gap: Prose references Standard Model gauge groups on discrete lattices. Zero formal code exists in the repository....
- Mechanization vulnerability: Missing dedicated executable Python property tests.
- Admissions dependency: Relies on unpriced inputs ['gauge_group_fiber_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Prospective downstream stage targeting finite lattice gauge theory: U(1) QED, SU(2)xU(1) Electroweak, and SU(3) Color.
- *Prose vs Code*: Prose references Standard Model gauge groups on discrete lattices. Zero formal code exists in the repository.
- *Boundaries & Assumptions*: Boundary conditions: Abelian U(1) vs non-abelian SU(2)/SU(3); plaquette action limits. Unstated assumption: discrete Wilson loops converge to continuous Yang-Mills theory.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 1, Outgoing edges: 0.
- *Admission Traceability*: Declared unpriced admissions: ['gauge_group_fiber_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean formalization of Wilson loop trace identities for finite subgroups of SU
- [Adversary 1 - Formal Soundness] Python unit test verifying gauge invariance of Wilson action.
- [Adversary 2 - Mechanization] Specification unit tests checking interface signatures and mathematical type contracts for proposed stage IMG-07.
- [Adversary 2 - Mechanization] Boundary unit tests for initial state configurations and dimension parameters of STAGE-10-FINITE-GAUGE-SECTORS.
- [Adversary 2 - Mechanization] Negative control unit tests ensuring unverified downstream conjectures in IMG-07 are not accepted by mock evaluators.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test connecting IMG-07 to DER-55 pentachoron exactness.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['IMG-01'] satisfy type preconditions and invariants of IMG-07.
- [Adversary 2 - Mechanization] Terminal boundary integration tests checking that IMG-07 exports valid terminal invariants or extension interfaces.
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['gauge_group_fiber_admission']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Lattice Monte Carlo simulation evaluating plaquette expectation values.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 7_IMAGINED_COSMOS_EXTENSION including IMG-07.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating STAGE-10-FINITE-GAUGE-SECTORS across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for IMG-07 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Inject non-gauge-invariant edge modification; verify that Wilson loop action check fails closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in STAGE-10-FINITE-GAUGE-SECTORS checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in IMG-07).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into IMG-07 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in IMG-07 causes check failure).

---

#### `IMG-08` — STAGE-11-SIMPLICIAL-REGGE-GRAVITY: Simplicial 3D/4D Regge-Barbero-Immirzi Curvature and Discrete Einstein-Hilbert Action

- **Layer**: `7_IMAGINED_COSMOS_EXTENSION` | **Bucket**: `IMAGINED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `False`; Checks: `[]`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Prospective downstream stage targeting simplicial 3D/4D Regge-Barbero-Immirzi...
- Prose vs code gap: Prose outlines discrete quantum gravity. Zero formal code exists in the repository (DER-53 only handles single tetrahedron integer arithmetic)....
- Mechanization vulnerability: Missing dedicated executable Python property tests.
- Admissions dependency: Relies on unpriced inputs ['simplicial_metric_edge_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Prospective downstream stage targeting simplicial 3D/4D Regge-Barbero-Immirzi gravity and discrete Einstein-Hilbert action.
- *Prose vs Code*: Prose outlines discrete quantum gravity. Zero formal code exists in the repository (DER-53 only handles single tetrahedron integer arithmetic).
- *Boundaries & Assumptions*: Boundary conditions: Lorentzian vs Euclidean signatures; Barbero-Immirzi parameter gamma > 0. Unstated assumption: Regge deficit angles sum to continuum scalar curvature.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 2, Outgoing edges: 0.
- *Admission Traceability*: Declared unpriced admissions: ['simplicial_metric_edge_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean formalization of 4D Regge action on simplicial 4-manifolds
- [Adversary 1 - Formal Soundness] Python numerical solver for Regge equations of motion.
- [Adversary 2 - Mechanization] Specification unit tests checking interface signatures and mathematical type contracts for proposed stage IMG-08.
- [Adversary 2 - Mechanization] Boundary unit tests for initial state configurations and dimension parameters of STAGE-11-SIMPLICIAL-REGGE-GRAVITY.
- [Adversary 2 - Mechanization] Negative control unit tests ensuring unverified downstream conjectures in IMG-08 are not accepted by mock evaluators.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking IMG-08 with DER-53 discrete Gauss-Bonnet.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['IMG-01', 'DER-53'] satisfy type preconditions and invariants of IMG-08.
- [Adversary 2 - Mechanization] Terminal boundary integration tests checking that IMG-08 exports valid terminal invariants or extension interfaces.
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['simplicial_metric_edge_admission']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] 4D simplicial gravity evolution simulation checking discrete Bianchi identity preservation.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 7_IMAGINED_COSMOS_EXTENSION including IMG-08.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating STAGE-11-SIMPLICIAL-REGGE-GRAVITY across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for IMG-08 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Violate triangle inequality on 4-simplex edge lengths; verify that Regge action fails to compute.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in STAGE-11-SIMPLICIAL-REGGE-GRAVITY checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in IMG-08).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into IMG-08 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in IMG-08 causes check failure).

---

#### `IMG-09` — STAGE-12-CONSTRUCTOR-THEORY-AND-THERMODYNAMICS: Finite Constructor Theory, Irreversibility, and Landauer Erasure Cost

- **Layer**: `7_IMAGINED_COSMOS_EXTENSION` | **Bucket**: `IMAGINED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `False`; Checks: `[]`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Prospective downstream stage targeting finite constructor theory, irreversibi...
- Prose vs code gap: Prose discusses constructor theory principles (achievable vs precluded tasks, thermodynamic cost). Zero formal code exists in the repository....
- Mechanization vulnerability: Missing dedicated executable Python property tests.
- Admissions dependency: Relies on unpriced inputs ['bath_partition_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Prospective downstream stage targeting finite constructor theory, irreversibility, and Landauer erasure cost.
- *Prose vs Code*: Prose discusses constructor theory principles (achievable vs precluded tasks, thermodynamic cost). Zero formal code exists in the repository.
- *Boundaries & Assumptions*: Boundary conditions: Zero dissipation limit; Landauer bound kT ln 2. Unstated assumption: task enablement graphs are transitive.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 2, Outgoing edges: 0.
- *Admission Traceability*: Declared unpriced admissions: ['bath_partition_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean formalization of constructor task algebra
- [Adversary 1 - Formal Soundness] Python unit test verifying Landauer erasure cost on 1-bit memory reset.
- [Adversary 2 - Mechanization] Specification unit tests checking interface signatures and mathematical type contracts for proposed stage IMG-09.
- [Adversary 2 - Mechanization] Boundary unit tests for initial state configurations and dimension parameters of STAGE-12-CONSTRUCTOR-THEORY-AND-THERMODYNAMICS.
- [Adversary 2 - Mechanization] Negative control unit tests ensuring unverified downstream conjectures in IMG-09 are not accepted by mock evaluators.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test connecting IMG-09 to DER-10 memory packet retention.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['DER-10', 'DER-18'] satisfy type preconditions and invariants of IMG-09.
- [Adversary 2 - Mechanization] Terminal boundary integration tests checking that IMG-09 exports valid terminal invariants or extension interfaces.
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['bath_partition_admission']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Constructor engine execution demonstrating thermodynamic irreversibility.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 7_IMAGINED_COSMOS_EXTENSION including IMG-09.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating STAGE-12-CONSTRUCTOR-THEORY-AND-THERMODYNAMICS across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for IMG-09 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Permit zero-cost bit erasure; verify that thermodynamic constructor bounds fail.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in STAGE-12-CONSTRUCTOR-THEORY-AND-THERMODYNAMICS checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in IMG-09).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into IMG-09 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in IMG-09 causes check failure).

---

#### `IMG-10` — STAGE-13-COSMOS-SELF-HOSTING-METATHEORY: Self-Hosting Cosmos Internal Mathematics, Proof Checker, and Reflective Closure

- **Layer**: `7_IMAGINED_COSMOS_EXTENSION` | **Bucket**: `IMAGINED` | **Tripartite Status**: `NON_PERFECTED`
- **Current Coverage**: 0 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `False`; Checks: `[]`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Prospective downstream stage targeting self-hosting Cosmos internal mathemati...
- Prose vs code gap: Prose outlines reflective self-hosting of the metatheory. Zero formal code exists in the repository....
- Mechanization vulnerability: Missing dedicated executable Python property tests.
- Admissions dependency: Relies on unpriced inputs ['internal_syntax_encoding_admission'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Classified as NON_PERFECTED. Carries 0 Lean 4 theorems and 0 Python check scripts. Prospective downstream stage targeting self-hosting Cosmos internal mathematics, proof checker, and reflective closure.
- *Prose vs Code*: Prose outlines reflective self-hosting of the metatheory. Zero formal code exists in the repository.
- *Boundaries & Assumptions*: Boundary conditions: Quining / self-interpretation; Godel incompleteness barriers. Unstated assumption: a finite discrete system can self-host its own proof checker without circularity.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Has dedicated Python check scripts, but requires assertion hardening and boundary testing.
- *Integration Seams*: Incoming edges: 1, Outgoing edges: 0.
- *Admission Traceability*: Declared unpriced admissions: ['internal_syntax_encoding_admission'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Constructive Lean formalization of a self-verifying proof checker for core formulas
- [Adversary 1 - Formal Soundness] Python unit test verifying self-hosting metacircular evaluator.
- [Adversary 2 - Mechanization] Specification unit tests checking interface signatures and mathematical type contracts for proposed stage IMG-10.
- [Adversary 2 - Mechanization] Boundary unit tests for initial state configurations and dimension parameters of STAGE-13-COSMOS-SELF-HOSTING-METATHEORY.
- [Adversary 2 - Mechanization] Negative control unit tests ensuring unverified downstream conjectures in IMG-10 are not accepted by mock evaluators.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking IMG-10 to DER-16 constitutional initiality.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that outputs from ['DER-17'] satisfy type preconditions and invariants of IMG-10.
- [Adversary 2 - Mechanization] Terminal boundary integration tests checking that IMG-10 exports valid terminal invariants or extension interfaces.
- [Adversary 2 - Mechanization] Transitive admission propagation integration tests verifying that required admissions (['internal_syntax_encoding_admission']) are enforced without silent omission.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Self-verification run where the system compiles and certifies its own codebase.
- [Adversary 2 - Mechanization] Full chain multi-stage execution tests tracing from initial mark '<>' through 7_IMAGINED_COSMOS_EXTENSION including IMG-10.
- [Adversary 2 - Mechanization] Multi-round replay tests evaluating STAGE-13-COSMOS-SELF-HOSTING-METATHEORY across repeated update cycles under non-zero admission and retention costs.
- [Adversary 2 - Mechanization] Cross-facet correspondence e2e tests asserting that Lean theorem outputs, Python execution states, and prose bounds for IMG-10 yield identical numerical results.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Inject inconsistency into the internal proof checker; verify that reflective closure fails closed.
- [Adversary 2 - Mechanization] Operator inversion mutation tests (flipping equality, order relations, or boolean connectives in STAGE-13-COSMOS-SELF-HOSTING-METATHEORY checks).
- [Adversary 2 - Mechanization] Constant perturbation mutation tests (incrementing/decrementing carrier sizes, dimension bounds, or budget thresholds in IMG-10).
- [Adversary 2 - Mechanization] Data corruption mutation tests (injecting invalid tokens, cyclic references, or altered hashes into IMG-10 inputs).
- [Adversary 2 - Mechanization] Axiom weakening mutation tests (verifying that removing declared hypotheses in IMG-10 causes check failure).

---

### Layer: 6_WDP_CANONICAL_REPLAY_AND_BRIDGE (19 Nodes)

#### `DER-57` — WDP-GUARDED-SCHEDULE-TOPOLOGY-AND-ONE-BIT-RETENTION: Exact 5-Gate Guarded Schedule Topology, Validated One-Bit Retention Automaton, and Positive-Cost Commutation Limits

- **Layer**: `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 29 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 29 Lean theorems in GuardedScheduleTopology.lean using core axioms propext and Quot.sound. Formalizes task start/finish scheduling and prefix-sa...
- Prose vs code gap: Prose characterizes this as an exact 5-gate admission-and-view guard topology for full schedule complexes. Lean formalization models a single integer supply cou...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S4_retention_state_bit', 'S5_additive_cost_target'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 29 Lean theorems in GuardedScheduleTopology.lean using core axioms propext and Quot.sound. Formalizes task start/finish scheduling and prefix-safety under finite capacity. Vulnerability: Operates on simplified boolean words (List Bool) where false is start and true is finish; it does not model concurrent task execution, overlapping memory access, or dynamic priority preemption.
- *Prose vs Code*: Prose characterizes this as an exact 5-gate admission-and-view guard topology for full schedule complexes. Lean formalization models a single integer supply counter tracking net start/finish events in a sequential trace.
- *Boundaries & Assumptions*: Boundary conditions: Supply = 0 (refuses start); empty trace; maximal capacity. Unstated assumption: tasks cannot fail or abort abnormally; every started task emits a finish event.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 3.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S4_retention_state_bit', 'S5_additive_cost_target'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem formalizing task abort/cancellation semantics and capacity reclamation
- [Adversary 1 - Formal Soundness] Python unit test verifying 5-gate transition table against non-boolean task payloads.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests mechanizing the 2-state retention automaton and 5-gate guard topology.
- [Adversary 2 - Mechanization] Boundary unit tests evaluating schedule prefix safety when initial capacity supply is zero.
- [Adversary 2 - Mechanization] Invariance unit tests checking task permutation equivalence against Lean theorem startsFirst_perm.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-57 schedule safety and DER-72 WDP Batch 10 transport composition.
- [Adversary 2 - Mechanization] Upstream integration tests verifying event streams from DER-33 and DER-42 conform to guard capacity preconditions.
- [Adversary 2 - Mechanization] Downstream integration tests confirming that OWE-12 receives verified positive-cost commutation boundaries.
- [Adversary 2 - Mechanization] Admission integration tests verifying that S0, S4, and S5 admissions are enforced across schedule execution.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Replay test verifying that capacity refusal halts execution when supply is exhausted across multi-phase schedule executions.
- [Adversary 2 - Mechanization] Full schedule execution end-to-end tests evaluating 5-gate transitions across repeated update cycles.
- [Adversary 2 - Mechanization] Capacity exhaustion end-to-end tests confirming that start events are refused when supply reaches zero.
- [Adversary 2 - Mechanization] Cross-facet correspondence tests verifying Lean theorem bounds match Python execution counters.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Invert capacity decrement on task start (e.g. supply + 1 instead of supply - 1); verify that prefix-safety validation fails closed.
- [Adversary 2 - Mechanization] Capacity decrement mutation tests replacing supply - 1 with supply + 1 in task start handler.
- [Adversary 2 - Mechanization] Guard comparison mutation tests changing starts <= supply to starts < supply.
- [Adversary 2 - Mechanization] Event reordering mutation tests checking that unsorted task traces trigger prefix-safety violations.

---

#### `DER-58` — WDP-FOUNDATIONAL-BRIDGES-AND-SUBSTRATE-CERTIFICATES: Formal Substrate Admission Certificates, Strict Refinement Height Bounds, and Endogenous Orbit-Weight Forcing

- **Layer**: `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 18 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 18 Lean theorems in FoundationalBridges.lean with propext and Quot.sound. Formalizes distinction between empty inscription and nested empty insc...
- Prose vs code gap: Prose presents substrate certificates as establishing endogenous orbit-weight forcing across arbitrary carriers. Lean code establishes inequality for two fixed ...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 18 Lean theorems in FoundationalBridges.lean with propext and Quot.sound. Formalizes distinction between empty inscription and nested empty inscription (markA vs markB) and height bounds. Vulnerability: Inscription distinction is established for exactly two syntactic constructors (empty vs nest empty); it does not establish distinction over arbitrary inductive terms without external syntactic decidability.
- *Prose vs Code*: Prose presents substrate certificates as establishing endogenous orbit-weight forcing across arbitrary carriers. Lean code establishes inequality for two fixed inscriptions and finite tree height properties.
- *Boundaries & Assumptions*: Boundary conditions: Tree height 0; two-element mark alphabet. Unstated assumption: mark identity is syntactically decidable via pattern matching on inductive constructors.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 5, Outgoing edges: 5.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem generalizing mark separation to arbitrary nested terms under constructor injectivity
- [Adversary 1 - Formal Soundness] Python unit test testing orbit weight conservation under group actions on finite carriers.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests computing substrate tree heights and orbit weight sums.
- [Adversary 2 - Mechanization] Boundary unit tests evaluating mark separation on minimal syntax trees of depth zero and one.
- [Adversary 2 - Mechanization] Property unit tests verifying orbit weight positivity across group actions on finite carriers.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test linking DER-58 height bounds with DER-67 dyadic refinement towers.
- [Adversary 2 - Mechanization] Upstream integration tests checking that inputs from DER-27 and DER-56 satisfy certificate preconditions.
- [Adversary 2 - Mechanization] Downstream integration tests confirming that OWE-05, OWE-06, OWE-09, and OWE-10 receive valid substrate certificates.
- [Adversary 2 - Mechanization] Refinement integration tests verifying that height bounds enforce termination in DER-67 dyadic towers.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Derivation test tracking substrate certificate issuance from initial mark to OWE-05/OWE-06 bridge targets.
- [Adversary 2 - Mechanization] End-to-end certificate issuance tests tracing substrate generation from markA/markB to bridge targets.
- [Adversary 2 - Mechanization] Multi-step orbit evolution end-to-end tests checking mass conservation across successive rewrites.
- [Adversary 2 - Mechanization] Cross-facet correspondence tests matching Lean height bounds with Python syntax tree traversals.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Force markA = markB in mock evaluator; verify that substrate certificate generation immediately refuses.
- [Adversary 2 - Mechanization] Mark equality mutation tests injecting markA == markB into the certificate evaluator.
- [Adversary 2 - Mechanization] Height bound mutation tests relaxing strict tree height inequalities from <= to <.
- [Adversary 2 - Mechanization] Orbit weight mutation tests altering positive weight coefficients to negative values.

---

#### `DER-59` — WDP-OBSERVER-ADAPTER-COMPLETENESS-AND-READOUT-FACTORIZATION: Constructive Observer Adapter Completeness, Section-Backed Readout Factorization, and Kernel Inclusion

- **Layer**: `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 27 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 27 Lean theorems in ObserverAdapterCompleteness.lean. Establishes that sectioned sort maps have constructive sections and that fiber-constant pr...
- Prose vs code gap: Prose asserts observer adapter completeness across broad observation domains. Lean formalization assumes an explicit retraction map (section) is provided as a h...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M2_indexed_context_family'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 27 Lean theorems in ObserverAdapterCompleteness.lean. Establishes that sectioned sort maps have constructive sections and that fiber-constant predicates descend uniquely. Vulnerability: Requires the existence of a global constructive section (splitting); it does not cover observers where sections are only locally defined or obstructed by topological torsion.
- *Prose vs Code*: Prose asserts observer adapter completeness across broad observation domains. Lean formalization assumes an explicit retraction map (section) is provided as a hypothesis.
- *Boundaries & Assumptions*: Boundary conditions: Identity observer; empty fibers; constant functions. Unstated assumption: target observation sorts have decidable equality.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M2_indexed_context_family'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem showing obstruction to factorization when fiber-constancy fails on a 2-point fiber
- [Adversary 1 - Formal Soundness] Python unit test testing observer adapter tables on non-surjective mappings.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests computing observer fiber decompositions and section inversions.
- [Adversary 2 - Mechanization] Boundary unit tests verifying adapter behavior on singleton and empty observation fibers.
- [Adversary 2 - Mechanization] Property unit tests asserting that tuple sections preserve componentwise section properties.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test connecting DER-59 readout factorization to DER-66 finite constraint representations.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that adapters from DER-39 and DER-43 compose associatively.
- [Adversary 2 - Mechanization] Downstream integration tests ensuring that sectioned observer maps partition constraint scopes in DER-66.
- [Adversary 2 - Mechanization] Context integration tests checking that indexed context families satisfy sectioned sort map requirements.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Multi-observer composition test verifying kernel inclusion preservation across cascaded adapters.
- [Adversary 2 - Mechanization] End-to-end readout factorization tests confirming unique descent of fiber-constant predicates.
- [Adversary 2 - Mechanization] Multi-stage observer cascade tests verifying zero information loss across sectioned adapters.
- [Adversary 2 - Mechanization] Cross-facet correspondence tests matching Lean unique_factorization_iff with Python lookup tables.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate section map to return an out-of-fiber element; verify that unique factorization tests fail closed.
- [Adversary 2 - Mechanization] Section map mutation tests altering section outputs to return elements outside the fiber.
- [Adversary 2 - Mechanization] Fiber constancy mutation tests perturbing predicate values on a single fiber element.
- [Adversary 2 - Mechanization] Kernel inclusion mutation tests dropping transitivity in kernel equivalence checking.

---

#### `DER-60` — WDP-ADDITIVE-TENSOR-COMPLETION-AND-GROTHENDIECK-FACTORIZATION: Cancellative Commutative Monoid Grothendieck Group Completion and Independent-Subsystem Tensor Costs

- **Layer**: `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 54 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 54 Lean theorems in AdditiveTensorCompletion.lean. Constructs free commutative monoid over generators, quotiented by interchange laws, and signe...
- Prose vs code gap: Prose discusses independent-subsystem tensor costs in quantum-like systems. Lean code models formal lists of generators with quotiented permutation equivalence ...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 54 Lean theorems in AdditiveTensorCompletion.lean. Constructs free commutative monoid over generators, quotiented by interchange laws, and signed Grothendieck completion. Vulnerability: Cancellativity is verified for free formal sums; it does not establish Grothendieck completion for non-cancellative monoids (which would collapse the group structure).
- *Prose vs Code*: Prose discusses independent-subsystem tensor costs in quantum-like systems. Lean code models formal lists of generators with quotiented permutation equivalence and integer pairing.
- *Boundaries & Assumptions*: Boundary conditions: Empty tensor product (unit); single generator carrier; zero cost. Unstated assumption: generator type X has decidable equality.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem showing collapse of the Grothendieck completion under non-cancellative addition
- [Adversary 1 - Formal Soundness] Python unit test verifying tensor cost additivity on multi-generator combinations.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests implementing free abelian group terms and Grothendieck cancellation.
- [Adversary 2 - Mechanization] Boundary unit tests checking monoid completion on empty list units and single generators.
- [Adversary 2 - Mechanization] Algebraic property unit tests evaluating tensor cost additivity on multi-generator combinations.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-60 Grothendieck completion and DER-61 dagger involution.
- [Adversary 2 - Mechanization] Upstream integration tests confirming cost metrics from DER-34 and DER-51 embed into the Grothendieck carrier.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that signed Grothendieck groups provide valid bases for DER-61 dagger pairing.
- [Adversary 2 - Mechanization] Admission integration tests asserting additive cost target S5 conservation across tensor products.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Tensor factorization test checking that composite system costs equal sum of subsystem costs across update chains.
- [Adversary 2 - Mechanization] End-to-end tensor factorization tests checking subsystem cost additivity across multi-agent processes.
- [Adversary 2 - Mechanization] Grothendieck group reduction tests verifying canonical representation uniqueness under formal difference cancellation.
- [Adversary 2 - Mechanization] Cross-facet correspondence tests matching Lean CommMonoid.interchange with Python tensor contractions.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate list equivalence quotient by removing the symmetry rule; verify that monoid completion validation fails.
- [Adversary 2 - Mechanization] Grothendieck addition mutation tests replacing (a+c, b+d) with (a+d, b+c).
- [Adversary 2 - Mechanization] Permutation quotient mutation tests removing the interchange law from formal list equivalence.
- [Adversary 2 - Mechanization] Cancellativity mutation tests introducing non-cancellative absorbing elements into generator lists.

---

#### `DER-61` — WDP-DAGGER-OBSERVER-PAIRING-AND-ADJOINT-INVOLUTION: Dagger Relational Observer Pairing, Contra-Involutive Composition, and Conjugate Bilinear Symmetry

- **Layer**: `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 16 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 16 Lean theorems in DaggerObserverPairing.lean. Formalizes involutive dagger operation on signed carrier and positive-semidefinite bilinear pair...
- Prose vs code gap: Prose characterizes this as adjoint involution and conjugate bilinear symmetry for relational observers. Lean code formalizes an involution on discrete basis ve...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target', 'M2_indexed_context_family'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 16 Lean theorems in DaggerObserverPairing.lean. Formalizes involutive dagger operation on signed carrier and positive-semidefinite bilinear pairing into 2D integer coordinates. Vulnerability: Positive-semidefiniteness is established over integer coordinates (Z x Z) using quadratic forms; it does not establish C*-algebraic positivity or continuous Hilbert space spectral decompositions.
- *Prose vs Code*: Prose characterizes this as adjoint involution and conjugate bilinear symmetry for relational observers. Lean code formalizes an involution on discrete basis vectors with integer cross-multiplication.
- *Boundaries & Assumptions*: Boundary conditions: Self-adjoint generators; zero vector; orthogonal basis pairs. Unstated assumption: involution is an automorphism of the underlying free additive carrier.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 5, Outgoing edges: 4.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target', 'M2_indexed_context_family'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem showing that non-involutive maps violate dagger symmetry
- [Adversary 1 - Formal Soundness] Python unit test evaluating positive-semidefinite matrix representations for small generators.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests computing bilinear pairing Gram matrices and verifying positive-semidefiniteness.
- [Adversary 2 - Mechanization] Boundary unit tests checking dagger involution on self-adjoint and skew-adjoint basis generators.
- [Adversary 2 - Mechanization] Property unit tests verifying contra-involutive composition laws (A . B)^dagger = B^dagger . A^dagger.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-61 dagger pairing and DER-62 Gaussian integer quantum readout.
- [Adversary 2 - Mechanization] Upstream integration tests checking that Grothendieck group outputs from DER-60 feed valid inputs to DER-61.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that dagger pairing Gram matrices parameterize DER-62 quantum readouts.
- [Adversary 2 - Mechanization] Relational observer integration tests linking DER-43 observer projections with DER-61 bilinear forms.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Verification that composite adjoint operations satisfy (A . B)^dagger = B^dagger . A^dagger across multi-stage observer transformations.
- [Adversary 2 - Mechanization] End-to-end adjoint consistency tests verifying that measurement expectation values remain positive across operations.
- [Adversary 2 - Mechanization] Observer reciprocity end-to-end tests checking bilinear pairing symmetry under observer exchange.
- [Adversary 2 - Mechanization] Cross-facet correspondence tests matching Lean signedDagger_unit with Python matrix conjugates.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Alter dagger involution to not invert composition order; verify that adjoint tests fail closed.
- [Adversary 2 - Mechanization] Dagger composition mutation tests omitting the order reversal in adjoint composition.
- [Adversary 2 - Mechanization] Gram matrix symmetry mutation tests swapping off-diagonal elements with unequal values.
- [Adversary 2 - Mechanization] Positive-semidefiniteness mutation tests injecting negative eigenvalues into the observer metric.

---

#### `DER-62` — WDP-GAUSSIAN-INT-QUANTUM-READOUT-AND-FINITE-MODEL-DISCHARGES: Gaussian Integer Parseval Identity, 2-Adic Unnormalized Hadamard Obstruction, 3-Basis Qubit MUBs, Bell Schmidt Determinant, Discrete Noether Conservation, and Landauer Erasure

- **Layer**: `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 24 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 24 Lean theorems in GaussianIntQuantumReadout.lean. Formalizes Gaussian integers Z[i], 2-point Parseval identity, 2-adic valuation obstruction p...
- Prose vs code gap: Prose claims discharge of quantum readout, Bell entanglement, and Landauer erasure. Lean formalization establishes arithmetic identities over Z[i] integer compo...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 24 Lean theorems in GaussianIntQuantumReadout.lean. Formalizes Gaussian integers Z[i], 2-point Parseval identity, 2-adic valuation obstruction preventing unnormalized unitary Hadamard in Z[i], 3 mutually unbiased bases for a qubit toy model, and discrete Noether conservation. Vulnerability: Operates on Gaussian integers Z[i] without square roots; Hadamard is unnormalized (factor of 2), and MUB overlap is scaled by 2 rather than 1/sqrt(2).
- *Prose vs Code*: Prose claims discharge of quantum readout, Bell entanglement, and Landauer erasure. Lean formalization establishes arithmetic identities over Z[i] integer components with cleared denominators.
- *Boundaries & Assumptions*: Boundary conditions: 2D state space (qubit toy model); integer division roundoff; 3 discrete bases. Unstated assumption: unnormalized state vectors represent physical probability distributions through integer scaling.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 7, Outgoing edges: 8.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem showing that normalization in Z[i] cannot be constructed for the vector (1, 1)
- [Adversary 1 - Formal Soundness] Python unit test testing discrete Bell inequality violation thresholds in cleared-denominator arithmetic.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests implementing Gaussian integer arithmetic, 2-point Parseval identity, and MUB checks.
- [Adversary 2 - Mechanization] Boundary unit tests evaluating 2-adic valuation obstruction preventing normalized Hadamard in Z[i].
- [Adversary 2 - Mechanization] Discrete Bell determinant unit tests computing Schmidt decomposition on 2-qubit Gaussian integer states.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-62 Gaussian readout and DER-63 complex tensor balancing.
- [Adversary 2 - Mechanization] Upstream integration tests confirming that curvature from DER-53 and pairing from DER-61 construct valid Z[i] states.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that Gaussian state vectors provide valid inputs for DER-63 tensor balancing and DER-75 capstone.
- [Adversary 2 - Mechanization] Conservation integration tests linking discrete Noether charges with step transitions from DER-25.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Qubit transformation test executing Pauli X, Y, Z rotations on Gaussian integer state vectors.
- [Adversary 2 - Mechanization] End-to-end quantum readout simulation tracing from initial mark to Bell state correlation checks.
- [Adversary 2 - Mechanization] Landauer erasure dissipation end-to-end tests tracking integer cost accumulation during state reset.
- [Adversary 2 - Mechanization] Cross-facet correspondence tests matching Lean gaussian_ext and parseval identities with Python numerical runs.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Perturb the imaginary unit square i^2 = -1 to i^2 = +1 (split-complex); verify that Parseval and Hadamard obstruction tests fail closed.
- [Adversary 2 - Mechanization] Gaussian multiplication mutation tests altering i^2 = -1 to i^2 = +1.
- [Adversary 2 - Mechanization] Parseval identity mutation tests altering the cleared-denominator factor 2 to 1.
- [Adversary 2 - Mechanization] Hadamard obstruction mutation tests forcing odd determinant on unnormalized Hadamard matrices.

---

#### `DER-63` — WDP-COMPLEX-TENSOR-BALANCING-AND-PHASE-EQUIVALENCE: Bilinear Tensor Balancing Quotient and Fourth-Root Phase Action Equivalence

- **Layer**: `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 14 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 14 Lean theorems in ComplexTensorBalancing.lean. Covers two-component and four-component integer coefficient identities under Z_4 cyclic phase a...
- Prose vs code gap: Prose describes complex tensor balancing and broad phase equivalence. Lean code establishes finite cyclic group Z_4 action on 4-tuples of integers with integer ...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M1_carrier_multiplicity'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 14 Lean theorems in ComplexTensorBalancing.lean. Covers two-component and four-component integer coefficient identities under Z_4 cyclic phase action. Vulnerability: Restricts phase rotations to the discrete fourth roots of unity {1, i, -1, -i}; continuous U(1) phase invariance is unaddressed.
- *Prose vs Code*: Prose describes complex tensor balancing and broad phase equivalence. Lean code establishes finite cyclic group Z_4 action on 4-tuples of integers with integer division by 2.
- *Boundaries & Assumptions*: Boundary conditions: Zero vector; 4-element phase orbit; division by 2 exactness. Unstated assumption: integer components are even whenever division by 2 is performed.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M1_carrier_multiplicity'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem showing failure of division by 2 on odd integer coordinates
- [Adversary 1 - Formal Soundness] Python unit test testing Z_4 orbit invariants on randomly generated integer 4-tuples.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests implementing 4-tuple balancing quotients and fourth-root phase actions.
- [Adversary 2 - Mechanization] Boundary unit tests checking behavior on zero vectors and orthogonal basis pairs under integer division by 2.
- [Adversary 2 - Mechanization] Property unit tests verifying that four successive phase shifts return the identity transformation.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-63 phase action and DER-62 Gaussian quantum readout.
- [Adversary 2 - Mechanization] Upstream integration tests confirming that Gaussian states from DER-62 satisfy even coordinate parity for division by 2.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that balanced tensor outputs conform to IMG-03 and IMG-05 cosmos interfaces.
- [Adversary 2 - Mechanization] Carrier integration tests checking multiplicity M1 consistency across bilinear quotient reductions.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Cyclic phase invariance test asserting that four successive phase shifts return to the initial state vector.
- [Adversary 2 - Mechanization] End-to-end phase rotation tests tracking 4-phase cyclic equivalence across composite state vectors.
- [Adversary 2 - Mechanization] Multi-particle tensor balancing tests verifying quotient stability under tensor product composition.
- [Adversary 2 - Mechanization] Cross-facet correspondence tests matching Lean sectionMap_project with Python array balancing.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate fourth-root phase shift by omitting the negative sign on i^2; verify phase equivalence tests fail.
- [Adversary 2 - Mechanization] Phase cycle mutation tests altering the 4-cycle permutation (a,b,c,d) -> (-b,a,-d,c).
- [Adversary 2 - Mechanization] Integer division mutation tests replacing integer floor division with round-to-nearest in balance projection.
- [Adversary 2 - Mechanization] Norm conservation mutation tests altering the doubleQuad_norm identity scaling factor.

---

#### `DER-64` — WDP-MARKED-GAUGE-TRANSPORT-AND-TREE-DEFECT-INVARIANCE: Marked Gauge Transport over Rooted Spanning Trees and Fundamental Cycle Holonomy Invariance

- **Layer**: `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 19 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 19 Lean theorems in MarkedGaugeTransport.lean. Analyzes gauge transport along rooted spanning trees and fundamental cycle holonomies on Source-2...
- Prose vs code gap: Prose claims gauge transport and tree defect invariance across general graphs. Lean formalization uses fixed cyclic triple renamings on natural number lookups f...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 19 Lean theorems in MarkedGaugeTransport.lean. Analyzes gauge transport along rooted spanning trees and fundamental cycle holonomies on Source-25 graphs. Vulnerability: Tree transport is path-independent because spanning trees contain zero cycles; holonomy invariance is established relative to fixed cycle bases rather than dynamic network re-topologization.
- *Prose vs Code*: Prose claims gauge transport and tree defect invariance across general graphs. Lean formalization uses fixed cyclic triple renamings on natural number lookups from Source-25.
- *Boundaries & Assumptions*: Boundary conditions: Trivial tree (single node); zero gauge shift; acyclic subgraphs. Unstated assumption: spanning trees are fixed and statically partitioned.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 5, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem showing non-trivial holonomy on non-tree chord edges
- [Adversary 1 - Formal Soundness] Python unit test calculating cycle holonomies on non-planar graph benchmarks.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests computing spanning tree gauge transport and fundamental cycle holonomies.
- [Adversary 2 - Mechanization] Boundary unit tests evaluating transport on trees with a single edge and trees with maximal branching.
- [Adversary 2 - Mechanization] Invariance unit tests checking that gauge shifts leave fundamental cycle holonomies invariant.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-64 gauge transport and DER-75 terminal capstone replay.
- [Adversary 2 - Mechanization] Upstream integration tests confirming that cochain transports from DER-37 and DER-47 feed valid gauge connections.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that tree defect invariants satisfy preconditions for DER-75 terminal capstone.
- [Adversary 2 - Mechanization] Admissions integration tests checking that gauge transport respects additive cost targets S5.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Gauge transformation invariance test verifying that global gauge shifts leave physical holonomies unchanged across the graph.
- [Adversary 2 - Mechanization] End-to-end gauge transport simulations on Source-25 graph instances verifying path independence on trees.
- [Adversary 2 - Mechanization] Holonomy invariance end-to-end tests evaluating cycle sums under random node gauge renamings.
- [Adversary 2 - Mechanization] Cross-facet correspondence tests matching Lean diagnostic_after_shift with Python graph holonomy calculations.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Invert sign of gauge connection on tree edges; verify tree defect invariance checks detect failure.
- [Adversary 2 - Mechanization] Gauge shift mutation tests omitting the node potential difference in link transport.
- [Adversary 2 - Mechanization] Tree chord mutation tests applying tree-transport rules to non-tree chord edges.
- [Adversary 2 - Mechanization] Holonomy accumulation mutation tests flipping sign on fundamental cycle boundary orientations.

---

#### `DER-65` — WDP-MERON-THERMO-LIMIT-CONSTANTS-AND-WILSON-ACTION-BOUNDS: Cleared-Denominator Meron Action Constants, Plaquette Frustration Thresholds, and Thermodynamic Scaling Bounds

- **Layer**: `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 18 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 18 Lean theorems in MeronThermoLimitConstants.lean. Establishes integer identities for cleared-denominator Meron actions and plaquette frustrati...
- Prose vs code gap: Prose speaks of thermodynamic scaling bounds and Meron action limits in field theory. Lean code establishes inequalities between fixed integer constants and rat...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 18 Lean theorems in MeronThermoLimitConstants.lean. Establishes integer identities for cleared-denominator Meron actions and plaquette frustration lower bounds. Vulnerability: Meron configurations are modeled via discrete rational constants with cleared denominators; it does not evaluate the thermodynamic limit N -> infinity via continuous path integrals.
- *Prose vs Code*: Prose speaks of thermodynamic scaling bounds and Meron action limits in field theory. Lean code establishes inequalities between fixed integer constants and rational multipliers.
- *Boundaries & Assumptions*: Boundary conditions: Single plaquette; zero field frustration; minimal lattice volume. Unstated assumption: thermodynamic scaling coefficients can be bounded uniformly by rational numbers.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 5, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem showing stability of the frustration bound under localized perturbation
- [Adversary 1 - Formal Soundness] Python unit test testing plaquette action sums on N x N 2D lattices.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests computing cleared-denominator Meron actions and plaquette frustration lower bounds.
- [Adversary 2 - Mechanization] Boundary unit tests evaluating frustration thresholds on unfrustrated vs maximally frustrated plaquettes.
- [Adversary 2 - Mechanization] Scaling property unit tests checking that thermodynamic action bounds grow monotonically with lattice area.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-65 Meron constants and DER-53 discrete Gauss-Bonnet curvature.
- [Adversary 2 - Mechanization] Upstream integration tests confirming that Trotter polynomial data from DER-49 and curvature from DER-53 match action inputs.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that action bounds inform IMG-07 and IMG-08 cosmos extensions.
- [Adversary 2 - Mechanization] Carrier integration tests checking multiplicity M1 scaling across thermodynamic limit calculations.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Thermodynamic scaling simulation measuring total action divergence as lattice size scales up.
- [Adversary 2 - Mechanization] End-to-end lattice action simulations tracking total Wilson action across increasing lattice sizes.
- [Adversary 2 - Mechanization] Frustration bound end-to-end tests confirming that no field configuration dips below the frustration threshold.
- [Adversary 2 - Mechanization] Cross-facet correspondence tests matching Lean meron_action_cleared constants with Python lattice action evaluations.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate plaquette frustration lower bound constant to exceed maximum action; verify validation fails closed.
- [Adversary 2 - Mechanization] Frustration threshold mutation tests setting the lower bound to zero.
- [Adversary 2 - Mechanization] Cleared denominator mutation tests omitting the integer clearing factor in action comparisons.
- [Adversary 2 - Mechanization] Action scaling mutation tests changing monotonic growth from <= to >= in lattice enlargement checks.

---

#### `DER-66` — WDP-FINITE-CONSTRAINT-REPRESENTATION-AND-CANONICAL-COVER: Constructive Sum-Indexed Constraint Representation and Canonical Evaluation Embedding

- **Layer**: `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 26 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 26 Lean theorems in FiniteConstraintRepresentation.lean. Formalizes constructive sheaf gluing for constraints over explicitly covered finite sco...
- Prose vs code gap: Prose claims canonical evaluation embedding and comprehensive constraint representation. Lean code models finite tables with list lookups and decidable row equa...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M1_carrier_multiplicity', 'M2_indexed_context_family'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 26 Lean theorems in FiniteConstraintRepresentation.lean. Formalizes constructive sheaf gluing for constraints over explicitly covered finite scopes with row tables. Vulnerability: Sheaf condition is verified for finite discrete covers where overlap compatibility is decidable by exhaustive search; it does not extend to infinite open coverings or non-Hausdorff sites.
- *Prose vs Code*: Prose claims canonical evaluation embedding and comprehensive constraint representation. Lean code models finite tables with list lookups and decidable row equality.
- *Boundaries & Assumptions*: Boundary conditions: Empty cover; singleton scope; disjoint scopes. Unstated assumption: all constraint evaluations terminate in finite time.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 0.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M1_carrier_multiplicity', 'M2_indexed_context_family'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem showing failure of gluing when pairwise compatibility holds on triple overlaps but fails on intersection
- [Adversary 1 - Formal Soundness] Python unit test testing constraint satisfaction solver on SAT instances.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests implementing constraint table gluing, row filtering, and canonical embeddings.
- [Adversary 2 - Mechanization] Boundary unit tests evaluating gluing theorems on empty constraint families and singleton scopes.
- [Adversary 2 - Mechanization] Exhaustive search unit tests verifying that finite row enumeration covers all satisfiable local assignments.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-59 observer factorization and DER-66 canonical covers.
- [Adversary 2 - Mechanization] Upstream integration tests checking that constraint definitions from DER-41 and adapters from DER-59 glue consistently.
- [Adversary 2 - Mechanization] Context integration tests ensuring indexed context family M2 supplies compatible constraint scopes.
- [Adversary 2 - Mechanization] Terminal leaf integration tests asserting that DER-66 exports stable evaluation tables without open bridge requirements.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Constraint verification test asserting that local solutions glue to a unique global assignment.
- [Adversary 2 - Mechanization] End-to-end constraint satisfaction tests verifying that local solutions assemble into a consistent global assignment.
- [Adversary 2 - Mechanization] Evaluation embedding end-to-end tests confirming that row injections preserve satisfaction status.
- [Adversary 2 - Mechanization] Cross-facet correspondence tests matching Lean gluing_theorem_effective with Python constraint solvers.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Corrupt overlap compatibility check by ignoring one boundary coordinate; verify gluing check fails.
- [Adversary 2 - Mechanization] Gluing compatibility mutation tests dropping pairwise overlap checks between intersecting scopes.
- [Adversary 2 - Mechanization] Row membership mutation tests altering row equality validation to ignore unbound variables.
- [Adversary 2 - Mechanization] Embedding injectivity mutation tests collapsing distinct local assignments into a single canonical row.

---

#### `DER-67` — WDP-DYADIC-PRESENTATION-AND-REFINEMENT-TOWER-PROJECTIVE-LIMITS: Constructive Dyadic Refinement Towers, Binary Restriction Fibers, and Compatible Projective Cochains

- **Layer**: `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 15 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 15 Lean theorems in DyadicPresentation.lean. Formalizes dyadic level orders (2^n), binary inclusion maps, and arithmetic residue pairing across ...
- Prose vs code gap: Prose claims projective limits of refinement towers and compatible cochains. Lean code establishes integer inequalities and modulo arithmetic laws between level...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M1_carrier_multiplicity', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 15 Lean theorems in DyadicPresentation.lean. Formalizes dyadic level orders (2^n), binary inclusion maps, and arithmetic residue pairing across refinement levels. Vulnerability: Operates with dyadic residue integers; it does not formalize 2-adic completions, Cantor space topology, or continuous projective limits.
- *Prose vs Code*: Prose claims projective limits of refinement towers and compatible cochains. Lean code establishes integer inequalities and modulo arithmetic laws between levels n and n+1.
- *Boundaries & Assumptions*: Boundary conditions: Level 0 (single point); level 1 (binary); level n -> infinity (unformalized). Unstated assumption: refinement steps are dyadic (branching factor 2).

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M1_carrier_multiplicity', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem showing injectivity of binary restriction fibers
- [Adversary 1 - Formal Soundness] Python unit test testing dyadic tree traversal and bit-level arithmetic.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests implementing dyadic tower addresses, inclusion maps, and residue pairings.
- [Adversary 2 - Mechanization] Boundary unit tests checking inclusion maps at base level 0 and single-step refinement level 1.
- [Adversary 2 - Mechanization] Property unit tests verifying that dyadic orders grow strictly as 2^n across refinement heights.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-67 dyadic towers and OWE-10 open bridge obligation.
- [Adversary 2 - Mechanization] Upstream integration tests confirming that substrate certificates from DER-58 bound refinement heights in DER-67.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that compatible projective cochains satisfy open bridge OWE-10 preconditions.
- [Adversary 2 - Mechanization] Step dynamics integration tests ensuring step history dynamics M3 provide well-ordered refinement transitions.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Multi-level projective sequence test checking that restriction maps commute across level jumps (n -> n+2 vs n -> n+1 -> n+2).
- [Adversary 2 - Mechanization] End-to-end dyadic refinement tests tracing address resolution from level N back to base mark.
- [Adversary 2 - Mechanization] Projective limit compatibility tests asserting that restriction maps commute across level jumps (n -> n+2).
- [Adversary 2 - Mechanization] Cross-facet correspondence tests matching Lean pairing_inclusion with Python bit-shift arithmetic.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate dyadic order formula 2^n to 2*n; verify that inclusion and order tests fail closed.
- [Adversary 2 - Mechanization] Dyadic order mutation tests replacing 2^n with 2*n in level capacity calculation.
- [Adversary 2 - Mechanization] Inclusion map mutation tests altering bit-shift offsets in binary address embedding.
- [Adversary 2 - Mechanization] Residue pairing mutation tests omitting the modulo 2^n reduction in character pairing.

---

#### `DER-68` — WDP-SELF-REFERENCE-BRIDGES-AND-LINKED-REPORT-FACTORIZATION: Constructive Self-Reference Bridges, Partial Section Factorization, and Deferred Linked-Report Horizon

- **Layer**: `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 10 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 10 Lean theorems in SelfReferenceBridges.lean. Formalizes self-reference bridges where reports factorize through presentation fibers without cir...
- Prose vs code gap: Prose describes self-reference bridges and linked-report factorizations. Lean code establishes that deterministic links imply fiber constancy on designated obse...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 10 Lean theorems in SelfReferenceBridges.lean. Formalizes self-reference bridges where reports factorize through presentation fibers without circular self-validation. Vulnerability: Avoids reflective paradoxes by staging report horizons through deferral; it does not formalize full reflective fixed-point combinators.
- *Prose vs Code*: Prose describes self-reference bridges and linked-report factorizations. Lean code establishes that deterministic links imply fiber constancy on designated observation tables.
- *Boundaries & Assumptions*: Boundary conditions: Trivial link (identity); undefined report; empty presentation fiber. Unstated assumption: evaluation horizons can be ordered to prevent cyclic dependency.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 3.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M2_indexed_context_family', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem showing that non-deferred self-reference causes ill-founded recursion
- [Adversary 1 - Formal Soundness] Python unit test testing report cache invalidation on circular links.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests implementing linked-report factorizations and deferred evaluation horizons.
- [Adversary 2 - Mechanization] Boundary unit tests evaluating behavior on empty reports and trivial identity links.
- [Adversary 2 - Mechanization] Acyclicity unit tests asserting that deferred evaluation graphs contain zero dependency cycles.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-68 linked reports and DER-69 functional classifications.
- [Adversary 2 - Mechanization] Upstream integration tests checking that initiality retracts from DER-16 embed into DER-68 self-reference structures.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that linked reports satisfy functional classification preconditions in DER-69.
- [Adversary 2 - Mechanization] Bridge integration tests ensuring that self-reference bridges support discharge requirements for OWE-07.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Horizon evaluation test verifying that reports remain stable across cascading self-inspections.
- [Adversary 2 - Mechanization] End-to-end self-inspection tests confirming that reports remain consistent across cascading evaluation rounds.
- [Adversary 2 - Mechanization] Deferred horizon stability tests asserting that deferred reports evaluate identically to direct reports on convergence.
- [Adversary 2 - Mechanization] Cross-facet correspondence tests matching Lean linked_report_available with Python graph report caches.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Remove the deferral guard in the report evaluation loop; verify circularity detection raises exception.
- [Adversary 2 - Mechanization] Deferral guard mutation tests removing the horizon staging check to trigger immediate cyclic self-reference.
- [Adversary 2 - Mechanization] Fiber constancy mutation tests returning divergent report values on presentation fibers.
- [Adversary 2 - Mechanization] Link verification mutation tests accepting unvalidated links as verified links.

---

#### `DER-69` — WDP-FUNCTIONAL-CLASSIFICATION-AND-BLIND-SPOT-LINKAGE: Decidable Functional Observer Classification, Zero-Tolerance Faithfulness, and Blind-Spot Linkage

- **Layer**: `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 11 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 11 Lean theorems in FunctionalClassification.lean. Formalizes observer classification into linked, stable, and blind-spot states, showing that l...
- Prose vs code gap: Prose claims zero-tolerance faithfulness and functional classification. Lean code defines three predicates and establishes implication lemmas between them....
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'M2_indexed_context_family'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 11 Lean theorems in FunctionalClassification.lean. Formalizes observer classification into linked, stable, and blind-spot states, showing that linked observers have no blind spots. Vulnerability: Blind-spot elimination is established relative to a declared finite set of presentation fibers; it does not establish zero blind spots against unanticipated external perturbations.
- *Prose vs Code*: Prose claims zero-tolerance faithfulness and functional classification. Lean code defines three predicates and establishes implication lemmas between them.
- *Boundaries & Assumptions*: Boundary conditions: All-blind observer (empty report); faithful observer (bijective); singleton state. Unstated assumption: observer classification is decidable for all declared predicates.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'M2_indexed_context_family'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem showing that partial observers admit non-empty blind spots
- [Adversary 1 - Formal Soundness] Python unit test classifying randomly generated observer tables into functional types.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests classifying observers into linked, stable, and blind-spot states.
- [Adversary 2 - Mechanization] Boundary unit tests evaluating observers with zero reports (complete blind spot) and bijective observers (zero blind spot).
- [Adversary 2 - Mechanization] Property unit tests checking that composite linked observers preserve linked classification.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-68 self-reference and DER-69 blind-spot linkage.
- [Adversary 2 - Mechanization] Upstream integration tests confirming that behavioral quotients from DER-39 and links from DER-68 construct valid classifiers.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that observer classification results feed into cosmos extension IMG-10.
- [Adversary 2 - Mechanization] Context integration tests ensuring context family M2 supports all required observation fiber partitions.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Observer robustness test measuring report stability under noise injection into blind-spot fibers.
- [Adversary 2 - Mechanization] End-to-end observer classification tests evaluating synthetic observer suites under noise injection.
- [Adversary 2 - Mechanization] Zero-tolerance faithfulness tests asserting that any readout discrepancy immediately reclassifies the observer as unlinked.
- [Adversary 2 - Mechanization] Cross-facet correspondence tests matching Lean no_blind_spot_linked with Python classification audits.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Invert the blind-spot condition (e.g. blind_spot = true when report is faithful); verify classification tests fail.
- [Adversary 2 - Mechanization] Blind spot partition mutation tests classifying observers with missing fibers as faithful.
- [Adversary 2 - Mechanization] Faithfulness threshold mutation tests relaxing zero-tolerance discrepancy check to tolerate single errors.
- [Adversary 2 - Mechanization] Stability mutation tests removing the prerequisite of fiber constancy from observer linking.

---

#### `DER-70` — WDP-ADMISSION-COUNT-AND-SUBSTRATE-BUDGET-ACCOUNTING: Exact Admission Event Counting, Monotone Ledger Accumulation, and Budget Conservation Identities

- **Layer**: `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 12 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 12 Lean theorems in AdmissionCount.lean. Formalizes monotone accumulation of admission mass and potential bounds across step histories for Sourc...
- Prose vs code gap: Prose claims substrate budget accounting and conservation identities. Lean code establishes that each of the 8 enabled transitions monotonically increments mass...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target', 'M3_step_history_dynamics'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 12 Lean theorems in AdmissionCount.lean. Formalizes monotone accumulation of admission mass and potential bounds across step histories for Source-16 states. Vulnerability: Operates on discrete integer potential functions (n, sum r, sum s, sum leftovers); it does not model non-monotone budget replenishment or continuous resource dissipation.
- *Prose vs Code*: Prose claims substrate budget accounting and conservation identities. Lean code establishes that each of the 8 enabled transitions monotonically increments mass or preserves potential.
- *Boundaries & Assumptions*: Boundary conditions: Initial empty state (zero mass); single step; maximal budget bound. Unstated assumption: admission costs cannot be negative or retroactive.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 5, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target', 'M3_step_history_dynamics'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem showing that non-enabled transitions violate monotone ledger accumulation
- [Adversary 1 - Formal Soundness] Python unit test testing mass and potential updates across 10,000 random transition sequences.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests tracking admission counts, potential functions, and ledger mass.
- [Adversary 2 - Mechanization] Boundary unit tests evaluating potential and mass calculations on empty states and single-step histories.
- [Adversary 2 - Mechanization] Monotonicity unit tests verifying that mass never decreases across all 8 enabled transition types.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-70 budget accounting and DER-45 primitive context floor.
- [Adversary 2 - Mechanization] Upstream integration tests checking that step transitions from DER-33 and floor constraints from DER-45 increment ledger correctly.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that budget bounds enforce conservation in cosmos extension IMG-06.
- [Adversary 2 - Mechanization] Admission integration tests asserting that S0 and S5 budget limits are respected across run executions.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Budget exhaustion test verifying that execution terminates when cumulative admissions hit declared upper bound.
- [Adversary 2 - Mechanization] End-to-end accounting audits tracking cumulative admission expenditures across complete derivation replays.
- [Adversary 2 - Mechanization] Budget exhaustion end-to-end tests confirming that executions halt cleanly when declared budget limits are met.
- [Adversary 2 - Mechanization] Cross-facet correspondence tests matching Lean every_step_mass_monotone with Python ledger logs.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate step mass update from mass + 1 to mass - 1; verify monotonicity assertions trigger immediately.
- [Adversary 2 - Mechanization] Ledger mass mutation tests decrementing mass on state transitions (mass - 1 instead of mass + 1).
- [Adversary 2 - Mechanization] Potential upper bound mutation tests altering potential update bounds to permit unbounded growth.
- [Adversary 2 - Mechanization] Transition enabling mutation tests allowing unadmitted events to execute without incrementing admission counters.

---

#### `DER-71` — WDP-BALANCE-PRESERVING-EDITS-AND-CYCLE-SPACE-INVARIANCE: Balance-Preserving Cochain Edits, Coboundary Perturbation Invariance, and Zero-Sum Cycle Conservation

- **Layer**: `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 10 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 10 Lean theorems in BalancePreservingEdits.lean. Establishes integer cycle laws and coboundary perturbation invariance for Source-25 directed te...
- Prose vs code gap: Prose characterizes this as balance-preserving cochain edits and cycle space invariance. Lean code establishes that adding a gradient cochain preserves zero-sum...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 10 Lean theorems in BalancePreservingEdits.lean. Establishes integer cycle laws and coboundary perturbation invariance for Source-25 directed tetrahedra. Vulnerability: Scoped to local tetrahedral edits on fixed graph topologies; it does not establish cycle space invariance under topological surgery (edge contraction or face splitting).
- *Prose vs Code*: Prose characterizes this as balance-preserving cochain edits and cycle space invariance. Lean code establishes that adding a gradient cochain preserves zero-sum cycle values on a fixed 4-vertex tetrahedron.
- *Boundaries & Assumptions*: Boundary conditions: Trivial cycle (length 0); zero edit; orthogonal cycles. Unstated assumption: edge orientations are anti-symmetric under reversal.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 2.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem showing that non-gradient edits alter cycle sums
- [Adversary 1 - Formal Soundness] Python unit test testing cycle conservation under random integer gradient perturbations.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests computing directed tetrahedral cycle spaces and testing gradient balance preservation.
- [Adversary 2 - Mechanization] Boundary unit tests evaluating cochain edits on trivial zero-cycles and isolated tetrahedral faces.
- [Adversary 2 - Mechanization] Invariance unit tests checking that coboundary perturbations leave fundamental cycle evaluations unchanged.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-71 balance preservation and DER-47 cochain transport.
- [Adversary 2 - Mechanization] Upstream integration tests confirming that cochain edits from DER-38 and transports from DER-47 preserve tetrahedral balance.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that balanced cochains feed valid invariants to IMG-06 and IMG-07 cosmos interfaces.
- [Adversary 2 - Mechanization] Cost target integration tests asserting that balance-preserving edits maintain zero-cost targets S5.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Network circulation test verifying that balanced cochains remain divergence-free under local updates.
- [Adversary 2 - Mechanization] End-to-end cochain evolution tests executing 500 successive balanced edits and asserting zero-sum cycle conservation.
- [Adversary 2 - Mechanization] Coboundary invariance end-to-end tests checking that gradient edits produce zero circulation across closed cycles.
- [Adversary 2 - Mechanization] Cross-facet correspondence tests matching Lean gradient_balanced with Python cochain algebra.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Add a non-zero constant to a single edge in a closed cycle; verify cycle balance assertions detect the deficit.
- [Adversary 2 - Mechanization] Cycle balance mutation tests injecting non-zero circulation into gradient cochain updates.
- [Adversary 2 - Mechanization] Tetrahedral orientation mutation tests flipping edge sign in the boundary differential operator.
- [Adversary 2 - Mechanization] Update scope mutation tests modifying edges inside a cycle while asserting update_outside_cycle holds.

---

#### `DER-72` — WDP-BATCH-10-CANONICAL-TRANSPORT-SYNTHESIS: WDP Batch 10 Synthesis: Multi-Step Transport Composition and Quotient Coherence

- **Layer**: `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 18 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 18 Lean theorems in WdpBatch10.lean. Synthesizes L1-to-L2 complex field embeddings, rational norm multiplicativity (gratNormSq), and multi-step ...
- Prose vs code gap: Prose presents Batch 10 as canonical transport synthesis. Lean formalization establishes algebraic identities for rational complex arithmetic and quotient coher...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S4_retention_state_bit', 'S5_additive_cost_target'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 18 Lean theorems in WdpBatch10.lean. Synthesizes L1-to-L2 complex field embeddings, rational norm multiplicativity (gratNormSq), and multi-step transport composition. Vulnerability: Complex numbers are constructed as rational pairs Q x Q (gratMul), avoiding real analysis; topological completeness and convergence are absent.
- *Prose vs Code*: Prose presents Batch 10 as canonical transport synthesis. Lean formalization establishes algebraic identities for rational complex arithmetic and quotient coherence lemmas.
- *Boundaries & Assumptions*: Boundary conditions: Zero norm vector; identity transport; 1-step vs n-step chains. Unstated assumption: field characteristic is zero (Q arithmetic).

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 4, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S4_retention_state_bit', 'S5_additive_cost_target'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem showing non-degeneracy of the rational complex norm
- [Adversary 1 - Formal Soundness] Python unit test testing multi-step transport compositions against random rational coordinates.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests implementing rational complex arithmetic, gratNormSq, and multi-step transport.
- [Adversary 2 - Mechanization] Boundary unit tests checking transport composition on identity transports and zero norm vectors.
- [Adversary 2 - Mechanization] Algebraic unit tests verifying norm multiplicativity gratNormSq(z * w) = gratNormSq(z) * gratNormSq(w).

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test connecting DER-72 transport composition to DER-73 window synthesis.
- [Adversary 2 - Mechanization] Upstream integration tests verifying that transport structures from DER-50 and schedule guards from DER-57 compose into DER-72.
- [Adversary 2 - Mechanization] Downstream integration tests confirming that Batch 10 quotient coherence satisfies preconditions for DER-73 window synthesis.
- [Adversary 2 - Mechanization] Retention integration tests asserting that one-bit retention state S4 commutes across transport compositions.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Transport test asserting quotient coherence holds after 50 successive composition steps.
- [Adversary 2 - Mechanization] End-to-end transport chain simulations evaluating quotient coherence across 20-step composite paths.
- [Adversary 2 - Mechanization] Multi-step commutativity end-to-end tests checking that path alternatives evaluate to identical quotient states.
- [Adversary 2 - Mechanization] Cross-facet correspondence tests matching Lean gratNormSq_mul with Python rational field arithmetic.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Mutate gratNormSq (x, y) = x^2 + y^2 to x^2 - y^2 (hyperbolic norm); verify norm multiplicativity checks fail.
- [Adversary 2 - Mechanization] Complex multiplication mutation tests altering cross-terms in rational complex multiplication.
- [Adversary 2 - Mechanization] Norm squared mutation tests changing x^2 + y^2 to x^2 - y^2 (hyperbolic norm).
- [Adversary 2 - Mechanization] Transport composition mutation tests dropping associativity in chained transport maps.

---

#### `DER-73` — WDP-BATCH-11-OBSTRUCTION-AND-WINDOW-SYNTHESIS: WDP Batch 11 Synthesis: Windowed Obstruction Bounds and Local-Global Glueing Certificates

- **Layer**: `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 12 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 12 Lean theorems in WdpBatch11.lean. Synthesizes Genesis succession element counts, admitting count inequalities (admittingCount <= everyCount),...
- Prose vs code gap: Prose describes Batch 11 as synthesizing windowed obstruction bounds and local-global gluing certificates. Lean code establishes arithmetic inequalities on even...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 12 Lean theorems in WdpBatch11.lean. Synthesizes Genesis succession element counts, admitting count inequalities (admittingCount <= everyCount), and windowed obstruction bounds. Vulnerability: Windowed obstruction bounds are derived on 3-window overlap configurations; it does not establish obstruction scaling on arbitrarily large window covers.
- *Prose vs Code*: Prose describes Batch 11 as synthesizing windowed obstruction bounds and local-global gluing certificates. Lean code establishes arithmetic inequalities on event count histories and finite window overlaps.
- *Boundaries & Assumptions*: Boundary conditions: Zero change events; single window (zero obstruction); 3-window maximal frustration. Unstated assumption: window partitions have finite overlap intersections.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 6, Outgoing edges: 1.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem showing strict positivity of obstruction on frustrated 3-window systems
- [Adversary 1 - Formal Soundness] Python unit test testing succession counts against simulated execution traces.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests calculating windowed obstruction indices and local-global gluing certificates.
- [Adversary 2 - Mechanization] Boundary unit tests evaluating obstruction bounds on single windows (zero obstruction) and 3-window overlaps.
- [Adversary 2 - Mechanization] Event count unit tests checking stepRung change differences against admitting count inequalities.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-73 window bounds and DER-74 higher cohomology synthesis.
- [Adversary 2 - Mechanization] Upstream integration tests confirming that overlap frustration from DER-52 and transport from DER-72 construct valid Batch 11 certificates.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that window obstruction bounds feed into DER-74 higher cohomology synthesis.
- [Adversary 2 - Mechanization] Carrier integration tests checking multiplicity M1 scaling across windowed partition overlaps.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Local-global gluing simulation verifying that certified windows assemble into a consistent global state.
- [Adversary 2 - Mechanization] End-to-end local-global gluing tests verifying that certified window families assemble into consistent global states.
- [Adversary 2 - Mechanization] Obstruction bound end-to-end tests checking that total frustration remains bounded under window mesh refinement.
- [Adversary 2 - Mechanization] Cross-facet correspondence tests matching Lean stepRung_change_eq_elems_diff with Python event counters.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Flip inequality admittingCount <= everyCount to >=; verify that theorem validation rejects the mutation.
- [Adversary 2 - Mechanization] Admitting count mutation tests inverting the inequality admittingCount <= everyCount to >=.
- [Adversary 2 - Mechanization] Window obstruction mutation tests setting the frustration lower bound to negative infinity.
- [Adversary 2 - Mechanization] Gluing certificate mutation tests omitting boundary consistency checks between overlapping windows.

---

#### `DER-74` — WDP-BATCH-12-HIGHER-COHOMOLOGY-AND-CURVATURE-SYNTHESIS: WDP Batch 12 Synthesis: Simplicial Bianchi Conservation and Curvature-Holonomy Coupling

- **Layer**: `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 18 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 18 Lean theorems in WdpBatch12.lean. Synthesizes Genesis engine class 144 capacities, rule observation counts, simplicial Bianchi identities (d^...
- Prose vs code gap: Prose asserts higher cohomology and curvature synthesis. Lean code establishes combinatorial identities over finite integer vectors and table lookups for 144 en...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 18 Lean theorems in WdpBatch12.lean. Synthesizes Genesis engine class 144 capacities, rule observation counts, simplicial Bianchi identities (d^2 = 0), and curvature-holonomy coupling. Vulnerability: Operates on combinatorial 2-complexes and tetrahedral boundary operators; continuous differential forms, Riemann curvature tensors, and smooth manifolds are not modeled.
- *Prose vs Code*: Prose asserts higher cohomology and curvature synthesis. Lean code establishes combinatorial identities over finite integer vectors and table lookups for 144 engine configurations.
- *Boundaries & Assumptions*: Boundary conditions: Trivial coboundary; zero curvature; flat tetrahedral complex. Unstated assumption: simplicial orientations satisfy standard algebraic topology boundary conventions.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 6, Outgoing edges: 3.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem showing that non-zero curvature prevents exact coboundary trivialization
- [Adversary 1 - Formal Soundness] Python unit test testing the d^2 = 0 nilpotency condition on arbitrary simplicial meshes.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests implementing simplicial boundary differentials, verifying d^2 = 0 nilpotency.
- [Adversary 2 - Mechanization] Boundary unit tests evaluating Bianchi identities on flat complexes vs complexes with localized curvature defects.
- [Adversary 2 - Mechanization] Engine capacity unit tests checking rule observation counts across all 144 Genesis engine classes.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-74 curvature coupling and DER-75 terminal capstone synthesis.
- [Adversary 2 - Mechanization] Upstream integration tests confirming that discrete curvature splits from DER-53 and window bounds from DER-73 feed into DER-74.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that curvature-holonomy couplings satisfy preconditions for DER-75 capstone synthesis.
- [Adversary 2 - Mechanization] Cosmos integration tests linking Bianchi conservation with IMG-01 and IMG-08 higher-dimensional cosmos models.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Curvature conservation test asserting that total simplicial Bianchi sums vanish over closed 3-surfaces.
- [Adversary 2 - Mechanization] End-to-end simplicial cohomology simulations checking that total Bianchi curvature sums vanish on closed 3-surfaces.
- [Adversary 2 - Mechanization] Curvature-holonomy coupling end-to-end tests verifying holonomy changes match enclosed curvature integrals.
- [Adversary 2 - Mechanization] Cross-facet correspondence tests matching Lean bianchi_conservation_tetrahedral with Python boundary matrix calculations.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Invert sign of one face in the tetrahedral boundary operator; verify that d^2 != 0 triggers test failure.
- [Adversary 2 - Mechanization] Coboundary nilpotency mutation tests altering boundary operator signs so that d^2 != 0.
- [Adversary 2 - Mechanization] Curvature-holonomy coupling mutation tests decoupling link holonomies from face curvature values.
- [Adversary 2 - Mechanization] Engine capacity mutation tests exceeding declared capacity limits for class 144 engines.

---

#### `DER-75` — WDP-BATCH-13-TERMINAL-CAPSTONE-SYNTHESIS: WDP Batch 13 Terminal Synthesis: End-to-End Witnessed Difference Programme Replay Closure

- **Layer**: `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | **Bucket**: `DERIVED` | **Tripartite Status**: `PERFECTED`
- **Current Coverage**: 13 Lean theorems; Standalone Python: `False`; Meta-Validation Only: `True`; Checks: `['scripts/check_primitive_difference.py', 'scripts/check_admission_replay.py']`

**Key Adversarial Vulnerabilities**:
- Formal limitation: Verified across 13 Lean theorems in WdpBatch13.lean. Formalizes institutional boundary authorization firewalls (RespectsInstitutionalBoundary), guarded software...
- Prose vs code gap: Prose proclaims terminal capstone synthesis and end-to-end replay closure. Lean code establishes tag-filtering lemmas and predicate preservation across an abstr...
- Mechanization vulnerability: Node binds only to Lean meta-validation scripts; no standalone Python numerical simulation or executable calculation.
- Admissions dependency: Relies on unpriced inputs ['S0_lean_core_host', 'S4_retention_state_bit', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Adversary 1 Findings (Formal Soundness & Prose)**:
- *Soundness*: Verified across 13 Lean theorems in WdpBatch13.lean. Formalizes institutional boundary authorization firewalls (RespectsInstitutionalBoundary), guarded software projections, and end-to-end replay closure for the Witnessed Difference Programme. Vulnerability: Operates as an authorization gate between software-only packets and institutional packets based on discrete tag bits; it does not model side-channel leaks, cryptographic vulnerabilities, or adversarial memory tampering.
- *Prose vs Code*: Prose proclaims terminal capstone synthesis and end-to-end replay closure. Lean code establishes tag-filtering lemmas and predicate preservation across an abstract projection map.
- *Boundaries & Assumptions*: Boundary conditions: All-software packet stream; all-institutional stream; empty packet. Unstated assumption: packet tags cannot be forged or mutated in transit between execution units.

**Adversary 2 Findings (Mechanization & Integration)**:
- *Mechanization*: Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation.
- *Integration Seams*: Incoming edges: 6, Outgoing edges: 3.
- *Admission Traceability*: Declared unpriced admissions: ['S0_lean_core_host', 'S4_retention_state_bit', 'S5_additive_cost_target', 'M1_carrier_multiplicity'].

**Missing Unit Tests**:
- [Adversary 1 - Formal Soundness] Lean theorem showing that untagged institutional packets are rejected by the firewall
- [Adversary 1 - Formal Soundness] Python unit test testing boundary enforcement against malformed packet streams.
- [Adversary 2 - Mechanization] Dedicated standalone Python unit tests implementing the institutional boundary authorization firewall and software projection.
- [Adversary 2 - Mechanization] Boundary unit tests evaluating firewall behavior on empty packet streams and all-software vs all-institutional packets.
- [Adversary 2 - Mechanization] Tag validation unit tests verifying that packet tag filtering strictly enforces security boundaries.

**Missing Integration Tests**:
- [Adversary 1 - Formal Soundness] Seam test between DER-74 higher cohomology outputs and DER-75 capstone closure.
- [Adversary 2 - Mechanization] Upstream integration tests confirming that outputs from DER-62 (quantum), DER-64 (gauge), and DER-74 (cohomology) are accepted by DER-75.
- [Adversary 2 - Mechanization] Downstream integration tests verifying that terminal replay closure supports cosmos extensions IMG-04, IMG-09, and IMG-10.
- [Adversary 2 - Mechanization] Full admission integration tests asserting that S0, S4, S5, and M1 admissions are accounted for at terminal capstone.

**Missing End-to-End Tests**:
- [Adversary 1 - Formal Soundness] Full-chain replay test from initial mark through all 75 derivation nodes to DER-75 terminal verification.
- [Adversary 2 - Mechanization] Comprehensive end-to-end replay test verifying entire derivation DAG from mark to DER-75 capstone under non-zero costs.
- [Adversary 2 - Mechanization] Security firewall end-to-end tests asserting that institutional packets cannot bypass software projection gates.
- [Adversary 2 - Mechanization] Cross-facet correspondence tests matching Lean guardedEnforcement_respects_boundary with Python firewall logs.

**Missing Mutation Tests**:
- [Adversary 1 - Formal Soundness] Disable packet tag inspection in firewall filter; verify security boundary tests fail closed.
- [Adversary 2 - Mechanization] Firewall bypass mutation tests allowing untagged institutional packets to pass software projections.
- [Adversary 2 - Mechanization] Boundary respect mutation tests inverting the boolean outcome of RespectsInstitutionalBoundary.
- [Adversary 2 - Mechanization] Terminal closure mutation tests marking replay verification successful when intermediate assertions fail.

---

## 4. Master Cross-Facet Synthesis Matrix

| Node ID | Code | Layer | Tripartite Status | Lean Theorems | Meta Only | Unit Gaps | Integ Gaps | E2E Gaps | Mut Gaps | Total Gaps |
|---|---|---|---|---:|:---:|---:|---:|---:|---:|---:|
| `DER-52` | `WDP-LOCAL-COMPATIBILITY-AND-OVERLAP-FRUSTRATION` | `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | `PERFECTED` | 15 | YES | 5 | 4 | 4 | 5 | **18** |
| `DER-53` | `WDP-DISCRETE-GAUSS-BONNET-AND-REGGE-CURVATURE-SPLIT` | `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | `PERFECTED` | 15 | YES | 5 | 4 | 4 | 6 | **19** |
| `DER-54` | `WDP-FINITE-WINDOW-OBSTRUCTION-AND-DIAGNOSTIC-TRICHOTOMY` | `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | `PERFECTED` | 24 | YES | 5 | 4 | 4 | 5 | **18** |
| `DER-55` | `WDP-HIGHER-SIMPLICIAL-COHOMOLOGY-AND-PENTACHORON-EXACTNESS` | `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | `PERFECTED` | 21 | YES | 5 | 4 | 4 | 5 | **18** |
| `DER-56` | `WDP-BRIDGE-OBLIGATION-REDUCTIONS-OWE07-TO-OWE13` | `5_INTERNAL_METATHEORY` | `PERFECTED` | 18 | YES | 5 | 4 | 4 | 5 | **18** |
| `OWE-01` | `S0-HOST-SUBSTRATE` | `0_HOST_AND_ADMISSIONS` | `NON_PERFECTED` | 0 | YES | 5 | 4 | 4 | 6 | **19** |
| `OWE-02` | `S1-INHABITED-OFFDIAGONAL-PAIR` | `0_HOST_AND_ADMISSIONS` | `NON_PERFECTED` | 1 | NO | 5 | 4 | 4 | 6 | **19** |
| `OWE-03` | `S2-S5-SYMMETRY-COMPOSITION-RETENTION-COST` | `0_HOST_AND_ADMISSIONS` | `NON_PERFECTED` | 0 | NO | 5 | 4 | 4 | 6 | **19** |
| `OWE-04` | `M1-M3-UNFREEZING-MECHANISMS` | `0_HOST_AND_ADMISSIONS` | `NON_PERFECTED` | 0 | NO | 5 | 4 | 4 | 5 | **18** |
| `DER-01` | `N03-N09-PRIMITIVE-DIFFERENCE` | `1_PRE_SEAL_MARK_AND_TORSOR` | `PERFECTED` | 26 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-02` | `N04-N08-TORSOR-AND-OPERATIONS` | `1_PRE_SEAL_MARK_AND_TORSOR` | `PERFECTED` | 27 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-03` | `OQ-01-RT-03-N16-CARRIER-BOUNDS-AND-SYMMETRY-FLOOR` | `1_PRE_SEAL_MARK_AND_TORSOR` | `PERFECTED` | 9 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-04` | `N11-MIRROR-NON-IDENTIFICATION` | `1_PRE_SEAL_MARK_AND_TORSOR` | `PERFECTED` | 19 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-05` | `N28-N33-ZERO-EQUIVALENCE-AND-RESIDUAL-QUOTIENT` | `2_SEAL_AND_ZERO_EQUIVALENCE` | `PERFECTED` | 62 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-06` | `WDP-CH01-MINIMAL-SEPARATION-REGIME4` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 12 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-07` | `OQ-04-RT-01-ARITY-COST-UNIQUENESS` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 10 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-08` | `OQ-05-RT-09-MULTI-ROUND-CLOSURE` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 7 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-09` | `WDP-CH02-FIVE-MODE-REFUSAL-HIERARCHY` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 5 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-10` | `OQ-03-RT-02-MEMORY-PACKET-16-OF-1024` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 9 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-11` | `OQ-06-RT-05-RT-10-CHOICE-FREE-REPORT-FACTORIZATION` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 7 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-12` | `RT-06-OQ-08-RT-12-CLOSURE-DUALITY-AND-HORIZON-MORPHISM` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `CONDITIONALLY_PERFECTED` | 8 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-13` | `OQ-02-RT-04-SIMPLICIAL-COBOUNDARY-AND-VORTEX` | `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | `PERFECTED` | 9 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-14` | `OQ-07-RT-11-L1-WEIGHT-SYMMETRY` | `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | `PERFECTED` | 4 | NO | 5 | 4 | 4 | 5 | **18** |
| `DER-15` | `RT-07-RT-08-NATURAL-SECTION-AND-HOLONOMY` | `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | `PERFECTED` | 7 | NO | 5 | 4 | 4 | 5 | **18** |
| `DER-16` | `WDP-CH03-CONSTITUTIONAL-INITIALITY-AND-RETRACT` | `5_INTERNAL_METATHEORY` | `PERFECTED` | 8 | NO | 5 | 4 | 4 | 5 | **18** |
| `DER-17` | `WDP-CH04-NO-OUTSIDE-AND-DIAGONAL-TOWER` | `5_INTERNAL_METATHEORY` | `PERFECTED` | 10 | NO | 5 | 4 | 4 | 5 | **18** |
| `DER-18` | `WDP-CH06-MONOTONIC-NO-RETURN` | `5_INTERNAL_METATHEORY` | `PERFECTED` | 6 | NO | 5 | 4 | 4 | 5 | **18** |
| `DER-19` | `AUDIT-MINIMAL-CHAIN-CAMPAIGNS-1-TO-3` | `5_INTERNAL_METATHEORY` | `PERFECTED` | 5 | NO | 5 | 4 | 4 | 5 | **18** |
| `DER-20` | `EVIDENCE-SEED-AUDIT-BASELINE` | `5_INTERNAL_METATHEORY` | `NON_PERFECTED` | 0 | NO | 5 | 4 | 4 | 5 | **18** |
| `DER-21` | `SLICE-IX-PROFILE-PREORDER-EQUIVALENCE-BRIDGE` | `2_SEAL_AND_ZERO_EQUIVALENCE` | `PERFECTED` | 20 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-22` | `SLICE-IX-TEN-STICK-RESIDUAL-AND-PHASE-LIFT-MODELS` | `2_SEAL_AND_ZERO_EQUIVALENCE` | `CONDITIONALLY_PERFECTED` | 9 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-23` | `SLICE-IX-SUPPLIED-GENERATOR-TRACE-AND-RADIUS-PROFILE-COLLISION` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `CONDITIONALLY_PERFECTED` | 35 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-24` | `OQ-05-REGIME4-TRANSITION-TO-CLASS-COUNT-BRIDGE` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 36 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-25` | `SLICE-X-HOLONOMY-PERIOD-FOUR-AND-STICK-THRESHOLD-CHARACTERIZATION` | `2_SEAL_AND_ZERO_EQUIVALENCE` | `PERFECTED` | 12 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-26` | `SLICE-XI-MULTI-ROUND-CAPACITY-SCALING-AND-ADAPTIVE-HORIZON` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 8 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-27` | `SLICE-XII-ORBIT-DECOMPOSED-COCHAIN-WEIGHTS-GENERAL` | `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | `PERFECTED` | 10 | NO | 5 | 4 | 4 | 5 | **18** |
| `DER-28` | `SLICE-XIII-SINGLETON-VIEW-EMBEDDING-AND-FULL-REPLAY-BRIDGE` | `5_INTERNAL_METATHEORY` | `PERFECTED` | 6 | NO | 5 | 4 | 4 | 5 | **18** |
| `DER-29` | `SLICE-XIV-PAIR-QUOTIENT-MULTIPLICITY-AND-SYMMETRY-FLOOR-BRIDGE` | `1_PRE_SEAL_MARK_AND_TORSOR` | `PERFECTED` | 6 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-30` | `SLICE-XV-SIMPLICIAL-COCHAIN-EXACTNESS-AND-PRIMAL-DUAL-L1-MIN` | `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | `PERFECTED` | 6 | NO | 5 | 4 | 4 | 5 | **18** |
| `DER-31` | `WDP-GENERATIVE-HISTORY-COMPRESSION` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 21 | YES | 5 | 4 | 4 | 6 | **19** |
| `DER-32` | `WDP-GENESIS-CONSTRUCTION-LITERAL-ROOT` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 7 | YES | 5 | 4 | 4 | 5 | **18** |
| `DER-33` | `OMEGA-ADMISSION-REPLAY-WDP-BRIDGE` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 25 | NO | 5 | 4 | 4 | 6 | **19** |
| `DER-34` | `WDP-FINITE-DISTINCTION-HORIZON-AND-MINIMAL-QUOTIENT` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 34 | YES | 5 | 4 | 4 | 5 | **18** |
| `DER-35` | `WDP-RELATIONAL-RETENTION-BISIMULATION-AND-ACYCLIC-REACHABILITY` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 19 | YES | 5 | 4 | 4 | 5 | **18** |
| `DER-36` | `WDP-RETENTION-CHOICES-AND-NONTRANSITIVE-TOLERANCE` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 17 | YES | 5 | 4 | 4 | 5 | **18** |
| `DER-37` | `WDP-SOURCE25-PAIR-TRANSPORT-AND-PAID-TRACE-PRESERVATION` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 10 | YES | 5 | 4 | 4 | 5 | **18** |
| `DER-38` | `WDP-COCHAIN-TRANSPORT-NATURALITY` | `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | `PERFECTED` | 4 | YES | 5 | 4 | 4 | 5 | **18** |
| `DER-39` | `WDP-BEHAVIORAL-QUOTIENT-FINITE-WORDS` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 17 | YES | 5 | 4 | 4 | 5 | **18** |
| `DER-40` | `WDP-CONTEXT-REFLECTION-KERNEL-REFINEMENT` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 14 | YES | 5 | 4 | 4 | 5 | **18** |
| `DER-41` | `WDP-FAITHFUL-REPRESENTATION-PROFILE-INJECTIVITY` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 20 | YES | 5 | 4 | 4 | 5 | **18** |
| `DER-42` | `WDP-GUARDED-HISTORY-COHERENCE-EXACT-BOUNDARIES` | `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | `PERFECTED` | 11 | YES | 5 | 4 | 4 | 5 | **18** |
| `DER-43` | `WDP-OBSERVER-DESCENT-KERNEL-FACTORS` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 6 | YES | 5 | 4 | 4 | 5 | **18** |
| `DER-44` | `WDP-ORIGINAL-GENESIS-OBSERVER-SIX-FIELD-SIGNATURE` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 18 | YES | 5 | 4 | 4 | 5 | **18** |
| `DER-45` | `WDP-PRIMITIVE-ADMISSION-FLOOR-NO-PHANTOM-REDUCTION` | `1_PRE_SEAL_MARK_AND_TORSOR` | `PERFECTED` | 8 | YES | 5 | 4 | 4 | 5 | **18** |
| `DER-46` | `WDP-PRIMITIVE-CONTEXT-FLOOR-SEPARATION` | `3_POST_SEAL_SEPARATION_AND_RETENTION` | `PERFECTED` | 11 | YES | 5 | 4 | 4 | 5 | **18** |
| `DER-47` | `WDP-ROOT-GAUGE-NORMALIZATION-SPANNING-TREE` | `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | `PERFECTED` | 16 | YES | 5 | 4 | 4 | 6 | **19** |
| `DER-48` | `WDP-SPARSE-CHAIN-TRANSPORT-OPERATOR-BOUNDS` | `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | `PERFECTED` | 45 | YES | 5 | 4 | 4 | 5 | **18** |
| `DER-49` | `WDP-TROTTER-CHAR-POLY-SPECTRAL-INVARIANCE` | `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | `PERFECTED` | 33 | YES | 5 | 4 | 4 | 5 | **18** |
| `DER-50` | `WDP-BATCH9-PRIMAL-DUAL-REPAIR-SYNTHESIS` | `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | `PERFECTED` | 18 | YES | 5 | 4 | 4 | 5 | **18** |
| `DER-51` | `WDP-OBSTRUCTION-COHOMOLOGY-AND-WEAK-STRONG-DUALITY` | `4_LOCAL_GLOBAL_AND_L1_GEOMETRY` | `PERFECTED` | 31 | YES | 5 | 4 | 4 | 5 | **18** |
| `OWE-05` | `PG-R-GAP-DIAMOND-TO-ROOT` | `6_OWED_BRIDGES` | `NON_PERFECTED` | 0 | NO | 5 | 4 | 4 | 5 | **18** |
| `OWE-06` | `PG-R-GAP-GENESIS-TO-WINDOW` | `6_OWED_BRIDGES` | `NON_PERFECTED` | 0 | NO | 5 | 4 | 4 | 5 | **18** |
| `OWE-07` | `N21-N22-INTERNAL-WITNESSING-AND-PERSISTENCE` | `6_OWED_BRIDGES` | `NON_PERFECTED` | 0 | NO | 5 | 4 | 4 | 5 | **18** |
| `OWE-08` | `N19-N20-TEN-STICK-REFLECTION-AND-FOUR-STEP-LIFT` | `6_OWED_BRIDGES` | `NON_PERFECTED` | 0 | NO | 5 | 4 | 4 | 5 | **18** |
| `OWE-09` | `L1-R-RESIDUAL-TO-WEIGHTS` | `6_OWED_BRIDGES` | `NON_PERFECTED` | 4 | NO | 5 | 4 | 4 | 5 | **18** |
| `OWE-10` | `N23-N26-PROFILE-PREORDER-AND-CONTINUUM-ADMISSION` | `6_OWED_BRIDGES` | `NON_PERFECTED` | 0 | NO | 5 | 4 | 4 | 5 | **18** |
| `OWE-12` | `OQ-08-LEGACY-REPRESENTED-HORIZON-BRIDGE` | `6_OWED_BRIDGES` | `NON_PERFECTED` | 0 | NO | 5 | 4 | 4 | 5 | **18** |
| `OWE-13` | `N22-MULTI-ROUND-LAW-AND-REPAIR-PERSISTENCE-BRIDGE` | `6_OWED_BRIDGES` | `NON_PERFECTED` | 0 | NO | 5 | 4 | 4 | 5 | **18** |
| `IMG-01` | `WDP-HIGHER-SEMI-SIMPLICIAL-COHOMOLOGY` | `7_IMAGINED_COSMOS_EXTENSION` | `NON_PERFECTED` | 0 | NO | 5 | 4 | 4 | 5 | **18** |
| `IMG-02` | `STAGE-05-OBSERVER-FUNCTOR-CAUSAL-DIAMONDS` | `7_IMAGINED_COSMOS_EXTENSION` | `NON_PERFECTED` | 0 | NO | 5 | 4 | 4 | 5 | **18** |
| `IMG-03` | `STAGE-06-L1-TO-L2-COMPLEX-AMPLITUDE-LIFT` | `7_IMAGINED_COSMOS_EXTENSION` | `NON_PERFECTED` | 0 | NO | 5 | 4 | 4 | 5 | **18** |
| `IMG-04` | `STAGE-07-FINITE-QM-BORN-GLEASON-CPTP` | `7_IMAGINED_COSMOS_EXTENSION` | `NON_PERFECTED` | 0 | NO | 5 | 4 | 4 | 5 | **18** |
| `IMG-05` | `STAGE-08-MUB-TENSOR-ENTANGLEMENT` | `7_IMAGINED_COSMOS_EXTENSION` | `NON_PERFECTED` | 0 | NO | 5 | 4 | 4 | 5 | **18** |
| `IMG-06` | `STAGE-09-DISCRETE-NOETHER-AND-CANONICAL-PAIRS` | `7_IMAGINED_COSMOS_EXTENSION` | `NON_PERFECTED` | 0 | NO | 5 | 4 | 4 | 5 | **18** |
| `IMG-07` | `STAGE-10-FINITE-GAUGE-SECTORS` | `7_IMAGINED_COSMOS_EXTENSION` | `NON_PERFECTED` | 0 | NO | 5 | 4 | 4 | 5 | **18** |
| `IMG-08` | `STAGE-11-SIMPLICIAL-REGGE-GRAVITY` | `7_IMAGINED_COSMOS_EXTENSION` | `NON_PERFECTED` | 0 | NO | 5 | 4 | 4 | 5 | **18** |
| `IMG-09` | `STAGE-12-CONSTRUCTOR-THEORY-AND-THERMODYNAMICS` | `7_IMAGINED_COSMOS_EXTENSION` | `NON_PERFECTED` | 0 | NO | 5 | 4 | 4 | 5 | **18** |
| `IMG-10` | `STAGE-13-COSMOS-SELF-HOSTING-METATHEORY` | `7_IMAGINED_COSMOS_EXTENSION` | `NON_PERFECTED` | 0 | NO | 5 | 4 | 4 | 5 | **18** |
| `DER-57` | `WDP-GUARDED-SCHEDULE-TOPOLOGY-AND-ONE-BIT-RETENTION` | `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | `PERFECTED` | 29 | YES | 5 | 4 | 4 | 4 | **17** |
| `DER-58` | `WDP-FOUNDATIONAL-BRIDGES-AND-SUBSTRATE-CERTIFICATES` | `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | `PERFECTED` | 18 | YES | 5 | 4 | 4 | 4 | **17** |
| `DER-59` | `WDP-OBSERVER-ADAPTER-COMPLETENESS-AND-READOUT-FACTORIZATION` | `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | `PERFECTED` | 27 | YES | 5 | 4 | 4 | 4 | **17** |
| `DER-60` | `WDP-ADDITIVE-TENSOR-COMPLETION-AND-GROTHENDIECK-FACTORIZATION` | `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | `PERFECTED` | 54 | YES | 5 | 4 | 4 | 4 | **17** |
| `DER-61` | `WDP-DAGGER-OBSERVER-PAIRING-AND-ADJOINT-INVOLUTION` | `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | `PERFECTED` | 16 | YES | 5 | 4 | 4 | 4 | **17** |
| `DER-62` | `WDP-GAUSSIAN-INT-QUANTUM-READOUT-AND-FINITE-MODEL-DISCHARGES` | `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | `PERFECTED` | 24 | YES | 5 | 4 | 4 | 4 | **17** |
| `DER-63` | `WDP-COMPLEX-TENSOR-BALANCING-AND-PHASE-EQUIVALENCE` | `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | `PERFECTED` | 14 | YES | 5 | 4 | 4 | 4 | **17** |
| `DER-64` | `WDP-MARKED-GAUGE-TRANSPORT-AND-TREE-DEFECT-INVARIANCE` | `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | `PERFECTED` | 19 | YES | 5 | 4 | 4 | 4 | **17** |
| `DER-65` | `WDP-MERON-THERMO-LIMIT-CONSTANTS-AND-WILSON-ACTION-BOUNDS` | `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | `PERFECTED` | 18 | YES | 5 | 4 | 4 | 4 | **17** |
| `DER-66` | `WDP-FINITE-CONSTRAINT-REPRESENTATION-AND-CANONICAL-COVER` | `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | `PERFECTED` | 26 | YES | 5 | 4 | 4 | 4 | **17** |
| `DER-67` | `WDP-DYADIC-PRESENTATION-AND-REFINEMENT-TOWER-PROJECTIVE-LIMITS` | `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | `PERFECTED` | 15 | YES | 5 | 4 | 4 | 4 | **17** |
| `DER-68` | `WDP-SELF-REFERENCE-BRIDGES-AND-LINKED-REPORT-FACTORIZATION` | `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | `PERFECTED` | 10 | YES | 5 | 4 | 4 | 4 | **17** |
| `DER-69` | `WDP-FUNCTIONAL-CLASSIFICATION-AND-BLIND-SPOT-LINKAGE` | `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | `PERFECTED` | 11 | YES | 5 | 4 | 4 | 4 | **17** |
| `DER-70` | `WDP-ADMISSION-COUNT-AND-SUBSTRATE-BUDGET-ACCOUNTING` | `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | `PERFECTED` | 12 | YES | 5 | 4 | 4 | 4 | **17** |
| `DER-71` | `WDP-BALANCE-PRESERVING-EDITS-AND-CYCLE-SPACE-INVARIANCE` | `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | `PERFECTED` | 10 | YES | 5 | 4 | 4 | 4 | **17** |
| `DER-72` | `WDP-BATCH-10-CANONICAL-TRANSPORT-SYNTHESIS` | `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | `PERFECTED` | 18 | YES | 5 | 4 | 4 | 4 | **17** |
| `DER-73` | `WDP-BATCH-11-OBSTRUCTION-AND-WINDOW-SYNTHESIS` | `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | `PERFECTED` | 12 | YES | 5 | 4 | 4 | 4 | **17** |
| `DER-74` | `WDP-BATCH-12-HIGHER-COHOMOLOGY-AND-CURVATURE-SYNTHESIS` | `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | `PERFECTED` | 18 | YES | 5 | 4 | 4 | 4 | **17** |
| `DER-75` | `WDP-BATCH-13-TERMINAL-CAPSTONE-SYNTHESIS` | `6_WDP_CANONICAL_REPLAY_AND_BRIDGE` | `PERFECTED` | 13 | YES | 5 | 4 | 4 | 4 | **17** |

## 5. Downstream Prioritized Test Engineering Roadmap

To systematically address the test gap without premature test suites during Milestone 4, the following execution phases are recommended for downstream engineering cycles:

1. **Phase 1: Zero-Assertion Script Hardening (Immediate Priority)**
   - Refactor `audit/2026-11-05_minimal_chain/2_mark_checks.py`, `4_frozen_checks.py`, and `5_forcing_checks.py`.
   - Replace unasserted print statements with strict equality assertions and non-zero exits.

2. **Phase 2: Trotter Calculator Restoration (DER-49)**
   - Port `trotter_characteristic_polynomials.py` into `scripts/` or `code/`.
   - Author dedicated unit tests verifying cyclic trace invariance, response matrix generation, and char poly roots.

3. **Phase 3: WDP Layer 6 Standalone Mechanization (DER-31..DER-56)**
   - Develop standalone Python numerical simulation engines for discrete Gauss-Bonnet, cochain transport, and simplicial cohomology.
   - Replace Lean meta-script reliance with dynamic property-based tests in `tests/`.

4. **Phase 4: Admission Closure and Graph Re-wiring**
   - Explicitly wire open bridges `OWE-05`, `OWE-06`, and `OWE-10` to downstream consumers.
   - Propagate conditional bridge debt `OWE-08` from `DER-22` into `DER-49`.
