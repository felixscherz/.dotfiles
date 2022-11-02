local Remap = require("felixws.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local nmap = Remap.nmap

nnoremap("<leader>pv", "<cmd>NERDTree<CR>")

xnoremap("<leader>p", '"_dP')


nnoremap("<leader>h", ":wincmd h<CR>", {silent = true})
nnoremap("<leader>j", ":wincmd j<CR>", {silent = true})
nnoremap("<leader>k", ":wincmd k<CR>", {silent = true})
nnoremap("<leader>l", ":wincmd l<CR>", {silent = true})

nnoremap("Y", "yg$")
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")
nnoremap("J", "mzJ`z")


nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")

-- nmap("<leader>nf", ":call CocAction('format')<CR>")
-- nmap("<leader>ns", ":CocCommand python.sortImports<CR>")
-- nnoremap("<leader>u", ":call CocAction('diagnosticPrevious')<CR>")
-- nnoremap("<leader>d", ":call CocAction('diagnosticNext')<CR>")

nnoremap("gdh", ":diffget //2<CR>")
nnoremap("gdl", ":diffget //3<CR>")


local builtin = require('telescope.builtin')
nnoremap("<leader>ff", builtin.find_files)
nnoremap("<leader>fg", builtin.live_grep)
nnoremap("<leader>fb", builtin.buffers)
nnoremap("<leader>fh", builtin.help_tags)


-- nmap("<leader>rn", "<Plug>(coc-rename)")


-- resizing
nnoremap("<leader>.", ':exe "vertical resize " . (winwidth(0) * 3/2)<CR>', {silent = true})
nnoremap("<leader>,", ':exe "vertical resize " . (winwidth(0) * 2/3)<CR>', {silent = true})
nnoremap("<leader>=", ':exe "resize " . (winheight(0) * 3/2)<CR>', {silent = true})
nnoremap("<leader>-", ':exe "resize " . (winheight(0) * 2/3)<CR>', {silent = true})

