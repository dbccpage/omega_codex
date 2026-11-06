/-!
# Simplex AutoP Syntax Specification

Defines the formal syntax trees for the AutoP structural specification language.
AutoP is purely descriptive: it models mathematical structures, categories,
sheaves, operators, certificates, and obligations.

AuthorityEffect: None.
-/

namespace Simplex.AutoP.Syntax

/-- Target backend compilation annotations. -/
inductive TargetBackend where
  | lean : TargetBackend
  | rust : TargetBackend
  | python : TargetBackend
deriving Repr, DecidableEq

/-- The three levels of truth/evidence in AutoP. -/
inductive ProofLevel where
  | proof : ProofLevel    -- Exact Lean 4 mathematical proof
  | certify : ProofLevel  -- Rust runtime verifier with checked conditions
  | observe : ProofLevel  -- Empirical/diagnostic observation outside the evaluator
deriving Repr, DecidableEq

/-- Binary operator kinds for expressions. -/
inductive BinOpKind where
  | add : BinOpKind
  | sub : BinOpKind
  | mul : BinOpKind
  | div : BinOpKind
  | pow : BinOpKind
deriving Repr, DecidableEq

/-- Formal type expressions. -/
inductive TypeExpr where
  | named (name : String) : TypeExpr
  | arrow (source target : TypeExpr) : TypeExpr
  | product (factors : List TypeExpr) : TypeExpr
  | parameterized (name : String) (args : List TypeExpr) : TypeExpr
deriving Repr, Inhabited

/-- Expression AST. -/
inductive Expr where
  | var (name : String) : Expr
  | intLit (val : Int) : Expr
  | app (fnName : String) (args : List Expr) : Expr
  | tuple (elements : List Expr) : Expr
  | compose (f g : Expr) : Expr
  | binOp (lhs : Expr) (op : BinOpKind) (rhs : Expr) : Expr
  | neg (inner : Expr) : Expr
deriving Repr, Inhabited

/-- Top-level declaration kinds in the AutoP language. -/
inductive Declaration where
  -- Core Structural
  | manifold (name : String) (dim : Nat)
  | morphism (name : String) (source target : TypeExpr)
  | sheaf (name : String) (params : List String)
  | adjunction (name : String) (left right : String)
  | tensor (name : String)
  | orbit (name : String) (source target : TypeExpr)
  | functor (name : String) (sourceCat targetCat : String)
  | natural (name : String) (sourceF targetF : String)
  | category (name : String) (objects : List String)
  | network (name : String) (nodes : List String)
  | deploy (name : String) (targetNode : String)
  | operad (name : String) (source target : TypeExpr)
  | bundle (name : String) (total base : TypeExpr)
  | topos (name : String)
  | presheaf (name : String)
  | cohomology (name : String)
  | operator (name : String) (source target : TypeExpr)
  -- Module & Structural Utilities
  | moduleDecl (name : String) (decls : List Declaration)
  | importDecl (path : List String)
  | typeDecl (name : String) (definition : Option TypeExpr)
  | structureDecl (name : String)
  | diagram (name : String)
  | rule (name : String) (direction : String)
  | invariant (name : String) (typeSig : TypeExpr)
  -- Algebraic Foundations
  | algebra (name : String) (carrier : TypeExpr)
  | complex (name : String)
  | proposition (name : String)
  -- Three-Level Proof & Lawfulness
  | certifyDecl (name : String) (conditions : List String)
  | observeDecl (name : String) (statement : String)
  | functionalDecl (name : String) (targetType : TypeExpr)
  | lawEnforcement (name : String)
  | countermodel (name : String) (witnessName : String)
  | evaluator (name : String)
  | observable (name : String) (typeSig : TypeExpr)
  -- Theorem Compression & Contracts
  | theoremDecl (name : String) (statements : List String)
  | contractDecl (name : String) (obligations : List String)
  -- Quarantined (Explicitly parsed to reject fail-closed)
  | quarantined (keyword : String) (name : String)
deriving Repr, Inhabited

/-- A complete AutoP module specification. -/
structure Module where
  name : String
  declarations : List Declaration
deriving Repr, Inhabited

end Simplex.AutoP.Syntax
