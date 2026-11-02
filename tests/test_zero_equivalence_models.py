"""Independent finite regression cases, including deliberately corrupted tables."""
import importlib.util
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("zero_models", ROOT / "scripts/zero_equivalence_models.py")
models = importlib.util.module_from_spec(spec)
spec.loader.exec_module(models)


class ZeroModelsTests(unittest.TestCase):
    def test_all_four_declared_cases(self):
        expected = [(1, True, 2), (1, False, 2), (2, True, 2), (2, False, 5)]
        for name, result in zip(models.FIXTURES, expected):
            checked = models.check_fixture(name)
            self.assertEqual((checked["classes"], checked["exact_descends"], checked["candidate_equivalences"]), result)
            self.assertTrue(checked["zero_status_descends"])

    def test_changed_zero_criterion_is_rejected(self):
        with self.assertRaises(ValueError):
            models.check_fixture("rich", zeros=frozenset({0, 1, 2}))

    def test_changed_exact_values_are_rejected(self):
        with self.assertRaises(ValueError):
            models.check_fixture("nonconstantAllZero", table=((0, 0), (0, 0)))
        with self.assertRaises(ValueError):
            models.check_fixture("rich", table=((0, 0, 2), (0, 0, 2), (2, 2, 0)))

    def test_broken_equivalence_law_is_rejected(self):
        with self.assertRaises(ValueError):
            models.check_fixture("binary", table=((1, 1), (1, 0)))

    def test_empty_and_singleton_are_distinct(self):
        self.assertEqual(models.classify((), frozenset({0}))["classes"], 0)
        self.assertEqual(models.classify(((0,),), frozenset({0}))["classes"], 1)

    def test_bijective_relabeling_preserves_each_case(self):
        for table, zeros, _, _ in models.FIXTURES.values():
            order = tuple(reversed(range(len(table))))
            renamed = tuple(tuple(table[x][y] for y in order) for x in order)
            self.assertEqual(models.classify(table, zeros), models.classify(renamed, zeros))


if __name__ == "__main__":
    unittest.main()
