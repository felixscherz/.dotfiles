#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"

install_cask bitwarden
install_package bitwarden-cli
