#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
# Stow global .gitignore
stow_it git
# Stow private .gitconfig
stow --dir="$DOTFILES_DIR/packages/private" --target="$HOME" git
