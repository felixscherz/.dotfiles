#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
if ! command -v opencode &>/dev/null; then
    curl -fsSL https://opencode.ai/install | bash
fi
mkdir -p "$HOME/.config/opencode"
stow_it opencode "$HOME/.config/opencode"
