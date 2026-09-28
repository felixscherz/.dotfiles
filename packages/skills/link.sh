#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
mkdir -p "$HOME/.agents"
stow_it skills "$HOME/.agents"
