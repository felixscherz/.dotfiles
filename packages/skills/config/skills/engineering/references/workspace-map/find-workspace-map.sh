#!/usr/bin/env bash
set -e

if [[ $# -ne 1 || ! -d "$1" ]]; then
	printf 'Usage: %s DIRECTORY\n' "$0" >&2
	exit 2
fi

directory=$(cd -P -- "$1" && pwd)

while :; do
	mapping="$directory/.felixws/WORKSPACE_MAP.md"
	if [[ -e "$mapping" || -L "$mapping" ]]; then
		printf '%s\n' "$mapping"
		exit 0
	fi
	[[ "$directory" == / ]] && break
	directory=$(dirname -- "$directory")
done

exit 1
