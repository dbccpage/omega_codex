# Genesis reconstruction and local setup

Omega Codex develops one reviewed piece at a time. Existing files remain in place. The immediate setup step adds no legacy source imports and changes no mathematical claims.

## Current environment

- Lean: `leanprover/lean4:v4.33.0`, pinned in `lean-toolchain`.
- Lake: the existing package builds `lean/PrimitiveDifference.lean`.
- Dependencies: Lean core only; no Mathlib or other Lake packages.
- Python: 3.9 or newer; verification uses the standard library only.
- Local environment: `.venv`, ignored by Git. No project dependency on PFP's environment.
- CI: archive verification, five corruption/reconstruction tests, the Lean build, and the 26-theorem dependency census.

The source-bound receipt in `docs/primitive_difference_verification.json` records the earlier local theorem check. Running the checker normally prints a fresh result without rewriting that receipt.

## Local commands

From the repository root, with Lean/Elan available:

```text
lean --version
lake build
```

Create a Python environment with a working Python 3.9+ interpreter if one does not already exist:

```text
python -m venv --without-pip .venv
```

On Windows, run the checks using that environment directly; activation is optional:

```powershell
.\.venv\Scripts\python.exe scripts\check_primitive_difference.py
.\.venv\Scripts\python.exe scripts\verify_genesis_record.py
.\.venv\Scripts\python.exe -m unittest discover -s tests -v
```

On Linux or macOS, the corresponding interpreter is `.venv/bin/python`. CI uses its runner Python. Archive verification requires the first-publication commit in Git history; a shallow checkout must obtain that history first.

## The discussion loop

1. Codex presents one proposed slice with concrete statements and examples, source provenance, assumptions, dependencies, checks, and limits.
2. The user reviews it and may discuss it with their friend.
3. The user brings back corrections and an agreed direction.
4. Codex implements that agreed slice, verifies it, and reports any gap between the proposal and the result.
5. Review the result before choosing the next slice.

This is a working agreement from the user's instruction, not a claim that the current mathematics is final. A proposal can be revised or rejected without deleting its historical evidence. Cleanup or consolidation should be discussed as its own bounded change.

## Proposed first reconstruction slice

Status: **proposed for discussion, not implemented by this setup step**.

Question: What exactly makes a witnessed relation fail to fit on one position?

Read-only source: `19L57G1` at commit `45bb09864f9b52ed5ecf66e977ca81f0ed623de7`, `lean4/Derivation/PrimDiff.lean`, specifically `selfdiff_consistent` and `no_witness_on_subsingleton`. Refresh those pins before implementation if the source changes. The new module already contains the related `irrefl_witness_ne` theorem.

Proposed Lean work:

- Reconstruct the one-position countermodel: a bare asserted binary relation can be a self-relation.
- Reconstruct the obstruction: on a type with at most one inhabitant, an irreflexive relation cannot have a witnessed pair.

Proposed code work:

- Write a small, independent enumeration of the binary relations on one position and two positions.
- Compare bare occurrence, irreflexivity, and symmetry against explicit expected examples.
- Relate these finite examples to the Lean statements without presenting enumeration as a proof for arbitrary types.

Assumptions to discuss: an admitted carrier, a binary relation, the meaning of a witnessed pair, equality, and the no-self-relation law. Symmetry is an optional extra. The comparison is about carrier size under those stated requirements, not a smallest universe.

Expected limits: no Regime, no question evaluator, no persistence mechanism, no physical witnessing claim, and no broad import of `primdiff.py`. The existing 26-theorem module remains in place.

Before implementation, the discussion should settle whether this is the right next question and whether “witnessed pair” here denotes an admitted formal fact or the stronger internally performed event the user wants to investigate.
