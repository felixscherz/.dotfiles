return {
	{
		"folke/lazydev.nvim",
		-- ft = "lua", -- disabled this since it was causing issues when opening lua files
		enabled = true,
		event = { "VeryLazy" },
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}
