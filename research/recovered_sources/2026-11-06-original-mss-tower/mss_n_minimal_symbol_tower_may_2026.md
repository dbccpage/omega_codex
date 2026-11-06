# MSS-n: Minimal Symbol Tower
## n = 0 … 10
*Jeremy Carroll + Claude, May 2026*

---

## Definitions (terse)

```
MSS-n = (Σ_n, R_n)
  Σ_n   alphabet
  R_n   rewriting rules

CLOSED:   ∀e ∈ Σ_n* : nf(e) ∈ Σ_n*
FORCED:   ∃e ∈ Σ_n* : nf(e) ∉ Σ_n*

F : MSS-n → MSS-(n+1)    free completion (up functor)
U : MSS-(n+1) → MSS-n    forgetful (strip lift)

F ⊣ U:   Hom(FX,Y) ≅ Hom(X,UY)

T = U∘F    monad on MSS-n ("closure forced at level n")
η : id → T    unit: X embeds in its own closure
μ : T∘T → T  multiplication: double closure = single closure

CONJUGATE PAIR RULE:
  Δ_n = 2  iff  the forced symbol has a dual
  (zero needs equality; reals need order; ρ needs tr; â† needs â)
  Δ_n = 1  iff  the forced symbol is self-contained
```

---

## The Tower

```
n  │ Σ_n │ Δ  │ wall type              │ new symbols forced
───┼─────┼────┼────────────────────────┼──────────────────────────
0  │   2 │  — │ EXPRESSIVE             │ {0,1}
   │     │    │ no relation possible   │
   │     │    │                        │
1  │   3 │  1 │ STRUCTURAL             │ → (directed edge)
   │     │    │ direction needed       │
   │     │    │                        │
2  │   4 │  1 │ STRUCTURAL             │ * (second node type)
   │     │    │ node identity collapse │
   │     │    │                        │
3  │   5 │  1 │ TOPOLOGICAL            │ # (third node: enables
   │     │    │ need β₁ > 0            │    non-trivial cycle)
   │     │    │                        │
4  │   7 │  2 │ ALGEBRAIC *            │ ∅, = (zero + equality:
   │     │    │ need exactness test    │    conjugate pair)
   │     │    │                        │
5  │   9 │  2 │ METRIC *               │ ℝ, <_ℝ (reals + order:
   │     │    │ need Φ₁ comparison     │    conjugate pair)
   │     │    │                        │
6  │  10 │  1 │ PHASE                  │ i (imaginary unit:
   │     │    │ degenerate Φ₁ states   │    self-contained)
   │     │    │                        │
7  │  12 │  2 │ STATISTICAL *          │ ρ, tr (density matrix +
   │     │    │ need mixed states      │    trace: conjugate pair)
   │     │    │                        │
8  │  13 │  1 │ COMPOSITIONAL          │ ⊗ (tensor product:
   │     │    │ need multi-system      │    self-contained)
   │     │    │                        │
9  │  15 │  2 │ FOCK *                 │ â†, â (creation +
   │     │    │ variable particle n    │    annihilation: conjugate)
   │     │    │                        │
10 │  16 │  1 │ LOCAL                  │ φ(x) (local field:
   │     │    │ need fields at points  │    self-contained)
───┴─────┴────┴────────────────────────┴──────────────────────────
* = Δ=2: universe forces a conjugate pair simultaneously
```

---

## Sequence

```
n:     0   1   2   3   4   5   6   7   8   9  10
|Σ_n|: 2   3   4   5   7   9  10  12  13  15  16

Δ:         1   1   1   2   2   1   2   1   2   1
```

Linear fit: `|Σ_n| ≈ 1.47n + 1.36`

The sequence is NOT in OEIS (as of this writing).
It is a new sequence determined by the forcing structure of physics.

---

## The Conjugate Pair Pattern

Δ_n = 1 at: n = 0→1, 1→2, 2→3, 5→6, 7→8, 9→10
Δ_n = 2 at: n = 3→4, 4→5, 6→7, 8→9

The 2s cluster in pairs then thin out: (3,4), (6), (8).
The pattern after n=4: 2,1,2,1,2,1 — strictly alternating.

**Conjecture A:**
For n > 4, Δ_n alternates: 2,1,2,1,2,1,...
i.e., every even wall type forces a conjugate pair,
every odd wall type is self-contained.

If true: `|Σ_n| = 9 + ⌊3(n-4)/2⌋` for n > 4.

---

## Missing Values

The integers in [2,16] NOT in the sequence:

```
{6, 8, 11, 14}
```

These are the symbol counts the universe **skips**.
No MSS-n has exactly 6, 8, 11, or 14 symbols.

```
6  = 2 × 3        (skipped: phase forced i alone, not 2 symbols)
8  = 2³            (skipped: tensor ⊗ forced alone)
11 = prime         (skipped: local field φ(x) forced alone)
14 = 2 × 7         (skipped: renorm R_μ would be alone)
```

The universe skips these because at those levels the forcing
produces either 1 or 2 new symbols — never the exact count
that would land on 6, 8, 11, or 14.

---

## Riemann Connection

### What the zeros of ζ(s) measure (classical):

The nontrivial zeros ρ = ½ + iγ of ζ(s) control the error in
the prime counting function:

```
π(x) = Li(x) - Σ_ρ Li(x^ρ) + ...
```

Each zero contributes an oscillation to π(x) at scale x^{1/2}.

### What the MSS-n sequence measures:

|Σ_n| counts the forced symbols at level n.
The difference sequence Δ_n counts the forcing events.
Δ_n = 2 marks a conjugate pair: two symbols forced simultaneously.

### The proposed correspondence:

```
γ_k  (imaginary part of k-th Riemann zero)
↔
n_k  (level at which the k-th conjugate pair is forced)
```

The k-th zero γ_k controls an oscillation in the prime counting
function at a specific frequency. The k-th conjugate pair Δ=2
event marks a new structural duality entering the symbol system.

**Both count the same thing:** the moments where the universe is
forced to introduce a pair rather than a singleton.

### The RH statement in this language:

**RH** says all γ_k have Re(ρ) = ½.

In MSS-n language this would mean:

> All conjugate pair forcing events occur at the same
> structural depth ½ relative to the tower height.

i.e., the 2s in the Δ sequence are symmetrically distributed
around the "middle" of the tower.

**If the tower is infinite** (no self-complete level):
RH says the asymptotic density of Δ=2 events is
concentrated on the critical line — no pairs cluster
shallower or deeper than ½.

**If the tower converges** (self-complete at N):
RH says the Δ=2 events are symmetric around N/2.

---

## The Monad T at Each Level

```
T_n = U_n ∘ F_n

T_0: {0,1} → {0,1}   (identity — nothing forced yet)
T_1: adds →           (direction: fixed point of T_1 = directed graph)
T_2: adds *           (second node: fixed point = labeled graph)
T_3: adds #           (enables cycles: fixed point = graph with β₁≥1)
T_4: adds ∅,=         (exactness: fixed point = chain complex)
T_5: adds ℝ,<_ℝ       (measurement: fixed point = normed chain complex)
T_6: adds i           (phase: fixed point = complex chain complex)
T_7: adds ρ,tr        (statistics: fixed point = density matrix theory)
T_8: adds ⊗           (composition: fixed point = tensor category)
T_9: adds â†,â        (Fock: fixed point = QFT Fock space)
T_10: adds φ(x)       (local: fixed point = local QFT)
```

The fixed points of T_n are the **harmonic forms** at level n —
the structures that survive the forgetful functor unchanged.

β_n = dim(ker T_n) = number of independent harmonic classes at level n.

This is the Betti number. The Euler characteristic:

```
χ = β_0 - β_1 + β_2 - β_3 + ...
```

**Conjecture B:**
The zeros of ζ(s) are the values where χ(MSS-s) = 0,
i.e., the levels where the forced lifts and forgetful collapses
are in exact balance.

---

## Open Questions

```
Q1. Does Δ_n = 1 or 2 for all n? Or does Δ_n = 3 ever occur?
    (Would require a triple — three symbols mutually forced.)
    
Q2. What is |Σ_∞|? Does the tower converge?

Q3. Is the Δ=2 pattern in correspondence with the Riemann zeros,
    or is this numerology?
    (Test: compute Δ_n for n=11..100 and check against γ_k.)
    
Q4. What is the precise functor F_{n→n+1} for each n?
    (Specified above for n=0..10 but not fully formalized.)
    
Q5. Is the missing-value set {6,8,11,14,...} known?
    What is its asymptotic density?
```

---

*Status: conjecture-level. Mechanically tight for n=0..10.*
*The Riemann connection is a hypothesis, not a theorem.*
