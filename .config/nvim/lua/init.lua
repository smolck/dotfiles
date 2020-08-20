local vim                  = vim
local os                   = require 'os'
local helpers              = require 'lua_helpers'
local nvim_options         = helpers.nvim_options
local nvim_apply_mappings  = helpers.nvim_apply_mappings
local nvim_create_augroups = helpers.nvim_create_augroups

-- Vim function definitions {{{
vim.fn.BuildComposer = function(info)
    local has = vim.fn.has

    if info.status ~= 'unchanged' or info.force then
        if has('nvim') then
            vim.api.nvim_command('!cargo build --release')
        else
            vim.api.nvim_command('!cargo build --release --no-default-features --features json-rpc')
        end
    end
end

vim.fn.LightlineReadonly = function()
    if vim.g.readonly then
        return ''
    else
        return ''
    end
end

vim.api.nvim_command [[
    function! DeleteTrailingWS()
      exe 'normal mz'
      %s/\s\+$//ge
      exe 'normal `z'
    endfunction
]]

vim.api.nvim_command [[
    function! SynStack()
        if !exists('*synstack')
            return
        endif
        echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
    endfunction
]]

vim.api.nvim_command [[
    function! LightlineFugitive()
       if exists('*fugitive#head')
        let branch = fugitive#head()
        return branch !=# '' ? ''.branch : ''
       endif
       return ''
    endfunction
]]
-- }}}

-- Globals {{{
local function init_globals()
    vim.g.python3_host_prog                         = '/bin/python'
    -- vim.g.node_host_prog                            = os.getenv('HOME') .. '/.npm-global/bin/n'
    vim.g.completion_enable_snippet                 = 'UltiSnips'

    vim.g.startify_custom_header_quotes             = {{ os.getenv('VERSEOFDAY') }}
    vim.g.polyglot_disabled                         = { 'dart', 'haskell', 'ocaml' }
    vim.g.floaterm_position                         = 'center'
    vim.g.floaterm_width                            = nvim_options.columns / 2
    vim.g.mapleader                                 = ';'
    vim.g.maplocalleader                            = ';'

    -- Colorscheme
    vim.g.colors_name                               = 'gruvbox-material'

    vim.g.neomake_cpp_enabled_makers                = {'clangd'}
    vim.g.python_highlight_all                      = 1

    vim.g.strip_whitespace_on_save                  = 1
    vim.g.strip_max_file_size                       = 1000
    vim.g.strip_whitespace_confirm                  = 0

    vim.g.opamshare                                 = vim.fn.substitute(vim.fn.system('opam config var share'), '\n$', '', "''")

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

-- Lightline config {{{
local function init_lightline()
    vim.g.lightline = {
        colorscheme = 'gruvbox_material';
        tabline = {
          left = { { 'bufferinfo' },
                    { 'separator' },
                    { 'bufferbefore', 'buffercurrent', 'bufferafter' }, },
          right = { { 'tabs', 'close' }, },
        };
        active = {
            left = { { 'mode', 'paste' },
                    { 'fugitive', 'readonly', 'filename', 'modified' }
            }
        };
        component_expand = {
          buffercurrent = 'lightline#buffer#buffercurrent',
          bufferbefore = 'lightline#buffer#bufferbefore',
          bufferafter = 'lightline#buffer#bufferafter',
        };
        component_type = {
          buffercurrent = 'tabsel',
          bufferbefore = 'raw',
          bufferafter = 'raw',
        };
        component_function = {
          bufferinfo = 'lightline#buffer#bufferinfo',
          readonly = 'LightlineReadonly',
          fugitive = 'LightlineFugitive'
        };
        -- separator = { left = '', right = '' };
        -- subseparator = { left = '', right = '' };
    }
    -- Lightline-buffer UI settings
    vim.g.lightline_buffer_logo                     = ' '
    vim.g.lightline_buffer_readonly_icon            = ''
    vim.g.lightline_buffer_modified_icon            = '✭'
    vim.g.lightline_buffer_git_icon                 = ' '
    vim.g.lightline_buffer_ellipsis_icon            = '..'
    vim.g.lightline_buffer_expand_left_icon         = '◀ '
    vim.g.lightline_buffer_expand_right_icon        = ' ▶'
    vim.g.lightline_buffer_active_buffer_left_icon  = ''
    vim.g.lightline_buffer_active_buffer_right_icon = ''
    vim.g.lightline_buffer_separator_icon           = '  '

    -- Requires <https://github.com/ryanoasis/vim-devicons>
    vim.g.lightline_buffer_enable_devicons          = 1

    vim.g.lightline_buffer_show_bfnr                = 1

    -- See `:help filename-modifiers`
    vim.g.lightline_buffer_fname_mod                = ':t'

    -- Hide buffer list
    vim.g.lightline_buffer_excludes                 = { 'vimfiler' }

    vim.g.lightline_buffer_maxflen                  = 30 -- Max file name length
    vim.g.lightline_buffer_minflen                  = 16 -- Min file name length

    vim.g.lightline_buffer_maxfextlen               = 30 -- Max file extension length
    vim.g.lightline_buffer_minfextlen               = 3  -- Min file extension length

    -- Reserve length for other componenet (e.g. info, close)
    vim.g.lightline_buffer_reservelen               = 20
end

-- }}}

-- Options {{{
local function init_options()
    local options = {
      noswapfile         = true;
      timeoutlen         = 500;
      modeline           = true;
      foldmethod         = 'marker';

      textwidth          = 80;
      splitbelow         = true;
      splitright         = true;
      title              = true;
      ignorecase         = true;
      encoding           = 'UTF-8';
      background         = 'dark';
      path               = nvim_options.path .. ',' .. vim.api.nvim_call_function('getenv', { 'PWD' });
      wildmenu           = true;
      tabstop            = 4;
      shiftwidth         = 4;
      softtabstop        = 4;
      expandtab          = true;
      smarttab           = true;
      autoindent         = true;

      number             = true;
      relativenumber     = true;
      autochdir          = true;
      hlsearch           = true;
      smartcase          = true;
      cursorline         = true;
      linebreak          = true;
      wrap               = false;
      lazyredraw         = true;

      termguicolors	     = true;

      -- guifont		     = 'Hasklig\\ Bold:h14';
      guifont		     = 'JetBrainsMono\\ Bold:h14';

      hidden             = true;
      showtabline        = 2; -- Always show tabline.
      completeopt        = {'menuone', 'noinsert', 'noselect'};

      shortmess          = nvim_options.shortmess .. 'c';

      runtimepath        = nvim_options.runtimepath
        .. ",/home/smolck/.luarocks/share" .. ",/home/smolck/dev/lua/org.nvim"

      -- Should be equivalent to `set rtp+=<SHARE_DIR>/merlin/vim` in VimL
      -- rtp                = nvim_options.rtp .. ',' .. vim.g.opamshare .. "/merlin/vim"
    }

    -- Blink cursor if using GNvim.
    if vim.fn.exists('g:gnvim') then
        -- options.guicursor = nvim_options.guicursor .. ',a:blinkon333'
    end

    -- for k, v in pairs(options) do nvim_options[k] = v end

    -- TODO(smolck): Temporary until change in vim.api.nvim_set_option
    -- or addition of a different API function or something.
    for k, v in pairs(options) do
        if v == true or v == false then
            vim.api.nvim_command('set ' .. k)
        elseif type(v) == 'table' then
            local values = ''
            for k2, v2 in pairs(v) do
                if k2 == 1 then
                    values = values .. v2
                else
                    values = values .. ',' .. v2
                end
            end
            vim.api.nvim_command('set ' .. k .. '=' .. values)
        else
            vim.api.nvim_command('set ' .. k .. '=' .. v)
	    -- print('option ' .. k .. ' value ' .. v)
        end
    end
end
-- }}}

-- Autocmds {{{
local function create_autocmds()
    local autocmds = {
        indentation = {
            {'FileType', 'javascript', 'setlocal shiftwidth=2'},
            {'FileType', 'scala',      'setlocal shiftwidth=2'},
            {'FileType', 'dart',       'setlocal shiftwidth=2'},
            {'FileType', 'haskell',    'setlocal shiftwidth=2'},
            {'FileType', 'ocaml',      'setlocal shiftwidth=2'},
            {'FileType', 'go',         'setlocal shiftwidth=4'},
            {'FileType', 'lua',         'setlocal shiftwidth=2'},
        },
        omnifunc = {
            {'Filetype', 'lua,reason,haskell,dart,rust,python,go,c,cpp,scala,elixir',  'setlocal omnifunc=v:lua.vim.lsp.omnifunc'},
            -- {'Filetype', 'fennel',                                          'setlocal omnifunc=fnl#omniComplete'},
            -- {'Filetype', 'lua',                                             'setlocal omnifunc=fnl#omniCompleteLua'}
        },
        ncm2 = {
            -- Enable ncm2 for all buffers.
            -- {'BufEnter', '*', 'call ncm2#enable_for_buffer()'}
            {'BufEnter', 'txt', 'call ncm2#enable_for_buffer()'}
        },
        general = {
            {'FocusGained', '*', 'checktime'}
        },
        clojure = {
            {'Syntax', 'clojure', 'ClojureHighlightReferences'},
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

    helpers.nvim_apply_mappings(valid_modes, mappings)
end
-- }}}

init_lightline()

init_globals()
init_options()

require'colorizer'.setup()
require'nvim-todoist.ui'.init()

-- init_lsps()

-- Should be enabled before autocmds (afaik)
vim.api.nvim_command('syntax enable')
vim.api.nvim_command('filetype plugin on')

create_mappings()
create_autocmds()

require'snippets'.use_suggested_mappings()
require'snippets'.snippets = {
  lua = {
    -- Courtesy of @norcalli
    func = [[function${1|vim.trim(S.v):gsub("^%S"," %0")}(${2|vim.trim(S.v)})$0 end]];
    req = [[local ${2:${1|S.v:match"%w+$"}} = require '$1']];
    ["local"] = [[local ${2:${1|S.v:match"[^.]+$"}} = ${1}]];

    ["for"] = "for ${1:i}, ${2:v} in ipairs(${3:t}) do\n$0\nend";

    ["vmap"] = [[vim.tbl_map(function(x) return ${1:x} end, ${2:t})]];
    ["vfilter"] = [[vim.tbl_filter(function(x) return ${1:x} == ${2} end, ${3:t})]];

    randcolor = function()
      return string.format("#%06X", math.floor(math.random() * 0xFFFFFF))
    end;

    -- ["local"] = [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = ${1}]];
  }
}

if vim.fn.has('gnvim') ~= 0 then
  -- Disable external tabline
  vim.fn['gnvim#enable_ext_tabline'](0)
  vim.api.nvim_command('GnvimCursorEnableAnimations 0')
end

require'lsp'.setup_lsps()

require'nvim-gitter.plugin'.init()
