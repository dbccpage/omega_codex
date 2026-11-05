# Prompt 4 — Priced Containers or `F1-frozen` / `F2-frozen`

## Pinned Repository Commits

| Repository | Path | Git Commit (`HEAD`) |
|---|---|---|
| `A` (`19L57G1`) | `C:\Users\a343o\source\repos\19L57G1` | `45bb09864f9b52ed5ecf66e977ca81f0ed623de7` |
| `B` (`theory_of_finite_quantum_mechanics`) | `C:\Users\a343o\source\repos\theory_of_finite_quantum_mechanics` | `e45ed2e133920aa3790af8c5e072ee9829898490` |
| `omega_codex` (baseline) | `C:\Users\a343o\source\repos\omega_codex` | `e21b785626ff8d0231a53409c76fe4e7a57cd59d` |

---

## Exact Definitions (Fixed Before Analysis)

- **`container`** (`Supplied`, `A/lean4/Derivation/Basic.lean:33-39`, `A/lean4/Derivation/Horizon.lean:53-56`, `B/atlas/finite_obstruction_calculus/witnessed_difference_programme/witnessed_difference_programme.md:274-303`, `B/atlas/projection_obstruction/m_compatible_gauge_classification/m_compatible_gauge_classification.md:63-83`): A declared carrier, state tuple (`Regime = (D, F, I, U, Q)` or `World`), host diagram (`(P, E_cov, F, r)`), or retention store (`E_ret`, `ClosedRun`) into which a transition step writes or from which a predicate reads.
- **`priced`** (`Supplied`, `WDP-CH01-D02` at `wdp.md:280-291`, `WDP-CH01-D03` at `wdp.md:293-303`, `WDP-CH03-D01` at `wdp.md:615-645`, `Basic.lean:215-225`): A container or step admission whose entry is recorded and charged in a declared cost or loss ledger (`mu1`, `mu2`, `Pi_3 = (c_wit, c_ret, c_op, c_id)`, `World.budget`, or `Cat_Res` loss ledger `L`). An **unpriced container** is a declared state space and transition relation with no cost function or budget gate.
- **`F1-frozen`** (`Supplied`, Prompt 4 definition): Relative to a declared transition relation $s \to s'$ and selection rule $S$, a state $s$ is **`F1-frozen`** iff **no single distinct successor is forced** from $s$ — that is, either (i) quiescence ($s \to s$ or no step) is permitted, or (ii) $|S(s)| = 0$, or (iii) $|S(s)| \ge 2$ with non-equivalent successors (an unresolved tie).
- **`F2-frozen`** (`Supplied`, Prompt 4 definition): Relative to a declared transition relation $s \to s'$, a state $s$ is **`F2-frozen`** iff **no distinct successor is possible** from $s$ — that is, $\{s' \neq s : s \to s'\} = \emptyset$. Every `F2-frozen` state is also `F1-frozen`, whereas a state with $\ge 1$ possible successor that is optional or tied is `F1-frozen` and `not F2-frozen`.

---

## State-by-State Table (`F1-frozen` vs `F2-frozen`, Unfreezing Mechanism, Inside/Outside, Evidence)

| State | `F1-frozen`? | `F2-frozen`? | What Unfreezes It | Inside / Outside | Evidence (`Tag` + Source / Check) |
|---|---|---|---|---|---|
| **S0. Mark alone `<>` (no operation admitted)** | **Yes (`F1-frozen`)** | **Yes (`F2-frozen`)** | Admitting a carrier enlargement (`0 -> 1`) and a transition or admission operation (`NewDatum`, `NewForm`) | **Outside** (`Supplied`) | `Witnessed` & `Derived`: `B/dag/derivation_dag.json` (`PG-INERT-DIAMOND`), `2_mark_checks.py` `[1]`, `4_frozen_checks.py` `[1]` (`valid_responses = 0`). |
| **S1a. Genesis Stage 1 `R1 = (1, [], [], [], [])` under `validResponse`** | **Yes (`F1-frozen`)** | **Yes (`F2-frozen`)** | Carrier growth (`NewDatum`, $n=1 \to 2$) plus requirement admission (`impose 0 1`) | **Outside** (`Supplied`) | `Derived`: `A/lean4/Derivation/Inertia.lean:51-66` (`no_valid_response_R1`, `R1_inert`: $i, j < 1 \implies i = j$, contradicting `i != j`). `Witnessed`: `4_frozen_checks.py` `[1]`. |
| **S1b. Genesis Stage 1 `R1 = (1, [], [], [], [])` under raw `applyItem`** | **Yes (`F1-frozen`)** | **No (`not F2-frozen`)** | An external step schedule / driver choosing between `NewDatum` and `NewForm(k)` ($k \ge 1$) | **Outside** (`Supplied`) | `Witnessed`: `4_frozen_checks.py` `[1]` (`3` distinct 1-step states at arity $\le 2$: `NewDatum`, `NewForm(1)`, `NewForm(2)`). `Derived`: `A/research/dynamics_step/STATUS.md:30-40` (Rule `R2`). |
| **S2a. Bare 2-datum regime `R2L_bare = (2, [], [], [], [])` (no active `reqs`)** | **Yes (`F1-frozen`)** | **Yes (`F2-frozen`)** under separation; **No (`not F2-frozen`)** under raw `applyItem` | Supplied demand `impose(0, 1)` (or initial requirement `reqs = [(0, 1)]`) | **Outside** (`Supplied`) | `Derived`: `A/research/endogenous_demand/README.md:12-28` (`reqs_preserved_of_no_impose`: requirements never arise without `impose`). `Witnessed`: `4_frozen_checks.py` `[1]`. |
| **S2b. Challenge regime `R2L = (2, [], [], [], [(0,1)])` under unpriced `validResponse` or $\mu_1$ min** | **Yes (`F1-frozen`)** | **No (`not F2-frozen`)** | Second-stage context-size cost $\mu_2 = (|\Delta|, |\text{Ctx}|)$ plus `Iso` quotient (or an external tie-breaker) | **Outside** (`Supplied`) | `Derived`: `A/lean4/Derivation/Minimality.lean:105-115` (`deltaU0_valid`, so `not F2-frozen`) and `Minimality.lean:380-416` (`markK_pairwise_noniso`, infinite $\mu_1=2$ ties, so `F1-frozen`). `Witnessed`: `4_frozen_checks.py` `[1]` (`6` states in `3` `Iso` classes at $a \le 2$). |
| **S2c. Challenge regime `R2L = (2, [], [], [], [(0,1)])` under $\mu_2$ min or WDP $\Pi_3$ (concrete state)** | **Yes (`F1-frozen` on concrete states)**; **No (`not F1-frozen` up to `Iso`)** | **No (`not F2-frozen`)** | Supplying the isomorphism quotient `Iso` (`swap01`) or an external tie-breaking selector (`deltas[0]`) between `U0` (`[1]`) and `U1` (`[0]`) | **Outside** (`Supplied`) | `Derived`: `A/lean4/Derivation/Minimality.lean:451-487` (`mu2_unique`), `WDP-CH03-P03` (`wdp.md:655-680`: `[0]` and `[1]` tie at $\Pi_3 = (1,1,1,0)$). `Witnessed`: `4_frozen_checks.py` `[1]`, `[2]`. |
| **S3a. Challenge regime `R2F = (3, [], [], [], [(1,2)])` under unpriced `validResponse` or $\mu_1$ min** | **Yes (`F1-frozen`)** | **No (`not F2-frozen`)** | Second-stage cost $\mu_2$ plus `Iso` quotient (`swap12`) | **Outside** (`Supplied`) | `Derived` & `Witnessed`: `A/lean4/Derivation/MinimalityF.lean:45-55`, `4_frozen_checks.py` `[1]` (`10` valid responses in `5` `Iso` classes at $|\Delta| \le 2, a \le 2$). |
| **S3b. Challenge regime `R2F = (3, [], [], [], [(1,2)])` under $\mu_2$ min (concrete vs `Iso`)** | **Yes (`F1-frozen` on concrete states)**; **No (`not F1-frozen` up to `Iso`)** | **No (`not F2-frozen`)** | Supplying `Iso` (`swap12` fixing `0`) or external tie selection between `U0F` (`[1]`) and `U2F` (`[2]`) | **Outside** (`Supplied`) | `Derived`: `A/lean4/Derivation/MinimalityF.lean:86-197` (`mu2_unique_F`). `Witnessed`: `4_frozen_checks.py` `[1]` (`2` concrete states in `1` `Iso` class). |
| **S4. Closed regime `U0 = (2, [1], [(0,[1])], [], [(0,1)])` at closure endpoint** | **Yes (`F1-frozen`)** | **Yes (`F2-frozen`)** for new pair demands on $n=2$ | External carrier growth (`NewDatum`, $n=2 \to 3$) plus fresh demand (`impose`) | **Outside** (`Supplied`) | `Derived`: `A/lean4/Derivation/Rounds.lean:251-265` ($2(1+m) \le 2 \implies m=0$). `Witnessed` quote: `B/atlas/finite_obstruction_calculus/genesis/paper.md:476-481` (`"reaching a closed regime does not by itself supply a fresh datum or a new goal"`). |
| **S5. `Horizon.lean` world `specWorld k` (`budget = 0`, quiescent)** | **Yes (`F1-frozen`)** | **Yes (`F2-frozen`)** for `addView` (`budget = 0`) | External driver schedule `blockEvents (m+1)` injecting `.setBudget 1`, `.admitTok (m+1)`, `.require 0 (m+1)`, `.addView [m+1]` | **Outside** (`Supplied`) | `Derived`: `A/lean4/Derivation/Horizon.lean:155-161`, `236-250` (`worldAt_spec`), `A/research/ignition/README.md:19-41` (`quiescent_fixed`). `Witnessed`: `4_frozen_checks.py` `[4]`. |

---

## One-Paragraph Tagged Verdicts for Questions 1–5

### Question 1 Verdict (`Derived` and `Witnessed`)
From the mark alone (`<>` with no operation) and from the single-datum regime `R1 = (1, [], [], [], [])` under `validResponse`, the system is both **`F1-frozen`** and **`F2-frozen`** (`Derived` in `A/lean4/Derivation/Inertia.lean:51-66`; `Witnessed` in `4_frozen_checks.py` `[1]` with `0` valid responses). From the Genesis challenge regimes `R2L = (2, [], [], [], [(0,1)])` and `R2F = (3, [], [], [], [(1,2)])`, the system is **`not F2-frozen`** because valid separating extensions exist (`6` on `R2L` and `10` on `R2F` within $|\Delta| \le 2, a \le 2$, `Witnessed` in `4_frozen_checks.py` `[1]`), and it remains **`F1-frozen`** at every concrete level: (a) without an execution trigger, an unsatisfied requirement does not force a transition (`A/research/dynamics_step/STATUS.md:37-40`, Rule `R2`); (b) under $\mu_1$ minimization alone, infinitely many non-isomorphic extensions `markK(k)` tie at $\mu_1 = 2$ (`Minimality.lean:380-416`); and (c) under $\mu_2 = (2, 1)$ minimization, two distinct concrete states still tie (`U0` vs `U1` on `R2L`; `U0F` vs `U2F` on `R2F`), so `R2L` and `R2F` become **`not F1-frozen` only after quotienting by `Iso`** (`Minimality.lean:451-487`, `MinimalityF.lean:86-197`).

### Question 2 Verdict (`Supplied`, `Derived`, and `Witnessed`)
Every mechanism that unfreezes an `F1-frozen` or `F2-frozen` state across the three repositories is **supplied from outside the state tuple**, not generated inside it: (1) **supplied demand** (`impose` / initial `reqs`) is external (`Supplied` in `Basic.lean:136-139`; `Derived` in `A/research/endogenous_demand/README.md:12-28`, `reqs_preserved_of_no_impose`, showing no internal operation creates a requirement); (2) **external schedule / ignition** (`blockEvents` in `Horizon.lean:240-250` and `Driver.lean`) is external (`Derived` in `A/research/ignition/README.md:19-41`, `quiescent_fixed`, showing quiescent worlds never step without an external event list); (3) **carrier growth** (`NewDatum` / `admitDatum`) is an external choice (`Supplied` in `Basic.lean:109-110`, `B/atlas/finite_obstruction_calculus/genesis/paper.md:476-481`); (4) **price ledgers** ($\mu_1, \mu_2$ in `Basic.lean:215-225` and $\Pi_3$ in `WDP-CH03-D01`) are external evaluation functions (`Supplied`); and (5) **tie selection** (`Iso` in `Minimality.lean:176-196` or first-witness indexing `deltas[0]`) is an external declaration (`Supplied`, `A/research/dynamics_step/STATUS.md:13-18`, `39`, Rule `R4`).

### Question 3 Verdict (`Derived` and `Witnessed` by Countermodels)
A priced container is **not** necessary for a state to have a possible successor (`not F2-frozen`) or a uniquely forced successor (`not F1-frozen`) (`Not forced`, `Witnessed` in `4_frozen_checks.py` `[3]`, `[4]`). First, for `F2-frozen`, unpriced `Regime` already has $6$ valid separating responses on `R2L` and $10$ on `R2F` inside $|\Delta| \le 2, a \le 2$, whereas adding a budget price gate in `Horizon.lean:155-161` (`0 < w.budget`) makes `specWorld k` at `budget = 0` **`F2-frozen`** for `addView` (`4_frozen_checks.py` `[4]`). Second, for `F1-frozen`, `4_frozen_checks.py` `[3]` exhibits two explicit **unpriced container countermodels** whose successor is uniquely forced (`not F1-frozen` and `not F2-frozen`): `Countermodel U1` (a 2-state deterministic transition system $0 \to 1$ with no cost ledger, `distinct_succ(0) = [1]`) and `Countermodel U2` (an unpriced `Regime` on `R2L` whose admission grammar is restricted to unary forms and canonical second-endpoint marks, yielding `distinct_succ(R2L) = [U0]` of size $1$ with zero cost ledger). Only when the admission grammar is first chosen to be unrestricted across all arities $a \ge 1$ and all tuple positions does an unpriced `Regime` admit infinitely many non-isomorphic responses `markK(k)` (`Derived` from `Minimality.lean:380-416`).

### Question 4 Verdict (`Derived` and `Witnessed`)
Pricing is not needed to move at all (it never turns an `F2-frozen` state into a `not F2-frozen` state), and even for tie-breaking it only narrows the menu of ties without eliminating the final concrete tie (`Derived` and `Witnessed`, `4_frozen_checks.py` `[1]`, `[2]`; `WDP-CH03-P03` at `wdp.md:655-680`). On `R2L`, moving from the unpriced valid-response menu ($6$ states in $3$ `Iso` classes at $a \le 2$) to $\mu_1$ pricing leaves all $6$ states tied at $\mu_1 = 2$, and moving to $\mu_2 = (2, 1)$ or WDP's four-component price vector $\Pi_3 = (c_{\text{wit}}, c_{\text{ret}}, c_{\text{op}}, c_{\text{id}})$ leaves the two opposite unary marks `U0 = (2, [1], [(0,[1])], [], [(0,1)])` and `U1 = (2, [1], [(0,[0])], [], [(0,1)])` tied at $\mu_2 = (2, 1)$ and $\Pi_3 = (1, 1, 1, 0)$ (`Witnessed` in `4_frozen_checks.py` `[2]`). Consequently, concrete state selection remains **`F1-frozen`** after all declared pricing is applied, and resolving that surviving tie requires a non-price symmetry quotient (`Iso`) or an external choice (`WDP-CH03-P03`).

### Question 5 Verdict (`Derived` and `Witnessed`)
The price ledger itself requires a host container — specifically, a carrier equipped with addition, comparison, and subtraction or lexicographic ordering (`Nat` for $\mu_1$ and `World.budget`, `Nat × Nat` for $\mu_2$, $\mathbb{N}^4$ for $\Pi_3$, or $\mathbb{R}_{\ge 0}$ and `Cat_Res` loss ledger $L_{\text{host},\text{gauge}}$ in `B/atlas/projection_obstruction/m_compatible_gauge_classification/m_compatible_gauge_classification.md:70-122`) (`Derived` and `Witnessed`). That host container is not neutral: in `A/lean4/Derivation/Horizon.lean:22-35` (`C10 cross-language budget exactness`), changing the budget ledger's carrier from integer arithmetic $\mathbb{Z}$ (`0 - 1 = -1`) to saturating natural arithmetic `Nat` (`max(0, 0 - 1) = 0`) alters the reachable state space (`Witnessed` in `4_frozen_checks.py` `[4]`). This container regress (object container $\to$ price ledger container $\to$ packet loss-ledger container) does not terminate by an internal derivation; it stops at the unpriced ambient metalanguage (`Nat`, `List`, `Prop`, `<` in `Basic.lean`, and the declared antecedent in `m_compatible_gauge_classification.md:82`), and that stopping boundary is explicitly **`Supplied`** (`A01`–`A03` in `1_admission_ledger.md`).

---

## Witnessed Script Output (`python 4_frozen_checks.py`)

Command:
```text
python C:\Users\a343o\source\repos\omega_codex\audit\2026-11-05_minimal_chain\4_frozen_checks.py
```

Pasted output (`Witnessed`):
```text
=== PROMPT 4: PRICED CONTAINERS OR F1-FROZEN / F2-FROZEN CHECKS ===

[1] SUCCESSOR CENSUS ACROSS STATES AND UNFREEZING MECHANISMS (bound: |Delta|<=2, arity<=2)
  State: Mark alone <> (no ops)
    valid_responses = 0 -> F1-frozen, F2-frozen
  State: R1 = (1,[],[],[],[])
    raw_1step_admissions (arity<=2): 3 distinct states
    valid_separating_responses: 0 states (0 Iso classes)
    under no step policy (quiescence allowed): F1-frozen, F2-frozen
    under forced-step + unpriced validResponse: F1-frozen, F2-frozen
    under forced-step + mu1 min: 0 states (0 Iso classes) -> F1-frozen, F2-frozen
    under forced-step + mu2 min (concrete): 0 states -> F1-frozen, F2-frozen
    under forced-step + mu2 min + Iso quotient: 0 Iso class -> F1-frozen, F2-frozen
  State: R2L_bare = (2,[],[],[],[])
    raw_1step_admissions (arity<=2): 4 distinct states
    valid_separating_responses: 0 states (0 Iso classes)
    under no step policy (quiescence allowed): F1-frozen, F2-frozen
    under forced-step + unpriced validResponse: F1-frozen, F2-frozen
    under forced-step + mu1 min: 0 states (0 Iso classes) -> F1-frozen, F2-frozen
    under forced-step + mu2 min (concrete): 0 states -> F1-frozen, F2-frozen
    under forced-step + mu2 min + Iso quotient: 0 Iso class -> F1-frozen, F2-frozen
  State: R2L = (2,[],[],[],[(0,1)])
    raw_1step_admissions (arity<=2): 3 distinct states
    valid_separating_responses: 6 states (3 Iso classes)
    under no step policy (quiescence allowed): F1-frozen, not F2-frozen
    under forced-step + unpriced validResponse: F1-frozen, not F2-frozen
    under forced-step + mu1 min: 6 states (3 Iso classes) -> F1-frozen, not F2-frozen
    under forced-step + mu2 min (concrete): 2 states -> F1-frozen, not F2-frozen
    under forced-step + mu2 min + Iso quotient: 1 Iso class -> not F1-frozen, not F2-frozen
  State: R2F = (3,[],[],[],[(1,2)])
    raw_1step_admissions (arity<=2): 5 distinct states
    valid_separating_responses: 10 states (5 Iso classes)
    under no step policy (quiescence allowed): F1-frozen, not F2-frozen
    under forced-step + unpriced validResponse: F1-frozen, not F2-frozen
    under forced-step + mu1 min: 10 states (5 Iso classes) -> F1-frozen, not F2-frozen
    under forced-step + mu2 min (concrete): 2 states -> F1-frozen, not F2-frozen
    under forced-step + mu2 min + Iso quotient: 1 Iso class -> not F1-frozen, not F2-frozen
  State: U0_closed = (2,[1],[(0,[1])],[],[(0,1)])
    raw_1step_admissions (arity<=2): 5 distinct states
    valid_separating_responses: 0 states (0 Iso classes)
    under no step policy (quiescence allowed): F1-frozen, F2-frozen
    under forced-step + unpriced validResponse: F1-frozen, F2-frozen
    under forced-step + mu1 min: 0 states (0 Iso classes) -> F1-frozen, F2-frozen
    under forced-step + mu2 min (concrete): 0 states -> F1-frozen, F2-frozen
    under forced-step + mu2 min + Iso quotient: 0 Iso class -> F1-frozen, F2-frozen

[2] WDP-CH03-P03 SURVIVING TIE CHECK UNDER PRICED LEDGER Pi_3 AND mu2
  U0 = Regime(data=2, forms=(1,), insts=((0, (1,)),), rules=(), reqs=((0, 1),)), mu2 = (2, 1), Pi_3 = (1, 1, 1, 0)
  U1 = Regime(data=2, forms=(1,), insts=((0, (0,)),), rules=(), reqs=((0, 1),)), mu2 = (2, 1), Pi_3 = (1, 1, 1, 0)
  U0 != U1: True, Pi_3(U0) == Pi_3(U1): True, are_isomorphic(U0, U1): True
  Result: Pricing alone leaves concrete state selection F1-frozen between U0 and U1.

[3] QUESTION 3 COUNTERMODELS: UNPRICED CONTAINERS WITH FORCED SUCCESSOR (NOT F1-FROZEN, NOT F2-FROZEN)
  Countermodel U1 (unpriced 2-state deterministic transition 0 -> 1): distinct_succ(0) = [1] (count=1) -> not F1-frozen, not F2-frozen
  Countermodel U2 (unpriced canonical-grammar Regime on R2L): distinct_succ(R2L) = [Regime(data=2, forms=(1,), insts=((0, (1,)),), rules=(), reqs=((0, 1),))] (count=1) -> not F1-frozen, not F2-frozen

[4] HORIZON.LEAN BUDGET GATE & LEDGER HOST REGRESS CHECK (Nat vs Int)
  World at budget=0: priced_addView_possible=False (F2-frozen), unpriced_addView_possible=True (not F2-frozen)
  World at budget=1: priced_addView_possible=True (not F2-frozen), unpriced_addView_possible=True (not F2-frozen)
  Ledger host container at budget=0 after gateBudget-off decrement: Nat_host=0 vs Int_host=-1 (mismatch=True)
```
