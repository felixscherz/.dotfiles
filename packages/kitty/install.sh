#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"

# Install kitty
if is_macos; then
    if [[ ! -d "$HOME/Applications/kitty.app" ]]; then
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
    fi
    # Install nerd font
    brew install --cask font-jetbrains-mono-nerd-font 2>/dev/null || true
elif is_linux; then
    # TODO: Linux font installation not implemented
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
fi

stow_it kitty
