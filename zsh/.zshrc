# .zshrc gets source by interactive shells
source $(brew --prefix)/share/antigen/antigen.zsh

antigen use oh-my-zsh
antigen bundle git
antigen bundle pip
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle jeffreytse/zsh-vi-mode
antigen bundle jsontools
antigen bundle web-search

antigen theme robbyrussell

antigen apply
antigen bundle-q

# make sure to start a tmux session
if [ "$TMUX" = "" ]; then tmux; fi

# initiate direnv to source files properly
if [ -x "$(command -v direnv)" ]; then
    eval "$(direnv hook zsh)"
fi
alias man='MANWIDTH=$((COLUMNS > 120 ? 120 : COLUMNS)) man'
alias cdfd='change_directory_fuzzy'
alias gitroot='cd $(git rev-parse --show-toplevel)'
alias watch-citrix="watch find ~/Downloads/ -type f -name 'Q*.ica' -exec open {} '\;'"
alias python="python3"
alias pip="pip3"


# zsh-history-substring-search configuration
bindkey '^[[A' history-substring-search-up # or '\eOA'
bindkey '^[[B' history-substring-search-down # or '\eOB'
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
zstyle ':history-substring-search:highlight' found 'fg=green,bold'

fpath+=~/.zfunc

# COMPLETIONS

autoload -Uz compinit && compinit
# Only run compinit if the dump file doesn't exist or is outdated (e.g., older than 24 hours)
ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-${ZSH_VERSION}"

if [[ -f "$ZSH_COMPDUMP" && -n "$ZSH_COMPDUMP"(Nm+24) ]]; then
  # If the dump file exists and is less than 24 hours old, load from it
  compinit -d "$ZSH_COMPDUMP"
else
  # Otherwise, generate a new dump file and save it
  compinit -C -d "$ZSH_COMPDUMP"
fi
