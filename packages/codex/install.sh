#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"

# Keep selective Codex installs working with the shared skills package.
"$DOTFILES_DIR/packages/skills/install.sh"
