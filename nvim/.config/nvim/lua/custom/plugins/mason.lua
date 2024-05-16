return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		config = function(_, opts)
			require("mason").setup(opts)
		end,
		opts = {
			ui = {
				border = "rounded",
				icons = {
					package_installed = "◍",
					package_pending = "◍",
					package_uninstalled = "◍",
				},
			},
			log_level = vim.log.levels.INFO,
			max_concurrent_installers = 4,
		},
	}, -- simple to use language server installer
	{ "williamboman/mason-lspconfig.nvim" },
}
