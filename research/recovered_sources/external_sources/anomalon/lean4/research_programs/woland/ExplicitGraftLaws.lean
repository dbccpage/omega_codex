import ExplicitInputAction

/-!
# Complete graft laws for explicitly reindexed planar trees

AuthorityEffect: None.

The equations below concern the actual tree and external-to-planar permutation
of `ExplicitTree.graft`. Arity transports are explicit. Nullary inserted trees
and repeated colours are allowed. These proofs do not verify Rust compilation,
wire decoding, canonical bytes, executors, or authorization.
-/

namespace Woland.InputAction

universe u v
open PlanarTree

def transportPermutation {n m : Nat} (same : n = m) (order : Permutation n) :
    Permutation m := same ▸ order

theorem transportPermutation_value {n m : Nat} (same : n = m)
    (order : Permutation n) (index : Fin m) :
    ((transportPermutation same order).toFun index).val =
      (order.toFun (Fin.cast same.symm index)).val := by
  cases same
  rfl

theorem transportPermutation_ext {n m : Nat} (same : n = m)
    (first : Permutation n) (second : Permutation m)
    (values : ∀ index, (first.toFun index).val =
      (second.toFun (Fin.cast same index)).val) :
    transportPermutation same first = second := by
  cases same
  exact IndexEquiv.ext _ _ (fun index => Fin.ext (values index))

theorem splice_left_unit {n : Nat} (order : Permutation n) :
    transportPermutation (by unfold replacementSize; omega)
      (splice (IndexEquiv.refl (Fin 1)) order ⟨0, by decide⟩) = order := by
  apply transportPermutation_ext
  intro index
  rw [← flatten_unflatten (slot := (⟨0, by decide⟩ : Fin 1)) index]
  generalize unflatten (⟨0, by decide⟩ : Fin 1) index = occurrence
  cases occurrence with
  | inl external =>
      have h := external.val.isLt
      have ne := external.property
      exact False.elim (ne (Fin.ext (by omega)))
  | inr internal =>
      rw [splice_flatten]
      simp [replacementMap, flatten, IndexEquiv.refl]

theorem splice_right_unit {n : Nat} (order : Permutation n) (slot : Fin n) :
    transportPermutation (by unfold replacementSize; omega)
      (splice order (IndexEquiv.refl (Fin 1)) slot) = order := by
  apply transportPermutation_ext
  intro index
  rw [← flatten_unflatten slot index]
  generalize unflatten slot index = occurrence
  cases occurrence with
  | inl external =>
      rw [splice_flatten]
      simp only [replacementMap, flatten]
      split <;> split <;> simp_all
  | inr internal =>
      rw [splice_flatten]
      simp [replacementMap, flatten, IndexEquiv.refl]

def newSlot {n m : Nat} (slot : Fin n) (inside : Fin m) :
    Fin (replacementSize n m) := flatten slot (.inr inside)

def oldSlot {n m : Nat} (slot index : Fin n) (different : index ≠ slot) :
    Fin (replacementSize n m) := flatten slot (.inl ⟨index, different⟩)

theorem newSlot_val {n m : Nat} (slot : Fin n) (inside : Fin m) :
    (newSlot slot inside).val = slot.val + inside.val := rfl

theorem oldSlot_val {n m : Nat} (slot index : Fin n) (different : index ≠ slot) :
    (oldSlot (m := m) slot index different).val =
      if index.val < slot.val then index.val else index.val + m - 1 := by
  simp only [oldSlot, flatten]
  split <;> rfl

theorem oldSlot_injective {n m : Nat} (slot : Fin n) (a b : Fin n)
    (ha : a ≠ slot) (hb : b ≠ slot)
    (same : oldSlot (m := m) slot a ha = oldSlot slot b hb) : a = b := by
  have eq := (replacementOrder (inner := m) slot).injective
    (first := .inl ⟨a, ha⟩) (second := .inl ⟨b, hb⟩) same
  exact congrArg Subtype.val (Sum.inl.inj eq)

theorem newSlot_injective {n m : Nat} (slot : Fin n) (a b : Fin m)
    (same : newSlot slot a = newSlot slot b) : a = b := by
  exact Sum.inr.inj ((replacementOrder slot).injective same)

theorem oldSlot_ne_newSlot {n m : Nat} (slot index : Fin n) (different : index ≠ slot)
    (inside : Fin m) : oldSlot slot index different ≠ newSlot slot inside := by
  intro same
  have eq := (replacementOrder (inner := m) slot).injective
    (first := .inl ⟨index, different⟩) (second := .inr inside) same
  cases eq

theorem splice_newSlot {n m : Nat} (p : Permutation n) (q : Permutation m)
    (i : Fin n) (j : Fin m) :
    (splice p q i).toFun (newSlot i j) = newSlot (p.toFun i) (q.toFun j) :=
  splice_flatten p q i (.inr j)

theorem splice_oldSlot {n m : Nat} (p : Permutation n) (q : Permutation m)
    (i a : Fin n) (different : a ≠ i) :
    (splice p q i).toFun (oldSlot i a different) =
      oldSlot (p.toFun i) (p.toFun a) (fun eq => different (p.injective eq)) :=
  splice_flatten p q i (.inl ⟨a, different⟩)

abbrev NestedOccurrence {n m : Nat} (i : Fin n) (j : Fin m) (l : Nat) :=
  Sum {a : Fin n // a ≠ i} (Sum {b : Fin m // b ≠ j} (Fin l))

def nestedLeft {n m l : Nat} (i : Fin n) (j : Fin m) :
    NestedOccurrence i j l → Fin (replacementSize (replacementSize n m) l)
  | .inl a => oldSlot (newSlot i j) (oldSlot i a.val a.property)
      (oldSlot_ne_newSlot i a.val a.property j)
  | .inr (.inl b) => oldSlot (newSlot i j) (newSlot i b.val)
      (fun eq => b.property (newSlot_injective i b.val j eq))
  | .inr (.inr c) => newSlot (newSlot i j) c

def nestedRight {n m l : Nat} (i : Fin n) (j : Fin m) :
    NestedOccurrence i j l → Fin (replacementSize n (replacementSize m l))
  | .inl a => oldSlot i a.val a.property
  | .inr (.inl b) => newSlot i (oldSlot j b.val b.property)
  | .inr (.inr c) => newSlot i (newSlot j c)

theorem nested_coordinate {n m l : Nat} (i : Fin n) (j : Fin m)
    (occurrence : NestedOccurrence i j l) :
    (nestedLeft i j occurrence).val = (nestedRight i j occurrence).val := by
  have hi := i.isLt
  have hj := j.isLt
  cases occurrence with
  | inl a =>
      have ha : a.val.val ≠ i.val := fun eq => a.property (Fin.ext eq)
      simp only [nestedLeft, nestedRight]
      rw [oldSlot_val]
      simp only [oldSlot_val, newSlot_val, replacementSize]
      split <;> (try split) <;> (try split) <;> omega
  | inr internal =>
      cases internal with
      | inl b =>
          have hb : b.val.val ≠ j.val := fun eq => b.property (Fin.ext eq)
          simp only [nestedLeft, nestedRight, oldSlot_val, newSlot_val]
          by_cases earlier : b.val.val < j.val
          · simp only [Nat.add_lt_add_iff_left, earlier, ite_true]
          · simp only [Nat.add_lt_add_iff_left, earlier, ite_false]
            omega
      | inr c => simp [nestedLeft, nestedRight, newSlot_val, Nat.add_assoc]

theorem nestedLeft_surjective {n m l : Nat} (i : Fin n) (j : Fin m)
    (index : Fin (replacementSize (replacementSize n m) l)) :
    ∃ occurrence, nestedLeft i j occurrence = index := by
  have recovered := flatten_unflatten (newSlot i j) index
  cases first : unflatten (newSlot i j) index with
  | inr c =>
      rw [first] at recovered
      exact ⟨.inr (.inr c), recovered⟩
  | inl old =>
      rw [first] at recovered
      have old_recovered := flatten_unflatten i old.val
      cases second : unflatten i old.val with
      | inl a =>
          refine ⟨.inl a, ?_⟩
          have old_eq : oldSlot i a.val a.property = old.val := by
            simpa [second, oldSlot] using old_recovered
          change oldSlot _ _ _ = index
          have same : old = ⟨oldSlot i a.val a.property,
              oldSlot_ne_newSlot i a.val a.property j⟩ := Subtype.ext old_eq.symm
          simpa only [same, oldSlot] using recovered
      | inr b =>
          have old_eq : newSlot i b = old.val := by
            simpa [second, newSlot] using old_recovered
          have different : b ≠ j := by
            intro eq
            apply old.property
            rw [← old_eq, eq]
          refine ⟨.inr (.inl ⟨b, different⟩), ?_⟩
          change oldSlot _ _ _ = index
          have same : old = ⟨newSlot i b,
              fun eq => different (newSlot_injective i b j eq)⟩ := Subtype.ext old_eq.symm
          simpa only [same, oldSlot] using recovered

def nestedMap {n m l : Nat} (p : Permutation n) (q : Permutation m) (r : Permutation l)
    (i : Fin n) (j : Fin m) :
    NestedOccurrence i j l → NestedOccurrence (p.toFun i) (q.toFun j) l
  | .inl a => .inl ⟨p.toFun a.val, fun eq => a.property (p.injective eq)⟩
  | .inr (.inl b) => .inr (.inl ⟨q.toFun b.val, fun eq => b.property (q.injective eq)⟩)
  | .inr (.inr c) => .inr (.inr (r.toFun c))

theorem nestedLeft_natural {n m l : Nat}
    (p : Permutation n) (q : Permutation m) (r : Permutation l)
    (i : Fin n) (j : Fin m) (occurrence : NestedOccurrence i j l) :
    (splice (splice p q i) r (newSlot i j)).toFun (nestedLeft i j occurrence) =
      nestedLeft (p.toFun i) (q.toFun j) (nestedMap p q r i j occurrence) := by
  cases occurrence with
  | inl a => simp only [nestedLeft, nestedMap, splice_oldSlot, splice_newSlot]
  | inr internal =>
      cases internal <;> simp only [nestedLeft, nestedMap, splice_oldSlot, splice_newSlot]

theorem nestedRight_natural {n m l : Nat}
    (p : Permutation n) (q : Permutation m) (r : Permutation l)
    (i : Fin n) (j : Fin m) (occurrence : NestedOccurrence i j l) :
    (splice p (splice q r j) i).toFun (nestedRight i j occurrence) =
      nestedRight (p.toFun i) (q.toFun j) (nestedMap p q r i j occurrence) := by
  cases occurrence with
  | inl a => simp only [nestedRight, nestedMap, splice_oldSlot]
  | inr internal =>
      cases internal <;> simp only [nestedRight, nestedMap, splice_oldSlot, splice_newSlot]

theorem nested_size {n m : Nat} (i : Fin n) (j : Fin m) (l : Nat) :
    replacementSize (replacementSize n m) l = replacementSize n (replacementSize m l) := by
  have := i.isLt
  have := j.isLt
  unfold replacementSize
  omega

theorem splice_nested {n m l : Nat}
    (p : Permutation n) (q : Permutation m) (r : Permutation l)
    (i : Fin n) (j : Fin m) :
    transportPermutation (nested_size i j l)
      (splice (splice p q i) r (newSlot i j)) = splice p (splice q r j) i := by
  apply transportPermutation_ext
  intro index
  obtain ⟨occurrence, rfl⟩ := nestedLeft_surjective i j index
  have coord : Fin.cast (nested_size i j l) (nestedLeft i j occurrence) =
      nestedRight i j occurrence := Fin.ext (nested_coordinate i j occurrence)
  rw [coord, nestedLeft_natural, nestedRight_natural]
  exact nested_coordinate (p.toFun i) (q.toFun j) _

theorem oldSlot_lt_oldSlot {n m : Nat} (i a b : Fin n) (ha : a ≠ i) (hb : b ≠ i) :
    (oldSlot (m := m) i a ha).val < (oldSlot (m := m) i b hb).val ↔ a.val < b.val := by
  have ha' : a.val ≠ i.val := fun eq => ha (Fin.ext eq)
  have hb' : b.val ≠ i.val := fun eq => hb (Fin.ext eq)
  simp only [oldSlot_val]
  constructor <;> intro inequality <;> split at * <;> split at * <;> omega

theorem newSlot_lt_oldSlot {n m : Nat} (i a : Fin n) (ha : a ≠ i) (b : Fin m) :
    (newSlot i b).val < (oldSlot (m := m) i a ha).val ↔ i.val < a.val := by
  have ha' : a.val ≠ i.val := fun eq => ha (Fin.ext eq)
  have hb := b.isLt
  simp only [oldSlot_val, newSlot_val]
  constructor <;> intro inequality <;> split at * <;> omega

theorem oldSlot_lt_newSlot {n m : Nat} (i a : Fin n) (ha : a ≠ i) (b : Fin m) :
    (oldSlot (m := m) i a ha).val < (newSlot i b).val ↔ a.val < i.val := by
  have ha' : a.val ≠ i.val := fun eq => ha (Fin.ext eq)
  have hb := b.isLt
  simp only [oldSlot_val, newSlot_val]
  constructor <;> intro inequality <;> split at * <;> omega

abbrev DisjointOccurrence {n : Nat} (i k : Fin n) (m l : Nat) :=
  Sum {a : Fin n // a ≠ i ∧ a ≠ k} (Sum (Fin m) (Fin l))

def disjointLeft {n m l : Nat} (i k : Fin n) (different : k ≠ i) :
    DisjointOccurrence i k m l → Fin (replacementSize (replacementSize n m) l)
  | .inl a => oldSlot (oldSlot i k different) (oldSlot i a.val a.property.1)
      (fun eq => a.property.2 (oldSlot_injective i a.val k a.property.1 different eq))
  | .inr (.inl b) => oldSlot (oldSlot i k different) (newSlot i b)
      (fun eq => oldSlot_ne_newSlot i k different b eq.symm)
  | .inr (.inr c) => newSlot (oldSlot i k different) c

def disjointRight {n m l : Nat} (i k : Fin n) (different : k ≠ i) :
    DisjointOccurrence i k m l → Fin (replacementSize (replacementSize n l) m)
  | .inl a => oldSlot (oldSlot k i (Ne.symm different)) (oldSlot k a.val a.property.2)
      (fun eq => a.property.1 (oldSlot_injective k a.val i a.property.2 (Ne.symm different) eq))
  | .inr (.inl b) => newSlot (oldSlot k i (Ne.symm different)) b
  | .inr (.inr c) => oldSlot (oldSlot k i (Ne.symm different)) (newSlot k c)
      (fun eq => oldSlot_ne_newSlot k i (Ne.symm different) c eq.symm)

theorem disjoint_coordinate {n m l : Nat} (i k : Fin n) (different : k ≠ i)
    (occurrence : DisjointOccurrence i k m l) :
    (disjointLeft i k different occurrence).val =
      (disjointRight i k different occurrence).val := by
  have hik : k.val ≠ i.val := fun eq => different (Fin.ext eq)
  cases occurrence with
  | inl a =>
      have hai : a.val.val ≠ i.val := fun eq => a.property.1 (Fin.ext eq)
      have hak : a.val.val ≠ k.val := fun eq => a.property.2 (Fin.ext eq)
      simp only [disjointLeft, disjointRight]
      rw [oldSlot_val]
      conv => rhs; rw [oldSlot_val]
      simp only [oldSlot_lt_oldSlot]
      simp only [oldSlot_val]
      (repeat' split) <;> omega
  | inr inner =>
      cases inner with
      | inl b =>
          have hb := b.isLt
          simp only [disjointLeft, disjointRight]
          rw [oldSlot_val]
          simp only [newSlot_lt_oldSlot]
          simp only [newSlot_val, oldSlot_val]
          (repeat' split) <;> omega
      | inr c =>
          have hc := c.isLt
          simp only [disjointLeft, disjointRight]
          conv => rhs; rw [oldSlot_val]
          simp only [newSlot_lt_oldSlot]
          simp only [newSlot_val, oldSlot_val]
          (repeat' split) <;> omega

theorem disjointLeft_surjective {n m l : Nat} (i k : Fin n) (different : k ≠ i)
    (index : Fin (replacementSize (replacementSize n m) l)) :
    ∃ occurrence, disjointLeft i k different occurrence = index := by
  have recovered := flatten_unflatten (oldSlot (m := m) i k different) index
  cases first : unflatten (oldSlot (m := m) i k different) index with
  | inr c =>
      rw [first] at recovered
      exact ⟨.inr (.inr c), recovered⟩
  | inl old =>
      rw [first] at recovered
      have old_recovered := flatten_unflatten i old.val
      cases second : unflatten i old.val with
      | inl a =>
          have old_eq : oldSlot i a.val a.property = old.val := by
            simpa [second, oldSlot] using old_recovered
          have not_k : a.val ≠ k := by
            intro eq
            apply old.property
            rw [← old_eq]
            subst k
            rfl
          refine ⟨.inl ⟨a.val, a.property, not_k⟩, ?_⟩
          have same : old = ⟨oldSlot i a.val a.property,
              fun eq => not_k (oldSlot_injective i a.val k a.property different eq)⟩ :=
            Subtype.ext old_eq.symm
          simpa only [same, disjointLeft, oldSlot] using recovered
      | inr b =>
          have old_eq : newSlot i b = old.val := by
            simpa [second, newSlot] using old_recovered
          refine ⟨.inr (.inl b), ?_⟩
          have same : old = ⟨newSlot i b,
              fun eq => oldSlot_ne_newSlot i k different b eq.symm⟩ := Subtype.ext old_eq.symm
          simpa only [same, disjointLeft, oldSlot] using recovered

def disjointMap {n m l : Nat} (p : Permutation n) (q : Permutation m) (r : Permutation l)
    (i k : Fin n) :
    DisjointOccurrence i k m l → DisjointOccurrence (p.toFun i) (p.toFun k) m l
  | .inl a => .inl ⟨p.toFun a.val, (fun eq => a.property.1 (p.injective eq)),
      (fun eq => a.property.2 (p.injective eq))⟩
  | .inr (.inl b) => .inr (.inl (q.toFun b))
  | .inr (.inr c) => .inr (.inr (r.toFun c))

theorem disjointLeft_natural {n m l : Nat}
    (p : Permutation n) (q : Permutation m) (r : Permutation l)
    (i k : Fin n) (different : k ≠ i) (occurrence : DisjointOccurrence i k m l) :
    (splice (splice p q i) r (oldSlot i k different)).toFun
      (disjointLeft i k different occurrence) =
      disjointLeft (p.toFun i) (p.toFun k) (fun eq => different (p.injective eq))
        (disjointMap p q r i k occurrence) := by
  cases occurrence with
  | inl a => simp only [disjointLeft, disjointMap, splice_oldSlot]
  | inr inner =>
      cases inner <;> simp only [disjointLeft, disjointMap, splice_oldSlot, splice_newSlot]

theorem disjointRight_natural {n m l : Nat}
    (p : Permutation n) (q : Permutation m) (r : Permutation l)
    (i k : Fin n) (different : k ≠ i) (occurrence : DisjointOccurrence i k m l) :
    (splice (splice p r k) q (oldSlot k i (Ne.symm different))).toFun
      (disjointRight i k different occurrence) =
      disjointRight (p.toFun i) (p.toFun k) (fun eq => different (p.injective eq))
        (disjointMap p q r i k occurrence) := by
  cases occurrence with
  | inl a => simp only [disjointRight, disjointMap, splice_oldSlot]
  | inr inner =>
      cases inner <;> simp only [disjointRight, disjointMap, splice_oldSlot, splice_newSlot]

theorem disjoint_size {n : Nat} (i k : Fin n) (different : k ≠ i) (m l : Nat) :
    replacementSize (replacementSize n m) l = replacementSize (replacementSize n l) m := by
  have := i.isLt
  have := k.isLt
  have unequal : k.val ≠ i.val := fun eq => different (Fin.ext eq)
  unfold replacementSize
  omega

theorem splice_disjoint {n m l : Nat}
    (p : Permutation n) (q : Permutation m) (r : Permutation l)
    (i k : Fin n) (different : k ≠ i) :
    transportPermutation (disjoint_size i k different m l)
      (splice (splice p q i) r (oldSlot i k different)) =
        splice (splice p r k) q (oldSlot k i (Ne.symm different)) := by
  apply transportPermutation_ext
  intro index
  obtain ⟨occurrence, rfl⟩ := disjointLeft_surjective i k different index
  have coord : Fin.cast (disjoint_size i k different m l) (disjointLeft i k different occurrence) =
      disjointRight i k different occurrence := Fin.ext (disjoint_coordinate i k different occurrence)
  rw [coord, disjointLeft_natural, disjointRight_natural]
  exact disjoint_coordinate (p.toFun i) (p.toFun k) _ _

theorem fork_left_input {Colour : Type u} {Label : Type v}
    (fork : Fork Colour Label) (tree : Tree Colour Label) :
    (fork.leftContext tree).input = fork.left.input := by
  simp [Fork.leftContext, Context.compose_input, Context.input]

theorem fork_right_input {Colour : Type u} {Label : Type v}
    (fork : Fork Colour Label) (tree : Tree Colour Label) :
    (fork.rightContext tree).input = fork.right.input := by
  simp [Fork.rightContext, Context.compose_input, Context.input]

theorem fork_skeleton_shared {Colour : Type u} {Label : Type v}
    (fork : Fork Colour Label) :
    (fork.leftContext (.input fork.right.input)).skeleton =
      (fork.rightContext (.input fork.left.input)).skeleton := by
  have h := fork.disjoint_substitution (.input fork.left.input) (.input fork.right.input)
  rw [← fork_left_input fork (.input fork.right.input), Context.right_identity] at h
  rw [fork_left_input, ← fork_right_input fork (.input fork.left.input), Context.right_identity] at h
  simpa only [fork_right_input] using h

theorem fork_right_skeleton_after_left {Colour : Type u} {Label : Type v}
    (fork : Fork Colour Label) (tree : Tree Colour Label) :
    (fork.rightContext tree).skeleton =
      (fork.leftContext (.input fork.right.input)).fill tree := by
  rw [← Context.right_identity, fork_right_input]
  exact (fork.disjoint_substitution tree (.input fork.right.input)).symm

theorem fork_left_skeleton_after_right {Colour : Type u} {Label : Type v}
    (fork : Fork Colour Label) (tree : Tree Colour Label) :
    (fork.leftContext tree).skeleton =
      (fork.rightContext (.input fork.left.input)).fill tree := by
  rw [← Context.right_identity, fork_left_input]
  exact fork.disjoint_substitution (.input fork.left.input) tree

def liftFork {Colour : Type u} {Label : Type v}
    (context : Context Colour Label) (fork : Fork Colour Label) : Fork Colour Label :=
  { fork with outside := context.compose fork.outside }

theorem liftFork_left {Colour : Type u} {Label : Type v}
    (context : Context Colour Label) (fork : Fork Colour Label) (tree : Tree Colour Label) :
    (liftFork context fork).leftContext tree = context.compose (fork.leftContext tree) := by
  simp only [liftFork, Fork.leftContext, Context.compose_assoc]

theorem liftFork_right {Colour : Type u} {Label : Type v}
    (context : Context Colour Label) (fork : Fork Colour Label) (tree : Tree Colour Label) :
    (liftFork context fork).rightContext tree = context.compose (fork.rightContext tree) := by
  simp only [liftFork, Fork.rightContext, Context.compose_assoc]

mutual
  /-- Any two distinct ordered leaf occurrences have an actual common-branch Fork. -/
  theorem tree_fork {Colour : Type u} {Label : Type v} (tree : Tree Colour Label)
      (i k : Nat) (earlier : i < k) (bound : k < tree.inputs.length) :
      ∃ fork : Fork Colour Label,
        (fork.leftContext (.input fork.right.input)).skeleton = tree ∧
        (fork.leftContext (.input fork.right.input)).index = i ∧
        (fork.rightContext (.input fork.left.input)).index = k := by
    cases tree with
    | input colour =>
        simp only [Tree.inputs, List.length_singleton] at bound
        exact False.elim (by omega)
    | node label children =>
        simpa only [Forest.append, Forest.inputs, List.length_nil, Nat.zero_add] using
          forest_fork children label .nil i k earlier bound

  theorem forest_fork {Colour : Type u} {Label : Type v} (forest : Forest Colour Label)
      (label : Label) (before : Forest Colour Label) (i k : Nat)
      (earlier : i < k) (bound : k < forest.inputs.length) :
      ∃ fork : Fork Colour Label,
        (fork.leftContext (.input fork.right.input)).skeleton = .node label (before.append forest) ∧
        (fork.leftContext (.input fork.right.input)).index = before.inputs.length + i ∧
        (fork.rightContext (.input fork.left.input)).index = before.inputs.length + k := by
    cases forest with
    | nil =>
        simp only [Forest.inputs, List.length_nil] at bound
        exact False.elim (by omega)
    | cons head tail =>
        by_cases both_head : k < head.inputs.length
        · obtain ⟨fork, skeleton, left_index, right_index⟩ := tree_fork head i k earlier both_head
          let context : Context Colour Label := .under label before (.hole fork.left.input) tail
          refine ⟨liftFork context fork, ?_, ?_, ?_⟩
          · change ((liftFork context fork).leftContext (.input fork.right.input)).skeleton = _
            rw [liftFork_left, Context.skeleton_compose, skeleton]
            rfl
          · change ((liftFork context fork).leftContext (.input fork.right.input)).index = _
            rw [liftFork_left, Context.compose_index, left_index]
            simp [context, Context.index, Context.prefix]
          · change ((liftFork context fork).rightContext (.input fork.left.input)).index = _
            rw [liftFork_right, Context.compose_index, right_index]
            simp [context, Context.index, Context.prefix]
        · by_cases first_head : i < head.inputs.length
          · obtain ⟨left, left_selected⟩ := head.select_complete i first_head
            obtain ⟨left_skeleton, left_index⟩ := head.select_correct i left left_selected
            have tail_bound : k - head.inputs.length < tail.inputs.length := by
              simp only [Forest.inputs, List.length_append] at bound
              omega
            obtain ⟨right, right_selected⟩ := tail.select_complete (k - head.inputs.length) tail_bound
            obtain ⟨right_skeleton, right_index⟩ :=
              tail.select_correct (k - head.inputs.length) right right_selected
            let fork : Fork Colour Label :=
              ⟨.hole left.input, label, before, left, right.before, right.inside, right.after⟩
            refine ⟨fork, ?_, ?_, ?_⟩
            · simp only [fork, Fork.leftContext, Context.compose, Context.skeleton,
                Context.right_identity, left_skeleton]
              exact congrArg (fun rest => Tree.node label (before.append (.cons head rest))) right_skeleton
            · rw [Fork.left_index]
              simp only [fork, Context.index, Context.prefix, List.length_nil, Nat.zero_add]
              exact congrArg (before.inputs.length + ·) left_index
            · rw [Fork.right_index]
              simp only [fork, Context.right_identity, left_skeleton,
                Context.index, Context.prefix, List.length_nil, Nat.zero_add]
              simp only [ForestSelection.index, Context.index] at right_index
              omega
          · have tail_earlier : i - head.inputs.length < k - head.inputs.length := by omega
            have tail_bound : k - head.inputs.length < tail.inputs.length := by
              simp only [Forest.inputs, List.length_append] at bound
              omega
            obtain ⟨fork, skeleton, left_index, right_index⟩ :=
              forest_fork tail label (before.append (.cons head .nil))
                (i - head.inputs.length) (k - head.inputs.length) tail_earlier tail_bound
            refine ⟨fork, ?_, ?_, ?_⟩
            · simpa only [Forest.append_assoc, Forest.append] using skeleton
            · simp only [Forest.inputs_append, Forest.inputs, List.length_append,
                List.length_nil, Nat.add_zero] at left_index
              omega
            · simp only [Forest.inputs_append, Forest.inputs, List.length_append,
                List.length_nil, Nat.add_zero] at right_index
              omega
end

namespace ExplicitTree

variable {Colour : Type u} {Label : Type v} {n m : Nat}

def transportArity (same : n = m) (tree : ExplicitTree Colour Label n) :
    ExplicitTree Colour Label m :=
  ⟨tree.tree, tree.input_length.trans same, transportPermutation same tree.order⟩

theorem ext (first second : ExplicitTree Colour Label n)
    (trees : first.tree = second.tree) (orders : first.order = second.order) :
    first = second := by
  cases first
  cases second
  cases trees
  cases orders
  rfl

def unit (colour : Colour) : ExplicitTree Colour Label 1 :=
  ⟨.input colour, rfl, IndexEquiv.refl (Fin 1)⟩

theorem graft_left_unit (colour : Colour) (tree : ExplicitTree Colour Label n) :
    transportArity (by unfold replacementSize; omega)
      ((unit colour).graft tree ⟨0, by decide⟩) = tree := by
  apply ext
  · change ((unit colour).selected ⟨0, by decide⟩).fill tree.tree = tree.tree
    have h := ((unit (Label := Label) colour).selected_correct (⟨0, by decide⟩ : Fin 1)).1
    have eq := Context.eq_hole_of_skeleton_input _ colour h
    rw [eq]
    rfl
  · exact splice_left_unit tree.order

theorem graft_right_unit (tree : ExplicitTree Colour Label n) (slot : Fin n) :
    transportArity (by unfold replacementSize; omega)
      (tree.graft (unit (tree.externalColour slot)) slot) = tree := by
  apply ext
  · change (tree.selected slot).fill (.input (tree.externalColour slot)) = tree.tree
    rw [← tree.selected_colour slot, Context.right_identity]
    exact (tree.selected_correct slot).1
  · exact splice_right_unit tree.order slot

theorem selected_nested (outer : ExplicitTree Colour Label n)
    (inside : ExplicitTree Colour Label m) (i : Fin n) (j : Fin m) :
    (outer.graft inside i).selected (newSlot i j) =
      (outer.selected i).compose (inside.selected j) := by
  apply Context.unique_at_index
  · rw [((outer.graft inside i).selected_correct (newSlot i j)).1,
      Context.skeleton_compose, (inside.selected_correct j).1]
    rfl
  · rw [((outer.graft inside i).selected_correct (newSlot i j)).2,
      Context.compose_index, (outer.selected_correct i).2, (inside.selected_correct j).2]
    change ((splice outer.order inside.order i).toFun (newSlot i j)).val = _
    rw [splice_newSlot]
    rfl

/-- Nested substitution uses the external slot `i+j`, with the full order retained. -/
theorem graft_nested {l : Nat} (outer : ExplicitTree Colour Label n)
    (inside : ExplicitTree Colour Label m) (innermost : ExplicitTree Colour Label l)
    (i : Fin n) (j : Fin m) :
    transportArity (nested_size i j l)
      ((outer.graft inside i).graft innermost (newSlot i j)) =
        outer.graft (inside.graft innermost j) i := by
  apply ext
  · change ((outer.graft inside i).selected (newSlot i j)).fill innermost.tree = _
    rw [selected_nested, Context.fill_compose]
    rfl
  · exact splice_nested outer.order inside.order innermost.order i j

theorem selected_fork_after_left (outer : ExplicitTree Colour Label n)
    (inside : ExplicitTree Colour Label m) (i k : Fin n) (different : k ≠ i)
    (fork : Fork Colour Label)
    (left : outer.selected i = fork.leftContext (.input fork.right.input))
    (right : outer.selected k = fork.rightContext (.input fork.left.input)) :
    (outer.graft inside i).selected (oldSlot i k different) = fork.rightContext inside.tree := by
  have hi := (outer.selected_correct i).2
  have hk := (outer.selected_correct k).2
  rw [left] at hi
  rw [right] at hk
  have precedes := fork.left_precedes_right
  rw [hi, hk] at precedes
  apply Context.unique_at_index
  · rw [((outer.graft inside i).selected_correct (oldSlot i k different)).1,
      fork_right_skeleton_after_left]
    change (outer.selected i).fill inside.tree = _
    rw [left]
  · rw [((outer.graft inside i).selected_correct (oldSlot i k different)).2,
      fork.right_index_reindexed, hk, inside.input_length]
    change ((splice outer.order inside.order i).toFun (oldSlot i k different)).val = _
    rw [splice_oldSlot, oldSlot_val]
    simp only [show ¬ (outer.order.toFun k).val < (outer.order.toFun i).val by omega,
      ite_false]

theorem selected_fork_after_right {l : Nat} (outer : ExplicitTree Colour Label n)
    (inside : ExplicitTree Colour Label l) (i k : Fin n) (different : k ≠ i)
    (fork : Fork Colour Label)
    (left : outer.selected i = fork.leftContext (.input fork.right.input))
    (right : outer.selected k = fork.rightContext (.input fork.left.input)) :
    (outer.graft inside k).selected (oldSlot k i (Ne.symm different)) = fork.leftContext inside.tree := by
  have hi := (outer.selected_correct i).2
  have hk := (outer.selected_correct k).2
  rw [left] at hi
  rw [right] at hk
  have precedes := fork.left_precedes_right
  rw [hi, hk] at precedes
  apply Context.unique_at_index
  · rw [((outer.graft inside k).selected_correct (oldSlot k i (Ne.symm different))).1,
      fork_left_skeleton_after_right]
    change (outer.selected k).fill inside.tree = _
    rw [right]
  · rw [((outer.graft inside k).selected_correct (oldSlot k i (Ne.symm different))).2,
      fork.left_index_unchanged inside.tree (.input fork.right.input), hi]
    change ((splice outer.order inside.order k).toFun (oldSlot k i (Ne.symm different))).val = _
    rw [splice_oldSlot, oldSlot_val]
    simp only [precedes, ite_true]

theorem graft_tree_disjoint_of_fork {l : Nat} (outer : ExplicitTree Colour Label n)
    (first : ExplicitTree Colour Label m) (second : ExplicitTree Colour Label l)
    (i k : Fin n) (different : k ≠ i) (fork : Fork Colour Label)
    (left : outer.selected i = fork.leftContext (.input fork.right.input))
    (right : outer.selected k = fork.rightContext (.input fork.left.input)) :
    ((outer.graft first i).graft second (oldSlot i k different)).tree =
      ((outer.graft second k).graft first (oldSlot k i (Ne.symm different))).tree := by
  change ((outer.graft first i).selected (oldSlot i k different)).fill second.tree =
      ((outer.graft second k).selected (oldSlot k i (Ne.symm different))).fill first.tree
  rw [selected_fork_after_left outer first i k different fork left right,
      selected_fork_after_right outer second i k different fork left right]
  exact (fork.disjoint_substitution first.tree second.tree).symm

theorem selected_fork (outer : ExplicitTree Colour Label n) (i k : Fin n)
    (earlier : (outer.order.toFun i).val < (outer.order.toFun k).val) :
    ∃ fork : Fork Colour Label,
      outer.selected i = fork.leftContext (.input fork.right.input) ∧
      outer.selected k = fork.rightContext (.input fork.left.input) := by
  have bound : (outer.order.toFun k).val < outer.tree.inputs.length := by
    rw [outer.input_length]
    exact (outer.order.toFun k).isLt
  obtain ⟨fork, skeleton, left_index, right_index⟩ :=
    tree_fork outer.tree (outer.order.toFun i).val (outer.order.toFun k).val earlier bound
  refine ⟨fork, ?_, ?_⟩
  · exact Context.unique_at_index _ _
      ((outer.selected_correct i).1.trans skeleton.symm)
      ((outer.selected_correct i).2.trans left_index.symm)
  · have right_skeleton := (fork_skeleton_shared fork).symm.trans skeleton
    exact Context.unique_at_index _ _
      ((outer.selected_correct k).1.trans right_skeleton.symm)
      ((outer.selected_correct k).2.trans right_index.symm)

theorem graft_tree_disjoint {l : Nat} (outer : ExplicitTree Colour Label n)
    (first : ExplicitTree Colour Label m) (second : ExplicitTree Colour Label l)
    (i k : Fin n) (different : k ≠ i) :
    ((outer.graft first i).graft second (oldSlot i k different)).tree =
      ((outer.graft second k).graft first (oldSlot k i (Ne.symm different))).tree := by
  have distinct : (outer.order.toFun k).val ≠ (outer.order.toFun i).val :=
    fun eq => different (outer.order.injective (Fin.ext eq))
  by_cases earlier : (outer.order.toFun i).val < (outer.order.toFun k).val
  · obtain ⟨fork, left, right⟩ := outer.selected_fork i k earlier
    exact graft_tree_disjoint_of_fork outer first second i k different fork left right
  · have reversed : (outer.order.toFun k).val < (outer.order.toFun i).val := by omega
    obtain ⟨fork, left, right⟩ := outer.selected_fork k i reversed
    exact (graft_tree_disjoint_of_fork outer second first k i (Ne.symm different) fork left right).symm

/-- Complete disjoint interchange, independent of the planar order selected by the permutation. -/
theorem graft_disjoint {l : Nat} (outer : ExplicitTree Colour Label n)
    (first : ExplicitTree Colour Label m) (second : ExplicitTree Colour Label l)
    (i k : Fin n) (different : k ≠ i) :
    transportArity (disjoint_size i k different m l)
      ((outer.graft first i).graft second (oldSlot i k different)) =
        (outer.graft second k).graft first (oldSlot k i (Ne.symm different)) := by
  apply ext
  · exact graft_tree_disjoint outer first second i k different
  · exact splice_disjoint outer.order first.order second.order i k different

def laterSlot {n : Nat} (i k : Fin n) (m : Nat) (earlier : i.val < k.val) :
    Fin (replacementSize n m) :=
  ⟨k.val + m - 1, by have := k.isLt; unfold replacementSize; omega⟩

def earlierSlot {n : Nat} (i k : Fin n) (l : Nat) (earlier : i.val < k.val) :
    Fin (replacementSize n l) :=
  ⟨i.val, by have := k.isLt; unfold replacementSize; omega⟩

/-- For `i < k`, the later slot is `k+m-1`; the earlier slot remains `i`. -/
theorem graft_disjoint_ordered {l : Nat} (outer : ExplicitTree Colour Label n)
    (first : ExplicitTree Colour Label m) (second : ExplicitTree Colour Label l)
    (i k : Fin n) (earlier : i.val < k.val) :
    transportArity (disjoint_size i k (fun eq => by
        have := congrArg Fin.val eq; omega) m l)
      ((outer.graft first i).graft second (laterSlot i k m earlier)) =
        (outer.graft second k).graft first (earlierSlot i k l earlier) := by
  have different : k ≠ i := fun eq => by have := congrArg Fin.val eq; omega
  have later_eq : laterSlot i k m earlier = oldSlot i k different := by
    apply Fin.ext
    rw [oldSlot_val]
    simp only [show ¬ k.val < i.val by omega, ite_false]
    rfl
  have earlier_eq : earlierSlot i k l earlier = oldSlot k i (Ne.symm different) := by
    apply Fin.ext
    rw [oldSlot_val]
    simp only [earlier, ite_true]
    rfl
  rw [later_eq, earlier_eq]
  exact graft_disjoint outer first second i k different

end ExplicitTree

#print axioms tree_fork
#print axioms splice_left_unit
#print axioms splice_right_unit
#print axioms splice_nested
#print axioms splice_disjoint
#print axioms ExplicitTree.graft_left_unit
#print axioms ExplicitTree.graft_right_unit
#print axioms ExplicitTree.graft_nested
#print axioms ExplicitTree.graft_disjoint
#print axioms ExplicitTree.graft_disjoint_ordered
end Woland.InputAction
