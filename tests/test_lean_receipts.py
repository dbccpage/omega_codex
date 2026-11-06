"""Reviewed inventory checks and real Lean mutations, isolated from the checkout."""
import copy
import importlib.util
import json
import os
from pathlib import Path
import shutil
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("lean_checker", ROOT / "scripts/check_primitive_difference.py")
checker = importlib.util.module_from_spec(spec)
spec.loader.exec_module(checker)


class ReceiptTests(unittest.TestCase):
    def setUp(self):
        self.receipt = json.loads((ROOT / checker.RECEIPTS["ZeroEquivalence"]).read_text(encoding="utf-8"))

    def test_platform_text_and_dependency_order_do_not_change_contract(self):
        linux = copy.deepcopy(self.receipt)
        linux["lean_version"] = "Lean (version 4.33.0, x86_64-unknown-linux-gnu, commit same, Release)"
        for axioms in linux["dependencies"].values():
            axioms.reverse()
        checker.verify_receipt(linux, self.receipt, "ZeroEquivalence")

    def test_all_registered_receipts_match_source_hashes_and_schema(self):
        import hashlib
        self.assertEqual(set(checker.MODULES.keys()), set(checker.RECEIPTS.keys()))
        for module in checker.MODULES:
            with self.subTest(module=module):
                rel_source = f"lean/{module}.lean"
                receipt_path = ROOT / checker.RECEIPTS[module]
                self.assertTrue(receipt_path.exists(), f"Missing receipt for {module}")
                receipt = json.loads(receipt_path.read_text(encoding="utf-8"))
                self.assertEqual(receipt["source"], rel_source)
                self.assertEqual(
                    receipt["source_sha256"],
                    hashlib.sha256((ROOT / rel_source).read_bytes()).hexdigest(),
                )
                self.assertEqual(receipt["theorems_checked"], len(receipt["dependencies"]))
                checker.verify_receipt(copy.deepcopy(receipt), receipt, module)

    def test_contract_changes_fail_closed(self):
        mutations = {
            "source": lambda r: r.update(source="lean/PrimitiveDifference.lean"),
            "hash": lambda r: r.update(source_sha256="0" * 64),
            "import": lambda r: r["direct_imports"].update({"lean/PrimitiveDifference.lean": "0" * 64}),
            "toolchain": lambda r: r.update(toolchain="leanprover/lean4:v4.34.0"),
            "version": lambda r: r.update(lean_version="Lean (version 4.34.0, Linux)"),
            "count": lambda r: r.update(theorems_checked=61),
            "name": lambda r: r["dependencies"].update({"extra_theorem": []}),
            "dependencies": lambda r: r["dependencies"].update(zeroRel_equivalence=["propext"]),
            "axiom policy": lambda r: r.update(allowed_axioms=["propext", "Quot.sound", "Classical.choice"]),
            "duplicate dependencies": lambda r: r["dependencies"].update(zeroRel_equivalence=["propext", "propext"]),
        }
        for name, mutate in mutations.items():
            with self.subTest(name=name):
                changed = copy.deepcopy(self.receipt)
                mutate(changed)
                with self.assertRaises(RuntimeError):
                    checker.verify_receipt(changed, self.receipt, "ZeroEquivalence")


@unittest.skipUnless(os.environ.get("OMEGA_TEST_LEAN_MUTATIONS") == "1",
                     "Real Lean mutation tests run in the Lean CI job")
class CompilableMutationTests(unittest.TestCase):
    def test_unused_theorem_removal_and_weakening_are_rejected(self):
        expected = json.loads((ROOT / checker.RECEIPTS["ZeroEquivalence"]).read_text(encoding="utf-8"))
        original = (ROOT / "lean/ZeroEquivalence.lean").read_text(encoding="utf-8")
        prefix = original.split("theorem static_kernel_does_not_determine_terminal", 1)[0]
        end = "end OmegaCodex.ZeroEquivalence\n"
        variants = {
            "remove": prefix + end,
            "weaken": prefix + "theorem static_kernel_does_not_determine_terminal "
                "(K : Kernel α β) (q : ResidualQuotient K) : True := True.intro\n\n" + end,
        }
        with tempfile.TemporaryDirectory(prefix="omega-receipt-mutation-") as temporary:
            root = Path(temporary)
            (root / "lean").mkdir()
            for name in ("lean-toolchain", "lakefile.toml", "lake-manifest.json"):
                shutil.copyfile(ROOT / name, root / name)
            for source in (ROOT / "lean").glob("*.lean"):
                shutil.copyfile(source, root / "lean" / source.name)
            for label, source in variants.items():
                with self.subTest(label=label), patch.object(checker, "ROOT", root):
                    (root / "lean/ZeroEquivalence.lean").write_bytes(source.encode("utf-8"))
                    actual = checker.check("ZeroEquivalence")  # The altered source really compiles.
                    self.assertEqual(actual["theorems_checked"], 61 if label == "remove" else 62)
                    with self.assertRaises(RuntimeError):
                        checker.verify_receipt(actual, expected, "ZeroEquivalence")
                    # Deliberate regeneration can accept drift, but needs mathematical review.
                    checker.verify_receipt(actual, copy.deepcopy(actual), "ZeroEquivalence")

    def test_profile_preorder_der25_theorem_removal_and_weakening_are_rejected(self):
        expected = json.loads(
            (ROOT / checker.RECEIPTS["ProfilePreorderAndGenerator"]).read_text(encoding="utf-8")
        )
        original = (ROOT / "lean/ProfilePreorderAndGenerator.lean").read_text(encoding="utf-8")
        target_decl = (
            "/-- At `n = 3`, 1-stick configurations simultaneously witness mirror collapse\n"
            "    (`hamming3 stick3Left stick3Right = 2`, `reflResidual3 stick3Left stick3Right = 0`)\n"
            "    and positive non-mirror reflection residual\n"
            "    (`hamming3 stick3Left stick3Mid = 2`, `reflResidual3 stick3Left stick3Mid = 2`),\n"
            "    establishing `n = 3` as the minimal 1-stick carrier threshold (`N19`). -/\n"
            "theorem n3_minimal_single_stick_reflection_witness :\n"
            "    hamming3 stick3Left stick3Right = 2 ∧\n"
            "    reflResidual3 stick3Left stick3Right = 0 ∧\n"
            "    hamming3 stick3Left stick3Mid = 2 ∧\n"
            "    reflResidual3 stick3Left stick3Mid = 2 := by\n"
            "  decide\n"
        )
        self.assertIn(target_decl, original)
        variants = {
            "remove": original.replace(target_decl, "", 1),
            "weaken_with_omega": original.replace(
                target_decl,
                "theorem n3_minimal_single_stick_reflection_witness : (0 : Nat) < 1 := by omega\n",
                1,
            ),
        }
        with tempfile.TemporaryDirectory(prefix="omega-profile-mutation-") as temporary:
            root = Path(temporary)
            (root / "lean").mkdir()
            for name in ("lean-toolchain", "lakefile.toml", "lake-manifest.json"):
                shutil.copyfile(ROOT / name, root / name)
            for source in (ROOT / "lean").glob("*.lean"):
                shutil.copyfile(source, root / "lean" / source.name)
            for label, source in variants.items():
                with self.subTest(label=label), patch.object(checker, "ROOT", root):
                    (root / "lean/ProfilePreorderAndGenerator.lean").write_bytes(source.encode("utf-8"))
                    actual = checker.check("ProfilePreorderAndGenerator")
                    self.assertEqual(actual["theorems_checked"], 75 if label == "remove" else 76)
                    with self.assertRaises(RuntimeError):
                        checker.verify_receipt(actual, expected, "ProfilePreorderAndGenerator")


if __name__ == "__main__":
    unittest.main()
