-- to show whitespace using :set list, disable with :set nolist
vim.cmd([[
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
]])

local function dump_lsp_config()
	local output = vim.inspect(vim.lsp.get_clients())
	local lines = vim.split(output, "\n")
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_var(buf, "filetype", "lua")
	vim.api.nvim_buf_set_name(buf, "lsp-configuration")
	vim.api.nvim_set_current_buf(buf)
end

vim.api.nvim_create_user_command("LspDumpConfig", dump_lsp_config, { nargs = 0 })
