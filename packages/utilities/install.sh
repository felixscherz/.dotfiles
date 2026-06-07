#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
install_package fd fzf jq parallel direnv ripgrep awscli podman docker
install_cask bitwarden
