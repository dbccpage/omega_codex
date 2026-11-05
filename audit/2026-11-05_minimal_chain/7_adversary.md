# Task 6 (Part B): Adversarial Audit of Part A (`6_minimal_chain.md`) and Tasks 1–5

## Source Commits

- `A` (`C:\Users\a343o\source\repos\19L57G1`): `45bb09864f9b52ed5ecf66e977ca81f0ed623de7`
- `B` (`C:\Users\a343o\source\repos\theory_of_finite_quantum_mechanics`): `e45ed2e133920aa3790af8c5e072ee9829898490`
- `omega_codex` (`C:\Users\a343o\source\repos\omega_codex` baseline): `e21b785626ff8d0231a53409c76fe4e7a57cd59d`

Path abbreviations:
- `B/pregenesis/paper.md` = `B/atlas/finite_obstruction_calculus/pregenesis_to_minimal_symbol_systems/paper.md`
- `B/genesis/paper.md` = `B/atlas/finite_obstruction_calculus/genesis/paper.md`
- `B/wdp/wdp.md` = `B/atlas/finite_obstruction_calculus/witnessed_difference_programme/witnessed_difference_programme.md`

---

## 1. Script Reruns and Output Parity Audit (`Witnessed`)

All four verification scripts in `C:\Users\a343o\source\repos\omega_codex\audit\2026-11-05_minimal_chain\` were rerun from scratch in a clean subshell. Below are the exact commands, pasted outputs, and mismatch reports (both stdout comparison against Tasks 2–5 and code-vs-source comparison against `A` and `B`).

### 1.1 Rerun of `2_mark_checks.py`

Command:
```text
python C:\Users\a343o\source\repos\omega_codex\audit\2026-11-05_minimal_chain\2_mark_checks.py
```

Pasted output (`Witnessed`):
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

- **Stdout mismatch vs `2_mark_alone.md:101-140`:** None (0 byte differences).
- **Script-to-source audit:** `2_mark_checks.py:30-56` hardcodes a 6-field `HostState` where each of the 7 operations writes to its own dedicated slot (`admitted`, `supplied`, `designated`, `retained`, `obs`, `eq`). That checks that 7 distinct field-update functions are pairwise distinct by construction, not that a preexisting machine forced 7 operations.

---

### 1.2 Rerun of `3_regime_deletions.py`

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

- **Stdout mismatch vs `3_regime_fields.md:129-183`:** None (0 byte differences).
- **Script-to-source mismatches found inside `3_regime_deletions.py` (`Witnessed`):**
  1. **Block `[4]` (`3_regime_deletions.py:149-180, 407-414`) fabricates a `Basic.lean:202` disjunction and an `Item.impose` constructor:** In `A/lean4/Derivation/Basic.lean:171-200`, `Item` has 4 constructors (`newDatum`, `newForm`, `newInst`, `newRuleAll` — no `impose`), `validResponse` is the conjunction `∃ s, applyDelta r δ = some s ∧ separable s i j ∧ ∀ q ∈ r.reqs, separable s q.1 q.2` (lines 198–200), and `R2L` at line 208 already has `reqs = [(0, 1)]`.
  2. **Block `[5]` (`3_regime_deletions.py:50-59, 188-193`) computes single-hole context counts $k \cdot 2^{k-1}$ instead of `Minimality.lean`'s `aritySum` or `Basic.lean`'s multi-hole context count $(n+1)^k - n^k$:** In `A/lean4/Derivation/Minimality.lean:15-18` and `B/genesis/paper.md:288-290`, the second component of $\mu_2(\Delta)$ is $\operatorname{aritySum}(\Delta) = \sum_{\operatorname{NewForm}(a) \in \Delta} a$, so $\mu_2(\operatorname{deltaK}(k)) = (2, k)$ (`(2, 1), (2, 2), (2, 3), (2, 4), (2, 5)`), not `(2, 1), (2, 4), (2, 12), (2, 32), (2, 80)`. Furthermore, `B/genesis/paper.md:253-255` defines $|\operatorname{Ctx}(R)| = \sum_f ((n+1)^{a_f} - n^{a_f})$ (counting contexts with $\ge 1$ hole per `Basic.lean:77`), which on $n=2$ equals $3^k - 2^k = 1, 5, 19, 65, 211$, whereas `contexts_of` in `3_regime_deletions.py:50-59` only enumerates single-hole contexts ($k \cdot 2^{k-1} = 1, 4, 12, 32, 80$).

---

### 1.3 Rerun of `4_frozen_checks.py`

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

- **Stdout mismatch vs `4_priced_containers.md:66-127`:** None (0 byte differences).
- **Script-to-source mismatches found inside `4_frozen_checks.py` (`Witnessed`):**
  1. **Swapped `U0` and `U1` (`4_frozen_checks.py:214, 261-262`):** In `A/lean4/Derivation/Minimality.lean:38-40`, `U0` has `insts = [(0, [0])]` and `U1` has `insts = [(0, [1])]`. `4_frozen_checks.py` defines `U0` with `(0, (1,))` and `U1` with `(0, (0,))`.
  2. **Invented `Pi_3 = (1, 1, 1, 0)` tuple (`4_frozen_checks.py:260-265`):** `WDP-CH03-P03` (`B/wdp/wdp.md:694-743`) uses `mu1 = |Delta|` and `mu2 = (|Delta|, aritySum)` and does not define a 4-tuple `Pi_3 = (c_wit, c_ret, c_op, c_id)`.

---

### 1.4 Rerun of `5_forcing_checks.py`

Command:
```text
python C:\Users\a343o\source\repos\omega_codex\audit\2026-11-05_minimal_chain\5_forcing_checks.py
```

Pasted output (`Witnessed`):
```text
=== PROMPT 5: FORCED BUT NEVER RECOGNISED -- FINITE DERIVABILITY & COUNTERMODEL CHECKS ===

[1] BINARY RELATIONS ON A = {0, 1} (A24, A25, A26 vs A05/A17)
  total_relations = 16
  countermodels to (A24 -> A25 irreflexivity): 12 (e.g. R={(0,0)})
  countermodels to (A24 + A25 -> A26 symmetry): 2 (D2: R={(0,1)}, R={(1,0)})
  countermodels to (A24 + A26 -> A25 irreflexivity): 6 (e.g. R={(0,0)})
  profile-inequality relations violating irreflexivity: 0 (Outcome a: derived from A03+A05)
  profile-inequality relations violating symmetry: 0 (Outcome a: derived from A03+A05)

[2] HOLE-FILLING (A16/H04), UNORDERED REQS (A12), AND DEDUPLICATION (A14) CENSUS
  total_wf_regimes_checked = 8424
  multihole_vs_singlehole_separability_mismatches = 0 (Outcome a: multi-hole simultaneous plug H04 is redundant relative to single-hole contexts)
  asymmetric_separability_mismatches = 0, reflexive_separability_mismatches = 0 (Outcome a: unordered canonical requirement semantics A12 is forced by symmetry/irreflexivity of separable)
  duplicate_instance_profile_mismatches = 0 (Outcome a for profiles: deduplication A14 is forced by membership semantics of derivable)

[3] MU2 COST ORDER CHECK ON R2L (n=2) (A19)
  lex_min (mu1, aritySum) = (2, 1)
  rev_lex_min (aritySum, mu1) = (2, 1)
  additive_min (mu1 + aritySum) = (2, 1)
  ctx_lex_min (mu1, |Ctx|) = (2, 1), ctx_rev_min (|Ctx|, mu1) = (2, 1)
  unique_pareto_minimum = [(2, 1)] (Outcome a: once both components are present, (2,1) is the componentwise utopia point; lex order is redundant)
[3] MU2 COST ORDER CHECK ON R2F (n=3) (A19)
  lex_min (mu1, aritySum) = (2, 1)
  rev_lex_min (aritySum, mu1) = (2, 1)
  additive_min (mu1 + aritySum) = (2, 1)
  ctx_lex_min (mu1, |Ctx|) = (2, 1), ctx_rev_min (|Ctx|, mu1) = (2, 1)
  unique_pareto_minimum = [(2, 1)] (Outcome a: once both components are present, (2,1) is the componentwise utopia point; lex order is redundant)

[4] OBSERVER MEMORY LAYER & RETENTION PACKET INDEPENDENCE (A33 / A34, |M|=|I|=|O|=2)
  |U_space| = 16, |R_space| = 4, |Approx_space| = 16
  total_packets (|U|*|R|*|Approx|) = 1024
  packets_retaining_distinction_across_1_idle_step = 16 / 1024
  non_retaining_countermodels (CM1-CM5 family) = 1008 / 1024 (Outcome b: memory retention is not forced by static exhibition)
```

- **Stdout mismatch vs `5_unrecognised_forcing.md:88-123`:** None (0 byte differences).
- **Script-to-source mismatches found inside `5_forcing_checks.py` (`Witnessed`):**
  1. **`check_mu2_cost_order` (`5_forcing_checks.py:191-204`) checks a hardcoded list of arithmetic triples rather than enumerating deltas:** It constructs `candidates = [(2, a, a * (n ** (a - 1))) for a in range(1, max_arity + 1)] + [(3, 1, n), (3, 2, 2 * n)]`, using the single-hole context formula $a \cdot n^{a-1}$ instead of $(n+1)^a - n^a$.
  2. **Mislabelled `CM1`–`CM5` in comment (`5_forcing_checks.py:234-235` and `5_unrecognised_forcing.md:54`):** In `B/wdp/wdp.md:815-845`, `CM1` has $|M| \ge 2$ with static update $u(m,i) = m$ (not $|M|=1$), `CM2` has toggle $u$ and constant $r$ (not reset $u$), `CM3` has $|M|=3$ cyclic $u$ and parity $r$ (not constant $r$), and `CM5` has irreversible reset $u(m, \text{reset}) = m_0$ (not bit-flip $u$).

---

## 2. Adversarial Attack on Every `Derived` and `Witnessed` Claim in Part A and Tasks 1–5

We tested every `Derived` and `Witnessed` claim in `6_minimal_chain.md` and `1_admission_ledger.md` through `5_unrecognised_forcing.md` by (i) checking every cited `file:line` in `A`, `B`, and `omega_codex`, and (ii) attempting to construct a countermodel.

### 2.1 Confirmed Refutations, Source Misreadings, and Scope Countermodels (`Witnessed` and `Derived`)

| # | Target File & Claim (`Tag`) | What the Adversary Checked / Tried | Finding (`REFUTED` or `SCOPE-RESTRICTED`) |
|---|---|---|---|
| **F1** | `3_regime_fields.md:65-66` & `3_regime_deletions.py:149-180,407-414` (`Witnessed`): Claims `A/lean4/Derivation/Basic.lean:198-203` defines `validResponse` with disjunction `((i, j) ∈ r'.reqs \|\| (j, i) ∈ r'.reqs \|\| separable r' i j)`, `R2L.reqs = []` at `Basic.lean:206`, and `delta = [Item.impose 0 1]` is valid at cost 1. | Read `A/lean4/Derivation/Basic.lean:170-210` line-by-line. | **REFUTED (Source & Code Fabrication):** In `Basic.lean:171-176`, `Item` has only 4 constructors (`newDatum`, `newForm`, `newInst`, `newRuleAll`) and no `impose` constructor. In `Basic.lean:198-200`, `validResponse` is a conjunction (`separable s i j ∧ ∀ q ∈ r.reqs, separable s q.1 q.2`), not a disjunction. In `Basic.lean:208`, `R2L` has `reqs = [(0, 1)]`, not `[]`. |
| **F2** | `3_regime_fields.md:18-19`, `3_regime_deletions.py:50-59,188-193,347-360`, `5_unrecognised_forcing.md:66` (`Derived` / `Witnessed`): Claims $\mu_2(\Delta) = (\|\Delta\|, \|\operatorname{Ctx}(R')\|)$, claims `B/genesis/paper.md:253-255` states $\|\operatorname{Ctx}(R)\| = \sum a_f \|D\|^{a_f-1}$, and reports $\mu_2(\operatorname{markK}(k)) = (2, k \cdot 2^{k-1})$. | Read `A/lean4/Derivation/Minimality.lean:15-18`, `Basic.lean:74-81`, and `B/genesis/paper.md:253-255,288-290`. | **REFUTED (Misread Formula & Definition):** In `Minimality.lean:15-18` and `B/genesis/paper.md:288-290`, the second coordinate of $\mu_2$ is `aritySum(d)` (giving $\mu_2(\operatorname{deltaK}(k)) = (2, k)$, not $(2, k \cdot 2^{k-1})$). In `B/genesis/paper.md:253-255`, the context formula is $\sum_{f} ((n+1)^{a_f} - n^{a_f})$ (counting all contexts with $\ge 1$ hole per `Basic.lean:77`, giving $3^k - 2^k = 5$ at $n=2, k=2$, not $4$). |
| **F3** | `1_admission_ledger.md:95` (`H04`, `Witnessed`) vs `5_unrecognised_forcing.md:37,65-66` (`A16`, `Derived` / `Witnessed`): Task 1 (`H04`) claims that without simultaneous multi-hole `plug`, `markK` ($k \ge 2$) would require additional data or instances; Task 5 (`A16`) claims multi-hole `plug` adds zero separating power over single-hole contexts. | Tested `markK(k)` ($n=2$, form $0$ of arity $k$, single diagonal instance `(1, ..., 1)`) using only single-hole contexts (`count_none == 1`). | **REFUTED in Task 1 (`H04`); SURVIVED in Task 5 (`A16`):** On `markK(k)` for any $k \ge 2$, the single-hole context $c_1 = \langle 0, [\text{none}, \text{some } 1, \dots, \text{some } 1]\rangle$ plugs datum $0$ to $(0, 1, \dots, 1) \notin I$ (`false`) and datum $1$ to $(1, 1, \dots, 1) \in I$ (`true`). Thus `markK(k)` still separates $(0, 1)$ at cost $\mu_1 = 2$ with 1 instance using only 1-hole contexts, refuting `1_admission_ledger.md:95`. |
| **F4** | `4_priced_containers.md:27,42` (`Derived`): Cites `A/lean4/Derivation/Inertia.lean:51-66` for theorems `no_valid_response_R1` and `R1_inert`. | Read `A/lean4/Derivation/Inertia.lean:1-90` and grepped `A/lean4/` for `no_valid_response_R1` and `R1_inert`. | **REFUTED (Non-Existent Theorem Names):** Neither `no_valid_response_R1` nor `R1_inert` exists in `A/lean4/`. Lines 50–66 of `Inertia.lean` are `R2L_collapsed`, `R2F_collapsed`, `historyL_replays`, and `historyF_replays`. (The mathematical statement that $i < j < 1$ is unsatisfiable holds in `Nat`, so the state verdict holds while the theorem citation is false.) |
| **F5** | `3_regime_fields.md:15-22,36,75-87` (`Derived` / `Witnessed`): Cites `Basic.lean:155-162` for `collapsed_of_no_insts`, `Progress.lean:141-155` for `step_strict_mono` on `elems(r)`, and wrong line ranges across `Basic.lean`, `Minimality.lean`, `Rounds.lean`, plus scrambled ledger IDs `A09`–`A23` in lines 75–87. | Read `Basic.lean`, `Inertia.lean`, `Minimality.lean`, `Progress.lean`, `Rounds.lean`, and `B/atlas/finite_obstruction_calculus/genesis/lean4/SecondRun/Run.lean`. | **REFUTED (Wrong Files, Line Ranges, and Ledger IDs):** (i) `collapsed_of_no_insts` is at `Inertia.lean:40-46` (not `Basic.lean:155-162`, which is inside `stepE`); (ii) `step_strict_mono` does not exist in `Progress.lean` (`elems` monotonicity `stepE_elems_lt_of_ne` is in `B/atlas/finite_obstruction_calculus/genesis/lean4/SecondRun/Run.lean:61-101`); (iii) `Regime` is at `Basic.lean:53-59` (not `33-39`), `cost1_insufficient_general` is `Minimality.lean:102-142` (not `281-285`), `deltaU0_valid` is `79-80` (not `105-115`), `mu2_unique` is `480-485` (not `451-487`), `markK_pairwise_noniso` is `355-364` (not `380-416`), `closedRun_round_bound` is `Rounds.lean:452-468` (not `251-265`); (iv) lines 75–87 cite `A09`–`A23` with off-by-2 IDs relative to `1_admission_ledger.md`. |
| **F6** | `4_priced_containers.md:16,31,34,51` & `4_frozen_checks.py:214,260-265` (`Derived` / `Witnessed`): Cites `WDP-CH03-P03` (`wdp.md:655-680`) for price vector $\Pi_3 = (c_{\text{wit}}, c_{\text{ret}}, c_{\text{op}}, c_{\text{id}}) = (1,1,1,0)$, swaps `U0`/`U1`, quotes `B/genesis/paper.md:476-481`, and cites wrong `wdp.md` line numbers. | Read `B/wdp/wdp.md:380-760` and `B/genesis/paper.md:370-490`. | **REFUTED (Invented Symbol & Wrong Line Numbers):** (i) `WDP-CH03-P03` (`B/wdp/wdp.md:712-743`, not `655-680`) has no 4-vector $\Pi_3$; (ii) `WDP-CH01-D02` is at `496-511` (not `280-291`), `CH01-D03` at `513-530` (not `293-303`), `CH03-D01` at `684-692` (not `615-645`); (iii) the closure-endpoint quote is at `B/genesis/paper.md:379-380` (`"Its fixed-carrier endpoint does not by itself supply a fresh datum or a new goal"`), not `476-481`; (iv) `U0` and `U1` are swapped relative to `Minimality.lean:38-40`. |
| **F7** | `5_unrecognised_forcing.md:40,67-68` (`A19`, `Derived` / `Witnessed`): Claims `(2, 1)` is the componentwise Pareto minimum so the lexicographic order of $\mu_2$ is redundant. | Tested separating deltas from a regime where a binary form is **already** admitted (`r = (3, [2], [(0, [0, 2])], [], [])`, target `(0, 1)`) and under total-state form-arity cost vs delta-only `aritySum`. | **SCOPE-RESTRICTED (Holds on `R2L`/`R2F` where `forms = []`; Fails on General Regimes):** On `R2L` and `R2F` (`forms = [], insts = []`), every separating delta must add $\ge 1$ form ($a \ge 1$) and $\ge 1$ instance, so $|\Delta| \ge 2$ and $\operatorname{aritySum}(\Delta) \ge 1$, making `(2, 1)` the Pareto minimum. **Countermodel on general regimes (`forms != []`):** From `r = (3, [2], [(0,[0,2])], [], [])` where `(0,1)` is collapsed (`0` and `1` both fail `(0,[x,2])` and `(0,[2,x])`), the 1-item delta $\Delta_1 = [\operatorname{newInst}(0, [0, 1])]$ separates `(0, 1)` with $(|\Delta_1|, |\operatorname{Ctx}(r')|) = (1, 19)$ (or total form arity $(1, 2)$), whereas the 2-item unary delta $\Delta_2 = [\operatorname{newForm}(1), \operatorname{newInst}(1, [1])]$ has $(|\Delta_2|, \text{new-form }\operatorname{aritySum}) = (2, 1)$ (or under new-context cost $(2, 6)$ vs $(1, 19)$). There the two coordinates trade off ($(1, 19)$ vs $(2, 6)$), so lexicographic order is NOT redundant outside `forms = []`. |
| **F8** | `5_unrecognised_forcing.md:54` (`A33`, `Witnessed`): Lists `CM1`–`CM5` as `CM1 |M|=1, CM2 reset u, CM3 constant r, CM4 all-true approx, CM5 bit-flip u`. | Read `B/wdp/wdp.md:815-845` (`CM1`–`CM5`). | **REFUTED (Scrambled Source Labels):** In `B/wdp/wdp.md:815-845`, `CM1` is static memory ($|M| \ge 2, u(m,i)=m$), `CM2` is readout blindness (toggle $u$, constant $r$), `CM3` is coarse-graining ($|M|=3$ cyclic $u$, parity $r$), `CM4` is trivial tolerance $\approx$, and `CM5` is irreversible reset $u(m, \text{reset}) = m_0$. (The bounded census `1008 / 1024` in `5_forcing_checks.py` `[4]` remains exact.) |

### 2.2 Claims That Survived Adversarial Attack (Including What Was Tried)

| Target File & Claim (`Tag`) | What the Adversary Tried to Break It | Why the Attempted Countermodel Failed (`SURVIVED`) |
|---|---|---|
| `6_minimal_chain.md` Step 4 (`D1`, `Derived` / `Witnessed`): `Irrefl(R)` and `R(a,b)` give `a != b` and `|X| >= 2` from `S1`–`S3`. | Tried: (1) Paraconsistent / non-substitutive equality where $a = b$ does not substitute into $R(a,b)$; (2) Empty carrier $X = \varnothing$; (3) 1-element carrier $X = \{m_0\}$; (4) Partial relation $R$. | (1) Blocked by `S1` (`Eq.subst`); (2) Blocked by `S2` ($a, b : X$ inhabit $X$); (3) Blocked by `S2`+`S3` ($R(m_0, m_0)$ contradicts $\operatorname{Irrefl}(R)\, m_0$); (4) Blocked by `S2` ($R : X \to X \to \text{Prop}$ is total into `Prop` with witness $w : R(a,b)$). |
| `6_minimal_chain.md` Step 7 (`D2`, `Derived`): `S1`–`S5` assemble a finite WDP Admitted Cut `C = (X, E, tau, K)` with $a \ne b$ and $\text{Same}_K(a,b) = 0$ when $k_R \in K$. | Tried to make $k_R(a) = k_R(b)$ while keeping $w : R(a,b)$ and $\operatorname{Irrefl}(R)\, b$. | Since $k_R(x) := R(x, b)$, $k_R(a) = R(a, b)$ is inhabited by $w$ (`S2`) and $k_R(b) = R(b, b)$ is refuted by $\operatorname{Irrefl}(R)\, b$ (`S3`). If $k_R(a) = k_R(b)$, `Eq.mp` yields $R(b, b)$, hence `False`. |
| `1_admission_ledger.md:92-94` (`H01`–`H03`, `Witnessed`): Hidden axioms `Classical.choice`, `propext`, `funext`, `Quot.sound` in Lean proofs. | Checked `B/atlas/finite_obstruction_calculus/genesis/lean4/Paper.lean:24-34`, `A/lean4/Derivation/PrimDiff.lean:270-279`, and `omega_codex/lean/ZeroEquivalence.lean:58`. | Every cited line matches: `Paper.lean:24` uses `Classical.choose v.property`; `PrimDiff.lean:270-271` uses `funext` and `propext`; `ZeroEquivalence.lean:58` uses `Quot.sound`. |
| `1_admission_ledger.md:96-99` (`H05`–`H08`, `Witnessed`): Sequential `foldlM` (`H05`), `getD ... 0` (`H06`), Python `f"w{n}"` collision (`H07`), and real interval bisection in `WDP-CH04-P02` (`H08`). | Tested Python `delta_events` (`A/code/derivation/candidates.py:120-125`) on a 1-token regime whose sole token is already `"w1"`; checked `Basic.lean:67,192` and `B/wdp/wdp.md:1081-1095`. | On `base` with `data = ("w1",)`, `n = base.n_data() = 1`, so `NewDatum` emits `AdmitDatum("w1")`, which `model.py:112-113` ignores as a duplicate token (`len(data)` stays `1` instead of becoming `2`). All four citations and mechanisms hold. |
| `2_mark_alone.md:14-19` (`Derived` / `Witnessed`): On `<>` alone, `T = empty` has 0 successors, `T = {(m0,m0)}` has 1, and `R_L0` / `R_F0` satisfy `underivable_of_empty` and `collapsed_of_no_insts`. | Tried to construct a regime with `insts = []` and `rules = [0]` where `plug c 0` and `plug c 1` have different derivability. | When `insts = []`, `derivable r (plug c d)` reduces to `(plug c d).1 ∈ r.rules`, which is `c.form ∈ r.rules` because `(plug c d).1 = c.form` (`Basic.lean:81`). Since `c.form ∈ r.rules` does not depend on `d`, `derivable r (plug c 0) ↔ derivable r (plug c 1)` always holds (`Inertia.lean:40-46`). |
| `2_mark_alone.md:49-65` (`G1`–`G10`, `Witnessed`): Single-step additions from `R_L0`, `R_F0`, and `RState`. | Checked `Basic.lean:145-162` and `Refusal.lean:59-78` against `2_mark_checks.py` §3. | `admitInst` and `admitRuleAll` require `f < r.forms.length` (`0 < 0` false), and `impose` requires `i < j ∧ j < r.data` (`1 < 0` and `1 < 1` false). All 10 rows hold. |
| `2_mark_alone.md:79-89` (`Derived` / `Witnessed`): Carrier swap changes `inhabited_irrefl_models` ($0$ on $|C|=1$ vs $2^{n(n-1)}-1$ on $|C|=n \ge 2$) and breaks `q.1 < q.2` on unordered `Opaque2`. | Tried to define canonical unordered pair storage on `Opaque2 = {a, b}` without choosing an orientation $(a, b)$ vs $(b, a)$. | By `Bridge.no_swap_fixed_offdiag_pair` (`A/lean4/Derivation/Bridge.lean:281-285`), the swap bijection on `{a, b}` maps $(a, b) \mapsto (b, a)$ with no fixed off-diagonal pair, so selecting a canonical representative requires breaking swap symmetry. |
| `3_regime_fields.md:34-50,98-108` (`Derived` / `Witnessed`): Deleting `U` (`R_4 = (D,F,I,Q)`) preserves `R1`–`R6`; materializing `U` into `I` fails under `admitDatum` ($n=2 \to 3$); deriving `Q` as `separable` shrinks max rounds on $n=3$ from $3$ to $2$. | Tried to find a 1-step separation on $n=3$ that separates `(0, 1)` without separating `(0, 2)` or `(1, 2)`. | Any boolean predicate $P : \{0, 1, 2\} \to \{0, 1\}$ with $P(0) \ne P(1)$ must assign $P(2) \in \{0, 1\}$; by pigeonhole, $P(2)$ differs from either $P(0)$ or $P(1)$, so at least 2 of the 3 pairs are separated in round 1, reducing the maximum number of rounds under $Q_{\text{der}} = \text{separable}$ from $3$ to $2$. |
| `4_priced_containers.md:47-49` (`U1, U2`, `Witnessed`) & `[4]` (`Horizon.lean` budget gate): Unpriced containers can have a forced successor (`not F1-frozen`), while a budget gate at `budget = 0` makes `addView` `F2-frozen`. | Checked `A/lean4/Derivation/Horizon.lean:155-161` (`stepWorld` for `.addView`). | `Horizon.lean:155` guards `.addView` with `if !gateBudget || 0 < w.budget then ... else w`. At `gateBudget = true` and `w.budget = 0`, `.addView` is a no-op, whereas at `gateBudget = false` it appends the view. |
| `5_unrecognised_forcing.md:24-55` (`A03, A05, A07, A12, A14, A24–A29`, `Derived` / `Witnessed`): Profile inequality $\neg(x \sim_O y)$ forces `Irrefl` and `Symm`; `fromSetoid` reconstructs `ZeroRel`. | Tried to construct an observation family $O$ on $A = \{0, 1\}$ whose induced inequality $R(x, y) := \exists f \in O, f(x) \ne f(y)$ is either reflexive at some point or asymmetric. | For any $f : A \to V$, equality `=` on $V$ (`A03`) is reflexive ($f(x) = f(x)$) and symmetric ($f(x) = f(y) \leftrightarrow f(y) = f(x)$), so its negation $\exists f \in O, f(x) \ne f(y)$ is always irreflexive and symmetric. |

---

## 3. Audit of Words Doing Unproved Work (`"forced"`, `"minimal"`, `"frozen"`, `"internal"`)

| Word | Where It Appears (`file:line`) | What Claim It Makes | What Unproved / Supplied Premise Actually Does the Work (with Countermodel) |
|---|---|---|---|
| `"forced"` | `A/lean4/Derivation/PrimDiff.lean:83` (`"-- §4. Carrier size: the two-element carrier is forced"`) | Claims the 2-element carrier (`|X| = 2`) is forced by an irreflexive witness. | **Actual theorem (`no_witness_on_subsingleton`, line 84):** Only rules out $|X| \le 1$ (`¬ Subsingleton α`), giving a **lower bound** $|X| \ge 2$, not $|X| = 2$, and only after `Irrefl(R)` and `R(a,b)` are supplied. **Countermodel:** $X = \text{Fin } 3 = \{0, 1, 2\}$ with $R = \{(0, 1)\}$ satisfies `Irrefl(R)` and `R(0,1)` with $|X| = 3 \ne 2$ (`2_mark_checks.py` §4). |
| `"forced"` | `B/pregenesis/paper.md:302` (`"Admitting a binary relation R ... together with the protection law Irrefl(R) ... forces a != b"`) | Calls $a \ne b$ "forced" in §9. | **Hidden premise:** Only conditional on three `Supplied` admissions (`S1` host equality substitution, `S2` $R(a,b)$, `S3` $\operatorname{Irrefl}(R)$). Without `S3`, `selfdiff_consistent` (`PrimDiff.lean:48-50`) satisfies $R(a,b)$ with $a = b$. |
| `"forced"` | `5_unrecognised_forcing.md:1,102,103` & `5_forcing_checks.py:173,175` (`"Forced But Never Recognised"`, `"unordered canonical requirement semantics A12 is forced"`, `"deduplication A14 is forced"`) | Claims `A12` (unordered `reqs`) and `A14` (deduplication) are forced. | **Hidden premise:** Only forced for *observational profiles* under set-membership `derivable` (`A17`) and symmetric `separable` (`A17`). **Countermodel:** For `elems(r)` in `R6` (`Run.lean:42-44`) and `round_reqs_succ` (`Rounds.lean:380`), list length `.length` is sensitive to duplicate insertions unless `insertNew` (`A14`) is explicitly supplied. |
| `"minimal"` | `A/lean4/Derivation/Minimality.lean:5` (`"Challenge 3: minimality"`); `B/genesis/paper.md:280,310`; `B/wdp/wdp.md:693,719,732` (`WDP-CH03-P03`) | Calls cost $\mu_1 = 2$ and $\mu_2 = (2, 1)$ (and `U0`) the "minimal" separating augmentation. | **Hidden premise:** Relative to the split 4-constructor "declare-then-assert" grammar `Item` (`A18`) and sequential `applyDelta` (`H05`). **Countermodel (`3_regime_deletions.py` `[7]`, row `Derive F from I`):** If form arity is inferred from instances (or form+instance are bundled into one item), `[newInst(0, [1])]` separates `(0, 1)` at cost $\mu_1 = 1, \mu_2 = (1, 1)$. |
| `"minimal"` | `A/lean4/Derivation/PrimDiff.lean:16-18` (`"Section 5 constructs the minimal models on Bool: the directed witness D2 ... and the symmetric witness S2"`) | Calls `D2` and `S2` on `Bool` "the minimal models". | **Hidden premise:** Requires `Irrefl(R)` (`A25`) and `R(a,b)` (`A24`) to exclude $|X| = 1$, and even on `Bool` there are **three** inhabited irreflexive relations (`D2`, `D2rev`, `S2`; `PrimDiff.lean:245-256`, `2_mark_checks.py` §4 `inhabited_irrefl_models = 3`). Calling them two models relies on quotienting `D2rev` by `swap` (`PrimDiff.lean:259`). |
| `"minimal"` | `6_minimal_chain.md:1,22` (`"Minimal Derivation Chain"`) | Calls the 3-step chain `S1`–`S3` $\to$ `a != b` "minimal". | **Hidden premise:** Minimal only among chains that derive $a \ne b$ *from a relational witness* $R(a,b)$. If $a \ne b$ itself were admitted directly (e.g. `0 ≠ 1` in `Nat` from `A01`), `R` and `Irrefl(R)` (`S2, S3`) would not be needed to get $0 \ne 1$, though `R(a,b)` is required by the prompt target (`"irreflexive R with R(a,b) gives a != b"`). |
| `"frozen"` | `4_priced_containers.md:26-35,41-43` & `4_frozen_checks.py:69-111` (rows `S1a`, `S2a`, `S4` labelled `F2-frozen`) | Labels `R1 = (1,[],[],[],[])`, `R2L_bare = (2,[],[],[],[])`, and `U0_closed` as `F2-frozen` ("no distinct successor is possible"). | **Hidden premise:** They have `0` successors **only** under `validResponse` (which requires separating an already-imposed target pair `(i, j)` not yet separated). Under the primitive transition relation `stepE` / `applyItem` (`A13`/`A18`), `4_frozen_checks.py` `[1]` itself prints `raw_1step_admissions (arity<=2): 3 distinct states` for `R1`, `4` for `R2L_bare`, and `5` for `U0_closed`. Thus under `stepE` they are **not** `F2-frozen`. |
| `"internal"` | `A/lean4/Derivation/Basic.lean:12` (`"internal identity is the index"`), `Basic.lean:120` (`"Internal separability"`), `B/genesis/paper.md:241-243` | Calls index `< r.data` "internal identity" and `separable r d d'` "internal separability". | **Hidden premise:** `Regime` contains passive lists of natural numbers (`data`, `forms`, `insts`, `rules`, `reqs`) and no internal evaluator. Both index equality `=` and `separable r d d'` (`∃ c, wfCtx r c ∧ ...`) are **external metatheoretic predicates** evaluated in the host metalanguage (`A01, A03`). Furthermore, in `U0`, datum `0` and datum `1` are separated only because the host plugs the metatheoretic indices `0` and `1` into `c` and compares `0 = 1` in `List.elem`. |
| `"internal"` | `A/lean4/Derivation/Inertia.lean:28` (`"From genesis, no successor is generated internally"`); `4_priced_containers.md:24,45` (`"Inside / Outside"`) | Contrasts "internal generation" with "external supply". | **Hidden premise:** Because `Regime` is a passive tuple with no autonomous step loop (`A/research/ignition/README.md:19-41`), **no** transition in the entire repository — even on `R2L` after `Iso` quotienting — is executed "internally" by the tuple; every transition is applied by an external host function (`stepE`, `applyDelta`, `replayE`). |
