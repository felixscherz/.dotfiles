local M = {}

local function register_keymaps()
	local wk = require("which-key")

	wk.register({
		["rr"] = { ":lua require('refactoring').select_refactor()<CR>", "Refactor" },
	}, { mode = "v", prefix = "<leader>", silent = true, noremap = true, expr = false })
end

function M.setup(opts)
	require("refactoring").setup(opts)
	register_keymaps()
end

return M
