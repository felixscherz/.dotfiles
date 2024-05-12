# .zshrc gets source by interactive shells
source $(brew --prefix)/share/antigen/antigen.zsh

antigen use oh-my-zsh
antigen bundle git
antigen bundle pip
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle jeffreytse/zsh-vi-mode
antigen bundle jsontools
antigen bundle web-search

antigen theme robbyrussell

antigen apply

# make sure to start a tmux session
if [ "$TMUX" = "" ]; then tmux; fi

source $HOME/.config/personal/alias
