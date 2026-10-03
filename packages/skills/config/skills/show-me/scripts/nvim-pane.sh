#!/usr/bin/env bash
# Drive a Neovim instance in a tmux pane next to the agent's pane.
#
#   nvim-pane.sh open [dir]   start the viewer (or reuse a running one), print its socket
#   nvim-pane.sh cmd <ex>     run one Ex command, exit non-zero on error
#   nvim-pane.sh eval <expr>  print the value of a Vimscript expression
#   nvim-pane.sh lua          run Lua read from stdin, print what it print()s, exit non-zero on error
#   nvim-pane.sh close        quit the viewer (refuses if the user has unsaved changes)
set -euo pipefail

if [[ -z "${TMUX:-}" || -z "${TMUX_PANE:-}" ]]; then
	echo "not running inside tmux" >&2
	exit 1
fi

tmp="${TMPDIR:-/tmp}"
tmp="${tmp%/}"
# one viewer per agent pane, so parallel agent sessions do not share a viewer
sock="$tmp/show-me-${TMUX_PANE#%}.sock"

alive() {
	[[ -S "$sock" ]] && nvim --server "$sock" --remote-expr 1 >/dev/null 2>&1
}

require_alive() {
	if ! alive; then
		echo "no viewer running, start one with: nvim-pane.sh open" >&2
		exit 1
	fi
}

# Quote a string as a Vimscript literal: single quotes, with ' doubled.
vim_string() {
	printf "'%s'" "${1//\'/\'\'}"
}

remote_lua="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/remote.lua"

# Call a function from remote.lua in the viewer and print its result. The first line of
# the result is "ok" or "error"; an error goes to stderr and makes the script fail.
run_remote() {
	local fn="$1" arg="$2" result status
	result="$(nvim --server "$sock" --remote-expr \
		"luaeval('dofile(_A[1]).$fn(_A[2])', [$(vim_string "$remote_lua"), $(vim_string "$arg")])")"
	status="${result%%$'\n'*}"
	# $(...) drops trailing newlines, so a result without output is just the status line
	if [[ "$result" == *$'\n'* ]]; then
		result="${result#*$'\n'}"
	else
		result=""
	fi
	if [[ "$status" != ok ]]; then
		printf '%s\n' "$result" >&2
		exit 1
	fi
	if [[ -n "$result" ]]; then
		printf '%s\n' "$result"
	fi
}

case "${1:-}" in
open)
	if alive; then
		echo "$sock"
		exit 0
	fi
	rm -f "$sock"
	dir="${2:-$PWD}"
	# -d keeps focus in the agent's pane; -t splits the agent's window, not whichever window is active
	tmux split-window -h -d -t "$TMUX_PANE" -c "$dir" "nvim --listen '$sock'"
	for _ in $(seq 50); do
		if alive; then
			echo "$sock"
			exit 0
		fi
		sleep 0.1
	done
	echo "nvim did not start listening on $sock" >&2
	exit 1
	;;
cmd)
	shift
	require_alive
	run_remote ex "$*"
	;;
eval)
	shift
	require_alive
	nvim --server "$sock" --remote-expr "$*"
	echo
	;;
lua)
	require_alive
	file="$(mktemp "$tmp/show-me.XXXXXX")"
	trap 'rm -f "$file"' EXIT
	cat >"$file"
	run_remote lua "$file"
	;;
close)
	if alive; then
		nvim --server "$sock" --remote-send '<C-\><C-n>:qa<CR>'
	fi
	;;
*)
	sed -n '2,9p' "$0" >&2
	exit 1
	;;
esac
