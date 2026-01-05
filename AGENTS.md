# AGENTS.md

## Build/Install/Lint Commands
- **Install**: `./install.sh` (bootstrap) or `ansible-playbook --diff main.yml`
- **Lint/Format**: `pre-commit run --all-files` (runs stylua, yamlfmt, yaml/whitespace checks)
- **Format Lua only**: `stylua nvim/`
- **Format YAML only**: `yamlfmt roles/ main.yml`

## Code Style

### Lua (nvim/)
- Formatted by StyLua (tabs, ~120 char lines)
- Plugin files return a single lazy.nvim spec table
- Autocommand groups prefixed with `custom_`
- Keymaps use `<leader>` prefix

### Shell Scripts
- Shebang: `#!/usr/bin/env bash` or `#!/usr/bin/env zsh`
- Use `set -e` for error handling, quote variables: `"$VAR"`

### YAML (Ansible)
- Use full module namespace: `ansible.builtin.command`
- Tasks require descriptive `name` fields
- Use `register` and `changed_when` for idempotency

## Commits
- Follow Conventional Commits format (enforced by commitizen)
