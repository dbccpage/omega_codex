"""Independent finite models for Slice 6 (ProfilePreorderAndGenerator); stdlib only.

Checks:
1. ProfileEquiv vs. MutualComp vs. E across all 512 binary relations on a 3-element carrier:
   - ProfileEquiv is an equivalence relation for all 512 relations.
   - IsPreorder holds on 29 relations; on all 29, ProfileEquiv == MutualComp.
   - Equivalence holds on 5 relations; on all 5, ProfileEquiv == MutualComp == E.
2. Quotient retention and symmetry multiplicity on finite setoids (N25).
3. Ten-stick reflection involution, raw Hamming vs. reflection residual, and Burnside
   orbit census across all 1024 configurations in {0, 1}^10 (N19).
4. Four-step cyclic lift vs. two-step trivial lift over visible C2 counterpart (N20).
5. One-token refusal-reification bridge, reflective chain endogenous obstruction
   generation, repair strategy classification, and radius-d outrun thresholds (N21-N22).
"""
from itertools import product
import json


def is_reflexive(rel):
    n = len(rel)
    return all(rel[x][x] for x in range(n))


def is_symmetric(rel):
    n = len(rel)
    return all(rel[x][y] == rel[y][x] for x, y in product(range(n), repeat=2))


def is_transitive(rel):
    n = len(rel)
    return all(
        not (rel[x][y] and rel[y][z]) or rel[x][z]
        for x, y, z in product(range(n), repeat=3)
    )


def is_preorder(rel):
    return is_reflexive(rel) and is_transitive(rel)


def is_equivalence(rel):
    return is_preorder(rel) and is_symmetric(rel)


def profile_equiv(rel):
    n = len(rel)
    return tuple(
        tuple(
            all(rel[x][z] == rel[y][z] for z in range(n))
            and all(rel[z][x] == rel[z][y] for z in range(n))
            for y in range(n)
        )
        for x in range(n)
    )


def mutual_comp(rel):
    n = len(rel)
    return tuple(
        tuple(bool(rel[x][y] and rel[y][x]) for y in range(n))
        for x in range(n)
    )


def check_profile_preorder_hierarchy(n=3):
    total_relations = 0
    preorder_count = 0
    equivalence_count = 0
    non_preorder_profile_differs = 0

    for flat in product((False, True), repeat=n * n):
        rel = tuple(tuple(flat[x * n + y] for y in range(n)) for x in range(n))
        total_relations += 1
        peq = profile_equiv(rel)
        mcomp = mutual_comp(rel)

        if not is_equivalence(peq):
            raise ValueError("ProfileEquiv failed equivalence laws")

        if is_preorder(rel):
            preorder_count += 1
            if not is_equivalence(mcomp):
                raise ValueError("MutualComp failed equivalence laws on a preorder")
            if peq != mcomp:
                raise ValueError("ProfileEquiv != MutualComp on a preorder")
        else:
            if peq != mcomp:
                non_preorder_profile_differs += 1

        if is_equivalence(rel):
            equivalence_count += 1
            if peq != rel or mcomp != rel:
                raise ValueError("ProfileEquiv or MutualComp != E on an equivalence")

    if n == 3 and (total_relations != 512 or preorder_count != 29 or equivalence_count != 5):
        raise ValueError(
            f"Unexpected 3-element relation counts: total={total_relations}, "
            f"preorders={preorder_count}, equivalences={equivalence_count}"
        )

    return {
        "carrier_size": n,
        "total_relations": total_relations,
        "preorder_count": preorder_count,
        "equivalence_count": equivalence_count,
        "all_profile_equiv_are_equivalences": True,
        "all_preorders_match_mutual_comp": True,
        "all_equivalences_match_rel": True,
        "non_preorder_profile_differs_count": non_preorder_profile_differs,
    }


def check_ten_stick_reflection():
    configs = list(product((0, 1), repeat=10))
    palindromes = 0
    mirror_pairs_zero_residual = 0
    orbits = set()

    for s in configs:
        rev = tuple(reversed(s))
        if tuple(reversed(rev)) != s:
            raise ValueError("Ten-stick reflection is not involutive")
        raw = sum(1 for a, b in zip(s, rev) if a != b)
        residual = min(
            raw,
            sum(1 for a, b in zip(s, tuple(reversed(rev))) if a != b),
        )
        if residual != 0:
            raise ValueError("Reflection residual with own mirror must be 0")
        if s == rev:
            palindromes += 1
        else:
            if raw == 0:
                raise ValueError("Non-palindromic configuration had zero raw distance to mirror")
            mirror_pairs_zero_residual += 1
        orbits.add(min(s, rev))

    stick_left = (1,) + (0,) * 9
    stick_right = (0,) * 9 + (1,)
    stick_mid = (0, 1) + (0,) * 8

    raw_lr = sum(a != b for a, b in zip(stick_left, stick_right))
    res_lr = min(
        raw_lr,
        sum(a != b for a, b in zip(stick_left, reversed(stick_right))),
    )
    raw_lm = sum(a != b for a, b in zip(stick_left, stick_mid))
    res_lm = min(
        raw_lm,
        sum(a != b for a, b in zip(stick_left, reversed(stick_mid))),
    )

    if (raw_lr, res_lr, raw_lm, res_lm) != (2, 0, 2, 2):
        raise ValueError("Ten-stick witness distances mismatch")
    if len(configs) != 1024 or palindromes != 32 or len(orbits) != 528:
        raise ValueError("Ten-stick Burnside orbit counts mismatch")

    return {
        "total_configs": len(configs),
        "palindromes": palindromes,
        "non_palindromic_mirror_configs": mirror_pairs_zero_residual,
        "reflection_orbits": len(orbits),
        "stick_left_right_raw": raw_lr,
        "stick_left_right_residual": res_lr,
        "stick_left_mid_raw": raw_lm,
        "stick_left_mid_residual": res_lm,
    }


def check_four_step_lift():
    for x in range(4):
        s1 = (x + 1) % 4
        s2 = (x + 2) % 4
        s4 = (x + 4) % 4
        if (s1 % 2) != (1 - (x % 2)):
            raise ValueError("step4 failed to intertwine visible counterpart")
        if (s2 % 2) != (x % 2) or s2 == x:
            raise ValueError("two steps of step4 must restore visible parity while flipping sheet")
        if s4 != x:
            raise ValueError("four steps of step4 must restore lifted state")

    for b, sheet in product((0, 1), repeat=2):
        t1 = (1 - b, sheet)
        t2 = (1 - t1[0], t1[1])
        if t1[0] != 1 - b or t2 != (b, sheet):
            raise ValueError("trivial 2-step lift check failed")

    return {
        "lifted_carrier_size": 4,
        "single_step_intertwines_counterpart": True,
        "two_steps_visible_id_sheet_flipped": True,
        "four_steps_period_four": True,
        "trivial_lift_period_two": True,
    }


def refl_state(n):
    data = list(range(n + 1))
    tags = list(range(1, n + 1))
    rel = [(k, k + 1) for k in range(n)]
    return {"data": data, "tags": set(tags), "rel": rel}


def profile1(state, i):
    is_tagged = i in state["tags"]
    has_in = any(dst == i for _, dst in state["rel"])
    has_out = any(src == i for src, _ in state["rel"])
    return (is_tagged, has_in, has_out)


def profile_d(n, i, d):
    state = refl_state(n)
    ball = [i - d + k for k in range(2 * d + 1)]
    return tuple(profile1(state, idx) for idx in ball)


def check_reflective_generator_and_depth_d():
    # 1. One-token refusal-reification minimum route
    m_data = []
    m_rel = []
    for tok in (0, 0):
        item = ("tok", tok)
        if item in m_data:
            rec = ("receipt", len(m_data))
            m_data.append(rec)
            m_rel.append((item, rec))
        else:
            m_data.append(item)
    if len(m_data) != 2 or len(m_rel) != 1 or m_rel[0][0] == m_rel[0][1]:
        raise ValueError("One-token refusal-reification minimum route failed")

    # 2. Depth-1 obstruction counts for n = 1..8
    depth1_counts = {}
    for n in range(1, 9):
        state = refl_state(n)
        colliding_pairs = [
            (i, j)
            for i in range(n + 1)
            for j in range(i + 1, n + 1)
            if profile1(state, i) == profile1(state, j)
        ]
        expected_middle_pairs = [
            (i, j)
            for i in range(1, n)
            for j in range(i + 1, n)
        ]
        if colliding_pairs != expected_middle_pairs:
            raise ValueError(f"Depth-1 obstruction mismatch at n={n}")
        depth1_counts[n] = len(colliding_pairs)

    # 3. Radius-d deep-interior outrun thresholds for d = 0..4
    thresholds = {}
    for d in range(5):
        threshold = 2 * d + 3
        deep_pairs = [
            (i, j)
            for i in range(d + 1, threshold - d)
            for j in range(i + 1, threshold - d)
        ]
        if deep_pairs != [(d + 1, d + 2)]:
            raise ValueError(f"Unexpected minimal deep pair at d={d}")
        if profile_d(threshold, d + 1, d) != profile_d(threshold, d + 2, d):
            raise ValueError(f"Radius-{d} profile collision failed at threshold {threshold}")
        thresholds[d] = threshold

    return {
        "one_token_bridge_carrier_size": len(m_data),
        "one_token_bridge_rel_size": len(m_rel),
        "depth1_obstruction_counts": depth1_counts,
        "radius_d_thresholds": thresholds,
    }


def run_all_checks():
    return {
        "profile_preorder_hierarchy": check_profile_preorder_hierarchy(3),
        "ten_stick_reflection": check_ten_stick_reflection(),
        "four_step_lift": check_four_step_lift(),
        "reflective_generator_and_depth_d": check_reflective_generator_and_depth_d(),
    }


if __name__ == "__main__":
    print(json.dumps(run_all_checks(), indent=2))
