"""Unit tests for OQ-05 general Regime4 transition-to-class-count growth bridge and RT-09 boundary cases."""
from __future__ import annotations

import importlib.util
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "oq05_to_oq08_checks",
    ROOT / "audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py",
)
oq05 = importlib.util.module_from_spec(spec)
spec.loader.exec_module(oq05)


class OQ05Regime4ClassCountTests(unittest.TestCase):
    def test_empty_and_singleton_carrier_edge_cases(self) -> None:
        r0 = (0, (), (), ())
        self.assertEqual(oq05.all_wf_ctxs4(r0), [])
        self.assertEqual(oq05.regime_class_count4(r0), 0)

        r0_unary = (0, (1,), (), ())
        self.assertEqual(oq05.all_wf_ctxs4(r0_unary), [(0, (None,))])
        self.assertEqual(oq05.regime_class_count4(r0_unary), 0)

        r1 = (1, (), (), ())
        self.assertEqual(oq05.all_wf_ctxs4(r1), [])
        self.assertEqual(oq05.regime_class_count4(r1), 1)
        self.assertTrue(oq05.is_rep4(r1, 0))

    def test_all_wf_ctxs4_enumeration_for_unary_and_binary_forms(self) -> None:
        # For data=2, forms=(1, 2):
        # form 0 (arity 1): slots of length 1 with at least one None -> [(None,)] (1 context)
        # form 1 (arity 2): slots of length 2 over {None, 0, 1} with at least one None -> 3^2 - 2^2 = 5 contexts
        r = (2, (1, 2), (), ())
        ctxs = oq05.all_wf_ctxs4(r)
        self.assertEqual(len(ctxs), 6)
        form0_ctxs = [c for c in ctxs if c[0] == 0]
        form1_ctxs = [c for c in ctxs if c[0] == 1]
        self.assertEqual(len(form0_ctxs), 1)
        self.assertEqual(len(form1_ctxs), 5)
        for f, slots in ctxs:
            self.assertIn(None, slots)
            self.assertEqual(len(slots), r[1][f])

    def test_step_fresh_unary4_strict_class_count_trajectories(self) -> None:
        for n in (2, 3, 4, 5):
            r = (n, (), (), ())
            counts = [oq05.regime_class_count4(r)]
            self.assertEqual(counts[0], 1)
            for t in range(n - 1):
                self.assertTrue(oq05.collapsed4_bool(r, t, t + 1))
                r = oq05.step_fresh_unary4(r, t)
                self.assertFalse(oq05.collapsed4_bool(r, t, t + 1))
                counts.append(oq05.regime_class_count4(r))
            self.assertEqual(counts, list(range(1, n + 1)))

        # Check non-consecutive pair separation order on n=4
        r4 = (4, (), (), ())
        counts4 = [oq05.regime_class_count4(r4)]
        for target in (3, 1, 2):
            self.assertTrue(oq05.collapsed4_bool(r4, 0, target))
            r4 = oq05.step_fresh_unary4(r4, target)
            self.assertFalse(oq05.collapsed4_bool(r4, 0, target))
            counts4.append(oq05.regime_class_count4(r4))
        self.assertEqual(counts4, [1, 2, 3, 4])

    def test_rt09_existing_form_recollapse_vs_fresh_form_strict_refinement(self) -> None:
        r3_round1 = (3, (1,), ((0, (0,)),), ((0, 1),))
        r3_round2_recollapse = (3, (1,), ((0, (0,)), (0, (2,))), ((0, 1),))
        r3_round2_fresh = (3, (1, 1), ((0, (0,)), (1, (1,))), ((0, 1),))
        self.assertEqual(oq05.regime_class_count4(r3_round1), 2)
        self.assertEqual(oq05.regime_class_count4(r3_round2_recollapse), 2)
        self.assertEqual(oq05.regime_class_count4(r3_round2_fresh), 3)
        # Existing-form update separates (1, 2) but re-collapses (0, 2)
        self.assertFalse(oq05.collapsed4_bool(r3_round2_recollapse, 1, 2))
        self.assertTrue(oq05.collapsed4_bool(r3_round2_recollapse, 0, 2))
        # Fresh-form update separates all three pairs (0, 1), (0, 2), and (1, 2)
        self.assertFalse(oq05.collapsed4_bool(r3_round2_fresh, 0, 1))
        self.assertFalse(oq05.collapsed4_bool(r3_round2_fresh, 0, 2))
        self.assertFalse(oq05.collapsed4_bool(r3_round2_fresh, 1, 2))


if __name__ == "__main__":
    unittest.main()
