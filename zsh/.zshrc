export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

source $ZSH/antigen.zsh

antigen use oh-my-zsh
antigen bundle git
antigen bundle pip
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle jeffreytse/zsh-vi-mode
antigen bundle jsontools
antigen bundle web-search

antigen theme robbyrussell/oh-my-zsh

antigen apply

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# initiate direnv to source files properly
if [ -x "$(command -v direnv)" ]; then
    eval "$(direnv hook zsh)"
fi

if [ "$TMUX" = "" ]; then tmux; fi


source $HOME/.config/personal/alias
