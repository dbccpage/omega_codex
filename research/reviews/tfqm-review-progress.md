# TFQM Lean review: source screening and selected findings

This is an **incomplete review**. The accompanying `tfqm_lean_inventory.json` records all 1,479 Lean files in the requested scope, with hashes, imports and a lexical declaration inventory. That scan reads source bytes but is not a substantive review of every theorem or proof. Its declaration locations are approximate: the regular expression can include leading blank lines. Its candidate `admit` tokens also match ordinary identifiers such as `Kernel.admit`; they are not verified placeholders. No build, axiom census, or proof audit has been performed.

Source checkout: `C:/Users/a343o/source/repos/theory_of_finite_quantum_mechanics`, recorded HEAD `e45ed2e133920aa3790af8c5e072ee9829898490`. Working-tree bytes were hashed; their equality to HEAD has not been checked. Scope: `atlas/finite_obstruction_calculus` except `witnessed_difference_programme`, plus all `lean4` files, including imported copies of witnessed-difference modules, because the latter tree was requested in full.

## Genesis ongoing stages: reviewed source boundaries

- The first `H3V7N5QF` seed supplies terms, an asserted relation, a given ordered pair and a no-loop legality rule. `Answers.lean` constructs removal and build paths in that change system and a lower bound relative to the stated task and permitted changes. These are not a universal remove-or-build law.
- Fourth and fifth introduce multiplicities and, in the fifth, explicit removal and identification. `Fifth/Answers.lean:106` proves a three-way persistence result for a `Step5` transition and a well-formed state. The removal result at line 177 uses the declared `Reach5` rules and named endpoints.
- Sixth explicitly drops the loop prohibition and its obstruction paragraph. Seventh supplies an empty initial state. Eighth adds a second relation; ninth combines two relations with an empty beginning. These are alternative specified systems; the additional relation is not derived from bare difference.
- Tenth through fifteenth explore distinct supplied readings of leftovers, writings, identification records, coarser writings and admission records. Sixteenth makes a recorded leftover eligible for a declared admission. They should not be conflated with each other or with performed witnessing.
- Seventeenth makes loop-freeness a predicate rather than a given and compares outcomes when a previously obstructed change is allowed. Eighteenth through twenty-first address chosen writings, partial identification, ordered changes and refusal, each against its own declared reading.
- Twentysecond re-encodes states using finite lists of relation-tagged atoms and proves scoped sameness, reachability and cost statements. Twentythird changes the sameness criterion and studies minimum-assertion representatives; its `Fewest.lean` includes a four-term counterexample to a proposed local method. Twentyfourth supplies filled terms; twentyfifth supplies filled triples. Their map files study exactly what these declared representations preserve or forget, not an unconditional emergence of filling.

These summaries reflect selected stage headers and representative declarations, not a line-by-line check of every stage file. Stage variants and unresolved claims remain in the inventory for further review.

## Additional top-level findings

- `lean4/AdmissionFloor.lean` defines an exhibited cut with a carrier, relation, endpoints, relatedness and irreflexivity. Its `cut_exists_iff_nontrivial` is conditional on that formal task, and its countermodels separate the presence of a relation from the no-loop law.
- `lean4/GenesisHottShadow.lean` explicitly supplies a regime with cardinality, form arities, tuples, rules and required pairs. Its introduction says it does not obtain simplicial or globular face data from that regime, or prove the determination claim.
- `lean4/InertDiamond.lean` supplies a token type, state, event alphabet and step rules. Supply is inert by the defined step rule; the file explicitly exhibits a rival rule. It does not prove inertness from the inscription itself.
- `lean4/CochainObstruction.lean` distinguishes caller-supplied contract certificates from an explicit triangle instance. Some contract-field negation hypotheses can be unsatisfiable; the file itself warns that such firewall results need not provide mathematical content. The triangle result is scoped to the stated complex.
- `lean4/InterferenceNonDescent.lean` supplies Gaussian-integer vectors, a phase-blind map and a mixing operation. It states a finite no-factorization result for that specified readout; it does not derive physical quantum mechanics.
- `lean4/OntologyBasic.lean` defines a difference package from source and target sorts and a binary delta, while its structure package has a carrier and proposition-valued fields. `OntologyPrimitiveBridge.lean` accepts descent propositions as inputs. Names and authority status do not establish those propositions or derive the packages from a primitive.

## Imported copies

207 imported files record original SHA-256 values matching files in the included atlas tree. After removing the import wrapper and import lines and normalizing line endings, 205 bodies match their recorded atlas source. Two do not: `Imported/GenesisDerivation/Derivation/PrimitiveContact.lean` changes comment paths; `Imported/GenesisOngoing/Second/Rename.lean` changes proof text. This comparison does not validate the modified proofs or establish equivalence across changed imports.

## Remaining work

The full proof-level review of the 1,479 files, including the 769 top-level TFQM modules and the remaining stage declarations, is outstanding. The lexical index is a navigation aid and does not discharge that work. In particular, apparent theorem names, placeholder tokens, supplied `Prop` fields, and historical status strings need source-context inspection before any claim is promoted.

Subsequent source-level reviews are in `tfqm-proof-review-repair-lift.md`, `tfqm-proof-review-fibers-l1.md`, and `tfqm-proof-review-growth-demand.md`. `tfqm-proof-review-status.json` maps the 35 files covered by those reports and explicitly marks the other 1,444 as not yet proof-reviewed in that tracked pass. This conservative status does not erase earlier spot inspections.
