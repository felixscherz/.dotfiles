#!/usr/bin/env bash
# Shared helper functions for dotfiles installation

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

is_macos() {
    [[ "$(uname -s)" == "Darwin" ]]
}

is_linux() {
    [[ "$(uname -s)" == "Linux" ]]
}

install_package() {
    if is_macos; then
        brew install "$@"
    elif is_linux; then
        sudo apt install -y "$@"
    fi
}

install_cask() {
    if is_macos; then
        brew install --cask "$@"
    else
        echo "Cask installs are only supported on macOS"
        return 1
    fi
}

stow_it() {
    local pkg="$1"
    local target="${2:-$HOME}"
    stow --dir="$DOTFILES_DIR/packages/$pkg" --target="$target" config
}

bootstrap() {
    mkdir -p "$HOME/.config"
    if is_macos; then
        if ! command -v brew &>/dev/null; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        if ! command -v stow &>/dev/null; then
            brew install stow
        fi
    elif is_linux; then
        sudo apt update -y
        if ! command -v stow &>/dev/null; then
            sudo apt install -y stow
        fi
    fi
}
