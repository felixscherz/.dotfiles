#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"

install_cask karabiner-elements
"$(dirname "$0")/link.sh"
