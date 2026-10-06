#!/usr/bin/env bash
# global-layer.sh <layer-dir>
# Snapshots the user's skills and opencode config into <layer-dir>/{skills,config},
# resolving symlinks and stripping the benchmarking skills and other leaks.
set -e

dest="$1"
if [ -z "$dest" ]; then
	echo "usage: $0 <layer-dir>" >&2
	exit 1
fi
skills="${SKILLS_DIR:-$HOME/.agents/skills}"
config="${OPENCODE_DIR:-$HOME/.config/opencode}"

mkdir -p "$dest/skills" "$dest/config"
rsync -aL \
	--exclude 'benchmarking-the-harness' \
	--exclude 'create-benchmark' \
	--exclude 'benchmark-*' \
	--exclude 'synced' \
	"$skills/" "$dest/skills/"
for entry in opencode.json AGENTS.md agents; do
	if [ -e "$config/$entry" ]; then
		cp -RL "$config/$entry" "$dest/config/"
	fi
done

if grep -rlIiE '\b(benchmark|rubric|arena)\b' "$dest" >/dev/null; then
	echo "check these files for leaks:" >&2
	grep -rlIiE '\b(benchmark|rubric|arena)\b' "$dest" >&2
fi
