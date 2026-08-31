#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"
install_package neovim

ensure_cargo
cargo install --locked tree-sitter-cli

stow_it nvim

cat <<'EOF'

NOTE: the nvim config expects a few extra tools that are not installed here:
  - Neovim 0.12+  (apt often ships an older version; use the prebuilt release if so)
  - make          (required to build the telescope-fzf-native plugin)
  - fd            (fd-find; used by telescope for file finding)
  - C compiler    (required to compile Tree-sitter parsers)

Install them with your package manager, e.g. on Debian/Ubuntu:
  sudo apt install -y build-essential fd-find
EOF
