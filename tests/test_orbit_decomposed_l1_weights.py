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

    def test_der28_singleton_view_embedding_and_full_guard_replay(self):
        # Boundary case: empty event trace []
        w0_full = ((), (), (), (), (), 1, True, (), 0)
        self.assertEqual(
            checks.proj_to_represented_world(w0_full),
            checks.replay_represented_world((), checks.proj_to_represented_world(w0_full)),
        )

        # Multi-step trace covering all 8 Event constructors at horizonSpecializationCosts = (0,0,0,1)
        all_eight_trace = [
            ("admitTok", 10),
            ("admitTok", 20),
            ("require", 0, 1),
            ("setBudget", 2),
            ("addView", (0,)),
            ("mark", (0,), 1),
            ("refuse", 0, 1),
            ("note", 42),
            ("setAugLicense", False),
        ]
        wf = w0_full
        for ev in all_eight_trace:
            wf = checks.step_full_wdp_world((0, 0, 0, 1), wf, ev)
        self.assertEqual(
            checks.proj_to_represented_world(wf),
            checks.replay_represented_world(all_eight_trace, checks.proj_to_represented_world(w0_full)),
        )

        # Singleton view carrier bound & membership equivalences (including empty list / n=0)
        for n in range(4):
            for v in range(4):
                self.assertEqual(all(p < n for p in (v,)), v < n)
        for vs in ((), (0,), (1, 2), (0, 1, 2)):
            mapped = tuple((u,) for u in vs)
            for v in range(4):
                self.assertEqual((v,) in mapped, v in vs)

        # Event embedding embed_hev and unconditional admitTok / require / setBudget commutation
        self.assertEqual(checks.embed_hev(("admitTok", 5)), ("admitTok", 5))
        self.assertEqual(checks.embed_hev(("require", 0, 1)), ("require", 0, 1))
        self.assertEqual(checks.embed_hev(("addView", 2)), ("addView", (2,)))
        self.assertEqual(checks.embed_hev(("setBudget", 3)), ("setBudget", 3))
        for hw_base in (
            ((), (), (), 0),
            ((10, 20), ((0, 1),), (0,), 1),
        ):
            for licensed in (False, True):
                for hev in (
                    ("admitTok", 10),   # duplicate token
                    ("admitTok", 30),   # novel token
                    ("require", 0, 0),  # diagonal self-pair rejected
                    ("require", 0, 1),  # valid or duplicate pair
                    ("require", 0, 5),  # out-of-bounds index rejected
                    ("setBudget", 0),
                    ("setBudget", 4),
                ):
                    self.assertEqual(
                        checks.embed_hworld(checks.step_hworld_guarded(hw_base, hev), licensed),
                        checks.step_represented_world(checks.embed_hworld(hw_base, licensed), checks.embed_hev(hev)),
                    )

        # Novel, separating, licensed addView commutes even when budget == 0 or v >= len(toks)
        for budget in (0, 1, 2):
            hw = ((10, 20), ((0, 1),), (), budget)
            for v in (0, 1, 2):
                if v < len(hw[0]):
                    self.assertTrue(checks.increase_b(len(hw[0]), checks.embed_hworld(hw, True)[1], (v,)))
                lhs = checks.embed_hworld(checks.step_hworld_guarded(hw, ("addView", v)), True)
                rhs = checks.step_represented_world(checks.embed_hworld(hw, True), ("addView", (v,)))
                self.assertEqual(lhs, rhs)

        # Exact iff characterization when budget >= 1 and v < len(toks)
        hw_cases = [
            ((10,), (), (), 1),            # singleton carrier: increaseB is False
            ((10, 20), ((0, 1),), (), 1),  # novel separating view
            ((10, 20), ((0, 1),), (0,), 1),  # v=0 duplicate, v=1 no new separation
        ]
        for hw in hw_cases:
            for licensed in (False, True):
                for v in range(len(hw[0])):
                    lhs = checks.embed_hworld(checks.step_hworld_guarded(hw, ("addView", v)), licensed)
                    rhs = checks.step_represented_world(checks.embed_hworld(hw, licensed), ("addView", (v,)))
                    expected = (
                        (v not in hw[2])
                        and checks.increase_b(len(hw[0]), checks.embed_hworld(hw, licensed)[1], (v,))
                        and licensed
                    )
                    self.assertEqual(lhs == rhs, expected)

    def test_der29_pair_quotient_multiplicity_and_symmetry_floor(self):
        pairs = list(itertools.product((False, True), repeat=2))
        self.assertEqual({checks.pair_to_fin3(p) for p in pairs}, {0, 1, 2})
        self.assertEqual({checks.pair_to_fin3_dual(p) for p in pairs}, {0, 1, 2})
        for p in pairs:
            self.assertEqual(checks.diag_swap(checks.diag_swap(p)), p)
            self.assertNotEqual(checks.diag_swap(p), p)
            self.assertEqual(checks.diag_swap(p)[0] ^ checks.diag_swap(p)[1], p[0] ^ p[1])
            self.assertEqual(checks.transpose_pair(checks.transpose_pair(p)), p)
            self.assertEqual(checks.transpose_pair(p) == p, not (p[0] ^ p[1]))
            self.assertEqual(checks.pair_to_fin3(checks.diag_swap(p)), checks.swap3(checks.pair_to_fin3(p)))
            self.assertEqual(checks.pair_to_fin3(checks.transpose_pair(p)), checks.swap3(checks.pair_to_fin3(p)))
            self.assertEqual(checks.offer12(checks.pair_to_fin3(p)), p[0] ^ p[1])
            self.assertEqual(checks.pair_to_fin3_dual(checks.diag_swap(p)), checks.swap3(checks.pair_to_fin3_dual(p)))
            self.assertEqual(checks.pair_to_fin3_dual(checks.transpose_pair(p)), checks.pair_to_fin3_dual(p))
            self.assertEqual(checks.offer12(checks.pair_to_fin3_dual(p)), not (p[0] ^ p[1]))
            for q in pairs:
                self.assertEqual(
                    checks.pair_to_fin3(p) == checks.pair_to_fin3(q),
                    p == q or ((not (p[0] ^ p[1])) and (not (q[0] ^ q[1]))),
                )

    def test_der30_simplicial_cochain_exactness_and_primal_dual_l1_min(self):
        # F2 triangle exactness on all 8 cochains
        for h_f2 in itertools.product((False, True), repeat=3):
            closed = not checks.d1_unsigned_f2(h_f2)
            self.assertEqual(closed, checks.d0_unsigned_f2(checks.prim_triangle_f2(h_f2)) == h_f2)
            self.assertEqual(
                closed,
                any(checks.d0_unsigned_f2(c) == h_f2 for c in itertools.product((False, True), repeat=3)),
            )

        # Z triangle exactness and primal-dual L1 minimum defect (including 0, positive, negative curl)
        for h_int in ((0, 0, 0), (1, 1, 1), (-2, -3, 1), (3, -1, 2), (-1, 4, 3)):
            d1_val = checks.d1_signed_cyc_int(h_int)
            self.assertEqual(d1_val == 0, checks.d0_signed_int(checks.prim_triangle_int(h_int)) == h_int)
            res_prim = checks.residual_cochain1_int(h_int, checks.prim_triangle_int(h_int))
            self.assertEqual(res_prim, (0, d1_val, 0))
            self.assertEqual(checks.norm_l1(res_prim), abs(d1_val))
            for c_int in itertools.product(range(-3, 4), repeat=3):
                res = checks.residual_cochain1_int(h_int, c_int)
                self.assertEqual(checks.d1_signed_cyc_int(res), d1_val)
                self.assertLessEqual(abs(d1_val), checks.norm_l1(res))

        # Z tetrahedron 2-cochain exactness (ker d2 == im d1)
        for f_tet in ((0, 0, 0, 0), (2, 3, 2, 1), (1, 1, 1, 1), (-2, 1, -1, 2), (5, 2, -1, 3)):
            d2_val = checks.d2_tet_signed(f_tet)
            self.assertEqual(d2_val == 0, checks.d1_tet_signed(checks.prim_tet1_int(f_tet)) == f_tet)
            if d2_val != 0:
                for h_tet in itertools.product(range(-1, 2), repeat=6):
                    self.assertNotEqual(checks.d1_tet_signed(h_tet), f_tet)


if __name__ == "__main__":
    unittest.main()
