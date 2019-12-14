local vim                  = vim
local os                   = require 'os'
local helpers              = require 'helpers'
local nvim_options         = helpers.nvim_options
local nvim_apply_mappings  = helpers.nvim_apply_mappings
local nvim_create_augroups = helpers.nvim_create_augroups
local plug                 = helpers.plug

-- Vim function definitions {{{
vim.fn['BuildComposer'] = function(info)
    local has = vim.fn.has

    if info.status ~= 'unchanged' or info.force then
        if has('nvim') then
            vim.api.command('!cargo build --release')
        else
            vim.api.command('!cargo build --release --no-default-features --features json-rpc')
        end
    end
end

vim.fn['LightlineReadonly'] = function()
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

-- Plugins {{{
plug('~/.config/nvim/plugged', {
  'Vigemus/nvimux',
  'Yggdroot/indentLine',
  'airblade/vim-gitgutter',
  'bakpakin/fennel.vim',
  'clojure-vim/async-clj-omni',
  'ctrlpvim/ctrlp.vim',
  'dart-lang/dart-vim-plugin',
  'gruvbox-community/gruvbox',
  'itchyny/lightline.vim',
  'joshdick/onedark.vim',
  'mhinz/vim-startify',
  'ncm2/float-preview.nvim',
  'ncm2/ncm2',
  'ncm2/ncm2-bufword',
  'ncm2/ncm2-cssomni',
  'ncm2/ncm2-path',
  'neovim/nvim-lsp',
  'neovimhaskell/haskell-vim',
  'norcalli/nvim-colorizer.lua',
  'ntpeters/vim-better-whitespace',
  'rhysd/git-messenger.vim',
  'roxma/nvim-yarp',
  'sainnhe/gruvbox-material',
  'sbdchd/neoformat',
  'sheerun/vim-polyglot',
  'taohexxx/lightline-buffer',
  'tpope/vim-fireplace',
  'tpope/vim-fugitive',
  'tpope/vim-repeat',
  'tpope/vim-surround',
  'vimwiki/vimwiki',
  {'jaawerth/fennel-nvim', branch = 'dev'},
  {'ncm2/ncm2-tern', ['do'] = 'npm install'},
})
-- }}}

-- Nvimux Config {{{
local nvimux = require 'nvimux'

nvimux.config.set_all {
  prefix = '<C-a>',
  new_window = 'term',
  new_tab = nil,
  new_window_buffer = 'single',
  quickterm_direction = 'botright',
  quickterm_orientation = 'vertical',
  quickterm_scope = 'g', -- Use 'g' for global quickterm
  quickterm_size = '80',
}

nvimux.bindings.bind_all{
  {'s', ':NvimuxHorizontalSplit', {'n', 'v', 'i', 't'}},
  {'v', ':NvimuxVerticalSplit', {'n', 'v', 'i', 't'}},
}

nvimux.bootstrap()

-- }}}

-- Config for LSPs {{{
local nvim_lsp  = require 'nvim_lsp'
local util      = require 'nvim_lsp/util'
local skeleton  = require 'nvim_lsp/skeleton'

local function init_lsps()
    nvim_lsp.pyls.setup { {} }
    nvim_lsp.rls.setup {
        cmd = { 'rustup', 'run', 'nightly', 'rls' }
    }
    nvim_lsp.clangd.setup { {} }
    nvim_lsp.gopls.setup { {} }
    nvim_lsp.tsserver.setup { {} }

    skeleton.reason_ls = {
        default_config = {
            cmd = { os.getenv("HOME") .. "/dev/reason-ls/rls-linux/reason-language-server" },
            filetypes = { 'reason' },
            root_dir = util.root_pattern('package.json'),
            log_level = vim.lsp.protocol.MessageType.Warning,
            settings = {},
        }
    }

    skeleton.dart_analyzer = {
        default_config = {
            cmd = { 'dart', '/opt/dart-sdk-dev/bin/snapshots/analysis_server.dart.snapshot', '--lsp' },
            filetypes = { 'dart' },
            root_dir = util.root_pattern('pubspec.yaml'),
            log_level = vim.lsp.protocol.MessageType.Warning,
            settings = {},
        }
    }

    skeleton.haskell_ide_engine = {
        default_config = {
            cmd = { 'hie-8.6.5' },
            filetypes = { 'haskell' },
            root_dir = util.root_pattern('stack.yaml'),
            log_level = vim.lsp.protocol.MessageType.Warning,
            settings = {},
        }
    }

    nvim_lsp.dart_analyzer.setup {
        on_attach = language_client_setup,
    }

    nvim_lsp.haskell_ide_engine.setup {
        on_attach = language_client_setup,
    }

    nvim_lsp.reason_ls.setup {
        on_attach = language_client_setup,
    }
end
-- }}}

-- Globals {{{
local function init_globals()
    vim.g.startify_custom_header_quotes             = {{ os.getenv('VERSEOFDAY') }}
    vim.g.polyglot_disabled                         = { 'dart', 'haskell' }
    vim.g.floaterm_position                         = 'center'
    vim.g.floaterm_width                            = nvim_options.columns / 2
    vim.g.mapleader                                 = ';'

    -- Colorscheme
    vim.g.colors_name                               = 'gruvbox-material'

    vim.g.neomake_cpp_enabled_makers                = {'clangd'}
    vim.g.python_highlight_all                      = 1

    vim.g.strip_whitespace_on_save                  = 1
    vim.g.strip_max_file_size                       = 1000
    vim.g.strip_whitespace_confirm                  = 0
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
        separator = { left = '', right = '' };
        subseparator = { left = '', right = '' };
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

      guifont		     = 'Iosevka\\ Extrabold:h14';

      hidden             = true;
      showtabline        = 2; -- Always show tabline.
      completeopt        = {'menuone', 'noinsert', 'noselect'};

      -- Should be equivalent to `set rtp+=<SHARE_DIR>/merlin/vim` in VimL
      -- Don't think I even need this anymore....
      rtp                = nvim_options.rtp .. ',' .. '<SHARE_DIR>/merlin/vim'
    }

    -- Blink cursor if using GNvim.
    if vim.fn.exists('g:gnvim') then
        options.guicursor = nvim_options.guicursor .. ',a:blinkon333'
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
        },
        omnifunc = {
            {'Filetype', 'reason,haskell,dart,rust,python,go,c,cpp', 'setl omnifunc=lsp#omnifunc'},
            {'Filetype', 'fennel',                                    'setl omnifunc=fnl#omniComplete'},
            {'Filetype', 'lua',                                       'setl omnifunc=fnl#omniCompleteLua'}
        },
        ncm2 = {
            -- Enable ncm2 for all buffers.
            {'BufEnter', '*', 'call ncm2#enable_for_buffer()'}
        },
        general = {
            {'FocusGained', '*', 'checktime'}
        }
    }

    nvim_create_augroups(autocmds)
end
-- }}}

-- Keymappings {{{

local function create_mappings()
    local mappings = {
        ['n<Leader>git'] = {':GitMessenger<CR>',               noremap = true},

        -- Esc out of nvim terminal
        ['t<Esc>'       ] = {'<C-\\><C-n>',                    noremap = true},

        -- YTC -> 'Yank To Clipboard'
        ['n<Leader>ytc' ] = {'\"+y',                           noremap = true},

        ['n<Leader>cc'  ] = {function() print('') end,         noremap = true},

        ['n<Up>'        ] = {function() jump(0) end,           noremap = true},
        ['n<Right>'     ] = {function() move_forward(0) end,   noremap = true},
        ['n<Left>'      ] = {function() move_backward(0) end,  noremap = true},
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
        ['n<Leader>w'   ] = {':call DeleteTrailingWS()<CR>',   noremap = true},

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

require 'colorizer'.setup()

init_lsps()
init_lightline()

-- Should be enabled before autocmds (afaik)
vim.api.nvim_command('syntax enable')
vim.api.nvim_command('filetype plugin on')

create_mappings()
create_autocmds()
