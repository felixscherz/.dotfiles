## 0.2.0 (2024-04-02)

### Feat

- use ins-completion with nvim-cmp
- replace Copilot.vim with Copilot.lua
- update yabai configuration to latest feature
- pyright -> basedpyright
- add github copilot
- imporve filetype detection
- keymaps for undotree
- steal options from tjdevries
- add TS parsers
- change dotfile visibility in neo-tree
- schemastore instead of manually specifying
- Lspsaga
- replace null-ls with none-ls
- gitconfig includes work profile
- install rust
- include watson role
- aucmds to set terraform filetype
- include watson
- add global gitignore
- update neotree to 3.x
- set .gitignore
- awscli and git
- install fzf
- add npm and ripgrep
- install fd
- include more treesitter parsers
- terrafrom LSPs are included
- TS installs `Makefile` parser
- jdtls and clangd LSPs available
- reduce transparency
- more padding with yabai
- add schemas for yamlls
- keymap for go-to-type-definition
- change prettier formatting
- set alias for curl with sigv4 authentication
- **neovim**: add venv-selector.nvim plugin
- **env**: export MacOS variables on that plattform only
- **pre-commit**: install pre-commit
- **python**: install python versions
- add GNU parallel
- calculate MANWIDTH dynamically
- add jq
- add direnv
- install neovim
- install pyenv

### Fix

- change email back
- change deafault git email
- add nvim-lua as cmp source
- **yabai**: autoraise confuses me, turn it off
- correctly disable copilot
- basedpyright configuration
- change to lsp.hover from Lspsaga
- treesitter highlighting
- excludeDirs in rust-analyzer
- ignore binaries
- ruff-lsp settings
- define functions in zshrc
- ignore share and state folder nvim creates
- alacritty from yml -> toml
- source brew shellenv after installing
- yaml indentation
- error when opening markdown files due to treesitter
- enable LuaSnip again
- move direnv hook to .zshrc from .zprofile
- correctly initiate direnv
- enable fonts in tmux with alacritty
- correctly source homebrew environment
- only install clang on Linux

### Refactor

- install stow at the start
- separate oh-my-zsh from zsh
- **zsh**: clean up .zshrc and .zprofile


- update indent-blankline to version 3

## 0.1.0 (2023-10-07)

### Feat

- include pre-commit and run hooks
- include stowing of dotfiles with ansible
- install pyenv and zsh with ansible
- use antigen for zsh plugins
- add clangd as an lsp
- remove aucmds for make filetype
- add new git hotkey
- add new treesitter parsers

### Fix

- dressing.nvim with transparent background
- nvim-autopairs not initliazing
- figure out some transparency settings

### Refactor

- move dressing.nvim to separate module
- change _common.lua -> _general.lua
- change setup -> config for whichkey and indent_blankline
- move lualine to appearance
- move python settings to options.lua
- options
