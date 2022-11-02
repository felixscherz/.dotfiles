require("tokyonight").setup({
    transparent=true
})

vim.cmd("colorscheme tokyonight")

vim.api.nvim_set_hl(0, "Search", {link = "IncSearch"})
