vim.opt.background = "dark"

-- vim.cmd("let g:lightline = {'colorscheme' : 'tokyonight'}")
-- vim.cmd("colorscheme tokyonight")

vim.cmd[[
let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox'
]]
vim.cmd("colorscheme gruvbox")

vim.cmd[[highlight CursorLine ctermbg=60 guibg=#363d59]]

-- vim.cmd[[highlight CocInlayHint guifg=#f7768e guibg=#24283b]]
-- vim.cmd[[highlight link CocInlayHintParameter CocInlayHint]]
-- vim.cmd[[highlight link CocInlayHintType CocInlayHint]]



vim.opt.cursorline = true
