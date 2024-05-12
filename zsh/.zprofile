# .zprofile gets sourced at startup
export XDG_CONFIG_HOME=$HOME/.config
export EDITOR="nvim"
export MANPAGER='nvim +Man!'

PERSONAL=$XDG_CONFIG_HOME/personal
source $PERSONAL/functions
source $PERSONAL/paths
source $PERSONAL/env

# Set PATH, MANPATH, etc., for Homebrew.
if ! [ -f "/opt/homebrew/bin/brew)" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# initiate direnv to source files properly
if [ -x "$(command -v direnv)" ]; then
    eval "$(direnv hook zsh)"
fi

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export WATSON_DIR=$XDG_CONFIG_HOME/watson
[ -f ~/.cargo/env ] && source $HOME/.cargo/env
