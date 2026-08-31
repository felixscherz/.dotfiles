#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"

NVIM_VERSION="0.12.2"

if is_macos; then
	install_package neovim
elif is_linux; then
	if [[ "$(uname -m)" != "x86_64" ]]; then
		echo "Neovim $NVIM_VERSION does not provide an Ubuntu release package for $(uname -m)" >&2
		exit 1
	fi

	(
		nvim_tmp_dir="$(mktemp -d)"
		trap 'rm -rf "$nvim_tmp_dir"' EXIT

		nvim_asset="nvim-linux-x86_64.deb"
		nvim_url="https://github.com/neovim/neovim-releases/releases/download/v${NVIM_VERSION}/${nvim_asset}"
		curl -fL --retry 3 --output "$nvim_tmp_dir/$nvim_asset" "$nvim_url"

		# apt downloads local packages as the _apt user when possible.
		chmod 755 "$nvim_tmp_dir"
		chmod 644 "$nvim_tmp_dir/$nvim_asset"
		sudo apt install -y "$nvim_tmp_dir/$nvim_asset"
	)
fi

ensure_cargo
cargo install --locked tree-sitter-cli

stow_it nvim

cat <<'EOF'

NOTE: the nvim config expects a few extra tools that are not installed here:
  - make          (required to build the telescope-fzf-native plugin)
  - fd            (fd-find; used by telescope for file finding)
  - C compiler    (required to compile Tree-sitter parsers)

Install them with your package manager, e.g. on Debian/Ubuntu:
  sudo apt install -y build-essential fd-find
EOF
