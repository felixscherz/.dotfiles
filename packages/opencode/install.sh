#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
if ! command -v opencode &>/dev/null; then
    curl -fsSL https://opencode.ai/install | bash
fi
mkdir -p "$HOME/.config/opencode"
stow_it opencode "$HOME/.config/opencode"
# Company-specific providers live in the private overlay, merged via OPENCODE_CONFIG.
if [ -d "$DOTFILES_DIR/packages/private/opencode" ]; then
    stow --dir="$DOTFILES_DIR/packages/private" --target="$HOME/.config/opencode" opencode
fi
