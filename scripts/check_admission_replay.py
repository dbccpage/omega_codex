"""Build and verify the agreed replay slice; emit a fresh, source-bound report."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import tempfile

from admission_replay_checks import verify_walk, mutation_controls, require

ROOT = Path(__file__).resolve().parents[1]


def run(args):
    return subprocess.run(args, cwd=ROOT, capture_output=True, text=True,
                          encoding='utf-8', errors='strict', timeout=60)


def successful(args):
    result = run(args)
    require(result.returncode == 0, result.stdout + result.stderr)
    return result.stdout


def source_closure(module):
    found = {}
    def visit(name):
        path = ROOT / 'lean' / (name.replace('.', '/') + '.lean')
        rel = path.relative_to(ROOT).as_posix()
        if rel in found:
            return
        raw = path.read_bytes()
        found[rel] = hashlib.sha256(raw).hexdigest()
        for imports in re.findall(r'^import\s+([^\r\n]+)', raw.decode('utf-8'), re.M):
            for dependency in imports.split():
                visit(dependency)
    visit(module)
    return found


def check():
    version = successful(['lean', '--version']).strip()
    require('version 4.33.0,' in version, 'Wrong Lean version')
    require((ROOT/'lean-toolchain').read_text().strip() == 'leanprover/lean4:v4.33.0', 'Toolchain drift')
    sources = source_closure('AdmissionReplay')
    for rel in ['lakefile.toml', 'scripts/admission_replay_walk.lean',
                'scripts/admission_replay_checks.py', 'scripts/check_admission_replay.py',
                'tests/test_admission_replay.py']:
        sources[rel] = hashlib.sha256((ROOT/rel).read_bytes()).hexdigest()
    custody = json.loads((ROOT/'research/route/2026-11-06-admission-replay-source-custody.json').read_text())
    for entry in custody:
        require(sources[entry['destination']] == entry['sha256'], 'Vendor source changed')
        raw = (ROOT/entry['destination']).read_bytes().replace(b'\r\n', b'\n')
        blob = hashlib.sha1(b'blob ' + str(len(raw)).encode() + b'\0' + raw).hexdigest()
        require(blob == entry['git_blob_lf'], 'Pinned source blob differs')
    successful(['lake', 'build', 'AdmissionReplay'])
    source = (ROOT/'lean/AdmissionReplay.lean').read_text(encoding='utf-8')
    require(not re.search(r'^\s*(?:axiom|opaque)\s|\b(?:sorry|native_decide)\b', source, re.M),
            'Unverified declaration in adapter')
    names = re.findall(r'^theorem\s+(\w+)', source, re.M)
    require(bool(names) and len(names) == len(set(names)), 'Theorem inventory')
    with tempfile.TemporaryDirectory(prefix='omega-admission-replay-') as temporary:
        temp = Path(temporary)
        census = temp/'Census.lean'
        census.write_text('import AdmissionReplay\n' + '\n'.join(
            '#print axioms OmegaCodex.AdmissionReplay.' + name for name in names), encoding='utf-8')
        output = successful(['lake', 'env', 'lean', str(census)])
        dependencies = {}
        for name in names:
            match = re.search("'OmegaCodex.AdmissionReplay." + re.escape(name) +
                              r"' (does not depend on any axioms|depends on axioms: \[([^\]]*)\])", output)
            require(match is not None, 'Missing census: ' + name)
            axioms = [] if match[2] is None else [a.strip() for a in match[2].split(',')]
            require(set(axioms) <= {'propext', 'Quot.sound'}, 'Unexpected axiom: ' + name)
            dependencies[name] = axioms

        header = ('import AdmissionReplay\nopen OmegaCodex.MinimalSeparation '
                  'OmegaCodex.AdmissionReplay\n')
        # Baseline and mutant differ only in the asserted conclusion; the
        # actual source functions run in Lean's kernel via decide.
        controls = {
            'event-order': (
                'applyDelta4 R2L4 [.newForm 1, .newInst 0 [0]] = some U0_4',
                'applyDelta4 R2L4 [.newInst 0 [0], .newForm 1] = some U0_4'),
            'argument': (
                'applyItem4 U0_4 (.newInst 0 [0]) = some U0_4',
                'applyItem4 U0_4 (.newInst 0 [2]) = some U0_4'),
            'refusal': (
                'applyItem4 R2L4 (.newForm 0) = none',
                'applyItem4 R2L4 (.newForm 0) = some R2L4'),
            'occurrence-price': (
                'eventCost (fun _ => 1) (unaryResponse 0 ++ [.newInst 0 [0]]) = 3',
                'eventCost (fun _ => 1) (unaryResponse 0 ++ [.newInst 0 [0]]) = 2'),
            'retained-distinction': (
                'collapsed4Bool R3_round2_fresh 0 2 = false',
                'collapsed4Bool R3_round2_fresh 0 2 = true'),
            'supply-is-not-admission': (
                'presentedStep emptyRegime (.supply "<>") = some emptyRegime',
                'presentedStep emptyRegime (.supply "<>") = some ⟨1, [], [], []⟩'),
        }
        baseline = temp/'Baseline.lean'
        baseline.write_text(header + '\n'.join('example : ' + b + ' := by decide' for b, _ in controls.values()),
                            encoding='utf-8')
        successful(['lake', 'env', 'lean', str(baseline)])
        kernel_controls = {}
        for name, (_, mutant) in controls.items():
            path = temp/(name + '.lean')
            path.write_text(header + 'example : ' + mutant + ' := by decide\n', encoding='utf-8')
            result = run(['lake', 'env', 'lean', str(path)])
            require(result.returncode != 0 and 'decide' in result.stdout and 'error:' in result.stdout,
                    'Mutation survived or failed inconclusively: ' + name + '\n' + result.stdout + result.stderr)
            kernel_controls[name] = {'rejected': True, 'exit_code': result.returncode,
                                     'diagnostic': result.stdout.strip()}
    walk_raw = successful(['lake', 'env', 'lean', '--run', 'scripts/admission_replay_walk.lean'])
    walk = json.loads(walk_raw)
    finite = verify_walk(walk)
    mutations = mutation_controls(walk)
    for rel, expected in sources.items():
        require(hashlib.sha256((ROOT/rel).read_bytes()).hexdigest() == expected,
                'Source changed during check: ' + rel)
    return {'scope': 'Omega Item4 replay adapter and finite fixtures, not Rust driver refinement or endogenous continuation',
            'lean_version': version, 'sources_sha256': sources,
            'theorems_checked': len(names), 'axiom_dependencies': dependencies,
            'finite': finite, 'claim_mutations': mutations, 'lean_negative_controls': kernel_controls,
            'walk_sha256': hashlib.sha256(walk_raw.encode('utf-8')).hexdigest()}, walk_raw


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--report', type=Path)
    parser.add_argument('--walk', type=Path)
    args = parser.parse_args()
    report, walk = check()
    if args.report:
        args.report.write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
    if args.walk:
        args.walk.write_text(walk, encoding='utf-8', newline='')
    print(json.dumps({'theorems_checked': report['theorems_checked'],
                      'finite': report['finite'], 'claim_mutations_rejected': len(report['claim_mutations']),
                      'lean_negative_controls_rejected': len(report['lean_negative_controls'])}, indent=2))
