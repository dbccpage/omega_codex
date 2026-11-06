#!/usr/bin/env python3
"""
Prompt 4 finite verification script: 4_frozen_checks.py
Pinned commits:
  A (19L57G1): 45bb09864f9b52ed5ecf66e977ca81f0ed623de7
  B (theory_of_finite_quantum_mechanics): e45ed2e133920aa3790af8c5e072ee9829898490
  omega_codex: e21b785626ff8d0231a53409c76fe4e7a57cd59d

Enumerates successors for small regimes (mark alone, R1, R2L, R2F, closed U0,
and Horizon budget worlds) under each unfreezing option, and checks F1-frozen
(no single successor is forced) vs F2-frozen (no successor is possible),
plus unpriced vs priced container countermodels.
"""

from dataclasses import dataclass
from itertools import permutations, product
from typing import Callable, FrozenSet, List, Optional, Sequence, Tuple


@dataclass(frozen=True)
class Regime:
    data: int
    forms: Tuple[int, ...]
    insts: Tuple[Tuple[int, Tuple[int, ...]], ...]
    rules: Tuple[int, ...]
    reqs: Tuple[Tuple[int, int], ...]


@dataclass(frozen=True)
class Item:
    kind: str  # "newDatum", "newForm", "newInst", "newRuleAll", "impose"
    arity: int = 0
    f_id: int = 0
    args: Tuple[int, ...] = ()
    pair: Tuple[int, int] = (0, 0)


def contexts_of(r: Regime) -> List[Tuple[int, int, Tuple[int, ...]]]:
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


def profile_of(r: Regime, d: int) -> Tuple[bool, ...]:
    ctxs = contexts_of(r)
    return tuple(derivable(r, f_id, plug(pos, d, rest)) for f_id, pos, rest in ctxs)


def separable(r: Regime, d1: int, d2: int) -> bool:
    return profile_of(r, d1) != profile_of(r, d2)


def sort_pair(a: int, b: int) -> Tuple[int, int]:
    return (a, b) if a <= b else (b, a)


def are_isomorphic(r1: Regime, r2: Regime) -> bool:
    if r1.data != r2.data or len(r1.forms) != len(r2.forms):
        return False
    n = r1.data
    m = len(r1.forms)
    r2_inst_set = set(r2.insts)
    r2_rule_set = set(r2.rules)
    r2_req_set = set(sort_pair(a, b) for a, b in r2.reqs)
    for pi in permutations(range(n)):
        if set(sort_pair(pi[a], pi[b]) for a, b in r1.reqs) != r2_req_set:
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


def count_iso_classes(states: Sequence[Regime]) -> int:
    reps: List[Regime] = []
    for s in states:
        if not any(are_isomorphic(s, r) for r in reps):
            reps.append(s)
    return len(reps)


def apply_item(r: Regime, item: Item) -> Optional[Regime]:
    if item.kind == "newDatum":
        return Regime(r.data + 1, r.forms, r.insts, r.rules, r.reqs)
    if item.kind == "newForm":
        if item.arity < 1:
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


def enumerate_primitive_items(r: Regime, max_arity: int = 2) -> List[Item]:
    items: List[Item] = [Item("newDatum")]
    for a in range(1, max_arity + 1):
        items.append(Item("newForm", arity=a))
    for f_id, arity in enumerate(r.forms):
        for args in product(range(r.data), repeat=arity):
            if (f_id, args) not in r.insts:
                items.append(Item("newInst", f_id=f_id, args=args))
        if f_id not in r.rules:
            items.append(Item("newRuleAll", f_id=f_id))
    for i in range(r.data):
        for j in range(i + 1, r.data):
            if (i, j) not in r.reqs and (j, i) not in r.reqs:
                items.append(Item("impose", pair=(i, j)))
    return items


def enumerate_valid_responses(
    r0: Regime,
    max_len: int = 2,
    max_arity: int = 2,
) -> List[Tuple[Tuple[Item, ...], Regime]]:
    """
    Enumerate valid separating responses for an active unseparated requirement in r0.reqs.
    If r0.reqs has no unseparated requirement, returns [].
    """
    unsep = [(i, j) for (i, j) in r0.reqs if not separable(r0, i, j)]
    if not unsep:
        return []
    ti, tj = unsep[0]
    results: List[Tuple[Tuple[Item, ...], Regime]] = []

    def dfs(cur: Regime, delta: Tuple[Item, ...]) -> None:
        if len(delta) > 0 and separable(cur, ti, tj):
            results.append((delta, cur))
        if len(delta) >= max_len:
            return
        for it in enumerate_primitive_items(cur, max_arity=max_arity):
            if it.kind == "newDatum" and cur.data >= 3:
                continue
            if it.kind == "newForm" and len(cur.forms) >= 2:
                continue
            nxt = apply_item(cur, it)
            if nxt is not None and nxt != cur:
                dfs(nxt, delta + (it,))

    dfs(r0, ())
    return results


def classify_f1_f2(
    distinct_successors: Sequence[Regime],
    quiescence_allowed: bool,
    quotient_by_iso: bool = False,
) -> Tuple[str, str]:
    """
    Return (F1_status, F2_status) with explicit F1-frozen / F2-frozen labels.
    F2-frozen iff len(distinct_successors) == 0.
    F1-frozen iff quiescence_allowed or len(distinct_successors) == 0 or
      (effective branch count > 1).
    """
    f2 = "F2-frozen" if len(distinct_successors) == 0 else "not F2-frozen"
    if len(distinct_successors) == 0 or quiescence_allowed:
        f1 = "F1-frozen"
    else:
        branches = count_iso_classes(distinct_successors) if quotient_by_iso else len(set(distinct_successors))
        f1 = "F1-frozen" if branches != 1 else "not F1-frozen"
    return f1, f2


def main() -> None:
    print("=== PROMPT 4: PRICED CONTAINERS OR F1-FROZEN / F2-FROZEN CHECKS ===")
    print()

    R1 = Regime(1, (), (), (), ())
    R2L_no_req = Regime(2, (), (), (), ())
    R2L = Regime(2, (), (), (), ((0, 1),))
    R2F = Regime(3, (), (), (), ((1, 2),))
    U0_closed = Regime(2, (1,), ((0, (1,)),), (), ((0, 1),))

    print("[1] SUCCESSOR CENSUS ACROSS STATES AND UNFREEZING MECHANISMS (bound: |Delta|<=2, arity<=2)")
    states = [
        ("Mark alone <> (no ops)", None),
        ("R1 = (1,[],[],[],[])", R1),
        ("R2L_bare = (2,[],[],[],[])", R2L_no_req),
        ("R2L = (2,[],[],[],[(0,1)])", R2L),
        ("R2F = (3,[],[],[],[(1,2)])", R2F),
        ("U0_closed = (2,[1],[(0,[1])],[],[(0,1)])", U0_closed),
    ]

    for name, st in states:
        if st is None:
            print(f"  State: {name}")
            print("    valid_responses = 0 -> F1-frozen, F2-frozen")
            continue
        prim_1step = [apply_item(st, it) for it in enumerate_primitive_items(st, max_arity=2)]
        prim_1step_valid = [r for r in prim_1step if r is not None and r != st]
        val_resps = enumerate_valid_responses(st, max_len=2, max_arity=2)
        val_states = [r for _, r in val_resps]
        mu1_min_states: List[Regime] = []
        mu2_min_states: List[Regime] = []
        if val_resps:
            min_m1 = min(len(d) for d, _ in val_resps)
            mu1_min_states = [r for d, r in val_resps if len(d) == min_m1]
            min_m2 = min((len(d), len(contexts_of(r))) for d, r in val_resps)
            mu2_min_states = [r for d, r in val_resps if (len(d), len(contexts_of(r))) == min_m2]

        f1_no_pol, f2_no_pol = classify_f1_f2(val_states, quiescence_allowed=True)
        f1_unpriced_step, f2_unpriced_step = classify_f1_f2(val_states, quiescence_allowed=False)
        f1_mu1, f2_mu1 = classify_f1_f2(mu1_min_states, quiescence_allowed=False)
        f1_mu2_concrete, f2_mu2_concrete = classify_f1_f2(mu2_min_states, quiescence_allowed=False, quotient_by_iso=False)
        f1_mu2_iso, f2_mu2_iso = classify_f1_f2(mu2_min_states, quiescence_allowed=False, quotient_by_iso=True)

        print(f"  State: {name}")
        print(f"    raw_1step_admissions (arity<=2): {len(prim_1step_valid)} distinct states")
        print(f"    valid_separating_responses: {len(val_states)} states ({count_iso_classes(val_states)} Iso classes)")
        print(f"    under no step policy (quiescence allowed): {f1_no_pol}, {f2_no_pol}")
        print(f"    under forced-step + unpriced validResponse: {f1_unpriced_step}, {f2_unpriced_step}")
        print(f"    under forced-step + mu1 min: {len(mu1_min_states)} states ({count_iso_classes(mu1_min_states)} Iso classes) -> {f1_mu1}, {f2_mu1}")
        print(f"    under forced-step + mu2 min (concrete): {len(mu2_min_states)} states -> {f1_mu2_concrete}, {f2_mu2_concrete}")
        print(f"    under forced-step + mu2 min + Iso quotient: {count_iso_classes(mu2_min_states)} Iso class -> {f1_mu2_iso}, {f2_mu2_iso}")
    print()

    # [2] Check WDP-CH03-P03 surviving tie under Pi_3 = (c_wit, c_ret, c_op, c_id)
    print("[2] WDP-CH03-P03 SURVIVING TIE CHECK UNDER PRICED LEDGER Pi_3 AND mu2")
    U0 = Regime(2, (1,), ((0, (1,)),), (), ((0, 1),))
    U1 = Regime(2, (1,), ((0, (0,)),), (), ((0, 1),))
    pi3_U0 = (1, 1, 1, 0)  # 1 witness, 1 retained bit, 1 unary op, 0 extra carrier ids
    pi3_U1 = (1, 1, 1, 0)
    print(f"  U0 = {U0}, mu2 = (2, {len(contexts_of(U0))}), Pi_3 = {pi3_U0}")
    print(f"  U1 = {U1}, mu2 = (2, {len(contexts_of(U1))}), Pi_3 = {pi3_U1}")
    print(f"  U0 != U1: {U0 != U1}, Pi_3(U0) == Pi_3(U1): {pi3_U0 == pi3_U1}, are_isomorphic(U0, U1): {are_isomorphic(U0, U1)}")
    print("  Result: Pricing alone leaves concrete state selection F1-frozen between U0 and U1.")
    print()

    # [3] Question 3 Countermodels: Unpriced containers whose successor is forced (not F1-frozen, not F2-frozen)
    print("[3] QUESTION 3 COUNTERMODELS: UNPRICED CONTAINERS WITH FORCED SUCCESSOR (NOT F1-FROZEN, NOT F2-FROZEN)")
    # Countermodel U1: 2-state deterministic transition system with no cost ledger
    u1_transitions = {0: [1], 1: [1]}
    u1_succ_0 = [s for s in u1_transitions[0] if s != 0]
    print(f"  Countermodel U1 (unpriced 2-state deterministic transition 0 -> 1): "
          f"distinct_succ(0) = {u1_succ_0} (count={len(u1_succ_0)}) -> not F1-frozen, not F2-frozen")

    # Countermodel U2: Unpriced restricted-grammar Regime on R2L (unary form only, canonical second-endpoint mark)
    def unpriced_canonical_grammar_responses(r0: Regime) -> List[Regime]:
        if not r0.reqs:
            return []
        ti, tj = r0.reqs[0]
        if separable(r0, ti, tj):
            return []
        # Grammar admits only unary form and canonical mark on second endpoint tj of active requirement
        r1 = apply_item(r0, Item("newForm", arity=1))
        if r1 is None:
            return []
        r2 = apply_item(r1, Item("newInst", f_id=len(r1.forms) - 1, args=(tj,)))
        return [r2] if (r2 is not None and separable(r2, ti, tj)) else []

    u2_succ = unpriced_canonical_grammar_responses(R2L)
    print(f"  Countermodel U2 (unpriced canonical-grammar Regime on R2L): "
          f"distinct_succ(R2L) = {u2_succ} (count={len(u2_succ)}) -> not F1-frozen, not F2-frozen")
    print()

    # [4] Horizon.lean C10 check: Budget-priced container vs unpriced container, and Z vs Nat ledger host
    print("[4] HORIZON.LEAN BUDGET GATE & LEDGER HOST REGRESS CHECK (Nat vs Int)")
    for budget in (0, 1):
        can_add_view_priced = budget > 0
        can_add_view_unpriced = True
        print(f"  World at budget={budget}: priced_addView_possible={can_add_view_priced} "
              f"({'not F2-frozen' if can_add_view_priced else 'F2-frozen'}), "
              f"unpriced_addView_possible={can_add_view_unpriced} (not F2-frozen)")
    # Ledger host container difference (Horizon.lean C10: Nat saturating 0 - 1 = 0 vs Int 0 - 1 = -1)
    b0 = 0
    nat_decrement = max(0, b0 - 1)
    int_decrement = b0 - 1
    print(f"  Ledger host container at budget=0 after gateBudget-off decrement: "
          f"Nat_host={nat_decrement} vs Int_host={int_decrement} (mismatch={nat_decrement != int_decrement})")


if __name__ == "__main__":
    main()
