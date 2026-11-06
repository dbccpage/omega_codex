import Kernel

open Simplex.AutoP.Kernel

def main : IO Unit := do
  let cert : DualWitnessCertificate := {
    name := "h1_triangle_cycle_witness_k3",
    divergenceFree := true,
    linfBounded := true,
    pairingSaturated := true
  }
  let isValid := isCertificateValid cert
  let receiptStr := canonicalReceiptString cert
  IO.println s!"VALID:{isValid}"
  IO.println s!"RECEIPT:{receiptStr}"
