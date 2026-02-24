# Implementation Plan: Replace pyenv with uv

**ID**: 001-replace-pyenv-with-uv
**Status**: Proposed
**Created**: 2025-02-24
**Author**: opencode

## Overview

Replace pyenv with uv as the Python package manager and version manager. uv is a modern, Rust-based Python package manager that is significantly faster than pyenv and provides unified tooling for Python version management, package installation, and virtual environment management.

## Motivation

- **Performance**: uv is ~10-100x faster than pip and pyenv
- **Simplicity**: Single tool replaces pyenv, pip, pipx, and venv
- **Modern design**: Better dependency resolution, caching, and lock files
- **Reduced complexity**: No shims, no PATH manipulation on first use
- **Faster shell startup**: Eliminate lazy-loading logic for pyenv

## Current State

- **Python versions**: 3.9.14, 3.10.7, 3.11.3 (pre-installed via pyenv)
- **Package manager**: pipx for installing Python CLI tools
- **Shell config**: `personal/.config/personal/zprofile.d/pyenv.sh` with lazy-loading
- **Ansible role**: `roles/pyenv/` handles installation and setup

## Decisions

1. **Installation method**: Official uv installer script (https://astral.sh/uv/install.sh)
2. **Python versions**: On-demand installation (no pre-installed versions)
3. **pipx replacement**: Use `uv tool install` instead of pipx

## Changes Required

### 1. Create New Files

#### `roles/uv/tasks/main.yml`
```yaml
- name: Check if uv installed
  ansible.builtin.stat:
    path: "{{ ansible_user_dir }}/.local/bin/uv"
  register: uv_install
- name: Download uv installer
  ansible.builtin.get_url:
    url: https://astral.sh/uv/install.sh
    dest: /tmp/uv_install.sh
    mode: '0755'
  when: not uv_install.stat.exists
- name: Install uv
  ansible.builtin.command: /tmp/uv_install.sh
  when: not uv_install.stat.exists
  changed_when: not uv_install.stat.exists
```

#### `personal/.config/personal/zprofile.d/uv.sh`
```bash
# Add uv to PATH
addToPathFront "$HOME/.local/bin"
```

### 2. Modify Existing Files

#### `group_vars/all.yml`
**Before** (line 14):
```yaml
components:
  - llvm
  - zsh
  - parallel
  - tmux
  - environment
  - kitty
  - pyenv
  - precommit
```

**After**:
```yaml
components:
  - llvm
  - zsh
  - parallel
  - tmux
  - environment
  - kitty
  - uv
  - precommit
```

#### `docs/SHELL_OPTIMIZATION.md`
- Remove section "Pyenv Lazy Loading (~50-100ms savings)" (lines 23-29)
- Remove row from trade-offs table (line 58):
  ```markdown
  | Pyenv lazy-load | ~50-100ms | First `pyenv` command is slow |
  ```
- Remove pyenv reversion instructions (lines 138-143)

#### `CHANGELOG.md`
Add entry:
```markdown
- [YYYY-MM-DD] Replace pyenv with uv for Python management
```

### 3. Delete Files/Directories

- `roles/pyenv/` (entire directory)
- `personal/.config/personal/zprofile.d/pyenv.sh`

## Implementation Steps

1. **Create uv Ansible role**
   ```bash
   mkdir -p roles/uv/tasks
   # Create roles/uv/tasks/main.yml
   ```

2. **Create shell config for uv**
   ```bash
   # Create personal/.config/personal/zprofile.d/uv.sh
   ```

3. **Update Ansible configuration**
   ```bash
   # Edit group_vars/all.yml - replace pyenv with uv
   ```

4. **Update documentation**
   ```bash
   # Edit docs/SHELL_OPTIMIZATION.md
   # Edit CHANGELOG.md
   ```

5. **Remove pyenv artifacts**
   ```bash
   rm -rf roles/pyenv
   rm personal/.config/personal/zprofile.d/pyenv.sh
   ```

6. **Test the migration**
   ```bash
   # Run the Ansible playbook
   ansible-playbook -i inventory.yml main.yml

   # Verify uv installation
   uv --version
   uv python list

   # Test Python on-demand installation
   uv python install 3.12
   ```

7. **Clean up (manual, after successful migration)**
   ```bash
   # Remove pyenv installation and data
   rm -rf ~/.pyenv

   # Uninstall pipx if installed via brew (optional)
   brew uninstall pipx
   ```

## Rollback Plan

If issues arise, rollback steps:

1. **Restore pyenv role**
   ```bash
   git checkout roles/pyenv/
   git checkout personal/.config/personal/zprofile.d/pyenv.sh
   ```

2. **Restore group_vars/all.yml**
   ```bash
   git checkout group_vars/all.yml
   ```

3. **Restore documentation**
   ```bash
   git checkout docs/SHELL_OPTIMIZATION.md
   git checkout CHANGELOG.md
   ```

4. **Reinstall pyenv**
   ```bash
   ansible-playbook -i inventory.yml main.yml --tags pyenv
   ```

## Migration Guide for Users

### Before migration
```bash
# Install Python version
pyenv install 3.12.0
pyenv global 3.12.0

# Install a CLI tool
pipx install black
```

### After migration
```bash
# Python is installed on-demand automatically, or specify version
uv python install 3.12.0

# Set Python version for a project (preferred)
echo "python >=3.12" > pyproject.toml
uv sync

# Install a CLI tool
uv tool install black
```

### Virtual environments

#### Before (pyenv-virtualenv)
```bash
pyenv virtualenv 3.12.0 myproject
pyenv activate myproject
```

#### After (uv)
```bash
cd myproject
uv venv
source .venv/bin/activate
# Or use uv run for automatic activation
uv run python script.py
```

## Testing Checklist

- [ ] Ansible playbook runs without errors
- [ ] `uv --version` outputs version information
- [ ] `uv python list` lists available Python versions
- [ ] Shell startup time improved (measure with `time zsh -i -c exit`)
- [ ] No pyenv-related errors in shell startup
- [ ] Can install Python version on-demand: `uv python install 3.12`
- [ ] Can create virtual environment: `uv venv`
- [ ] Can install tools: `uv tool install ruff`
- [ ] Existing projects with `.python-version` still work (uv respects this)

## Post-Migration Tasks

1. **Update any scripts** that reference pyenv
   ```bash
   rg "pyenv" ~/scripts/ ~/projects/
   ```

2. **Remove pyenv from CI/CD pipelines** (if applicable)

3. **Update project documentation** that references pyenv setup

4. **Consider updating AGENTS.md** if there are any pyenv-related commands

## Estimated Impact

- **Shell startup**: Save ~50-100ms (pyenv lazy-load overhead)
- **Python setup time**: Faster (no pre-installed versions, on-demand only)
- **Disk usage**: Reduce by ~3GB (pre-installed Python versions)
- **Initial migration time**: ~15-30 minutes

## References

- [uv documentation](https://docs.astral.sh/uv/)
- [uv installation](https://docs.astral.sh/uv/getting-started/installation/)
- [uv vs pyenv](https://docs.astral.sh/uv/concepts/installers/)
- [uv tool usage](https://docs.astral.sh/uv/guides/tools/)
