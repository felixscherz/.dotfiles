local M = {}

M.opts = {
	org_agenda_files = { "~/org/**/*", "~/org/refile.org" },
	org_default_notes_file = "~/org/refile.org",
	org_capture_templates = {
		t = { description = "Task", template = "* TODO %?\n  %u\n  %a", target = "~/org/todos/todos.org" },
		m = {
			description = "Meeting",
			template = "* MEETING %u %?:meeting:\n  %U",
			target = "~/org/meetings/meetings.org",
		},
		c = {
			description = "Code",
			template = "* CODE %?:code:\n  %U\n%a\n#+begin_src\n%x\n#+end_src",
			target = "~/org/code/code.org",
		},
	},
}

M.config = function(plugin, opts)
	require("orgmode").setup_ts_grammar()
	require("orgmode").setup(M.opts)
end

return M
