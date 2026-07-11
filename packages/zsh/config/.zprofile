# zmodload zsh/zprof
# .zprofile gets sourced at startup
export XDG_CONFIG_HOME=$HOME/.config
export EDITOR="nvim"
export MANPAGER='nvim +Man!'

# Merge the private opencode config (company providers) on top of the public one,
# only when the private overlay is present on this machine.
[ -f "$HOME/.config/opencode/opencode.private.json" ] && export OPENCODE_CONFIG="$HOME/.config/opencode/opencode.private.json"

export PATH=$(getconf PATH)


addToPath() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$PATH:$1
    fi
}

addToPathFront() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$1:$PATH
    fi
}

# source specific configuration
PERSONAL=$XDG_CONFIG_HOME/personal
for _f in $PERSONAL/zprofile.d/*; do source $_f; done
unset _f
unset PERSONAL

addToPathFront $HOME/.local/scripts
addToPathFront $HOME/.local/bin
