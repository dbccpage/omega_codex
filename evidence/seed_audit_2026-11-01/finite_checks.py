"""Small independent checks of examples in the audit; no model calls."""
import hashlib
import itertools
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent
run = ROOT / 'run'
verified_files = 0
for line in (run / 'SHA256SUMS').read_text(encoding='utf-8').splitlines():
    expected, relative = line.split('  ', 1)
    assert hashlib.sha256((run / relative).read_bytes()).hexdigest() == expected, relative
    verified_files += 1

# Four binary receipt pairs: swapping preserves XOR. Resetting every result-
# relevant component loses XOR; a separately protected result bit preserves it.
rows = []
for a, b in itertools.product((0, 1), repeat=2):
    result = a ^ b
    assert (b ^ a) == result
    rows.append({'a': a, 'b': b, 'difference': result, 'swapped_difference': b ^ a,
                 'reset_complete_state_without_R': ['RESUME', 0, 0, 0],
                 'protected_R': result})
assert rows[0]['reset_complete_state_without_R'] == rows[1]['reset_complete_state_without_R']
assert rows[0]['difference'] != rows[1]['difference']

# Explicit countermodels for deleting each of the three axioms in R5/chat7.
# These are semantic checks of the displayed witnesses, not a Lean proof.
countermodels = [
    {'deleted': 'd(a)=0', 'a': 0, 'p': 0, 'zero': 0, 'one': 1, 'd': [1]},
    {'deleted': 'd(p)=1', 'a': 0, 'p': 0, 'zero': 0, 'one': 1, 'd': [0]},
    {'deleted': '0!=1', 'a': 0, 'p': 0, 'zero': 0, 'one': 0, 'd': [0]},
]
for m in countermodels:
    axioms = {'d(a)=0': m['d'][m['a']] == m['zero'],
              'd(p)=1': m['d'][m['p']] == m['one'], '0!=1': m['zero'] != m['one']}
    assert all(v for k, v in axioms.items() if k != m['deleted'])
    assert m['d'][m['a']] == m['d'][m['p']]
    assert m['a'] == m['p']

# A warning about extending R5/chat6 beyond its explicitly admitted 0/1
# event-per-window domain: event parity is not arbitrary-count presence XOR.
assert ((2 % 2) ^ (0 % 2)) != (int(2 > 0) ^ int(0 > 0))

evidence = {'passed': True, 'preserved_run_files_checked': verified_files,
            'binary_receipt_cases': rows, 'axiom_deletion_countermodels': countermodels,
            'scope': 'Finite example and archive-integrity checks only. No new LLM calls, physical experiment, global minimality search, or Lean build.'}
(ROOT / 'finite_checks.json').write_text(json.dumps(evidence, indent=2) + '\n', encoding='utf-8')
print(json.dumps({'passed': True, 'preserved_run_files_checked': verified_files,
                  'binary_receipt_cases': len(rows), 'deletion_countermodels': len(countermodels)}))
