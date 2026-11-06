# Prompt 3 — The Five Regime Fields (`D, F, I, U, Q`)

## Pinned Repository Commits

| Repository | Path | Git Commit (`HEAD`) |
|---|---|---|
| `A` (`19L57G1`) | `C:\Users\a343o\source\repos\19L57G1` | `45bb09864f9b52ed5ecf66e977ca81f0ed623de7` |
| `B` (`theory_of_finite_quantum_mechanics`) | `C:\Users\a343o\source\repos\theory_of_finite_quantum_mechanics` | `e45ed2e133920aa3790af8c5e072ee9829898490` |
| `omega_codex` (baseline) | `C:\Users\a343o\source\repos\omega_codex` | `e21b785626ff8d0231a53409c76fe4e7a57cd59d` |

---

## Target Results Under Test

Let the baseline 5-tuple be `R = (D, F, I, U, Q)` (`Supplied`, `A/lean4/Derivation/Basic.lean:33-39`, `B/atlas/finite_obstruction_calculus/genesis/paper.md:274-281`), evaluated against the six stated target results:

- **`R1` (`first-separation cost 2`)**: From an initial collapsed regime (`R2L = (2, [], [], [], [(0,1)])` or `R2F = (3, [], [], [], [(1,2)])`), no 1-item extension separates the target pair (`cost1_insufficient_general`, `A/lean4/Derivation/Minimality.lean:281-285`), and a 2-item extension separates it (`deltaU0_valid`, `Minimality.lean:105-115`), giving minimum $\mu_1(\Delta) = 2$.
- **`R2` (`mu2 unique minimum (2,1)`)**: Under $\mu_2(\Delta) = (|\Delta|, |\text{Ctx}(R')|)$, the minimum over separating extensions is `(2, 1)`, and all extensions achieving `(2, 1)` produce regimes in a single isomorphism class up to `Iso` (`mu2_unique`, `Minimality.lean:451-487`; `mu2_unique_F`, `MinimalityF.lean:86-197`).
- **`R3` (`infinitely many mu1 ties`)**: For every arity $k \ge 1$, the 2-item extension `deltaK(k) = [newForm(k), newInst(0, [1,...,1])]` has $\mu_1 = 2$, separates `(0, 1)`, and produces pairwise non-isomorphic regimes `markK(k)` with $|\text{Ctx}(\text{markK}(k))| = k \cdot n^{k-1}$ (`markK_pairwise_noniso`, `Minimality.lean:380-416`).
- **`R4` (`collapsed_of_no_insts`)**: For every regime `r` with `r.insts = []`, every pair of data `d, d' < r.data` is collapsed (`collapsed_of_no_insts`, `Basic.lean:155-162`).
- **`R5` (`round bound 2(|Q0|+m) <= n(n-1)`)**: For every closed multi-round run of $m$ rounds on a fixed $n$-datum carrier with canonical deduplicated requirements ($0 \le i < j < n$), $2(|Q_0| + m) \le n(n - 1)$ (`closedRun_round_bound`, `Rounds.lean:251-265`).
- **`R6` (`no-return / cumulative element count`)**: The cumulative count `elems(r) = |D| + |F| + |I| + |U| + |Q|` strictly increases (`elems(r) < elems(r')`) on every regime-changing primitive admission step, precluding directed cycles (`step_strict_mono`, `Progress.lean:141-155`).

---

## Questions 1 & 2 — Field-by-Result Matrix (Deletions and Finite Derivations)

Status labels in each cell:
- `SURVIVES` (`Derived` / `Witnessed`): result holds with unchanged value and statement.
- `SURVIVES*` (`Derived`): result holds vacuously because no non-empty instances or separating extensions exist.
- `CHANGES(...)` (`Derived` / `Witnessed`): a modified numerical bound or modified equivalence class holds, but the original value or congruence changes.
- `BREAKS(...)` (`Derived` / `Witnessed`): the result fails; countermodel exhibited below and in `3_regime_deletions.py`.

| Variant (Field Deletion or Derivation) | `R1`: First-Sep Cost 2 | `R2`: `mu2` Unique Min `(2,1)` | `R3`: Infinitely Many `mu1` Ties | `R4`: `collapsed_of_no_insts` | `R5`: Round Bound $2(\|Q_0\|+m) \le n(n-1)$ | `R6`: No-Return (`elems` Monotone) |
|---|---|---|---|---|---|---|
| **0. Baseline `(D, F, I, U, Q)`** | **SURVIVES** (`Derived`, `Minimality.lean:281-292`; `Witnessed`, `3_regime_deletions.py` `[3]`) | **SURVIVES** (`Derived`, `Minimality.lean:451`, `MinimalityF.lean:86`; `Witnessed`, `3_regime_deletions.py` `[3]`) | **SURVIVES** (`Derived`, `Minimality.lean:380-416`; `Witnessed` for $k \le 5$, `3_regime_deletions.py` `[5]`) | **SURVIVES** (`Derived`, `Basic.lean:155-162`; `Witnessed` across 60/60 regimes, `3_regime_deletions.py` `[1]`) | **SURVIVES** (`Derived`, `Rounds.lean:251-265`; `Witnessed`, `3_regime_deletions.py` `[6]`) | **SURVIVES** (`Derived`, `Progress.lean:141-155`) |
| **1a. Delete `D` (fix $n = 0$)** | **BREAKS** (`Derived`: `wf` requires `i < 0`, so no target pair or instance is well-formed) | **BREAKS** (`Derived`: no valid response exists) | **BREAKS** (`Derived`: no valid response exists) | **SURVIVES*** (`Derived`: holds vacuously on empty carrier) | **SURVIVES*** (`Derived`: $m = 0 \implies 0 \le 0$) | **SURVIVES*** (`Derived`: `F`-only growth remains monotone) |
| **1b. Delete `D` (fix constant $n = 2$, drop `NewDatum`)** | **SURVIVES on `L`; BREAKS on `F`** (`Derived`: $n=2$ accommodates `R2L` but rejects datum `2` in `R2F`) | **SURVIVES on `L`; BREAKS on `F`** (`Derived`: unique `(2,1)` on $n=2$; `R2F` rejected) | **SURVIVES on `L`** (`Derived`: `markK(k)` uses $n=2$ for all $k \ge 1$) | **SURVIVES** (`Derived`: proof of `collapsed_of_no_insts` holds at fixed $n=2$) | **SURVIVES at $n=2$** (`Derived`: $2(|Q_0|+m) \le 2$) | **SURVIVES** (`Derived`: `|F|+|I|+|U|+|Q|` strictly increases) |
| **1c. Delete `D` (replace with ambient `Nat`, drop `< r.data` guard)** | **SURVIVES** (`Derived`: still needs 1 form + 1 instance = 2 items) | **BREAKS** (`Derived`: for arity $a \ge 2$, $|\text{Ctx}(R')| = a \cdot |\mathbb{N}|^{a-1} = \infty$, so finite $|\text{Ctx}|$ is undefined) | **SURVIVES** (`Derived`: `markK(k)` has $\mu_1 = 2$ and distinct arities $k$) | **SURVIVES** (`Derived`: `plug` into `U` holds for all $d \in \mathbb{N}$) | **BREAKS** (`Derived`: $n = \infty$ allows unboundedly many pair demands $m \to \infty$) | **SURVIVES** (`Derived`: `|F|+|I|+|U|+|Q|` strictly increases) |
| **1d. Derive `D` from `(I, Q)` ($D_{\text{der}} = \text{indices in } I \cup Q$)** | **SURVIVES** (`Derived`: still needs 1 form + 1 instance) | **CHANGES on `F`** (`Derived`: unmentioned datum `0` in `R2F` is dropped, shrinking $|D|$ from $3$ to $2$ and $|\text{Ctx}|$ for arity 2 from $4$ to $2$) | **SURVIVES** (`Derived`: `markK(k)` arities stay pairwise non-isomorphic) | **SURVIVES** (`Derived`: if $I = \emptyset$, no instance separates any pair) | **BREAKS when $Q_0 = \emptyset$** (`Derived`: initially $I=Q_0=\emptyset \implies |D_{\text{der}}|=0 \implies n(n-1)=0$, violated as soon as round 1 adds a pair) | **BREAKS** (`Derived`: `NewDatum` without `I` or `Q` mention does not change $D_{\text{der}}$) |
| **2a. Delete `F` (fix `forms = []`, drop `NewForm`)** | **BREAKS** (`Derived`: `wf` forces `I = []`, so no separation exists) | **BREAKS** (`Derived`: no valid response exists) | **BREAKS** (`Derived`: no valid response exists) | **SURVIVES*** (`Derived`: `I = []` always holds) | **SURVIVES*** (`Derived`: $m = 0$ rounds possible) | **SURVIVES*** (`Derived`: only `D` and `Q` can grow) |
| **2b. Delete `F` (fix constant `forms = [1]`, drop `NewForm`)** | **BREAKS** (`Witnessed`: 1-item `delta = [newInst(0, [1])]` separates `(0,1)` at cost $\mu_1 = 1$) | **CHANGES to `(1,1)`** (`Witnessed`: minimum $\mu_2$ drops from `(2,1)` to `(1,1)`) | **BREAKS** (`Derived`: arity is fixed to $1$; only 2 unary instances exist on $n=2$, so infinite tie family vanishes) | **SURVIVES** (`Derived`: `Basic.lean:155-162` applies at `forms = [1]`) | **SURVIVES** (`Derived`: each round still demands a new pair in `Q`) | **SURVIVES** (`Derived`: `|D|+|I|+|U|+|Q|` strictly increases) |
| **2c. Derive `F` from `I` (infer arities from `len(args)` in `I`, drop `NewForm`)** | **BREAKS** (`Witnessed`: admitting `newInst(0, [1])` implicitly supplies its unary form at cost $\mu_1 = 1$, falsifying `cost1_insufficient_general`) | **CHANGES to `(1,1)`** (`Witnessed`: unique minimum shifts from `(2,1)` to `(1,1)`) | **CHANGES to cost-1 ties** (`Witnessed`: `[newInst(0, [1]*k)]` gives infinite ties at $\mu_1 = 1$ instead of $\mu_1 = 2$) | **SURVIVES** (`Witnessed`, `3_regime_deletions.py` `[1]`: 0 mismatches across all inhabited regimes) | **SURVIVES** (`Derived`: pair count bound in `Q` is unchanged) | **SURVIVES** (`Derived`: `|D|+|I|+|U|+|Q|` strictly increases) |
| **3a. Delete `I` (fix `insts = []`, drop `NewInst`)** | **BREAKS** (`Derived` by `R4`: `insts = []` forces all pairs to stay collapsed; 0 separating deltas exist) | **BREAKS** (`Derived`: no valid response exists) | **BREAKS** (`Derived`: no valid response exists) | **SURVIVES*** (`Derived`: holds for every regime in the restricted space) | **SURVIVES*** (`Derived`: $m = 0$ valid separating rounds exist) | **SURVIVES*** (`Derived`: `|D|+|F|+|U|+|Q|` strictly increases) |
| **3b. Derive `I` from `(D, F, U, Q)`** | **BREAKS** (`Derived`: `D, F, U` are invariant under all permutations of $D$, and `Q` does not enter `derivable`; no deterministic function of `(D,F,U)` can break symmetry between $i$ and $j$) | **BREAKS** (`Derived`: no asymmetric instance can be derived) | **BREAKS** (`Derived`: no asymmetric instance can be derived) | **SURVIVES*** (`Derived`: symmetric profiles leave all pairs collapsed) | **SURVIVES*** (`Derived`: $m = 0$ separating rounds) | **BREAKS** (`Derived`: `NewInst` steps are lost) |
| **4a. Delete `U` (fix `rules = []`, drop `NewRuleAll`)** | **SURVIVES** (`Derived` & `Witnessed`, `3_regime_deletions.py` `[3]`, `[7]`: `U` cannot separate data; minimum separating delta uses only `F` and `I` at cost 2) | **SURVIVES** (`Derived` & `Witnessed`: `U0` and `U0F` have `rules = []`) | **SURVIVES** (`Derived` & `Witnessed`: `markK(k)` has `rules = []` for all $k \ge 1$) | **SURVIVES** (`Derived`: if `I = []` and `U = []`, `derivable` is identically `false`, so all profiles are equal) | **SURVIVES** (`Derived`: `Rounds.lean` never requires `U` to be non-empty) | **SURVIVES** (`Derived`: `|D|+|F|+|I|+|Q|` strictly increases on remaining 4 item kinds) |
| **4b. Derive `U` on finite carrier (materialize $f \in U$ as $D^{a_f} \subseteq I$)** | **SURVIVES** (`Witnessed`, `3_regime_deletions.py` `[1]`: 0 profile mismatches across all 8,424 regimes at fixed $n \le 3$) | **SURVIVES** (`Witnessed`: `U = []` at the `(2,1)` minimum) | **SURVIVES** (`Witnessed`: `U = []` on `markK(k)`) | **SURVIVES** (`Witnessed`: at fixed $n$, adding full product $D^{a_f}$ to $I$ keeps all pairs collapsed) | **SURVIVES** (`Derived`: fixed-$n$ profiles are identical) | **CHANGES cost & growth** (`Witnessed`, `3_regime_deletions.py` `[2]`: cost of arity-$a$ rule jumps from $1$ to $n^a$; under `admitDatum` ($n=2 \to 3$), materialized `I` leaves datum `2` uncovered (`collapsed(0,2) = False`), breaking `Ext.lean:160-175`) |
| **5a. Delete `Q` (pass target `(i,j)` externally, drop `reqs` from `Regime`)** | **SURVIVES** (`Witnessed`, `3_regime_deletions.py` `[3]`: `R2L` and `R2F` still require 1 form + 1 instance = 2 items) | **CHANGES on `F`** (`Witnessed`, `3_regime_deletions.py` `[3]`: without `Q` in `Iso`, `inst=[0]` and `inst=[1]` on $n=3$ are isomorphic (`True`), yet `separable(inst=[0], 1, 2) = False` while `separable(inst=[1], 1, 2) = True`, so `Iso` ceases to preserve validity on `R2F` unless target `{1,2}` is added back to `Iso`) | **SURVIVES** (`Derived`: `markK(k)` is distinguished by form arity $k$) | **SURVIVES** (`Derived`: `Q` does not appear in `derivable` or `collapsed`) | **BREAKS** (`Derived`: without `Q` persisted in state across rounds, a run cannot enforce `∀ q ∈ r.reqs, q ∈ r'.reqs` or `NewPairDemand`, allowing the same pair `(0,1)` to be re-demanded infinitely often) | **SURVIVES on `(D,F,I,U)`** (`Derived`: `|D|+|F|+|I|+|U|` strictly increases on the remaining 4 item kinds) |
| **5b. Derive `Q` as $\{(i,j) : i < j \land \text{separable}(r,i,j)\}$** | **SURVIVES** (`Derived`: initial state has $Q_{\text{der}} = \emptyset$, separation still costs 2) | **CHANGES on `F`** (`Derived`: initial `R2F` has `I = []` so $Q_{\text{der}}(R_{2,F}) = \emptyset$, erasing the distinction between target `(1,2)` and `(0,1)` before extension) | **SURVIVES** (`Derived`: `markK(k)` has $Q_{\text{der}} = \{(0,1)\}$) | **SURVIVES** (`Derived`: `I = []` implies $Q_{\text{der}} = \emptyset$) | **CHANGES bound from $\binom{n}{2}$ to $n-1$** (`Witnessed`, `3_regime_deletions.py` `[6]`: on $n=3$, separating `(0,1)` via `inst (0,(0,))` simultaneously makes `(0,1)` and `(0,2)` separable, jumping $|Q_{\text{der}}|$ from $0$ to $2$ in 1 round and reducing max rounds from $3$ to $2$) | **BREAKS monotonicity under `NewRuleAll`** (`Derived`: adding $f \in U$ when $f$ held asymmetric instances in $I$ collapses previously separated pairs, shrinking $|Q_{\text{der}}|$) |

---

## Detailed Findings on Question 2 (Derivability of Fields on Finite Carriers)

1. **`U` as the set of all tuples of `I` at fixed finite $n$** (`Witnessed`, `3_regime_deletions.py` `[1]`, `[2]`; `A/research/instance_demand/README.md:148-163`):
   - **At fixed finite $n$**: Materializing every $f \in U$ into $I$ as the full Cartesian power $\{0,\dots,n-1\}^{a_f}$ yields zero profile mismatches across all 8,424 well-formed regimes with $n \le 3, |F| \le 1, a \le 2$ (`U_materialized_into_I_profile_mismatches = 0`).
   - **What breaks**:
     - **Cost accounting**: A uniform rule on an arity-$a$ form costs $\mu_1 = 1$ item via `NewRuleAll(f)`, whereas materializing it in `I` costs $n^a$ `NewInst` items ($3^2 = 9$ items at $n=3, a=2$).
     - **Extension behaviour under carrier growth (`admitDatum`, $n \to n+1$)**: For `r_u_rule = (2, (1,), (), (0,), ())`, applying `NewDatum` yields $n=3$ with `collapsed(0, 2) = True` because $0 \in U$ automatically covers the new datum `2`. For the materialized regime `r_u_mat = (2, (1,), ((0,(0,)), (0,(1,))), (), ())`, applying `NewDatum` yields `collapsed(0, 2) = False` because `(0, (2,))` is missing from `I` (`Witnessed`, `3_regime_deletions.py` `[2]`).
2. **`F` as arities read off `I`** (`Witnessed`, `3_regime_deletions.py` `[1]`, `[3]`):
   - **At states where every form is inhabited in `I` and `U = []`**: Inferring `arity(f) = len(args)` from the instances `(f, args) in I` yields zero profile mismatches across all inhabited regimes (`F_inferred_from_inhabited_I_profile_mismatches = 0`).
   - **What breaks**:
     - **Cost accounting (`R1` and `R2`)**: In the baseline grammar, separating `(0,1)` from `I = []` requires two primitive admissions (`NewForm(1)` then `NewInst(0, [1])`), which is the entire mechanism behind `cost1_insufficient_general` ($\mu_1 = 2$) and $\mu_2 = (2,1)$. If `F` is inferred from `I` with no separate `NewForm` step, a single `NewInst(0, [1])` separates `(0,1)` at $\mu_1 = 1$ and $\mu_2 = (1,1)$.
     - **Uninhabited forms**: A form admitted with zero instances (`Forms = [1], Insts = []`) cannot be represented, eliminating the intermediate state of the sequential 2-step delta `applyDelta` (`H05`).
3. **Loophole in raw `Basic.lean:202` `validResponse` disjunction** (`Witnessed`, `3_regime_deletions.py` `[4]`):
   - In `A/lean4/Derivation/Basic.lean:198-203`, `validResponse r i j d` writes `((i, j) ∈ r'.reqs || (j, i) ∈ r'.reqs || separable r' i j)`. On `R2L` (where `R2L.reqs = []` in `Basic.lean:206`), the 1-item delta `[Item.impose 0 1]` satisfies `(0, 1) ∈ r'.reqs` at cost $\mu_1 = 1$ without separating `0` and `1` (`raw_Basic_lean_202_valid = True, separable_after_impose = False`). `Minimality.lean:28-31` and `Rounds.lean:27-35` avoid this loophole by redefining `R2L` with `reqs = [(0, 1)]` and redefining ` validResponse` to require `separable r' i j` as a conjunction rather than a disjunction.

---

## Question 3 — Capabilities Missing from the Tuple `(D, F, I, U, Q)` That the Results Use Anyway

Counting capabilities from `1_admission_ledger.md` that are **not** fields of `R = (D, F, I, U, Q)` but are used by the Genesis §§6–8 proofs:

| # | Capability Used by Genesis §§6–8 | Ledger ID | Where Used (`file:line`) | Role in Proofs |
|---|---|---|---|---|
| 1 | Ambient discrete index arithmetic (`Nat`, `<`, `==`, `decide`) | `A01`, `A03` | `A/lean4/Derivation/Basic.lean:33-53` | Supplies finite carrier indexing `0 .. n-1`, decidable equality, and arity arithmetic. |
| 2 | Well-formedness guard (`wf`) | `A09` | `A/lean4/Derivation/Basic.lean:45-53` | Rejects out-of-range indices, wrong tuple lengths, and diagonal requirements `i = j`. |
| 3 | Single-hole context extraction (`Ctx`) and uniform simultaneous hole-plugging (`plug`) | `A13`, `H04` | `A/lean4/Derivation/Basic.lean:59-81` | Defines the observation interface; `H04` plugs all `none` slots with the same datum $d$, enabling `markK(k)` to work with a single diagonal instance $[1,\dots,1]$. |
| 4 | Positive binary evaluation (`derivable`) with negated failure (`false`) | `A14` | `A/lean4/Derivation/Basic.lean:87-91` | Assigns a boolean truth value to every context-datum pair without an explicit negative instance store. |
| 5 | Extensional profile equality (`collapsed` / `separable`) | `A15` | `A/lean4/Derivation/Basic.lean:97-105` | Converts boolean derivability across contexts into pair separation. |
| 6 | Five-constructor extension grammar (`Item`, `Delta`) with sequential intra-delta state threading (`foldlM`) | `A16`, `H05` | `A/lean4/Derivation/Basic.lean:168-194` | Allows item 2 (`newInst 0 [1]`) to reference form `0` created by item 1 (`newForm 1`) inside a single delta. |
| 7 | Monotone extension and preservation policy (`validResponse`) | `A17` | `A/lean4/Derivation/Basic.lean:198-203`, `Minimality.lean:39-48` | Prohibits deletion or modification of existing `D, F, I, U, Q` entries. |
| 8 | Deduplication on admission (`∉` guards in `admitInst`, `admitRuleAll`, `impose`) | `A18` | `A/lean4/Derivation/Basic.lean:119-139` | Prevents duplicate entries from inflating `elems(r)` in `Rounds.lean` and `Progress.lean`. |
| 9 | Initial reading choice (`L` vs `F`, fixing initial `D` and `Q`) | `A19` | `A/lean4/Derivation/Minimality.lean:28-31`, `MinimalityF.lean:37-42` | Supplies the starting regime `R2L` or `R2F` and target pair `(i, j)`. |
| 10 | Two-stage lexicographic cost ledger ($\mu_1$, $\mu_2$) and selection order | `A20`, `A21` | `A/lean4/Derivation/Basic.lean:215-225` | Scores extensions by item count first and total context count second. |
| 11 | Typed regime isomorphism (`Iso`) with unordered requirement normalization (`sortPair`) | `A22`, `Minimality.lean:169-196` | `A/lean4/Derivation/Minimality.lean:169-196` | Identifies `[0]` and `[1]` on `R2L` and `[1]` and `[2]` on `R2F` as a single equivalence class. |
| 12 | Multi-round run history container (`ClosedRun`) | `A23` | `A/lean4/Derivation/Rounds.lean:45-62` | Stores the sequence of intermediate regimes and targets across rounds to bound $m$. |

**Total non-field capabilities used by the Genesis §§6–8 results**: **12 capabilities** (`Derived` from `1_admission_ledger.md`).

---

## Question 4 — Smaller Tuple Reproducing the Headline Results (`R1`–`R6`)

Within the stated grammar (`Item` constructors over finite regimes) and checked exhaustively on the stated bound ($n \le 3$, $|F| \le 1$, arity $\le 2$, delta length $\le 2$ in `3_regime_deletions.py`):

1. **For all six results `R1`–`R6` simultaneously (multi-round and both readings `L` and `F`)**:
   - The **4-tuple** `R_4 = (D, F, I, Q)` obtained by deleting `U` (`rules = []`, dropping `NewRuleAll`) reproduces **all six results `R1`–`R6` verbatim** (`Derived` and `Witnessed` in `3_regime_deletions.py` `[7]`, row `Del U (fix U=())`):
     - `R1`: minimum separating cost is $\mu_1 = 2$ (`[newForm(1), newInst(0, [1])]`).
     - `R2`: unique $\mu_2 = (2, 1)$ minimum up to `Iso` on both `R2L` and `R2F`.
     - `R3`: infinite $\mu_1 = 2$ tie family `markK(k)` for all $k \ge 1$.
     - `R4`: when `I = []`, `derivable` is identically `false`, so every pair is collapsed.
     - `R5`: multi-round bound $2(|Q_0| + m) \le n(n - 1)$ holds unchanged.
     - `R6`: `elems_4(r) = |D| + |F| + |I| + |Q|` strictly increases on every regime-changing step.
   - What is lost by dropping `U`: only the uniform-rule vs explicit-instance extension contrast under carrier growth (`Ext.lean:160-175`, `grow_demand_iff`), which is not among `R1`–`R6`.
2. **For single-round separation on a fixed reading (`R1`–`R4` and `R6`)**:
   - The **3-tuple** `R_3 = (D, F, I)` (with external target pair `(i, j)` preserved by pointed `Iso`) reproduces `R1`, `R2`, `R3`, `R4`, and `R6` (`Derived` and `Witnessed`, consistent with `omega_codex/docs/genesis_discussion.md:27-35`), while dropping `R5` (which requires `Q` to persist across rounds).
   - No **2-tuple** subset of `(D, F, I, U, Q)` reproduces `R1`–`R3` within the stated grammar (`Witnessed` by the deletion rows for `D`, `F`, and `I` in `3_regime_deletions.py` `[7]`).

### Supplied List for the Proposed 4-Tuple `R_4 = (D, F, I, Q)`

To state and prove `R1`–`R6` on `R_4 = (D, F, I, Q)`, the following items remain `Supplied`:
1. State fields `D : Nat`, `F : List Nat`, `I : List (Nat × List Nat)`, `Q : List (Nat × Nat)` (`Supplied`, restriction of `A04`–`A06`, `A08`).
2. Well-formedness predicate `wf_4` (`Supplied`, restriction of `A09`).
3. Single-hole contexts `Ctx`, uniform simultaneous `plug`, membership-based `derivable_4(r, f, args) := (f, args) ∈ r.insts`, and profile equality `collapsed` / `separable` (`Supplied`, `A13`–`A15`, `H04`).
4. Four-constructor extension grammar `Item_4 ::= newDatum | newForm(a) | newInst(f, args) | impose(i, j)` with sequential `applyDelta`, deduplication, and monotone `validResponse` (`Supplied`, `A16`–`A18`, `H05`).
5. Initial reading `R2L` or `R2F`, cost measures $\mu_1, \mu_2$, `Iso` with `sortPair`, and `ClosedRun` (`Supplied`, `A19`–`A23`).

---

## Witnessed Script Output (`python 3_regime_deletions.py`)

Command:
```text
python C:\Users\a343o\source\repos\omega_codex\audit\2026-11-05_minimal_chain\3_regime_deletions.py
```

Pasted output (`Witnessed`):
```text
=== PROMPT 3: FIVE REGIME FIELDS & DELETION / DERIVABILITY CHECKS ===

[1] BOUNDED REGIME CENSUS (n <= 3, |F| <= 1, arity <= 2)
  total_wf_regimes = 8424 (n=0: 5, n=1: 9, n=2: 82, n=3: 8328)
  regimes_with_no_insts = 60
  collapsed_of_no_insts_violations = 0
  U_materialized_into_I_profile_mismatches (fixed n) = 0
  F_inferred_from_inhabited_I_profile_mismatches = 0

[2] EXTENSION CHECK FOR U MATERIALIZATION UNDER admitDatum (n=2 -> n=3)
  at n=2: collapsed(0,1) with U=(0,): True, with I={(0,),(1,)}: True
  after admitDatum (n=3): collapsed(0,2) with U=(0,): True, with materialized I: False
  mu1 cost to admit uniform rule on arity 2 at n=3: U costs 1 item, materialized I costs 3^2 = 9 items

[3] SEPARATION SEARCH ON R2L (n=2, target=(0,1)) AND R2F (n=3, target=(1,2))
  R2L: len1_sols=0, len2_sols=6, min_mu2=(2, 1), min_mu2_states=2, iso_classes_with_Q=1, iso_classes_without_Q=1
  R2F: len1_sols=0, len2_sols=10, min_mu2=(2, 1), min_mu2_states=2, iso_classes_with_Q=1, iso_classes_without_Q=1
    R2F without Q: are_isomorphic(inst=[0], inst=[1]) = True, but separable(inst=[0], 1, 2) = False vs separable(inst=[1], 1, 2) = True

[4] BASIC.LEAN:202 DISJUNCTION CHECK FOR 1-ITEM IMPOSE DELTA
  delta = [impose(0,1)] on R2L: raw_Basic_lean_202_valid = True, separable_after_impose = False

[5] MU1 TIE FAMILY markK(k) FOR k = 1..5 ON R2L
  k=1: mu1=2, mu2=(2, 1), separable(0,1)=True
  k=2: mu1=2, mu2=(2, 4), separable(0,1)=True
  k=3: mu1=2, mu2=(2, 12), separable(0,1)=True
  k=4: mu1=2, mu2=(2, 32), separable(0,1)=True
  k=5: mu1=2, mu2=(2, 80), separable(0,1)=True
  markK(1..5) pairwise_non_isomorphic = True

[6] MULTI-ROUND BOUND 2*(|Q0|+m) <= n*(n-1) AND DERIVED-Q COLLAPSE ON n=3
  n=2: n*(n-1)=2, max canonical pair demands m <= 1 when |Q0|=0 -> 2*m <= 2
  n=3: n*(n-1)=6, max canonical pair demands m <= 3 when |Q0|=0 -> 2*m <= 6
  On n=3, after 1 round separating (0,1) via inst (0,(0,)):
    explicit Q = [(0, 1)] (size 1, allows 2 more pair-demand rounds up to m=3)
    Q_derived = {(i,j) : separable} = [(0, 1), (0, 2)] (size 2 in 1 step; max rounds drops from 3 to 2)

[7] FIELD-BY-RESULT MATRIX SUMMARY
  Variant                  | R1:cost2    | R2:mu2=(2,1) | R3:inf_ties  | R4:no_insts | R5:rnd_bnd      | R6:no_return 
  -------------------------+-------------+--------------+--------------+-------------+-----------------+--------------
  Baseline (D,F,I,U,Q)     | SURVIVES    | SURVIVES     | SURVIVES     | SURVIVES    | SURVIVES        | SURVIVES     
  Del D (fix n=0)          | BREAKS      | BREAKS       | BREAKS       | SURVIVES*   | SURVIVES*       | SURVIVES*    
  Del D (fix n=2 const)    | SURVIVES(L) | SURVIVES(L)  | SURVIVES(L)  | SURVIVES    | SURVIVES(n=2)   | SURVIVES     
  Del D (ambient Nat)      | SURVIVES    | BREAKS(inf)  | SURVIVES     | SURVIVES    | BREAKS(inf)     | SURVIVES     
  Derive D from (I,Q)      | SURVIVES(L) | CHANGES(F)   | SURVIVES     | SURVIVES    | BREAKS(Q0=0)    | BREAKS       
  Del F (fix F=())         | BREAKS      | BREAKS       | BREAKS       | SURVIVES*   | SURVIVES*       | SURVIVES*    
  Del F (fix F=(1,))       | BREAKS(c=1) | CHANGES(1,1) | BREAKS       | SURVIVES    | SURVIVES        | SURVIVES     
  Derive F from I          | BREAKS(c=1) | CHANGES(1,1) | CHANGES(c=1) | SURVIVES    | SURVIVES        | SURVIVES     
  Del I (fix I=())         | BREAKS      | BREAKS       | BREAKS       | SURVIVES*   | SURVIVES*       | SURVIVES*    
  Del U (fix U=())         | SURVIVES    | SURVIVES     | SURVIVES     | SURVIVES    | SURVIVES        | SURVIVES     
  Derive U (materialize I) | SURVIVES    | SURVIVES     | SURVIVES     | SURVIVES    | SURVIVES        | CHANGES(cost)
  Del Q (external target)  | SURVIVES    | CHANGES(F)   | SURVIVES     | SURVIVES    | BREAKS          | SURVIVES     
  Derive Q (=separable)    | SURVIVES    | CHANGES(F)   | SURVIVES     | SURVIVES    | CHANGES(m<=n-1) | BREAKS(mono)
```
