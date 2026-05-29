# AGENTS.md

## Build/Install/Lint Commands
- **Install all**: `./install.sh`
- **Install specific**: `./install.sh nvim zsh tmux`
- **Lint/Format**: `pre-commit run --all-files` (runs stylua, yamlfmt, yaml/whitespace checks)
- **Format Lua only**: `stylua packages/nvim/config/.config/nvim/`

## Code Style

### Lua (packages/nvim/config/.config/nvim/)
- Formatted by StyLua (tabs, ~120 char lines)
- Plugin files return a single lazy.nvim spec table
- Autocommand groups prefixed with `custom_`
- Keymaps use `<leader>` prefix

### Shell Scripts
- Shebang: `#!/usr/bin/env bash` or `#!/usr/bin/env zsh`
- Use `set -e` for error handling, quote variables: `"$VAR"`

## Commits
- Follow Conventional Commits format (enforced by commitizen)

## Structure
- `packages/<name>/config/` — stow source (symlinked to $HOME)
- `packages/<name>/install.sh` — installs dependencies + stows config
- `lib.sh` — shared helpers (install_package, stow_it, is_macos, etc.)
- `packages.txt` — ordered list of packages for full install
