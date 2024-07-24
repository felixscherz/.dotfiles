return {
	"folke/which-key.nvim",
	config = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 900
		require("which-key").setup()

		local wk = require("which-key")
		wk.add({
			{
				name = "window movement",
				{ "<leader>h", ":wincmd h<CR>", desc = "move left" },
				{ "<leader>j", ":wincmd j<CR>", desc = "move right" },
				{ "<leader>k", ":wincmd k<CR>", desc = "move up" },
				{ "<leader>l", ":wincmd l<CR>", desc = "move down" },
				{ "<leader>.", ':exe "vertical resize " . (winwidth(0) * 3/2)<CR>', desc = "increase window width" },
				{ "<leader>,", ':exe "vertical resize " . (winwidth(0) * 2/3)<CR>', desc = "decrease window width" },
				{ "<leader>=", ':exe "resize " . (winheight(0) * 3/2)<CR>', desc = "increase window height" },
				{ "<leader>-", ':exe "resize " . (winheight(0) * 2/3)<CR>', desc = "decrease window height" },
				{ "<C-d>", "<C-d>zz", desc = "move down" },
				{ "<C-u>", "<C-u>zz", desc = "move up" },
			},
			{
				name = "yank/delete/paste",
				{ "Y", "yg$" },
				{ "n", "nzzzv" },
				{ "N", "Nzzzv" },
				{ "J", "mzJ`z" },
				{ "<leader>p", '"_dP', desc = "delete to black hole register before pasting", mode = "x" },
			},
		})
	end,
	lazy = false,
}
