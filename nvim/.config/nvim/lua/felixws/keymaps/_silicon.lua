local wk = require("which-key")
local clip_buffer = function()
	require("silicon").visualise_api({ to_clip = true, visible = true })
end
local clip_buffer_with_highlight = function()
	require("silicon").visualise_api({ to_clip = true, show_buf = true })
end
local clip_selection = function()
	require("silicon").visualise_api({ to_clip = true })
end

wk.register({
	name = "silicon",
	s = { clip_buffer, "clip buffer" },
}, { prefix = "<leader>" })

wk.register({
	name = "silicon",
	s = { clip_selection, "clip highlight" },
	bs = { clip_buffer_with_highlight, "clip buffer with highlight" },
}, { mode = "v", prefix = "<leader>" })
