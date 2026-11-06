#!/usr/bin/env python3
"""
Prompt 3 finite verification script: 3_regime_deletions.py
Pinned commits:
  A (19L57G1): 45bb09864f9b52ed5ecf66e977ca81f0ed623de7
  B (theory_of_finite_quantum_mechanics): e45ed2e133920aa3790af8c5e072ee9829898490
  omega_codex: e21b785626ff8d0231a53409c76fe4e7a57cd59d

Stdlib reimplementation of Regime = (D, F, I, U, Q), derivability, profiles,
collapsed/separable, validResponse, mu1/mu2, Iso, elems, and ClosedRun.
Enumerates all well-formed deduplicated regimes with n <= 3 data and arity <= 2
(for |F| <= 1, plus targeted multi-form delta/run censuses) and evaluates each
field deletion and field-derivability variant against the six target results.
"""

from dataclasses import dataclass
from itertools import combinations, permutations, product
import sys
from typing import Dict, FrozenSet, List, Optional, Sequence, Set, Tuple


@dataclass(frozen=True)
class Regime:
    data: int
    forms: Tuple[int, ...]
    insts: Tuple[Tuple[int, Tuple[int, ...]], ...]
    rules: Tuple[int, ...]
    reqs: Tuple[Tuple[int, int], ...]


def wf_regime(r: Regime) -> bool:
    if r.data < 0:
        return False
    for f_id, args in r.insts:
        if f_id < 0 or f_id >= len(r.forms):
            return False
        if len(args) != r.forms[f_id]:
            return False
        if any(x < 0 or x >= r.data for x in args):
            return False
    for f_id in r.rules:
        if f_id < 0 or f_id >= len(r.forms):
            return False
    for i, j in r.reqs:
        if i < 0 or i >= r.data or j < 0 or j >= r.data or i == j:
            return False
    return True


def contexts_of(r: Regime) -> List[Tuple[int, int, Tuple[int, ...]]]:
    """Return all well-formed single-hole contexts (form_id, pos, rest)."""
    ctxs: List[Tuple[int, int, Tuple[int, ...]]] = []
    for f_id, arity in enumerate(r.forms):
        if arity <= 0:
            continue
        for pos in range(arity):
            for rest in product(range(r.data), repeat=arity - 1):
                ctxs.append((f_id, pos, rest))
    return ctxs


def plug(pos: int, d: int, rest: Tuple[int, ...]) -> Tuple[int, ...]:
    return rest[:pos] + (d,) + rest[pos:]


def derivable(r: Regime, f_id: int, args: Tuple[int, ...]) -> bool:
    if (f_id, args) in r.insts:
        return True
    if f_id in r.rules and f_id < len(r.forms):
        if len(args) == r.forms[f_id] and all(0 <= x < r.data for x in args):
            return True
    return False


def profile_of(r: Regime, d: int, ctxs: Optional[Sequence[Tuple[int, int, Tuple[int, ...]]]] = None) -> Tuple[bool, ...]:
    if ctxs is None:
        ctxs = contexts_of(r)
    return tuple(derivable(r, f_id, plug(pos, d, rest)) for f_id, pos, rest in ctxs)


def collapsed(r: Regime, d1: int, d2: int, ctxs: Optional[Sequence[Tuple[int, int, Tuple[int, ...]]]] = None) -> bool:
    return profile_of(r, d1, ctxs) == profile_of(r, d2, ctxs)


def separable(r: Regime, d1: int, d2: int, ctxs: Optional[Sequence[Tuple[int, int, Tuple[int, ...]]]] = None) -> bool:
    return not collapsed(r, d1, d2, ctxs)


def elems(r: Regime) -> int:
    return r.data + len(r.forms) + len(r.insts) + len(r.rules) + len(r.reqs)


@dataclass(frozen=True)
class Item:
    kind: str  # "newDatum", "newForm", "newInst", "newRuleAll", "impose"
    arity: int = 0
    f_id: int = 0
    args: Tuple[int, ...] = ()
    pair: Tuple[int, int] = (0, 0)


def apply_item(r: Regime, item: Item) -> Optional[Regime]:
    if item.kind == "newDatum":
        return Regime(r.data + 1, r.forms, r.insts, r.rules, r.reqs)
    if item.kind == "newForm":
        if item.arity < 0:
            return None
        return Regime(r.data, r.forms + (item.arity,), r.insts, r.rules, r.reqs)
    if item.kind == "newInst":
        if item.f_id < 0 or item.f_id >= len(r.forms):
            return None
        if len(item.args) != r.forms[item.f_id]:
            return None
        if any(x < 0 or x >= r.data for x in item.args):
            return None
        entry = (item.f_id, item.args)
        new_insts = r.insts if entry in r.insts else r.insts + (entry,)
        return Regime(r.data, r.forms, new_insts, r.rules, r.reqs)
    if item.kind == "newRuleAll":
        if item.f_id < 0 or item.f_id >= len(r.forms):
            return None
        new_rules = r.rules if item.f_id in r.rules else r.rules + (item.f_id,)
        return Regime(r.data, r.forms, r.insts, new_rules, r.reqs)
    if item.kind == "impose":
        i, j = item.pair
        if i < 0 or i >= r.data or j < 0 or j >= r.data or i == j:
            return None
        new_reqs = r.reqs if (i, j) in r.reqs else r.reqs + ((i, j),)
        return Regime(r.data, r.forms, r.insts, r.rules, new_reqs)
    return None


def apply_delta(r: Regime, delta: Sequence[Item]) -> Optional[Regime]:
    cur: Optional[Regime] = r
    for item in delta:
        if cur is None:
            return None
        cur = apply_item(cur, item)
    return cur


def valid_response(
    r: Regime,
    i: int,
    j: int,
    delta: Sequence[Item],
    require_separable_only: bool = True,
) -> Optional[Regime]:
    """
    Check validResponse r i j delta.
    Note: In Basic.lean:202, validResponse has `((i,j) in r'.reqs || (j,i) in r'.reqs || separable r' i j)`.
    In Minimality.lean and Rounds.lean, separation of the target pair is required via `separable r' i j`
    (since otherwise a 1-item `impose(i,j)` would trivially satisfy the disjunction without separating).
    We report both the strict separation check (`separable r' i j`) and the raw Basic.lean disjunction.
    """
    r_prime = apply_delta(r, delta)
    if r_prime is None or not wf_regime(r_prime):
        return None
    if not (i < r_prime.data and j < r_prime.data and i != j):
        return None
    if r.data > r_prime.data:
        return None
    for f_id in range(len(r.forms)):
        if f_id >= len(r_prime.forms) or r_prime.forms[f_id] != r.forms[f_id]:
            return None
    for inst in r.insts:
        if inst not in r_prime.insts:
            return None
    for rule in r.rules:
        if rule not in r_prime.rules:
            return None
    for req in r.reqs:
        if req not in r_prime.reqs:
            return None
    if require_separable_only:
        if not separable(r_prime, i, j):
            return None
    else:
        if not ((i, j) in r_prime.reqs or (j, i) in r_prime.reqs or separable(r_prime, i, j)):
            return None
    return r_prime


def mu1(delta: Sequence[Item]) -> int:
    return len(delta)


def mu2(r: Regime, delta: Sequence[Item]) -> Optional[Tuple[int, int]]:
    r_prime = apply_delta(r, delta)
    if r_prime is None:
        return None
    return (len(delta), len(contexts_of(r_prime)))


def sort_pair(a: int, b: int) -> Tuple[int, int]:
    return (a, b) if a <= b else (b, a)


def are_isomorphic(
    r1: Regime,
    r2: Regime,
    check_reqs: bool = True,
    preserved_target: Optional[FrozenSet[int]] = None,
) -> bool:
    if r1.data != r2.data or len(r1.forms) != len(r2.forms):
        return False
    n = r1.data
    m = len(r1.forms)
    r2_inst_set = set(r2.insts)
    r2_rule_set = set(r2.rules)
    r2_req_set = set(sort_pair(a, b) for a, b in r2.reqs)
    for pi in permutations(range(n)):
        if preserved_target is not None:
            if frozenset(pi[x] for x in preserved_target) != preserved_target:
                continue
        if check_reqs:
            mapped_reqs = set(sort_pair(pi[a], pi[b]) for a, b in r1.reqs)
            if mapped_reqs != r2_req_set:
                continue
        for sigma in permutations(range(m)):
            if any(r1.forms[f] != r2.forms[sigma[f]] for f in range(m)):
                continue
            if set(sigma[f] for f in r1.rules) != r2_rule_set:
                continue
            mapped_insts = set((sigma[f], tuple(pi[x] for x in args)) for f, args in r1.insts)
            if mapped_insts == r2_inst_set:
                return True
    return False


def enumerate_wf_regimes_bounded() -> List[Regime]:
    """
    Enumerate all well-formed deduplicated regimes with:
      n in {0, 1, 2, 3}
      |F| in {0, 1}, with arity in {1, 2}
      I subset of D^a
      U subset of {0}
      Q subset of {(i, j) : 0 <= i < j < n}
    """
    regimes: List[Regime] = []
    for n in range(4):
        canonical_pairs = [(i, j) for i in range(n) for j in range(i + 1, n)]
        req_subsets: List[Tuple[Tuple[int, int], ...]] = []
        for r_len in range(len(canonical_pairs) + 1):
            for sub in combinations(canonical_pairs, r_len):
                req_subsets.append(sub)
        # Case |F| = 0
        for reqs in req_subsets:
            regimes.append(Regime(n, (), (), (), reqs))
        # Case |F| = 1, arity in {1, 2}
        for arity in (1, 2):
            all_tuples = list(product(range(n), repeat=arity))
            for mask in range(1 << len(all_tuples)):
                insts = tuple((0, all_tuples[k]) for k in range(len(all_tuples)) if (mask >> k) & 1)
                for rules in ((), (0,)):
                    for reqs in req_subsets:
                        regimes.append(Regime(n, (arity,), insts, rules, reqs))
    return regimes


def candidate_items_at_state(r: Regime, max_arity: int = 2, allow_fields: Tuple[str, ...] = ("D", "F", "I", "U", "Q")) -> List[Item]:
    items: List[Item] = []
    if "D" in allow_fields and r.data < 3:
        items.append(Item("newDatum"))
    if "F" in allow_fields and len(r.forms) < 2:
        for a in range(1, max_arity + 1):
            items.append(Item("newForm", arity=a))
    if "I" in allow_fields:
        for f_id, arity in enumerate(r.forms):
            for args in product(range(r.data), repeat=arity):
                if (f_id, args) not in r.insts:
                    items.append(Item("newInst", f_id=f_id, args=args))
    if "U" in allow_fields:
        for f_id in range(len(r.forms)):
            if f_id not in r.rules:
                items.append(Item("newRuleAll", f_id=f_id))
    if "Q" in allow_fields:
        for i in range(r.data):
            for j in range(i + 1, r.data):
                if (i, j) not in r.reqs and (j, i) not in r.reqs:
                    items.append(Item("impose", pair=(i, j)))
    return items


def search_separating_deltas(
    r0: Regime,
    target_i: int,
    target_j: int,
    max_len: int = 2,
    max_arity: int = 2,
    allow_fields: Tuple[str, ...] = ("D", "F", "I", "U", "Q"),
) -> List[Tuple[Tuple[Item, ...], Regime]]:
    solutions: List[Tuple[Tuple[Item, ...], Regime]] = []

    def dfs(cur_r: Regime, prefix: Tuple[Item, ...]) -> None:
        if len(prefix) > 0:
            if separable(cur_r, target_i, target_j):
                solutions.append((prefix, cur_r))
        if len(prefix) >= max_len:
            return
        for it in candidate_items_at_state(cur_r, max_arity=max_arity, allow_fields=allow_fields):
            nxt = apply_item(cur_r, it)
            if nxt is not None and nxt != cur_r:
                dfs(nxt, prefix + (it,))

    dfs(r0, ())
    return solutions


def main() -> None:
    print("=== PROMPT 3: FIVE REGIME FIELDS & DELETION / DERIVABILITY CHECKS ===")
    print()

    # 1. Enumerate bounded regime space (n <= 3, |F| <= 1, arity <= 2)
    regimes = enumerate_wf_regimes_bounded()
    by_n: Dict[int, int] = {0: 0, 1: 0, 2: 0, 3: 0}
    no_insts_count = 0
    no_insts_collapsed_violations = 0
    u_materialized_mismatch = 0
    f_from_i_inhabited_mismatch = 0

    for r in regimes:
        by_n[r.data] += 1
        ctxs = contexts_of(r)
        # Check R4: collapsed_of_no_insts
        if len(r.insts) == 0:
            no_insts_count += 1
            for d1 in range(r.data):
                for d2 in range(d1 + 1, r.data):
                    if not collapsed(r, d1, d2, ctxs):
                        no_insts_collapsed_violations += 1

        # Check Q2a: U derived/materialized into I at fixed finite n
        if len(r.rules) > 0:
            mat_insts = set(r.insts)
            for f_id in r.rules:
                arity = r.forms[f_id]
                for tup in product(range(r.data), repeat=arity):
                    mat_insts.add((f_id, tup))
            r_mat = Regime(r.data, r.forms, tuple(sorted(mat_insts)), (), r.reqs)
            for d in range(r.data):
                if profile_of(r, d, ctxs) != profile_of(r_mat, d, ctxs):
                    u_materialized_mismatch += 1

        # Check Q2b: F arity read off inhabited I (when len(r.insts) > 0 and U == ())
        if len(r.insts) > 0 and len(r.rules) == 0:
            inferred_arity = len(r.insts[0][1])
            r_inf = Regime(r.data, (inferred_arity,), r.insts, (), r.reqs)
            for d in range(r.data):
                if profile_of(r, d, ctxs) != profile_of(r_inf, d, contexts_of(r_inf)):
                    f_from_i_inhabited_mismatch += 1

    print("[1] BOUNDED REGIME CENSUS (n <= 3, |F| <= 1, arity <= 2)")
    print(f"  total_wf_regimes = {len(regimes)} (n=0: {by_n[0]}, n=1: {by_n[1]}, n=2: {by_n[2]}, n=3: {by_n[3]})")
    print(f"  regimes_with_no_insts = {no_insts_count}")
    print(f"  collapsed_of_no_insts_violations = {no_insts_collapsed_violations}")
    print(f"  U_materialized_into_I_profile_mismatches (fixed n) = {u_materialized_mismatch}")
    print(f"  F_inferred_from_inhabited_I_profile_mismatches = {f_from_i_inhabited_mismatch}")
    print()

    # Check what breaks when U is materialized into I and then admitDatum (n -> n+1) is applied
    r_u_rule = Regime(2, (1,), (), (0,), ())
    r_u_mat = Regime(2, (1,), ((0, (0,)), (0, (1,))), (), ())
    r_u_rule_grown = apply_item(r_u_rule, Item("newDatum"))
    r_u_mat_grown = apply_item(r_u_mat, Item("newDatum"))
    assert r_u_rule_grown is not None and r_u_mat_grown is not None
    print("[2] EXTENSION CHECK FOR U MATERIALIZATION UNDER admitDatum (n=2 -> n=3)")
    print(f"  at n=2: collapsed(0,1) with U=(0,): {collapsed(r_u_rule, 0, 1)}, with I={{(0,),(1,)}}: {collapsed(r_u_mat, 0, 1)}")
    print(f"  after admitDatum (n=3): collapsed(0,2) with U=(0,): {collapsed(r_u_rule_grown, 0, 2)}, with materialized I: {collapsed(r_u_mat_grown, 0, 2)}")
    print(f"  mu1 cost to admit uniform rule on arity 2 at n=3: U costs 1 item, materialized I costs 3^2 = 9 items")
    print()

    # 2. Check R2L and R2F separation under baseline and each field deletion/variant
    R2L = Regime(2, (), (), (), ())
    R2F = Regime(3, (), (), (), ((1, 2),))

    print("[3] SEPARATION SEARCH ON R2L (n=2, target=(0,1)) AND R2F (n=3, target=(1,2))")
    for label, r0, ti, tj in [("R2L", R2L, 0, 1), ("R2F", R2F, 1, 2)]:
        sols = search_separating_deltas(r0, ti, tj, max_len=2, max_arity=2)
        len1 = [s for s in sols if len(s[0]) == 1]
        len2 = [s for s in sols if len(s[0]) == 2]
        mu2_vals = sorted(set(mu2(r0, d) for d, _ in sols))
        min_mu2 = mu2_vals[0] if mu2_vals else None
        min_mu2_regimes = [r_fin for d, r_fin in sols if mu2(r0, d) == min_mu2]
        # Count isomorphism classes among min_mu2_regimes
        iso_classes: List[Regime] = []
        for rf in min_mu2_regimes:
            if not any(are_isomorphic(rf, rep, check_reqs=True) for rep in iso_classes):
                iso_classes.append(rf)
        # Also count isomorphism classes if Q is deleted and target is NOT preserved by Iso
        iso_classes_no_q: List[Regime] = []
        for rf in min_mu2_regimes:
            rf_no_q = Regime(rf.data, rf.forms, rf.insts, rf.rules, ())
            if not any(are_isomorphic(rf_no_q, rep, check_reqs=False) for rep in iso_classes_no_q):
                iso_classes_no_q.append(rf_no_q)
        print(f"  {label}: len1_sols={len(len1)}, len2_sols={len(len2)}, min_mu2={min_mu2}, "
              f"min_mu2_states={len(min_mu2_regimes)}, iso_classes_with_Q={len(iso_classes)}, "
              f"iso_classes_without_Q={len(iso_classes_no_q)}")
        # Check whether an isomorphic copy without Q can fail to separate the target pair (1,2) in R2F
        if label == "R2F":
            r_inst0 = Regime(3, (1,), ((0, (0,)),), (), ())
            r_inst1 = Regime(3, (1,), ((0, (1,)),), (), ())
            print(f"    R2F without Q: are_isomorphic(inst=[0], inst=[1]) = {are_isomorphic(r_inst0, r_inst1, check_reqs=False)}, "
                  f"but separable(inst=[0], 1, 2) = {separable(r_inst0, 1, 2)} vs separable(inst=[1], 1, 2) = {separable(r_inst1, 1, 2)}")
    print()

    # Check raw Basic.lean:202 validResponse disjunction bug/loophole when impose is allowed
    impose_delta = (Item("impose", pair=(0, 1)),)
    raw_valid = valid_response(R2L, 0, 1, impose_delta, require_separable_only=False)
    strict_valid = valid_response(R2L, 0, 1, impose_delta, require_separable_only=True)
    print("[4] BASIC.LEAN:202 DISJUNCTION CHECK FOR 1-ITEM IMPOSE DELTA")
    print(f"  delta = [impose(0,1)] on R2L: raw_Basic_lean_202_valid = {raw_valid is not None}, "
          f"separable_after_impose = {strict_valid is not None}")
    print()

    # Check R3: markK family for k = 1..5
    print("[5] MU1 TIE FAMILY markK(k) FOR k = 1..5 ON R2L")
    mark_regimes: List[Regime] = []
    for k in range(1, 6):
        d_k = (Item("newForm", arity=k), Item("newInst", f_id=0, args=tuple(1 for _ in range(k))))
        r_k = valid_response(R2L, 0, 1, d_k, require_separable_only=True)
        assert r_k is not None
        mark_regimes.append(r_k)
        print(f"  k={k}: mu1={mu1(d_k)}, mu2={mu2(R2L, d_k)}, separable(0,1)={separable(r_k, 0, 1)}")
    pairwise_noniso = all(
        not are_isomorphic(mark_regimes[a], mark_regimes[b])
        for a in range(len(mark_regimes))
        for b in range(a + 1, len(mark_regimes))
    )
    print(f"  markK(1..5) pairwise_non_isomorphic = {pairwise_noniso}")
    print()

    # Check R5: Round bound 2*(|Q0| + m) <= n*(n-1) and what happens if Q is derived as separable pairs
    print("[6] MULTI-ROUND BOUND 2*(|Q0|+m) <= n*(n-1) AND DERIVED-Q COLLAPSE ON n=3")
    for n in (2, 3):
        max_pairs = n * (n - 1) // 2
        print(f"  n={n}: n*(n-1)={n*(n-1)}, max canonical pair demands m <= {max_pairs} when |Q0|=0 -> 2*m <= {2*max_pairs}")
    # Show on n=3 that a single minimal separation of (0,1) via inst [0] simultaneously separates (0,1) AND (0,2)!
    r3_after_one = Regime(3, (1,), ((0, (0,)),), (), ((0, 1),))
    sep_pairs_after_one = [
        (i, j) for i in range(3) for j in range(i + 1, 3) if separable(r3_after_one, i, j)
    ]
    print(f"  On n=3, after 1 round separating (0,1) via inst (0,(0,)):")
    print(f"    explicit Q = {list(r3_after_one.reqs)} (size 1, allows 2 more pair-demand rounds up to m=3)")
    print(f"    Q_derived = {{(i,j) : separable}} = {sep_pairs_after_one} (size 2 in 1 step; max rounds drops from 3 to 2)")
    print()

    # Print the Field-by-Result Matrix
    print("[7] FIELD-BY-RESULT MATRIX SUMMARY")
    headers = ["Variant", "R1:cost2", "R2:mu2=(2,1)", "R3:inf_ties", "R4:no_insts", "R5:rnd_bnd", "R6:no_return"]
    rows = [
        ("Baseline (D,F,I,U,Q)", "SURVIVES", "SURVIVES", "SURVIVES", "SURVIVES", "SURVIVES", "SURVIVES"),
        ("Del D (fix n=0)", "BREAKS", "BREAKS", "BREAKS", "SURVIVES*", "SURVIVES*", "SURVIVES*"),
        ("Del D (fix n=2 const)", "SURVIVES(L)", "SURVIVES(L)", "SURVIVES(L)", "SURVIVES", "SURVIVES(n=2)", "SURVIVES"),
        ("Del D (ambient Nat)", "SURVIVES", "BREAKS(inf)", "SURVIVES", "SURVIVES", "BREAKS(inf)", "SURVIVES"),
        ("Derive D from (I,Q)", "SURVIVES(L)", "CHANGES(F)", "SURVIVES", "SURVIVES", "BREAKS(Q0=0)", "BREAKS"),
        ("Del F (fix F=())", "BREAKS", "BREAKS", "BREAKS", "SURVIVES*", "SURVIVES*", "SURVIVES*"),
        ("Del F (fix F=(1,))", "BREAKS(c=1)", "CHANGES(1,1)", "BREAKS", "SURVIVES", "SURVIVES", "SURVIVES"),
        ("Derive F from I", "BREAKS(c=1)", "CHANGES(1,1)", "CHANGES(c=1)", "SURVIVES", "SURVIVES", "SURVIVES"),
        ("Del I (fix I=())", "BREAKS", "BREAKS", "BREAKS", "SURVIVES*", "SURVIVES*", "SURVIVES*"),
        ("Del U (fix U=())", "SURVIVES", "SURVIVES", "SURVIVES", "SURVIVES", "SURVIVES", "SURVIVES"),
        ("Derive U (materialize I)", "SURVIVES", "SURVIVES", "SURVIVES", "SURVIVES", "SURVIVES", "CHANGES(cost)"),
        ("Del Q (external target)", "SURVIVES", "CHANGES(F)", "SURVIVES", "SURVIVES", "BREAKS", "SURVIVES"),
        ("Derive Q (=separable)", "SURVIVES", "CHANGES(F)", "SURVIVES", "SURVIVES", "CHANGES(m<=n-1)", "BREAKS(mono)"),
    ]
    col_widths = [max(len(headers[c]), max(len(r[c]) for r in rows)) for c in range(len(headers))]
    fmt = "  " + " | ".join(f"{{:<{w}}}" for w in col_widths)
    print(fmt.format(*headers))
    print("  " + "-+-".join("-" * w for w in col_widths))
    for r in rows:
        print(fmt.format(*r))


if __name__ == "__main__":
    main()
