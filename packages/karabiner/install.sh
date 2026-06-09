#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"

install_cask karabiner-elements
stow_it karabiner
