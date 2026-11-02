import PrimitiveDifference

/-!
Zero-equivalence and specified descent, reconstructed using Lean core.
The carrier, values, equality, equivalence laws, and preservation target are
explicit inputs. No endpoint, representative selector, or evaluator is supplied.
-/
set_option autoImplicit false

namespace OmegaCodex.ZeroEquivalence

universe u v w z

structure Kernel (α : Type u) (β : Type v) where
  δ : α → α → β
  Zero : β → Prop
  zero_refl : ∀ x, Zero (δ x x)
  zero_symm : ∀ x y, Zero (δ x y) → Zero (δ y x)
  zero_trans : ∀ x y z, Zero (δ x y) → Zero (δ y z) → Zero (δ x z)

variable {α : Type u} {β : Type v} {γ : Type w} {η : Type z}

def ZeroRel (K : Kernel α β) (x y : α) : Prop := K.Zero (K.δ x y)

def zeroSetoid (K : Kernel α β) : Setoid α where
  r := ZeroRel K
  iseqv := ⟨K.zero_refl, K.zero_symm _ _, K.zero_trans _ _ _⟩

def ResidualQuotient (K : Kernel α β) : Type u := Quotient (zeroSetoid K)

def classOf (K : Kernel α β) (x : α) : ResidualQuotient K :=
  Quotient.mk (zeroSetoid K) x

def Nonzero (K : Kernel α β) (x y : α) : Prop := ¬ ZeroRel K x y

theorem zeroRel_equivalence (K : Kernel α β) : Equivalence (ZeroRel K) :=
  (zeroSetoid K).iseqv

theorem nonzero_irrefl (K : Kernel α β) :
    OmegaCodex.PrimitiveDifference.Irrefl (Nonzero K) :=
  fun x h => h (K.zero_refl x)

theorem nonzero_symm (K : Kernel α β) {x y : α} :
    Nonzero K x y → Nonzero K y x :=
  fun h h' => h (K.zero_symm y x h')

theorem nonzero_implies_ne (K : Kernel α β) {x y : α}
    (h : Nonzero K x y) : x ≠ y :=
  OmegaCodex.PrimitiveDifference.irrefl_witness_ne (nonzero_irrefl K) h

theorem classOf_eq_iff_zeroRel (K : Kernel α β) (x y : α) :
    classOf K x = classOf K y ↔ ZeroRel K x y :=
  ⟨fun h => Quotient.exact h, fun h => Quotient.sound (s := zeroSetoid K) h⟩

theorem nonzero_iff_classes_ne (K : Kernel α β) (x y : α) :
    Nonzero K x y ↔ classOf K x ≠ classOf K y := by
  constructor
  · intro h he
    exact h ((classOf_eq_iff_zeroRel K x y).mp he)
  · intro h he
    exact h ((classOf_eq_iff_zeroRel K x y).mpr he)

theorem exists_nonzero_iff_distinct_classes (K : Kernel α β) :
    (∃ x y, Nonzero K x y) ↔
      ∃ q r : ResidualQuotient K, q ≠ r := by
  constructor
  · rintro ⟨x, y, h⟩
    exact ⟨classOf K x, classOf K y, (nonzero_iff_classes_ne K x y).mp h⟩
  · rintro ⟨q, r, h⟩
    revert h
    refine Quotient.inductionOn₂ q r ?_
    intro x y h
    exact ⟨x, y, (nonzero_iff_classes_ne K x y).mpr h⟩

theorem quotient_subsingleton_iff (K : Kernel α β) :
    Subsingleton (ResidualQuotient K) ↔ ∀ x y, ZeroRel K x y := by
  constructor
  · intro h x y
    exact (classOf_eq_iff_zeroRel K x y).mp (h.elim _ _)
  · intro h
    constructor
    intro q r
    refine Quotient.inductionOn₂ q r ?_
    intro x y
    exact Quotient.sound (h x y)

/-- Equality, rather than only logical equivalence, of a specified readout. -/
def UnaryCongruent (S : Setoid α) (φ : α → γ) : Prop :=
  ∀ x y, S.r x y → φ x = φ y

def UnaryDescends (S : Setoid α) (φ : α → γ) : Prop :=
  ∃ F : Quotient S → γ, ∀ x, F (Quotient.mk S x) = φ x

def unaryFactor (S : Setoid α) (φ : α → γ) (h : UnaryCongruent S φ) :
    Quotient S → γ := Quotient.lift φ h

theorem unaryFactor_mk (S : Setoid α) (φ : α → γ)
    (h : UnaryCongruent S φ) (x : α) :
    unaryFactor S φ h (Quotient.mk S x) = φ x := rfl

theorem unary_descends_iff (S : Setoid α) (φ : α → γ) :
    UnaryDescends S φ ↔ UnaryCongruent S φ := by
  constructor
  · rintro ⟨F, hF⟩ x y hxy
    calc
      φ x = F (Quotient.mk S x) := (hF x).symm
      _ = F (Quotient.mk S y) := congrArg F (Quotient.sound hxy)
      _ = φ y := hF y
  · intro h
    exact ⟨unaryFactor S φ h, unaryFactor_mk S φ h⟩

theorem unaryFactor_unique (S : Setoid α) (φ : α → γ)
    (h : UnaryCongruent S φ) (F : Quotient S → γ)
    (hF : ∀ x, F (Quotient.mk S x) = φ x) : F = unaryFactor S φ h := by
  funext q
  refine Quotient.inductionOn q ?_
  exact hF

theorem unary_no_factor_of_witness (S : Setoid α) (φ : α → γ)
    {x y : α} (hxy : S.r x y) (hne : φ x ≠ φ y) : ¬ UnaryDescends S φ :=
  fun h => hne ((unary_descends_iff S φ).mp h x y hxy)

def BinaryCongruent (S : Setoid α) (d : α → α → β) : Prop :=
  ∀ x x' y y', S.r x x' → S.r y y' → d x y = d x' y'

def BinaryDescends (S : Setoid α) (d : α → α → β) : Prop :=
  ∃ F : Quotient S → Quotient S → β,
    ∀ x y, F (Quotient.mk S x) (Quotient.mk S y) = d x y

def binaryFactor (S : Setoid α) (d : α → α → β) (h : BinaryCongruent S d) :
    Quotient S → Quotient S → β :=
  Quotient.lift₂ (s₁ := S) (s₂ := S) d
    (by intro x y x' y' hx hy; exact h x x' y y' hx hy)

theorem binaryFactor_mk (S : Setoid α) (d : α → α → β)
    (h : BinaryCongruent S d) (x y : α) :
    binaryFactor S d h (Quotient.mk S x) (Quotient.mk S y) = d x y := rfl

theorem binary_descends_iff (S : Setoid α) (d : α → α → β) :
    BinaryDescends S d ↔ BinaryCongruent S d := by
  constructor
  · rintro ⟨F, hF⟩ x x' y y' hx hy
    calc
      d x y = F (Quotient.mk S x) (Quotient.mk S y) := (hF x y).symm
      _ = F (Quotient.mk S x') (Quotient.mk S y') := by
        rw [Quotient.sound hx, Quotient.sound hy]
      _ = d x' y' := hF x' y'
  · intro h
    exact ⟨binaryFactor S d h, binaryFactor_mk S d h⟩

theorem binaryFactor_unique (S : Setoid α) (d : α → α → β)
    (h : BinaryCongruent S d) (F : Quotient S → Quotient S → β)
    (hF : ∀ x y, F (Quotient.mk S x) (Quotient.mk S y) = d x y) :
    F = binaryFactor S d h := by
  funext q r
  refine Quotient.inductionOn₂ q r ?_
  exact hF

theorem binary_no_factor_of_witness (S : Setoid α) (d : α → α → β)
    {x x' y y' : α} (hx : S.r x x') (hy : S.r y y')
    (hne : d x y ≠ d x' y') : ¬ BinaryDescends S d :=
  fun h => hne ((binary_descends_iff S d).mp h x x' y y' hx hy)

/-- Prop equality expresses identical zero-status, using propositional extensionality. -/
def ZeroStatusDescends (K : Kernel α β) (S : Setoid α) : Prop :=
  BinaryDescends S (ZeroRel K)

def RefinesZero (K : Kernel α β) (S : Setoid α) : Prop :=
  ∀ x y, S.r x y → ZeroRel K x y

theorem zero_status_descends_iff_refines (K : Kernel α β) (S : Setoid α) :
    ZeroStatusDescends K S ↔ RefinesZero K S := by
  rw [ZeroStatusDescends, binary_descends_iff]
  constructor
  · intro h x y hxy
    have he : ZeroRel K x x = ZeroRel K x y := h x x x y (S.refl x) hxy
    exact he ▸ K.zero_refl x
  · intro h x x' y y' hx hy
    apply propext
    constructor
    · intro hxy
      exact K.zero_trans x' y y'
        (K.zero_trans x' x y (K.zero_symm x x' (h x x' hx)) hxy) (h y y' hy)
    · intro hxy
      exact K.zero_trans x y' y
        (K.zero_trans x x' y' (h x x' hx) hxy) (K.zero_symm y y' (h y y' hy))

theorem zero_status_descends_own (K : Kernel α β) :
    ZeroStatusDescends K (zeroSetoid K) :=
  (zero_status_descends_iff_refines K (zeroSetoid K)).mpr (fun _ _ h => h)

def DeltaCongruent (K : Kernel α β) : Prop := BinaryCongruent (zeroSetoid K) K.δ

theorem deltaFactor_exists_iff_deltaCongruent (K : Kernel α β) :
    BinaryDescends (zeroSetoid K) K.δ ↔ DeltaCongruent K :=
  binary_descends_iff (zeroSetoid K) K.δ

theorem pair_descends_iff (S : Setoid α) (φ : α → γ) (ψ : α → η) :
    UnaryDescends S (fun x => (φ x, ψ x)) ↔
      UnaryDescends S φ ∧ UnaryDescends S ψ := by
  rw [unary_descends_iff, unary_descends_iff, unary_descends_iff]
  constructor
  · intro h
    exact ⟨fun x y hxy => congrArg Prod.fst (h x y hxy),
      fun x y hxy => congrArg Prod.snd (h x y hxy)⟩
  · rintro ⟨hφ, hψ⟩ x y hxy
    exact Prod.ext (hφ x y hxy) (hψ x y hxy)

theorem localGreenGlobalRed_pair_obstruction (S : Setoid α)
    (φ : α → γ) (ψ : α → η) (hφ : UnaryCongruent S φ)
    {x y : α} (hxy : S.r x y) (hne : ψ x ≠ ψ y) :
    UnaryDescends S φ ∧ ¬ UnaryDescends S (fun x => (φ x, ψ x)) := by
  refine ⟨(unary_descends_iff S φ).mpr hφ, ?_⟩
  intro h
  exact unary_no_factor_of_witness S ψ hxy hne ((pair_descends_iff S φ ψ).mp h).2

/-- Re-encoding remembers precisely the equivalence relation. -/
def fromSetoid (S : Setoid α) : Kernel α Prop where
  δ := S.r
  Zero := fun p => p
  zero_refl := S.refl
  zero_symm := fun _ _ => S.symm
  zero_trans := fun _ _ _ => S.trans

theorem fromSetoid_zeroRel (S : Setoid α) (x y : α) :
    ZeroRel (fromSetoid S) x y ↔ S.r x y := Iff.rfl

theorem forget_reconstruct_zeroRel (K : Kernel α β) (x y : α) :
    ZeroRel (fromSetoid (zeroSetoid K)) x y ↔ ZeroRel K x y := Iff.rfl

theorem fromSetoid_exact_descends (S : Setoid α) :
    BinaryDescends S (fromSetoid S).δ := zero_status_descends_own (fromSetoid S)

theorem exact_descends_implies_zero_status (K : Kernel α β) (S : Setoid α)
    (h : BinaryDescends S K.δ) : ZeroStatusDescends K S := by
  apply (binary_descends_iff S (ZeroRel K)).mpr
  intro x x' y y' hx hy
  exact congrArg K.Zero ((binary_descends_iff S K.δ).mp h x x' y y' hx hy)

/-! Four finite cases. Labels in these fixtures are coordinates, not chosen
representatives in the generic quotient constructions. -/

def constantAllZero : Kernel Bool Bool where
  δ := fun _ _ => false
  Zero := fun _ => True
  zero_refl := fun _ => True.intro
  zero_symm := fun _ _ _ => True.intro
  zero_trans := fun _ _ _ _ _ => True.intro

def nonconstantAllZero : Kernel Bool Bool where
  δ := fun x _ => x
  Zero := fun _ => True
  zero_refl := fun _ => True.intro
  zero_symm := fun _ _ _ => True.intro
  zero_trans := fun _ _ _ _ _ => True.intro

def binary : Kernel Bool Bool where
  δ := Bool.xor
  Zero := fun v => v = false
  zero_refl := by intro x; cases x <;> rfl
  zero_symm := by intro x y; cases x <;> cases y <;> decide
  zero_trans := by intro x y z; cases x <;> cases y <;> cases z <;> decide

inductive Three where
  | zero | one | two
  deriving DecidableEq, Repr

/-- Rows and columns are 0,1,2; the entries are 0,0,2 / 1,1,2 / 2,2,0. -/
def richDelta : Three → Three → Three
  | .zero, .zero => .zero
  | .zero, .one => .zero
  | .zero, .two => .two
  | .one, .zero => .one
  | .one, .one => .one
  | .one, .two => .two
  | .two, .zero => .two
  | .two, .one => .two
  | .two, .two => .zero

def rich : Kernel Three Three where
  δ := richDelta
  Zero := fun v => v = .zero ∨ v = .one
  zero_refl := by intro x; cases x <;> decide
  zero_symm := by intro x y; cases x <;> cases y <;> decide
  zero_trans := by intro x y z; cases x <;> cases y <;> cases z <;> decide

theorem four_fixtures_zero_status_descends :
    ZeroStatusDescends constantAllZero (zeroSetoid constantAllZero) ∧
    ZeroStatusDescends nonconstantAllZero (zeroSetoid nonconstantAllZero) ∧
    ZeroStatusDescends binary (zeroSetoid binary) ∧
    ZeroStatusDescends rich (zeroSetoid rich) :=
  ⟨zero_status_descends_own _, zero_status_descends_own _,
    zero_status_descends_own _, zero_status_descends_own _⟩

theorem constantAllZero_one_class :
    Nonempty (ResidualQuotient constantAllZero) ∧
    Subsingleton (ResidualQuotient constantAllZero) :=
  ⟨⟨classOf constantAllZero false⟩,
    (quotient_subsingleton_iff constantAllZero).mpr (fun _ _ => True.intro)⟩

theorem constantAllZero_exact_descends :
    BinaryDescends (zeroSetoid constantAllZero) constantAllZero.δ :=
  (binary_descends_iff _ _).mpr (fun _ _ _ _ _ _ => rfl)

theorem nonconstantAllZero_one_class :
    Nonempty (ResidualQuotient nonconstantAllZero) ∧
    Subsingleton (ResidualQuotient nonconstantAllZero) :=
  ⟨⟨classOf nonconstantAllZero false⟩,
    (quotient_subsingleton_iff nonconstantAllZero).mpr (fun _ _ => True.intro)⟩

theorem nonconstantAllZero_failure_witness :
    ZeroRel nonconstantAllZero false true ∧
    ZeroRel nonconstantAllZero false false ∧
    nonconstantAllZero.δ false false ≠ nonconstantAllZero.δ true false := by
  change True ∧ True ∧ false ≠ true
  decide

theorem nonconstantAllZero_not_exact_descends :
    ¬ BinaryDescends (zeroSetoid nonconstantAllZero) nonconstantAllZero.δ :=
  binary_no_factor_of_witness _ _ nonconstantAllZero_failure_witness.1
    nonconstantAllZero_failure_witness.2.1 nonconstantAllZero_failure_witness.2.2

theorem binary_zeroRel_iff_eq (x y : Bool) : ZeroRel binary x y ↔ x = y := by
  cases x <;> cases y <;> simp [ZeroRel, binary]

theorem binary_nonzero_iff_S2 (x y : Bool) :
    Nonzero binary x y ↔ OmegaCodex.PrimitiveDifference.S2 x y := by
  change (¬ ZeroRel binary x y) ↔ x ≠ y
  rw [binary_zeroRel_iff_eq]

theorem binary_two_classes :
    classOf binary false ≠ classOf binary true ∧
    ∀ q : ResidualQuotient binary, q = classOf binary false ∨ q = classOf binary true := by
  constructor
  · exact (nonzero_iff_classes_ne binary false true).mp (by simp [Nonzero, ZeroRel, binary])
  · intro q
    refine Quotient.inductionOn q ?_
    intro x
    cases x
    · exact Or.inl rfl
    · exact Or.inr rfl

theorem binary_exact_descends : BinaryDescends (zeroSetoid binary) binary.δ := by
  apply (binary_descends_iff _ _).mpr
  intro x x' y y' hx hy
  have hx' := (binary_zeroRel_iff_eq x x').mp hx
  have hy' := (binary_zeroRel_iff_eq y y').mp hy
  rw [hx', hy']

theorem rich_zeroRel_classes (x y : Three) :
    ZeroRel rich x y ↔ (x ≠ .two ∧ y ≠ .two) ∨ (x = .two ∧ y = .two) := by
  cases x <;> cases y <;> simp [ZeroRel, rich, richDelta]

theorem rich_two_classes :
    classOf rich .zero ≠ classOf rich .two ∧
    ∀ q : ResidualQuotient rich, q = classOf rich .zero ∨ q = classOf rich .two := by
  constructor
  · exact (nonzero_iff_classes_ne rich .zero .two).mp (by simp [Nonzero, ZeroRel, rich, richDelta])
  · intro q
    refine Quotient.inductionOn q ?_
    intro x
    cases x
    · exact Or.inl rfl
    · exact Or.inl ((classOf_eq_iff_zeroRel rich .one .zero).mpr (Or.inr rfl))
    · exact Or.inr rfl

theorem rich_failure_witness :
    ZeroRel rich .zero .one ∧ ZeroRel rich .zero .zero ∧
    rich.δ .zero .zero ≠ rich.δ .one .zero := by
  simp [ZeroRel, rich, richDelta]

theorem rich_not_exact_descends : ¬ BinaryDescends (zeroSetoid rich) rich.δ :=
  binary_no_factor_of_witness _ _ rich_failure_witness.1
    rich_failure_witness.2.1 rich_failure_witness.2.2

theorem presentation_inequality_without_class_inequality :
    ∃ x y : Bool, x ≠ y ∧ classOf nonconstantAllZero x = classOf nonconstantAllZero y :=
  ⟨false, true, by decide, (classOf_eq_iff_zeroRel _ _ _).mpr True.intro⟩

theorem same_zeroRel_different_values :
    (∀ x y, ZeroRel constantAllZero x y ↔ ZeroRel nonconstantAllZero x y) ∧
    (∃ x y, constantAllZero.δ x y ≠ nonconstantAllZero.δ x y) :=
  ⟨fun _ _ => Iff.rfl, true, false, by decide⟩

theorem same_zeroRel_different_descent :
    (∀ x y, ZeroRel constantAllZero x y ↔ ZeroRel nonconstantAllZero x y) ∧
    BinaryDescends (zeroSetoid constantAllZero) constantAllZero.δ ∧
    ¬ BinaryDescends (zeroSetoid nonconstantAllZero) nonconstantAllZero.δ :=
  ⟨same_zeroRel_different_values.1,
    constantAllZero_exact_descends, nonconstantAllZero_not_exact_descends⟩

theorem finite_localGreenGlobalRed :
    UnaryDescends (zeroSetoid nonconstantAllZero) (fun _ : Bool => false) ∧
    ¬ UnaryDescends (zeroSetoid nonconstantAllZero) (fun x : Bool => (false, x)) :=
  localGreenGlobalRed_pair_obstruction _ (fun _ : Bool => false) (fun x : Bool => x)
    (fun _ _ _ => rfl) (x := false) (y := true) True.intro (by decide)

/-! Symmetric and irreflexive is strictly weaker than complement-of-equivalence. -/

def isolatedEdge (x y : Three) : Prop :=
  (x = .zero ∧ y = .one) ∨ (x = .one ∧ y = .zero)

theorem isolatedEdge_irrefl : OmegaCodex.PrimitiveDifference.Irrefl isolatedEdge := by
  intro x
  cases x <;> simp [isolatedEdge]

theorem isolatedEdge_symm (x y : Three) : isolatedEdge x y → isolatedEdge y x := by
  cases x <;> cases y <;> simp [isolatedEdge]

theorem isolatedEdge_witness : isolatedEdge .zero .one := Or.inl ⟨rfl, rfl⟩

theorem isolatedEdge_not_zero_complement (K : Kernel Three β) :
    ¬ (∀ x y, isolatedEdge x y ↔ Nonzero K x y) := by
  intro h
  have h01 : Nonzero K .zero .one := (h _ _).mp isolatedEdge_witness
  have h02 : ¬ ¬ ZeroRel K .zero .two := by
    intro hn
    exact (show ¬ isolatedEdge .zero .two by simp [isolatedEdge]) ((h _ _).mpr hn)
  have h21 : ¬ ¬ ZeroRel K .two .one := by
    intro hn
    exact (show ¬ isolatedEdge .two .one by simp [isolatedEdge]) ((h _ _).mpr hn)
  exact h02 (fun e02 => h21 (fun e21 => h01 (K.zero_trans _ _ _ e02 e21)))

theorem isolatedEdge_not_equivalence_complement :
    ¬ (∃ S : Setoid Three, ∀ x y, isolatedEdge x y ↔ ¬ S.r x y) := by
  rintro ⟨S, h⟩
  exact isolatedEdge_not_zero_complement (fromSetoid S) h

/-! Empty and singleton carriers do not supply a nonzero pair. -/

def emptyKernel : Kernel Empty Bool where
  δ := fun x _ => nomatch x
  Zero := fun v => v = false
  zero_refl := by intro x; cases x
  zero_symm := by intro x; cases x
  zero_trans := by intro x; cases x

def singletonKernel : Kernel Unit Bool where
  δ := fun _ _ => false
  Zero := fun v => v = false
  zero_refl := fun _ => rfl
  zero_symm := fun _ _ _ => rfl
  zero_trans := fun _ _ _ _ _ => rfl

theorem empty_quotient :
    Subsingleton (ResidualQuotient emptyKernel) ∧
    ¬ Nonempty (ResidualQuotient emptyKernel) := by
  constructor
  · apply (quotient_subsingleton_iff _).mpr
    intro x
    cases x
  · rintro ⟨q⟩
    refine Quotient.inductionOn q ?_
    intro x
    cases x

theorem singleton_quotient :
    Nonempty (ResidualQuotient singletonKernel) ∧
    Subsingleton (ResidualQuotient singletonKernel) :=
  ⟨⟨classOf singletonKernel ()⟩, (quotient_subsingleton_iff _).mpr (fun _ _ => rfl)⟩

theorem empty_exact_descends : BinaryDescends (zeroSetoid emptyKernel) emptyKernel.δ := by
  apply (binary_descends_iff _ _).mpr
  intro x
  cases x

theorem singleton_exact_descends :
    BinaryDescends (zeroSetoid singletonKernel) singletonKernel.δ :=
  (binary_descends_iff _ _).mpr (fun _ _ _ _ _ _ => rfl)

theorem empty_and_singleton_zero_status :
    ZeroStatusDescends emptyKernel (zeroSetoid emptyKernel) ∧
    ZeroStatusDescends singletonKernel (zeroSetoid singletonKernel) :=
  ⟨zero_status_descends_own _, zero_status_descends_own _⟩

/-! Relabeling uses supplied inverse maps; it never chooses quotient representatives. -/

def relabel (K : Kernel α β) (f : γ → α) : Kernel γ β where
  δ := fun x y => K.δ (f x) (f y)
  Zero := K.Zero
  zero_refl := fun x => K.zero_refl (f x)
  zero_symm := fun x y => K.zero_symm (f x) (f y)
  zero_trans := fun x y z => K.zero_trans (f x) (f y) (f z)

theorem relabel_zeroRel (K : Kernel α β) (f : γ → α) (x y : γ) :
    ZeroRel (relabel K f) x y ↔ ZeroRel K (f x) (f y) := Iff.rfl

theorem relabel_nonzero (K : Kernel α β) (f : γ → α) (x y : γ) :
    Nonzero (relabel K f) x y ↔ Nonzero K (f x) (f y) := Iff.rfl

def relabelQuotientMap (K : Kernel α β) (f : γ → α) :
    ResidualQuotient (relabel K f) → ResidualQuotient K :=
  Quotient.lift (fun x => classOf K (f x))
    (fun _ _ h => Quotient.sound (s := zeroSetoid K) h)

def relabelQuotientInverse (K : Kernel α β) (f : γ → α) (g : α → γ)
    (hfg : ∀ x, f (g x) = x) :
    ResidualQuotient K → ResidualQuotient (relabel K f) :=
  Quotient.lift (fun x => classOf (relabel K f) (g x)) (by
    intro x y h
    apply Quotient.sound
    change ZeroRel K (f (g x)) (f (g y))
    rw [hfg x, hfg y]
    exact h)

theorem relabel_quotient_left_inverse (K : Kernel α β) (f : γ → α) (g : α → γ)
    (hfg : ∀ x, f (g x) = x) (hgf : ∀ x, g (f x) = x)
    (q : ResidualQuotient (relabel K f)) :
    relabelQuotientInverse K f g hfg (relabelQuotientMap K f q) = q := by
  refine Quotient.inductionOn q ?_
  intro x
  change classOf (relabel K f) (g (f x)) = classOf (relabel K f) x
  rw [hgf x]

theorem relabel_quotient_right_inverse (K : Kernel α β) (f : γ → α) (g : α → γ)
    (hfg : ∀ x, f (g x) = x) (q : ResidualQuotient K) :
    relabelQuotientMap K f (relabelQuotientInverse K f g hfg q) = q := by
  refine Quotient.inductionOn q ?_
  intro x
  change classOf K (f (g x)) = classOf K x
  rw [hfg x]

/-- An explicit right inverse already suffices for this preservation comparison. -/
theorem relabel_exact_descends_iff (K : Kernel α β) (f : γ → α) (g : α → γ)
    (hfg : ∀ x, f (g x) = x) :
    BinaryDescends (zeroSetoid (relabel K f)) (relabel K f).δ ↔
    BinaryDescends (zeroSetoid K) K.δ := by
  rw [binary_descends_iff, binary_descends_iff]
  constructor
  · intro h x x' y y' hx hy
    have hx' : ZeroRel (relabel K f) (g x) (g x') := by
      change ZeroRel K (f (g x)) (f (g x'))
      rw [hfg x, hfg x']
      exact hx
    have hy' : ZeroRel (relabel K f) (g y) (g y') := by
      change ZeroRel K (f (g y)) (f (g y'))
      rw [hfg y, hfg y']
      exact hy
    have he := h (g x) (g x') (g y) (g y') hx' hy'
    change K.δ (f (g x)) (f (g y)) = K.δ (f (g x')) (f (g y')) at he
    simpa only [hfg] using he
  · intro h x x' y y' hx hy
    exact h (f x) (f x') (f y) (f y') hx hy

theorem relabel_unary_descends_iff (K : Kernel α β) (f : γ → α) (g : α → γ)
    (hfg : ∀ x, f (g x) = x) (φ : α → η) :
    UnaryDescends (zeroSetoid (relabel K f)) (fun x => φ (f x)) ↔
    UnaryDescends (zeroSetoid K) φ := by
  rw [unary_descends_iff, unary_descends_iff]
  constructor
  · intro h x y hxy
    have hxy' : ZeroRel (relabel K f) (g x) (g y) := by
      change ZeroRel K (f (g x)) (f (g y))
      rw [hfg x, hfg y]
      exact hxy
    simpa only [hfg] using h (g x) (g y) hxy'
  · intro h x y hxy
    exact h (f x) (f y) hxy

/-! A precise structural crosswalk to the existing collapse obstruction. -/

theorem zero_status_refuses_nonzero_identification (K : Kernel α β) (S : Setoid α)
    {x y : α} (hS : S.r x y) (hR : Nonzero K x y) : ¬ ZeroStatusDescends K S :=
  fun h => hR ((zero_status_descends_iff_refines K S).mp h x y hS)

theorem nonzero_collision_violates_irrefl (K : Kernel α β) (c : α → γ)
    {x y : α} (hR : Nonzero K x y) (hc : c x = c y) :
    ¬ OmegaCodex.PrimitiveDifference.Irrefl
      (OmegaCodex.PrimitiveDifference.Push (Nonzero K) c) :=
  OmegaCodex.PrimitiveDifference.identified_witness_violates_irrefl hR c hc

/-! Two stipulated continuations of the very same static quotient. -/

def NoSuccessor {σ : Type u} (step : σ → σ → Prop) (s : σ) : Prop :=
  ∀ t, ¬ step s t

def halted {σ : Type u} : σ → σ → Prop := fun _ _ => False

def identityStep {σ : Type u} : σ → σ → Prop := fun s t => s = t

theorem static_kernel_does_not_determine_terminal (K : Kernel α β)
    (q : ResidualQuotient K) :
    NoSuccessor halted q ∧ identityStep q q ∧ ¬ NoSuccessor identityStep q :=
  ⟨fun _ h => h, rfl, fun h => h q rfl⟩

end OmegaCodex.ZeroEquivalence
