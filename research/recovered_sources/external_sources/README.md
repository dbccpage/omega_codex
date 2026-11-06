# External Lean source consolidation

This folder centralizes Lean sources explicitly identified in the Omega discussion outside Omega and TFQM. [source-map.json](source-map.json) records each source path, SHA-256, and its research copy. Byte-identical files point to one already recovered copy, so the original package directory may not be independently buildable. [SHA256SUMS.txt](SHA256SUMS.txt) covers the new copies and map.

- `19L57G1/lean4/Derivation`: all 75 Lean files found in the previously identified directory; source checkout HEAD `45bb09864f9b52ed5ecf66e977ca81f0ed623de7` as recorded during the prior recovery.
- `anomalon/lean4`: all 150 Lean files found in the previously identified directory; source checkout HEAD `f547317025169b5d3ae74ea554b2dd4a48024517` as recorded during the prior recovery.
- Two additional identified `19L57G1/research` diagonal files are mapped when present.
- 92 non-PFP Lean sources in the prior papers-directory inventory are mapped. PFP-specific paper packages remain excluded as previously instructed. The source checkout HEAD recorded during the prior recovery is `505492e03cb8effb47b25103864b0a36282c393a`.

These HEADs identify checkouts, not proof that the working files match those revisions. The map hashes identify the actual copied bytes. No source has been adapted; package dependencies, toolchains and all files outside the identified scope have not been imported. No Lean build or claim validation is implied.

The archive's duplicate primitive-difference source bodies are mapped below. UUIDs refer to `old/<UUID>.lean` at archive commit `b3b67e3e3fda96a2827b071665c8d3516d846405`; the matching `new/<UUID>-*.md` catalog preserves the original path. Each row's listed files have the same Git blob and therefore share one recovered copy.

| Recovered copy | Archive UUIDs |
| --- | --- |
| `../archive/shared_kernel/primitive_difference.lean` | `316d03be-35e1-4e03-bdf6-0bed447174f9`, `dd729d59-4c48-484b-8301-28da97fc6340`, `0b6074a8-e5e4-4efd-ad46-e068bc73285d`, `b9052333-6ed8-4f44-8be0-f4f8b9300bfe` |
| `../archive/short_kernel/PrimitiveDifference.lean` | `5c3e1504-514f-41a2-9c33-4d3482bdd584`, `2aff6ee7-cfdf-4e6d-8f86-b1f7e9745765`, `31bc7fef-b6ca-4822-898a-345c2923879b`, `67a99e49-6172-49de-941a-08eaa08115e2` |
| `../archive/shared_kernel/shared_kernel.lean` | `68fe4996-8981-4b80-97c9-27f207e44f51`, `9889679d-25ec-4e3b-ac28-9bb444be6424` |
