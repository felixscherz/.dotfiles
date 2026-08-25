-- Some Mason packages need a host toolchain present at *install* time (they
-- shell out to npm/go/python3, or unzip a release archive). On a fresh box that
-- toolchain may be missing, and Mason then spams "Failed to spawn process"
-- errors. Rather than force every user of this config to install Go, Node, etc.,
-- we only queue a package when the tool it needs is actually on PATH.

local M = {}

-- package name -> executable it requires to install. Package names cover both
-- mason registry names (used by mason-tool-installer) and lspconfig server
-- names (used by mason-lspconfig), since the two lists name things differently.
M.requires = {
	-- npm / node
	prettier = "npm",
	jsonls = "npm",
	yamlls = "npm",
	bashls = "npm",
	ansiblels = "npm",
	svelte = "npm",
	ts_ls = "npm",
	-- go
	gopls = "go",
	gofumpt = "go",
	goimports = "go",
	delve = "go",
	-- python3
	yamllint = "python3",
	ty = "python3",
	basedpyright = "python3",
	cmake = "python3",
	autotools_ls = "python3",
	-- unzip (release archives)
	stylua = "unzip",
	terraformls = "unzip",
	clangd = "unzip",
}

-- Return only the packages whose required tool is available, warning once about
-- the rest so it is clear why they were skipped.
function M.filter(list)
	local keep = {}
	local skipped = {}
	for _, name in ipairs(list) do
		local base = vim.split(name, "@")[1]
		local dep = M.requires[base]
		if dep and vim.fn.executable(dep) == 0 then
			table.insert(skipped, string.format("%s (needs %s)", base, dep))
		else
			table.insert(keep, name)
		end
	end
	if #skipped > 0 then
		vim.schedule(function()
			vim.notify(
				"mason: skipping packages, required tools not on PATH:\n  " .. table.concat(skipped, "\n  "),
				vim.log.levels.WARN
			)
		end)
	end
	return keep
end

return M
