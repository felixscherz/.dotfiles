Nnoremap("<leader>h", ":wincmd h<CR>", { silent = true })
Nnoremap("<leader>j", ":wincmd j<CR>", { silent = true })
Nnoremap("<leader>k", ":wincmd k<CR>", { silent = true })
Nnoremap("<leader>l", ":wincmd l<CR>", { silent = true })

-- resizing
Nnoremap("<leader>.", ':exe "vertical resize " . (winwidth(0) * 3/2)<CR>', { silent = true })
Nnoremap("<leader>,", ':exe "vertical resize " . (winwidth(0) * 2/3)<CR>', { silent = true })
Nnoremap("<leader>=", ':exe "resize " . (winheight(0) * 3/2)<CR>', { silent = true })
Nnoremap("<leader>-", ':exe "resize " . (winheight(0) * 2/3)<CR>', { silent = true })

Xnoremap("<leader>p", '"_dP')

Nnoremap("Y", "yg$")
Nnoremap("n", "nzzzv")
Nnoremap("N", "Nzzzv")
Nnoremap("J", "mzJ`z")

Nnoremap("<C-d>", "<C-d>zz")
Nnoremap("<C-u>", "<C-u>zz")


