"""Finite mirror models and exhaustive decoders on reachable observations only."""
from itertools import product
import json

MODELS = ("one_referent", "two_referents")
PAIRS = tuple(product((False, True), repeat=2))

def referents(model):
    if model == "one_referent":
        return (0, 0)
    if model == "two_referents":
        return (0, 1)
    raise ValueError("Unknown model")

def identity_answer(model):
    a, b = referents(model)
    return a == b

def observe(model):
    referents(model)  # Validate the model; referents are not accessible here.
    return tuple(x != y for x, y in PAIRS)

def decoding_table(observations):
    """Enumerate all Boolean functions on just the reachable observation set."""
    reachable = tuple(dict.fromkeys(observations))
    valid = []
    for outputs in product((False, True), repeat=len(reachable)):
        decoder = dict(zip(reachable, outputs))
        if all(decoder[observation] == identity_answer(model)
               for model, observation in zip(MODELS, observations)):
            valid.append(tuple(decoder[o] for o in reachable))
    return {"reachable_values": len(reachable), "decoders_examined": 2**len(reachable),
            "correct_decoders": len(valid)}

def enumerate_case():
    base = tuple(observe(m) for m in MODELS)
    completions = []
    for extra in product((False, True), repeat=2):
        combined = tuple((observation, bit) for observation, bit in zip(base, extra))
        completions.append({"extra_values": list(extra),
                            "separates_models": extra[0] != extra[1],
                            **decoding_table(combined)})
    return {"models": [{"model": m, "referents": list(referents(m)),
                        "accessible_relation": list(observe(m)),
                        "same_referent": identity_answer(m)} for m in MODELS],
            "base_interface": decoding_table(base),
            "boolean_completions": completions,
            "scope": "Two stipulated models, one fixed relational interface, and all four Boolean extra channels. Decoders are enumerated only on reachable observations. No physical sensing or universal observer claim."}

if __name__ == "__main__":
    print(json.dumps(enumerate_case(), indent=2))
