# Working on Omega Codex

This repository is the home for the user's Genesis-to-Cosmos reconstruction.

## Scope and review

- Work in small, reviewable slices. The user, Codex, and a friend discuss each slice; the user carries the friend's feedback.
- Before implementing a new reconstruction slice, present its source, assumptions, intended result, checks, and unresolved questions. Wait for the user's agreement on that slice.
- Once a slice is agreed, complete its implementation and checks, report the actual results, and stop for the next discussion. Do not treat acceptance of one slice as approval for later slices.
- Do not contact the friend or delegate their review to an agent.
- Commit/push/PR work must remain within the user's authorized scope. Do not merge without an explicit instruction.

## Preservation and reconstruction

- Do not delete existing repository files or perform cleanup sweeps.
- Keep the historical evidence and manifests unchanged.
- Do not bulk-copy old Genesis repositories or create a large import that later needs to be dismantled.
- Treat legacy repositories as read-only references. Record the exact source revision and what is reconstructed, adapted, or left unresolved.
- Reconstruct the smallest useful agreed piece with explicit dependencies. Preserve differences between the legacy claim and the new claim.
- Keep formal distinction, structural obstruction, an operational specification, and performed witnessing separate.
- A lower bound or minimum must state its task, comparison class, and cost measure.

## Verification and communication

- Use the pinned Lean toolchain and the repository's own Python environment; the Python checks currently use only the standard library.
- Build only the agreed slice and run the relevant existing checks. Do not silently expand to legacy-project builds or download large dependencies.
- Report the actual theorem statements and axiom dependencies. Do not infer general mathematical, physical, or publication claims from passing checks.
- Give concise progress updates during sustained work. Surface substantive design choices before committing to them.
- Start from CONTRIBUTING.md for commands and the next proposed slice.
