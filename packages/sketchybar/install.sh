#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
is_macos || exit 0
install_package felixkratz/formulae/sketchybar
"$(dirname "$0")/link.sh"
