#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"

export FNM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/fnm"

if ! command -v fnm &>/dev/null; then
    if is_macos; then
        install_package fnm
    else
        curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/bin" --skip-shell
    fi
fi

eval "$(fnm env)"

if ! fnm list | grep -q 'v24'; then
    fnm install 24
fi
fnm default 24
