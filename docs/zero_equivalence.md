# First nontrivial difference: zero-equivalence, descent, and refusal

This implements the approved quotient bridge on Omega Codex baseline `b8acbe0ccef33a83f41cafd37b9fe943a3414e5e`. The [Lean module](../lean/ZeroEquivalence.lean) contains 62 checked theorem declarations under `OmegaCodex.ZeroEquivalence`; the [dependency receipt](zero_equivalence_verification.json) binds every declaration to its source and direct import. No legacy project was built or bulk-imported.

The central result is task-specific: **E is the largest equivalence relation on the given carrier through whose quotient the declared zero-status descends.** Exact values and separately named readouts can require finer identifications. At the level of E, this is a reformulation of equivalence and inequality of quotient classes. It is not a derivation of nontriviality from fewer assumptions, nor a universal weakest structure joining all existing developments.

## Admissions from `<>`

The root inscription supplies none of the following by itself. The construction explicitly supplies a carrier `α`, value type `β`, a binary function `δ`, a predicate `Zero`, equality and logic, and reflexivity, symmetry, and transitivity of `E(x,y) := Zero(δ(x,y))`. Lean's quotient machinery is then used to form `Q := α/E`. No distinguished value of `α` or `β`, endpoint, orientation, origin, decidable equality on arbitrary carriers, or inhabitedness is assumed.

The type of `δ` is written in curried form, `α → α → β`. This is the plan's binary function. Only E must be symmetric: exact values of δ need not be symmetric, as the fourth fixture demonstrates.

A proposed identification additionally supplies an equivalence relation `S` on the same carrier. Judging it requires a specified preservation task. An internal evaluator, a certificate-producing procedure, an invocation, and a registered refusal are separate obligations. A checked proposition or a factor function is not evidence that such an event has occurred inside the modeled system.

## 1. The zero-equivalence kernel

`Kernel`, `ZeroRel`, `zeroSetoid`, `ResidualQuotient`, `classOf`, and `Nonzero` expose the construction directly. The following statements are proved:

| Statement | Lean anchor |
|---|---|
| E is an equivalence relation. | `zeroRel_equivalence` |
| R(x,y) := not E(x,y) is irreflexive and symmetric; R(x,y) implies x != y. | `nonzero_irrefl`, `nonzero_symm`, `nonzero_implies_ne` |
| [x] = [y] iff E(x,y); R(x,y) iff [x] != [y]. | `classOf_eq_iff_zeroRel`, `nonzero_iff_classes_ne` |
| There exists a related pair iff there exist two distinct quotient classes. This means at least two, not exactly two. | `exists_nonzero_iff_distinct_classes` |
| Q is a subsingleton iff E relates every pair. | `quotient_subsingleton_iff` |

The existence theorem uses quotient induction into a proposition. It does not extract a representative selector. `empty_quotient` proves both subsingleton status and the absence of an inhabitant for an empty carrier. `singleton_quotient` supplies an explicit inhabitant as well as subsingleton status for the singleton fixture. Thus at most one class is never silently promoted to exactly one.

These are constructive statements of existence and negation. In particular, no argument replaces the positive existence of two distinct classes by the negation of subsingleton status on an arbitrary carrier.

## 2. The coarsest permitted identification

For any candidate `S : Setoid α`, `ZeroStatusDescends K S` means that there exists

```text
F : (α/S) → (α/S) → Prop
F([x],[y]) = E(x,y), for every x,y.
```

Equality of propositions represents identical truth status; propositional extensionality connects this to a biconditional. This requires both directions of preservation. Merely requiring that existing zero pairs map to a true proposition would permit the constant-true output for every S and would not establish the theorem below.

`zero_status_descends_iff_refines` proves:

```text
ZeroStatusDescends K S  iff  ∀ x y, S(x,y) → E(x,y).
```

The proof exposes the assumptions:

1. If S identifies x and y, then the quotient input pairs ([x],[x]) and ([x],[y]) are equal. A descended zero-status must agree on them. E(x,x) holds by reflexivity, so E(x,y) holds.
2. Conversely, suppose S is contained in E. Replacing either argument by an S-equivalent one cannot change E, using E's symmetry and transitivity. Quotient lifting therefore supplies F.

E itself qualifies (`zero_status_descends_own`). Every qualifying S is contained in E. This is exactly the largest-identification, or coarsest-quotient, claim **for this fixed carrier, kernel, candidate class, and zero-status preservation task**. It does not maximize identifications preserving unspecified future readouts. `zero_status_refuses_nonzero_identification` gives the explicit obstruction when an S-equivalent pair is nonzero. This witness is supplied, not extracted from the negation of a universal preservation claim.

## 3. Exact values and named readouts

`BinaryDescends S δ` asks for a function on two S-classes reproducing the exact original δ-value at every pair. `BinaryCongruent S δ` requires δ(x,y) = δ(x',y') whenever S(x,x') and S(y,y'). `binary_descends_iff` proves their equivalence, and `binaryFactor` constructs the factor by quotient lifting. `binaryFactor_unique` proves uniqueness by quotient induction.

Specializing S to E gives `deltaFactor_exists_iff_deltaCongruent`, corresponding to the Anomalon theorem. Exact descent implies zero-status descent (`exact_descends_implies_zero_status`); the converse fails in fixtures 2 and 4 below.

For a named unary readout φ, `unary_descends_iff` proves that φ descends iff S-equivalent inputs receive equal φ-values. The factor is explicit, unique, and constructed without representative selection. `unary_no_factor_of_witness` and `binary_no_factor_of_witness` turn supplied equal-class/different-value witnesses into non-factorization proofs.

`pair_descends_iff` says the paired readout (φ,ψ) descends iff both components do. `localGreenGlobalRed_pair_obstruction` retains an explicit S-equivalent pair with different ψ-values. The finite instance uses the all-zero Boolean quotient: the constant readout φ(x)=false descends, while ψ(x)=x and the pair (false,x) do not. There is no implicit requirement to preserve every possible readout; adding ψ is an additional obligation.

## 4. Four finite cases

The `Three` constructors `zero`, `one`, and `two` are the table's coordinates and values 0,1,2. These labels are fixture presentations, not a distinguished position in the kernel API.

| Fixture | Difference and zero criterion | Own zero-quotient | Zero-status descends? | Exact δ descends? |
|---|---|---|---|---|
| `constantAllZero` | Bool; δ(x,y)=false; all values zero | Exactly one class | Yes | Yes |
| `nonconstantAllZero` | Bool; δ(x,y)=x; all values zero | Exactly one class | Yes | No |
| `binary` | Bool XOR; only false zero | Exactly two classes | Yes | Yes |
| `rich` | Three-position table below; 0 and 1 zero | Exactly two classes: {0,1}, {2} | Yes | No |

```text
        y=0  y=1  y=2
x=0      0    0    2
x=1      1    1    2
x=2      2    2    0
```

`four_fixtures_zero_status_descends` covers all four. The one-class statements include explicit inhabitedness. The two-class statements include distinct classes and a proof that every quotient element equals one of those two classes; they establish an upper bound as well as a lower bound.

The negative cases retain concrete witnesses:

- Fixture 2 identifies false with true, but δ(false,false)=false and δ(true,false)=true.
- Fixture 4 identifies 0 with 1, but δ(0,0)=0 and δ(1,0)=1.

Both pairs of binary inputs become equal in the relevant product of quotients. Their exact values remain unequal, so a factor cannot exist. The theorem names end in `failure_witness` and `not_exact_descends`.

The empty and singleton fixtures separately prove zero-status and exact-value descent. The empty quotient has no class; its descent statements do not manufacture one.

## 5. Logical strength versus preserved content

`fromSetoid S` uses proposition-valued differences: δ(x,y) is the proposition S(x,y), and Zero(p) is p itself. `fromSetoid_zeroRel` and `forget_reconstruct_zeroRel` establish the pointwise roundtrips at the level of E. Thus carrying a zero-equivalence kernel adds no logical strength to the existence of the admitted equivalence relation when arbitrary proposition-valued differences are permitted. This permits choosing Prop as the value type; it is not a claim about realizing every E in every preassigned value type.

This is not an equivalence of the full value-bearing data. `same_zeroRel_different_values` exhibits two Boolean-valued kernels with exactly the same E and different δ-values. `same_zeroRel_different_descent` shows that even exact factorization behavior is forgotten. Their proposition-valued reconstruction always descends (`fromSetoid_exact_descends`), whereas the original nonconstant all-zero δ does not.

| Distinction | What it says | What it does not say |
|---|---|---|
| Original presentation inequality x != y | Two carrier presentations are unequal. | They need not belong to different zero-classes. `presentation_inequality_without_class_inequality` supplies a counterexample. |
| Quotient inequality [x] != [y] | The presentations are not E-related; exactly R(x,y). | It does not inspect all δ-values within an E-class. |
| Exact-value inequality δ(x,y) != δ(x',y') | The specified values differ. | Either or both values may be declared zero; it need not distinguish quotient classes. |
| Failure of specified descent | Equal quotient inputs require different outputs for a named task. | It does not show failure of every other task, or an internally registered refusal. |

At the zero/nonzero level, R is precisely inequality on the quotient, pulled back to presentations. It is therefore an alternative encoding of that inequality. The equivalence relation determines which distinctions are retained before that comparison; original presentation inequality is a different relation in general.

There is also a logical boundary between E and R: defining R as not E does not constructively recover E as not R on arbitrary propositions. The roundtrip theorem preserves E directly; it does not assume double-negation elimination. The Boolean/three-position fixtures have concrete decidable tables, but no such decision assumption is imposed on every kernel.

### The reverse bridge fails in general

`isolatedEdge` relates 0 to 1 and 1 to 0, leaving 2 isolated. It is symmetric and irreflexive and has a witnessed pair. `isolatedEdge_not_equivalence_complement` proves that it is not the complement of any equivalence relation; `isolatedEdge_not_zero_complement` states the corresponding impossibility for any kernel on that carrier.

Intuitively, absence of edges 0–2 and 2–1 conflicts with the edge 0–1 under the proposed zero-transitivity. The formal proof combines double-negated zero facts to derive a contradiction without selecting proofs by classical choice or assuming excluded middle. Consequently, a general symmetric irreflexive relation cannot be translated back into this kernel while preserving its full relation. Zero-transitivity is additional content, not a consequence of symmetry and irreflexivity.

### Invariance under relabeling

`relabel` transports the carrier presentation along a supplied map. Zero and nonzero relations commute with it pointwise. For supplied inverse maps, `relabelQuotientMap`, `relabelQuotientInverse`, and their inverse-law theorems give mutually inverse quotient maps. No quotient representative is selected.

`relabel_exact_descends_iff` and `relabel_unary_descends_iff` preserve the descent judgments for transported values/readouts. For these two iff statements an explicit right inverse already suffices; the second inverse law is used for the quotient bijection. A bijective relabeling meets both requirements. These are generic results, so the four fixtures' classification does not depend on their displayed labels.

## 6. Comparison with the existing developments

These are source-bound comparisons, not imports of a universal kernel. The common description is candidate identification, required preservation, and obstruction.

| Development | Candidate identification | Required preservation | Obstruction and translation limit |
|---|---|---|---|
| `PrimDiff` bare assertions | A map c, possibly identifying a related pair | A pushed relational occurrence alone | A collision can survive as a self-loop. Collapse by itself is not a violation. Protecting irreflexivity turns it into one. |
| `FidelityObstruction` in `PrimDiff.lean` | c with a related-pair collision | A supplied target predicate P on the pushed relation | The definition combines the collision with failure of P. The definition alone does not assert source validity or furnish an evaluator. P must be specified. |
| Zero-status quotient descent | Equivalence S on the same carrier | E's truth status on every pair | Exactly S not contained in E, with an explicit nonzero identification as a failure witness. It uses E's equivalence laws. |
| Exact-value / unary descent | Equivalence S | The declared δ or named readout | An S-equivalent input collision with unequal required outputs obstructs descent. Equal-class structure alone does not specify these outputs. |
| `SymmetryFloor` | A supplied renaming fixing an input; an explicitly equivariant continuation f | Commutation of f with the renamings | The successor remains fixed by that renaming. This is a constraint on a rule and its symmetry data, not a quotient-only stopping rule. |
| `Bridge` | Admissions/extensions allowed by a supplied policy | The policy's admitted facts and laws | Policy-dependent token/witness conclusions do not create protection against all later extensions. Adding loops can preserve positive facts while destroying irreflexivity. |

There is a checked forward translation: `nonzero_collision_violates_irrefl` applies the existing primitive-difference collision theorem to R from any kernel. The reverse translation for arbitrary symmetric irreflexive relations fails by the isolated-edge example. In the Boolean XOR specialization, `binary_nonzero_iff_S2` identifies R with the existing S2 relation. That specialization does not make the generic kernel and S2 identical specifications.

For an arbitrary map c, its equality-of-images relation is an equivalence relation. A collision with unequal required readout values obstructs factorization through c. The quotient construction supplies a factor on all classes when congruence holds; constructing a total decoder on an arbitrary larger codomain additionally has to handle points outside c's image. The current mirror decoder uses an explicit finite observation interface and its own assumptions. No blanket equivalence with every decoder interface is asserted here.

Three legacy anchors prevent unsupported compression:

- `irred_empty_iff_ne`: resistance to an operation family containing only the generated identity behavior is exactly ordinary inequality. A refusal definition can therefore add no new strength in that comparison.
- `merger_erases`: permitting a constant merger eliminates every irreducible pair. Resistance depends on the allowed family; it does not follow from inequality alone.
- `D2_S2_collapse_equiv`: the directed edge and reciprocal S2 have the same collapse-collision profile for maps from Bool. That profile intentionally forgets orientation. Matching refusal profiles therefore need not preserve the full relational data or reduce the assumptions that produced it.

The `SymmetryFloor.floor` theorem actually needs an indexed family of maps and equivariance, not group/action laws. Neither its rule nor its fixed-input hypothesis is supplied by a static kernel. The operation and admission-policy data in the other developments likewise need separate accounts. This slice supplies limited translations and a failed reverse bridge; it does not establish that one weakest common structure exists.

## 7. Continuation boundary

Keep three predicates separate:

1. Q has at most one class.
2. Every currently required operation/readout descends.
3. The declared continuation relation has no successor at the current state.

For condition 2 with exact δ as the required task, the four fixtures realize all four truth-value combinations of conditions 1 and 2. If only zero-status is required, condition 2 holds in every fixture. The task cannot be omitted from this statement.

For condition 3, `static_kernel_does_not_determine_terminal` fixes the same kernel and the same quotient state q. The relation `halted` permits no successors; `identityStep` permits q to follow itself and is not terminal there. The theorem takes an actual q as input and does not assume an empty quotient has a current state.

The self-loop is an available successor, not a new distinction or productive growth. Both rules can lack any new distinguishing content. A statement that no new distinction is reachable requires a continuation grammar, reachability, and a definition of new content. None is inferred from subsingleton status or from satisfied descent obligations, and no general continuation engine is added.

## 8. Source correspondence and scope

The referenced files were checked locally against these exact repository heads; relevant paths had no working-tree differences. They remain read-only references.

| Source | Reconstruction or use |
|---|---|
| Anomalon [`lean4/PrimitiveDifference.lean`](https://github.com/dbccpage/anomalon/blob/ec9130572e5887b0fad9cb716aab31b76c512b8d/lean4/PrimitiveDifference.lean), commit `ec9130572e5887b0fad9cb716aab31b76c512b8d` | Reconstructs the zero kernel, quotient, exact factorization and unary-readout criterion. Generalizes descent to arbitrary S; retains explicit local-green/global-red witnesses. No pointed extension, value-setoid extension, context package, or later hierarchy is imported. |
| 19L57G1 [`PrimDiff.lean`](https://github.com/dbccpage/19L57G1/blob/45bb09864f9b52ed5ecf66e977ca81f0ed623de7/lean4/Derivation/PrimDiff.lean), commit `45bb09864f9b52ed5ecf66e977ca81f0ed623de7` | Bare assertions, collapse, `FidelityObstruction`, and the three comparison anchors. These legacy declarations were inspected, not rebuilt in this slice. |
| Same revision, [`Bridge.lean`](https://github.com/dbccpage/19L57G1/blob/45bb09864f9b52ed5ecf66e977ca81f0ed623de7/lean4/Derivation/Bridge.lean) | Admission-policy dependence, `irrefl_law_not_entailed`, and conditional `equivariant_witness_is_S2`. Comparison only. |
| Same revision, [`SymmetryFloor.lean`](https://github.com/dbccpage/19L57G1/blob/45bb09864f9b52ed5ecf66e977ca81f0ed623de7/research/symmetry_floor/lean/SymmetryFloor.lean) | Fixed-input equivariance floor and iteration. Comparison only. |
| Omega Codex baseline `b8acbe0ccef33a83f41cafd37b9fe943a3414e5e`, [PrimitiveDifference](../lean/PrimitiveDifference.lean) | Sole direct import. Reuses irreflexive-witness inequality and the collapse obstruction; adds the exact Boolean S2 crosswalk. Existing source bytes remain unchanged. |

`fromSetoid`, the coarsest-identification theorem, the isolated-edge counterexample, the richer fixture, relabeling proofs, and the static continuation comparison are reconstructed here for the approved investigation. Their mathematical statements are the evidence; no historical priority claim is made.

## 9. Verification

- `lake build`: all three bounded Lean libraries built with pinned Lean 4.33.0, no external Lake packages.
- New census: 62/62 theorem declarations checked. Allowed and observed axiom union: `propext`, `Quot.sound`. No `Classical.choice`, proof placeholders, new axioms, or opaque declarations.
- Existing censuses: 26/26 PrimitiveDifference and 19/19 MirrorNonIdentification theorems passed. Their allowance remains only `propext`; their source files and stored receipts were not rewritten.
- Existing Python suite: all ten tests passed.
- Archive verifier: all 76 anchored files verified byte-for-byte, with 25 answers, nine histories, and 25 audit rows; zero network/API calls in the replay.
- The new receipt records the module SHA-256, the sole imported source SHA-256, toolchain/version, and the exact dependency list for every theorem. CI now runs the third census; these statements report local checks, not an unobserved hosted-CI outcome.

To reproduce the new census without rewriting its stored receipt:

```powershell
.\.venv\Scripts\python.exe scripts/check_primitive_difference.py --module ZeroEquivalence
```

The receipt is a checked source snapshot, not a claim about physical witnessing, publication, a universal minimum, or the legacy projects' full builds.

## Next steps for the three-way discussion

Adversarially review the quantifiers and preservation task in `zero_status_descends_iff_refines`, then the four-case classification and its explicit failure witnesses. Decide whether the loss of exact values and orientation is acceptable for the intended Genesis distinction. Review the failed reverse bridge before proposing further compression of the research DAG.

Torsor formalization, holonomy, cochains, sheaves, numerical residuals, and a general continuation engine remain later slices. Internal acquisition, an invoked judgment, and a registered refusal remain unresolved obligations. No subsequent slice is authorized by completion of this one.
