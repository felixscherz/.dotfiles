#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$DOTFILES_DIR/lib.sh"

bootstrap

if [[ $# -eq 0 ]]; then
    while IFS= read -r pkg; do
        [[ -z "$pkg" || "$pkg" == \#* ]] && continue
        echo "==> Installing $pkg"
        "$DOTFILES_DIR/packages/$pkg/install.sh"
    done < "$DOTFILES_DIR/packages.txt"
else
    for pkg in "$@"; do
        echo "==> Installing $pkg"
        "$DOTFILES_DIR/packages/$pkg/install.sh"
    done
fi
