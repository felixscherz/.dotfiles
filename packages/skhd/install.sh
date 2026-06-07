#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
is_macos || exit 0
install_package jackielii/tap/skhd-zig
stow_it skhd
skhd --start-service
