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
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "VimEnter",
    config = function()
      require("mason-tool-installer").setup({
        -- filter drops packages whose host tool (npm/go/python3/unzip) is not
        -- installed, so a fresh box doesn't get spammed with spawn errors.
        ensure_installed = require("custom.mason_requirements").filter({
          "prettier",
          "jq",
          "yamlfmt",
          "stylua",
          "ktfmt",
          "yamllint",
          "gofumpt",
          "goimports",
          "delve",
        }),
        auto_update = false,
        run_on_start = true,
      })
    end,
  },
}
