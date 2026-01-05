# Zsh Shell Startup Optimization

This document tracks shell startup time optimizations, current trade-offs, and future improvement opportunities.

## Baseline Performance

- **Before optimization**: ~546ms
- **After optimization**: Target <200ms

## Implemented Optimizations

### 1. NVM Lazy Loading (~800ms savings)

**File**: `personal/.config/personal/zprofile.d/nvm.sh`

**Change**: Instead of loading NVM on every shell start, NVM is loaded on first use of `nvm`, `node`, `npm`, or `npx`.

**Trade-off**: First invocation of node/npm commands has ~800ms delay while NVM loads. Subsequent calls are instant.

**Disabled features**:
- Automatic `.nvmrc` detection (`nvm_auto`) - use `nvm use` manually when entering a project with `.nvmrc`

### 2. Pyenv Lazy Loading (~50-100ms savings)

**File**: `personal/.config/personal/zprofile.d/pyenv.sh`

**Change**: Pyenv shims are added to PATH immediately, but full `pyenv init` is deferred until first `pyenv` command.

**Trade-off**: Python and pip work immediately via shims. Only `pyenv` subcommands (like `pyenv install`, `pyenv shell`) trigger the full init.

### 3. Hardcoded Homebrew Prefix (~20-50ms savings)

**File**: `zsh/.zshrc`

**Change**: Replaced `$(brew --prefix)` with `/opt/homebrew` to avoid spawning a subshell.

**Trade-off**: Path is hardcoded for Apple Silicon Macs. If migrating to Intel Mac, change to `/usr/local`.

### 4. Compinit Caching (~200-400ms savings)

**File**: `zsh/.zshrc`

**Change**:
- Fixed double-execution bug (compinit was running twice)
- Use `-C` flag to skip security checks when dump file is fresh (<24 hours)
- Cache stored in `~/.cache/zsh/zcompdump-${ZSH_VERSION}`

**Trade-off**: New completions may take up to 24 hours to appear. Force refresh with:
```bash
rm ~/.cache/zsh/zcompdump-* && exec zsh
```

## Current Trade-offs Summary

| Optimization | Savings | Trade-off |
|-------------|---------|-----------|
| NVM lazy-load | ~800ms | First node/npm call is slow; no auto .nvmrc |
| Pyenv lazy-load | ~50-100ms | First `pyenv` command is slow |
| Hardcoded brew path | ~20-50ms | Not portable to Intel Macs |
| Compinit caching | ~200-400ms | New completions delayed up to 24h |

## Future Optimization Opportunities

### High Impact

#### Switch from Antigen to zinit or sheldon
- **Estimated savings**: 100-300ms
- **Effort**: Medium
- **Details**: Antigen has significant overhead. Modern alternatives:
  - [zinit](https://github.com/zdharma-continuum/zinit) - Fast, supports lazy loading
  - [sheldon](https://github.com/rossmacarthur/sheldon) - Rust-based, very fast
  - Manual sourcing - Zero overhead but more maintenance

#### Lazy-load oh-my-zsh plugins
- **Estimated savings**: 50-200ms
- **Effort**: Medium
- **Details**: Many oh-my-zsh plugins can be lazy-loaded or removed if unused

### Medium Impact

#### Profile and optimize direnv hook
- **Estimated savings**: 10-50ms
- **Effort**: Low
- **Details**: `direnv hook zsh` runs on every prompt. Consider if needed.

#### Reduce antigen bundles
- **Estimated savings**: Variable
- **Effort**: Low
- **Details**: Each bundle adds load time. Audit which are actually used:
  - `git` - Git aliases (useful)
  - `pip` - Pip completions (useful if using pip)
  - `jsontools` - JSON utilities (rarely used?)
  - `web-search` - Search from terminal (rarely used?)

#### Use zsh-defer for non-critical init
- **Estimated savings**: Perceived startup improvement
- **Effort**: Medium
- **Details**: [zsh-defer](https://github.com/romkatv/zsh-defer) can defer non-essential initialization until after the first prompt renders.

### Low Impact / Polish

#### Compile zsh files to zwc
- **Estimated savings**: 5-20ms
- **Effort**: Low
- **Details**: `zcompile ~/.zshrc` creates bytecode cache

#### Audit PATH additions
- **Estimated savings**: ~5ms
- **Effort**: Low
- **Details**: Each `addToPath` call does string matching. Batch where possible.

## Profiling Commands

```bash
# Quick timing
time zsh -i -c exit

# Detailed function profiling
# Add to TOP of .zprofile:
zmodload zsh/zprof
# Add to END of .zshrc:
zprof

# Profile with timestamps (manual)
# Add at various points:
echo "checkpoint: $(date +%s%3N)"
```

## Reverting Changes

To revert to non-lazy NVM loading:
```bash
# nvm.sh
export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

To revert to non-lazy pyenv loading:
```bash
# pyenv.sh
addToPathFront $HOME/.pyenv/bin
eval "$(pyenv init -)"
```
