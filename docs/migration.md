# Genesis study migration

On 2026-11-01 the user designated [dbccpage/omega_codex](https://github.com/dbccpage/omega_codex) as the home for the Genesis-to-Cosmos studies and requested a commit, push, and pull request. The previously created Genesis study package is migrated from `proposal_fidelity_protocol_pfp/docs/genesis_studies/seed_audit_2026-11-01` to `evidence/seed_audit_2026-11-01`.

The package is copied byte for byte, including its manifests, original prompts, 25 request/response pairs, nine conversation histories, audit, source-chat snapshot, and finite example checks. Git attributes preserve the archive bytes rather than converting line endings. The source directory is removed from PFP only after the destination is verified and the migration is pushed. Unrelated PFP changes are outside this migration.

The migration inventory in [migration_inventory.json](../migration_inventory.json) records every imported path, byte length, and SHA-256 hash. Original archive paths and historical script assumptions remain in the frozen files as evidence of how the experiment was run. In particular, the historical `run/verify.py` expects an original Downloads file. Use the portable verifier below for this repository. Do not run the historical paid API runner merely to verify the archive.

## Offline verification

From the repository root, using Python 3.9 or newer:

```text
python scripts/verify_genesis_record.py
```

The verifier checks the imported inventory, both preserved manifests, exact prompts and order, isolated histories, fixed request settings, sequential ledger timestamps, raw-response hashes, all 25 normal completions, the saved transcript, audit coverage, and the small binary/countermodel examples. It makes no API calls and does not rewrite the archived evidence. Successful verification establishes custody and those scoped examples, not correctness of every model answer or a general minimality theorem.

## Continuing the discussion

The [latest discussion transcript](genesis_discussion.md) contains the two exchanges after the audit. The source-development conversation remains in the evidence package. Its retrieved four turns supply motivation and preliminary prompts; the exact final run sheet is separately preserved in the source protocol.

The current entry point is the repository README. We will continue by examining the internal structure of a question and what would count as a performed, witnessed judgment before treating any Regime field as foundational.

## Publication anchor and provenance limit

The PFP source directory was untracked, so no original PFP source commit exists. The verifier now anchors the archive to first-publication commit `1864f8671706b0aa82db2dff8feeec29d440c2fc`, reconstructs the full report for exact prompt/answer association, and checks unchanged archive bytes. This verifies equality to the first published omega_codex record, not independent proof of the earlier PFP origin. Full Git history is needed (`git fetch --unshallow` for a shallow clone). See [the review response](pr1_review_response.md) for the reconstruction and corruption tests.

The workflow runs the verifier and `python -m unittest discover -s tests -v`. It makes no model calls.
