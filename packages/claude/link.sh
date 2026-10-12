#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
# Share global instructions from the opencode package through the symlink under
# config/. Skills are installed from the separate skills repo.
mkdir -p "$HOME/.claude"
stow_it claude "$HOME/.claude"
