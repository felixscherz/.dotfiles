#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
# ~/AGENTS.md holds the global instructions shared by every harness. The claude
# and opencode packages link their own instruction files to config/AGENTS.md.
stow_it agents "$HOME"
