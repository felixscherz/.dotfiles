#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"

install_cask finicky
# Config is company/customer-specific, so it lives in the private overlay.
stow --dir="$DOTFILES_DIR/packages/private" --target="$HOME" finicky
