#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
if ! command -v pre-commit &>/dev/null; then
    pipx install pre-commit
fi
