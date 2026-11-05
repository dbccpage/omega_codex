# Task 6 (Part A): Minimal Derivation Chain from `<>` to `a != b` and `(X, E, tau, K)`

## Source Commits

- `A` (`C:\Users\a343o\source\repos\19L57G1`): `45bb09864f9b52ed5ecf66e977ca81f0ed623de7`
- `B` (`C:\Users\a343o\source\repos\theory_of_finite_quantum_mechanics`): `e45ed2e133920aa3790af8c5e072ee9829898490`
- `omega_codex` (`C:\Users\a343o\source\repos\omega_codex` baseline): `e21b785626ff8d0231a53409c76fe4e7a57cd59d`

Path abbreviations:
- `B/pregenesis/paper.md` = `B/atlas/finite_obstruction_calculus/pregenesis_to_minimal_symbol_systems/paper.md`
- `B/genesis/paper.md` = `B/atlas/finite_obstruction_calculus/genesis/paper.md`
- `B/wdp/wdp.md` = `B/atlas/finite_obstruction_calculus/witnessed_difference_programme/witnessed_difference_programme.md`

---

## 1. Pruning Note on Root Inscription `<>` (`A02`)

Before assembling the table under the rule *"Keep only additions that a later step uses"*, we record the status of `<>` (`A02`):
- **Unused as a formal premise (`Derived` and `Witnessed`):** Neither `PrimDiff.irrefl_witness_ne` (`A/lean4/Derivation/PrimDiff.lean:42-44`), nor Genesis §9 Proposition 3 (`B/genesis/paper.md:412-420`), nor `WDP-CH01-P02` (`B/wdp/wdp.md:464-474`), nor `WDP-CH01-D01` (`B/wdp/wdp.md:388-393`) references `<>`. `PrimDiff.lean:6-7` states: *"Nothing here depends on the Regime machinery of Basic.lean."* Node `PG-INERT-DIAMOND` (`B/dag/derivation_dag.json:870`) records that `<>` with no operation is inert (`2_mark_checks.py` §1).
- **How `<>` enters if retained:** If `<>` is kept as the starting token of the chain, its only downstream use is to serve as the first designated element $a := \text{<>} \in X$ in Step `S2` below. We include `Step 0` in the table to mark the prompt's starting point `<>`, and give the `Supplied` count both with and without `Step 0`.

---

## 2. Minimal Chain Table (`<>` $\to$ `a != b` $\to$ `C = (X, E, tau, K)`)

| step | what is added | tag | forced? | evidence (file:line or command) |
|---|---|---|---|---|
| `Step 0` (pruned on direct path; optional label $a := \text{<>}$) | Root inscription `<>` declared as an opaque token (`A02`). Used downstream only if identified with endpoint $a \in X$ in `S2`; unused by the proof of `a != b`. | `Supplied` (by prompt seed, `A/prompt/seed_prompt.md:11-15`; `B/pregenesis/paper.md:37`; `B/genesis/paper.md:36`) | `Not forced` — the host metalanguage `S1` contains the empty type `Empty` (`False`) with no designated token (`2_mark_alone.md:14`, `5_unrecognised_forcing.md:23`). | `A/lean4/Derivation/PrimDiff.lean:6-7`; `B/dag/derivation_dag.json:870` (`PG-INERT-DIAMOND`); `python 2_mark_checks.py` |
| `Step 1` (`S1` = `A01` + `A03`) | Host metalanguage with types, implication `->`, falsity `False`, and equality `=` with reflexivity `Eq.refl` and substitution `Eq.subst : a = b -> P a -> P b` (defining `a != b` as `a = b -> False`). | `Supplied` (by authors in `B/pregenesis/paper.md:28-30,136`; `B/genesis/paper.md:27-30`; `A/lean4/Derivation/PrimDiff.lean:9-11,43-44`; `omega_codex/lean/PrimitiveDifference.lean:19-21`) | `Not forced` — with zero prior assumptions ($\varnothing$), no syntax, type, or inference rule exists to state `R(a,b)` or `a != b`. (Once `A01` is supplied in Lean 4, inductive `Eq` in `A03` is present in core `A01`; `5_unrecognised_forcing.md:24`.) | `A/lean4/Derivation/PrimDiff.lean:9-11,42-44`; `omega_codex/lean/PrimitiveDifference.lean:19-21` |
| `Step 2` (`S2` = `A24`) | Carrier type $X$, binary relation $R : X \to X \to \text{Prop}$, designated elements $a, b : X$ (with $a := \text{<>}$ if `Step 0` is kept), and relational witness $w : R(a, b)$. | `Supplied` (by authors in `A/lean4/Derivation/PrimDiff.lean:42-43`; `B/pregenesis/paper.md:302`; `B/genesis/paper.md:412-415`; `B/wdp/wdp.md:398-399,464-470`) | `Not forced` from `S1` (or `S0`+`S1`) — **Countermodel:** on $X = \text{Bool} = \{0, 1\}$, the empty relation $R(x, y) := \text{False}$ satisfies `S1` (`PrimDiff.meta_diff_without_assertion`, `PrimDiff.lean:63-66`) while no pair satisfies $R(a, b)$. | `A/lean4/Derivation/PrimDiff.lean:42-43,63-66`; `B/wdp/wdp.md:464-473`; `python 2_mark_checks.py` (`Relation T=set()`) |
| `Step 3` (`S3` = `A25`) | Irreflexivity law $\operatorname{Irrefl}(R) : \forall x : X,\, R(x, x) \to \text{False}$. | `Supplied` (by authors in `A/lean4/Derivation/PrimDiff.lean:28,42`; `B/pregenesis/paper.md:302-303`; `B/genesis/paper.md:415`; `B/wdp/wdp.md:398,468-474`) | `Not forced` from `S1`+`S2` — **Countermodel:** on singleton carrier $X = \text{Unit} = \{m_0\}$, $R(x, y) := \text{True}$ with $a = m_0, b = m_0$ satisfies $R(a, b)$ while $a = b$ (`PrimDiff.selfdiff_consistent`, `PrimDiff.lean:48-50`; `12/16` relations on $\{0, 1\}$ in `5_forcing_checks.py` `[1]`). | `A/lean4/Derivation/PrimDiff.lean:28,42,48-50`; `B/wdp/wdp.md:468-472`; `python 5_forcing_checks.py` |
| `Step 4` (`D1` — Target 1) | **Target 1 (`Genesis` §9 Prop. 3, `WDP-CH01-P02`, `PrimDiff.irrefl_witness_ne`):** From `S1`+`S2`+`S3`, derive endpoint non-identity $a \ne b$ ($a = b \to \text{False}$) and carrier lower bound $\neg \operatorname{Subsingleton}(X)$ ($|X| \ge 2$). | `Derived` (proof in §3 below; also `Witnessed` in Lean and Python) | `Forced` by `S1`+`S2`+`S3` — holds in every model of `S1`–`S3` (proof in §3; checked across all $6$ carriers and all $65,536$ relations up to $|X|=4$ in `2_mark_checks.py` §4). | `A/lean4/Derivation/PrimDiff.lean:42-45,84-86`; `omega_codex/lean/PrimitiveDifference.lean:19-26`; `B/genesis/paper.md:412-420`; `B/wdp/wdp.md:464-474`; `python 2_mark_checks.py` |
| `Step 5` (`S4` = finiteness half of `A28`) | Finite carrier and incidence restriction: restrict $X$ to a finite exhibited token set (minimal choice: $X = \{a, b\}$ of size $2$, matching the lower bound from `Step 4`) and $E \subseteq X \times X$ to a finite nonempty set of witnessed incidences containing $e_0 = (a, b) \in R$. | `Supplied` (by authors in `WDP-CH01-D01`, `B/wdp/wdp.md:388-390`) | `Not forced` by `S1`–`S3` + `D1` — `Step 4` forces the lower bound $|X| \ge 2$ and $|R| \ge 1$, but **Countermodel to upper finiteness:** $X = \mathbb{N}$ with $R = \{(0, 1)\}$ (or $R(x, y) := x < y$) and $a = 0, b = 1$ satisfies `S1`–`S3` and $a \ne b$ on an infinite carrier. | `B/wdp/wdp.md:388-390` (`WDP-CH01-D01`); `A/lean4/Derivation/PrimDiff.lean:84-86`; `1_admission_ledger.md:45` (`A28`) |
| `Step 6` (`S5` = typing & comparison half of `A28`) | Role typing map $\tau$ assigning incidence roles to $E$ (e.g. binary endpoint role on $e_0 = (a, b)$) and declared family of admissible comparisons $K$ on $X$ (e.g. $K = \{k_R\}$ with $k_R(x) := R(x, b)$). | `Supplied` (by authors in `WDP-CH01-D01`, `B/wdp/wdp.md:390-393`) | `Not forced` by `S1`–`S4` — **Countermodels:** (i) $(X, R, a, b)$ carries no role map $\tau$, and on $X = \{a, b\}$ both directed typing `D2` and symmetric typing `S2` satisfy `S1`–`S4` (`PrimDiff.lean:89-95`, `5_forcing_checks.py` `[1]`); (ii) taking $K = \varnothing$ satisfies `S1`–`S4` while making $\text{Same}_K$ constant (`B/genesis/paper.md:114-115`). | `B/wdp/wdp.md:388-403` (`WDP-CH01-D01`), `416-428` (`WDP-CH01-P01`); `1_admission_ledger.md:45` (`A28`) |
| `Step 7` (`D2` — Target 2) | **Target 2 (`WDP-CH01-D01` Admitted Cut):** Assemble $C = (X, E, \tau, K)$ with finite token carrier $X$ ($|X| \ge 2$, containing $a \ne b$), finite incidence set $E$ containing $e_0 = (a, b)$, role assignment $\tau$, and comparison family $K$ separating $a$ and $b$. | `Derived` (by tuple construction from `S1`–`S5` and `D1`) | `Forced` by `S1`–`S5` — every component of $C = (X, E, \tau, K)$ is defined and inhabited from `S1`–`S5` and `D1`. | `B/wdp/wdp.md:388-403` (`WDP-CH01-D01`), `416-428` (`WDP-CH01-P01`); `5_unrecognised_forcing.md:49` (`A28`) |

---

## 3. Full Proofs for Derived Steps and Countermodels for Kept `Supplied` Items

### 3.1 Full Proof of `Step 4` (`D1`: `Irrefl(R)` and `R(a,b)` Give `a != b` and `|X| >= 2`)

- **Premises used (`Supplied`):** `S1` (host implication `->`, `False`, and equality `=` with `Eq.subst`), `S2` ($X : \text{Type}$, $R : X \to X \to \text{Prop}$, $a, b : X$, $w : R(a, b)$), and `S3` ($\operatorname{Irrefl}(R) : \forall x : X,\, R(x, x) \to \text{False}$).
- **Derivation of $a \ne b$ (`Derived`):**
  1. By definition in `S1`, $a \ne b$ is the function type $(a = b) \to \text{False}$.
  2. Assume $h_{\text{eq}} : a = b$.
  3. Apply equality substitution `Eq.subst` (`S1`) to $h_{\text{eq}} : a = b$ and the predicate $P(x) := R(x, b)$ (or in reverse to $P(x) := R(a, x)$) on the witness $w : R(a, b)$ (`S2`) to obtain $w' : R(b, b)$ (or $R(a, a)$).
  4. Instantiate $\operatorname{Irrefl}(R)$ (`S3`) at $b$ (or $a$) to obtain $\operatorname{Irrefl}(R)\, b : R(b, b) \to \text{False}$, and apply it to $w' : R(b, b)$ to obtain $\text{False}$.
  5. Discharge the assumption $h_{\text{eq}} : a = b$ by `->`-introduction (`S1`) to conclude $(a = b) \to \text{False}$, i.e., $a \ne b$.
  - Exact Lean 4 term (`A/lean4/Derivation/PrimDiff.lean:42-44`, `omega_codex/lean/PrimitiveDifference.lean:19-21`):
    `fun h_eq => h_irrefl a (h_eq ▸ h_rel)`.
- **Derivation of $\neg \operatorname{Subsingleton}(X)$ (`Derived`):**
  1. Suppose $h_{\text{sub}} : \forall x\, y : X,\, x = y$.
  2. Instantiate $h_{\text{sub}}$ at $a, b$ (`S2`) to obtain $h_{\text{eq}} : a = b$.
  3. Apply $a \ne b$ (derived above) to $h_{\text{eq}}$ to obtain $\text{False}$ (`PrimDiff.no_witness_on_subsingleton`, `A/lean4/Derivation/PrimDiff.lean:84-86`).

### 3.2 Full Proof of `Step 7` (`D2`: Assembly of Admitted Cut `C = (X, E, tau, K)`)

- **Premises used (`Supplied` and `Derived`):** `S1`–`S5` and `D1` ($a \ne b$).
- **Derivation (`Derived`):**
  1. From `S4` and `D1`, $X$ is a finite token set containing $a, b$ with $a \ne b$ (so $|X| \ge 2$), and $E \subseteq X \times X$ is a finite incidence set containing $e_0 = (a, b)$ with $R(a, b)$.
  2. From `S5`, $\tau$ assigns well-typed roles to every incidence in $E$, and $K$ is a declared family of comparisons on $X$.
  3. When $K$ contains the unary relational comparison $k_R(x) := R(x, b)$ (`S5`), $k_R(a) = R(a, b)$ holds by `S2` ($w : R(a, b)$) while $k_R(b) = R(b, b)$ is false by `S3` ($\operatorname{Irrefl}(R)\, b$), so $k_R(a) \ne k_R(b)$ and $\text{Same}_K(a, b) = 0$ (`WDP-CH01-P01`, `B/wdp/wdp.md:416-428`).
  4. Therefore $C = (X, E, \tau, K)$ satisfies every clause of `WDP-CH01-D01` (`B/wdp/wdp.md:388-393`).

### 3.3 Why the Chain Fails Without Each Kept `Supplied` Item (Explicit Countermodels)

| Kept `Supplied` Item | What Fails When Dropped | Explicit Countermodel (`Witnessed` / `Derived`) |
|---|---|---|
| `S1` (`A01` + `A03`: host logic and equality `=`) | Target 1 (`a != b`) cannot be stated or derived. | Without equality `=` and substitution `Eq.subst`, $R(a, b)$ and $\forall x, \neg R(x, x)$ are syntactic formulas in an equality-free predicate calculus; interpret $a$ and $b$ as two constant symbols mapped to distinct elements in one model and to the same element in no equality predicate — $a \ne b$ (`a = b -> False`) is not even a well-formed formula (`1_admission_ledger.md:18,20`). |
| `S2` (`A24`: carrier $X$, binary relation $R$, witnessed pair $w : R(a, b)$) | No relational witness exists from which to extract $a \ne b$ or populate $E$. | **Countermodel (`PrimDiff.meta_diff_without_assertion`, `A/lean4/Derivation/PrimDiff.lean:63-66`):** Set $X = \text{Bool} = \{0, 1\}$ and $R(x, y) := \text{False}$. Then `S1` and `S3` ($\forall x, \neg R(x, x)$) hold vacuously, yet $\neg \exists a\, b, R(a, b)$, so $R$ exhibits no pair and $E = \varnothing$ (`B/wdp/wdp.md:472-473`). |
| `S3` (`A25`: irreflexivity $\forall x, \neg R(x, x)$) | $R(a, b)$ no longer entails $a \ne b$ or $|X| \ge 2$. | **Countermodel (`PrimDiff.selfdiff_consistent`, `A/lean4/Derivation/PrimDiff.lean:48-50`):** Set $X = \text{Unit} = \{m_0\}$, $R(x, y) := \text{True}$, $a = m_0, b = m_0$. Then `S1` and `S2` ($R(m_0, m_0)$) hold, yet $a = b$ (`a != b` is false) and $|X| = 1$ (`2_mark_checks.py` §4 `bare_witness_models=1`; `5_forcing_checks.py` `[1]` `12/16` relations on $\{0, 1\}$). |
| `S4` (finiteness of $X$ and $E$ in `A28`) | Target 2 (`WDP-CH01-D01`, which requires $X$ and $E$ to be finite sets) fails. | **Countermodel:** Set $X = \mathbb{N}$, $R = \{(n, n+1) : n \in \mathbb{N}\}$, $a = 0, b = 1$. Then `S1`–`S3` and Target 1 ($0 \ne 1$) all hold, but $X$ and $E = R$ are infinite, violating the finiteness requirement of `WDP-CH01-D01` (`B/wdp/wdp.md:389-390`). |
| `S5` (role typing $\tau$ and comparison family $K$ in `A28`) | Target 2 (`C = (X, E, tau, K)`) lacks $\tau$ and $K$, or fails comparison separation. | **Countermodel:** Given $X = \{0, 1\}$ and $R = \{(0, 1)\}$ satisfying `S1`–`S4`, set $K = \varnothing$ (`5_unrecognised_forcing.md:26`, `B/genesis/paper.md:114-115`). Then all comparison profiles under $K$ are identical ($\text{Same}_K(0, 1) = 1$) despite $R(0, 1)$ and $0 \ne 1$. |

---

## 4. Count of `Supplied` Items: Minimal Chain vs Legacy `Regime` Path

### 4.1 Summary Count Table

| Path and Target | Kept `Supplied` Items | Total `Supplied` Count | Notes on Accounting Conventions |
|---|---|---|---|
| **Minimal Chain to Target 1 (`a != b`, Genesis §9 / `WDP-CH01-P02`)** | `S1` (host logic + `=`), `S2` ($X, R, a, b, R(a,b)$), `S3` ($\operatorname{Irrefl}(R)$) | **3** (or **4** if `A01` logic and `A03` equality are counted separately; **+1** if unused `<>` `A02` is listed) | In Lean 4 (`A01`), inductive `Eq` (`A03`) is built into the core language (`5_unrecognised_forcing.md:24`). `<>` (`A02`) does zero work in the proof (`PrimDiff.lean:6-7,42-44`). |
| **Minimal Chain to Target 2 (`C = (X, E, tau, K)`, `WDP-CH01-D01`)** | `S1`, `S2`, `S3` + `S4` (finiteness of $X, E$) + `S5` (role typing $\tau$ and comparison family $K$) | **5** (or **6** if `A01` and `A03` are split; **+1** if unused `<>` `A02` is listed) | Reaches a finite, role-typed WDP Admitted Cut with a witnessed apartness pair $a \ne b$. |
| **Legacy `Regime` Path (full 5-tuple `R = (D, F, I, U, Q)` in `Basic.lean` + `Minimality.lean` + `Rounds.lean`)** | **5 tuple fields** (`D, F, I, U, Q` = `A08`–`A12`) + **12 non-field capabilities** (`3_regime_fields.md:74-89`: `A01`/`A03` index arithmetic, `wf`, `Ctx` + simultaneous `plug` `A16`/`H04`, `derivable` `A17`, `collapsed`/`separable` `A17`, `Item`/`applyDelta` `A18`/`H05`, `validResponse`, deduplication `A14`, reading `L`/`F` `A15`, costs $\mu_1/\mu_2$ `A19`, `Iso` `A20`, `ClosedRun` `A21`) | **17** (or **18** if `<>` `A02` is counted separately) | Constructs `U0 = (2, [1], [(0,[1])], [], [(0,1)])` and then defines $R(x, y) := \operatorname{separable}(U_0, x, y)$, from which `Irrefl(R)` and $0 \ne 1$ follow (`5_unrecognised_forcing.md:45-46`). |
| **Legacy `Regime` Path (pruned 4-tuple `R_4 = (D, F, I, Q)` without `U`)** | Drops `U` (`A11`) and `NewRuleAll` while keeping `(D, F, I, Q)` and the 12 non-field capabilities (`3_regime_fields.md:98-105`) | **16** | Reproduces all six Genesis §§6–8 results `R1`–`R6` (`3_regime_deletions.py` `[7]`). |
| **Legacy `Regime` Path (single-round `U0` witness only, `5_unrecognised_forcing.md` row `A24`)** | Keeps `A01, A03, A08, A09, A10, A15, A16, A17, A18` (`D, F, I`, reading `R2L`, `Ctx`/`plug`, `derivable`/`separable`, `Item`/`applyDelta`) to produce `U0` and $R := \operatorname{separable}(U_0)$ | **9** ledger rows (`11` with `H04, H05`) | Drops `U` (`A11`), persistent `Q` (`A12`), $\mu_1/\mu_2$ (`A19`), `Iso` (`A20`), and `ClosedRun` (`A21`). |

### 4.2 Side-by-Side Comparison: Why the Minimal Chain Needs 3–5 Admissions Instead of 9–17

1. **What the legacy `Regime` path builds before reaching `R(a,b)` and `Irrefl(R)` (`Derived`):**
   - Instead of declaring a binary relation $R$ and irreflexivity $\operatorname{Irrefl}(R)$ directly (`S2, S3`), the legacy `Regime` path declares an indexed carrier `D` (`A08`), an arity-typed form store `F` (`A09`), a positive tuple store `I` (`A10`), a uniform-rule store `U` (`A11`), a requirement store `Q` (`A12`), a context-slot grammar `Ctx` with simultaneous hole-filling `plug` (`A16, H04`), a positive lookup predicate `derivable` (`A17`), and a negated profile-equivalence predicate `separable` (`A17`), plus a 4-constructor sequential delta grammar `Item` (`A18, H05`), two cost functions $\mu_1, \mu_2$ (`A19`), and an isomorphism relation `Iso` (`A20`) to select the unary mark `U0 = (2, [1], [(0,[1])], [], [(0,1)])`.
   - At the end of that construction, `separable(U0, 0, 1)` is one specific instance of an inhabited irreflexive (and symmetric) binary relation on $\{0, 1\}$ (`5_unrecognised_forcing.md` rows `A24`–`A26`).
2. **What is saved (`Derived`):**
   - Target 1 (`a != b`) uses **3** `Supplied` items (`S1`–`S3`) versus **9** ledger rows (or **17** in the full `Regime` package) — a reduction of **6 to 14 `Supplied` items**.
   - Target 2 (`C = (X, E, tau, K)`) uses **5** `Supplied` items (`S1`–`S5`) versus **16–17** in the full `Regime` path — a reduction of **11 to 12 `Supplied` items**.
