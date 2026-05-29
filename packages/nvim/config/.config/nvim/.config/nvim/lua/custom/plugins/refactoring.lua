return {
	"ThePrimeagen/refactoring.nvim",
	keys = { { "<leader>rr", mode = "v" } },
	dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
	config = function(_, opts)
		require("refactoring").setup(opts)
		local wk = require("which-key")

		wk.add({
			{
				"<leader>rr",
				":lua require('refactoring').select_refactor()<CR>",
				mode = "v",
				silent = true,
				noremap = true,
				expr = false,
			},
		})
	end,
	event = "BufReadPre",
}
