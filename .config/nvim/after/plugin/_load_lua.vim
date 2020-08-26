" From https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/after/plugin/_load_lua.vim
" let s:load_dir = expand('<sfile>:p:h:h:h')
" exec printf('luafile %s/lua/init.lua', s:load_dir)

lua << EOF
vim.api.nvim_exec('luafile ' .. os.getenv('HOME') .. '/.config/nvim/lua/init.lua', false)
EOF
