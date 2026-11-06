"""Run the actual Lean executable and independently check its declared corpus."""
import json
from pathlib import Path
import subprocess
import shutil
import unittest

from scripts.admission_replay_checks import verify_walk, mutation_controls

ROOT = Path(__file__).resolve().parents[1]


@unittest.skipUnless(shutil.which('lake'), 'Live replay checks require the pinned Lean toolchain')
class AdmissionReplayTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # Build is explicit so stale oleans cannot stand in for current source.
        subprocess.run(['lake', 'build', 'AdmissionReplay'], cwd=ROOT,
                       check=True, capture_output=True, timeout=60)
        run = subprocess.run(['lake', 'env', 'lean', '--run', 'scripts/admission_replay_walk.lean'],
                             cwd=ROOT, check=True, capture_output=True, text=True,
                             encoding='utf-8', timeout=60)
        cls.walk = json.loads(run.stdout)

    def test_actual_lean_replay_and_independent_context_oracle(self):
        result = verify_walk(self.walk)
        self.assertEqual(result['accepted_bounded'] + result['refused_bounded'], 365)

    def test_corrupted_claims_rejected(self):
        self.assertEqual(len(mutation_controls(self.walk)), 5)

    def test_missing_population_is_not_coverage(self):
        changed = dict(self.walk, bounded=self.walk['bounded'][:-1])
        with self.assertRaisesRegex(ValueError, 'population'):
            verify_walk(changed)

    def test_repeated_row_cannot_replace_missing_case(self):
        changed = dict(self.walk, bounded=[self.walk['bounded'][0]] * 365)
        with self.assertRaisesRegex(ValueError, 'coverage'):
            verify_walk(changed)


if __name__ == '__main__':
    unittest.main()
