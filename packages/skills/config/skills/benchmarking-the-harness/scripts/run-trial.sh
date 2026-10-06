#!/usr/bin/env bash
# run-trial.sh <arena-dir> <benchmark-dir> <layer> <label>
# Builds a sandbox under /tmp/agent-runs/<id>, runs one headless opencode session
# in it, and stores the trace, diff and session db under <arena-dir>/runs/<label>.
set -e

arena="$1"
benchdir="$2"
layer="$3"
label="$4"
if [ -z "$label" ]; then
	echo "usage: $0 <arena-dir> <benchmark-dir> <layer> <label>" >&2
	exit 1
fi
bench="$(basename "$benchdir")"
repo="$(cat "$benchdir/fixture/repo-name")"
model="${MODEL:-github-copilot/gpt-6-luna}"
opencode_bin="$(command -v opencode)"

root="/tmp/agent-runs/$(openssl rand -hex 4)"
home="$root/home"
work="$root/$repo"
rec="$arena/runs/$label"
mkdir -p "$home/.agents" "$home/.config" "$home/.local/share/opencode" "$rec"

"$benchdir/fixture/setup.sh" "$work"
cp -R "$arena/layers/$layer/skills" "$home/.agents/skills"
cp -R "$arena/layers/$layer/config" "$home/.config/opencode"
# Arena-only login (seed/), copied consistently including the WAL.
sqlite3 "$arena/seed/.local/share/opencode/opencode.db" ".backup '$home/.local/share/opencode/opencode.db'"
git config --file "$home/.gitconfig" user.name "$(git config --global user.name)"
git config --file "$home/.gitconfig" user.email "$(git config --global user.email)"

# Starting state, tracked outside the sandbox so the diff includes untracked files.
git --git-dir="$rec/pre.git" init --quiet
git --git-dir="$rec/pre.git" --work-tree="$work" add -A
git --git-dir="$rec/pre.git" --work-tree="$work" -c user.name=x -c user.email=x commit --quiet -m pre

printf '%s\t%s\t%s\t%s\n' "$label" "$bench" "$layer" "$root" >>"$arena/key.tsv"

start=$(date +%s)
(
	cd "$work"
	env HOME="$home" \
		XDG_CONFIG_HOME="$home/.config" \
		XDG_DATA_HOME="$home/.local/share" \
		XDG_STATE_HOME="$home/.local/state" \
		XDG_CACHE_HOME="$home/.cache" \
		OPENCODE_CONFIG_DIR="$home/.config/opencode" \
		CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}" \
		RUSTUP_HOME="${RUSTUP_HOME:-$HOME/.rustup}" \
		"$opencode_bin" run --standalone --auto -m "$model" --format json "$(cat "$benchdir/task.md")"
) >"$rec/events.jsonl" 2>"$rec/stderr.log" || echo "opencode exited $?" >>"$rec/stderr.log"
echo $(($(date +%s) - start)) >"$rec/seconds"

git --git-dir="$rec/pre.git" --work-tree="$work" add -A
git --git-dir="$rec/pre.git" --work-tree="$work" diff --cached HEAD >"$rec/diff.patch"
cp "$home/.local/share/opencode/opencode.db" "$rec/opencode.db" 2>/dev/null || true
echo "$label done in $(cat "$rec/seconds")s: $root"
