#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
# Config is company/customer-specific, so it lives in the private overlay.
stow "$STOW_ACTION" --dir="$DOTFILES_DIR/packages/private" --target="$HOME" finicky
