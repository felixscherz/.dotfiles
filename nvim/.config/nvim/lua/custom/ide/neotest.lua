local M = {}

local function register_keymaps()
	local wk = require("which-key")

	wk.register({
		["nt"] = {
			name = "neotest",
			o = {
				function()
					require("neotest").summary.open()
				end,
				"open summary",
			},
			p = {
				function()
					require("neotest").output_panel.open()
				end,
				"open panel",
			},
			r = {
				function()
					require("neotest").run.run()
				end,
				"run test",
			},
			f = {
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				"run file",
			},
			s = {
				function()
					require("neotest").run.stop()
				end,
				"stop test",
			},
			a = {
				function()
					require("neotest").run.attach()
				end,
				"attach to test",
			},
		},
	}, { prefix = "<leader>" })
end

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
			enabled = true,
			open = false,
		},
		status = {
			enabled = true,
			signs = true,
			virtual_text = false,
		},
	})
	register_keymaps()
end

return M
