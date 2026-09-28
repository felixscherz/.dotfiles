#!/usr/bin/env bash
# Remove the symlinks of every package (or the given ones). Installed software
# is left in place. To move the repo: unlink.sh, move it, then link.sh.
set -e
STOW_ACTION=--delete exec "$(cd "$(dirname "$0")" && pwd)/link.sh" "$@"
