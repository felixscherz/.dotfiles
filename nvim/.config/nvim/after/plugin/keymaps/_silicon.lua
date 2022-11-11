Vnoremap("<leader>s", function() Silicon.visualise_api({to_clip = true}) end)
Vnoremap("<leader>bs", function() Silicon.visualise_api({to_clip = true, show_buf = true}) end)
Nnoremap("<leader>s", function() Silicon.visualise_api({to_clip = true, visible = true}) end)
