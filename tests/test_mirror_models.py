"""Semantic checks of the approved two-model mirror slice."""
import importlib.util
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("mirror_models", ROOT / "scripts/mirror_models.py")
mirror = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mirror)

class MirrorTests(unittest.TestCase):
    def test_shared_presentations_do_not_fix_referent_count(self):
        self.assertEqual(mirror.referents("one_referent"), (0, 0))
        self.assertEqual(mirror.referents("two_referents"), (0, 1))
        self.assertTrue(mirror.identity_answer("one_referent"))
        self.assertFalse(mirror.identity_answer("two_referents"))

    def test_full_accessible_tables_are_identical(self):
        expected = (False, True, True, False)
        self.assertEqual(mirror.observe("one_referent"), expected)
        self.assertEqual(mirror.observe("two_referents"), expected)

    def test_no_base_decoder_answers_both_models(self):
        self.assertEqual(mirror.enumerate_case()["base_interface"],
                         {"reachable_values": 1, "decoders_examined": 2, "correct_decoders": 0})

    def test_all_boolean_extra_channels(self):
        rows = mirror.enumerate_case()["boolean_completions"]
        self.assertEqual([r["extra_values"] for r in rows],
                         [[False, False], [False, True], [True, False], [True, True]])
        self.assertEqual([r["correct_decoders"] for r in rows], [0, 1, 1, 0])
        self.assertEqual([r["decoders_examined"] for r in rows], [2, 4, 4, 2])

    def test_invalid_model_is_not_silently_interpreted(self):
        with self.assertRaises(ValueError):
            mirror.observe("unadmitted_model")

if __name__ == "__main__":
    unittest.main()
