# Finite Contextual Quotient Homology and Licensed Cell Extension  
## A Mathematical Core for MSS-N / UROS

> **Status:** combined mathematics-centered paper.  
> **Scope:** finite categories, finite presheaf contexts, quotient cohomology, dual holonomy witnesses, contextual congruence, finite cell extension, primitive survivor algebra, and conditional infinite-tower zeta objects.  
> **Exclusions:** no physics claim, no consciousness claim, no quantum-computing claim, no analytic-continuation claim, no Riemann Hypothesis claim.

---

## Abstract

This paper defines MSS-N / UROS as a finite categorical and homological framework for obstruction, repair, contextual non-congruence, and licensed extension. At each level \(n\), a finite context category acts on a finite term category, while licensed repairs generate a cochain complex

\[
C^0_n \xrightarrow{d_{0,n}} C^1_n \xrightarrow{d_{1,n}} C^2_n,
\qquad d_{1,n}d_{0,n}=0.
\]

Exact repairs form the subspace \(B^1_n=\operatorname{im}(d_{0,n})\), quotient obstruction lives in

\[
Q^1_n=C^1_n/B^1_n,
\]

and stabilized survivors are closed non-exact classes in

\[
H^1_n=\ker(\overline d_{1,n})
\cong \ker(d_{1,n})/\operatorname{im}(d_{0,n}).
\]

The finite category of contexts provides the observational boundary. A lift is licensed only when quotient equivalence fails to be a congruence under an admissible context. Thus the central mathematical object is not raw obstruction, but **context-visible quotient non-congruence**. The central invariant is not a scalar, but the lift-forget fixed subobject

\[
\operatorname{Skel}_n
=
\{q\in H^1_n\setminus\{0\}:U_nF_n(q)=q\}.
\]

The resulting theory is finite contextual quotient homology plus controlled cell extension.

---

## 0. Boundary and Evidentiary Grades

The framework is stratified.

### Canonical finite core

The theorem-grade core contains:

1. finite term and context categories;
2. finite presheaf/topos context;
3. finite cochain complexes;
4. quotient norm and dual certificates;
5. contextual congruence and critical-pair witnesses;
6. finite lift contracts;
7. primitive survivor algebra under separability hypotheses;
8. typed terminal states and refusal conditions.

### Research extensions

The research layer contains:

1. primitive decomposition across families of carriers;
2. tower languages;
3. filtered diagrams;
4. survivor zeta functions;
5. transfer operators.

These require additional hypotheses.

### Speculative bridges

Arithmetic shadows, RH-like fluctuation laws, spectral analogies, and realization functors are not part of the core. They are conditional programs.

No theorem below asserts anything about physical law, consciousness, quantum mechanics, analytic continuation, or the classical Riemann Hypothesis.

---

## 1. Ambient Categories

Let

\[
\mathsf{FinCat}
\]

be the category of finite small categories,

\[
\mathsf{FinSet}
\]

the category of finite sets, and

\[
\mathsf{Vect}^{\mathrm{fd}}_{\mathbb R}
\]

the category of finite-dimensional real vector spaces.

For a finite category \(\mathcal C\), define the finite presheaf category

\[
\widehat{\mathcal C}_{\mathrm{fin}}
=
\mathsf{FinSet}^{\mathcal C^{op}}.
\]

This is the basic finite topos-like environment. If a finite Grothendieck topology \(J\) is declared, one may form

\[
\mathsf{Sh}(\mathcal C,J)
\subseteq
\widehat{\mathcal C}_{\mathrm{fin}},
\]

but no sheaf topology is automatic.

The finite setting is intentional. All covers, matching families, gluing tests, chain groups, and certificates are finite.

---

## 2. MSS-N Levels

An MSS level is a tuple

\[
\mathcal M_n
=
(\mathcal T_n,\mathcal C_n,\rho_n,L_n,D_n,O_n,\delta_n,\chi_n,\omega_n,\mu_n),
\]

where:

| Symbol | Type | Role |
|---|---|---|
| \( \mathcal T_n \) | finite category | terms or states |
| \( \mathcal C_n \) | finite category | admissible contexts |
| \( \rho_n \) | functor | context action |
| \( L_n \) | finite set | licensed repair generators |
| \( D_n \) | finite set | distinction coordinates |
| \( O_n \) | finite set | obstruction coordinates |
| \( \delta_n \) | linear map | repair boundary |
| \( \chi_n \) | linear map | closure boundary |
| \( \omega_n \) | positive weights on \(D_n\) | quotient norm data |
| \( \mu_n \) | finite well-founded measure | descent ranking |

The context action is a functor

\[
\rho_n:\mathcal C_n\to \mathsf{End}(\mathcal T_n).
\]

The finite cochain carrier is

\[
C^0_n\xrightarrow{d_{0,n}}C^1_n\xrightarrow{d_{1,n}}C^2_n,
\]

with

\[
C^0_n=\mathbb R^{L_n},
\qquad
C^1_n=\mathbb R^{D_n},
\qquad
C^2_n=\mathbb R^{O_n},
\]

and

\[
d_{0,n}=\delta_n,
\qquad
d_{1,n}=\chi_n,
\qquad
d_{1,n}d_{0,n}=0.
\]

Thus \(C^\bullet_n\) is a finite cochain complex concentrated in degrees \(0,1,2\).

---

## 3. Presheaf and Topos Form

The level \(n\) admits a context presheaf

\[
X_n:\mathcal C_n^{op}\to\mathsf{FinSet},
\]

where \(X_n(c)\) is the finite set of states visible through context \(c\).

The distinction data may be represented as a finite-dimensional vector presheaf

\[
\mathscr D_n:\mathcal C_n^{op}\to
\mathsf{Vect}^{\mathrm{fd}}_{\mathbb R}.
\]

A local family of compatible data is a matching family in

\[
\widehat{\mathcal C_n}_{\mathrm{fin}}.
\]

The basic sheaf-like obstruction pattern is

\[
\text{local matching family}
\quad\not\Rightarrow\quad
\text{global section}.
\]

When a topology \(J_n\) is declared, this becomes literal finite sheaf theory. Without \(J_n\), it remains presheaf-level contextual obstruction.

---

## 4. Quotient Homology of Repair

The exact repair subspace is

\[
B^1_n=\operatorname{im}(d_{0,n})\subseteq C^1_n.
\]

The quotient distinction space is

\[
Q^1_n=C^1_n/B^1_n.
\]

Let

\[
\pi_n:C^1_n\to Q^1_n
\]

be the quotient map.

Since \(d_{1,n}d_{0,n}=0\), the closure map descends uniquely to

\[
\overline d_{1,n}:Q^1_n\to C^2_n
\]

such that

\[
\overline d_{1,n}\pi_n=d_{1,n}.
\]

The closed quotient object is

\[
H^1_n
=
\ker(\overline d_{1,n})
\cong
\ker(d_{1,n})/\operatorname{im}(d_{0,n}).
\]

Elements of \(H^1_n\setminus\{0\}\) are closed non-exact quotient classes. They are not automatically primitive.

---

## 5. Weighted Quotient Norm

For \(x\in C^1_n\), write

\[
[x]_n=x+B^1_n\in Q^1_n.
\]

Define the weighted \(\ell^1\) norm on \(C^1_n\cong\mathbb R^{D_n}\) by

\[
\|x\|_{1,\omega_n}
=
\sum_{d\in D_n}\omega_{n,d}|x_d|.
\]

The quotient obstruction norm is

\[
\Phi_n([x]_n)
=
\inf_{\alpha\in C^0_n}
\|x-d_{0,n}\alpha\|_{1,\omega_n}.
\]

The closure mass is

\[
\Gamma_n([x]_n)
=
\|\overline d_{1,n}([x]_n)\|.
\]

### Proposition 5.1 — Normed Cokernel

The pair

\[
(Q^1_n,\Phi_n)
\]

is the normed cokernel of \(d_{0,n}:C^0_n\to C^1_n\) in finite-dimensional normed vector spaces. The infimum defining \(\Phi_n\) is attained.

#### Proof

Since \(C^1_n\) is finite-dimensional, \(B^1_n=\operatorname{im}(d_{0,n})\) is closed. The quotient norm on \(C^1_n/B^1_n\) is exactly

\[
\inf_{b\in B^1_n}\|x-b\|_{1,\omega_n}.
\]

Finite-dimensional properness gives attainment. \(\square\)

---

## 6. The Trichotomy

Define:

\[
\mathsf{Ex}_n
=
\{q\in Q^1_n:\Phi_n(q)=0\},
\]

\[
\mathsf{Surv}_n
=
\{q\in Q^1_n:\Phi_n(q)>0,\ \overline d_{1,n}(q)=0\},
\]

\[
\mathsf{Open}_n
=
\{q\in Q^1_n:\Phi_n(q)>0,\ \overline d_{1,n}(q)\ne0\}.
\]

In finite dimension, \(\Phi_n\) is a true norm on \(Q^1_n\), hence

\[
Q^1_n
=
\mathsf{Ex}_n
\sqcup
\mathsf{Surv}_n
\sqcup
\mathsf{Open}_n.
\]

Only \(\mathsf{Surv}_n\) is closed non-exact quotient residue.

---

## 7. Dual Homology and Holonomy Witnesses

The dual repair-annihilator is

\[
Z_{1,n}
=
\ker(d_{0,n}^*)
\subseteq (C^1_n)^*.
\]

Elements of \(Z_{1,n}\) pair with quotient classes because

\[
\varphi(d_{0,n}\alpha)=0
\qquad
(\varphi\in Z_{1,n}).
\]

Thus

\[
\langle \varphi,[x]_n\rangle
=
\varphi(x)
\]

is well-defined on \(Q^1_n\).

### Theorem 7.1 — Dual Quotient Certificate

For every \(x\in C^1_n\),

\[
\Phi_n([x]_n)
=
\max
\left\{
\varphi(x):
d_{0,n}^*\varphi=0,\ 
|\varphi_d|\le \omega_{n,d}
\right\}.
\]

The maximum is attained.

#### Proof

The primal program is the finite-dimensional linear program

\[
\min_{\alpha,u}
\sum_{d\in D_n}\omega_{n,d}u_d
\]

subject to

\[
-u_d
\le
x_d-(d_{0,n}\alpha)_d
\le
u_d.
\]

The dual constraints are precisely

\[
d_{0,n}^*\varphi=0,
\qquad
|\varphi_d|\le \omega_{n,d}.
\]

Finite-dimensional linear-program duality gives equality and attainment. \(\square\)

A dual optimum \(\varphi^\ast\) is a holonomy witness of non-erasure:

\[
\varphi^\ast([x]_n)=\Phi_n([x]_n)>0.
\]

If a context loop \(\ell\) in the nerve \(N(\mathcal C_n)\) induces a dual cycle \(z_\ell\in Z_{1,n}\), define

\[
\operatorname{Hol}_n(x;\ell)
=
\langle z_\ell,[x]_n\rangle.
\]

Then

\[
\operatorname{Hol}_n(x+d_{0,n}\alpha;\ell)
=
\operatorname{Hol}_n(x;\ell).
\]

This is the finite holonomy form of repair-invariance.

---

## 8. Context Equivalence and Congruence

Let

\[
p_n:\operatorname{Ob}(\mathcal T_n)\to Q^1_n
\]

be the declared quotient profile map.

Define

\[
x\sim_n y
\quad\Longleftrightarrow\quad
p_n(x)=p_n(y).
\]

The equivalence \(\sim_n\) is a congruence relative to \(\mathcal C_n\) when

\[
x\sim_n y
\quad\Longrightarrow\quad
\rho_n(c)(x)\sim_n\rho_n(c)(y)
\quad
\forall c\in\operatorname{Ob}(\mathcal C_n).
\]

A context witness of non-congruence is

\[
w=(x,y,c)
\]

such that

\[
x\sim_n y,
\qquad
\rho_n(c)(x)\not\sim_n\rho_n(c)(y).
\]

Equivalently,

\[
p_n(x)-p_n(y)=0,
\]

but

\[
p_n(\rho_n(c)x)-p_n(\rho_n(c)y)\ne0.
\]

This is the categorical lift trigger. Obstruction without context non-congruence is not by itself a lift trigger.

---

## 9. Homotopy of Contexts

Let

\[
N(\mathcal C_n)
\]

be the nerve of the finite context category. A composable chain of context arrows is a simplex in \(N(\mathcal C_n)\).

If two context paths \(a,b\) have the same endpoints, a declared homotopy filler is a 2-simplex or finite zigzag of 2-simplices identifying them in a homotopy category

\[
\operatorname{Ho}(\mathcal C_n).
\]

Path invariance of quotient profiles is

\[
p_n(\rho_n(a)x)=p_n(\rho_n(b)x)
\]

whenever

\[
a\simeq b
\quad
\text{in}
\quad
\operatorname{Ho}(\mathcal C_n).
\]

A homotopy obstruction is

\[
\Theta_n(x;a,b)
=
p_n(\rho_n(a)x)-p_n(\rho_n(b)x)
\in Q^1_n.
\]

If

\[
\Theta_n(x;a,b)\in H^1_n\setminus\{0\},
\]

then the obstruction is closed and quotient-stable. If

\[
\overline d_{1,n}\Theta_n(x;a,b)\ne0,
\]

then the obstruction is not yet closed at level \(n\).

This is the finite homotopical reading of context path failure.

---

## 10. Finite Cell Extension and Lift Contracts

A lift is a finite extension of presentations

\[
F_n:\mathcal M_n\to\mathcal M_{n+1}.
\]

It may add:

1. finite context objects or arrows;
2. finite term constructors;
3. finite repair generators;
4. finite distinction coordinates;
5. finite obstruction coordinates;
6. finite filler cells for declared homotopy defects.

A lift must have a finite contract

\[
\Lambda_n=(w,E,m,F_n,U_n,\iota_n,\pi_n),
\]

where:

| Component | Meaning |
|---|---|
| \(w\) | context witness of non-congruence |
| \(E\) | exhaustion or coverage certificate |
| \(m\) | minimality certificate for the constructor increment |
| \(F_n\) | extension morphism |
| \(U_n\) | forgetful comparison morphism |
| \(\iota_n\) | inclusion of old data |
| \(\pi_n\) | projection/descent of new data |

The constructor increment is meaningful only over a finite declared search class:

\[
\Delta(w)
=
\min\{|\mathsf G|:
\mathsf G\text{ is a finite generator set resolving }w\}.
\]

Without this declared finite class, \(\Delta(w)\) is undefined.

A lift contract must classify old certificates as:

\[
\text{preserved},\quad
\text{refined},\quad
\text{invalidated}.
\]

No lift may silently mutate old certificate status.

---

## 11. Lift-Forget Fixed Subobjects

When a forgetful comparison is declared,

\[
U_n:\mathcal M_{n+1}\to\mathcal M_n,
\]

the lift-forget endomap is

\[
T_n=U_nF_n.
\]

Assume \(T_n\) induces an endomorphism on \(Q^1_n\) and \(H^1_n\). The fixed closed skeleton is

\[
\operatorname{Skel}_n
=
\{q\in H^1_n\setminus\{0\}:T_n(q)=q\}.
\]

This object is theorem-grade once \(F_n\), \(U_n\), and the induced action on \(Q^1_n\) are declared.

It is not a monad unless unit, multiplication, and coherence laws are supplied.

The lift-forget invariant is a finite fixed subobject

\[
\operatorname{Skel}_n\hookrightarrow H^1_n.
\]

Define

\[
\operatorname{Fix}_{H}(T_n)
=
\{q\in H^1_n:T_n(q)=q\},
\]

\[
\operatorname{Mov}_{H}(T_n)
=
\{q\in H^1_n:T_n(q)\ne q\}.
\]

Then

\[
H^1_n
=
\operatorname{Fix}_{H}(T_n)
\sqcup
\operatorname{Mov}_{H}(T_n)
\]

as a set-level decomposition.

If an old quotient class is claimed to be preserved, it must lie in \(\operatorname{Fix}_{H}(T_n)\). If it lies in \(\operatorname{Mov}_{H}(T_n)\), the lift has changed or erased old quotient data relative to the declared comparison.

Thus the invariant principle is:

\[
\boxed{
\text{admissible extension preserves a finite quotient subobject, not merely a number.}
}
\]

---

## 12. Higher-Arity Residuals

Let \(R_n\subseteq C^1_n\) be a finite repair subspace or repair-generated subset.

A family

\[
(r_1,\dots,r_k)\subset R_n
\]

is locally exact on proper faces when every declared proper subface or proper subsum lies in

\[
\operatorname{im}(d_{0,n}).
\]

It has \(k\)-global failure when

\[
\sum_{i=1}^k r_i\in\ker(d_{1,n})
\]

and

\[
\sum_{i=1}^k r_i\notin\operatorname{im}(d_{0,n}).
\]

The higher-arity compatibility class is

\[
\tau_{k,n}(r_1,\dots,r_k)
=
\left[\sum_{i=1}^k r_i\right]
\in H^1_n.
\]

Its residual mass is

\[
\Phi_{2,n}^{(k)}(r_1,\dots,r_k)
=
\Phi_n(\tau_{k,n}(r_1,\dots,r_k)).
\]

This is a finite Čech-like obstruction: local exactness on proper pieces, global non-exactness on the whole family.

Higher-arity residuals affect naming pressure only when they are independent of the declared primitive monoid. If

\[
\mathsf M_n\cong \mathbb N^{(\mathsf P_n)}
\]

and

\[
q=\tau_{k,n}(r_1,\dots,r_k)\ne0,
\qquad
q\notin\langle\mathsf P_n\rangle_{\mathbb N},
\]

then \(q\) is not nameable by existing primitive generators. Any admissible context witness \(w_q\) detecting this class satisfies

\[
\Delta(w_q)\ge1.
\]

The safe implication is

\[
\tau_{k,n}\ne0
\wedge
\tau_{k,n}\notin \langle\mathsf P_n\rangle_{\mathbb N}
\Longrightarrow
S(n+1)>S(n),
\]

provided a finite context witness is present.

No universal claim is made that every higher-arity residual forces \(\Delta\ge2\). That requires a separate lower-bound theorem.

---

## 13. Primitive Survivor Algebra

Let

\[
\mathsf M_n\subseteq H^1_n
\]

be a declared commutative survivor monoid.

A nonzero element \(p\in\mathsf M_n\) is primitive when

\[
p=a+b,\quad a,b\in\mathsf M_n
\quad\Longrightarrow\quad
a=0\ \text{or}\ b=0.
\]

Let

\[
\mathsf P_n
=
\{p\in\mathsf M_n:p\text{ primitive}\}.
\]

The free-factorization condition is

\[
\mathsf M_n\cong \mathbb N^{(\mathsf P_n)}.
\]

This condition is not automatic. It requires quotient separability and cancellation.

Connected support, graph connectivity, and Betti rank do not imply primitive free factorization.

### Assumption 13.1 — Quotient Separability

For a stabilized representative \(h\) with support decomposition

\[
\operatorname{supp}(h)=\bigsqcup_i S_i,
\]

the quotient obstruction space decomposes compatibly:

\[
Q^1_{\operatorname{supp}(h)}
\cong
\bigoplus_i Q^1(S_i),
\]

and

\[
\Phi([h])=\sum_i\Phi([h_i]).
\]

This prevents exact repairs from coupling independent candidate components.

### Theorem 13.2 — Conditional Primitive Decomposition

Assume quotient separability, cancellation, and finite support. Then every element \(x\in\mathsf M_n\) decomposes uniquely as

\[
x=\sum_{p\in\mathsf P_n}m_p p,
\qquad
m_p\in\mathbb N,
\]

with finite support. Hence

\[
\mathsf M_n\cong\mathbb N^{(\mathsf P_n)}.
\]

#### Proof

Existence follows by finite descent on support and \(\Phi\)-mass: if \(x\) is primitive, stop; otherwise split \(x=a+b\) into nonzero independent summands and repeat. Finite support prevents infinite splitting.

For uniqueness, quotient separability and cancellation imply that no primitive summand can be traded across another. Therefore the coordinate multiplicities \(m_p\) are uniquely determined. \(\square\)

---

## 14. Naming Pressure

Let \(W_n\) be the finite set of primitive independent context witnesses admitted at level \(n\). Each witness has a constructor increment

\[
\Delta:W_n\to\mathbb N_{>0}.
\]

The naming-pressure sequence is

\[
S(n+1)
=
S(n)+\sum_{w\in W_n}\Delta(w).
\]

Equivalently, if \(G_{\le n}\) is the least free generator set naming all admitted primitive context distinctions through level \(n\),

\[
S(n)=|G_{\le n}|.
\]

This is not raw alphabet size, not Betti number, not \(\dim H^1_n\), and not the total number of quotient classes.

It is a generator-rank statistic under a declared primitive factorization regime.

The sharpness of \(S(n)\) depends on the minimality certificates in the lift contracts. Without those certificates, \(S(n)\) is accounting, not a lower bound.

---

## 15. Operators as Morphisms, Not Solvers

Operators are finite deterministic morphisms on declared carriers. They are not search procedures.

Mathematically, an operator at level \(n\) is a typed map

\[
A:X\to Y
\]

between declared finite carrier objects, satisfying:

1. deterministic evaluation;
2. no hidden state;
3. no internal search;
4. explicit carrier change;
5. compatibility with declared certificates or descent measures.

Operators may transform or propose. They may not certify acceptance.

Only the evaluator can classify a certified state.

---

## 16. Terminal States

The finite engine separates mathematical status from resource status.

\[
\texttt{Exact}
\]

means

\[
\Phi(q)=0
\]

with trusted certificate.

\[
\texttt{StabilizedSurvivor}
\]

means

\[
\Phi(q)>0,\qquad \overline d_1(q)=0
\]

with trusted closure.

\[
\texttt{CertifiedExhaustion}
\]

means open obstruction remains and all declared repair or lift routes have been covered.

\[
\texttt{BudgetUnknown}
\]

means resources ended before a coverage certificate was obtained.

The distinction is essential:

\[
\boxed{
\text{exhausted structure}\ne\text{exhausted resources}.
}
\]

---

## 17. Finite Tower

A finite MSS-N tower is a sequence

\[
\mathcal M_0
\xrightarrow{F_0}
\mathcal M_1
\xrightarrow{F_1}
\cdots
\xrightarrow{F_{N-1}}
\mathcal M_N.
\]

Each transition requires a lift contract. If forgetful maps are declared, then for \(i\le j\),

\[
F_{i,j}:\mathcal M_i\to\mathcal M_j,
\qquad
U_{i,j}:\mathcal M_j\to\mathcal M_i.
\]

The finite theory closes at

\[
\boxed{
\text{MSS-N}
=
\text{finite contextual homology}
+
\text{holonomy witnesses}
+
\text{homotopy fillers}
+
\text{primitive algebra}
+
\text{fixed quotient subobjects}
+
\text{bounded lift tower}.
}
\]

---

## 18. Conditional Boundary to MSS-\(\infty\)

The finite theory does not assert an infinite tower. If an infinite tower is declared, it is first a filtered diagram

\[
\mathcal M_\bullet:\mathbb N\to\mathsf{MSS},
\qquad
n\mapsto \mathcal M_n,
\qquad
n\le m\mapsto F_{n,m}.
\]

The formal infinite naming pressure is

\[
S_{\mathcal M}(\infty)
=
\sup_N S_{\mathcal M}(N).
\]

If every \(W_n\) is finite and every \(\Delta(w)\) is defined,

\[
S_{\mathcal M}(\infty)
=
S(0)+
\sum_{n=0}^{\infty}
\sum_{w\in W_n}\Delta(w)
\]

as an element of \(\mathbb N\cup\{\aleph_0\}\) for countable finite-increment towers.

The infinite naming monoid is

\[
\mathsf N_\infty
=
\varinjlim_N \mathsf N_{\le N}
\cong
\mathbb N^{(G_\infty)}
\]

only when primitive decomposition, quotient separability, additive costs, and old-generator preservation remain compatible through the tower.

---

## 19. Survivor Zeta: Conditional Construction

Suppose an infinite tower satisfies:

1. every finite survivor monoid has free primitive factorization;
2. old primitive generators are preserved or explicitly invalidated;
3. quotient separability persists;
4. costs are additive;
5. every generator birth has a finite witness and minimality certificate.

Let

\[
G_\infty
=
\bigsqcup_{N\ge0}
(G_{\le N+1}\setminus G_{\le N})
\]

be the primitive generator births, and let

\[
a:G_\infty\to\mathbb R_{>0}
\]

be a positive additive cost.

Then define

\[
\zeta_{\mathcal M}(s)
=
\prod_{g\in G_\infty}
(1-e^{-sa(g)})^{-1}.
\]

Let

\[
A_{\mathcal M}(T)
=
\#\{g\in G_\infty:a(g)\le T\}.
\]

The abscissa of absolute convergence is

\[
\sigma_0
=
\limsup_{T\to\infty}
\frac{\log A_{\mathcal M}(T)}{T}.
\]

The product converges absolutely for

\[
\operatorname{Re}(s)>\sigma_0.
\]

No analytic continuation follows from this product alone.

---

## 20. Separation from Classical Zeta

The classical Riemann zeta function satisfies

\[
\zeta(s)
=
\prod_{p}
(1-p^{-s})^{-1}
=
\prod_p
(1-e^{-s\log p})^{-1}.
\]

The survivor zeta becomes the classical Euler product only if there is an arithmetic realization

\[
R:G_\infty\to\{\text{rational primes}\}
\]

such that:

1. \(R\) is a bijection or controlled finite-multiplicity cover;
2. \(a(g)=\log R(g)\);
3. primitive addition maps to integer multiplication;
4. the induced Dirichlet series is \(\sum_{n\ge1}n^{-s}\).

Without this realization,

\[
\zeta_{\mathcal M}
\]

is an MSS survivor zeta, not the Riemann zeta.

Likewise, RH-like statements require either:

1. a counting law for \(A_{\mathcal M}(T)\), or
2. a transfer operator with trace-class/meromorphic continuation data.

An Euler product alone is not enough.

---

## 21. Deleted and Demoted Claims

The combined canonical paper excludes the following claims:

1. \(S(\infty)\) solves RH.
2. Every MSS tower has a zeta function.
3. Every survivor zeta has analytic continuation.
4. Finite Euler products have classical RH zeros.
5. The class of all UROS towers equals the primes.
6. The Riemann zeta is automatically generated by obstruction theory.
7. Physical law, mass spectra, quantum mechanics, or consciousness follow from the finite core.
8. \(\ell^1\) is the only norm for all mathematics.
9. \(\Delta\in\{1,2\}\) is a universal theorem.
10. PDEs or dynamics are consequences of the finite obstruction theory.

These require separate realization, lower-bound, or analytic theorems.

---

## 22. Compact Formula Sheet

\[
B^1_n=\operatorname{im}(d_{0,n}).
\]

\[
Q^1_n=C^1_n/B^1_n.
\]

\[
H^1_n=\ker(\overline d_{1,n})
\cong
\ker(d_{1,n})/\operatorname{im}(d_{0,n}).
\]

\[
\Phi_n([x])
=
\inf_{\alpha\in C^0_n}
\|x-d_{0,n}\alpha\|_{1,\omega_n}.
\]

\[
Z_{1,n}=\ker(d_{0,n}^*).
\]

\[
x\sim_n y
\iff
p_n(x)=p_n(y).
\]

\[
w=(x,y,c):
x\sim_n y
\wedge
\rho_n(c)x\not\sim_n\rho_n(c)y.
\]

\[
\operatorname{Skel}_n
=
\{q\in H^1_n\setminus\{0\}:U_nF_n(q)=q\}.
\]

\[
S(n+1)=S(n)+\sum_{w\in W_n}\Delta(w).
\]

\[
\mathsf M_n\cong\mathbb N^{(\mathsf P_n)}
\quad
\text{only under quotient separability and cancellation}.
\]

\[
\mathsf N_\infty
\cong
\mathbb N^{(G_\infty)}
\quad
\text{only when primitive compatibility persists through the tower}.
\]

\[
\zeta_{\mathcal M}(s)
=
\prod_{g\in G_\infty}
(1-e^{-sa(g)})^{-1}
\quad
\text{only in its absolute-convergence half-plane unless more data are supplied}.
\]

---

## 23. Minimal Theorem Statement

\[
\boxed{
\text{MSS-N is finite contextual quotient homology with holonomy witnesses, homotopy-sensitive congruence, conditional primitive algebra, and licensed finite cell extension.}
}
\]

Or in operational mathematical form:

\[
\boxed{
\text{repair by } \operatorname{im}d_0,\ 
\text{measure in } C^1/\operatorname{im}d_0,\ 
\text{stabilize in } H^1,\ 
\text{lift only on contextual non-congruence}.
}
\]
