local api                  = vim.api
local os                   = require('os')
require('nvim_utils')

if vim.g.uivonim == 1 then
  vim.defer_fn(function()
    require'uivonim'.notify_uivonim('enable-ext-statusline', false)
  end, 1000)
end

-- Just a cool thing
-- :set redrawdebug=compositor writedelay=10

-- Vim function definitions {{{
-- vim.fn.BuildComposer = function(info)
--     local has = vim.fn.has
--
--     if info.status ~= 'unchanged' or info.force then
--         if has('nvim') then
--             api.nvim_command('!cargo build --release')
--         else
--             api.nvim_command('!cargo build --release --no-default-features --features json-rpc')
--         end
--     end
-- end
--
-- vim.fn.LightlineReadonly = function()
--     if vim.g.readonly then
--         return ''
--     else
--         return ''
--     end
-- end

api.nvim_command [[
    function! SynStack()
        if !exists('*synstack')
            return
        endif
        echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
    endfunction

    function! LightlineFugitive()
       if exists('*fugitive#head')
        let branch = fugitive#head()
        return branch !=# '' ? ''.branch : ''
       endif
       return ''
    endfunction

    function! DeleteTrailingWS()
      exe 'normal mz'
      %s/\s\+$//ge
      exe 'normal `z'
    endfunction
]]
-- }}}

-- Globals {{{
local function init_globals()
  vim.g.completion_enable_auto_hover = 0

  -- vim.g.fzf_preview_window = 'up:60%'

  -- vim.g.pear_tree_smart_openers = 1
  -- vim.g.pear_tree_smart_closers = 1
  -- vim.g.pear_tree_smart_backspace = 1

    vim.g.python3_host_prog                         = '/bin/python'
    -- vim.g.node_host_prog                            = os.getenv('HOME') .. '/.npm-global/bin/n'
    -- vim.g.completion_enable_snippet                 = 'UltiSnips'

    vim.g.startify_custom_header_quotes             = {{ os.getenv('VERSEOFDAY') }}
    -- vim.g.polyglot_disabled                         = { 'dart', 'haskell', 'ocaml' }
    vim.g.floaterm_position                         = 'center'
    vim.g.floaterm_width                            = vim.o.columns / 2
    vim.g.mapleader                                 = ';'
    vim.g.maplocalleader                            = ';'

    -- Colorscheme
    vim.g.gruvbox_material_better_performance        = 1
    vim.g.gruvbox_material_diagnostic_line_highlight = 1
    vim.g.gruvbox_material_background               = 'hard'

    -- vim.g.colors_name                               = 'gruvbox-material'
    vim.g.colors_name                               = 'oak'
    -- if vim.g.uivonim == 1 then
    -- else
    --    vim.g.colors_name                               = 'gruvbox-material'
    -- end

    vim.g.neomake_cpp_enabled_makers                = {'clangd'}
    vim.g.python_highlight_all                      = 1

    vim.g.strip_whitespace_on_save                  = 1
    vim.g.strip_max_file_size                       = 1000
    vim.g.strip_whitespace_confirm                  = 0

    -- This is slow! I think.
    -- vim.g.opamshare                                 = vim.fn.substitute(vim.fn.system('opam config var share'), '\n$', '', "''")

    vim.g.neoformat_basic_format_align              = 1
    vim.g.neoformat_basic_format_retab              = 1
    vim.g.neoformat_try_formatprg                   = 1

    -- vim.g.conjure_omnifunc                          = 1

    vim.g.UltiSnipsExpandTrigger                    = "<tab>"
    vim.g.UltiSnipsJumpForwardTrigger               = "<c-b>"
    vim.g.UltiSnipsJumpBackwardTrigger              = "<c-z>"
    -- vim.g.org_agenda_files                          = {'~/org/todos.org'}

    vim.g.todoist                                   = { key = os.getenv('TODOIST_API_KEY') }
end
-- }}}

-- Options {{{
local function init_options()
  vim.o.clipboard = 'unnamedplus'

  vim.bo.swapfile         = false
  vim.o.swapfile          = false

  vim.wo.foldmethod         = 'marker'
  vim.bo.modeline           = true
  vim.o.modeline            = true

  vim.o.timeoutlen         = 1000

  vim.o.textwidth          = 80
  vim.bo.textwidth          = 80

  vim.o.splitbelow         = true
  -- vim.o.splitright         = true

  vim.o.title              = true
  vim.o.ignorecase         = true
  vim.o.encoding           = 'UTF-8'
  -- background         = os.date('*t').hour > 18 and 'dark' or 'light'
  vim.o.background         = 'dark'

  api.nvim_exec(string.format('set path+=%s', os.getenv('PWD')), false)

  vim.o.wildmenu           = true

  vim.bo.tabstop           = 4
  vim.o.tabstop            = 4

  vim.bo.shiftwidth        = 4
  vim.o.shiftwidth         = 4

  vim.bo.softtabstop       = 4
  vim.o.softtabstop        = 4

  vim.bo.expandtab         = true
  vim.o.expandtab          = true

  vim.o.smarttab           = true

  vim.bo.autoindent        = true
  vim.o.autoindent         = true

  vim.wo.number            = true
  vim.wo.relativenumber    = true
  vim.o.autochdir          = true
  vim.o.hlsearch           = true
  vim.o.smartcase          = true

  vim.wo.cursorline        = true
  vim.wo.linebreak         = true
  vim.wo.wrap              = false
  -- vim.o.lazyredraw         = true

  -- guifont		     = 'Hasklig\\ Bold:h14';
  if vim.g.uivonim == 1 then
    vim.o.guifont		     = 'JetBrains Mono:h20:b'
  else
    vim.o.guifont		     = 'JetBrains Mono:h14:b'
  end

  vim.o.hidden             = true
  vim.o.showtabline        = 2 -- Always show tabline.
  vim.o.completeopt        = 'menuone,noinsert,noselect'

  api.nvim_exec('set shortmess+=c', false)
  -- api.nvim_exec(
  --   string.format(
  --     'set runtimepath+=",%s"',
  --       os.getenv('HOME') .. '/.luarocks/share'), false)

  -- Should be equivalent to `set rtp+=<SHARE_DIR>/merlin/vim` in VimL
  -- rtp                = nvim_options.rtp .. ',' .. vim.g.opamshare .. "/merlin/vim"
    -- }
  vim.o.termguicolors = true

    -- Blink cursor if using GNvim.
  if vim.fn.exists('g:gnvim') then
      -- options.guicursor = nvim_options.guicursor .. ',a:blinkon333'
  end
end
-- }}}

-- Autocmds {{{
local function create_autocmds()
    local autocmds = {
        indentation = {
            {'FileType', 'typescript,typescriptreact,javascript,scala,dart,haskell,ocaml,go', 'setlocal shiftwidth=2'},
        },
        omnifunc = {
            {'Filetype', 'typescript,typescriptreact,lua,reason,haskell,dart,rust,python,go,c,cpp,scala,elixir',  'setlocal omnifunc=v:lua.vim.lsp.omnifunc'},
            {'Filetype', 'plaintex',  'setlocal omnifunc=vimtex#complete#omnifunc'},
            -- {'Filetype', 'fennel',                                          'setlocal omnifunc=fnl#omniComplete'},
            -- {'Filetype', 'lua',                                             'setlocal omnifunc=fnl#omniCompleteLua'}
        },
        ncm2 = {
            -- Enable ncm2 for all buffers.
            -- {'BufEnter', '*', 'call ncm2#enable_for_buffer()'}
            -- {'BufEnter', 'txt', 'call ncm2#enable_for_buffer()'}
        },
        general = {
            {'FocusGained', '*', 'checktime'}
        },
        clojure = {
            -- {'Syntax', 'clojure', 'ClojureHighlightReferences'},
            -- {'VimEnter', '*', 'RainbowParentheses'},
        }
    }

    nvim_create_augroups(autocmds)
end
-- }}}

-- Keymappings {{{
local function create_mappings()
    -- Taken from
    -- https://github.com/norcalli/nvim_utils/blob/master/lua/nvim_utils.lua
    local valid_modes = {
    	n = 'n'; v = 'v'; x = 'x'; i = 'i';
    	o = 'o'; t = 't'; c = 'c'; s = 's';
    	-- :map! and :map
    	['!'] = '!'; [' '] = '';
    }

    local mappings = {
      ['i<Leader>sh'] = { '<esc>:lua vim.lsp.buf.signature_help()<cr>'; noremap = true; };
      ['i<Leader>ci'] = { '<esc>:lua vim.lsp.buf.completion()<cr>'; noremap = true; };
      ['n<Leader>fn'] = {
        ':silent FloatermNew --height=0.6 --width=0.6 --wintype=floating --name=floaterm1 --position=center<cr>';
        noremap = true;
      };
      ['n<Leader>fk'] = {':silent FloatermKill<cr>'; noremap = true; };
      ['n<Leader>fs'] = { ':FloatermShow<cr>'; noremap = true; };
      ['n<Leader>fh'] = { ':FloatermHide<cr>'; noremap = true; };
      ['n<Leader>zf'] = { ':FZFFiles<cr>'; noremap = true; };
      ['n<Leader>zh'] = { ':FZFHistory<cr>'; noremap = true; };
      ['n<Leader>zl'] = { ':FZFBLines<cr>'; noremap = true; };

        ['n<Leader>pt']  = {':NERDTreeToggle<CR>', noremap = true},
        -- ['n<Leader>']    = {":WhichKey '<Leader>'<CR>", noremap = true, silent = true},

        ['n<Leader>git'] = {':GitMessenger<CR>',               noremap = true},

        -- Esc out of nvim terminal
        ['t<Esc>'       ] = {'<C-\\><C-n>',                    noremap = true},

        -- YTC -> 'Yank To Clipboard'
        ['n<Leader>ytc' ] = {'\"+y',                           noremap = true},

        ['n<Leader>cc'  ] = {function() print('') end,         noremap = true},

        -- fe -> 'Format Elixir'
        -- ['n<Leader>fe'  ] = { format_current_elixir_file,      noremap = true},

        -- ['n<Up>'        ] = {function() jump(0) end,           noremap = true},
        -- ['n<Right>'     ] = {function() move_forward(0) end,   noremap = true},
        -- ['n<Left>'      ] = {function() move_backward(0) end,  noremap = true},
        ['n?'           ] = {':call SynStack()<CR>',           noremap = true},

        -- No arrow keys.
        -- ['n<Up>'        ] = {'<nop>',                          noremap = true},
        ['n<Down>'      ] = {'<nop>',                          noremap = true},
        -- ['n<Left>'      ] = {'<nop>',                          noremap = true},
        -- ['n<Right>'     ] = {'<nop>',                          noremap = true},
        ['i<Up>'        ] = {'<nop>',                          noremap = true},
        ['i<Down>'      ] = {'<nop>',                          noremap = true},
        ['i<Left>'      ] = {'<nop>',                          noremap = true},
        ['i<Right>'     ] = {'<nop>',                          noremap = true},

        -- Easy navigation of buffers.
        -- TODO: Better equivalent to this?
        -- `map <Leader>n :bn<CR>`
        -- `map <Leader>p :bp<CR>`
        -- `map <Leader>d :bd<CR>`
        ['n<Leader>n'   ] = {':bn<CR>',                        noremap = true},
        ['n<Leader>p'   ] = {':bp<CR>',                        noremap = true},
        ['n<Leader>d'   ] = {':bd<CR>',                        noremap = true},

        -- Simple command for opening this config.
        ['n<Leader>init'] = {":sp<Space>~/.config/nvim/lua/init.lua<CR>", noremap = true},

        -- Delete trailing whitespace.
        ['n<Leader>w'   ] = {':call DeleteTrailingWS()<CR>',   noremap = true}

        --[[
        ['t<Leader>api' ] = {
            ":new|put =map(filter(api_info().functions, '!has_key(v:val,''deprecated_since'')'), 'v:val.name')",
            noremap = true
        }
        --]]
    }

    nvim_apply_mappings(mappings)
end
-- }}}

init_globals()
init_options()

-- Should be enabled before autocmds (afaik)
api.nvim_command('syntax enable')
api.nvim_command('filetype plugin on')

require'lsp'.setup_lsps()

create_mappings()
create_autocmds()

require'bufferline'.setup {
  highlights = {
    bufferline_fill = {
      -- guibg = gruvbox_material_palette.bg5[1];
    };
  };
}

require'statusline'
require'treesitter'

vim.defer_fn(function()
  local gm_conf = vim.fn['gruvbox_material#get_configuration']()
  local gruvbox_material_palette =
    vim.fn['gruvbox_material#get_palette'](gm_conf.background, gm_conf.palette)
  api.nvim_command('highlight SignColumn guibg=' .. gruvbox_material_palette.bg0[1])

  require'colorizer'.setup()
  require'mysnippets'
  require'gitter'.neovim_stuff.use_defaults()
end, 600)

vim.defer_fn(function()
  if vim.g.gnvim_runtime_loaded then
    -- Disable external tabline
    vim.fn['gnvim#enable_ext_tabline'](0)
    api.nvim_command('GnvimCursorEnableAnimations 0')
  end -- require'treesitter'
end, 1000)
