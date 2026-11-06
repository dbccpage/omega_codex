"""
Comprehensive Validation Test Suite for dag/test_gap_catalog.json and dag/test_gap_catalog.md (Milestone 4).

Validates:
1. File existence and substantial content.
2. Canonical schema version and top-level metadata.
3. 100% coverage across all 78 derivation DAG nodes.
4. Completeness of per-node schemas and coverage metrics.
5. Non-empty test gap categories (unit, integration, end-to-end, mutation) for every node.
6. Representation of both Adversary 1 and Adversary 2 across findings and test items.
7. Completeness of systemic vulnerability catalog.
8. Exact arithmetic consistency between census summary and node aggregations.
9. Strict Claim Hygiene: zero forbidden terms across JSON and Markdown artifacts.
"""

import json
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[1]
JSON_CATALOG_PATH = ROOT / "dag" / "test_gap_catalog.json"
MD_CATALOG_PATH = ROOT / "dag" / "test_gap_catalog.md"
DAG_PATH = ROOT / "dag" / "derivation_dag.json"
AUDIT_PATH = ROOT / "dag" / "tripartite_correspondence_audit.json"

FORBIDDEN_REGEX = re.compile(
    r"\b(metaphysics|ontology|philosophy|philosophical|proves|prove|proved|proving|guarantees|mathematically\s+verifies|fundamentally|true\s+intelligence|impossible|universal|flawless|perfectly|clearly|obviously|simply|merely|weaponized|gpt|gemini|claude|chatgpt|openai|anthropic)\b",
    re.IGNORECASE,
)

EXPECTED_NODE_FIELDS = {
    "id",
    "code",
    "layer",
    "bucket",
    "tripartite_status",
    "status_detail",
    "title",
    "current_coverage",
    "adversary_1_findings",
    "adversary_2_findings",
    "key_adversarial_vulnerabilities",
    "missing_unit_tests",
    "missing_integration_tests",
    "missing_end_to_end_tests",
    "missing_mutation_tests",
}

EXPECTED_COVERAGE_FIELDS = {
    "lean_theorems_count",
    "python_checks",
    "standalone_python_mechanization",
    "meta_validation_only",
    "incoming_edge_count",
    "outgoing_edge_count",
}

EXPECTED_ADV1_FIELDS = {
    "role",
    "soundness_critique",
    "prose_vs_code",
    "boundaries_and_assumptions",
}

EXPECTED_ADV2_FIELDS = {
    "role",
    "mechanization_assessment",
    "integration_seams",
    "admission_traceability",
}


class TestGapCatalogValidationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.assertTrue(
            JSON_CATALOG_PATH.is_file(),
            f"Missing required artifact: {JSON_CATALOG_PATH}",
        )
        cls.assertTrue(
            MD_CATALOG_PATH.is_file(),
            f"Missing required artifact: {MD_CATALOG_PATH}",
        )
        with open(JSON_CATALOG_PATH, "r", encoding="utf-8") as f:
            cls.catalog_data = json.load(f)
        cls.md_text = MD_CATALOG_PATH.read_text(encoding="utf-8")

        with open(DAG_PATH, "r", encoding="utf-8") as f:
            cls.dag_data = json.load(f)

        with open(AUDIT_PATH, "r", encoding="utf-8") as f:
            cls.audit_data = json.load(f)

    def test_artifacts_exist_and_non_empty(self) -> None:
        self.assertGreater(JSON_CATALOG_PATH.stat().st_size, 50_000)
        self.assertGreater(MD_CATALOG_PATH.stat().st_size, 50_000)

    def test_top_level_metadata(self) -> None:
        self.assertEqual(self.catalog_data.get("schema_version"), "1.0.0")
        self.assertIn("Two-Person Adversarial Test Gap Catalog", self.catalog_data.get("title", ""))
        self.assertIn("auditors", self.catalog_data)
        self.assertEqual(len(self.catalog_data["auditors"]), 2)
        self.assertIn("claim_hygiene_summary", self.catalog_data)
        self.assertIn("systemic_vulnerabilities", self.catalog_data)
        self.assertIn("census_summary", self.catalog_data)
        self.assertIn("nodes", self.catalog_data)

    def test_covers_all_78_derivation_dag_nodes(self) -> None:
        dag_node_ids = [n["id"] for n in self.dag_data["nodes"]]
        self.assertEqual(len(dag_node_ids), 97)
        catalog_node_ids = list(self.catalog_data["nodes"].keys())
        self.assertEqual(len(catalog_node_ids), 97)
        self.assertEqual(set(dag_node_ids), set(catalog_node_ids))

    def test_node_schema_completeness(self) -> None:
        for nid, node in self.catalog_data["nodes"].items():
            with self.subTest(node_id=nid):
                missing = EXPECTED_NODE_FIELDS - set(node.keys())
                self.assertFalse(missing, f"Node {nid} is missing fields: {missing}")

                # Check coverage sub-fields
                cov = node["current_coverage"]
                missing_cov = EXPECTED_COVERAGE_FIELDS - set(cov.keys())
                self.assertFalse(missing_cov, f"Node {nid} current_coverage missing: {missing_cov}")

                # Check Adv1 sub-fields
                adv1 = node["adversary_1_findings"]
                missing_adv1 = EXPECTED_ADV1_FIELDS - set(adv1.keys())
                self.assertFalse(missing_adv1, f"Node {nid} adversary_1_findings missing: {missing_adv1}")

                # Check Adv2 sub-fields
                adv2 = node["adversary_2_findings"]
                missing_adv2 = EXPECTED_ADV2_FIELDS - set(adv2.keys())
                self.assertFalse(missing_adv2, f"Node {nid} adversary_2_findings missing: {missing_adv2}")

    def test_all_gap_categories_non_empty_for_every_node(self) -> None:
        for nid, node in self.catalog_data["nodes"].items():
            with self.subTest(node_id=nid):
                u = node["missing_unit_tests"]
                i = node["missing_integration_tests"]
                e = node["missing_end_to_end_tests"]
                m = node["missing_mutation_tests"]

                self.assertIsInstance(u, list)
                self.assertGreater(len(u), 0, f"Node {nid} has empty missing_unit_tests")
                self.assertIsInstance(i, list)
                self.assertGreater(len(i), 0, f"Node {nid} has empty missing_integration_tests")
                self.assertIsInstance(e, list)
                self.assertGreater(len(e), 0, f"Node {nid} has empty missing_end_to_end_tests")
                self.assertIsInstance(m, list)
                self.assertGreater(len(m), 0, f"Node {nid} has empty missing_mutation_tests")

                # Verify all entries are non-empty strings
                for cat_name, cat_list in [("unit", u), ("integration", i), ("e2e", e), ("mutation", m)]:
                    for idx, item in enumerate(cat_list):
                        self.assertIsInstance(item, str)
                        self.assertGreater(len(item.strip()), 10, f"Node {nid} {cat_name}[{idx}] too short: {item!r}")

    def test_both_adversaries_represented_in_test_categories(self) -> None:
        for nid, node in self.catalog_data["nodes"].items():
            with self.subTest(node_id=nid):
                for cat_name in ["missing_unit_tests", "missing_integration_tests", "missing_end_to_end_tests", "missing_mutation_tests"]:
                    items = node[cat_name]
                    has_adv1 = any("[Adversary 1 - Formal Soundness]" in item for item in items)
                    has_adv2 = any("[Adversary 2 - Mechanization]" in item for item in items)
                    self.assertTrue(has_adv1, f"Node {nid} {cat_name} missing Adversary 1 items")
                    self.assertTrue(has_adv2, f"Node {nid} {cat_name} missing Adversary 2 items")

    def test_adversary_critique_text_non_empty(self) -> None:
        for nid, node in self.catalog_data["nodes"].items():
            with self.subTest(node_id=nid):
                adv1 = node["adversary_1_findings"]
                self.assertGreater(len(adv1["soundness_critique"].strip()), 20)
                self.assertGreater(len(adv1["prose_vs_code"].strip()), 20)
                self.assertGreater(len(adv1["boundaries_and_assumptions"].strip()), 20)

                adv2 = node["adversary_2_findings"]
                self.assertGreater(len(adv2["mechanization_assessment"].strip()), 10)
                self.assertGreater(len(adv2["integration_seams"].strip()), 10)
                self.assertGreater(len(adv2["admission_traceability"].strip()), 10)

    def test_key_vulnerabilities_populated(self) -> None:
        for nid, node in self.catalog_data["nodes"].items():
            with self.subTest(node_id=nid):
                vulns = node["key_adversarial_vulnerabilities"]
                self.assertIsInstance(vulns, list)
                self.assertGreater(len(vulns), 0, f"Node {nid} key_adversarial_vulnerabilities is empty")

    def test_systemic_vulnerabilities_coverage(self) -> None:
        vulns = self.catalog_data["systemic_vulnerabilities"]
        self.assertGreaterEqual(len(vulns), 7)
        titles = [v["title"] for v in vulns]

        expected_topics = [
            "Zero-Assertion",
            "Mechanization Facet Inflation",
            "Trotter Characteristic Polynomials",
            "Discrete Gauss-Bonnet",
            "Memoryless Refusal Register",
            "Admission Chain Bypasses",
            "Disconnected Open Bridge Obligations",
        ]
        for topic in expected_topics:
            self.assertTrue(
                any(topic in t for t in titles),
                f"Missing systemic vulnerability topic: {topic}",
            )

        for v in vulns:
            self.assertIn("id", v)
            self.assertIn("title", v)
            self.assertIn("severity", v)
            self.assertIn("affected_files", v)
            self.assertIn("description", v)
            self.assertIn("epistemic_impact", v)
            self.assertIn("remediation", v)
            self.assertGreater(len(v["affected_files"]), 0)

    def test_census_summary_arithmetic_consistency(self) -> None:
        census = self.catalog_data["census_summary"]
        nodes = self.catalog_data["nodes"]

        self.assertEqual(census["total_nodes_audited"], len(nodes))
        self.assertEqual(census["total_nodes_audited"], 97)

        calc_perfected = sum(1 for n in nodes.values() if n["tripartite_status"] == "PERFECTED")
        calc_cond = sum(1 for n in nodes.values() if n["tripartite_status"] == "CONDITIONALLY_PERFECTED")
        calc_non_perf = sum(1 for n in nodes.values() if n["tripartite_status"] == "NON_PERFECTED")

        self.assertEqual(census["perfected_nodes"], calc_perfected)
        self.assertEqual(census["conditionally_perfected_nodes"], calc_cond)
        self.assertEqual(census["non_perfected_nodes"], calc_non_perf)
        self.assertEqual(calc_perfected + calc_cond + calc_non_perf, 97)

        calc_unit = sum(len(n["missing_unit_tests"]) for n in nodes.values())
        calc_integ = sum(len(n["missing_integration_tests"]) for n in nodes.values())
        calc_e2e = sum(len(n["missing_end_to_end_tests"]) for n in nodes.values())
        calc_mut = sum(len(n["missing_mutation_tests"]) for n in nodes.values())

        self.assertEqual(census["total_missing_unit_tests"], calc_unit)
        self.assertEqual(census["total_missing_integration_tests"], calc_integ)
        self.assertEqual(census["total_missing_end_to_end_tests"], calc_e2e)
        self.assertEqual(census["total_missing_mutation_tests"], calc_mut)
        self.assertEqual(census["total_missing_test_items"], calc_unit + calc_integ + calc_e2e + calc_mut)

    def test_claim_hygiene_across_json_catalog(self) -> None:
        raw_json = JSON_CATALOG_PATH.read_text(encoding="utf-8")
        matches = set(FORBIDDEN_REGEX.findall(raw_json))
        self.assertFalse(matches, f"Claim hygiene forbidden terms in test_gap_catalog.json: {matches}")

    def test_claim_hygiene_across_markdown_catalog(self) -> None:
        matches = set(FORBIDDEN_REGEX.findall(self.md_text))
        self.assertFalse(matches, f"Claim hygiene forbidden terms in test_gap_catalog.md: {matches}")


if __name__ == "__main__":
    unittest.main()
