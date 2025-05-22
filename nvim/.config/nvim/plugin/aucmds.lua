local function augroup(name)
	return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

vim.filetype.add({
	filename = {
		[".envrc"] = "bash",
		[".flake8"] = "ini",
		[".importlinter"] = "ini",
	},
})

vim.filetype.add({
	pattern = { [".*/tasks/.*.yml"] = "yaml.ansible", [".*\\.dotfiles/main.yml"] = "yaml.ansible" },
})

--fix terraform and hcl comment string
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("FixTerraformCommentString", { clear = true }),
	callback = function(ev)
		vim.bo[ev.buf].commentstring = "# %s"
	end,
	pattern = { "terraform", "hcl" },
})

vim.filetype.add({
	extension = {
		http = "http",
	},
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("Jinja2PythonDetect", { clear = true }),
	pattern = { "*.py.j2" },
	callback = function(args)
		vim.opt_local.filetype = "py.j2"
		vim.diagnostic.enable(false, { bufnr = args.buf })
	end,
})
