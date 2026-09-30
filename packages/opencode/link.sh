#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
mkdir -p "$HOME/.config/opencode"
stow_it opencode "$HOME/.config/opencode"
