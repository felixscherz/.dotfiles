return {
	"nvimtools/none-ls.nvim",
	event = { "VeryLazy" },
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		local docformat_source = {
			name = "docformat",
			filetypes = { "python" },
			method = null_ls.methods.FORMATTING,
			generator = {
				fn = function(params)
					local obj = vim.system(
						{ "docformatter", "--style", "numpy", "--pre-summary-newline", "-" },
						{ stdin = params.content }
					):wait()
					return { {
						text = obj.stdout,
					} }
				end,
			},
		}
		null_ls.setup({
			debug = false,
			sources = {
				formatting.prettier.with({
					extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote", "--tab-width", "2" },
				}),
				formatting.black.with({ extra_args = { "--line-length", "120" } }),
				formatting.stylua,
				formatting.isort.with({ extra_args = { "--sl", "-l 120" } }),
				docformat_source,
			},
		})
	end,
}
