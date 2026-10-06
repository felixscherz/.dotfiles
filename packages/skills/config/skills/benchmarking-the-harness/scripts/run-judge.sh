#!/usr/bin/env bash
# run-judge.sh <arena-dir> <benchmark-dir>
# Scores every trial of one benchmark in a single pass, in an empty environment.
# Writes <arena-dir>/verdict-<benchmark>.json; an existing verdict is archived first.
set -e

arena="$1"
benchdir="$2"
if [ -z "$benchdir" ]; then
	echo "usage: $0 <arena-dir> <benchmark-dir>" >&2
	exit 1
fi
here="$(cd "$(dirname "$0")" && pwd)"
bench="$(basename "$benchdir")"
model="${JUDGE_MODEL:-${MODEL:-github-copilot/gpt-6-luna}}"
opencode_bin="$(command -v opencode)"

root="/tmp/agent-runs/$(openssl rand -hex 4)"
home="$root/home"
review="$root/review"
mkdir -p "$home/.config/opencode" "$home/.local/share/opencode" "$review"
sqlite3 "$arena/seed/.local/share/opencode/opencode.db" ".backup '$home/.local/share/opencode/opencode.db'"
printf '{"$schema":"https://opencode.ai/config.json","share":"disabled","update":"disable"}\n' \
	>"$home/.config/opencode/opencode.json"

cp "$benchdir/task.md" "$benchdir/rubric.md" "$benchdir/reference.patch" "$review/"
# Only the criteria go to the judge; trace expectations are for the coordinator.
sed -i.bak '/^## Trace expectations/,$d' "$review/rubric.md" && rm "$review/rubric.md.bak"
labels=$(awk -F'\t' -v b="$bench" '$2 == b {print $1}' "$arena/key.tsv" | sort)
for label in $labels; do
	mkdir -p "$review/$label"
	python3 "$here/render-trace.py" "$arena/runs/$label/events.jsonl" "$arena" >"$review/$label/trace.txt"
	cp "$arena/runs/$label/diff.patch" "$review/$label/diff.patch"
done

prompt="You are grading how well several coding agents handled the same task. Everything is in $review:
- task.md: the request each agent received, word for word
- rubric.md: the criteria, each scored 0, 1 or 2 with anchors
- reference.patch: one accepted solution; other approaches that meet the criteria score the same
- one directory per agent ($(echo $labels | tr '\n' ' ')), each with trace.txt (what the agent did and said, in order) and diff.patch (its final change to the repository)

Read every file before scoring. Score every agent against every criterion on the same scale, in one pass, following the anchors literally. Ground each score in the trace or diff, citing what you saw. Do not reward length or style.

Write the verdict to $review/verdict.json as {\"<label>\": {\"<criterion number>\": {\"score\": 0|1|2, \"why\": \"...\"}}}, then reply with a table of labels x criteria and two sentences per agent on its strongest and weakest point."

out="$arena/verdict-$bench.json"
if [ -f "$out" ]; then
	mkdir -p "$arena/archive"
	mv "$out" "$arena/archive/verdict-$bench.$(date +%Y%m%d-%H%M%S).json"
fi

(
	cd "$review"
	env HOME="$home" \
		XDG_CONFIG_HOME="$home/.config" \
		XDG_DATA_HOME="$home/.local/share" \
		XDG_STATE_HOME="$home/.local/state" \
		XDG_CACHE_HOME="$home/.cache" \
		OPENCODE_CONFIG_DIR="$home/.config/opencode" \
		"$opencode_bin" run --standalone --auto -m "$model" --format json "$prompt"
) >"$arena/judge-$bench.events.jsonl" 2>"$arena/judge-$bench.stderr.log"

cp "$review/verdict.json" "$out"
jq -r 'select(.type=="text") | .part.text' "$arena/judge-$bench.events.jsonl" | tail -40
