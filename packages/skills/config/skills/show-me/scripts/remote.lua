-- Runs requests from nvim-pane.sh inside the viewer.
--
-- Output is never collected through message redirection (`execute()`, `:redir`,
-- `nvim_exec2(..., { output = true })`). Redirection also records errors that were
-- suppressed with `:silent!`, so runtime ftplugins that clean up with
-- `sil! nunmap ...` would show up as spurious "E31: No such mapping" errors.
-- Instead, errors come from `pcall`, which only fails for errors that were not
-- suppressed, and output comes from `print` calls in the Lua chunk.
--
-- Every function returns a string whose first line is "ok" or "error", followed by
-- the output or the error message.

local M = {}

local function result(ok, text)
  return (ok and "ok" or "error") .. "\n" .. (text or "")
end

---@param cmd string
function M.ex(cmd)
  local ok, err = pcall(vim.api.nvim_exec2, cmd, {})
  -- remote calls do not redraw on their own
  vim.cmd.redraw()
  return result(ok, not ok and tostring(err) or nil)
end

---@param path string
function M.lua(path)
  local chunk, load_err = loadfile(path)
  if not chunk then
    return result(false, load_err)
  end

  local lines = {}
  local function capture_print(...)
    local parts = {}
    for i = 1, select("#", ...) do
      parts[#parts + 1] = tostring((select(i, ...)))
    end
    lines[#lines + 1] = table.concat(parts, "\t")
  end
  setfenv(chunk, setmetatable({ print = capture_print }, { __index = _G }))

  local ok, err = pcall(chunk)
  vim.cmd.redraw()
  if not ok then
    lines[#lines + 1] = tostring(err)
  end
  return result(ok, table.concat(lines, "\n"))
end

return M
