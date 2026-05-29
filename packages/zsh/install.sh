#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
install_package zsh antigen
stow_it zsh
