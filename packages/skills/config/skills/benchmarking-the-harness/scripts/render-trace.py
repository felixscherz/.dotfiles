#!/usr/bin/env python3
"""render-trace.py <events.jsonl> <arena-dir>: print a readable trace with the environment redacted.

The judge must not tell variants apart. Skill and reference names come from every layer in
<arena-dir>/layers. Tool calls that touch the environment are dropped without a marker (a count
of markers reveals the variant). Mentions of skill and reference names are replaced, and
<arena-dir>/redact.tsv, if present, adds `regex<TAB>replacement` rewrites for giveaway phrases.
"""

import json
import re
import sys
from pathlib import Path

ENV_PATH = re.compile(r"\.agents/skills|home/\.agents|\.config/opencode|AGENTS\.md|\.felixws")
SANDBOX = re.compile(r"(/private)?/tmp/agent-runs/[0-9a-f]+")


def environment_names(arena: Path) -> tuple[set[str], set[str]]:
    skills: set[str] = set()
    references: set[str] = set()
    for skill_dir in arena.glob("layers/*/skills/*"):
        if skill_dir.is_dir():
            skills.add(skill_dir.name)
            references.update(p.name for p in skill_dir.rglob("*") if p.is_file() and p.name != "SKILL.md")
    return skills, references


def rewrites(arena: Path) -> list[tuple[re.Pattern[str], str]]:
    path = arena / "redact.tsv"
    if not path.is_file():
        return []
    pairs = [line.split("\t", 1) for line in path.read_text().splitlines() if "\t" in line]
    return [(re.compile(pattern, re.IGNORECASE), replacement) for pattern, replacement in pairs]


def main() -> None:
    events, arena = Path(sys.argv[1]), Path(sys.argv[2])
    skills, references = environment_names(arena)
    names = "|".join(re.escape(n) for n in sorted(skills | references, key=len, reverse=True))
    mention = re.compile(rf"`?\b({names})\b`?( skill)?", re.IGNORECASE) if names else None
    extra = rewrites(arena)

    def clean(text: str) -> str:
        text = SANDBOX.sub("<workdir-parent>", text)
        if mention:
            text = mention.sub("[guidance]", text)
        for pattern, replacement in extra:
            text = pattern.sub(replacement, text)
        return text

    def short(value: object, limit: int) -> str:
        text = value if isinstance(value, str) else json.dumps(value)
        return text if len(text) <= limit else text[:limit] + f" ...[{len(text) - limit} chars cut]"

    for line in events.open():
        event = json.loads(line)
        part = event.get("part", {})
        if event["type"] == "text":
            print(f"\nASSISTANT:\n{clean(part.get('text', ''))}\n")
        elif event["type"] == "tool_use":
            tool = part.get("tool")
            state = part.get("state", {})
            raw = json.dumps(state.get("input", {}))
            output = state.get("output") or state.get("error") or ""
            touches_environment = any(
                ENV_PATH.search(text) or (mention and mention.search(text)) for text in (raw, str(output))
            )
            if tool == "skill" or touches_environment:
                continue
            print(f"TOOL {tool}: {clean(short(state.get('input', {}), 600))}")
            print(f"  => {clean(short(output, 1500))}")
        elif event["type"] == "error":
            print(f"ERROR: {clean(json.dumps(event.get('error')))}")


if __name__ == "__main__":
    main()
