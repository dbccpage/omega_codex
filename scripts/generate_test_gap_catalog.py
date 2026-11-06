"""
Canonical Test Gap Catalog Synthesis Generator (Milestone 4).

Synthesizes findings from both Adversary 1 (challenger_adv_1: Formal Soundness & Prose)
and Adversary 2 (challenger_adv_2: Mechanization & Integration) across all 97 nodes
of dag/derivation_dag.json into:
  - dag/test_gap_catalog.json
  - dag/test_gap_catalog.md

Strict claim hygiene: zero forbidden terms.
"""

from collections import OrderedDict
import datetime
import json
from pathlib import Path
import re
import sys

REPO_ROOT = Path(__file__).resolve().parents[1]
SCRIPTS_DIR = Path(__file__).resolve().parent
if str(SCRIPTS_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPTS_DIR))

from wdp_adversarial_critiques import ADV1_WDP_CRITIQUES, ADV2_WDP_NODES

ADV1_DIR = REPO_ROOT / ".agents" / "teamwork" / "challenger_adv_1"
ADV2_DIR = REPO_ROOT / ".agents" / "teamwork" / "challenger_adv_2"

DAG_PATH = REPO_ROOT / "dag" / "derivation_dag.json"
AUDIT_PATH = REPO_ROOT / "dag" / "tripartite_correspondence_audit.json"
ADV2_CATALOG_PATH = ADV2_DIR / "test_gap_catalog_adv2.json"

OUT_JSON_PATH = REPO_ROOT / "dag" / "test_gap_catalog.json"
OUT_MD_PATH = REPO_ROOT / "dag" / "test_gap_catalog.md"

# Forbidden phrases regex per project claim hygiene rules
FORBIDDEN_PATTERN = re.compile(
    r"\b(metaphysics|ontology|philosophy|philosophical|proves|prove|proved|proving|guarantees|mathematically\s+verifies|fundamentally|true\s+intelligence|impossible|universal|flawless|perfectly|clearly|obviously|simply|merely|weaponized|gpt|gemini|claude|chatgpt|openai|anthropic)\b",
    re.IGNORECASE,
)


def assert_claim_hygiene(text: str, context: str) -> None:
    matches = set(FORBIDDEN_PATTERN.findall(text))
    if matches:
        raise ValueError(f"Claim hygiene violation in {context}: forbidden term(s) {matches}")


def parse_adv1_items(text: str, prefix: str) -> list[str]:
    cleaned = re.sub(rf"^{prefix}:\s*", "", text, flags=re.IGNORECASE).strip()
    if "(1)" in cleaned and "(2)" in cleaned:
        parts = re.split(r";?\s*\(\d+\)\s*", cleaned)
        return [p.strip().rstrip(";") for p in parts if p.strip()]
    return [cleaned]


def load_inputs():
    sys.path.insert(0, str(ADV1_DIR))
    import generate_adversarial_handoff as g1

    with open(DAG_PATH, "r", encoding="utf-8") as f:
        dag = json.load(f)

    with open(AUDIT_PATH, "r", encoding="utf-8") as f:
        audit = json.load(f)

    with open(ADV2_CATALOG_PATH, "r", encoding="utf-8") as f:
        adv2 = json.load(f)

    # Ingest dual-adversary critiques for DER-57 through DER-75
    adv1_critiques = dict(g1.ALL_CRITIQUES)
    adv1_critiques.update(ADV1_WDP_CRITIQUES)

    adv2_nodes = dict(adv2["nodes"])
    adv2_nodes.update(ADV2_WDP_NODES)
    adv2["nodes"] = adv2_nodes
    adv2["total_nodes_audited"] = len(adv2_nodes)

    return dag, audit, adv1_critiques, adv2


def build_systemic_vulnerabilities() -> list[dict]:
    return [
        {
            "id": "VULN-01",
            "title": "Zero-Assertion and Superficial Check Scripts in Audit Suite",
            "severity": "CRITICAL",
            "affected_files": [
                "audit/2026-11-05_minimal_chain/2_mark_checks.py",
                "audit/2026-11-05_minimal_chain/4_frozen_checks.py",
                "audit/2026-11-05_minimal_chain/5_forcing_checks.py",
                "audit/2026-11-05_minimal_chain/9_oq01_to_oq04_checks.py",
                "audit/2026-11-05_minimal_chain/3_regime_deletions.py",
            ],
            "description": (
                "Three of the seven audit check scripts in audit/2026-11-05_minimal_chain/ "
                "(2_mark_checks.py, 4_frozen_checks.py, 5_forcing_checks.py) contain exactly zero "
                "assert statements, exception raises, or non-zero exit codes. They execute print statements "
                "and terminate with exit code 0 unconditionally. For example, 2_mark_checks.py:246-273 computes "
                "soundness_holds = all(...), prints the boolean to stdout, and exits with code 0 even if the "
                "invariant evaluates to False. Script 9_oq01_to_oq04_checks.py has only 1 assertion across 266 lines, "
                "and 3_regime_deletions.py has only 2 superficial 'is not None' checks across 476 lines."
            ),
            "epistemic_impact": (
                "Validation via scripts/validate_derivation_dag.py --run-checks reports false green success, "
                "masking runtime invariant breakages as successful runs."
            ),
            "remediation": (
                "Convert all stdout print checks into explicit boolean assertions and structured exceptions "
                "that exit with non-zero status upon evaluation failure."
            ),
        },
        {
            "id": "VULN-02",
            "title": "Mechanization Facet Inflation in WDP Layer 6 and Host Admissions",
            "severity": "HIGH",
            "affected_files": [
                "scripts/check_primitive_difference.py",
                "scripts/check_admission_replay.py",
                "dag/derivation_dag.json",
            ],
            "description": (
                "Exactly 26 nodes (host admission OWE-01 and 25 derived nodes in WDP Layer 6: "
                "DER-31, DER-32, DER-34 through DER-56) declare python_checks restricted to "
                "scripts/check_primitive_difference.py and scripts/check_admission_replay.py. "
                "These scripts only verify Lean toolchain compilation hashes and inspect #print axioms. "
                "There is zero executable Python code performing numerical simulation or runtime property testing "
                "for discrete Gauss-Bonnet splits (DER-53), cochain window trichotomy (DER-54), pentachoron monopoles (DER-55), "
                "rooted tree gauge normalization (DER-47), sparse chain transport norms (DER-48), or primal-dual repair quotients (DER-50, DER-51)."
            ),
            "epistemic_impact": (
                "24 of the 52 nodes classified as PERFECTED in the tri-partite correspondence audit have never been executed "
                "or tested in Python; their mechanization facet is administrative meta-validation rather than behavioral execution."
            ),
            "remediation": (
                "Author dedicated Python calculation modules and property-based test suites in tests/ covering each "
                "mathematical structure in WDP Layer 6."
            ),
        },
        {
            "id": "VULN-03",
            "title": "Missing Response Matrix Calculator in Trotter Characteristic Polynomials (DER-49)",
            "severity": "CRITICAL",
            "affected_files": [
                "lean/WitnessedDifference/TrotterCharPoly.lean",
                "dag/derivation_dag.json",
            ],
            "description": (
                "The header of lean/WitnessedDifference/TrotterCharPoly.lean (lines 11-14) states: "
                "'This file does not build the response matrix and does not derive a characteristic polynomial. "
                "The Python module code/trotter_characteristic_polynomials.py is the calculator for those matrices.' "
                "However, code/trotter_characteristic_polynomials.py does not exist in omega_codex, and the code/ "
                "directory is completely absent. All 33 theorems in TrotterCharPoly.lean only evaluate constant fraction "
                "identities of the form a * num - b * den = 0 via rfl (e.g., evalCleared 21 10 m1_root_pos1 = 0 checks 21*10 - 10*21 = 0)."
            ),
            "epistemic_impact": (
                "DER-49 is cataloged as PERFECTED, but its declared computational calculator was never integrated into omega_codex."
            ),
            "remediation": (
                "Port code/trotter_characteristic_polynomials.py from reference Repository B into scripts/ or a dedicated package, "
                "and bind dedicated unit tests in tests/."
            ),
        },
        {
            "id": "VULN-04",
            "title": "Integer Linear Arithmetic Substitutions in Discrete Gauss-Bonnet (DER-53) and Cohomology (DER-55)",
            "severity": "HIGH",
            "affected_files": [
                "lean/WitnessedDifference/DiscreteGaussBonnet.lean",
                "lean/WitnessedDifference/HigherSimplicialCohomology.lean",
            ],
            "description": (
                "In DiscreteGaussBonnet.lean:201-206, discrete_gauss_bonnet_triangulated_surface is a 4-variable integer linear "
                "identity 6*V - sumK = 6*(V - E + F) discharged in one step by the integer linear arithmetic tactic omega "
                "from hypotheses 2*E = 3*F and sumK = 2*E. There is no triangulated geometric surface, curvature form, or boundary operator. "
                "In HigherSimplicialCohomology.lean, Euler characteristics are proven by 'by decide' on static integer arithmetic expressions "
                "((4:Int) - 6 + 4 = 2, (6:Int) - 12 + 8 = 2, (5:Int) - 10 + 10 - 5 = 0) on single Platonic simplices."
            ),
            "epistemic_impact": (
                "Mathematical prose discusses continuum Regge calculus and General Relativity, whereas formal proofs operate "
                "strictly on static integer arithmetic expressions over single small graphs."
            ),
            "remediation": (
                "Implement generic simplicial mesh data structures and boundary operators in Python and Lean to verify deficit "
                "angle sums on non-equilateral and multi-cell meshes."
            ),
        },
        {
            "id": "VULN-05",
            "title": "Memoryless Refusal Register in Primitive Difference (DER-01)",
            "severity": "MEDIUM",
            "affected_files": [
                "lean/PrimitiveDifference.lean",
            ],
            "description": (
                "In lean/PrimitiveDifference.lean:166-168, def recordRefusal (c : Bool -> Bool) (_previous : Register) : Register := ⟨reject c⟩ "
                "discards the _previous register state completely. The refusal register is a stateless boolean wrapper evaluating "
                "an instantaneous function equality rather than accumulating operational history or state transitions."
            ),
            "epistemic_impact": (
                "Downstream prose describes cumulative refusal tracking, whereas the formalized code implements a stateless check."
            ),
            "remediation": (
                "Formalize stateful refusal registers accumulating historical candidate maps over input sequences, "
                "with tests verifying persistence across sequential updates."
            ),
        },
        {
            "id": "VULN-06",
            "title": "Admission Chain Bypasses and Transitive Admission Dropping",
            "severity": "HIGH",
            "affected_files": [
                "dag/derivation_dag.json",
                "dag/tripartite_correspondence_audit.json",
            ],
            "description": (
                "(1) DER-22 is marked DERIVED_CONDITIONALLY on open bridge OWE-08. DER-49 derives directly from DER-22, "
                "yet DER-49 is classified as unconditionally PERFECTED without inheriting OWE-08 or an incoming admission edge. "
                "(2) 51 of 56 DERIVED nodes drop transitive OWED admission dependencies from their unpriced_inputs_or_admissions "
                "(such as OWE-02 S1-S3 substrate, declared only on DER-01 and DER-02)."
            ),
            "epistemic_impact": (
                "Downstream derivations appear unconditionally established despite depending transitively on open bridge debts "
                "or unpriced foundational admissions."
            ),
            "remediation": (
                "Compute transitive closures of admission dependencies during DAG validation and propagate open bridge debts downstream."
            ),
        },
        {
            "id": "VULN-07",
            "title": "Disconnected Open Bridge Obligations in Derivation DAG",
            "severity": "HIGH",
            "affected_files": [
                "dag/derivation_dag.json",
            ],
            "description": (
                "Open bridge obligations OWE-05 (diamond-to-root gap), OWE-06 (genesis-to-window gap), and OWE-10 (infinite completion) "
                "have zero outgoing edges in dag/derivation_dag.json. Downstream nodes bypass them completely by assuming restricted "
                "finite carriers without explicit graph dependency edges."
            ),
            "epistemic_impact": (
                "The DAG topology masks open foundational debts by isolating bridge nodes rather than explicitly wiring them to consumers."
            ),
            "remediation": (
                "Connect open bridge obligations to their downstream recipient nodes with explicit requires_admission or motivates_bridge edges."
            ),
        },
        {
            "id": "VULN-08",
            "title": "Toy-Model Cost Restrictions in Replay Commutation (DER-12, DER-28, DER-33)",
            "severity": "MEDIUM",
            "affected_files": [
                "lean/AdmissionReplay.lean",
                "lean/WitnessedDifference/GuardedHistoryCoherence.lean",
                "audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py",
            ],
            "description": (
                "Commutation between HWorld and Represented.World is evaluated strictly at zero admission and retention cost "
                "(cSup = 0, cAdm = 0, cRet = 0, cEv = 1) and singleton views. Non-zero costs, multi-locus views, and non-trivial memory limits "
                "remain untested in executable code."
            ),
            "epistemic_impact": (
                "Commutation and replay properties are verified only under degenerate zero-cost conditions, leaving behavior under non-zero costs unexamined."
            ),
            "remediation": (
                "Author property-based simulation suites sweeping across non-zero cost vectors and multi-locus configurations."
            ),
        },
        {
            "id": "VULN-09",
            "title": "Scale Divergence between Mathematical Prose and Constructive Formalization",
            "severity": "MEDIUM",
            "affected_files": [
                "docs/research_map.md",
                "dag/README.md",
                "lean/*",
            ],
            "description": (
                "Mathematical prose documents employ terminology from continuous physics, differential geometry, and quantum field theory "
                "(e.g., Einstein-Hilbert action, Regge calculus, cosmological horizons, quantum state spaces), whereas formal code implements "
                "strictly discrete, finite combinatorial structures (e.g., Bool, Fin 3, single Platonic solids, hardcoded fractions)."
            ),
            "epistemic_impact": (
                "Creates semantic inflation where readers may confuse toy combinatorial models with continuous physical theories."
            ),
            "remediation": (
                "Align mathematical prose strictly with finite discrete structures and explicitly label all continuum descriptions as non-formalized conjectures."
            ),
        },
    ]


def synthesize_catalog():
    dag, audit, adv1_critiques, adv2 = load_inputs()

    audit_by_id = {n["id"]: n for n in audit["nodes"]}
    dag_nodes = {n["id"]: n for n in dag["nodes"]}
    adv2_nodes = adv2["nodes"]

    synthesized_nodes = OrderedDict()

    tot_unit = 0
    tot_integ = 0
    tot_e2e = 0
    tot_mut = 0

    for node in dag["nodes"]:
        nid = node["id"]
        audit_node = audit_by_id.get(nid, {})
        adv1_c = adv1_critiques.get(nid, {})
        adv2_c = adv2_nodes.get(nid, {})

        # Parse Adv1 missing tests
        adv1_unit_raw = adv1_c.get("missing_unit", "")
        adv1_integ_raw = adv1_c.get("missing_integration", "")
        adv1_e2e_raw = adv1_c.get("missing_e2e", "")
        adv1_mut_raw = adv1_c.get("missing_mutation", "")

        adv1_unit_items = [
            f"[Adversary 1 - Formal Soundness] {item}"
            for item in parse_adv1_items(adv1_unit_raw, "Unit")
        ]
        adv1_integ_items = [
            f"[Adversary 1 - Formal Soundness] {item}"
            for item in parse_adv1_items(adv1_integ_raw, "Integration")
        ]
        adv1_e2e_items = [
            f"[Adversary 1 - Formal Soundness] {item}"
            for item in parse_adv1_items(adv1_e2e_raw, "End-to-End")
        ]
        adv1_mut_items = [
            f"[Adversary 1 - Formal Soundness] {item}"
            for item in parse_adv1_items(adv1_mut_raw, "Mutation")
        ]

        # Extract Adv2 missing tests
        adv2_unit_items = [
            f"[Adversary 2 - Mechanization] {item}"
            for item in adv2_c.get("missing_unit_tests", [])
        ]
        adv2_integ_items = [
            f"[Adversary 2 - Mechanization] {item}"
            for item in adv2_c.get("missing_integration_tests", [])
        ]
        adv2_e2e_items = [
            f"[Adversary 2 - Mechanization] {item}"
            for item in adv2_c.get("missing_end_to_end_tests", [])
        ]
        adv2_mut_items = [
            f"[Adversary 2 - Mechanization] {item}"
            for item in adv2_c.get("missing_mutation_tests", [])
        ]

        combined_unit = adv1_unit_items + adv2_unit_items
        combined_integ = adv1_integ_items + adv2_integ_items
        combined_e2e = adv1_e2e_items + adv2_e2e_items
        combined_mut = adv1_mut_items + adv2_mut_items

        tot_unit += len(combined_unit)
        tot_integ += len(combined_integ)
        tot_e2e += len(combined_e2e)
        tot_mut += len(combined_mut)

        # Build key vulnerabilities summary
        vulns = []
        if adv1_c.get("soundness"):
            vulns.append(f"Formal limitation: {adv1_c['soundness'][:160]}...")
        if adv1_c.get("prose_vs_code"):
            vulns.append(f"Prose vs code gap: {adv1_c['prose_vs_code'][:160]}...")
        if adv2_c.get("current_coverage", {}).get("meta_validation_only"):
            vulns.append(
                "Mechanization vulnerability: Node binds only to Lean meta-validation scripts; "
                "no standalone Python numerical simulation or executable calculation."
            )
        elif not adv2_c.get("current_coverage", {}).get("standalone_python_mechanization"):
            vulns.append("Mechanization vulnerability: Missing dedicated executable Python property tests.")

        admissions = node.get("unpriced_inputs_or_admissions", [])
        if admissions:
            vulns.append(f"Admissions dependency: Relies on unpriced inputs {admissions}.")

        synthesized_nodes[nid] = {
            "id": nid,
            "code": node.get("code", ""),
            "layer": node.get("layer", ""),
            "bucket": node.get("bucket", ""),
            "tripartite_status": audit_node.get("classification", "UNKNOWN"),
            "status_detail": node.get("status_detail", ""),
            "title": node.get("title", ""),
            "current_coverage": adv2_c.get("current_coverage", {
                "lean_theorems_count": 0,
                "python_checks": node.get("python_checks", []),
                "standalone_python_mechanization": False,
                "meta_validation_only": True,
                "incoming_edge_count": 0,
                "outgoing_edge_count": 0,
            }),
            "adversary_1_findings": {
                "role": "Formal Soundness and Mathematical Prose",
                "soundness_critique": adv1_c.get("soundness", ""),
                "prose_vs_code": adv1_c.get("prose_vs_code", ""),
                "boundaries_and_assumptions": adv1_c.get("boundaries_assumptions", ""),
            },
            "adversary_2_findings": {
                "role": "Mechanization and Integration Architecture",
                "mechanization_assessment": (
                    "Binds exclusively to Lean meta-validation scripts; zero runtime Python simulation."
                    if adv2_c.get("current_coverage", {}).get("meta_validation_only")
                    else "Has dedicated Python check scripts, but requires assertion hardening and boundary testing."
                ),
                "integration_seams": (
                    f"Incoming edges: {adv2_c.get('current_coverage', {}).get('incoming_edge_count', 0)}, "
                    f"Outgoing edges: {adv2_c.get('current_coverage', {}).get('outgoing_edge_count', 0)}."
                ),
                "admission_traceability": (
                    f"Declared unpriced admissions: {node.get('unpriced_inputs_or_admissions', [])}."
                ),
            },
            "key_adversarial_vulnerabilities": vulns,
            "missing_unit_tests": combined_unit,
            "missing_integration_tests": combined_integ,
            "missing_end_to_end_tests": combined_e2e,
            "missing_mutation_tests": combined_mut,
        }

    catalog = {
        "schema_version": "1.0.0",
        "title": "Two-Person Adversarial Test Gap Catalog across 97 Derivation DAG Nodes",
        "generated_at": datetime.datetime.now(datetime.timezone.utc).isoformat(),
        "auditors": [
            {
                "role": "Adversary 1 (Formal Soundness and Mathematical Prose)",
                "agent": "challenger_adv_1",
            },
            {
                "role": "Adversary 2 (Mechanization and Integration Architecture)",
                "agent": "challenger_adv_2",
            },
        ],
        "claim_hygiene_summary": {
            "supports": (
                "A structured catalog of missing unit, integration, end-to-end, and mutation tests across all 97 "
                "derivation DAG nodes, identifying formal soundness limitations, unstated boundaries, check script "
                "assertion deficits, mechanization inflation, admission chain bypasses, and disconnected bridge obligations."
            ),
            "does_not_support": (
                "Any implementation of new test suites (strictly precluded by Milestone 4), any assertion that "
                "cataloging substitutes for empirical test execution, or any claim that toy-model checks establish "
                "continuum physics or general domain properties."
            ),
            "narrowest_defensible_claim": (
                "The derivation DAG contains 71 unconditionally perfected, 3 conditionally perfected, and 23 non-perfected "
                "nodes; 45 nodes lack standalone executable Python simulation (binding only to Lean meta-validation scripts), "
                "3 check scripts in audit/ contain zero assertions, and 51 of 56 derived nodes drop transitive admission dependencies."
            ),
            "next_test_needed": (
                "Execution of prioritized unit and integration test suites during downstream test engineering cycles, "
                "restoration of the Trotter char poly calculator in DER-49, hardening of zero-assertion audit check scripts, "
                "and explicit transitive wiring of open bridge admissions."
            ),
        },
        "systemic_vulnerabilities": build_systemic_vulnerabilities(),
        "census_summary": {
            "total_nodes_audited": len(synthesized_nodes),
            "perfected_nodes": sum(1 for n in synthesized_nodes.values() if n["tripartite_status"] == "PERFECTED"),
            "conditionally_perfected_nodes": sum(1 for n in synthesized_nodes.values() if n["tripartite_status"] == "CONDITIONALLY_PERFECTED"),
            "non_perfected_nodes": sum(1 for n in synthesized_nodes.values() if n["tripartite_status"] == "NON_PERFECTED"),
            "nodes_missing_standalone_python_mechanization": sum(1 for n in synthesized_nodes.values() if n["current_coverage"]["meta_validation_only"]),
            "zero_assertion_check_scripts_count": 3,
            "total_missing_unit_tests": tot_unit,
            "total_missing_integration_tests": tot_integ,
            "total_missing_end_to_end_tests": tot_e2e,
            "total_missing_mutation_tests": tot_mut,
            "total_missing_test_items": tot_unit + tot_integ + tot_e2e + tot_mut,
        },
        "nodes": synthesized_nodes,
    }

    return catalog


def generate_markdown(catalog: dict) -> str:
    census = catalog["census_summary"]
    systemic = catalog["systemic_vulnerabilities"]
    nodes = catalog["nodes"]

    md = []
    md.append("# Two-Person Adversarial Test Gap Catalog across 97 Derivation DAG Nodes\n")

    md.append("## Claim Hygiene Summary\n")
    md.append(f"1. **What it supports**: {catalog['claim_hygiene_summary']['supports']}")
    md.append(f"2. **What it does not support**: {catalog['claim_hygiene_summary']['does_not_support']}")
    md.append(f"3. **Narrowest defensible claim**: {catalog['claim_hygiene_summary']['narrowest_defensible_claim']}")
    md.append(f"4. **Next test needed**: {catalog['claim_hygiene_summary']['next_test_needed']}\n")

    md.append("## 1. Executive Summary & Audit Census\n")
    md.append(
        "This catalog synthesizes the independent adversarial investigations conducted by **Adversary 1** "
        "(`challenger_adv_1`: Formal Soundness and Mathematical Prose) and **Adversary 2** "
        "(`challenger_adv_2`: Mechanization and Integration Architecture) across all 97 nodes of "
        "the derivation DAG (`dag/derivation_dag.json`) and the tri-partite correspondence audit "
        "(`dag/tripartite_correspondence_audit.json`).\n"
    )

    md.append("| Metric | Count | Proportion |")
    md.append("|---|---:|---:|")
    md.append(f"| Total Derivation DAG Nodes Audited | {census['total_nodes_audited']} | 100.0% |")
    md.append(f"| Unconditionally Perfected Nodes | {census['perfected_nodes']} | {census['perfected_nodes']/census['total_nodes_audited']*100:.1f}% |")
    md.append(f"| Conditionally Perfected Nodes (Bridge-Dependent) | {census['conditionally_perfected_nodes']} | {census['conditionally_perfected_nodes']/census['total_nodes_audited']*100:.1f}% |")
    md.append(f"| Non-Perfected Nodes (Admissions / Bridges / Imagined) | {census['non_perfected_nodes']} | {census['non_perfected_nodes']/census['total_nodes_audited']*100:.1f}% |")
    md.append(f"| Nodes Missing Standalone Python Simulation (Meta-Only) | {census['nodes_missing_standalone_python_mechanization']} | {census['nodes_missing_standalone_python_mechanization']/census['total_nodes_audited']*100:.1f}% |")
    md.append(f"| Zero-Assertion Audit Check Scripts | {census['zero_assertion_check_scripts_count']} | N/A |")
    md.append(f"| Total Missing Unit Test Prescriptions | {census['total_missing_unit_tests']} | N/A |")
    md.append(f"| Total Missing Integration Test Prescriptions | {census['total_missing_integration_tests']} | N/A |")
    md.append(f"| Total Missing End-to-End Test Prescriptions | {census['total_missing_end_to_end_tests']} | N/A |")
    md.append(f"| Total Missing Mutation Test Prescriptions | {census['total_missing_mutation_tests']} | N/A |")
    md.append(f"| **Grand Total Cataloged Test Prescriptions** | **{census['total_missing_test_items']}** | **100.0%** |\n")

    md.append("## 2. Systemic Vulnerabilities\n")
    for v in systemic:
        md.append(f"### {v['id']}: {v['title']}\n")
        md.append(f"- **Severity**: `{v['severity']}`")
        md.append(f"- **Affected Files**: `{', '.join(v['affected_files'])}`")
        md.append(f"- **Description**: {v['description']}")
        md.append(f"- **Epistemic Impact**: {v['epistemic_impact']}")
        md.append(f"- **Remediation**: {v['remediation']}\n")

    md.append("## 3. Comprehensive Per-Node Test Gap Properties\n")

    # Group by layer
    by_layer = OrderedDict()
    for n in nodes.values():
        by_layer.setdefault(n["layer"], []).append(n)

    for layer_name, layer_nodes in by_layer.items():
        md.append(f"### Layer: {layer_name} ({len(layer_nodes)} Nodes)\n")
        for n in layer_nodes:
            md.append(f"#### `{n['id']}` — {n['code']}: {n['title']}\n")
            md.append(f"- **Layer**: `{n['layer']}` | **Bucket**: `{n['bucket']}` | **Tripartite Status**: `{n['tripartite_status']}`")
            md.append(f"- **Current Coverage**: {n['current_coverage']['lean_theorems_count']} Lean theorems; "
                      f"Standalone Python: `{n['current_coverage']['standalone_python_mechanization']}`; "
                      f"Meta-Validation Only: `{n['current_coverage']['meta_validation_only']}`; "
                      f"Checks: `{n['current_coverage']['python_checks']}`")

            md.append("\n**Key Adversarial Vulnerabilities**:")
            for vuln in n["key_adversarial_vulnerabilities"]:
                md.append(f"- {vuln}")

            md.append("\n**Adversary 1 Findings (Formal Soundness & Prose)**:")
            md.append(f"- *Soundness*: {n['adversary_1_findings']['soundness_critique']}")
            md.append(f"- *Prose vs Code*: {n['adversary_1_findings']['prose_vs_code']}")
            md.append(f"- *Boundaries & Assumptions*: {n['adversary_1_findings']['boundaries_and_assumptions']}")

            md.append("\n**Adversary 2 Findings (Mechanization & Integration)**:")
            md.append(f"- *Mechanization*: {n['adversary_2_findings']['mechanization_assessment']}")
            md.append(f"- *Integration Seams*: {n['adversary_2_findings']['integration_seams']}")
            md.append(f"- *Admission Traceability*: {n['adversary_2_findings']['admission_traceability']}")

            md.append("\n**Missing Unit Tests**:")
            for item in n["missing_unit_tests"]:
                md.append(f"- {item}")

            md.append("\n**Missing Integration Tests**:")
            for item in n["missing_integration_tests"]:
                md.append(f"- {item}")

            md.append("\n**Missing End-to-End Tests**:")
            for item in n["missing_end_to_end_tests"]:
                md.append(f"- {item}")

            md.append("\n**Missing Mutation Tests**:")
            for item in n["missing_mutation_tests"]:
                md.append(f"- {item}")

            md.append("\n---\n")

    md.append("## 4. Master Cross-Facet Synthesis Matrix\n")
    md.append("| Node ID | Code | Layer | Tripartite Status | Lean Theorems | Meta Only | Unit Gaps | Integ Gaps | E2E Gaps | Mut Gaps | Total Gaps |")
    md.append("|---|---|---|---|---:|:---:|---:|---:|---:|---:|---:|")
    for n in nodes.values():
        u = len(n["missing_unit_tests"])
        i = len(n["missing_integration_tests"])
        e = len(n["missing_end_to_end_tests"])
        m = len(n["missing_mutation_tests"])
        tot = u + i + e + m
        meta_str = "YES" if n["current_coverage"]["meta_validation_only"] else "NO"
        md.append(f"| `{n['id']}` | `{n['code']}` | `{n['layer']}` | `{n['tripartite_status']}` | {n['current_coverage']['lean_theorems_count']} | {meta_str} | {u} | {i} | {e} | {m} | **{tot}** |")

    md.append("\n## 5. Downstream Prioritized Test Engineering Roadmap\n")
    md.append(
        "To systematically address the test gap without premature test suites during Milestone 4, "
        "the following execution phases are recommended for downstream engineering cycles:\n\n"
        "1. **Phase 1: Zero-Assertion Script Hardening (Immediate Priority)**\n"
        "   - Refactor `audit/2026-11-05_minimal_chain/2_mark_checks.py`, `4_frozen_checks.py`, and `5_forcing_checks.py`.\n"
        "   - Replace unasserted print statements with strict equality assertions and non-zero exits.\n\n"
        "2. **Phase 2: Trotter Calculator Restoration (DER-49)**\n"
        "   - Port `trotter_characteristic_polynomials.py` into `scripts/` or `code/`.\n"
        "   - Author dedicated unit tests verifying cyclic trace invariance, response matrix generation, and char poly roots.\n\n"
        "3. **Phase 3: WDP Layer 6 Standalone Mechanization (DER-31..DER-56)**\n"
        "   - Develop standalone Python numerical simulation engines for discrete Gauss-Bonnet, cochain transport, "
        "and simplicial cohomology.\n"
        "   - Replace Lean meta-script reliance with dynamic property-based tests in `tests/`.\n\n"
        "4. **Phase 4: Admission Closure and Graph Re-wiring**\n"
        "   - Explicitly wire open bridges `OWE-05`, `OWE-06`, and `OWE-10` to downstream consumers.\n"
        "   - Propagate conditional bridge debt `OWE-08` from `DER-22` into `DER-49`.\n"
    )

    return "\n".join(md)


def main() -> int:
    print("Synthesizing test gap catalog from Adversary 1 and Adversary 2...")
    catalog = synthesize_catalog()

    json_str = json.dumps(catalog, indent=2, ensure_ascii=False)
    print("Validating JSON claim hygiene...")
    assert_claim_hygiene(json_str, "test_gap_catalog.json")

    print(f"Writing {OUT_JSON_PATH}...")
    OUT_JSON_PATH.write_text(json_str, encoding="utf-8")

    print("Generating markdown summary...")
    md_str = generate_markdown(catalog)

    print("Validating Markdown claim hygiene...")
    assert_claim_hygiene(md_str, "test_gap_catalog.md")

    print(f"Writing {OUT_MD_PATH}...")
    OUT_MD_PATH.write_text(md_str, encoding="utf-8")

    census = catalog["census_summary"]
    print("Synthesis complete:")
    print(f"  Total nodes: {census['total_nodes_audited']}")
    print(f"  Perfected: {census['perfected_nodes']}")
    print(f"  Conditionally Perfected: {census['conditionally_perfected_nodes']}")
    print(f"  Non-Perfected: {census['non_perfected_nodes']}")
    print(f"  Total test prescriptions: {census['total_missing_test_items']}")
    print(f"    Unit: {census['total_missing_unit_tests']}")
    print(f"    Integration: {census['total_missing_integration_tests']}")
    print(f"    End-to-End: {census['total_missing_end_to_end_tests']}")
    print(f"    Mutation: {census['total_missing_mutation_tests']}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
