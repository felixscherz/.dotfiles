#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
install_package llvm
if is_linux; then
    install_package clang
fi
