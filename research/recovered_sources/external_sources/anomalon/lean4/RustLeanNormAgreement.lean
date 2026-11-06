import Expressivity
set_option linter.deprecated false

/-!
S7: Lean-side per-row expressivityNorm printer.

Consumes the corpus file at
`omega_engine/crates/omega_symbol_game/tests/data/cross_window_corpus.txt`,
parses each line `n;d1,d2,...,dk`, computes
`OmegaCosmology.SymbolGame.expressivityNorm [d1, d2, ..., dk]`, and prints
one decimal value per line. The Rust S7 AT
(`rust_lean_norm_agreement.rs`) compares this output to
`omega_symbol_game::expressivity::norm` byte-for-byte.
-/

open OmegaCosmology.SymbolGame

def parseTokens (toks : List String) : Option (List Int) :=
  let go : List String → Option (List Int) := fun ts =>
    ts.foldr (fun t acc =>
      match acc with
      | none => none
      | some xs =>
        match t.toInt? with
        | some i => some (i :: xs)
        | none => none) (some [])
  go toks

def parseLine (line : String) : Option (List Int) :=
  let line := line.trim
  if line.isEmpty || line.startsWith "#" then
    none
  else
    let parts := line.splitOn ";"
    match parts with
    | [_n, ds] =>
      let toks := (ds.splitOn ",").map (·.trim) |>.filter (fun t => !t.isEmpty)
      parseTokens toks
    | _ => none

def main (args : List String) : IO Unit := do
  match args with
  | [path] =>
    let content ← IO.FS.readFile path
    let lines := content.splitOn "\n"
    for line in lines do
      match parseLine line with
      | some xs => IO.println (expressivityNorm xs)
      | none => pure ()
  | _ =>
    IO.eprintln "usage: lean --run rust_lean_norm_agreement.lean <corpus.txt>"
    IO.Process.exit 2
