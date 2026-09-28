#!/usr/bin/env bash
# Create the symlinks of every package (or the given ones) without installing
# any software. unlink.sh runs this with STOW_ACTION=--delete to remove them.
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
export STOW_ACTION="${STOW_ACTION:---stow}"
if [[ "$STOW_ACTION" == --delete ]]; then verb=Unlinking; else verb=Linking; fi

if [[ $# -eq 0 ]]; then
    # Every package, not just packages.txt, so links from selective installs are covered.
    for link in "$DOTFILES_DIR"/packages/*/link.sh; do
        echo "==> $verb $(basename "$(dirname "$link")")"
        "$link"
    done
else
    for pkg in "$@"; do
        echo "==> $verb $pkg"
        "$DOTFILES_DIR/packages/$pkg/link.sh"
    done
fi
