#!/usr/bin/env python3
"""Validate dag/derivation_dag.json against repository artifacts, receipts, and Claim Hygiene rules."""
from __future__ import annotations

import argparse
from collections import deque
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_DAG_PATH = ROOT / "dag/derivation_dag.json"

ALLOWED_BUCKETS = {"DERIVED", "OWED", "IMAGINED"}
ALLOWED_EDGE_KINDS = {"derives", "requires_admission", "motivates_bridge", "extends_to"}
FORBIDDEN_AXIOMS = {"Classical.choice", "sorryAx"}

FORBIDDEN_PHRASES = (
    "proves",
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


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def check_claim_hygiene_text(text: str, context: str) -> None:
    match = FORBIDDEN_REGEX.search(text)
    if match:
        raise ValueError(f"Claim Hygiene forbidden term {match.group(0)!r} in {context}: {text!r}")


def validate_dag_data(
    data: dict[str, Any],
    root: Path = ROOT,
    *,
    run_checks: bool = False,
) -> dict[str, Any]:
    required_top = {
        "schema_version",
        "title",
        "description",
        "claim_hygiene_scope",
        "buckets",
        "lean_inventory",
        "nodes",
        "edges",
    }
    missing_top = required_top - set(data.keys())
    if missing_top:
        raise ValueError(f"Missing top-level keys in derivation_dag.json: {sorted(missing_top)}")

    check_claim_hygiene_text(str(data["title"]), "title")
    check_claim_hygiene_text(str(data["description"]), "description")

    scope = data["claim_hygiene_scope"]
    for key in ("supports", "does_not_support", "narrowest_defensible_claim", "next_test_needed"):
        if key not in scope or not isinstance(scope[key], str) or not scope[key].strip():
            raise ValueError(f"claim_hygiene_scope missing non-empty {key!r}")
        check_claim_hygiene_text(scope[key], f"claim_hygiene_scope.{key}")

    # Validate Lean inventory and cache receipt theorem maps
    receipt_theorems_by_path: dict[str, set[str]] = {}
    referenced_theorems_by_path: dict[str, set[str]] = {}
    total_lean_theorems = 0
    seen_modules: set[str] = set()
    for entry in data["lean_inventory"]:
        mod = entry.get("module")
        src_rel = entry.get("source")
        rec_rel = entry.get("receipt")
        expected_count = entry.get("theorems_checked")
        if not mod or mod in seen_modules:
            raise ValueError(f"Duplicate or empty Lean module in lean_inventory: {mod!r}")
        seen_modules.add(mod)
        src_path = root / src_rel
        rec_path = root / rec_rel
        if not src_path.is_file():
            raise ValueError(f"Missing Lean source file for {mod}: {src_rel}")
        if not rec_path.is_file():
            raise ValueError(f"Missing Lean receipt file for {mod}: {rec_rel}")
        receipt = json.loads(rec_path.read_text(encoding="utf-8"))
        if not receipt.get("verified"):
            raise ValueError(f"Receipt not marked verified for {mod}: {rec_rel}")
        if receipt.get("source") != src_rel:
            raise ValueError(f"Receipt source mismatch for {mod}: {receipt.get('source')} != {src_rel}")
        actual_sha = sha256_file(src_path)
        if receipt.get("source_sha256") != actual_sha:
            raise ValueError(f"Receipt SHA-256 mismatch for {src_rel}")
        direct_imports = receipt.get("direct_imports", {})
        if not isinstance(direct_imports, dict):
            raise ValueError(f"Receipt direct_imports must be an object for {mod}")
        for imp_rel, imp_sha in direct_imports.items():
            imp_path = root / imp_rel
            if not imp_path.is_file():
                raise ValueError(f"Receipt {rec_rel} references missing direct_import: {imp_rel}")
            if sha256_file(imp_path) != imp_sha:
                raise ValueError(f"Receipt {rec_rel} direct_import SHA-256 mismatch for {imp_rel}")
        allowed_axioms = set(receipt.get("allowed_axioms", []))
        if allowed_axioms & FORBIDDEN_AXIOMS:
            raise ValueError(f"Receipt {rec_rel} allows forbidden axioms: {sorted(allowed_axioms & FORBIDDEN_AXIOMS)}")
        deps = receipt.get("dependencies", {})
        if len(deps) != expected_count or receipt.get("theorems_checked") != expected_count:
            raise ValueError(
                f"Theorem count mismatch for {mod}: inventory={expected_count}, receipt={len(deps)}"
            )
        for thm_name, thm_axioms in deps.items():
            ax_set = set(thm_axioms)
            if ax_set & FORBIDDEN_AXIOMS:
                raise ValueError(f"Theorem {mod}.{thm_name} uses forbidden axiom: {sorted(ax_set & FORBIDDEN_AXIOMS)}")
            if not ax_set.issubset(allowed_axioms):
                raise ValueError(
                    f"Theorem {mod}.{thm_name} uses axioms {sorted(ax_set - allowed_axioms)} outside allowed_axioms"
                )
        receipt_theorems_by_path[rec_rel] = set(deps.keys())
        referenced_theorems_by_path[rec_rel] = set()
        total_lean_theorems += expected_count

    # Validate buckets declaration
    buckets_decl = data["buckets"]
    if set(buckets_decl.keys()) != ALLOWED_BUCKETS:
        raise ValueError(f"buckets keys must be {sorted(ALLOWED_BUCKETS)}, got {sorted(buckets_decl.keys())}")

    # Validate nodes
    nodes = data["nodes"]
    if not isinstance(nodes, list) or not nodes:
        raise ValueError("nodes must be a non-empty list")

    node_by_id: dict[str, dict[str, Any]] = {}
    seen_codes: set[str] = set()
    bucket_counts = {b: 0 for b in ALLOWED_BUCKETS}
    all_python_checks: list[str] = []
    seen_python_checks: set[str] = set()
    all_ref_tokens: set[str] = set()

    for node in nodes:
        nid = node.get("id")
        code = node.get("code")
        bucket = node.get("bucket")
        title = node.get("title", "")
        statement = node.get("statement", "")
        if not nid or not isinstance(nid, str):
            raise ValueError(f"Node has invalid id: {node!r}")
        if nid in node_by_id:
            raise ValueError(f"Duplicate node id: {nid}")
        if not code or code in seen_codes:
            raise ValueError(f"Duplicate or empty node code: {code!r}")
        if bucket not in ALLOWED_BUCKETS:
            raise ValueError(f"Node {nid} has invalid bucket {bucket!r}")
        if not title.strip() or not statement.strip():
            raise ValueError(f"Node {nid} has empty title or statement")

        check_claim_hygiene_text(title, f"node[{nid}].title")
        check_claim_hygiene_text(statement, f"node[{nid}].statement")

        rm_refs = node.get("research_map_refs")
        if not rm_refs or not isinstance(rm_refs, list):
            raise ValueError(f"Node {nid} must declare non-empty research_map_refs")
        for ref in rm_refs:
            all_ref_tokens.add(str(ref))
            for tok in re.findall(r"(?:N\d{2}|OQ-\d{2}|RT-\d{2})", str(ref)):
                all_ref_tokens.add(tok)

        if not node.get("unpriced_inputs_or_admissions"):
            raise ValueError(f"Node {nid} must declare non-empty unpriced_inputs_or_admissions")

        artifacts = node.get("artifacts", {})
        if not isinstance(artifacts, dict):
            raise ValueError(f"Node {nid} artifacts must be an object")

        lean_file = artifacts.get("lean_file")
        lean_theorems = artifacts.get("lean_theorems", [])
        receipt_json = artifacts.get("receipt_json")
        python_checks = artifacts.get("python_checks", [])
        doc_refs = artifacts.get("doc_refs", [])

        if lean_file:
            if not (root / lean_file).is_file():
                raise ValueError(f"Node {nid} references missing lean_file: {lean_file}")
            if not receipt_json:
                raise ValueError(f"Node {nid} specifies lean_file without receipt_json")
            if receipt_json not in receipt_theorems_by_path:
                rec_path = root / receipt_json
                if not rec_path.is_file():
                    raise ValueError(f"Node {nid} references missing receipt_json: {receipt_json}")
                rec_data = json.loads(rec_path.read_text(encoding="utf-8"))
                receipt_theorems_by_path[receipt_json] = set(rec_data.get("dependencies", {}).keys())
                referenced_theorems_by_path.setdefault(receipt_json, set())
            known_theorems = receipt_theorems_by_path[receipt_json]
            if not lean_theorems:
                raise ValueError(f"Node {nid} specifies lean_file without lean_theorems")
            for thm in lean_theorems:
                if thm not in known_theorems:
                    raise ValueError(
                        f"Node {nid} references theorem {thm!r} not found in {receipt_json}"
                    )
                referenced_theorems_by_path[receipt_json].add(thm)

        for py_rel in python_checks:
            if not (root / py_rel).is_file():
                raise ValueError(f"Node {nid} references missing python_check: {py_rel}")
            if py_rel not in seen_python_checks:
                seen_python_checks.add(py_rel)
                all_python_checks.append(py_rel)

        for doc_rel in doc_refs:
            if not (root / doc_rel).is_file():
                raise ValueError(f"Node {nid} references missing doc_ref: {doc_rel}")

        if bucket == "DERIVED":
            has_lean = bool(lean_file and lean_theorems and receipt_json)
            has_py = bool(python_checks)
            if not (has_lean or has_py):
                raise ValueError(
                    f"DERIVED node {nid} must bind to verified Lean theorems or Python check scripts"
                )

        node_by_id[nid] = node
        seen_codes.add(code)
        bucket_counts[bucket] += 1

    # Surjective theorem coverage across all receipts in lean_inventory
    for entry in data["lean_inventory"]:
        rec_rel = entry["receipt"]
        mod = entry["module"]
        unref = sorted(receipt_theorems_by_path[rec_rel] - referenced_theorems_by_path.get(rec_rel, set()))
        if unref:
            raise ValueError(
                f"Module {mod} ({rec_rel}) has {len(unref)} unreferenced theorem(s) in DAG: {unref}"
            )

    # Surjective coverage of N00-N33, OQ-01-OQ-08, RT-01-RT-12
    expected_n = {f"N{i:02d}" for i in range(34)}
    expected_oq = {f"OQ-{i:02d}" for i in range(1, 9)}
    expected_rt = {f"RT-{i:02d}" for i in range(1, 13)}
    missing_refs = sorted((expected_n | expected_oq | expected_rt) - all_ref_tokens)
    if missing_refs:
        raise ValueError(f"DAG nodes are missing required research_map/OQ/RT references: {missing_refs}")

    for bucket, count in bucket_counts.items():
        declared = buckets_decl[bucket].get("count")
        if declared != count:
            raise ValueError(
                f"Bucket count mismatch for {bucket}: declared={declared}, actual={count}"
            )

    # Validate edges and acyclicity
    edges = data["edges"]
    if not isinstance(edges, list) or not edges:
        raise ValueError("edges must be a non-empty list")

    adj: dict[str, list[str]] = {nid: [] for nid in node_by_id}
    indegree: dict[str, int] = {nid: 0 for nid in node_by_id}
    seen_edges: set[tuple[str, str]] = set()

    for idx, edge in enumerate(edges):
        src = edge.get("from")
        dst = edge.get("to")
        kind = edge.get("kind")
        note = edge.get("note", "")
        if src not in node_by_id:
            raise ValueError(f"Edge #{idx} has unknown source node {src!r}")
        if dst not in node_by_id:
            raise ValueError(f"Edge #{idx} has unknown target node {dst!r}")
        if src == dst:
            raise ValueError(f"Self-loop on node {src!r} is forbidden")
        if (src, dst) in seen_edges:
            raise ValueError(f"Duplicate edge ({src!r}, {dst!r})")
        if kind not in ALLOWED_EDGE_KINDS:
            raise ValueError(f"Edge ({src!r} -> {dst!r}) has invalid kind {kind!r}")
        if not note.strip():
            raise ValueError(f"Edge ({src!r} -> {dst!r}) must have a non-empty note")
        check_claim_hygiene_text(note, f"edge[{src}->{dst}].note")

        src_bucket = node_by_id[src]["bucket"]
        dst_bucket = node_by_id[dst]["bucket"]
        if src_bucket == "IMAGINED" and dst_bucket in {"DERIVED", "OWED"}:
            raise ValueError(
                f"Epistemic ordering violation: {dst_bucket} node {dst} cannot depend on IMAGINED node {src}"
            )
        if dst_bucket == "DERIVED" and src_bucket == "OWED" and kind != "requires_admission":
            raise ValueError(
                f"Edge from OWED node {src} to DERIVED node {dst} must have kind 'requires_admission'"
            )

        seen_edges.add((src, dst))
        adj[src].append(dst)
        indegree[dst] += 1

    queue = deque([nid for nid, deg in indegree.items() if deg == 0])
    visited_order: list[str] = []
    while queue:
        curr = queue.popleft()
        visited_order.append(curr)
        for nxt in adj[curr]:
            indegree[nxt] -= 1
            if indegree[nxt] == 0:
                queue.append(nxt)

    if len(visited_order) != len(node_by_id):
        cycle_nodes = sorted(set(node_by_id.keys()) - set(visited_order))
        raise ValueError(f"Cycle detected in derivation DAG involving nodes: {cycle_nodes}")

    if run_checks:
        for py_rel in all_python_checks:
            proc = subprocess.run(
                [sys.executable, str(root / py_rel)],
                cwd=root,
                capture_output=True,
                text=True,
                check=False,
            )
            if proc.returncode != 0:
                raise ValueError(
                    f"Python check script {py_rel} failed with exit code {proc.returncode}:\n"
                    f"{proc.stdout}\n{proc.stderr}"
                )

    return {
        "valid": True,
        "schema_version": data["schema_version"],
        "total_nodes": len(node_by_id),
        "bucket_counts": bucket_counts,
        "total_edges": len(edges),
        "lean_modules_verified": len(data["lean_inventory"]),
        "total_lean_theorems": total_lean_theorems,
        "python_checks_executed": len(all_python_checks) if run_checks else 0,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--dag",
        type=Path,
        default=DEFAULT_DAG_PATH,
        help="Path to derivation_dag.json",
    )
    parser.add_argument(
        "--run-checks",
        action="store_true",
        help="Execute all referenced Python check scripts and verify exit code 0",
    )
    args = parser.parse_args()
    dag_path = args.dag if args.dag.is_absolute() else (ROOT / args.dag)
    data = json.loads(dag_path.read_text(encoding="utf-8"))
    summary = validate_dag_data(data, root=ROOT, run_checks=args.run_checks)
    print(json.dumps(summary, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
