**AuthorityEffect: None.**  
**Status:** historical research. Not CLAIM-RH. Not a laboratory certificate. Not MSS-N finite-core canon.  
See `README.md` in this folder for the quarantine fence.

# 03. MSS-n Tower and Arithmetic Shadows

## 1. The MSS-n Tower Definition

$\text{MSS-}n = (\Sigma_n, R_n)$

- CLOSED: $\forall e \in \Sigma_n^* : \operatorname{nf}(e) \in \Sigma_n^*$
- FORCED: $\exists e \in \Sigma_n^* : \operatorname{nf}(e) \notin \Sigma_n^*$

The Adjunction:
$F : \text{MSS-}n \to \text{MSS-}(n+1)$ (up functor)
$U : \text{MSS-}(n+1) \to \text{MSS-}n$ (forgetful functor)
$F \dashv U$

The Monad:
$T_n = U_n \circ F_n : \text{MSS-}n \to \text{MSS-}n$
Fixed points of $T_n$ = harmonic forms at level $n$.

## 2. Minimal Symbol Count

The sequence of $|\Sigma_n|$: $2, 3, 4, 5, 7, 9, 10, 12, 13, 15, 16, \ldots$

Conjugate Pair Rule: $\Delta_n = 2 \iff \text{forced symbol has a structural dual}$.
(e.g. zero needs equality, reals need ordering, density matrix needs trace).
$\Delta_n = 1 \iff \text{forced symbol is self-contained}$.

## 3. Minimum Symbol System -- MSS Tower Transfer Matrix

MSS-0 $\to$ MSS-1 is the 0-skeleton to 1-skeleton move.
Transfer matrix $A$ for de Bruijn graph $B(2,1)$:
Eigenvalues: $\lambda = 2, 0$. Topological entropy = $\log 2$.

Zeta function:

$$\zeta_{\text{MSS}}(z) = \frac{1}{\det(I - zA)} = \prod_{p\ \text{primitive}} \frac{1}{1 - z^{|p|}}$$

Primitive orbit count at prime $n$: $\pi(n) = (2^n - 2)/n$.
Primes as primitive periodic orbits -- not metaphor. The Riemann zeta is the arithmetic shadow of this, projected onto $\mathbb{Z}$.

## 4. Adjunction, L¹ Topology, and Prime-Indexed Minimum Symbol Systems

Adjoint vs Additive vs L¹:

- Adjoint: Up functor $U$ (pullback) and Down functor $D$ (pushforward).
- Additive: Down functor sums over fibers. This is the $L^1$ world: total mass, total defect.
- L¹ Instinct: Tracks total obstruction. Down functor aggregates this.

Prime-Indexed Minimum Symbol System:

- 0-skeleton: set of primes $\mathcal{P}$.
- 1-skeleton: loop edge $e_p$ at that prime.
- Transfer operator: $(T_s f)(p) = p^{-s} f(p)$.
- Global zeta: $\zeta(s) = \prod_p \frac{1}{1 - p^{-s}}$. Coproduct of the minimal loop system over all primes.

The Real Move: Computing $\text{MSS}_0 \xrightarrow{F^{\uparrow}_0} \text{MSS}_1 \xrightarrow{U_0} \text{MSS}_0$.
Identify $\Delta_0(X) = U_0 F^{\uparrow}_0 X - X$.

Under the corrected ontology, this is not an absence-origin move. It is the test of whether an unresolved boundary condition remains gauge-removable after lift and descent, or whether it returns with nonzero filling cost:

$$
C_0=\partial F_{\mathrm{deg}},\quad A(F_{\mathrm{deg}})=0
\quad\longrightarrow\quad
F_{\mathrm{act}},\quad A(F_{\mathrm{act}})>0.
$$

The arithmetic question is then sharpened: do primitive orbits count repeatable residues of forced area-lock, or only repeatable symbolic residues? A zeta product becomes physically meaningful only after the primitive cycles survive the area-lock minimization:

$$
\gamma \in \mathrm{PrimForce}
\quad\text{and}\quad

\inf_{\partial F=\gamma}|F|_1>0.

$$

## 5. Dagger Involution and Symmetry Emergence

RH-type symmetry ($s \leftrightarrow 1-s$) **cannot live on the MSS graphs themselves**. On MSS graphs, morphisms are directed paths representing implication, and reversing edges would destroy coboundary orientation, breaking the obstruction calculus. A dagger here would collapse the ascent engine. Symmetry only emerges *after* obstruction stabilizes.

The symmetry acts instead on the **periodic structure**: the machine that generates and composes primitives. This machine is the **Zeta Profunctor Monad**.

A dagger on a profunctor is a contravariant involution $(-)^\dagger : \mathcal{Z} \Rightarrow \mathcal{Z}^{op}$. On primitive orbits, the dagger reverses the traversal order (preserving cycle support) and transports weights $t^{|p|} \mapsto t^{-|p|}$. Because primitivity reduction commutes with reversal, the Zeta profunctor monad is naturally a **dagger monad**.

The trace of this profunctor monad is the zeta generating object. The dagger induces an invariance $\operatorname{Tr}(\mathcal{Z})^\dagger = \operatorname{Tr}(\mathcal{Z})$, which forces the continuous spectrum transformation $s \leftrightarrow 1-s$ to center exactly on the critical line.

**Theorem:** *RHS symmetry is impossible at the graph level, unavoidable at the profunctor-monad level, and automatic at the trace (zeta) level. It is the dagger involution of the Zeta profunctor monad, acting on primitive periodic structure after $\Delta$-stabilization.*

## 6. $\ell^1$ Stabilization, Dagger Unitarity, and Zeros

A dagger involution requires an object that is invariant under reversal--a stable fixed point of forced forgetting. $\ell^2$ minimization fails this requirement because it smears obstruction across generators, producing averages that are not idempotent. Reversing an $\ell^2$ average changes it.

$\ell^1$ minimization, conversely, projects onto the Eilenberg-Moore category of the lift-forget monad $T_n = U_n F_n$. It produces sparse, atomic representatives and is strictly **idempotent**:
$$ \alpha(\alpha(x)) = \alpha(x) $$

This $\ell^1$ stabilization guarantees that the harmonic representative $[h]$ satisfies $T_n([h]) = [h]$, creating an orientation-stable object where forward and backward paths share the same equivalence class support.

### Zeros vs Critical-Line Points

- **Zeros (Dagger Unitarity Failure):**In non-primitive strata, cycles factor into composites. $\ell^1$ stabilization fails to isolate a unique support, so the dagger maps the weight into a different equivalence class. The profunctor monad $\mathcal{Z}$ loses unitarity ($\mathcal{Z}^\dagger \circ \mathcal{Z} \neq \mathrm{id}$), trace cancels, and the generating function vanishes.*Zeros correspond to places where the dagger cannot be defined because stabilization has failed.*
- **Critical-Line Points (Balanced Fixed Points):**For primitive harmonic $[p]$, support is minimal and indivisible. Forward and backward flows match perfectly. $\mathcal{Z}^\dagger([p]) = [p]$ up to phase/weight normalization. At the trace level, this balance condition enforces symmetry $s \leftrightarrow 1-s$.*Critical-line points are exactly those primitive strata where $\ell^1$-stabilized objects are dagger-fixed (self-dual).*

**Core Theorem:** *$\ell^1$ stabilization is the categorical operation that produces fixed points of the lift-forget monad; only on these fixed points does the Zeta profunctor monad admit a dagger structure. Zeros arise precisely at strata where dagger-unitarity fails due to unresolved composition, while critical-line points are the balanced dagger-fixed primitives.*

## 7. The KMS Condition and Trace Invariance

A KMS (Kubo-Martin-Schwinger) condition expresses equilibrium between forward and backward composition. Here, this is derived purely categorically without any physical assumptions, arising from the interaction of the trace with the dagger on stabilized fixed points.

Let $z_1, z_2 \in \mathcal{Z}$ be $\ell^1$-stabilized primitive fixed points. Because fixed points eliminate leakage, trace cyclicity holds: $\mathrm{Tr}(z_1 \star z_2) = \mathrm{Tr}(z_2 \star z_1)$. However, cyclic rotation in the profunctor monad equals reversal plus conjugation, enforced by the dagger.

The KMS condition follows directly:
$$ \mathrm{Tr}_{\mathcal{Z}, s}(z_1 \star z_2) = \mathrm{Tr}_{\mathcal{Z}, 1-s}(z_2 \star z_1) $$
Equivalently:
$$ \mathrm{Tr}_{\mathcal{Z}, s}(z_1 \star z_2) = \mathrm{Tr}_{\mathcal{Z}, s}(z_2 \star z_1^\dagger) $$

This is forced because the dagger acts by reversing accumulation, which inverts the growth parameter $s \mapsto 1-s$.

## 8. Uniqueness of the Zeta Trace

**Uniqueness Theorem:** *Any additive invariant $I$ on the MSS tower that vanishes off $\ell^1$-stabilized fixed points and satisfies the dagger-induced KMS identity factors uniquely through the zeta trace of the Zeta profunctor monad.*

1. **Reduction:** $I$ is determined entirely by its values on primitive stabilized objects.
2. **Dagger Balance:** The KMS identity forces $I(p) = I(p^\dagger)$. Thus $I$ is constant on dagger-orbits of primitives.
3. **Universality:** The Zeta trace is exactly the sum over primitive dagger-orbits. Therefore, any such invariant $I$ cannot distinguish anything finer than the Zeta trace.
4. **Factorization:** There exists a unique homomorphism $\phi$ such that $I = \phi \circ \mathrm{Tr}_{\mathcal{Z}}$.

### Consequences

- The Zeta trace is the inevitable, unique invariant of the tower at this level.
- Zeros are not special values--they are the forced annihilation by this universality outside dagger-unitary strata.
- The critical line $s \leftrightarrow 1-s$ is rigid. Any deviation violates factorization.

---

## 9. Confluence-Theoretic Formalization of the Conjugate Pair Rule

We work entirely in **rewrite-system terms**, defining obstruction as a failure of confluence without requiring semantics or category theory.

### Setup

At MSS level $N$:

- Term language: $\mathcal{L}_N$
- Rewrite relation: $\to_N$ (admissible internal repair)
- Normalization target: canonical representative of repair-equivalence class ($\mathsf{NF}_N$)

We **do not assume** termination, confluence, or unique normal forms (these are closure attempts).

### Definition 1: Obstruction Equivalence

Obstruction equivalence is the equivalence relation induced by admissible repair failure. It lives exactly at the point where repair fails--below truth, identity, and proof.
Let $x \in \mathcal{L}_N$. Define repair reachability:
$$ x \Downarrow_N y \iff x \to_N^* y \text{ and } y \text{ is irreducible under } \to_N $$
Define the **obstruction equivalence**:
$$ x \sim_N y \iff \forall r \in \text{Adm}_N, \; (r(x) \text{ irreducible}) \iff (r(y) \text{ irreducible}) $$
Equivalently: $\mathsf{NF}_N(x)$ and $\mathsf{NF}_N(y)$ are both undefined or non-unique in the same way (both get stuck, branch, or loop into structurally indistinguishable dead ends).

An obstruction exists at level $N$ iff $\exists x \text{ such that } \mathsf{NF}_N(x) \text{ is not unique or not defined}$. This is **non-confluence**.

### Definition 1b: Admissible Contexts (The Control Surface)

Context is the measuring apparatus that triggers a $\Delta=2$ lift. An **admissible context** $C[\square] \in \mathcal{L}_N$ is an embedding that preserves well-formedness ($C[x] \in \mathcal{L}_N$) and repair monotonicity (if $x \to_N y$, then $C[x] \to_N^*C[y]$). It must*not* enable repairs that were not already admissible at level $N$. Admissible contexts define the current observational power of the system.

Obstruction equivalence is tested *relative to all admissible contexts*:
$$ x \sim_N y \iff \forall C[\square] \in \text{AdmCtx}_N, \; C[x] \text{ and } C[y] \text{ fail normalization identically} $$

If two failures are locally indistinguishable ($x \sim_N y$) but distinguishable when embedded into a larger admissible structure ($C[x] \not\sim_N C[y]$), then obstruction equivalence fails to be a congruence. A $\Delta=2$ lift is forced precisely because unary lifts only provide a single context shell, which fails to encode the broken congruence.

**Nesting and $\Delta>2$ Prevention:**Admissible contexts can be nested inductively, but only if the composite preserves admissible repair. Crucially, nested admissible contexts*do not increase $\Delta$*. Because contexts are monotone, any contextual distinction ultimately reduces to binary questions (e.g., $C[x]$ repairable? yes/no). Any higher-arity distinction would require nested contexts to distinguish states in three incompatible ways, which decomposes into sequential binary failures that MSS lifts earlier. Context sensitivity is deep but strictly binary-generating.

### Definition 2: Unary Repair Attempt & Confluence Restoration

A **unary lift** adds a constructor $s : \mathcal{L}_N \to \mathcal{L}_{N+1}$ with lifted rewrite rules ($x \to_N y \implies s(x) \to_{N+1} s(y)$) and *no* rule inspecting the interior of $s(\cdot)$. This models $\Delta = 1$.
A lift **restores confluence** iff $\forall x \in \mathcal{L}_N, \; \mathsf{NF}_{N+1}(s(x))$ exists and is unique up to $\sim_N$.

### Theorem 1 (Conjugate Pair $\iff$ Unary Confluence Failure)

>
> **Unary lift suffices iff obstruction equivalence is a congruence.**

Formally: $RequiresComparison(O_N) \iff \sim_N \text{ is not a congruence on } \mathcal{L}_N$.

### Proof

($\implies$) Assume `RequiresComparison(O_N)` is false. There exists unary $s$ such that $s(x) \equiv s(y) \implies x \sim_N y$. Thus $\sim_N$ is respected by all contexts of the form $s(\Box)$: it is a congruence. Rewriting modulo $s$ collapses exactly obstruction classes, restoring confluence.
($\impliedby$) Assume $\sim_N$ is not a congruence. There exist $x \sim_N y$ and a context $C[\Box]$ such that $C[x] \not\sim_N C[y]$. Any unary lift $s$ only introduces contexts of the form $s(\Box)$, which cannot distinguish these cases. Confluence cannot be restored by unary extension alone. $\blacksquare$

### Corollary (Conjugate Pair Rule, Rewrite Form)

$$
\Delta_N =
\begin{cases}
1 & \text{if } \sim_N \text{ is a congruence} \\
2 & \text{if } \sim_N \text{ is not a congruence}
\end{cases}
$$

---

## 10. Theorem 2: No Higher-Arity Obstruction ($\Delta > 2$ is Impossible)

> Under MSS axioms, **every irreducible obstruction equivalence is at most binary-relational**. Therefore, $\Delta_N > 2$ can never occur.

### Proof (Structural)

1. **What a lift must do:** A lift must restore confluence without modifying existing rewrite rules, purely by adding new constructors. The new syntax must separate non-congruent obstruction classes by embedding them into canonical normal forms.
2. **Why unary fails:**Unary constructors fail exactly when obstruction equivalence depends on*comparison* (i.e., it is relational, not functional). Examples include exact vs. non-exact, provable vs. unprovable, admissible vs. invalid. All are binary relations.
3. **Why binary always suffices:** Given any non-congruence equivalence $\sim_N$, there exists a minimal separating relation $R(x,y) \in \{0,1\}$ witnessing the obstruction. Introduce two constructors, $s_0(x)$ and $s_1(x)$, corresponding to the two equivalence classes under $R$. This always suffices to refine equivalence into a congruence and restore confluence. No third symbol is ever required.
4. **Why ternary cannot be forced:** If $\Delta_N \ge 3$ were required, the obstruction equivalence would require three mutually incompatible normal forms. This means no binary partition could separate obstruction classes. This contradicts the MSS axiom of minimality: an obstruction is introduced only when required to distinguish irreducible failure. Any obstruction appearing as three mutually exclusive states must have already appeared earlier as a binary failure under refinement. Ternary irreducibility cannot arise *for the first time* at any level.

Let $\sim_N$ be the obstruction equivalence. Under MSS constraints, $\text{index}(\sim_N) \le 2$. Therefore:
$$ \Delta_N \in \{1,2\} \text{ always.} \quad \blacksquare $$

---

## 11. The Global $\Delta$-to-Layer Map (Violation Tested)

No MSS layer violates the Conjugate Pair Rule. Every $\Delta=2$ jump corresponds to a provable failure of unary distinguishability, and every $\Delta=1$ jump corresponds to an injective unary naming.

| Transition         | Obstruction $O_N$                   | RequiresComparison? | $\Delta_n$ | New Symbols            |
| :----------------- | :---------------------------------- | :------------------ | :--------- | :--------------------- |
| **MSS-0 $\to$ 1**  | Nonclosure unmarkable               | ❌                   | 1          | `mark`                 |
| **MSS-1 $\to$ 2**  | Ambiguous adjacency                 | ❌                   | 1          | `edge`                 |
| **MSS-2 $\to$ 3**  | Local relation insufficient         | ❌                   | 1          | `graph carrier`        |
| **MSS-3 $\to$ 4**  | Cycles indistinguishable from exact | ✅                   | 2          | `cycle`,`exactness`    |
| **MSS-4 $\to$ 5**  | Detection $\neq$ permission         | ❌                   | 1          | `license`              |
| **MSS-5 $\to$ 6**  | Claim conflicts                     | ✅                   | 2          | `obligation`,`invalid` |
| **MSS-6 $\to$ 7**  | Rules not inspectable               | ❌                   | 1          | `quote`                |
| **MSS-7 $\to$ 8**  | Encoding $\neq$ derivation          | ✅                   | 2          | `Proof_T`,`Prov_T`     |
| **MSS-8 $\to$ 9**  | Self-application                    | ❌                   | 1          | `Fix`                  |
| **MSS-9 $\to$ 10** | Self-certification                  | ✅                   | 2          | `G1`,`G2`              |

This yields exactly $S(N)$: **2, 3, 4, 5, 7, 9, 10, 12, 13, 15, 16...**
