#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
if ! command -v opencode &>/dev/null; then
    curl -fsSL https://opencode.ai/install | bash
fi
"$(dirname "$0")/link.sh"
