#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
# Claude Code only reads ~/.claude, but opencode is the source of truth. The
# files under config/ are symlinks into the opencode package, so stowing them
# into ~/.claude lets Claude see the same global AGENTS.md and skills.
mkdir -p "$HOME/.claude"
stow_it claude "$HOME/.claude"
