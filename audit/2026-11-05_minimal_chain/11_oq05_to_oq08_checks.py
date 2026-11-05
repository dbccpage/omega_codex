#!/usr/bin/env python3
"""
11_oq05_to_oq08_checks.py
Pinned commits:
  A (19L57G1): 45bb09864f9b52ed5ecf66e977ca81f0ed623de7
  B (theory_of_finite_quantum_mechanics): e45ed2e133920aa3790af8c5e072ee9829898490
  omega_codex (baseline): e21b785626ff8d0231a53409c76fe4e7a57cd59d

Reproducible stdlib verification for settling OQ-05 through OQ-08 in 8_open.md:
  1. OQ-05 (GEN-WDP-O03 / A21): Multi-round closure bounds comparing explicit
     pair-demand accounting Q (max n*(n-1)/2 rounds) vs derived quotient-refinement
     accounting Q_der (max n - 1 rounds) for n = 2, 3, 4, 5, plus the n = 3 unary
     mark witness and ZeroEquivalence kernel check.
  2. OQ-06 (GEN-WDP-O05 / H01): Constructive decodeFin (List.find?) verification
     across all 256 (report, state) function pairs on |H| = 4, |V| = 2, |S| = 2,
     checking 0 mismatches against fiber constancy.
  3. OQ-07 (L1-R-RESIDUAL-TO-WEIGHTS / A32): 3-edge cycle repair optimization on
     [-3..3]^3 with v1 + v2 + v3 = 1 under asymmetric weights w = (1, 2, 2) and
     w' = (2, 1, 2), and verification that cyclic edge-permutation invariance
     holds iff w1 = w2 = w3.
  4. OQ-08 (GEN-WDP-O04 / A30, A31): State-refinement morphism projToHorizon from
     the 5-gate WDP span (WDP-CH01-D03) to the 1-gate Horizon world across all
     event sequences of length <= 3 at costs (0,0,0,1), (0,1,0,1), and (0,0,1,1).
"""

import itertools


# ============================================================================
# SECTION 1: OQ-05 -- Multi-Round Closure Bound (Explicit Q vs Derived Q_der)
# ============================================================================

def max_explicit_q_rounds(n):
    """Maximum rounds when any unrequested unordered pair (i < j) can be demanded."""
    all_pairs = [(i, j) for i in range(n) for j in range(i + 1, n)]
    return len(all_pairs)


def max_quotient_refinement_rounds(n):
    """Simulate longest chain of strict partition refinements on {0..n-1} by unary predicates."""
    # Start with 1 equivalence class: frozenset({frozenset(range(n))})
    start_part = frozenset([frozenset(range(n))])
    # All unary predicates U_d = {d} for d in 0..n-1 (and general subsets if needed)
    unary_preds = [frozenset([d]) for d in range(n)]

    def refine(partition, pred):
        new_blocks = []
        for block in partition:
            b_in = block & pred
            b_out = block - pred
            if b_in:
                new_blocks.append(b_in)
            if b_out:
                new_blocks.append(b_out)
        return frozenset(new_blocks)

    # BFS / DFS for max steps where each step demands a currently collapsed pair (i, j)
    # and applies a unary predicate that separates (i, j)
    memo = {}

    def dfs(part):
        if part in memo:
            return memo[part]
        best = 0
        # Find all currently collapsed pairs (i < j in the same block)
        collapsed_pairs = []
        for block in part:
            bl = sorted(block)
            for idx_a in range(len(bl)):
                for idx_b in range(idx_a + 1, len(bl)):
                    collapsed_pairs.append((bl[idx_a], bl[idx_b]))
        for i, j in collapsed_pairs:
            for pred in unary_preds:
                if (i in pred) != (j in pred):
                    nxt = refine(part, pred)
                    if len(nxt) > len(part):
                        best = max(best, 1 + dfs(nxt))
        memo[part] = best
        return best

    return dfs(start_part)


def check_oq05():
    print("=== [1] OQ-05: MULTI-ROUND CLOSURE BOUND (EXPLICIT Q VS DERIVED Q_der) ===")
    for n in [2, 3, 4, 5]:
        exp_q = max_explicit_q_rounds(n)
        der_q = max_quotient_refinement_rounds(n)
        gap = exp_q - der_q
        assert exp_q == n * (n - 1) // 2
        assert der_q == n - 1
        print(
            f"  n={n}: max_rounds(explicit Q) = {exp_q} [n(n-1)/2], "
            f"max_rounds(derived Q_der) = {der_q} [n-1], gap = {gap}"
        )

    # Concrete n=3 witness after Round 1 with unary instance (0, [0])
    insts_r1 = {(0, (0,))}
    # Single well-formed unary context c = (0, [None])
    def derivable_r1(d):
        return (0, (d,)) in insts_r1

    sep_01 = derivable_r1(0) != derivable_r1(1)
    sep_02 = derivable_r1(0) != derivable_r1(2)
    col_12 = derivable_r1(1) == derivable_r1(2)
    assert sep_01 and sep_02 and col_12
    print(
        f"  n=3 unary witness (0,[0]): sep(0,1)={sep_01}, sep(0,2)={sep_02}, "
        f"collapsed(1,2)={col_12} (1 round splits 2 pairs simultaneously)"
    )
    print()


# ============================================================================
# SECTION 2: OQ-06 -- Constructive decodeFin (List.find?) on Finite Histories
# ============================================================================

def decode_fin(histories, report_fn, state_fn, default_s, v):
    for h in histories:
        if report_fn(h) == v:
            return state_fn(h)
    return default_s


def is_fiber_constant(histories, report_fn, state_fn):
    for h1 in histories:
        for h2 in histories:
            if report_fn(h1) == report_fn(h2) and state_fn(h1) != state_fn(h2):
                return False
    return True


def check_oq06():
    print("=== [2] OQ-06: CONSTRUCTIVE decodeFin (List.find?) ON FINITE HISTORIES ===")
    histories = [0, 1, 2, 3]
    v_vals = [0, 1]
    s_vals = [0, 1]

    total_pairs = 0
    fiber_const_count = 0
    decode_exact_count = 0
    mismatches = 0

    for rep_tuple in itertools.product(v_vals, repeat=len(histories)):
        for st_tuple in itertools.product(s_vals, repeat=len(histories)):
            total_pairs += 1
            rep_fn = lambda h, rt=rep_tuple: rt[h]
            st_fn = lambda h, st=st_tuple: st[h]

            fc = is_fiber_constant(histories, rep_fn, st_fn)
            dec_ok = all(
                decode_fin(histories, rep_fn, st_fn, 0, rep_fn(h)) == st_fn(h)
                for h in histories
            )
            if fc:
                fiber_const_count += 1
            if dec_ok:
                decode_exact_count += 1
            if fc != dec_ok:
                mismatches += 1

    assert mismatches == 0
    print(f"  |H|=4, |V|=2, |S|=2: total (report, state) pairs = {total_pairs}")
    print(f"  Fiber-constant pairs:                {fiber_const_count} / {total_pairs}")
    print(f"  decodeFin exact on all h in H:       {decode_exact_count} / {total_pairs}")
    print(f"  Mismatches (fiber_const != decodeFin): {mismatches}")
    print()


# ============================================================================
# SECTION 3: OQ-07 -- Positive L1 Weights (Non-Forcing vs Symmetry Forcing)
# ============================================================================

def weighted_l1(w, v):
    return w[0] * abs(v[0]) + w[1] * abs(v[1]) + w[2] * abs(v[2])


def rot_edge(v):
    return (v[1], v[2], v[0])


def check_oq07():
    print("=== [3] OQ-07: POSITIVE L1 WEIGHTS (NON-FORCING VS SYMMETRY FORCING) ===")
    valid_repairs = [
        (v1, v2, v3)
        for v1, v2, v3 in itertools.product(range(-3, 4), repeat=3)
        if v1 + v2 + v3 == 1
    ]

    w1 = (1, 2, 2)
    w2 = (2, 1, 2)
    min_w1 = min(weighted_l1(w1, v) for v in valid_repairs)
    argmins_w1 = [v for v in valid_repairs if weighted_l1(w1, v) == min_w1]
    second_min_w1 = min(weighted_l1(w1, v) for v in valid_repairs if v != (1, 0, 0))

    min_w2 = min(weighted_l1(w2, v) for v in valid_repairs)
    argmins_w2 = [v for v in valid_repairs if weighted_l1(w2, v) == min_w2]
    second_min_w2 = min(weighted_l1(w2, v) for v in valid_repairs if v != (0, 1, 0))

    assert argmins_w1 == [(1, 0, 0)] and min_w1 == 1 and second_min_w1 == 2
    assert argmins_w2 == [(0, 1, 0)] and min_w2 == 1 and second_min_w2 == 2

    # Test all positive weight triples in {1..4}^3 for cyclic edge-permutation invariance
    all_weights = list(itertools.product(range(1, 5), repeat=3))
    cyc_invariant = [
        w for w in all_weights
        if all(weighted_l1(w, rot_edge(v)) == weighted_l1(w, v) for v in valid_repairs)
    ]
    equal_weights = [w for w in all_weights if w[0] == w[1] == w[2]]
    assert cyc_invariant == equal_weights

    print(f"  Valid repairs in [-3..3]^3 with v1+v2+v3=1: {len(valid_repairs)}")
    print(f"  w=(1,2,2): min={min_w1}, unique minimizer={argmins_w1}, min on v!=(1,0,0) is {second_min_w1}")
    print(f"  w=(2,1,2): min={min_w2}, unique minimizer={argmins_w2}, min on v!=(0,1,0) is {second_min_w2}")
    print(
        f"  Cyclic-invariant weights in {{1..4}}^3: {len(cyc_invariant)} / {len(all_weights)} "
        f"(matches w1==w2==w3: {cyc_invariant == equal_weights})"
    )
    print()


# ============================================================================
# SECTION 4: OQ-08 -- State-Refinement Morphism (WDP-CH01-D03 vs Horizon.lean)
# ============================================================================

def step_hworld(w, ev):
    toks, reqs, views, budget = w
    kind = ev[0]
    if kind == "admitTok":
        t = ev[1]
        return (toks if t in toks else toks + (t,), reqs, views, budget)
    if kind == "require":
        pair = (ev[1], ev[2])
        return (toks, reqs if pair in reqs else reqs + (pair,), views, budget)
    if kind == "addView":
        v = ev[1]
        if budget >= 1:
            return (toks, reqs, views if v in views else views + (v,), budget - 1)
        return w
    if kind == "setBudget":
        return (toks, reqs, views, ev[1])
    raise ValueError(f"Unknown event: {ev}")


def step_wdp_world(costs, w, ev):
    c_sup, c_adm, c_ret, c_ev = costs
    sup, adm, ret, views, ledger, receipts = w
    kind = ev[0]
    if kind == "admitTok":
        t = ev[1]
        cost = c_sup + c_adm
        if ledger >= cost:
            adm_next = adm if t in adm else adm + (t,)
            return (sup + (t,), adm_next, ret, views, ledger - cost, receipts)
        return w
    if kind == "require":
        pair = (ev[1], ev[2])
        if ledger >= c_ret:
            ret_next = ret if pair in ret else ret + (pair,)
            return (sup, adm, ret_next, views, ledger - c_ret, receipts)
        return w
    if kind == "addView":
        v = ev[1]
        if ledger >= c_ev:
            views_next = views if v in views else views + (v,)
            return (sup, adm, ret, views_next, ledger - c_ev, receipts + 1)
        return w
    if kind == "setBudget":
        return (sup, adm, ret, views, ev[1], receipts)
    raise ValueError(f"Unknown event: {ev}")


def proj_to_horizon(w_wdp):
    _, adm, ret, views, ledger, _ = w_wdp
    return (adm, ret, views, ledger)


def check_oq08():
    print("=== [4] OQ-08: STATE-REFINEMENT MORPHISM (WDP-CH01-D03 VS HORIZON.LEAN) ===")
    events = [
        ("admitTok", 0),
        ("admitTok", 1),
        ("require", 0, 1),
        ("addView", 0),
        ("setBudget", 1),
    ]
    w0_wdp = ((), (), (), (), 0, 0)
    w0_h = proj_to_horizon(w0_wdp)

    for label, costs in [
        ("Zero adm/ret cost (0,0,0,1)", (0, 0, 0, 1)),
        ("Priced admission  (0,1,0,1)", (0, 1, 0, 1)),
        ("Priced retention  (0,0,1,1)", (0, 0, 1, 1)),
    ]:
        total_traces = 0
        mismatches = 0
        for length in range(1, 4):
            for trace in itertools.product(events, repeat=length):
                total_traces += 1
                w_wdp = w0_wdp
                w_h = w0_h
                for ev in trace:
                    w_wdp = step_wdp_world(costs, w_wdp, ev)
                    w_h = step_hworld(w_h, ev)
                if proj_to_horizon(w_wdp) != w_h:
                    mismatches += 1
        print(f"  {label}: traces(len<=3)={total_traces}, commutation mismatches={mismatches}")


if __name__ == "__main__":
    check_oq05()
    check_oq06()
    check_oq07()
    check_oq08()
