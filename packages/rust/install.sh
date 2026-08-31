#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
ensure_cargo
if ! command -v cargo-nextest &>/dev/null; then
    curl -LsSf https://get.nexte.st/latest/mac | tar zxf - -C "${CARGO_HOME:-$HOME/.cargo}/bin"
fi
