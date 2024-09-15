# .zprofile gets sourced at startup
export XDG_CONFIG_HOME=$HOME/.config
export EDITOR="nvim"
export MANPAGER='nvim +Man!'

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
for f in $PERSONAL/*; do source $f; done

addToPathFront $HOME/.local/scripts
addToPathFront $HOME/.local/bin
