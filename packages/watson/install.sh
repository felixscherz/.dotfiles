#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
install_package watson
# Pre-create the dir as a real directory so stow does NOT tree-fold ~/.config/watson
# into the repo. Watson rewrites frames/state on every command; those are runtime
# data (gitignored), not config, and must stay local instead of being tracked.
mkdir -p "$HOME/.config/watson"
stow_it watson
