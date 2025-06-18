return {
	"almo7aya/openingh.nvim",
	cmd = { "OpenInGHRepo", "OpenInGHFile", "OpenInGHFileLines" },
	keys = { "<leader>gh" },
	config = function()
		local function is_visual_selection_active()
			local mode = vim.fn.mode()
			return mode == "v" or mode == "V" or mode == "<C-v>"
		end

		local function open_github_smart()
			if is_visual_selection_active() then
				-- If lines are selected (visual mode)
				vim.cmd("OpenInGHFileLines")
			elseif vim.api.nvim_buf_get_name(0) ~= "" then
				-- If inside a buffer (current buffer has a name/file)
				vim.cmd("OpenInGHFile")
			else
				-- Otherwise (no selection, no file open)
				vim.cmd("OpenInGHRepo")
			end
		end

		vim.keymap.set({ "n", "v" }, "<leader>gh", open_github_smart, { noremap = true, silent = true, nowait = false })
	end,
}
