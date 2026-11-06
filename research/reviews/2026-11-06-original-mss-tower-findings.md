# Three recovered MSS tower sources — November 6, 2026

All three sources are preserved verbatim in [the recovery packet](../recovered_sources/2026-11-06-original-mss-tower/manifest.json). Their Git blob hashes match archive revision `b3b67e3e3fda96a2827b071665c8d3516d846405`. The supplied main links resolved to that revision during this review.

## The May document is the closest historical match so far

[Minimal Symbol Tower](../recovered_sources/2026-11-06-original-mss-tower/mss_n_minimal_symbol_tower_may_2026.md), originally `mssn_tower_terse.md`, is headed “Jeremy Carroll + Claude, May 2026.” This is its internal date, not independent verification of its creation time.

The archive metadata maps it to:
`oe_master_librarian/.claude/worktrees/musing-taussig-5273ef/omega_engine/omega_engine_product_planning_office/_anomalon_architecture/02_oesympac_symbol_game_and_packetization/mssn/mssn_tower_terse.md`.

It records:
- MSS-n as alphabet plus rewriting rules.
- Closure failure as a normal form outside the current alphabet's words.
- Free completion F and forgetful U, an asserted adjunction and monad.
- The conjugate-pair rule and an explicit n=0..10 table.
- Counts 2,3,4,5,7,9,10,12,13,15,16.
- Delta increments 1,1,1,2,2,1,2,1,2,1.
- Phase at n=6, density/trace at n=7, tensor at n=8, creation/annihilation at n=9, local field at n=10.
- An explicit proposed link to Riemann zeros.
- Open questions about delta 3, an infinite tower, and computing n=11..100.

This matches the recalled period and mechanism. It does not contain the negative/imaginary-delta sweep, the 1024 consensus cutoff, or level-12–14 results. Its imaginary unit is an added symbol at n=6, not an imaginary growth increment.

The earlier recovered arithmetic-note mismatch is now more informative: this May table DOES reproduce the printed sequence, whereas the other note assigned a different sequence of increments to a different transition table. We have two distinct tabulations carrying the same displayed counts. Their editing chronology and dependence remain to be established.

## What each of the other two documents contributes

[Omega/UROS/MSS-N synthesis](../recovered_sources/2026-11-06-original-mss-tower/omega_uros_mssn_complete_math.md), originally `omega_uros_mssn_complete_math.md`, makes the proposed mechanism considerably more explicit:

1. Two terms have the same current quotient profile.
2. An admitted context makes their profiles differ.
3. This non-congruence licenses a candidate extension.
4. Delta is a minimum over a declared finite generator search class.
5. The lift-forget fixed part consists of classes satisfying UF(q)=q.
6. S(n) counts free naming generators, with primitive factorization and infinity separately conditional.

Sections 8, 9, 11, 12 and 19 are the recovery spine. Section 16 also contains the exact phase-blind descent condition for a Hilbert lift: equal squared moduli must remain equal after the proposed operation. This connects to the existing interference route without deriving it anew.

This source supplies finite categories, context actions, real cochain spaces, repair maps, positive weights and certificate rules. It is a downstream construction, not a derivation of those ingredients from the primitive. Its S(n) is generator rank, whereas the May note calls its count alphabet size. Those are not automatically the same invariant.

[MSS-8 and Beyond](../recovered_sources/2026-11-06-original-mss-tower/36_mss8_and_beyond.md), originally `36_mss8_and_beyond.md`, interprets levels as control/alternation/oracle depth. It explicitly forbids an omega-tower. The synthesis conditionally allows a countable diagram. These are different scope choices; no source correspondence yet identifies their levels with the May symbol counts.

## Concrete checks and unresolved mathematics

### May table and formula

The table increments agree with its printed difference sequence. Its proposed closed formula does not: at n=5, 9+floor(3(n-4)/2)=10 while the table says 9. The same mismatch persists through n=10. Exact results are recorded in [arithmetic_checks.json](../recovered_sources/2026-11-06-original-mss-tower/arithmetic_checks.json).

The glyph table names the desired new mathematics but does not provide the rewriting rules and exhaustive minimum search that force each row. In an ordinary rewrite system whose rules remain words over the current alphabet, rewrites cannot leave that alphabet. Its FORCED predicate therefore needs a specified ambient interpretation/completion or a different formulation of representational failure. Recovering that missing mechanism is the next search task, not grounds to replace the table with a new experiment.

The May note identifies fixed points of T with ker(T). Even after a linear realization is supplied, fixed points solve (T-I)q=0, not Tq=0. For T=identity on a nonzero space, every vector is fixed and ker(T) is zero. A generic monad is not itself a linear map with a kernel. The synthesis's explicit UF(q)=q fixes the equation at the level of a declared endomorphism; it still requires existence and preservation.

### Synthesis section 17: unique primitive decomposition

The stated hypotheses do not establish uniqueness. A one-coordinate example has C1=R, d0=0, d1=0, norm absolute value, and survivor monoid generated additively by 2 and 3. It is cancellative and has finite support; coordinate separability has no nontrivial split to test. Both 2 and 3 are indecomposable in this monoid, but 6=2+2+2=3+3. The two factorizations were checked exactly. Stronger atomic/freeness hypotheses or a different decomposition theorem are owed before this route licenses its Euler product.

### Synthesis section 18: higher-arity residual

If “all proper declared subfamilies are exact” includes each singleton for k>=2, then every r_i belongs to im(d0). Linearity gives sum(r_i)=d0(sum(a_i)), so the full sum is exact too. The proposed non-exact residual cannot occur under that reading. If singleton subfamilies are excluded, the allowed subfamilies and restriction/repair maps need definition. This does not rule out higher-order compatibility obstructions; it identifies a failure in this particular single-space additive formulation.

### Oracle note

The displayed existential/universal prefix contains five quantifier blocks and four switches. The note calls it five alternations. More substantively, oracle-level correspondence and strict minimality require a specified encoding, reductions and lower bounds; they do not follow from naming an obstruction schema. A finite per-level description also does not by itself prevent infinitely many successive lifts. The actual budget/descent contract must provide termination.

## Next recovery target

Search the source directory containing `mssn_tower_terse.md` for the rewriting rules, normal-form evaluator, context witnesses and experiment outputs behind its rows. Preserve the May outline, the oracle interpretation, and the more explicit synthesis separately. No newly reconstructed sweep should be labeled recovered experimental evidence.

No Lean build, original tower replay, RH verification or new reconstruction was performed. Three source copies passed exact Git-blob verification; the reported arithmetic checks are small counterchecks of specific statements.

