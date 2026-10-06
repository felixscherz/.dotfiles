#!/usr/bin/env bash
# run-arena.sh <arena-dir> <trials-per-variant> <benchmark-dir>...
# Runs every benchmark x layer (each directory in <arena-dir>/layers) x trial in
# parallel, with random labels. Rerun with more trials to add to an arena.
set -e

arena="$1"
trials="$2"
shift 2
if [ -z "$trials" ] || [ "$#" -eq 0 ]; then
	echo "usage: $0 <arena-dir> <trials-per-variant> <benchmark-dir>..." >&2
	exit 1
fi
here="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$arena/runs"

for benchdir in "$@"; do
	for layer in $(ls "$arena/layers"); do
		for _ in $(seq "$trials"); do
			label="run-$(openssl rand -hex 2)"
			"$here/run-trial.sh" "$arena" "$benchdir" "$layer" "$label" >"$arena/runs/.$label.log" 2>&1 &
		done
	done
done
wait
cat "$arena"/runs/.run-*.log
