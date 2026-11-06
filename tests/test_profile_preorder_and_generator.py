"""Unit tests for Slice 6 independent finite models (ProfilePreorderAndGenerator)."""
import importlib.util
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "profile_preorder_and_generator_models",
    ROOT / "scripts/profile_preorder_and_generator_models.py",
)
models = importlib.util.module_from_spec(spec)
spec.loader.exec_module(models)


class ProfilePreorderAndGeneratorTests(unittest.TestCase):
    def test_profile_preorder_hierarchy_on_two_and_three_elements(self):
        res2 = models.check_profile_preorder_hierarchy(2)
        self.assertEqual(res2["total_relations"], 16)
        self.assertEqual(res2["preorder_count"], 4)
        self.assertEqual(res2["equivalence_count"], 2)
        self.assertTrue(res2["all_profile_equiv_are_equivalences"])
        self.assertTrue(res2["all_preorders_match_mutual_comp"])
        self.assertTrue(res2["all_equivalences_match_rel"])

        res3 = models.check_profile_preorder_hierarchy(3)
        self.assertEqual(res3["total_relations"], 512)
        self.assertEqual(res3["preorder_count"], 29)
        self.assertEqual(res3["equivalence_count"], 5)
        self.assertGreater(res3["non_preorder_profile_differs_count"], 0)

    def test_d2_and_bool_leq_boundary_cases(self):
        # D2 on {0, 1}: only (0, 1) holds
        d2 = ((False, True), (False, False))
        self.assertFalse(models.is_preorder(d2))
        self.assertEqual(models.mutual_comp(d2), ((False, False), (False, False)))
        self.assertEqual(models.profile_equiv(d2), ((True, False), (False, True)))

        # Directed preorder boolLeq on {0, 1}: 0 <= 0, 0 <= 1, 1 <= 1
        bool_leq = ((True, True), (False, True))
        self.assertTrue(models.is_preorder(bool_leq))
        self.assertFalse(models.is_equivalence(bool_leq))
        self.assertEqual(
            models.profile_equiv(bool_leq),
            models.mutual_comp(bool_leq),
        )
        self.assertEqual(models.mutual_comp(bool_leq), ((True, False), (False, True)))

    def test_ten_stick_reflection_and_burnside_orbits(self):
        res = models.check_ten_stick_reflection()
        self.assertEqual(res["total_configs"], 1024)
        self.assertEqual(res["palindromes"], 32)
        self.assertEqual(res["non_palindromic_mirror_configs"], 992)
        self.assertEqual(res["reflection_orbits"], 528)
        self.assertEqual(res["stick_left_right_raw"], 2)
        self.assertEqual(res["stick_left_right_residual"], 0)
        self.assertEqual(res["stick_left_mid_raw"], 2)
        self.assertEqual(res["stick_left_mid_residual"], 2)

    def test_four_step_lift_and_trivial_lift(self):
        res = models.check_four_step_lift()
        self.assertEqual(res["lifted_carrier_size"], 4)
        self.assertTrue(res["single_step_intertwines_counterpart"])
        self.assertTrue(res["two_steps_visible_id_sheet_flipped"])
        self.assertTrue(res["four_steps_period_four"])
        self.assertTrue(res["trivial_lift_period_two"])

    def test_two_sheet_holonomy_census_across_all_16_intertwining_maps(self):
        res = models.check_two_sheet_holonomy_census()
        self.assertEqual(res["total_intertwining_maps"], 16)
        self.assertEqual(res["period_two_count"], 2)
        self.assertEqual(res["period_four_count"], 2)
        self.assertEqual(res["four_step_return_count"], 4)
        self.assertEqual(res["pointwise_non_return_witness_count"], 12)
        self.assertEqual(res["mixed_non_bijective_count"], 12)
        self.assertTrue(res["all_satisfy_dichotomy"])
        self.assertTrue(res["all_match_period_two_iff"])
        self.assertTrue(res["all_match_period_four_iff"])
        self.assertTrue(res["fin4_sheet_equivariant_bijection"])

    def test_stick_carrier_threshold_n1_n2_n3(self):
        res = models.check_stick_carrier_threshold()
        self.assertEqual(res["minimal_threshold_n"], 3)
        by_n = res["by_n"]
        self.assertTrue(by_n[1]["all_residual_eq_hamming"])
        self.assertFalse(by_n[1]["has_single_stick_mirror_collapse"])
        self.assertFalse(by_n[1]["has_positive_single_stick_residual"])

        self.assertFalse(by_n[2]["all_residual_eq_hamming"])
        self.assertTrue(by_n[2]["has_single_stick_mirror_collapse"])
        self.assertEqual(by_n[2]["mirror_collapse_pairs"], [(0, 1)])
        self.assertFalse(by_n[2]["has_positive_single_stick_residual"])
        self.assertEqual(by_n[2]["max_single_stick_residual"], 0)

        self.assertFalse(by_n[3]["all_residual_eq_hamming"])
        self.assertTrue(by_n[3]["has_single_stick_mirror_collapse"])
        self.assertEqual(by_n[3]["mirror_collapse_pairs"], [(0, 2)])
        self.assertTrue(by_n[3]["has_positive_single_stick_residual"])
        self.assertEqual(by_n[3]["positive_residual_pairs"], [(0, 1), (1, 2)])
        self.assertEqual(by_n[3]["max_single_stick_residual"], 2)

        for n_hi, expected_mirror in ((4, [(0, 3), (1, 2)]), (10, [(0, 9), (1, 8), (2, 7), (3, 6), (4, 5)])):
            self.assertFalse(by_n[n_hi]["all_residual_eq_hamming"])
            self.assertTrue(by_n[n_hi]["has_single_stick_mirror_collapse"])
            self.assertEqual(by_n[n_hi]["mirror_collapse_pairs"], expected_mirror)
            self.assertTrue(by_n[n_hi]["has_positive_single_stick_residual"])
            self.assertEqual(by_n[n_hi]["max_single_stick_residual"], 2)

    def test_reflective_generator_and_depth_d_thresholds(self):
        res = models.check_reflective_generator_and_depth_d()
        self.assertEqual(res["one_token_bridge_carrier_size"], 2)
        self.assertEqual(res["one_token_bridge_rel_size"], 1)
        self.assertEqual(
            res["depth1_obstruction_counts"],
            {1: 0, 2: 0, 3: 1, 4: 3, 5: 6, 6: 10, 7: 15, 8: 21},
        )
        self.assertEqual(
            res["radius_d_thresholds"],
            {0: 3, 1: 5, 2: 7, 3: 9, 4: 11},
        )


if __name__ == "__main__":
    unittest.main()
