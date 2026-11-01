"""Adversarial checks of custody and prompt/answer association."""
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("genesis_verifier", ROOT / "scripts" / "verify_genesis_record.py")
verifier = importlib.util.module_from_spec(spec)
spec.loader.exec_module(verifier)


def regenerate_hashes(root):
    archive = root / "evidence" / "seed_audit_2026-11-01"
    for directory in (archive / "run", archive):
        manifest = directory / "SHA256SUMS"
        lines = []
        for line in manifest.read_text(encoding="utf-8").splitlines():
            _, relative = line.split("  ", 1)
            digest = hashlib.sha256((directory / relative).read_bytes()).hexdigest()
            lines.append(f"{digest}  {relative}")
        manifest.write_text("\n".join(lines)+"\n", encoding="utf-8")
    inventory_path = root / "migration_inventory.json"
    inventory = json.loads(inventory_path.read_text(encoding="utf-8"))
    for entry in inventory["files"]:
        data = (root / entry["path"]).read_bytes()
        entry.update(bytes=len(data), sha256=hashlib.sha256(data).hexdigest())
    inventory_path.write_text(json.dumps(inventory, indent=2)+"\n", encoding="utf-8")


class VerificationTests(unittest.TestCase):
    def copied_record(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        root = Path(temporary.name)
        shutil.copytree(ROOT / "evidence", root / "evidence")
        shutil.copyfile(ROOT / "migration_inventory.json", root / "migration_inventory.json")
        return root

    def test_current_record(self):
        result = verifier.verify()
        self.assertTrue(result["verified"])
        self.assertEqual(result["anchored_files"], 76)

    def test_changed_evidence_rejected(self):
        root = self.copied_record()
        path = root / "evidence/seed_audit_2026-11-01/run/answers.md"
        path.write_bytes(path.read_bytes()+b"altered")
        with self.assertRaisesRegex(RuntimeError, "Inventory mismatch"):
            verifier.verify(root)

    def test_swapped_answers_rejected_even_with_regenerated_hashes(self):
        root = self.copied_record()
        run = root / "evidence/seed_audit_2026-11-01/run"
        first = json.loads((run / "calls/01_round1_chat1.response.json").read_bytes())["choices"][0]["message"]["content"]
        second = json.loads((run / "calls/02_round1_chat2.response.json").read_bytes())["choices"][0]["message"]["content"]
        path = run / "answers.md"
        report = path.read_text(encoding="utf-8")
        self.assertEqual(report.count(first), 1)
        self.assertEqual(report.count(second), 1)
        report = report.replace(first, "SWAP_ANSWER_PLACEHOLDER").replace(second, first).replace("SWAP_ANSWER_PLACEHOLDER", second)
        path.write_text(report, encoding="utf-8")
        regenerate_hashes(root)
        with self.assertRaisesRegex(RuntimeError, "Report mismatch"):
            verifier.verify(root)

    def test_rehashed_archive_rejected_by_publication_anchor(self):
        root = self.copied_record()
        path = root / "evidence/seed_audit_2026-11-01/audit.md"
        path.write_bytes(path.read_bytes()+b"\nChanged assessment.\n")
        regenerate_hashes(root)
        with self.assertRaisesRegex(RuntimeError, "First-publication inventory anchor mismatch"):
            verifier.verify(root)

    def test_archive_reconstructs_from_first_publication(self):
        inventory = json.loads(subprocess.check_output(
            ["git", "show", f"{verifier.ANCHOR_COMMIT}:migration_inventory.json"], cwd=ROOT))
        archived = subprocess.check_output(
            ["git", "ls-tree", "-r", "--name-only", verifier.ANCHOR_COMMIT, "--", "evidence/seed_audit_2026-11-01"],
            cwd=ROOT).decode("utf-8").splitlines()
        self.assertEqual(set(archived), {entry["path"] for entry in inventory["files"]})
        for entry in inventory["files"]:
            with self.subTest(path=entry["path"]):
                data = subprocess.check_output(
                    ["git", "show", f"{verifier.ANCHOR_COMMIT}:{entry['path']}"], cwd=ROOT)
                self.assertEqual(hashlib.sha256(data).hexdigest(), entry["sha256"])
                self.assertEqual(data, (ROOT / entry["path"]).read_bytes())


if __name__ == "__main__":
    unittest.main()
