#!/usr/bin/env python3
"""
11_oq05_to_oq08_checks.py
Pinned commits:
  A (19L57G1): 45bb09864f9b52ed5ecf66e977ca81f0ed623de7
  B (theory_of_finite_quantum_mechanics): e45ed2e133920aa3790af8c5e072ee9829898490
  omega_codex (baseline): e21b785626ff8d0231a53409c76fe4e7a57cd59d

Reproducible stdlib verification for OQ-05 through OQ-08 in 8_open.md:
  1. OQ-05 (GEN-WDP-O03 / A21, settled in DER-08 + DER-24):
     Multi-round closure bounds comparing explicit pair-demand accounting Q
     (max n*(n-1)/2 rounds) vs derived quotient-refinement accounting Q_der (max n - 1
     rounds via general Regime4 transition-to-class-count growth bridge DER-24)
     for n = 2, 3, 4, 5, plus the n = 3 unary mark witness, multi-round stepFreshUnary4
     class-count growth traces, and the RT-09 class-count comparison.
  2. OQ-06 (GEN-WDP-O05 / H01, settled in DER-11): Constructive decodeFin (List.find?)
     verification across all 256 (report, state) function pairs on |H| = 4, |V| = 2, |S| = 2,
     checking 0 mismatches against fiber constancy.
  3. OQ-07 (L1-R-RESIDUAL-TO-WEIGHTS / A32, settled in DER-14): 3-edge cycle repair
     optimization on [-3..3]^3 with v1 + v2 + v3 = 1 under asymmetric weights w = (1, 2, 2)
     and w' = (2, 1, 2), and verification that cyclic edge-permutation invariance holds
     iff w1 = w2 = w3.
  4. OQ-08 (GEN-WDP-O04 / A30, A31, DERIVED_CONDITIONALLY in DER-12 + regressions in
     DER-19 + OWED in OWE-12): Simplified-model commutation between WDPWorld and HWorld
     across all event sequences of length <= 3 at costs (0,0,0,1), (0,1,0,1), and (0,0,1,1),
     followed by the 4 concrete guard-discrepancy regressions between simplified
     stepHWorldGuarded and pinned legacy Represented.World.
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


def all_wf_ctxs4(regime):
    """Enumerate all well-formed contexts of Regime4(data, forms, insts, reqs)."""
    data, forms, _insts, _reqs = regime
    slot_options = [None] + list(range(data))
    ctxs = []
    for f, arity in enumerate(forms):
        for slots in itertools.product(slot_options, repeat=arity):
            if None in slots:
                ctxs.append((f, slots))
    return ctxs


def plug4(ctx, d):
    f, slots = ctx
    return (f, tuple(d if s is None else s for s in slots))


def derivable4_bool(regime, inst):
    _data, _forms, insts, _reqs = regime
    return inst in insts


def collapsed4_bool(regime, d1, d2):
    for ctx in all_wf_ctxs4(regime):
        if derivable4_bool(regime, plug4(ctx, d1)) != derivable4_bool(regime, plug4(ctx, d2)):
            return False
    return True


def is_rep4(regime, x):
    return all(not collapsed4_bool(regime, y, x) for y in range(x))


def regime_class_count4(regime):
    data = regime[0]
    return sum(1 for x in range(data) if is_rep4(regime, x))


def fresh_unary_delta4(regime, target):
    forms = regime[1]
    return (("newForm", 1), ("newInst", len(forms), (target,)))


def apply_item4(regime, item):
    data, forms, insts, reqs = regime
    tag = item[0]
    if tag == "newDatum":
        return (data + 1, forms, insts, reqs)
    if tag == "newForm":
        k = item[1]
        if k < 1:
            return None
        return (data, forms + (k,), insts, reqs)
    if tag == "newInst":
        f, args = item[1], tuple(item[2])
        if f >= len(forms) or len(args) != forms[f] or any(x >= data for x in args):
            return None
        new_inst = (f, args)
        new_insts = insts if new_inst in insts else insts + (new_inst,)
        return (data, forms, new_insts, reqs)
    if tag == "newReq":
        i, j = item[1], item[2]
        if i >= data or j >= data or i == j:
            return None
        pair = (i, j)
        new_reqs = reqs if pair in reqs else reqs + (pair,)
        return (data, forms, insts, new_reqs)
    return None


def apply_delta4(regime, delta):
    curr = regime
    for item in delta:
        curr = apply_item4(curr, item)
        if curr is None:
            return None
    return curr


def step_fresh_unary4(regime, target):
    data, forms, insts, reqs = regime
    new_inst = (len(forms), (target,))
    new_insts = insts if new_inst in insts else insts + (new_inst,)
    return (data, forms + (1,), new_insts, reqs)


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

    # General Regime4 transition-to-class-count growth bridge (DER-24, formerly OWE-11)
    for n in [2, 3, 4, 5]:
        r = (n, (), (), ())
        counts = [regime_class_count4(r)]
        assert counts[0] == 1
        for t in range(n - 1):
            assert collapsed4_bool(r, t, t + 1)
            nxt = step_fresh_unary4(r, t)
            assert apply_delta4(r, fresh_unary_delta4(r, t)) == nxt
            r = nxt
            counts.append(regime_class_count4(r))
            assert counts[-1] == counts[-2] + 1
        assert counts == list(range(1, n + 1))
        print(f"  n={n} stepFreshUnary4 classCount4 trajectory: {counts} (reaches {n} in {n-1} rounds)")

    r3_round1 = (3, (1,), ((0, (0,)),), ((0, 1),))
    r3_round2_recollapse = (3, (1,), ((0, (0,)), (0, (2,))), ((0, 1),))
    r3_round2_fresh = (3, (1, 1), ((0, (0,)), (1, (1,))), ((0, 1),))
    c_r1 = regime_class_count4(r3_round1)
    c_recol = regime_class_count4(r3_round2_recollapse)
    c_fresh = regime_class_count4(r3_round2_fresh)
    assert (c_r1, c_recol, c_fresh) == (2, 2, 3)
    print(
        f"  RT-09 classCount4 comparison: R3_round1={c_r1}, "
        f"R3_round2_recollapse={c_recol} (stalled), R3_round2_fresh={c_fresh} (strict +1)"
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


def swap_edge23(v):
    return (v[0], v[2], v[1])


def swap_edge12(v):
    return (v[1], v[0], v[2])


def weighted_l1_gen(w, v, n):
    return sum(w[k] * abs(v[k]) for k in range(n))


def unweighted_l1_gen(v, n):
    return sum(abs(v[k]) for k in range(n))


def unit_cochain(e, n):
    return tuple(1 if i == e else 0 for i in range(n))


def iter_edge(sigma, k, x):
    curr = x
    for _ in range(k):
        curr = sigma[curr]
    return curr


def check_oq07():
    print("=== [3] OQ-07 / DER-27: POSITIVE L1 WEIGHTS & ORBIT-DECOMPOSED SYMMETRY HIERARCHY ===")
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

    # Test all positive weight triples in {1..4}^3 for cyclic and involution edge symmetries
    all_weights = list(itertools.product(range(1, 5), repeat=3))
    cyc_invariant = [
        w for w in all_weights
        if all(weighted_l1(w, rot_edge(v)) == weighted_l1(w, v) for v in valid_repairs)
    ]
    swap23_invariant = [
        w for w in all_weights
        if all(weighted_l1(w, swap_edge23(v)) == weighted_l1(w, v) for v in valid_repairs)
    ]
    swap12_invariant = [
        w for w in all_weights
        if all(weighted_l1(w, swap_edge12(v)) == weighted_l1(w, v) for v in valid_repairs)
    ]
    both_swaps_invariant = [
        w for w in all_weights
        if all(
            weighted_l1(w, swap_edge12(v)) == weighted_l1(w, v)
            and weighted_l1(w, swap_edge23(v)) == weighted_l1(w, v)
            for v in valid_repairs
        )
    ]
    equal_weights = [w for w in all_weights if w[0] == w[1] == w[2]]
    orbit23_weights = [w for w in all_weights if w[1] == w[2]]
    orbit12_weights = [w for w in all_weights if w[0] == w[1]]
    assert cyc_invariant == equal_weights
    assert swap23_invariant == orbit23_weights and len(swap23_invariant) == 16
    assert swap12_invariant == orbit12_weights and len(swap12_invariant) == 16
    assert both_swaps_invariant == equal_weights and len(both_swaps_invariant) == 4

    for w in orbit23_weights:
        for v in valid_repairs:
            assert weighted_l1(w, v) == w[0] * abs(v[0]) + w[1] * (abs(v[1]) + abs(v[2]))

    # General n-edge orbit-constancy and transitive uniformity on n = 4
    n4 = 4
    weights4 = list(itertools.product(range(1, 4), repeat=n4))
    sigma_2orb = (1, 0, 3, 2)  # two 2-edge orbits {0, 1} and {2, 3}
    sigma_cyc4 = (1, 2, 3, 0)  # single transitive 4-edge orbit {0, 1, 2, 3}

    inv_2orb = [
        w for w in weights4
        if all(
            weighted_l1_gen(w, unit_cochain(sigma_2orb[e], n4), n4)
            == weighted_l1_gen(w, unit_cochain(e, n4), n4)
            for e in range(n4)
        )
    ]
    expected_2orb = [w for w in weights4 if w[0] == w[1] and w[2] == w[3]]
    assert inv_2orb == expected_2orb and len(inv_2orb) == 9

    inv_cyc4 = [
        w for w in weights4
        if all(
            weighted_l1_gen(w, unit_cochain(sigma_cyc4[e], n4), n4)
            == weighted_l1_gen(w, unit_cochain(e, n4), n4)
            for e in range(n4)
        )
    ]
    expected_cyc4 = [w for w in weights4 if w[0] == w[1] == w[2] == w[3]]
    assert inv_cyc4 == expected_cyc4 and len(inv_cyc4) == 3

    for w in expected_cyc4:
        for e in range(n4):
            assert any(iter_edge(sigma_cyc4, k, 0) == e for k in range(n4))
        for v in itertools.product(range(-1, 2), repeat=n4):
            assert weighted_l1_gen(w, v, n4) == w[0] * unweighted_l1_gen(v, n4)

    print(f"  Valid repairs in [-3..3]^3 with v1+v2+v3=1: {len(valid_repairs)}")
    print(f"  w=(1,2,2): min={min_w1}, unique minimizer={argmins_w1}, min on v!=(1,0,0) is {second_min_w1}")
    print(f"  w=(2,1,2): min={min_w2}, unique minimizer={argmins_w2}, min on v!=(0,1,0) is {second_min_w2}")
    print(
        f"  3-edge symmetry hierarchy in {{1..4}}^3: swap23={len(swap23_invariant)}/64 (w2==w3), "
        f"swap12={len(swap12_invariant)}/64 (w1==w2), S3/cyclic={len(cyc_invariant)}/64 (w1==w2==w3)"
    )
    print(
        f"  4-edge general orbit constancy in {{1..3}}^4: 2-orbit={len(inv_2orb)}/81, "
        f"transitive 4-cycle={len(inv_cyc4)}/81"
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


def step_hworld_guarded(w, ev):
    toks, reqs, views, budget = w
    kind = ev[0]
    if kind == "admitTok":
        t = ev[1]
        return (toks if t in toks else toks + (t,), reqs, views, budget)
    if kind == "require":
        i, j = ev[1], ev[2]
        if i < len(toks) and j < len(toks) and i != j:
            pair = (i, j)
            return (toks, reqs if pair in reqs else reqs + (pair,), views, budget)
        return w
    if kind == "addView":
        v = ev[1]
        if budget >= 1 and v < len(toks):
            return (toks, reqs, views if v in views else views + (v,), budget - 1)
        return w
    if kind == "setBudget":
        return (toks, reqs, views, ev[1])
    raise ValueError(f"Unknown event: {ev}")


def sep_b(col, i, j):
    return (i in col) != (j in col)


def sat_b(views, req):
    return any(sep_b(c, req[0], req[1]) for c in views)


def increase_b(data_len, views, col):
    return any(
        i != j and sep_b(col, i, j) and not sat_b(views, (i, j))
        for i in range(data_len)
        for j in range(data_len)
    )


def aug_ok_b(data_len, views, col):
    return (
        all(p < data_len for p in col)
        and (col not in views)
        and increase_b(data_len, views, col)
    )


def step_represented_add_view(w, col):
    data, views, reqs, refusals, budget, aug_licensed, notes = w
    if aug_ok_b(len(data), views, col) and aug_licensed and budget > 0:
        return (data, views + (col,), reqs, refusals, budget - 1, aug_licensed, notes)
    return w


def check_oq08():
    print("=== [4] OQ-08: STATE-REFINEMENT MORPHISM (SIMPLIFIED WDPWorld VS HWorld) ===")
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
        if label.startswith("Zero"):
            assert mismatches == 0
        else:
            assert mismatches > 0
        print(f"  {label}: traces(len<=3)={total_traces}, commutation mismatches={mismatches}")

    # Regressions comparing simplified stepHWorldGuarded vs full Represented.World step
    # 1. Singleton discrepancy: toks=[0], budget=1 accepts addView 0 in HWorld, rejected in World
    hw_sing = ((0,), (), (), 1)
    w_sing = ((0,), (), (), (), 1, True, ())
    assert step_hworld_guarded(hw_sing, ("addView", 0)) == ((0,), (), (0,), 0)
    assert not aug_ok_b(1, (), (0,))
    assert step_represented_add_view(w_sing, (0,)) == w_sing

    # 2. Duplicate view: [1] already in views; World rejects and keeps budget=1, HWorld debits budget
    hw_dup = ((0, 1), ((0, 1),), (1,), 1)
    w_dup = ((0, 1), ((1,),), ((0, 1),), (), 1, True, ())
    assert step_hworld_guarded(hw_dup, ("addView", 1)) == ((0, 1), ((0, 1),), (1,), 0)
    assert not aug_ok_b(2, ((1,),), (1,))
    assert step_represented_add_view(w_dup, (1,)) == w_dup

    # 3. Disabled augmentation license: augLicensed=False rejects in World, accepted in HWorld
    hw_lic = ((0, 1), ((0, 1),), (), 1)
    w_lic = ((0, 1), (), ((0, 1),), (), 1, False, ())
    assert aug_ok_b(2, (), (1,))
    assert step_represented_add_view(w_lic, (1,)) == w_lic
    assert step_hworld_guarded(hw_lic, ("addView", 1)) == ((0, 1), ((0, 1),), (1,), 0)

    # 4. No new separation: (0,1) already separated by [0]; novel [1] rejected in World, accepted in HWorld
    hw_nosep = ((0, 1), ((0, 1),), (0,), 1)
    w_nosep = ((0, 1), ((0,),), ((0, 1),), (), 1, True, ())
    assert (1,) not in w_nosep[1]
    assert not increase_b(2, ((0,),), (1,))
    assert not aug_ok_b(2, ((0,),), (1,))
    assert step_represented_add_view(w_nosep, (1,)) == w_nosep
    assert step_hworld_guarded(hw_nosep, ("addView", 1)) == ((0, 1), ((0, 1),), (0, 1), 0)

    print("\n=== [5] OQ-08: GUARD DISCREPANCY REGRESSIONS (stepHWorldGuarded VS LEGACY Represented.World) ===")
    print("  (1) Singleton data=[0], addView [0]: HWorld views=[0] (budget=0) vs Represented views=[] (budget=1, increaseB=False)")
    print("  (2) Duplicate view [1]:              HWorld views=[1] (budget=0) vs Represented views=[[1]] (budget=1, novel=False)")
    print("  (3) Disabled augLicensed=False:      HWorld views=[1] (budget=0) vs Represented views=[] (budget=1, licensed=False)")
    print("  (4) Novel view [1] with 0 new sep:   HWorld views=[0, 1] (budget=0) vs Represented views=[[0]] (budget=1, increaseB=False)")



if __name__ == "__main__":
    check_oq05()
    check_oq06()
    check_oq07()
    check_oq08()

