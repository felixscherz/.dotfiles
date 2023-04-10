local M = {}

M.config = function(plugin, opts)
	require("neotest").setup({
		adapters = {
			require("neotest-python")({
				dap = { justMyCode = false },
				args = { "-rP", "--log-level", "DEBUG" },
			}),
			require("neotest-plenary"),
			require("neotest-vim-test")({
				ignore_file_types = { "python", "vim", "lua" },
			}),
			require("neotest-rust")({ args = { "--no-capture" } }),
		},
		quickfix = {
			enabled = false,
		},
	})
end
