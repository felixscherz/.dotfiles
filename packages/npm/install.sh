#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
NVM_DIR="${NVM_DIR:-$HOME/.config/nvm}"
if [[ ! -f "$NVM_DIR/nvm.sh" ]]; then
    PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash'
fi
source "$NVM_DIR/nvm.sh"
if ! nvm ls 20.11.0 &>/dev/null; then
    nvm install 20.11.0
    nvm alias default 20.11.0
fi
