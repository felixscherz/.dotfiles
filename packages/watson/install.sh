#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
install_package watson
stow_it watson
