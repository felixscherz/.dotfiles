#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"

install_package zsh

ANTIGEN_DIR="$HOME/.local/bin"
ANTIGEN_FILE="$ANTIGEN_DIR/antigen.zsh"

if [ ! -f "$ANTIGEN_FILE" ]; then
    echo "Antigen not found. Installing..."
    mkdir -p "$ANTIGEN_DIR"
    curl -L git.io/antigen -o "$ANTIGEN_FILE"
else
    echo "Antigen is already installed at $ANTIGEN_FILE. Skipping download."
fi

stow_it zsh
