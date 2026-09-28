#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
is_macos || exit 0
install_cask nikitabobko/tap/aerospace
"$(dirname "$0")/link.sh"
