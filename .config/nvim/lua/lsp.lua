local lspconfig  = require 'lspconfig'
local util      = require 'lspconfig/util'
local configs  = require 'lspconfig/configs'
local completion_on_attach = require('completion').on_attach

local setup_table = {
    on_attach = completion_on_attach,
    handlers = vim.g.uivonim == 1 and require'uivonim/lsp'.callbacks or nil
}
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

  configs.zls = {
    default_config = {
      cmd = { os.getenv('HOME') .. "/dev/zig/zls/zig-cache/bin/zls" },
      filetypes = { 'zig' },
      root_dir = util.root_pattern('build.zig'),
      log_level = vim.lsp.protocol.MessageType.Warning,
      settings = {}
    };
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

  -- lspconfig.haskell_ide_engine.setup { on_attach = language_client_setup, }
  -- lspconfig.reason_ls.setup { on_attach = language_client_setup, }

  -- lspconfig.elixir_ls.setup { on_attach = completion_on_attach, }
end

local function stuff(tbl)
  return vim.tbl_extend('force', setup_table, tbl)
end

function lsp.setup_lsps()
  setup_custom_lsps()


  local home = os.getenv('HOME')
  lspconfig.gopls.setup(setup_table)

  lspconfig.texlab.setup(setup_table)

  lspconfig.zls.setup(setup_table)

  -- lspconfig.rls.setup { cmd = { 'rustup', 'run', 'nightly', 'rls' } }
  -- lspconfig.clangd.setup { {} }

  lspconfig.ccls.setup(setup_table)
  lspconfig.pyls.setup(setup_table)

  lspconfig.julials.setup(setup_table)
  lspconfig.rust_analyzer.setup(setup_table)
  -- lspconfig.rls.setup(stuff({
  --   cmd = { 'rustup', 'run', 'nightly', 'rls' }
  -- }))

  lspconfig.dartls.setup(setup_table)
  lspconfig.omnisharp.setup(vim.tbl_extend('force', setup_table, {
      root_dir = util.root_pattern('.csproj', '.sln', '.git', '.fsproj')
  }))

  require'nlua.lsp.nvim'.setup(lspconfig, vim.tbl_extend('force', setup_table, {
    globals = {
      -- AwesomeWM
      -- 'root'
    },
    library = {
      -- TODO(smolck): Doesn't work . . .
      ['/usr/share/awesome/lib/awful'] = true,
      ['/usr/share/awesome/lib/beautiful'] = true,
      ['/usr/share/awesome'] = true,
    }
  }))
  lspconfig.tsserver.setup(setup_table)
  lspconfig.metals.setup(setup_table)
end

return lsp
