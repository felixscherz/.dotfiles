return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			yaml = { "yamllint" },
		}
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("custom_nvim_lint", { clear = true }),
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
