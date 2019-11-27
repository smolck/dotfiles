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

local function init_globals()
    vim.g.startify_custom_header_quotes = {{ os.getenv('VERSEOFDAY') }}
    vim.g.polyglot_disabled = { 'dart' }
    vim.g.floaterm_position = 'center'
    vim.g.floaterm_width = nvim_options.columns / 2
    vim.g.airline_powerline_fonts = 1
    vim.g.mapleader = ';'
end

local function init_options()
    local options = {
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

      guifont		 = 'Iosevka Extrabold:h16';
    }

    for k, v in pairs(options) do nvim_options[k] = v end
end

init_globals()
init_options()
init_lsps()
