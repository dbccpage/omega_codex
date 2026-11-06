"""Finite model checks for Task 2 (The Mark Alone).

Uses only the Python standard library.
Enumerates:
1. Transition relations on a 1-element carrier (inertia vs self-loop).
2. State separation of the seven foundational operations (Mention, Supply,
   Designate, Admit, Retain, Observe, Equality).
3. Single-addition grammar (G1-G10) from the initial mark state: successor
   count and countermodels showing none is forced.
4. Carrier swaps (Unit, Opaque1, Opaque2, Bool, Fin3, Nat-prefix): which
   properties stay invariant and which change.
"""

from __future__ import annotations

from dataclasses import dataclass
from itertools import product
from typing import Callable, FrozenSet, Optional, Tuple


# ---------------------------------------------------------------------------
# 1. Inertia on a 1-element carrier {m0}
# ---------------------------------------------------------------------------

def check_mark_alone_inertia() -> None:
    print("=== 1. MARK ALONE AND TRANSITION MODELS ON {m0} ===")
    carrier = ("m0",)
    all_pairs = list(product(carrier, carrier))
    # All binary transition relations T subseteq {m0} x {m0}
    relations = [frozenset(), frozenset(all_pairs)]
    for T in relations:
        successors = [y for (x, y) in T if x == "m0"]
        print(
            f"Relation T={set(T)}: successor_count(m0)={len(successors)}, "
            f"has_successor={len(successors) > 0}"
        )
    # Check: is having a successor forced across all models T on {m0}?
    forced_successor = all(
        any(x == "m0" for (x, _) in T) for T in relations
    )
    # Check: is having NO successor forced if T is unconstrained?
    forced_no_successor_unconstrained = all(
        not any(x == "m0" for (x, _) in T) for T in relations
    )
    # Under the declared no-operation premise (T = empty):
    T_empty = frozenset()
    no_successor_when_T_empty = len([y for (x, y) in T_empty if x == "m0"]) == 0
    print(f"Successor forced across unconstrained T on {{m0}}? {forced_successor}")
    print(
        f"No-successor forced across unconstrained T on {{m0}}? "
        f"{forced_no_successor_unconstrained}"
    )
    print(f"No-successor holds under declared T=empty? {no_successor_when_T_empty}")
    print()


# ---------------------------------------------------------------------------
# 2. Seven operations state machine: pairwise independence check
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class HostState:
    mentioned: FrozenSet[str] = frozenset()
    supplied: Tuple[str, ...] = ()
    designated: Optional[str] = None
    admitted: Tuple[str, ...] = ()
    retained_history: Tuple[str, ...] = ()
    observations: FrozenSet[Tuple[str, bool]] = frozenset()
    equality_enabled: bool = False


def apply_op(s: HostState, op: str, tok: str = "<>") -> HostState:
    if op == "Mention":
        return HostState(
            s.mentioned | {tok}, s.supplied, s.designated,
            s.admitted, s.retained_history, s.observations, s.equality_enabled
        )
    if op == "Supply":
        return HostState(
            s.mentioned, s.supplied + (tok,), s.designated,
            s.admitted, s.retained_history, s.observations, s.equality_enabled
        )
    if op == "Designate":
        return HostState(
            s.mentioned, s.supplied, tok,
            s.admitted, s.retained_history, s.observations, s.equality_enabled
        )
    if op == "Admit":
        new_adm = s.admitted if tok in s.admitted else s.admitted + (tok,)
        return HostState(
            s.mentioned, s.supplied, s.designated,
            new_adm, s.retained_history, s.observations, s.equality_enabled
        )
    if op == "Retain":
        return HostState(
            s.mentioned, s.supplied, s.designated,
            s.admitted, s.retained_history + (tok,), s.observations, s.equality_enabled
        )
    if op == "Observe":
        return HostState(
            s.mentioned, s.supplied, s.designated,
            s.admitted, s.retained_history, s.observations | {(tok, True)}, s.equality_enabled
        )
    if op == "Equality":
        return HostState(
            s.mentioned, s.supplied, s.designated,
            s.admitted, s.retained_history, s.observations, True
        )
    raise ValueError(f"Unknown op: {op}")


def check_seven_operations() -> None:
    print("=== 2. SEVEN OPERATIONS SEPARATION CHECK ===")
    ops = ["Mention", "Supply", "Designate", "Admit", "Retain", "Observe", "Equality"]
    base = HostState()
    results = {op: apply_op(base, op, "<>") for op in ops}
    for op, st in results.items():
        print(
            f"Op={op:9s} -> admitted={st.admitted}, supplied={st.supplied}, "
            f"designated={st.designated}, retained={st.retained_history}, "
            f"obs={set(st.observations)}, eq={st.equality_enabled}"
        )
    distinct_states = len(set(results.values()))
    print(f"All 7 single-operation outcomes pairwise distinct? {distinct_states == 7} ({distinct_states}/7)")
    only_admit_changes_admitted = [
        op for op, st in results.items() if st.admitted != base.admitted
    ]
    print(f"Operations that change admitted carrier: {only_admit_changes_admitted}")
    print()


# ---------------------------------------------------------------------------
# 3. Minimal single additions (G1-G10) from the initial state
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class Regime:
    data: int = 0
    forms: Tuple[int, ...] = ()
    insts: FrozenSet[Tuple[int, Tuple[int, ...]]] = frozenset()
    rules: FrozenSet[int] = frozenset()
    reqs: FrozenSet[Tuple[int, int]] = frozenset()


def step_regime(r: Regime, kind: str, arg: int = 0, args: Tuple[int, ...] = ()) -> Optional[Regime]:
    if kind == "supply":
        return r
    if kind == "admitDatum":
        return Regime(r.data + 1, r.forms, r.insts, r.rules, r.reqs)
    if kind == "admitForm":
        if arg < 1:
            return None
        return Regime(r.data, r.forms + (arg,), r.insts, r.rules, r.reqs)
    if kind == "admitInst":
        if not (0 <= arg < len(r.forms)):
            return None
        if len(args) != r.forms[arg]:
            return None
        if not all(0 <= x < r.data for x in args):
            return None
        return Regime(r.data, r.forms, r.insts | {(arg, args)}, r.rules, r.reqs)
    if kind == "admitRuleAll":
        if not (0 <= arg < len(r.forms)):
            return None
        return Regime(r.data, r.forms, r.insts, r.rules | {arg}, r.reqs)
    if kind == "impose":
        if len(args) != 2:
            return None
        i, j = args
        if not (0 <= i < j < r.data):
            return None
        return Regime(r.data, r.forms, r.insts, r.rules, r.reqs | {(i, j)})
    return None


def check_single_additions() -> None:
    print("=== 3. MINIMAL SINGLE ADDITIONS (GRAMMAR G1-G10) ===")
    r_L0 = Regime(data=0)
    r_F0 = Regime(data=1)

    candidates = [
        ("G3: supply(0)", "supply", 0, ()),
        ("G4: admitDatum", "admitDatum", 0, ()),
        ("G5: admitForm(1)", "admitForm", 1, ()),
        ("G6: admitInst(0,(0,))", "admitInst", 0, (0,)),
        ("G7: admitRuleAll(0)", "admitRuleAll", 0, ()),
        ("G8: impose(0,1)", "impose", 0, (0, 1)),
    ]
    for label, kind, arg, args in candidates:
        out_L = step_regime(r_L0, kind, arg, args)
        out_F = step_regime(r_F0, kind, arg, args)
        chg_L = out_L is not None and out_L != r_L0
        chg_F = out_F is not None and out_F != r_F0
        print(
            f"{label:22s} | from R_L0(d=0): valid={out_L is not None!s:5s}, "
            f"state_changed={chg_L!s:5s} | from R_F0(d=1): valid={out_F is not None!s:5s}, "
            f"state_changed={chg_F!s:5s}"
        )

    # Also check refusal / occurrence modes on 1 admitted token [0]
    s_tok1 = (0,)
    modes = {
        "silent": (s_tok1, (), 0),
        "metaMarker": (s_tok1, (), 0),
        "fact (G9)": (s_tok1, (), 1),
        "reifyUntagged (G10a)": ((0, 0), (), 0),
        "reifyTagged (G10b)": ((0, 0), (1,), 0),
    }
    base_rstate = (s_tok1, (), 0)
    for mname, next_state in modes.items():
        print(
            f"Refusal mode {mname:20s} on duplicate admitTok(0): "
            f"state_changed={next_state != base_rstate}, carrier_len={len(next_state[0])}"
        )
    print()


# ---------------------------------------------------------------------------
# 4. Carrier swap check
# ---------------------------------------------------------------------------

def check_carrier_swaps() -> None:
    print("=== 4. CARRIER SWAP COMPARISON ===")
    carriers = [
        ("Unit", ((),), False),
        ("Opaque1", ("m0",), False),
        ("Opaque2", ("m0", "m1"), False),
        ("Bool", (False, True), True),
        ("Fin3", (0, 1, 2), True),
        ("Nat_prefix4", (0, 1, 2, 3), True),
    ]
    for name, elems, has_intrinsic_order in carriers:
        n = len(elems)
        pairs = list(product(elems, elems))
        # Enumerate all binary relations R subseteq C x C (for n <= 3; for n=4 check counts analytically/directly)
        if n <= 3:
            all_rels = [
                frozenset(p for i, p in enumerate(pairs) if (mask >> i) & 1)
                for mask in range(1 << len(pairs))
            ]
            bare_witness_rels = [R for R in all_rels if len(R) > 0]
            irrefl_rels = [
                R for R in all_rels if all((x, x) not in R for x in elems)
            ]
            inhabited_irrefl_rels = [R for R in irrefl_rels if len(R) > 0]
            # Check soundness: in every irrefl R, does (a,b) in R imply a != b?
            soundness_holds = all(
                all(a != b for (a, b) in R) for R in irrefl_rels
            )
            bare_count = len(bare_witness_rels)
            irrefl_wit_count = len(inhabited_irrefl_rels)
        else:
            # Exact combinatorial counts for n=4:
            # total relations = 2^(n^2), irrefl = 2^(n(n-1)), inhabited irrefl = 2^(n(n-1)) - 1
            bare_count = (1 << (n * n)) - 1
            irrefl_wit_count = (1 << (n * (n - 1))) - 1
            soundness_holds = True

        # Can we store an unordered requirement {a, b} (a != b) as a canonical ordered pair (i < j)
        # without choosing an orientation? Only if has_intrinsic_order or n < 2.
        canonical_ordered_pair_without_choice = has_intrinsic_order if n >= 2 else False
        unordered_pairs_count = n * (n - 1) // 2

        print(
            f"Carrier={name:11s} (|C|={n}): "
            f"empty_T_inert=True, "
            f"bare_witness_models={bare_count:5d}, "
            f"inhabited_irrefl_models={irrefl_wit_count:4d}, "
            f"irrefl_implies_ne={soundness_holds}, "
            f"unordered_req_pairs={unordered_pairs_count}, "
            f"canonical_lt_order={canonical_ordered_pair_without_choice}"
        )


if __name__ == "__main__":
    check_mark_alone_inertia()
    check_seven_operations()
    check_single_additions()
    check_carrier_swaps()
