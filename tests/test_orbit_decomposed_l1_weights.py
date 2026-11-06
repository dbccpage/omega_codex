"""Unit tests for Slice 4 / DER-27 orbit-decomposed automorphism-invariant L1 cochain weights."""
import importlib.util
import itertools
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "oq05_to_oq08_checks",
    ROOT / "audit/2026-11-05_minimal_chain/11_oq05_to_oq08_checks.py",
)
checks = importlib.util.module_from_spec(spec)
spec.loader.exec_module(checks)


class OrbitDecomposedL1WeightsTests(unittest.TestCase):
    def test_three_edge_symmetry_hierarchy_and_orbit_decomposition(self):
        valid_repairs = [
            (v1, v2, v3)
            for v1, v2, v3 in itertools.product(range(-3, 4), repeat=3)
            if v1 + v2 + v3 == 1
        ]
        all_weights = list(itertools.product(range(1, 5), repeat=3))
        for w in all_weights:
            inv23 = all(
                checks.weighted_l1(w, checks.swap_edge23(v)) == checks.weighted_l1(w, v)
                for v in valid_repairs
            )
            inv12 = all(
                checks.weighted_l1(w, checks.swap_edge12(v)) == checks.weighted_l1(w, v)
                for v in valid_repairs
            )
            inv_both = all(
                checks.weighted_l1(w, checks.swap_edge12(v)) == checks.weighted_l1(w, v)
                and checks.weighted_l1(w, checks.swap_edge23(v)) == checks.weighted_l1(w, v)
                for v in valid_repairs
            )
            self.assertEqual(inv23, w[1] == w[2])
            self.assertEqual(inv12, w[0] == w[1])
            self.assertEqual(inv_both, w[0] == w[1] == w[2])
            if w[1] == w[2]:
                for v in valid_repairs:
                    self.assertEqual(
                        checks.weighted_l1(w, v),
                        w[0] * abs(v[0]) + w[1] * (abs(v[1]) + abs(v[2])),
                    )

    def test_general_n_edge_unit_cochain_orbit_constancy_and_transitive_factoring(self):
        # Boundary case n = 0
        self.assertEqual(checks.weighted_l1_gen((3, 5), (1, -2), 0), 0)
        self.assertEqual(checks.unweighted_l1_gen((1, -2), 0), 0)

        # Unit cochain extraction for e < n and vanishing for n <= e
        w5 = (2, 7, 4, 9, 5)
        for e in range(5):
            u = checks.unit_cochain(e, 5)
            for m in range(e + 1):
                self.assertEqual(checks.weighted_l1_gen(w5, u, m), 0)
            for m in range(e + 1, 6):
                self.assertEqual(checks.weighted_l1_gen(w5, u, m), w5[e])

        # 5-edge 2-orbit permutation (3-cycle on {0,1,2} and 2-cycle on {3,4}) vs 5-cycle
        n5 = 5
        sigma_two_orbits = (1, 2, 0, 4, 3)
        sigma_five_cycle = (1, 2, 3, 4, 0)
        weights5 = list(itertools.product(range(1, 3), repeat=n5))
        for w in weights5:
            inv_2orb = all(
                checks.weighted_l1_gen(w, checks.unit_cochain(sigma_two_orbits[e], n5), n5)
                == checks.weighted_l1_gen(w, checks.unit_cochain(e, n5), n5)
                for e in range(n5)
            )
            self.assertEqual(inv_2orb, (w[0] == w[1] == w[2]) and (w[3] == w[4]))

            inv_5cyc = all(
                checks.weighted_l1_gen(w, checks.unit_cochain(sigma_five_cycle[e], n5), n5)
                == checks.weighted_l1_gen(w, checks.unit_cochain(e, n5), n5)
                for e in range(n5)
            )
            self.assertEqual(inv_5cyc, len(set(w)) == 1)
            if inv_5cyc:
                for v in ((1, -2, 0, 3, -1), (0, 0, 0, 0, 0), (-1, -1, -1, -1, -1)):
                    self.assertEqual(
                        checks.weighted_l1_gen(w, v, n5),
                        w[0] * checks.unweighted_l1_gen(v, n5),
                    )


if __name__ == "__main__":
    unittest.main()
