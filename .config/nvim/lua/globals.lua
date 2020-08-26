local api = vim.api

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
