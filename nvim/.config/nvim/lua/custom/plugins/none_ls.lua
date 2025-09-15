return {
	"nvimtools/none-ls.nvim",
	event = { "VeryLazy" },
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics
		null_ls.setup({
			debug = false,
			sources = {
				formatting.prettier.with({
					extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote", "--tab-width", "2" },
				}),
				formatting.black.with({ extra_args = { "--line-length", "120" } }),
				formatting.stylua,
				formatting.isort.with({ extra_args = { "--sl", "-l 120" } }),
				formatting.buildifier,
				diagnostics.yamllint,
			},
		})
	end,
}

-- if a none-ls source is not associated with an existing lsp server, there won't be any keymaps available
-- since the keymaps are set as part of an `on_attach` function that is only set for lsps
