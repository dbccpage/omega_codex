# PR 1 review response

The supplied review identified provenance, report-association, and CI gaps at commit `1864f8671706b0aa82db2dff8feeec29d440c2fc`.

## Provenance

The original PFP study directory was untracked. There is no PFP source commit to cite or reconstruct. The migration inventory and earlier local checks record a byte-for-byte copy, but do not independently prove a pre-publication origin.

The verifier now uses the immutable [first publication](https://github.com/dbccpage/omega_codex/commit/1864f8671706b0aa82db2dff8feeec29d440c2fc) as the archive anchor. It reads that commit's migration inventory through Git and compares the current inventory (normalizing its checkout line endings) and all 76 imported file digests. The reconstruction test separately reads every original archived Git blob and compares it with the imported files.

This establishes equality to the first published omega_codex archive. It does not establish an independently timestamped or signed PFP original, recover deleted pre-publication history, or authenticate the original API service beyond the preserved receipts. The anchor commit is fixed from the previously published PR and review; trust in that selected anchor remains an explicit premise.

## Report association

The verifier reconstructs the complete expected `answers.md` from the ordered saved prompts and raw responses and requires exact UTF-8 byte equality. Answer membership anywhere in the document is no longer accepted.

A negative test swaps the first two answer bodies while keeping their prompt headings and regenerating both archive manifests and the migration inventory. Verification must fail specifically with a report-association error, before the publication-anchor check. A separate negative test alters audit text and regenerates all hashes; the publication anchor rejects that internally consistent rewrite.

## Automation

The GitHub Actions workflow runs the offline verifier and standard-library unit tests with read-only repository permissions. Checkout is pinned to a commit and fetches full history so the original publication object is available. The workflow uses the Ubuntu runner's Python 3 and installs no packages.

Run locally:

```text
python scripts/verify_genesis_record.py
python -m unittest discover -s tests -v
```

The archived experiment files and original manifests remain unchanged. No new model calls or Lean build are part of these repairs.

## Conceptual review

The review's distinction between question specification, answer production, and answer registration remains an open Genesis question. A formal witness of separability does not itself establish an executing or registering subsystem. Those roles may be combined by a construction; identifying three roles does not establish three necessary mechanisms.

The projection observation is a conditional consequence of functional substitution: if `Q(x) = Q(y)`, applying the same function `f` gives equal outputs. It limits evaluators whose input factors entirely through `Q`. It neither supplies an observer nor proves that a particular observer architecture is necessary.

An account of a mark's appearance must state which conditions differ and which relation, transition, or act makes that difference internally available. These remain research targets; this engineering repair adds no new Regime, observer, or foundational theorem.
