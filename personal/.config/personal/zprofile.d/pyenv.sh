# Lazy-load pyenv to improve shell startup time (~50-100ms savings)
# pyenv will be loaded on first use
export PYENV_ROOT="$HOME/.pyenv"
addToPathFront "$PYENV_ROOT/bin"

# Add pyenv shims to PATH immediately so python/pip work
# but defer full pyenv init until first pyenv command
addToPathFront "$PYENV_ROOT/shims"

pyenv() {
    unfunction pyenv 2>/dev/null
    eval "$(command pyenv init -)"
    pyenv "$@"
}
