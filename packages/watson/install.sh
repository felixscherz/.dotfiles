#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
install_package watson
"$(dirname "$0")/link.sh"
