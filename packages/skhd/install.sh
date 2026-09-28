#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
is_macos || exit 0
install_package jackielii/tap/skhd-zig
"$(dirname "$0")/link.sh"
skhd --start-service
