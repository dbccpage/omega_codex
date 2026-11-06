# Task 2: Restart from the Mark Alone

## Source Commits

- `A` (`C:\Users\a343o\source\repos\19L57G1`): `45bb09864f9b52ed5ecf66e977ca81f0ed623de7`
- `B` (`C:\Users\a343o\source\repos\theory_of_finite_quantum_mechanics`): `e45ed2e133920aa3790af8c5e072ee9829898490`
- `omega_codex` (`C:\Users\a343o\source\repos\omega_codex` baseline): `e21b785626ff8d0231a53409c76fe4e7a57cd59d`

---

## Question 1: With `<>` Alone and No Operation, What Follows?

1. **What follows from `<>` with no declared operation (`Derived` and `Witnessed`):**
   - **No successor is forced (`Not forced` for successor existence; `Derived` under $T = \varnothing$):** Let $X = \{m_0\}$ be the singleton carrier holding the opaque datum (`A01`, `A02`). There are two binary transition relations $T \subseteq X \times X$: $T_0 = \varnothing$ (`successor_count(m0) = 0`) and $T_1 = \{(m_0, m_0)\}$ (`successor_count(m0) = 1`). Because $T_0$ has no successor while $T_1$ has one, a successor is `Not forced` by $X = \{m_0\}$ alone (countermodel: $T_0 = \varnothing$). When the hypothesis "no operation / empty transition relation" ($T = \varnothing$) is explicitly supplied (`B/atlas/finite_obstruction_calculus/pregenesis_to_minimal_symbol_systems/paper.md:45-47`, `B/atlas/finite_obstruction_calculus/genesis/paper.md:44-46`), it follows by definition of the empty set that $\forall y \in X, (m_0, y) \notin T$ (`Derived`).
   - **Inertness is a property of the declared rule, not of the ASCII spelling `<>` (`Witnessed`):** Node `PG-INERT-DIAMOND` in `B/dag/derivation_dag.json` states: `"inertness is the model rule rather than a consequence of the spelling; verified exhaustively for all traces of length <= 5."` In `A/lean4/Derivation/Inertia.lean:17-18`, `supply_no_op` (`stepE r (.supply t) = some r`) holds by `rfl` because `stepE` (`Basic.lean:146`) defines `.supply _ => some r` (`Supplied` in `A13`).
   - **Is inertia the *only* result at the initial state? No (`Derived` and `Witnessed`):** In the `Regime` representation (`genesis = ⟨0, [], [], [], []⟩` under reading `L`, or `R_F0 = ⟨1, [], [], [], []⟩` under reading `F`), three additional results follow from `forms = []`, `insts = []`, `rules = []`:
     1. **Total underivability (`underivable_of_empty`, `A/lean4/Derivation/Inertia.lean:30-35`):** For every instance $i$, $\neg \operatorname{derivable} r\, i$ (`Derived`: `derivable r i` is `i ∈ [] ∨ i.1 ∈ []`, which is `False ∨ False`).
     2. **Total observational collapse (`collapsed_of_no_insts`, `A/lean4/Derivation/Inertia.lean:40-46`):** For all indices $d, d'$, $\operatorname{collapsed} r\, d\, d'$ (`Derived`: when `r.insts = []`, `derivable r (plug c d)` reduces to `c.form ∈ r.rules`, which is independent of $d$).
     3. **Metatheoretic self-equality (`Derived` from `A01`, `A03`):** $m_0 = m_0$ holds in the host metalanguage.

---

## Question 2: The Seven Operations and What "There Was Not a Mark, There Is a Mark" Adds

Sources: `B/atlas/finite_obstruction_calculus/pregenesis_to_minimal_symbol_systems/paper.md:109-116` (six host operations: `Mention`, `Supply`, `Designate`, `Admit`, `Retain`, `Operate`), `A/prompt/seed_prompt.md:55` (`supply`, `mention`, `admission`, `current-state designation`, `retention`, `observation`, `equality`), `B/dag/derivation_dag.json` (`PG-SIX-OPERATIONS`), and `omega_codex/docs/genesis_discussion.md:116,148-155`.

### 2.1 Separation of the Operations (`Supplied` definitions; `Witnessed` independence in `2_mark_checks.py`)

| Operation | Host signature and state effect | Changes admitted carrier `D`? | Tag |
|---|---|---|---|
| `Mention` | Refer to an inscription or candidate in metalanguage discussion (`B/pregenesis/paper.md:110`); leaves object state unchanged | No | `Supplied` (`A04`) |
| `Supply` | Deliver a payload token to the input interface (`B/pregenesis/paper.md:111`, `Basic.lean:146`); leaves admitted state unchanged (`supply_no_op`) | No | `Supplied` (`A04`, `A13`) |
| `Designate` | Point to a presentation or existing datum as the current focus (`B/pregenesis/paper.md:112`, `model.py:70-71`) | No | `Supplied` (`A04`) |
| `Admit` | Insert a datum, form, instance, or rule into the regime (`B/pregenesis/paper.md:113`, `Basic.lean:147-158`) | Yes (for new datum) | `Supplied` (`A04`, `A13`) |
| `Retain` | Preserve an admitted object or event across subsequent steps in memory or history (`B/pregenesis/paper.md:114`, `B/wdp/wdp.md:767-777`) | No (preserves across steps) | `Supplied` (`A04`, `A22`, `A33`) |
| `Observe` (or `Operate`) | Evaluate a context `plug c d` (`Basic.lean:80`) or report map `o : A -> V` (`B/pregenesis/paper.md:115,129`) to obtain an answer | No | `Supplied` (`A04`, `A05`, `A16`) |
| `Equality` | Compare two terms, states, or observation outputs via `=` (`B/pregenesis/paper.md:136`, `seed_prompt.md:55`) | No | `Supplied` (`A03`) |

### 2.2 What "There Is a Mark" Uses vs What "There Wasn't a Mark, There Is a Mark" Adds

1. **"There is a mark" (`Witnessed` in `omega_codex/docs/genesis_discussion.md:116,148-149`):**
   - Uses `Mention` (naming the mark in the host metalanguage), `Designate` (selecting it as the current item), and either `Supply` (under Reading `L`, where `<>` is supplied to the interface) or `Admit` (under Reading `F`, where `<>` is admitted as datum `0` in `D`).
   - Does **not** require `Retain` across a transition, `Observe` (a query mapping the mark to an answer), or `Equality` between two states (`Derived`: a static 1-state model $S = \{s_1\}$ with no transition and no query satisfies "there is a mark").
2. **"There wasn't a mark, there is a mark" (`Witnessed` in `omega_codex/docs/genesis_discussion.md:116,150`):**
   - Adds **two distinct states or stages** ($s_0$ = unmarked / absent state, $s_1$ = marked / present state), an **ordered transition or history** $(s_0, s_1)$, **`Retain`** (keeping $s_0$ or its absence record available for comparison after $s_1$ arrives), **`Observe`** (a presence predicate distinguishing $s_0$ from $s_1$), and **non-equality** $s_0 \ne s_1$ (`Derived`: on a 1-state model $s_0 = s_1$, "there wasn't a mark" and "there is a mark" cannot both hold consistently without a contradiction $P(s_0) \land \neg P(s_0)$).

---

## Question 3: Minimal Single Additions Yielding Any Successor (`G1`–`G10`)

**Stated grammar of single additions:** We check every single-step addition across (i) raw binary transition relations $T \subseteq X \times X$ on carrier $X$ (`G1`–`G2`), (ii) the six `Regime` event constructors `Event` / four delta items `Item` (`A/lean4/Derivation/Basic.lean:134-190`, `G3`–`G8`), and (iii) the five duplicate-token refusal modes `Mode` (`A/lean4/Derivation/Refusal.lean:59-78`, `G9`–`G10`).

| Addition (in stated grammar) | What it yields from the initial mark state | Forced by `<>`? | Evidence (proof or countermodel) and Tag |
|---|---|---|---|
| `G1`: Add self-loop $(m_0, m_0)$ to raw transition relation $T$ on $X=\{m_0\}$ | 1 identity self-successor $m_0 \to m_0$ (state unchanged; cf. `N33` in `omega_codex/docs/research_map.md:174,256`) | `Not forced` (chosen) | **Countermodel:** $T = \varnothing$ on $X=\{m_0\}$ satisfies all assumptions of `<>` alone and has `0` successors (`Witnessed` in `2_mark_checks.py` §1). |
| `G2`: Add edge $(m_0, m_1)$ to $T$ on a 2-state carrier $X=\{m_0, m_1\}$ | 1 state-changing successor $m_0 \to m_1$ (requires $m_1 \in X$ already admitted) | `Not forced` (chosen) | **Countermodel:** $T = \varnothing$ on $X=\{m_0, m_1\}$ has `0` successors; also $X=\{m_0\}$ has no second state $m_1$ (`Witnessed` in `2_mark_checks.py` §1). |
| `G3`: `Event.supply(0)` on `R_L0` (`d=0`) or `R_F0` (`d=1`) | Self-successor `some r` with `r' = r` (`supply_no_op`, `Inertia.lean:17`); extends history length by 1 | `Not forced` (chosen) | **Countermodel:** The empty event trace `h = []` leaves the system at `r` with no transition event (`Witnessed` in `2_mark_checks.py` §3). |
| `G4`: `Event.admitDatum` (or `Item.newDatum`) on `R_L0` (`d=0`) or `R_F0` (`d=1`) | State-changing successor `some { r with data := r.data + 1 }`; pairs remain collapsed (`admission_without_expressive_increase`, `Inertia.lean:75`) | `Not forced` (chosen) | **Countermodel:** Under token-aware deduplication (`stepT` in `Erasure.lean:42-43`), re-admitting `<>` on `R_F0` (`tokens = [0]`) returns `some t` with `tokens = [0]` (`single_token_carrier_bound`, `Bridge.lean:87`; `Witnessed` in `2_mark_checks.py` §3). |
| `G5`: `Event.admitForm(a)` (or `Item.newForm(a)`) with $a \ge 1$ | State-changing successor `some { r with forms := [a] }`; `insts` stays `[]`, so all data stay collapsed (`collapsed_of_no_insts`) | `Not forced` (chosen) | **Countermodel:** Histories with no `admitForm` event satisfy `no_admitForm_no_forms` (`Bridge.lean:177`) with `forms = []`; also `a = 0` is refused (`none`) (`Witnessed` in `2_mark_checks.py` §3). |
| `G6`: `Event.admitInst(0, (0,))` (or `Item.newInst`) alone | **No successor (`none`)** from `R_L0` or `R_F0` because `forms = []` (`0 < 0` fails) | `Not forced` (fails alone) | **Proof/Witness:** `no_forms_no_witness` (`Bridge.lean:220`) and `cost1_insufficient_general` (`Minimality.lean:102`); `Witnessed` in `2_mark_checks.py` §3 (`valid=False`). |
| `G7`: `Event.admitRuleAll(0)` (or `Item.newRuleAll`) alone | **No successor (`none`)** from `R_L0` or `R_F0` because `forms = []` (`0 < 0` fails) | `Not forced` (fails alone) | **Proof/Witness:** `Basic.lean:157,189` requires `f < r.forms.length`; `Witnessed` in `2_mark_checks.py` §3 (`valid=False`). |
| `G8`: `Event.impose(0, 1)` alone | **No successor (`none`)** from `R_L0` (`d=0`) or `R_F0` (`d=1`) because `1 < r.data` fails | `Not forced` (fails alone) | **Proof/Witness:** `Basic.lean:160` requires `i < j ∧ j < r.data`, which requires `r.data >= 2`; `Witnessed` in `2_mark_checks.py` §3 (`valid=False`). |
| `G9`: Duplicate `admitTok(0)` under `Mode.fact` on `s = ⟨[0], [], 0⟩` | State-changing successor `⟨[0], [], 1⟩` (increments refusal counter while keeping carrier size 1; `fact_state_changes`, `Refusal.lean:173`) | `Not forced` (chosen) | **Countermodel:** Under `Mode.silent` or `Mode.metaMarker`, `stepR m ⟨[0], [], 0⟩ (.admitTok 0) = ⟨[0], [], 0⟩` (`silent_state_fixed`, `Refusal.lean:178`; `Witnessed` in `2_mark_checks.py` §3). |
| `G10`: Duplicate `admitTok(0)` under `Mode.reifyUntagged` (`G10a`) or `Mode.reifyTagged` (`G10b`) on `⟨[0], [], 0⟩` | Carrier-growing successor `⟨[0, 0], [], 0⟩` (collapsed) or `⟨[0, 0], [1], 0⟩` (separated by built-in tag `1 ∈ tags`; `Refusal.lean:214-230`) | `Not forced` (chosen) | **Countermodel:** `Mode.silent` leaves state fixed at `⟨[0], [], 0⟩` (`nonreify_carrier_bound`, `Refusal.lean:142`; `Witnessed` in `2_mark_checks.py` §3). |

---

## Question 4: Does the Carrier of the Mark Matter (`Nat`, `Unit`, or an Opaque Type)?

We compare six carriers in `2_mark_checks.py`: `Unit` ($|C|=1$), `Opaque1` ($|C|=1$), `Opaque2` ($|C|=2$, no intrinsic `<`), `Bool` ($|C|=2$, ordered `False < True`), `Fin3` ($|C|=3$, ordered), and `Nat_prefix4` ($|C|=4$, ordered prefix of `Nat`).

### 4.1 Results That Do NOT Change Under Carrier Swap (`Derived` and `Witnessed`)

1. **Empty-transition inertia (`empty_T_inert = True`):** On every carrier $C$, if $T = \varnothing$, no element has a successor (`Derived` from $\varnothing$ definition; `Witnessed` across all 6 carriers in `2_mark_checks.py` §4).
2. **Empty-instance collapse (`collapsed_of_no_insts`):** On every carrier $C$, when `insts = []`, every pair $(x, y) \in C \times C$ has identical positive derivability profile (`Derived` in `Inertia.lean:40-46`).
3. **Bare self-relation consistency (`selfdiff_consistent`):** On every nonempty carrier ($|C| \ge 1$), there exists at least one nonempty binary relation $R \subseteq C \times C$ (namely $R = \{(x_0, x_0)\}$, giving `bare_witness_models >= 1`; `Witnessed` in `2_mark_checks.py` §4).
4. **Soundness of irreflexivity across all carriers (`irrefl_implies_ne = True`):** On every carrier $C$, for every irreflexive relation $R$ on $C$, $(a, b) \in R \implies a \ne b$ (`Derived` by substitution of $a = b$ into $\neg R(a,a)$; `Witnessed` across all 6 carriers in `2_mark_checks.py` §4; holds vacuously on `Unit` and `Opaque1` where `inhabited_irrefl_models = 0`).

### 4.2 Results That DO Change Under Carrier Swap (`Derived` and `Witnessed`)

1. **Existence of an inhabited irreflexive relation (`inhabited_irrefl_models`) and pairwise separation:**
   - On `Unit` and `Opaque1` ($|C| = 1$): `inhabited_irrefl_models = 0` and `unordered_req_pairs = 0`. By `no_witness_on_subsingleton` (`A/lean4/Derivation/PrimDiff.lean:84`), no irreflexive relation can be inhabited on a 1-element carrier.
   - On `Opaque2` and `Bool` ($|C| = 2$): `inhabited_irrefl_models = 3` (namely `D2`, `D2rev`, and `S2`) and `unordered_req_pairs = 1`.
   - On `Fin3` ($|C| = 3$): `inhabited_irrefl_models = 63` ($2^{3 \times 2} - 1$) and `unordered_req_pairs = 3`.
   - On `Nat_prefix4` ($|C| = 4$): `inhabited_irrefl_models = 4095` ($2^{4 \times 3} - 1$) and `unordered_req_pairs = 6`.
2. **Canonical ordered storage of unordered requirements (`canonical_lt_order`):**
   - Swapping `Bool` or `Nat` for `Opaque2 = {"m0", "m1"}` (a 2-element carrier with equality `=` but no intrinsic linear order `<`) breaks `Regime.wf`'s representation of unordered requirements as ordered pairs `q.1 < q.2` (`A/lean4/Derivation/Basic.lean:70`) without an additional symmetry-breaking orientation choice (`no_swap_fixed_offdiag_pair`, `Bridge.lean:281`; `Witnessed` in `2_mark_checks.py` §4: `canonical_lt_order = False` for `Opaque2` vs `True` for `Bool`, `Fin3`, `Nat_prefix4`).
3. **Unbounded arity ties (`markK`) and unbounded datum growth:**
   - Proving that $\mu_1$ has infinitely many non-isomorphic minimum responses (`markK_pairwise_noniso`, `Minimality.lean:355`) uses `Nat` to supply unbounded arities $k \ge 1$. A finite carrier without `Nat` arities cannot index the infinite tie family.

---

## Witnessed Execution Output (`python 2_mark_checks.py`)

Command executed in `C:\Users\a343o\source\repos\omega_codex\audit\2026-11-05_minimal_chain`:
```text
python 2_mark_checks.py
```

Pasted output:
```text
=== 1. MARK ALONE AND TRANSITION MODELS ON {m0} ===
Relation T=set(): successor_count(m0)=0, has_successor=False
Relation T={('m0', 'm0')}: successor_count(m0)=1, has_successor=True
Successor forced across unconstrained T on {m0}? False
No-successor forced across unconstrained T on {m0}? False
No-successor holds under declared T=empty? True

=== 2. SEVEN OPERATIONS SEPARATION CHECK ===
Op=Mention   -> admitted=(), supplied=(), designated=None, retained=(), obs=set(), eq=False
Op=Supply    -> admitted=(), supplied=('<>',), designated=None, retained=(), obs=set(), eq=False
Op=Designate -> admitted=(), supplied=(), designated=<>, retained=(), obs=set(), eq=False
Op=Admit     -> admitted=('<>',), supplied=(), designated=None, retained=(), obs=set(), eq=False
Op=Retain    -> admitted=(), supplied=(), designated=None, retained=('<>',), obs=set(), eq=False
Op=Observe   -> admitted=(), supplied=(), designated=None, retained=(), obs={('<>', True)}, eq=False
Op=Equality  -> admitted=(), supplied=(), designated=None, retained=(), obs=set(), eq=True
All 7 single-operation outcomes pairwise distinct? True (7/7)
Operations that change admitted carrier: ['Admit']

=== 3. MINIMAL SINGLE ADDITIONS (GRAMMAR G1-G10) ===
G3: supply(0)          | from R_L0(d=0): valid=True , state_changed=False | from R_F0(d=1): valid=True , state_changed=False
G4: admitDatum         | from R_L0(d=0): valid=True , state_changed=True  | from R_F0(d=1): valid=True , state_changed=True 
G5: admitForm(1)       | from R_L0(d=0): valid=True , state_changed=True  | from R_F0(d=1): valid=True , state_changed=True 
G6: admitInst(0,(0,))  | from R_L0(d=0): valid=False, state_changed=False | from R_F0(d=1): valid=False, state_changed=False
G7: admitRuleAll(0)    | from R_L0(d=0): valid=False, state_changed=False | from R_F0(d=1): valid=False, state_changed=False
G8: impose(0,1)        | from R_L0(d=0): valid=False, state_changed=False | from R_F0(d=1): valid=False, state_changed=False
Refusal mode silent               on duplicate admitTok(0): state_changed=False, carrier_len=1
Refusal mode metaMarker           on duplicate admitTok(0): state_changed=False, carrier_len=1
Refusal mode fact (G9)            on duplicate admitTok(0): state_changed=True, carrier_len=1
Refusal mode reifyUntagged (G10a) on duplicate admitTok(0): state_changed=True, carrier_len=2
Refusal mode reifyTagged (G10b)   on duplicate admitTok(0): state_changed=True, carrier_len=2

=== 4. CARRIER SWAP COMPARISON ===
Carrier=Unit        (|C|=1): empty_T_inert=True, bare_witness_models=    1, inhabited_irrefl_models=   0, irrefl_implies_ne=True, unordered_req_pairs=0, canonical_lt_order=False
Carrier=Opaque1     (|C|=1): empty_T_inert=True, bare_witness_models=    1, inhabited_irrefl_models=   0, irrefl_implies_ne=True, unordered_req_pairs=0, canonical_lt_order=False
Carrier=Opaque2     (|C|=2): empty_T_inert=True, bare_witness_models=   15, inhabited_irrefl_models=   3, irrefl_implies_ne=True, unordered_req_pairs=1, canonical_lt_order=False
Carrier=Bool        (|C|=2): empty_T_inert=True, bare_witness_models=   15, inhabited_irrefl_models=   3, irrefl_implies_ne=True, unordered_req_pairs=1, canonical_lt_order=True
Carrier=Fin3        (|C|=3): empty_T_inert=True, bare_witness_models=  511, inhabited_irrefl_models=  63, irrefl_implies_ne=True, unordered_req_pairs=3, canonical_lt_order=True
Carrier=Nat_prefix4 (|C|=4): empty_T_inert=True, bare_witness_models=65535, inhabited_irrefl_models=4095, irrefl_implies_ne=True, unordered_req_pairs=6, canonical_lt_order=True
```
