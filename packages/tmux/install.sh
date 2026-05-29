#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
install_package tmux
stow_it tmux
