return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	config = function()
		require("ibl").setup({
			exclude = {
				filetypes = {
					"fugitive",
					"zsh",
					"git",
					"neo-tree",
					"lspinfo",
					"checkhealth",
					"help",
					"man",
					"conf",
					"",
				},
			},
		})
	end,
	event = { "BufReadPre", "BufNewFile" },
}
