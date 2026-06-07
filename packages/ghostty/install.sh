#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"

if is_macos; then
    install_cask ghostty
    # Install nerd font
    brew install --cask font-jetbrains-mono-nerd-font 2>/dev/null || true
fi

stow_it ghostty
