#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
if ! command -v cargo &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
if ! command -v cargo-nextest &>/dev/null; then
    curl -LsSf https://get.nexte.st/latest/mac | tar zxf - -C "${CARGO_HOME:-$HOME/.cargo}/bin"
fi
