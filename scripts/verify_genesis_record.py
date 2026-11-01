"""Verify the preserved Genesis study record without network calls or writes."""
import hashlib
import itertools
import json
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
ANCHOR_COMMIT = "1864f8671706b0aa82db2dff8feeec29d440c2fc"

def check(condition, message):
    if not condition:
        raise RuntimeError(message)

def sha(data):
    return hashlib.sha256(data).hexdigest()

def read(path):
    return json.loads(path.read_text(encoding="utf-8"))

def manifest(directory):
    lines = (directory / "SHA256SUMS").read_text(encoding="utf-8").splitlines()
    for line in lines:
        expected, relative = line.split("  ", 1)
        path = directory / relative
        check(path.resolve().is_relative_to(directory.resolve()), "Unsafe manifest path")
        check(sha(path.read_bytes()) == expected, "Manifest mismatch: " + relative)
    return len(lines)


def expected_report(entries, responses):
    """Reproduce the frozen runner's report without executing that runner."""
    lines = ["# Genesis seed experiment — GPT-6.1 Sol via OpenRouter", "",
             f"Completed answers: {len(responses)}/25. Conversations: 9.", "",
             "Prompts and answers below are verbatim. Model: `openai/gpt-6.1-sol`; reasoning: medium; maximum completion tokens: 16000. Each conversation has its own history. No added system prompt. This is an API adaptation of the supplied DeepSeek run sheet.", ""]
    for entry, response in zip(entries, responses):
        label = f"Round {entry['round']}, chat {entry['chat']}"
        if entry["seed"]:
            label += f", {entry['seed']}"
        lines += [f"## {label}", "", "### Prompt", "", "```text",
                  entry["prompt"].rstrip("\r\n"), "```", "", "### Answer", "",
                  response["choices"][0]["message"]["content"], ""]
    # The original Windows runner wrote CRLF, independent of this verifier host.
    return "\n".join(lines).replace("\n", "\r\n").encode("utf-8")

def verify_anchor(root):
    """Bind the inventory and archive to the first published Git snapshot."""
    try:
        anchored = subprocess.check_output(
            ["git", "show", f"{ANCHOR_COMMIT}:migration_inventory.json"],
            cwd=ROOT, stderr=subprocess.PIPE)
    except subprocess.CalledProcessError:
        raise RuntimeError("First-publication anchor unavailable; fetch full Git history") from None
    check((root / "migration_inventory.json").read_text(encoding="utf-8").encode("utf-8") == anchored,
          "First-publication inventory anchor mismatch")
    entries = json.loads(anchored)["files"]
    for entry in entries:
        path = root / entry["path"]
        check(sha(path.read_bytes()) == entry["sha256"],
              "First-publication archive anchor mismatch: " + entry["path"])
    return len(entries)

def verify(root=ROOT):
    root = Path(root).resolve()
    ARCHIVE = root / "evidence" / "seed_audit_2026-11-01"
    RUN = ARCHIVE / "run"
    inventory = read(root / "migration_inventory.json")
    paths = set()
    for entry in inventory["files"]:
        relative = entry["path"]
        path = root / relative
        check(path.resolve().is_relative_to(ARCHIVE.resolve()), "Unsafe inventory path")
        data = path.read_bytes()
        check(len(data) == entry["bytes"] and sha(data) == entry["sha256"],
              "Inventory mismatch: " + relative)
        paths.add(relative)
    actual = {p.relative_to(root).as_posix() for p in ARCHIVE.rglob("*") if p.is_file()}
    check(paths == actual, "Imported file inventory is incomplete")
    manifest_counts = [manifest(ARCHIVE), manifest(RUN)]
    source = (RUN / "source_protocol.md").read_bytes()
    prompts = re.findall(r"^```text\r?\n(.*?)^```",
                         source.decode("utf-8-sig"), re.M | re.S)
    plan, ledger = read(RUN / "plan.json"), read(RUN / "ledger.json")
    check(sha(source) == plan["source_sha256"], "Protocol hash mismatch")
    check(len(prompts) == len(ledger) == len(plan["entries"]) == 25, "Expected 25 calls")
    check(read(RUN / "status.json")["status"] == "complete", "Incomplete execution")
    check(len(list((RUN / "calls").iterdir())) == 50, "Unexpected call evidence")
    rounds = [r for r in range(1, 7) for _ in range(4)] + [7]
    chats = list(range(1, 5)) + list(range(5, 9)) * 5 + [9]
    histories = {str(c): [] for c in range(1, 10)}
    previous = None
    report_bytes = (RUN / "answers.md").read_bytes()
    report = report_bytes.decode("utf-8")
    responses = []
    for i, (prompt, rnd, chat) in enumerate(zip(prompts, rounds, chats), 1):
        entry, row = plan["entries"][i-1], ledger[i-1]
        for record in (entry, row):
            check((record["sequence"], record["round"], record["chat"]) == (i, rnd, chat),
                  "Sequence mismatch")
            check(record["prompt_sha256"] == sha(prompt.encode("utf-8")), "Prompt hash mismatch")
        check(entry["prompt"] == prompt, "Prompt text mismatch")
        stem = f"{i:02d}_round{rnd}_chat{chat}"
        req_bytes = (RUN / "calls" / (stem + ".request.json")).read_bytes()
        res_bytes = (RUN / "calls" / (stem + ".response.json")).read_bytes()
        check(sha(req_bytes) == row["request_sha256"], "Request hash mismatch")
        check(sha(res_bytes) == row["response_sha256"], "Response hash mismatch")
        request, response = json.loads(req_bytes), json.loads(res_bytes)
        expected = histories[str(chat)] + [{"role": "user", "content": prompt}]
        check(request["messages"] == expected, "Conversation isolation mismatch")
        check({k: v for k, v in request.items() if k != "messages"} == plan["settings"],
              "Settings mismatch")
        check(request["model"] == response["model"] == "openai/gpt-6.1-sol",
              "Model mismatch")
        check(response["provider"] == "OpenAI", "Provider mismatch")
        choice = response["choices"][0]
        check(choice["finish_reason"] == "stop", "Incomplete response")
        answer = choice["message"]["content"]
        check(isinstance(answer, str) and bool(answer.strip()), "Empty answer")
        responses.append(response)
        histories[str(chat)] = expected + [{"role": "assistant", "content": answer}]
        check(previous is None or row["started_at"] >= previous, "Calls overlap or reorder")
        previous = row["completed_at"]
    check(report_bytes == expected_report(plan["entries"], responses),
          "Report mismatch: prompt/answer association or document text changed")
    check(histories == read(RUN / "conversations.json"), "Saved history mismatch")
    check([len(histories[str(c)]) for c in range(1, 10)] == [2]*4 + [10]*4 + [2],
          "Conversation lengths mismatch")
    check(len(re.findall(r"^## Round ", report, re.M)) == 25, "Report coverage mismatch")
    audit = (ARCHIVE / "audit.md").read_text(encoding="utf-8")
    check(len([l for l in audit.splitlines() if l.startswith("| [R")]) == 25,
          "Audit coverage mismatch")
    source_chat = read(ARCHIVE / "prompt_development_chat.json")["source"]
    check(len(source_chat["turns"]) == 4 and not source_chat["page"]["hasMore"],
          "Source chat scope mismatch")

    # Independent finite checks, preserving their original scope.
    for a, b in itertools.product((0, 1), repeat=2):
        check(a ^ b == b ^ a, "Swap failed")
    reset_00 = ("RESUME", 0, 0, 0)
    reset_01 = ("RESUME", 0, 0, 0)
    check(reset_00 == reset_01 and (0 ^ 0) != (0 ^ 1), "Reset example failed")
    for deleted, zero, one, output in [
        ("a", 0, 1, 1), ("p", 0, 1, 0), ("neq", 0, 0, 0)
    ]:
        axioms = {"a": output == zero, "p": output == one, "neq": zero != one}
        check(all(v for k, v in axioms.items() if k != deleted), "Countermodel failed")
    check((2 % 2) != int(2 > 0), "Parity scope example failed")

    anchor_files = verify_anchor(root)

    # Reject accidental plaintext credentials without displaying candidate values.
    pattern = re.compile(rb"(?:sk-or-v1-|sk-proj-|ghp_|github_pat_)[A-Za-z0-9_-]{20,}")
    for path in root.rglob("*"):
        if path.is_file() and ".git" not in path.relative_to(root).parts:
            check(path.name not in (".env", ".env.local"), "Credential file in repository")
            check(not pattern.search(path.read_bytes()), "Potential credential in " + path.name)
    return {"verified": True, "imported_files": len(paths),
                      "manifest_entries": manifest_counts, "answers": 25,
                      "conversations": 9, "audit_rows": 25,
                      "binary_cases": 4, "deletion_countermodels": 3,
                      "network_calls": 0, "anchor_commit": ANCHOR_COMMIT,
                      "anchored_files": anchor_files}


if __name__ == "__main__":
    print(json.dumps(verify(), indent=2))
