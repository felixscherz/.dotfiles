# Lazy-load NVM to improve shell startup time (~800ms savings)
# NVM will be loaded on first use of nvm, node, npm, or npx
export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"

_load_nvm() {
    unfunction nvm node npm npx 2>/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

nvm() {
    _load_nvm
    nvm "$@"
}

node() {
    _load_nvm
    node "$@"
}

npm() {
    _load_nvm
    npm "$@"
}

npx() {
    _load_nvm
    npx "$@"
}
