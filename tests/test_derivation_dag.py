"""Unit and negative-mutation tests for dag/derivation_dag.json and scripts/validate_derivation_dag.py."""
from __future__ import annotations

import copy
import importlib.util
import json
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("dag_validator", ROOT / "scripts/validate_derivation_dag.py")
validator = importlib.util.module_from_spec(spec)
spec.loader.exec_module(validator)


class DerivationDagTests(unittest.TestCase):
    def setUp(self) -> None:
        self.dag_path = ROOT / "dag/derivation_dag.json"
        self.data = json.loads(self.dag_path.read_text(encoding="utf-8"))

    def test_canonical_dag_validates(self) -> None:
        summary = validator.validate_dag_data(self.data, root=ROOT)
        self.assertTrue(summary["valid"])
        self.assertEqual(summary["total_nodes"], 46)
        self.assertEqual(summary["total_edges"], 104)
        self.assertEqual(summary["requires_admission_edges"], 51)
        self.assertEqual(summary["bucket_counts"], {"DERIVED": 24, "OWED": 12, "IMAGINED": 10})
        self.assertEqual(summary["lean_modules_verified"], 9)
        self.assertEqual(summary["total_lean_theorems"], 350)

    def test_claim_hygiene_violations_fail_closed(self) -> None:
        for bad_word in ("proves", "guarantees", "impossible", "universal", "obviously", "metaphysics", "ontology"):
            with self.subTest(bad_word=bad_word):
                mutated = copy.deepcopy(self.data)
                mutated["nodes"][0]["statement"] = f"This node {bad_word} the result."
                with self.assertRaisesRegex(ValueError, "Claim Hygiene forbidden term"):
                    validator.validate_dag_data(mutated, root=ROOT)

    def test_missing_theorem_in_receipt_fails_closed(self) -> None:
        mutated = copy.deepcopy(self.data)
        for node in mutated["nodes"]:
            if node["id"] == "DER-01":
                node["artifacts"]["lean_theorems"].append("nonexistent_theorem_xyz")
                break
        with self.assertRaisesRegex(ValueError, "not found in"):
            validator.validate_dag_data(mutated, root=ROOT)

    def test_unreferenced_theorem_in_module_fails_closed(self) -> None:
        mutated = copy.deepcopy(self.data)
        for node in mutated["nodes"]:
            if node["id"] == "DER-01":
                node["artifacts"]["lean_theorems"] = node["artifacts"]["lean_theorems"][1:]
                break
        with self.assertRaisesRegex(ValueError, "unreferenced theorem"):
            validator.validate_dag_data(mutated, root=ROOT)

    def test_missing_research_map_ref_fails_closed(self) -> None:
        mutated = copy.deepcopy(self.data)
        for node in mutated["nodes"]:
            node["research_map_refs"] = [r for r in node["research_map_refs"] if r != "N21"]
            if not node["research_map_refs"]:
                node["research_map_refs"] = ["N22"]
        with self.assertRaisesRegex(ValueError, "missing required research_map/OQ/RT references"):
            validator.validate_dag_data(mutated, root=ROOT)

    def test_missing_artifact_files_fail_closed(self) -> None:
        for field, bad_val in (
            ("lean_file", "lean/NonExistent.lean"),
            ("python_checks", ["scripts/nonexistent_check.py"]),
            ("doc_refs", ["docs/nonexistent_doc.md"]),
        ):
            with self.subTest(field=field):
                mutated = copy.deepcopy(self.data)
                for node in mutated["nodes"]:
                    if node["id"] == "DER-01":
                        node["artifacts"][field] = bad_val
                        break
                with self.assertRaisesRegex(ValueError, "references missing"):
                    validator.validate_dag_data(mutated, root=ROOT)

    def test_wrong_existing_lean_file_fails_closed(self) -> None:
        """Codex reproducer #1: changing DER-01 lean_file to another existing Lean file must fail closed."""
        mutated = copy.deepcopy(self.data)
        for node in mutated["nodes"]:
            if node["id"] == "DER-01":
                node["artifacts"]["lean_file"] = "lean/InternalMetatheory.lean"
                break
        with self.assertRaisesRegex(ValueError, "Lean source/receipt binding mismatch"):
            validator.validate_dag_data(mutated, root=ROOT)

    def test_wrong_lean_module_fails_closed(self) -> None:
        mutated = copy.deepcopy(self.data)
        for node in mutated["nodes"]:
            if node["id"] == "DER-01":
                node["artifacts"]["lean_module"] = "InternalMetatheory"
                break
        with self.assertRaisesRegex(ValueError, "lean_module 'InternalMetatheory' does not match 'PrimitiveDifference'"):
            validator.validate_dag_data(mutated, root=ROOT)

    def test_missing_lean_module_fails_closed(self) -> None:
        mutated = copy.deepcopy(self.data)
        for node in mutated["nodes"]:
            if node["id"] == "DER-01":
                node["artifacts"].pop("lean_module", None)
                break
        with self.assertRaisesRegex(ValueError, "lean_module None does not match 'PrimitiveDifference'"):
            validator.validate_dag_data(mutated, root=ROOT)

    def test_derived_without_s0_host_admission_fails_closed(self) -> None:
        mutated = copy.deepcopy(self.data)
        for node in mutated["nodes"]:
            if node["id"] == "DER-01":
                node["unpriced_inputs_or_admissions"] = ["S1_off_diagonal_pair_witness"]
                break
        with self.assertRaisesRegex(ValueError, "DERIVED node DER-01 must declare 'S0_lean_core_host'"):
            validator.validate_dag_data(mutated, root=ROOT)

    def test_derived_conditionally_without_bridge_provider_fails_closed(self) -> None:
        mutated = copy.deepcopy(self.data)
        for node in mutated["nodes"]:
            if node["id"] == "DER-12":
                node["unpriced_inputs_or_admissions"] = [
                    "S0_lean_core_host",
                    "S4_retention_state_bit",
                    "S5_additive_cost_target",
                ]
                break
        mutated["edges"] = [
            e
            for e in mutated["edges"]
            if not (e["from"] == "OWE-12" and e["to"] == "DER-12" and e["kind"] == "requires_admission")
        ]
        with self.assertRaisesRegex(ValueError, "DERIVED_CONDITIONALLY node DER-12 must depend on at least one OWED OPEN_PROOF_OBLIGATION"):
            validator.validate_dag_data(mutated, root=ROOT)

    def test_removing_all_requires_admission_edges_fails_closed(self) -> None:
        """Codex reproducer #2: removing all requires_admission edges must fail closed."""
        mutated = copy.deepcopy(self.data)
        mutated["edges"] = [e for e in mutated["edges"] if e["kind"] != "requires_admission"]
        with self.assertRaisesRegex(ValueError, "missing required 'requires_admission' edge"):
            validator.validate_dag_data(mutated, root=ROOT)

    def test_removing_single_requires_admission_edge_with_compensating_edge_fails_closed(self) -> None:
        """Removing one required admission edge must fail even if an unrelated edge preserves total edge count."""
        mutated = copy.deepcopy(self.data)
        mutated["edges"] = [
            e
            for e in mutated["edges"]
            if not (e["from"] == "OWE-01" and e["to"] == "DER-01" and e["kind"] == "requires_admission")
        ]
        mutated["edges"].append({
            "from": "DER-01",
            "to": "DER-05",
            "kind": "derives",
            "note": "Unrelated compensating edge preserving total edge count.",
        })
        self.assertEqual(len(mutated["edges"]), len(self.data["edges"]))
        with self.assertRaisesRegex(ValueError, "missing required 'requires_admission' edge"):
            validator.validate_dag_data(mutated, root=ROOT)

    def test_unresolved_admission_identifier_fails_closed(self) -> None:
        mutated = copy.deepcopy(self.data)
        for node in mutated["nodes"]:
            if node["id"] == "DER-01":
                node["unpriced_inputs_or_admissions"].append("unknown_admission_xyz")
                break
        with self.assertRaisesRegex(ValueError, "unresolved admission identifier"):
            validator.validate_dag_data(mutated, root=ROOT)

    def test_derived_node_without_executable_artifacts_fails_closed(self) -> None:
        mutated = copy.deepcopy(self.data)
        for node in mutated["nodes"]:
            if node["id"] == "DER-01":
                node["artifacts"] = {"doc_refs": ["docs/research_map.md"]}
                break
        with self.assertRaisesRegex(ValueError, "DERIVED node DER-01 must bind to"):
            validator.validate_dag_data(mutated, root=ROOT)

    def test_bucket_count_mismatch_fails_closed(self) -> None:
        mutated = copy.deepcopy(self.data)
        mutated["buckets"]["DERIVED"]["count"] = 999
        with self.assertRaisesRegex(ValueError, "Bucket count mismatch"):
            validator.validate_dag_data(mutated, root=ROOT)

    def test_cycle_detection_fails_closed(self) -> None:
        mutated = copy.deepcopy(self.data)
        mutated["edges"].append({
            "from": "DER-02",
            "to": "DER-01",
            "kind": "derives",
            "note": "Artificial reverse edge creating a cycle.",
        })
        with self.assertRaisesRegex(ValueError, "Cycle detected"):
            validator.validate_dag_data(mutated, root=ROOT)

    def test_self_loop_and_duplicate_edge_fail_closed(self) -> None:
        loop_mut = copy.deepcopy(self.data)
        loop_mut["edges"].append({
            "from": "DER-01",
            "to": "DER-01",
            "kind": "derives",
            "note": "Self loop.",
        })
        with self.assertRaisesRegex(ValueError, "Self-loop"):
            validator.validate_dag_data(loop_mut, root=ROOT)

        dup_mut = copy.deepcopy(self.data)
        dup_mut["edges"].append(copy.deepcopy(dup_mut["edges"][0]))
        with self.assertRaisesRegex(ValueError, "Duplicate edge"):
            validator.validate_dag_data(dup_mut, root=ROOT)

    def test_epistemic_ordering_violations_fail_closed(self) -> None:
        imagined_to_derived = copy.deepcopy(self.data)
        imagined_to_derived["edges"].append({
            "from": "IMG-01",
            "to": "DER-13",
            "kind": "extends_to",
            "note": "Invalid dependency of derived node on imagined node.",
        })
        with self.assertRaisesRegex(ValueError, "Epistemic ordering violation"):
            validator.validate_dag_data(imagined_to_derived, root=ROOT)

        imagined_to_owed = copy.deepcopy(self.data)
        imagined_to_owed["edges"].append({
            "from": "IMG-01",
            "to": "OWE-09",
            "kind": "motivates_bridge",
            "note": "Invalid dependency of owed node on imagined node.",
        })
        with self.assertRaisesRegex(ValueError, "Epistemic ordering violation"):
            validator.validate_dag_data(imagined_to_owed, root=ROOT)

        owed_wrong_kind = copy.deepcopy(self.data)
        for edge in owed_wrong_kind["edges"]:
            if edge["from"] == "OWE-01" and edge["to"] == "DER-01":
                edge["kind"] = "derives"
                break
        with self.assertRaisesRegex(ValueError, "must have kind 'requires_admission'"):
            validator.validate_dag_data(owed_wrong_kind, root=ROOT)


if __name__ == "__main__":
    unittest.main()
