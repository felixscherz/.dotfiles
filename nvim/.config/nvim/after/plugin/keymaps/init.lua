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

nmap("<leader>nf", ":call CocAction('format')<CR>")
nmap("<leader>ns", ":CocCommand python.sortImports<CR>")

nnoremap("gdh", ":diffget //2<CR>")
nnoremap("gdl", ":diffget //3<CR>")

nnoremap("<leader>q", ":Spotify<CR>")


local builtin = require('telescope.builtin')
nnoremap("<leader>ff", builtin.find_files)
nnoremap("<leader>fg", builtin.live_grep)
nnoremap("<leader>fb", builtin.buffers)
nnoremap("<leader>fh", builtin.help_tags)


nmap("<leader>rn", "<Plug>(coc-rename)")


-- resizing
nnoremap("<leader>.", ":vertical resize +5<CR>", {silent = true})
nnoremap("<leader>,", ":vertical resize -5<CR>", {silent = true})
nnoremap("<leader>=", ":resize +5<CR>", {silent = true})
nnoremap("<leader>-", ":resize -5<CR>", {silent = true})
