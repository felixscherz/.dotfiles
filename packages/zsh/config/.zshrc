# .zshrc gets sourced by interactive shells
source $HOME/.local/bin/antigen.zsh

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
alias opencode-work='XDG_DATA_HOME=~/.local/share/opencode-work opencode'
alias nvimty='NVIM_USE_TY=1 nvim'


# zsh-history-substring-search configuration
bindkey '^[[A' history-substring-search-up # or '\eOA'
bindkey '^[[B' history-substring-search-down # or '\eOB'
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
zstyle ':history-substring-search:highlight' found 'fg=green,bold'


# bun completions
[ -s "/Users/felixscherz/.bun/_bun" ] && source "/Users/felixscherz/.bun/_bun"
#
# # bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# custom completions dir (tools drop completion functions here, e.g. rctx).
# antigen's own compinit runs before this dir is on fpath, so run compinit
# once more here to register these. no caching gymnastics - it's ~25ms.
fpath+=~/.zfunc
autoload -Uz compinit
compinit

# opencode
export PATH=/Users/felixscherz/.opencode/bin:$PATH


unsetopt autocd
