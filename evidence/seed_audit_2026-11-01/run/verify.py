"""Offline verification of the completed protocol execution."""
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent
def read(name):
    return json.loads((ROOT / name).read_text(encoding='utf-8'))
def digest(data):
    return hashlib.sha256(data).hexdigest()

source = (ROOT / 'source_protocol.md').read_bytes()
original = Path(r'C:\Users\a343o\Downloads\genesis_deepseek_seed_audit_and_protocol.md').read_bytes()
assert source == original, 'Source snapshot differs from supplied file.'
prompts = re.findall(r'^```text\r?\n(.*?)^```', source.decode('utf-8-sig'), re.M | re.S)
assert len(prompts) == 25
plan, ledger, status = read('plan.json'), read('ledger.json'), read('status.json')
assert status['status'] == 'complete' and status['completed'] == 25
assert plan['source_sha256'] == digest(source)
assert len(ledger) == 25
assert len(list((ROOT / 'calls').glob('*.request.json'))) == 25
assert len(list((ROOT / 'calls').glob('*.response.json'))) == 25
histories = {str(c): [] for c in range(1, 10)}
rounds = [r for r in range(1, 7) for _ in range(4)] + [7]
chats = list(range(1, 5)) + list(range(5, 9)) * 5 + [9]
models, providers, finishes = set(), set(), set()
cost = 0
prompt_tokens = completion_tokens = 0
previous_completed = None
for i, (prompt, rnd, chat) in enumerate(zip(prompts, rounds, chats), 1):
    entry, row = plan['entries'][i-1], ledger[i-1]
    assert (entry['sequence'], entry['round'], entry['chat']) == (i, rnd, chat)
    assert (row['sequence'], row['round'], row['chat']) == (i, rnd, chat)
    assert entry['prompt'] == prompt
    assert entry['prompt_sha256'] == row['prompt_sha256'] == digest(prompt.encode('utf-8'))
    stem = f'{i:02d}_round{rnd}_chat{chat}'
    request_bytes = (ROOT / 'calls' / (stem + '.request.json')).read_bytes()
    response_bytes = (ROOT / 'calls' / (stem + '.response.json')).read_bytes()
    assert digest(request_bytes) == row['request_sha256']
    assert digest(response_bytes) == row['response_sha256']
    request, response = json.loads(request_bytes), json.loads(response_bytes)
    expected = histories[str(chat)] + [{'role': 'user', 'content': prompt}]
    assert request['messages'] == expected, f'History mismatch in request {i}'
    assert {k: v for k, v in request.items() if k != 'messages'} == plan['settings']
    assert request['model'] == 'openai/gpt-6.1-sol'
    assert previous_completed is None or row['started_at'] >= previous_completed
    previous_completed = row['completed_at']
    choice = response['choices'][0]
    assert choice['finish_reason'] == 'stop'
    assert response['model'].startswith('openai/gpt-6.1-sol')
    answer = choice['message']['content']
    assert isinstance(answer, str) and answer.strip()
    histories[str(chat)] = expected + [{'role': 'assistant', 'content': answer}]
    models.add(response['model'])
    providers.add(response.get('provider'))
    finishes.add(choice['finish_reason'])
    cost += response.get('usage', {}).get('cost', 0) or 0
    prompt_tokens += response.get('usage', {}).get('prompt_tokens', 0)
    completion_tokens += response.get('usage', {}).get('completion_tokens', 0)
assert histories == read('conversations.json')
assert [len(histories[str(c)]) for c in range(1, 10)] == [2]*4 + [10]*4 + [2]
report = (ROOT / 'answers.md').read_text(encoding='utf-8')
assert len(re.findall(r'^## Round ', report, re.M)) == 25
for chat, history in histories.items():
    lines = [f'# Chat {chat} — GPT-6.1 Sol', '']
    for msg in history:
        lines += ['## ' + msg['role'].capitalize(), '', msg['content'], '']
        if msg['role'] == 'assistant':
            assert msg['content'] in report
    (ROOT / f'chat_{chat}.md').write_text('\n'.join(lines), encoding='utf-8')
verification = {
    'verified': True, 'answers': 25, 'rounds': 7, 'conversations': 9,
    'source_sha256': digest(source),
    'checks': ['source snapshot byte equality', 'exact prompt text and order',
               'isolated complete conversation histories', 'uniform settings without added system messages',
               'sequential request timestamps', 'request and response hashes',
               'all responses completed normally', 'all answers included verbatim in report'],
    'response_models': sorted(models), 'response_providers': sorted(providers, key=str),
    'finish_reasons': sorted(finishes), 'reported_cost_usd': cost,
    'prompt_tokens': prompt_tokens, 'completion_tokens': completion_tokens,
    'scope': 'Execution fidelity verified; this does not certify correctness of model answers.',
}
(ROOT / 'verification.json').write_text(json.dumps(verification, indent=2) + '\n', encoding='utf-8')
files = sorted(p for p in ROOT.rglob('*') if p.is_file() and p.name != 'SHA256SUMS')
(ROOT / 'SHA256SUMS').write_text(''.join(f'{digest(p.read_bytes())}  {p.relative_to(ROOT).as_posix()}\n' for p in files), encoding='utf-8')
print(json.dumps(verification, indent=2))
