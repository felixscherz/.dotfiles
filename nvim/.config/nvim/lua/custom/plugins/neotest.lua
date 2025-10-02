return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-neotest/neotest-python",
		"nvim-neotest/neotest-plenary",
		"nvim-neotest/neotest-vim-test",
		"codymikol/neotest-kotlin",
		"rouge8/neotest-rust",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-python")({
					dap = { justMyCode = false },
					args = { "-rP" },
				}),
				require("neotest-plenary"),
				require("neotest-vim-test")({
					ignore_file_types = { "python", "vim", "lua" },
				}),
				require("neotest-rust")({ args = { "--no-capture" } }),
				require("neotest-kotlin"),
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

		local wk = require("which-key")

		wk.add({
			name = "neotest",
			{
				"<leader>nto",
				function()
					require("neotest").summary.open()
				end,
				desc = "open summary",
			},
			{
				"<leader>ntp",
				function()
					require("neotest").output_panel.open()
				end,
				desc = "open panel",
			},
			{
				"<leader>ntr",
				function()
					require("neotest").run.run()
				end,
				desc = "run test",
			},
			{
				"<leader>ntf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "run file",
			},
			{
				"<leader>nts",
				function()
					require("neotest").run.stop()
				end,
				desc = "stop test",
			},
			{
				"<leader>nta",
				function()
					require("neotest").run.attach()
				end,
				desc = "attach to test",
			},
		})
	end,
	keys = { "<leader>n" },
}
