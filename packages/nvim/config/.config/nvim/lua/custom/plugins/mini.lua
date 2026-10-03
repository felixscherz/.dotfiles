return {
	"echasnovski/mini.nvim",
	config = function()
		require("mini.comment").setup()
		require("mini.surround").setup()

		local diff_base = require("custom.diff_base")
		require("mini.diff").setup({ source = diff_base.source })

		vim.api.nvim_create_user_command("DiffBase", function(opts)
			diff_base.set(opts.args ~= "" and opts.args or nil)
		end, { nargs = "?", desc = "Diff against merge-base with a revision (no argument: git index)" })

		require("which-key").add({
			{ "<leader>go", MiniDiff.toggle_overlay, desc = "toggle inline diff overlay" },
			{
				"<leader>gr",
				function()
					vim.ui.input({ prompt = "Diff base: ", default = diff_base.get() or "main" }, function(rev)
						if rev ~= nil and rev ~= "" then
							diff_base.set(rev)
						end
					end)
				end,
				desc = "review against revision",
			},
			{ "<leader>gR", ":DiffBase<CR>", desc = "diff against git index" },
			{
				"<leader>gq",
				function()
					diff_base.hunks_to_qflist()
					vim.cmd("copen")
				end,
				desc = "changed hunks to quickfix",
			},
		})
	end,
	lazy = false,
}
