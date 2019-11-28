local nvim_lsp = require('nvim_lsp')
local util = require('nvim_lsp/util')
local skeleton = require('nvim_lsp/skeleton')
local os = require('os')

local nvim_options = setmetatable({}, {
    __index = function(_, k)
			return vim.api.nvim_get_option(k)
		end;
    __newindex = function(_, k, v)
			return vim.api.nvim_set_option(k, v)
    end
  });

-- Config for LSPs {{{
local function init_lsps()
    nvim_lsp.pyls.setup { {} }
    nvim_lsp.rls.setup {
        cmd = { 'rustup', 'run', 'nightly', 'rls' }
    }
    nvim_lsp.clangd.setup { {} }
    nvim_lsp.gopls.setup { {} }
    nvim_lsp.tsserver.setup { {} }

    skeleton.dart_analyzer = {
        default_config = {
            cmd = { 'dart', '/opt/dart-sdk-dev/bin/snapshots/analysis_server.dart.snapshot', '--lsp' };
            filetypes = { 'dart' };
            root_dir = util.root_pattern("pubspec.yaml");
            log_level = vim.lsp.protocol.MessageType.Warning;
            settings = {};
        }
    }

    nvim_lsp.dart_analyzer.setup {
        on_attach = language_client_setup;
    }
end
-- }}}

-- Globals {{{
local function init_globals()
    vim.g.startify_custom_header_quotes             = {{ os.getenv('VERSEOFDAY') }}
    vim.g.polyglot_disabled                         = { 'dart' }
    vim.g.floaterm_position                         = 'center'
    vim.g.floaterm_width                            = nvim_options.columns / 2
    vim.g.mapleader                                 = ';'

    -- Colorscheme
    vim.g.colors_name                               = 'gruvbox-material'
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

      guifont		     = 'Iosevka Extrabold:h16';

      hidden             = true;
      showtabline        = 2; -- Always show tabline.
    }

    for k, v in pairs(options) do nvim_options[k] = v end
end
-- }}}

init_globals()
init_options()
init_lsps()
init_lightline()
