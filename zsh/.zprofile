# .zprofile gets sourced at startup
export XDG_CONFIG_HOME=$HOME/.config
export EDITOR="nvim"
export MANPAGER='nvim +Man!'

PERSONAL=$XDG_CONFIG_HOME/personal
source $PERSONAL/functions
source $PERSONAL/paths
source $PERSONAL/env

# initiate direnv to source files properly
if [ -x "$(command -v direnv)" ]; then
    eval "$(direnv hook zsh)"
fi

export WATSON_DIR=$XDG_CONFIG_HOME/watson
[ -f ~/.cargo/env ] && source $HOME/.cargo/env
