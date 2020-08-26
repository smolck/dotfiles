local api = vim.api

local function mode(_, _)
  local sections = require('el.sections')
  local modes = require('el.data').modes
  local mode_highlights = require('el.data').mode_highlights

  local curr_mode = vim.fn.mode()

  local display_name = modes[curr_mode][1]

  return ' ' .. display_name
  -- return sections.highlight(
  --   higroup,
  --   string.format('%s', display_name)
  -- )
end

local function filetype(_win_id, bufnr)
  return api.nvim_buf_get_option(bufnr, 'filetype')
end

local function generator()
  local extensions = require('el.extensions')
  local builtin = require('el.builtin')
  local el_segments = {}

  local separators = { left = '  ', right = '  ' };

  table.insert(el_segments, mode)
  table.insert(el_segments, separators.left)

  table.insert(el_segments, builtin.tail)
  table.insert(el_segments, separators.left)

  table.insert(el_segments, builtin.modified)

  table.insert(el_segments, ' %= ')

  table.insert(el_segments, filetype)
  table.insert(el_segments, separators.right)

  table.insert(el_segments, builtin.percentage_through_file .. '%%')
  table.insert(el_segments, separators.right)

  table.insert(el_segments, builtin.line_number .. ':' .. builtin.column .. ' ')

  return el_segments
end

require('el').setup { generator = generator }
