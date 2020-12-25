local api = vim.api

-- https://gist.github.com/nblackburn/875e6ff75bc8ce171c758bf75f304707#gistcomment-2588452
function _G.helpfulness()
  local word = vim.fn.expand('<cword>')

  api.nvim_feedkeys('ciw' .. "'" .. (word:gsub('([%a%d])([%u])', '%1-%2')):lower() .. "'", 'n', true)
end

function _G.dump(x)
  print(vim.inspect(x))
end

local function on_change(err, fname, status)
  local fullpath = vim.fn.fnamemodify(fname, ':p')
  api.nvim_command('luafile ' .. fullpath)

  -- Debounce: stop/start.
  _G['watcher' .. fullpath]:stop()
  watch_file(fullpath)
end

function _G.watch_file(filepath)
  local w = vim.loop.new_fs_event()

  w:start(filepath, {}, vim.schedule_wrap(function(...)
    on_change(...)
  end))

  _G['watcher' .. filepath] = w
end

_G.api = vim.api
_G.fn = vim.fn
