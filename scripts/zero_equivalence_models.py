"""Independent finite tables for the approved zero-equivalence bridge; stdlib only."""
from itertools import product

FIXTURES = {
    "constantAllZero": (((0, 0), (0, 0)), frozenset({0, 1}), 1, True),
    "nonconstantAllZero": (((0, 0), (1, 1)), frozenset({0, 1}), 1, False),
    "binary": (((0, 1), (1, 0)), frozenset({0}), 2, True),
    "rich": (((0, 0, 2), (1, 1, 2), (2, 2, 0)), frozenset({0, 1}), 2, False),
}


def is_equivalence(relation):
    n = len(relation)
    return (all(relation[x][x] for x in range(n))
            and all(relation[x][y] == relation[y][x] for x, y in product(range(n), repeat=2))
            and all(not (relation[x][y] and relation[y][z]) or relation[x][z]
                    for x, y, z in product(range(n), repeat=3)))


def equivalences(n):
    for flat in product((False, True), repeat=n * n):
        relation = tuple(tuple(flat[x*n+y] for y in range(n)) for x in range(n))
        if is_equivalence(relation):
            yield relation


def descends(values, relation):
    n = len(values)
    return all(values[x][y] == values[a][b]
               for x, a, y, b in product(range(n), repeat=4)
               if relation[x][a] and relation[y][b])


def classify(table, zeros):
    n = len(table)
    if any(len(row) != n for row in table):
        raise ValueError("Square difference table required")
    zero = tuple(tuple(value in zeros for value in row) for row in table)
    if not is_equivalence(zero):
        raise ValueError("Zero-status is not an equivalence")
    classes = {tuple(y for y in range(n) if zero[x][y]) for x in range(n)}
    checked = 0
    for candidate in equivalences(n):
        contained = all(not candidate[x][y] or zero[x][y] for x, y in product(range(n), repeat=2))
        if descends(zero, candidate) != contained:
            raise ValueError("Zero-status descent/containment disagreement")
        checked += 1
    return {"classes": len(classes), "exact_descends": descends(table, zero),
            "zero_status_descends": descends(zero, zero), "candidate_equivalences": checked}


def check_fixture(name, table=None, zeros=None):
    original, criterion, count, exact = FIXTURES[name]
    result = classify(original if table is None else table, criterion if zeros is None else zeros)
    if result["classes"] != count or result["exact_descends"] != exact:
        raise ValueError("Fixture classification changed: " + name)
    return result


if __name__ == "__main__":
    import json
    print(json.dumps({name: check_fixture(name) for name in FIXTURES}, indent=2))
