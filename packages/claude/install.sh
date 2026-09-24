#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
# Share global instructions from the opencode package and skills from the
# dedicated skills package through the symlinks under config/.
mkdir -p "$HOME/.claude"
stow_it claude "$HOME/.claude"
