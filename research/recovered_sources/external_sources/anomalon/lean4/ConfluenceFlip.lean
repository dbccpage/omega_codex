/-!
# Confluence Flip Mechanization: ADV_QM Hypothesis 12

Formal, Mathlib-compatible mechanization of the critical peak confluence flip
arising in the Symbol Game term-rewriting substrate (Paper 043, Block H / review_runs_20260901).

## Background

Consider the three-character start string `s = [a, b, c]` over an alphabet with `a ≠ c`.

1. **Original Presentation** `R`:
   - `r₁ : [a, b] ↦ [c]`
   - `r₂ : [b, c] ↦ [a]`
   At index 0, `r₁` reduces `s` to `[c, c]`.
   At index 1, `r₂` reduces `s` to `[a, a]`.
   Both `[c, c]` and `[a, a]` contain neither `[a, b]` nor `[b, c]`, hence both are
   normal forms (`IsNF`). Since `a ≠ c`, `[c, c] ≠ [a, a]`.
   Therefore, the critical peak is strictly non-joinable, and `R` is non-confluent.

2. **The ADV_QM H12 Killing Mutation** `R''`:
   - `r₁'' : [a, b] ↦ [a]`
   - `r₂'' : [b, c] ↦ [c]`
   At index 0, `r₁''` reduces `s` to `[a, c]`.
   At index 1, `r₂''` reduces `s` to `[a, c]`.
   Both branches land on the exact same word `[a, c]`, which is in normal form.
   The critical peak is joinable in 1 step, flipping the verdict from
   non-confluent to confluent.

AuthorityEffect: None.
-/

namespace SymbolGame.ConfluenceFlip

/-- Three-symbol alphabet for the canonical critical peak. -/
inductive Symbol where
  | a : Symbol
  | b : Symbol
  | c : Symbol
  deriving DecidableEq, Repr

open Symbol

theorem a_ne_c : a ≠ c := by
  intro h
  cases h

theorem a_ne_b : a ≠ b := by
  intro h
  cases h

theorem b_ne_c : b ≠ c := by
  intro h
  cases h

/-- Words are finite lists of symbols. -/
abbrev Word := List Symbol

/-- The canonical start word `abc`. -/
def s : Word := [a, b, c]

/-- A rewrite rule specifies a left-hand side and right-hand side pattern. -/
structure Rule (α : Type) where
  lhs : List α
  rhs : List α
  deriving DecidableEq, Repr

/-- Redex application at an exact 0-based character index.
    Substitutes `lhs` with `rhs` if and only if `r.lhs` is a prefix of `w.drop pos`. -/
def applyAt {α : Type} [DecidableEq α] (w : List α) (pos : Nat) (r : Rule α) : Option (List α) :=
  let prefixPart := w.take pos
  let rest := w.drop pos
  if r.lhs.isPrefixOf rest then
    some (prefixPart ++ r.rhs ++ rest.drop r.lhs.length)
  else
    none

/-- Inductive step relation: `w₁ ⟶ w₂` under rule set `R` via an explicit redex at `pos`. -/
inductive RedexStep {α : Type} [DecidableEq α] (R : List (Rule α)) : List α → Nat → Rule α → List α → Prop where
  | step (w : List α) (pos : Nat) (r : Rule α) (w' : List α)
      (hr : r ∈ R)
      (happ : applyAt w pos r = some w') : RedexStep R w pos r w'

/-- Un-indexed one-step transition relation under rule set `R`. -/
def Step {α : Type} [DecidableEq α] (R : List (Rule α)) (w w' : List α) : Prop :=
  ∃ pos r, RedexStep R w pos r w'

/-- Reflexive transitive closure of the rewrite relation. -/
inductive StarStep {α : Type} [DecidableEq α] (R : List (Rule α)) : List α → List α → Prop where
  | refl (w : List α) : StarStep R w w
  | tail {w₁ w₂ w₃ : List α} : StarStep R w₁ w₂ → Step R w₂ w₃ → StarStep R w₁ w₃

/-- Normal form predicate: no redex can be applied anywhere in the word. -/
def IsNF {α : Type} [DecidableEq α] (R : List (Rule α)) (w : List α) : Prop :=
  ∀ w', ¬ Step R w w'

/-- A critical peak `(w₁, w₂)` originating from `w` is joinable if both branches
    can reach a common descendant. -/
def Joinable {α : Type} [DecidableEq α] (R : List (Rule α)) (w₁ w₂ : List α) : Prop :=
  ∃ w, StarStep R w₁ w ∧ StarStep R w₂ w

theorem drop_nil {α : Type} (n : Nat) : ([] : List α).drop n = [] := by
  cases n <;> rfl

theorem drop_two_elem {α : Type} (x y : α) (n : Nat) : [x, y].drop (n + 2) = [] := by
  change [].drop n = []
  exact drop_nil n

theorem applyAt_of_drop_nil {α : Type} [DecidableEq α] (w : List α) (pos : Nat)
    (hdrop : w.drop pos = []) (x : α) (xs rhs : List α) :
    applyAt w pos ⟨x :: xs, rhs⟩ = none := by
  unfold applyAt
  rw [hdrop]
  rfl

/-! ### 1. Original Non-Confluent Presentation R -/

def r1 : Rule Symbol := ⟨[a, b], [c]⟩
def r2 : Rule Symbol := ⟨[b, c], [a]⟩

def R_orig : List (Rule Symbol) := [r1, r2]

/-- Branch 1 of R: `abc ⟶ [c, c]` at redex position 0. -/
theorem r_orig_branch1 : applyAt s 0 r1 = some [c, c] := by
  rfl

/-- Branch 2 of R: `abc ⟶ [a, a]` at redex position 1. -/
theorem r_orig_branch2 : applyAt s 1 r2 = some [a, a] := by
  rfl

theorem step_r_orig_branch1 : RedexStep R_orig s 0 r1 [c, c] := by
  apply RedexStep.step
  · simp [R_orig]
  · rfl

theorem step_r_orig_branch2 : RedexStep R_orig s 1 r2 [a, a] := by
  apply RedexStep.step
  · simp [R_orig]
  · rfl

/-- Helper: `applyAt [c, c] pos r = none` for any `r ∈ R_orig`. -/
theorem applyAt_cc_none (pos : Nat) (r : Rule Symbol) (hr : r ∈ R_orig) :
    applyAt [c, c] pos r = none := by
  simp [R_orig] at hr
  cases hr with
  | inl h1 =>
    subst h1
    cases pos with
    | zero => rfl
    | succ pos' =>
      cases pos' with
      | zero => rfl
      | succ pos'' =>
        exact applyAt_of_drop_nil [c, c] (pos'' + 2) (drop_two_elem c c pos'') a [b] [c]
  | inr h2 =>
    subst h2
    cases pos with
    | zero => rfl
    | succ pos' =>
      cases pos' with
      | zero => rfl
      | succ pos'' =>
        exact applyAt_of_drop_nil [c, c] (pos'' + 2) (drop_two_elem c c pos'') b [c] [a]

/-- `[c, c]` is irreducible under `R_orig`. -/
theorem cc_is_nf_orig : IsNF R_orig [c, c] := by
  intro w' ⟨pos, r, RedexStep.step _ _ _ _ hr happ⟩
  have hnone := applyAt_cc_none pos r hr
  rw [hnone] at happ
  contradiction

/-- Helper: `applyAt [a, a] pos r = none` for any `r ∈ R_orig`. -/
theorem applyAt_aa_none (pos : Nat) (r : Rule Symbol) (hr : r ∈ R_orig) :
    applyAt [a, a] pos r = none := by
  simp [R_orig] at hr
  cases hr with
  | inl h1 =>
    subst h1
    cases pos with
    | zero => rfl
    | succ pos' =>
      cases pos' with
      | zero => rfl
      | succ pos'' =>
        exact applyAt_of_drop_nil [a, a] (pos'' + 2) (drop_two_elem a a pos'') a [b] [c]
  | inr h2 =>
    subst h2
    cases pos with
    | zero => rfl
    | succ pos' =>
      cases pos' with
      | zero => rfl
      | succ pos'' =>
        exact applyAt_of_drop_nil [a, a] (pos'' + 2) (drop_two_elem a a pos'') b [c] [a]

/-- `[a, a]` is irreducible under `R_orig`. -/
theorem aa_is_nf_orig : IsNF R_orig [a, a] := by
  intro w' ⟨pos, r, RedexStep.step _ _ _ _ hr happ⟩
  have hnone := applyAt_aa_none pos r hr
  rw [hnone] at happ
  contradiction

/-- The two normal forms are distinct because `c ≠ a`. -/
theorem cc_ne_aa : ([c, c] : Word) ≠ [a, a] := by
  intro h
  injection h with h1 _
  exact a_ne_c h1.symm

/-- Any star-reduction from a normal form stays at the normal form. -/
theorem starStep_from_nf {α : Type} [DecidableEq α] {R : List (Rule α)} {w w' : List α}
    (hnf : IsNF R w) (hstar : StarStep R w w') : w' = w := by
  induction hstar with
  | refl => rfl
  | tail hprev hstep ih =>
    have heq : _ = w := ih
    subst heq
    exfalso
    exact hnf _ hstep

/-- Formal proof that the critical peak of R_orig is NOT joinable. -/
theorem r_orig_not_joinable : ¬ Joinable R_orig [c, c] [a, a] := by
  intro ⟨w, h1, h2⟩
  have hw1 := starStep_from_nf cc_is_nf_orig h1
  have hw2 := starStep_from_nf aa_is_nf_orig h2
  have h_eq : ([c, c] : Word) = [a, a] := hw1.symm.trans hw2
  exact cc_ne_aa h_eq

/-! ### 2. The ADV_QM H12 Killing Mutation R'' -/

def r1_mut : Rule Symbol := ⟨[a, b], [a]⟩
def r2_mut : Rule Symbol := ⟨[b, c], [c]⟩

def R_mut : List (Rule Symbol) := [r1_mut, r2_mut]

/-- Branch 1 of R'': `abc ⟶ [a, c]` at redex position 0. -/
theorem r_mut_branch1 : applyAt s 0 r1_mut = some [a, c] := by
  rfl

/-- Branch 2 of R'': `abc ⟶ [a, c]` at redex position 1. -/
theorem r_mut_branch2 : applyAt s 1 r2_mut = some [a, c] := by
  rfl

theorem step_r_mut_branch1 : RedexStep R_mut s 0 r1_mut [a, c] := by
  apply RedexStep.step
  · simp [R_mut]
  · rfl

theorem step_r_mut_branch2 : RedexStep R_mut s 1 r2_mut [a, c] := by
  apply RedexStep.step
  · simp [R_mut]
  · rfl

/-- Helper: `applyAt [a, c] pos r = none` for any `r ∈ R_mut`. -/
theorem applyAt_ac_none (pos : Nat) (r : Rule Symbol) (hr : r ∈ R_mut) :
    applyAt [a, c] pos r = none := by
  simp [R_mut] at hr
  cases hr with
  | inl h1 =>
    subst h1
    cases pos with
    | zero => rfl
    | succ pos' =>
      cases pos' with
      | zero => rfl
      | succ pos'' =>
        exact applyAt_of_drop_nil [a, c] (pos'' + 2) (drop_two_elem a c pos'') a [b] [a]
  | inr h2 =>
    subst h2
    cases pos with
    | zero => rfl
    | succ pos' =>
      cases pos' with
      | zero => rfl
      | succ pos'' =>
        exact applyAt_of_drop_nil [a, c] (pos'' + 2) (drop_two_elem a c pos'') b [c] [c]

/-- `[a, c]` is irreducible under `R_mut`. -/
theorem ac_is_nf_mut : IsNF R_mut [a, c] := by
  intro w' ⟨pos, r, RedexStep.step _ _ _ _ hr happ⟩
  have hnone := applyAt_ac_none pos r hr
  rw [hnone] at happ
  contradiction

/-- Formal proof that the critical peak of R_mut IS joinable (lands on [a, c]). -/
theorem r_mut_joinable : Joinable R_mut [a, c] [a, c] := by
  exact ⟨[a, c], StarStep.refl [a, c], StarStep.refl [a, c]⟩

/-- The Critical Peak Confluence Flip Theorem:
    The original presentation R_orig admits a non-joinable critical peak,
    while the ADV_QM H12 mutated presentation R_mut joins immediately at [a, c]. -/
theorem adv_qm_h12_confluence_flip :
    (¬ Joinable R_orig [c, c] [a, a]) ∧
    (applyAt s 0 r1_mut = some [a, c]) ∧
    (applyAt s 1 r2_mut = some [a, c]) ∧
    (Joinable R_mut [a, c] [a, c]) ∧
    (IsNF R_mut [a, c]) := by
  refine ⟨r_orig_not_joinable, r_mut_branch1, r_mut_branch2, r_mut_joinable, ac_is_nf_mut⟩

/-- The Confluence Flip Diamond Theorem:
    The critical peak from `s = [a, b, c]` joins under the mutated rule set R_mut at normal form `[a, c]`. -/
theorem confluence_flip_diamond : Joinable R_mut [a, c] [a, c] :=
  r_mut_joinable

#print axioms adv_qm_h12_confluence_flip
#print axioms confluence_flip_diamond

end SymbolGame.ConfluenceFlip
