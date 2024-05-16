return {
	"folke/which-key.nvim",
	config = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 900
		require("which-key").setup()

		local wk = require("which-key")
		wk.register({
			name = "window movement",
			h = { ":wincmd h<CR>", "move left" },
			j = { ":wincmd j<CR>", "move right" },
			k = { ":wincmd k<CR>", "move up" },
			l = { ":wincmd l<CR>", "move down" },
			["."] = { ':exe "vertical resize " . (winwidth(0) * 3/2)<CR>', "increase window width" },
			[","] = { ':exe "vertical resize " . (winwidth(0) * 2/3)<CR>', "decrease window width" },
			["="] = { ':exe "resize " . (winheight(0) * 3/2)<CR>', "increase window height" },
			["-"] = { ':exe "resize " . (winheight(0) * 2/3)<CR>', "decrease window height" },
			["<C-d"] = { "<C-d>zz", "move down" },
			["<C-u"] = { "<C-u>zz", "move up" },
		}, { prefix = "<leader>" })

		wk.register({
			name = "yank/delete",
			["Y"] = { "yg$", "cmd" },
			["n"] = { "nzzzv", "cmd" },
			["N"] = { "Nzzzv", "cmd" },
			["J"] = { "mzJ`z", "cmd" },
		})

		wk.register({
			["<leader>p"] = { '"_dP', "delete to black hole register before pasting" },
		}, { mode = "x" })
	end,
	lazy = false,
}
