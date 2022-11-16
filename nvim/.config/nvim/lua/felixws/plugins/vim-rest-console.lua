vim.cmd[[ let g:vrc_curl_opts = {'-s': ''}]]
vim.cmd[[
    let g:vrc_auto_format_response_enabled = 1
    let s:vrc_auto_format_response_patterns = {
      \ 'json': 'python -m json.tool',
      \ 'xml': 'xmllint --format -',
    \}
    let g:vrc_response_default_content_type = "application/json"
    let g:vrc_show_command = 1
]]
