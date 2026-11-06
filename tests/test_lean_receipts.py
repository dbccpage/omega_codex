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
        target_decl_der25 = (
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
        target_decl_der26 = (
            "/-- Any memory carrier with `mCard < 2 ^ k` states fails to injectively separate\n"
            "    all `2 ^ k` binary histories of length `k`. -/\n"
            "theorem multi_round_memory_collision_of_lt_pow2 (k mCard : Nat) (encode : Nat → Nat)\n"
            "    (hbound : ∀ h < 2 ^ k, encode h < mCard)\n"
            "    (hlt : mCard < 2 ^ k) :\n"
            "    ¬ (∀ h1 < 2 ^ k, ∀ h2 < 2 ^ k, encode h1 = encode h2 → h1 = h2) := by\n"
            "  intro hinj\n"
            "  have hle := multi_round_memory_capacity_lower_bound k mCard encode hbound hinj\n"
            "  omega\n"
        )
        self.assertIn(target_decl_der25, original)
        self.assertIn(target_decl_der26, original)
        variants = {
            "remove_der25": original.replace(target_decl_der25, "", 1),
            "weaken_der25_with_omega": original.replace(
                target_decl_der25,
                "theorem n3_minimal_single_stick_reflection_witness : (0 : Nat) < 1 := by omega\n",
                1,
            ),
            "remove_der26": original.replace(target_decl_der26, "", 1),
            "weaken_der26_to_true": original.replace(
                target_decl_der26,
                "theorem multi_round_memory_collision_of_lt_pow2 : True := True.intro\n",
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
                    self.assertEqual(
                        actual["theorems_checked"],
                        83 if label.startswith("remove") else 84,
                    )
                    if label == "weaken_der26_to_true":
                        self.assertEqual(
                            actual["dependencies"]["multi_round_memory_collision_of_lt_pow2"],
                            [],
                        )
                    with self.assertRaises(RuntimeError):
                        checker.verify_receipt(actual, expected, "ProfilePreorderAndGenerator")

    def test_local_global_der27_theorem_removal_and_weakening_are_rejected(self):
        expected = json.loads(
            (ROOT / checker.RECEIPTS["LocalGlobalObstruction"]).read_text(encoding="utf-8")
        )
        original = (ROOT / "lean/LocalGlobalObstruction.lean").read_text(encoding="utf-8")
        target_decl = (
            "/-- General transitive uniformity theorem: if `σ` acts transitively on `{0, ..., n - 1}`\n"
            "    from `0` and leaves `weightedL1Gen w` invariant on unit cochains, then all `n` edge\n"
            "    weights equal `w 0` and `weightedL1Gen w v n = w 0 * unweightedL1Gen v n` for every cochain `v`. -/\n"
            "theorem transitive_action_forces_uniform_weights_general (w : Nat → Nat) (σ : Nat → Nat) (n : Nat)\n"
            "    (hpos : 1 ≤ n)\n"
            "    (hclosed : ∀ e < n, σ e < n)\n"
            "    (hinv : ∀ e < n, weightedL1Gen w (unitCochain (σ e)) n = weightedL1Gen w (unitCochain e) n)\n"
            "    (htrans : ∀ e < n, ∃ k : Nat, iterEdge σ k 0 = e) :\n"
            "    (∀ e < n, w e = w 0) ∧\n"
            "    (∀ v : Nat → Int, weightedL1Gen w v n = w 0 * unweightedL1Gen v n) := by\n"
            "  have horb := symmetry_forces_orbit_equal_weights_general w σ n hclosed hinv\n"
            "  have hunif : ∀ e < n, w e = w 0 := by\n"
            "    intro e he\n"
            "    rcases htrans e he with ⟨k, hk⟩\n"
            "    have hk0 := (horb k 0 hpos).2\n"
            "    rw [← hk]\n"
            "    exact hk0\n"
            "  exact ⟨hunif, fun v => uniform_weights_factor_l1_general w v n (w 0) hunif⟩\n"
        )
        target_der30 = (
            "/-- Exactness of the unsigned `𝔽₂` triangle cochain complex (`ker d₁ = im d₀` on `Δ²`),\n"
            "    with canonical basepoint-0 primitive `primTriangleF2`. -/\n"
            "theorem triangle_f2_exact_iff (h : Cochain1F2) :\n"
            "    (d1UnsignedF2 h = false ↔ d0UnsignedF2 (primTriangleF2 h) = h) ∧\n"
            "    (d1UnsignedF2 h = false ↔ ∃ c : Cochain0F2, d0UnsignedF2 c = h) := by\n"
            "  have h1 : d1UnsignedF2 h = false ↔ d0UnsignedF2 (primTriangleF2 h) = h := by\n"
            "    cases h with\n"
            "    | mk e01 rest =>\n"
            "      cases rest with\n"
            "      | mk e12 e02 =>\n"
            "        cases e01 <;> cases e12 <;> cases e02 <;> decide\n"
            "  refine ⟨h1, ?_⟩\n"
            "  constructor\n"
            "  · intro hd1\n"
            "    exact ⟨primTriangleF2 h, h1.mp hd1⟩\n"
            "  · rintro ⟨c, rfl⟩\n"
            "    exact oq02_unsigned_f2_complex_holds c\n"
        )
        self.assertIn(target_decl, original)
        self.assertIn(target_der30, original)
        variants = {
            "remove": original.replace(target_decl, "", 1),
            "weaken": original.replace(
                target_decl,
                "theorem transitive_action_forces_uniform_weights_general : (0 : Nat) < 1 := by omega\n",
                1,
            ),
            "remove_der30": original.replace(target_der30, "", 1),
            "weaken_der30": original.replace(
                target_der30,
                "theorem triangle_f2_exact_iff : (0 : Nat) < 1 := by omega\n",
                1,
            ),
        }
        with tempfile.TemporaryDirectory(prefix="omega-lgo-mutation-") as temporary:
            root = Path(temporary)
            (root / "lean").mkdir()
            for name in ("lean-toolchain", "lakefile.toml", "lake-manifest.json"):
                shutil.copyfile(ROOT / name, root / name)
            for source in (ROOT / "lean").glob("*.lean"):
                shutil.copyfile(source, root / "lean" / source.name)
            for label, source in variants.items():
                with self.subTest(label=label), patch.object(checker, "ROOT", root):
                    (root / "lean/LocalGlobalObstruction.lean").write_bytes(source.encode("utf-8"))
                    actual = checker.check("LocalGlobalObstruction")
                    self.assertEqual(
                        actual["theorems_checked"],
                        35 if label.startswith("remove") else 36,
                    )
                    if label == "weaken":
                        self.assertEqual(
                            expected["dependencies"]["transitive_action_forces_uniform_weights_general"],
                            [],
                        )
                        self.assertEqual(
                            set(actual["dependencies"]["transitive_action_forces_uniform_weights_general"]),
                            {"propext", "Quot.sound"},
                        )
                    if label == "weaken_der30":
                        self.assertEqual(
                            expected["dependencies"]["triangle_f2_exact_iff"],
                            [],
                        )
                        self.assertEqual(
                            set(actual["dependencies"]["triangle_f2_exact_iff"]),
                            {"propext", "Quot.sound"},
                        )
                    with self.assertRaises(RuntimeError):
                        checker.verify_receipt(actual, expected, "LocalGlobalObstruction")


if __name__ == "__main__":
    unittest.main()


