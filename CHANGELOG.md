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
