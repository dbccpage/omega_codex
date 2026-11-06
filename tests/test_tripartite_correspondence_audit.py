"""Unit and regression tests for dag/tripartite_correspondence_audit.json and .md."""
from __future__ import annotations

import json
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[1]
JSON_PATH = ROOT / "dag/tripartite_correspondence_audit.json"
MD_PATH = ROOT / "dag/tripartite_correspondence_audit.md"
DAG_PATH = ROOT / "dag/derivation_dag.json"

FORBIDDEN_PHRASES = (
    "proves",
    "prove",
    "proved",
    "proving",
    "guarantees",
    "mathematically verifies",
    "fundamentally",
    "true intelligence",
    "impossible",
    "universal",
    "flawless",
    "perfectly",
    "clearly",
    "obviously",
    "simply",
    "merely",
    "weaponized",
    "metaphysics",
    "ontology",
    "philosophy",
    "philosophical",
)

FORBIDDEN_REGEX = re.compile(
    r"\b(?:" + "|".join(re.escape(p) for p in FORBIDDEN_PHRASES) + r")\b",
    re.IGNORECASE,
)


class TripartiteCorrespondenceAuditTests(unittest.TestCase):
    def setUp(self) -> None:
        self.assertTrue(JSON_PATH.is_file(), f"Missing JSON audit artifact at {JSON_PATH}")
        self.assertTrue(MD_PATH.is_file(), f"Missing Markdown audit artifact at {MD_PATH}")
        self.audit = json.loads(JSON_PATH.read_text(encoding="utf-8"))
        self.dag = json.loads(DAG_PATH.read_text(encoding="utf-8"))
        self.md_text = MD_PATH.read_text(encoding="utf-8")

    def test_schema_and_summary_totals(self) -> None:
        self.assertEqual(self.audit["schema_version"], "1.0.0")
        summary = self.audit["summary"]
        self.assertEqual(summary["total_nodes"], 97)
        self.assertEqual(summary["perfected_count"], 71)
        self.assertEqual(summary["conditionally_perfected_count"], 3)
        self.assertEqual(summary["non_perfected_count"], 23)
        self.assertEqual(summary["bucket_counts"], {"DERIVED": 75, "OWED": 12, "IMAGINED": 10})
        self.assertEqual(summary["lean_formalized_total_theorems"], 1240)
        self.assertEqual(summary["lean_formalized_total_modules"], 54)
        self.assertEqual(summary["python_unique_check_scripts"], 14)

    def test_node_set_parity_with_dag(self) -> None:
        dag_ids = {n["id"] for n in self.dag["nodes"]}
        audit_ids = {n["id"] for n in self.audit["nodes"]}
        self.assertEqual(audit_ids, dag_ids)

        perfected = set(self.audit["perfected_nodes"])
        cond_perfected = set(self.audit["conditionally_perfected_nodes"])
        non_perfected = set(self.audit["non_perfected_nodes"])

        self.assertEqual(len(perfected), 71)
        self.assertEqual(len(cond_perfected), 3)
        self.assertEqual(len(non_perfected), 23)
        self.assertEqual(perfected | cond_perfected | non_perfected, dag_ids)
        self.assertTrue(perfected.isdisjoint(cond_perfected))
        self.assertTrue(perfected.isdisjoint(non_perfected))
        self.assertTrue(cond_perfected.isdisjoint(non_perfected))

    def test_conditional_nodes_exact_enumeration(self) -> None:
        self.assertEqual(set(self.audit["conditionally_perfected_nodes"]), {"DER-12", "DER-22", "DER-23"})

    def test_non_perfected_derived_baseline(self) -> None:
        derived_non_perfected = [
            n["id"] for n in self.audit["nodes"] if n["bucket"] == "DERIVED" and n["classification"] == "NON_PERFECTED"
        ]
        self.assertEqual(derived_non_perfected, ["DER-20"])

    def test_perfected_nodes_have_all_facets_and_zero_bridge_dependencies(self) -> None:
        perfected_set = set(self.audit["perfected_nodes"])
        for node in self.audit["nodes"]:
            if node["id"] in perfected_set:
                self.assertEqual(node["classification"], "PERFECTED")
                self.assertTrue(node["is_perfected"])
                self.assertFalse(node["is_conditionally_perfected"])
                self.assertEqual(node["non_perfection_reasons"], [])

                facets = node["facets"]
                self.assertEqual(facets["lean_4"]["status"], "VERIFIED")
                self.assertGreater(facets["lean_4"]["theorems_count"], 0)
                self.assertTrue(facets["lean_4"]["receipt_verified"])
                self.assertTrue(facets["lean_4"]["zero_sorry"])
                self.assertTrue(facets["lean_4"]["zero_classical_choice"])

                self.assertEqual(facets["mechanization"]["status"], "VERIFIED")
                self.assertGreater(facets["mechanization"]["scripts_count"], 0)
                self.assertTrue(facets["mechanization"]["all_scripts_exist"])

                self.assertEqual(facets["prose"]["status"], "DOCUMENTED")
                self.assertGreater(facets["prose"]["doc_files_count"], 0)
                self.assertTrue(facets["prose"]["all_docs_exist"])

                bridge_deps = node["admissions_and_bridges"]["open_bridge_dependencies"]
                self.assertEqual(bridge_deps, [])

    def test_claim_hygiene_zero_forbidden_words(self) -> None:
        json_raw = JSON_PATH.read_text(encoding="utf-8")
        match_json = FORBIDDEN_REGEX.search(json_raw)
        self.assertIsNone(
            match_json,
            f"Forbidden term {getattr(match_json, 'group', lambda: None)()} found in {JSON_PATH}",
        )

        match_md = FORBIDDEN_REGEX.search(self.md_text)
        self.assertIsNone(
            match_md,
            f"Forbidden term {getattr(match_md, 'group', lambda: None)()} found in {MD_PATH}",
        )


if __name__ == "__main__":
    unittest.main()
