"""Sequential OpenRouter experiment; no automatic retries or model fallback."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import sys
import time
import urllib.error
import urllib.request
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parent
MODEL = 'openai/gpt-6.1-sol'
SETTINGS = {
    'model': MODEL,
    'reasoning': {'effort': 'medium'},
    'max_tokens': 16000,
    'stream': False,
    'provider': {'only': ['OpenAI'], 'allow_fallbacks': False, 'require_parameters': True},
}

def now():
    return datetime.now(timezone.utc).isoformat()

def save(path, value):
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

def sha(data):
    return hashlib.sha256(data).hexdigest()

def plan():
    source = (ROOT / 'source_protocol.md').read_bytes()
    text = source.decode('utf-8-sig')
    entries = []
    for round_match in re.finditer(r'^## Round (\d+) [^\n]*\n(.*?)(?=^## |\Z)', text, re.M | re.S):
        rnd = int(round_match[1])
        prompts = re.findall(r'^```text\r?\n(.*?)^```', round_match[2], re.M | re.S)
        assert len(prompts) == (1 if rnd == 7 else 4)
        for idx, prompt in enumerate(prompts):
            chat = idx + 1 if rnd == 1 else idx + 5 if rnd < 7 else 9
            entries.append({'sequence': len(entries)+1, 'round': rnd, 'chat': chat,
                            'seed': ['<>', '||', 'αβ', '≤'][idx] if rnd < 7 else None,
                            'prompt': prompt, 'prompt_sha256': sha(prompt.encode('utf-8'))})
    assert len(entries) == 25
    for rnd in range(3, 7):
        assert len({e['prompt'] for e in entries if e['round'] == rnd}) == 1
    return {'source_sha256': sha(source), 'settings': SETTINGS, 'entries': entries,
            'adaptation': 'User explicitly substituted GPT-6.1 Sol via OpenRouter for DeepSeek. API histories stand in for saved UI conversations. No extra system messages or cross-chat history.',
            'settings_note': 'Medium reasoning and 16000 maximum completion tokens fixed for every call. Sampling parameters left at provider defaults. No tools or automatic retries.'}

def load_key(path):
    key = os.environ.get('OPENROUTER_API_KEY', '').strip()
    if path:
        value = Path(path).read_text(encoding='utf-8-sig').strip()
        match = re.search(r'^\s*(?:export\s+)?OPENROUTER_API_KEY\s*=\s*(.*?)\s*$', value, re.M)
        key = (match[1] if match else value).strip().strip('\"\'')
    if not key or '\n' in key:
        raise RuntimeError('No usable OpenRouter API key was supplied; no requests sent.')
    return key

def render(entries, records):
    lines = ['# Genesis seed experiment — GPT-6.1 Sol via OpenRouter', '',
             f'Completed answers: {len(records)}/25. Conversations: 9.', '',
             'Prompts and answers below are verbatim. Model: `openai/gpt-6.1-sol`; reasoning: medium; maximum completion tokens: 16000. Each conversation has its own history. No added system prompt. This is an API adaptation of the supplied DeepSeek run sheet.', '']
    for e, r in zip(entries, records):
        label = f"Round {e['round']}, chat {e['chat']}" + (f", {e['seed']}" if e['seed'] else '')
        lines += [f'## {label}', '', '### Prompt', '', '```text', e['prompt'].rstrip('\r\n'), '```', '', '### Answer', '', r['choices'][0]['message']['content'], '']
    (ROOT / 'answers.md').write_text('\n'.join(lines), encoding='utf-8')

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--key-file')
    ap.add_argument('--prepare', action='store_true')
    args = ap.parse_args()
    p = plan()
    if args.prepare:
        save(ROOT / 'plan.json', p)
        print('Prepared 25 prompts, 7 rounds, 9 separate histories; no API calls.', flush=True)
        return
    existing = json.loads((ROOT / 'plan.json').read_text(encoding='utf-8'))
    assert existing == p, 'Source or settings changed after preparation.'
    key = load_key(args.key_file)
    histories = {i: [] for i in range(1, 10)}
    records = []
    ledger = []
    calls = ROOT / 'calls'
    calls.mkdir(exist_ok=True)
    if list(calls.iterdir()):
        raise RuntimeError('Existing request evidence found; refusing implicit retry or overwrite.')
    save(ROOT / 'status.json', {'status': 'running', 'started_at': now(), 'completed': 0})
    try:
        for e in p['entries']:
            stem = f"{e['sequence']:02d}_round{e['round']}_chat{e['chat']}"
            history = histories[e['chat']]
            messages = history + [{'role': 'user', 'content': e['prompt']}]
            payload = dict(SETTINGS, messages=messages)
            body = json.dumps(payload, ensure_ascii=False).encode('utf-8')
            (calls / (stem + '.request.json')).write_bytes(body)
            started = now()
            print(f"START {e['sequence']}/25 round {e['round']} chat {e['chat']}", flush=True)
            req = urllib.request.Request('https://openrouter.ai/api/v1/chat/completions', data=body,
                  headers={'Authorization': 'Bearer ' + key, 'Content-Type': 'application/json'})
            tick = time.monotonic()
            try:
                with urllib.request.urlopen(req, timeout=600) as resp:
                    raw = resp.read()
                    http_status = resp.status
            except urllib.error.HTTPError as exc:
                raw = exc.read()
                (calls / (stem + '.error.body')).write_bytes(raw)
                raise RuntimeError(f'HTTP {exc.code}; response preserved; no retry.') from None
            (calls / (stem + '.response.json')).write_bytes(raw)
            r = json.loads(raw)
            choice = r['choices'][0]
            assert choice['finish_reason'] == 'stop', 'Incomplete response; stopping without retry.'
            assert r.get('model', '').startswith(MODEL), 'Unexpected response model.'
            content = choice['message'].get('content')
            assert isinstance(content, str) and content.strip(), 'Missing answer.'
            histories[e['chat']] = messages + [{'role': 'assistant', 'content': content}]
            records.append(r)
            row = {k: e[k] for k in ('sequence', 'round', 'chat', 'seed', 'prompt_sha256')}
            row.update(started_at=started, completed_at=now(), elapsed_seconds=time.monotonic()-tick,
                       http_status=http_status, request_sha256=sha(body), response_sha256=sha(raw),
                       response_id=r.get('id'), model=r.get('model'), provider=r.get('provider'), usage=r.get('usage'))
            ledger.append(row)
            save(ROOT / 'ledger.json', ledger)
            save(ROOT / 'conversations.json', histories)
            render(p['entries'], records)
            save(ROOT / 'status.json', {'status': 'running', 'completed': len(records), 'updated_at': now()})
            print(f"SAVED {len(records)}/25; tokens={r.get('usage', {}).get('completion_tokens')}", flush=True)
        save(ROOT / 'status.json', {'status': 'complete', 'completed': 25, 'updated_at': now(),
              'reported_cost_usd': sum((r.get('usage') or {}).get('cost', 0) or 0 for r in records)})
    except Exception as exc:
        save(ROOT / 'status.json', {'status': 'stopped', 'completed': len(records), 'updated_at': now(), 'error': str(exc)})
        raise

if __name__ == '__main__':
    main()
