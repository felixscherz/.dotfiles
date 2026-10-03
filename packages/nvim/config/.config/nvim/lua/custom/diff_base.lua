-- mini.diff source whose reference can be switched from the git index to any revision.
-- With a base set, every buffer is diffed against the merge-base of HEAD and that revision,
-- which is what a branch review needs: only the changes this branch introduced.
local M = {}

-- nil means "compare against the git index" (mini.diff's default behaviour)
local base = nil
-- bumped on every base change so late async results for an old base are dropped
local generation = 0

local git_source = require("mini.diff").gen_source.git()

local function git(dir, args, on_done)
	vim.system(vim.list_extend({ "git", "-C", dir }, args), { text = true }, vim.schedule_wrap(on_done))
end

local function attach_to_base(buf_id)
	local path = vim.api.nvim_buf_get_name(buf_id)
	if path == "" then
		return false
	end
	path = vim.fn.resolve(path)
	local dir, file = vim.fs.dirname(path), vim.fs.basename(path)
	local gen = generation

	git(dir, { "merge-base", "HEAD", base }, function(merge_base)
		if gen ~= generation or not vim.api.nvim_buf_is_valid(buf_id) then
			return
		end
		if merge_base.code ~= 0 then
			return MiniDiff.fail_attach(buf_id)
		end
		local rev = vim.trim(merge_base.stdout)
		git(dir, { "show", rev .. ":./" .. file }, function(show)
			if gen ~= generation or not vim.api.nvim_buf_is_valid(buf_id) then
				return
			end
			-- a file missing at the base is new on this branch, so all of it is an addition
			MiniDiff.set_ref_text(buf_id, show.code == 0 and show.stdout or "")
		end)
	end)
end

M.source = {
	name = "git_base",
	attach = function(buf_id)
		if base == nil then
			return git_source.attach(buf_id)
		end
		return attach_to_base(buf_id)
	end,
	detach = function(buf_id)
		-- always forward: the buffer may have been attached while no base was set
		git_source.detach(buf_id)
	end,
	apply_hunks = function(buf_id, hunks)
		if base ~= nil then
			error(
				"Can not stage hunks while comparing against '" .. base .. "'. Run :DiffBase to go back to the index."
			)
		end
		return git_source.apply_hunks(buf_id, hunks)
	end,
}

--- Compare all buffers against `rev` (merge-base with HEAD), or against the git index when `rev` is nil.
function M.set(rev)
	if
		rev ~= nil
		and vim.system({ "git", "rev-parse", "--verify", "--quiet", rev .. "^{commit}" }):wait().code ~= 0
	then
		vim.notify("mini.diff base: unknown revision '" .. rev .. "'", vim.log.levels.ERROR)
		return
	end
	base = rev
	generation = generation + 1
	-- re-enable every loaded buffer, not just enabled ones: a failed attach under the old base disables it
	for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf_id) then
			local data = MiniDiff.get_buf_data(buf_id)
			MiniDiff.disable(buf_id)
			MiniDiff.enable(buf_id)
			if data ~= nil and data.overlay and MiniDiff.get_buf_data(buf_id) ~= nil then
				MiniDiff.toggle_overlay(buf_id)
			end
		end
	end
	vim.notify("mini.diff base: " .. (base or "git index"))
end

function M.get()
	return base
end

local function git_sync(dir, args)
	local result = vim.system(vim.list_extend({ "git", "-C", dir }, args), { text = true }):wait()
	if result.code ~= 0 then
		error(vim.trim(result.stderr), 0)
	end
	return result.stdout
end

-- Turns `git diff -U0` output into one quickfix entry per hunk, pointing at the hunk's first line in the new file.
local function parse_hunks(root, diff)
	local items, file = {}, nil
	for line in vim.gsplit(diff, "\n", { plain = true }) do
		local old_path = line:match("^%-%-%- a/(.*)$")
		local new_path = line:match("^%+%+%+ b/(.*)$")
		if old_path then
			file = old_path
		elseif new_path then
			file = new_path
		elseif line == "+++ /dev/null" and file then
			table.insert(items, { filename = vim.fs.joinpath(root, file), lnum = 1, text = "file deleted" })
			file = nil
		elseif file then
			local old_count, new_start, new_count = line:match("^@@ %-%d+,?(%d*) %+(%d+),?(%d*) @@")
			if new_start then
				local removed = old_count == "" and 1 or tonumber(old_count)
				local added = new_count == "" and 1 or tonumber(new_count)
				table.insert(items, {
					filename = vim.fs.joinpath(root, file),
					-- a pure deletion reports the line before it, which is 0 at the top of the file
					lnum = math.max(tonumber(new_start), 1),
					text = string.format("+%d -%d", added, removed),
				})
			end
		end
	end
	return items
end

--- Fill the quickfix list with every hunk that differs from the current base, plus untracked files.
function M.hunks_to_qflist()
	local ok, err = pcall(function()
		local root = vim.trim(git_sync(vim.fn.getcwd(), { "rev-parse", "--show-toplevel" }))
		-- same comparison mini.diff draws: the working tree against the merge-base, or against the index
		-- explicit prefixes: parse_hunks expects a/ and b/, which diff.mnemonicPrefix or diff.noprefix would change
		local diff_args = {
			"-c",
			"core.quotePath=false",
			"diff",
			"-U0",
			"--no-color",
			"--no-ext-diff",
			"--no-renames",
			"--src-prefix=a/",
			"--dst-prefix=b/",
		}
		if base ~= nil then
			table.insert(diff_args, vim.trim(git_sync(root, { "merge-base", "HEAD", base })))
		end
		local items = parse_hunks(root, git_sync(root, diff_args))
		local untracked = git_sync(root, { "-c", "core.quotePath=false", "ls-files", "--others", "--exclude-standard" })
		for _, file in ipairs(vim.split(untracked, "\n", { trimempty = true })) do
			table.insert(items, { filename = vim.fs.joinpath(root, file), lnum = 1, text = "untracked" })
		end
		vim.fn.setqflist({}, " ", { title = "Changes against " .. (base or "git index"), items = items })
		vim.notify(string.format("%d hunks against %s", #items, base or "git index"))
	end)
	if not ok then
		vim.notify("mini.diff base: " .. err, vim.log.levels.ERROR)
	end
end

return M
