package.loaded['functions'] = nil
local api = vim.api

local functions = {}

function functions.comment_line()
  local row = api.nvim_win_get_cursor(0)[1]
  local line = api.nvim_buf_get_lines(0, row - 1, row, false)[1]

  api.nvim_buf_set_lines(0, row - 1, row, false, { string.format(vim.bo.commenstring, line) })
end

return functions
