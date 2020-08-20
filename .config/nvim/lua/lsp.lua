local nvim_lsp  = require 'nvim_lsp'
local util      = require 'nvim_lsp/util'
local configs  = require 'nvim_lsp/configs'
local completion_on_attach = require('completion').on_attach

local lsp = {}

local function setup_custom_lsps()
  configs.elixir_ls = {
      default_config = {
          cmd = { os.getenv("HOME") .. "/dev/elixir/elixir-ls/language_server.sh" },
          filetypes = { 'elixir', 'eelixir' },
          root_dir = util.root_pattern('mix.exs', '.git'),
          log_level = vim.lsp.protocol.MessageType.Warning,
          settings = {},
      }
  }
  -- configs.reason_ls = {
  --     default_config = {
  --         cmd = { home .. "/dev/reason-ls/rls-linux/reason-language-server" },
  --         filetypes = { 'reason', 'ocaml' },
  --         root_dir = util.root_pattern('package.json'),
  --         log_level = vim.lsp.protocol.MessageType.Warning,
  --         settings = {},
  --     }
  -- }

  -- configs.haskell_ide_engine = {
  --     default_config = {
  --         cmd = { 'hie-8.6.5' },
  --         filetypes = { 'haskell' },
  --         root_dir = util.root_pattern('stack.yaml'),
  --         log_level = vim.lsp.protocol.MessageType.Warning,
  --         settings = {},
  --     }
  -- }

  -- nvim_lsp.haskell_ide_engine.setup { on_attach = language_client_setup, }
  -- nvim_lsp.reason_ls.setup { on_attach = language_client_setup, }

  nvim_lsp.elixir_ls.setup { on_attach = completion_on_attach, }
end

function lsp.setup_lsps()
  setup_custom_lsps()

  local home = os.getenv('HOME')
  nvim_lsp.gopls.setup { on_attach = completion_on_attach, cmd = { home .. '/dev/go/bin/gopls' }, }
  nvim_lsp.tsserver.setup { on_attach = completion_on_attach }

  -- nvim_lsp.rls.setup { cmd = { 'rustup', 'run', 'nightly', 'rls' } }
  -- nvim_lsp.clangd.setup { {} }

  nvim_lsp.ccls.setup {}
  nvim_lsp.pyls.setup { on_attach = completion_on_attach }

  require'nlua.lsp.nvim'.setup(nvim_lsp, { on_attach = completion_on_attach })
end

return lsp
