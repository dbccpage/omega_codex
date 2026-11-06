# Tower / survivor-zeta source recovery — 2026-11-06

This is source recovery, not a new reconstruction or certification of the historical claims.

## Recovered sources

Eight files (374,257 bytes) are preserved in [the recovery folder](../recovered_sources/2026-11-06-tower-zeta/manifest.json). Five are exact local copies from C:\.ana\rh-main\rh-main\mssn_tower_arithmetic_research. Three are exact Git-blob matches from dbccpage/_anomalon_archive at b3b67e3e3fda96a2827b071665c8d3516d846405. The manifest records full source paths, byte lengths, SHA-256 hashes and archive blob IDs.

The supplied RH package has no .git directory at its root. Its September relocation receipt identifies an earlier relocation base, not a verified revision of these current bytes. The copies are therefore identified as local snapshots, not attributed to that historical commit.

## Strong matches to Jeremy's recollection

- [Archive Riemann-shadow paper, section 7.4](../recovered_sources/2026-11-06-tower-zeta/mssn_infinity_and_riemann_shadow.md#74-uniform-bound-in-binary-mss-n): binary delta 2, a claimed spectral cap, higher-polarity width accumulation, instability, and effective-binary collapse. Source lines 2588–2634. These are recovered claims, not independently validated theorems.
- [Local RH version](../recovered_sources/2026-11-06-tower-zeta/rh-local/mssn_infinity_and_riemann_shadow.md): lines 2250–2295 preserve this same comparison. Lines 1232–1264 explicitly adopt genuinely higher-delta lifts instead of reduction to sequential binary lifts.
- [Early MSS/arithmetic note](../recovered_sources/2026-11-06-tower-zeta/rh-local/03_mssn_and_arithmetic.md): lines 199–216 give an actual transition table from MSS-0 through MSS-10, including quotation, provability, fixed points, and G1/G2. The accompanying mss_n_tower_and_arithmetic_shadows.md is a near-duplicate, as the source README itself states.
- [Recovered Lean source](../recovered_sources/2026-11-06-tower-zeta/er007_tower_zeta.lean): lines 18–30 supply natural-number base and delta, coordinate base + delta*k, and deltaTwoTower with delta := 2. It distinguishes this coordinate from the LicensedLift index. It imports s_level, which is not recovered in this small packet.
- The Lean file occurs twice in the archive (UUIDs f73341d8-ed59-46c8-b219-a35827042fb8 and 9424084e-57c9-467d-905b-09f4664c4dc4), both with blob d6db7b078b0c557de06ca1db680ba5fedcce1488. Only one copy was saved. Its SHA-256 matches the surviving Anomalon catalog fingerprint 8cc5d145752d3acc7a190f32433eed6a0262c58889df206c877ce8f63edeb8b5.
- The June 13 ENC-0894 entry in PFP explicitly records the user's “delta 2 every time” idea and points to s_n_packets_and_the_symbol_game.md. That referenced paper has not been recovered under that name; its local certificate says source_exists false. The recovered Lean is actual source behind that family of derivative entries.

## Differences that must not be flattened

1. **Three uses of delta:** a supplied constant arithmetic step in Lean; a claimed minimum constructor increment relative to an admissible repair class in the finite paper; and polarity/leakage structure in the transfer discussion. These need a source-backed bridge before they can be identified.
2. **Conflicting higher-arity claims:** the early notes say delta > 2 is impossible; a later local version adopts higher delta; the boundedness trilemma allows higher invariants, accumulating width, or effective-binary reduction. Preserve these alternatives rather than declaring a single settled result.
3. **An explicit arithmetic mismatch:** the early table lists increments 1,1,1,2,1,2,1,2,1,2. Starting from its S(0)=2 gives 2,3,4,5,7,8,10,11,13,14,16. The prose instead prints 2,3,4,5,7,9,10,12,13,15,16. The table and printed sequence cannot both describe that recurrence.
4. **Toy labels are supplied:** the archive paper's lines 945–1007 hardcode a delta schedule and cycle a list of physics names up to N=1200. Its output is not evidence that an obstruction solver discovered those theories. The supplied local infinite_symsys version preserves this section; the other local mssn_infinity version differs substantially.
5. **Zeta assumptions are present in the sources:** free primitive factorization, compatible transport and additive positive cost precede the survivor Euler product. Arithmetic realization and analytic bridges remain separate. The finite-core paper explicitly denies a universal delta-in-{1,2} theorem without a separate lower-bound result.

## Still missing

- Original April/May run date and experimental records.
- The sweep over -1, i, 0,1,2,3,4,5,6,7, including what that parameter represented.
- The survivor-consensus cutoff near 1024 and its stopping criterion.
- The recalled level-12–14 identification with Goedel/GR.
- A demonstrated relationship between the recovered prose, the simplified June Lean profile, and the lost experiment.

No matches for 1024, 1,024, consensus, Goedel/Gödel, Postnikov, or the targeted negative/imaginary-delta phrases were found in the four local tower notes. This is a bounded search result, not evidence the experiment never existed. Parent RH experiment searches did not locate an MSS survivor/delta sweep. The parent's finite Weil-positivity experiments are a different research track according to its own README.

## Checks actually performed

- Five local copies compared byte-for-byte with their sources.
- Three recovered archive files independently matched their Git blob hashes.
- SHA-256 and source paths recorded for all eight files.
- The two recovered Lean archive copies have identical blob IDs.
- Early-table arithmetic independently summed; mismatch recorded above.
- No Lean compilation, experiment replay, RH proof verification, or new mathematical implementation was performed.

