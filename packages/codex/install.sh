#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"

# OpenCode remains the source of truth for shared skills for now. Stow the
# compatibility link where Codex discovers global user skills.
mkdir -p "$HOME/.agents"
stow_it codex "$HOME/.agents"
