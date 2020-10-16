local nvim_lsp  = require 'nvim_lsp'
local util      = require 'nvim_lsp/util'
local configs  = require 'nvim_lsp/configs'
local completion_on_attach = require('completion').on_attach

local lsp = {}

-- Thanks TJ:
-- https://github.com/tjdevries/nlua.nvim/blob/a00062720c85cd84a4d11919559f66effbe979d1/lua/nlua/lsp/nvim.lua#L3-L21
local function sumneko_command()
  local cache_location = vim.fn.stdpath('cache')

  -- TODO: Need to figure out where these paths are & how to detect max os... please, bug reports
  local bin_location = jit.os

  return {
    string.format(
      "%s/nvim_lsp/sumneko_lua/lua-language-server/bin/%s/lua-language-server",
      cache_location,
      bin_location
    ),
    "-E",
    string.format(
      "%s/nvim/nvim_lsp/sumneko_lua/lua-language-server/main.lua",
      cache_location
    ),
  }
end

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

  -- nvim_lsp.haskell_ide_engine.setup { on_attach = language_client_setup, }
  -- nvim_lsp.reason_ls.setup { on_attach = language_client_setup, }

  -- nvim_lsp.elixir_ls.setup { on_attach = completion_on_attach, }
end

function lsp.setup_lsps()
  setup_custom_lsps()

  local home = os.getenv('HOME')
  nvim_lsp.gopls.setup { on_attach = completion_on_attach, cmd = { home .. '/dev/go/bin/gopls' }, }

  nvim_lsp.zls.setup { on_attach = completion_on_attach }

  -- nvim_lsp.rls.setup { cmd = { 'rustup', 'run', 'nightly', 'rls' } }
  -- nvim_lsp.clangd.setup { {} }

  nvim_lsp.ccls.setup {}
  nvim_lsp.pyls.setup { on_attach = completion_on_attach }

  nvim_lsp.julials.setup { on_attach = completion_on_attach }
  nvim_lsp.rls.setup {
    on_attach = completion_on_attach,
    cmd = { 'rustup', 'run', 'nightly', 'rls' }
  }

  nvim_lsp.dartls.setup { on_attach = completion_on_attach }

  if vim.g.uivonim == 1 then
    local lsp_callbacks = require'uivonim/lsp'.callbacks

    nvim_lsp.texlab.setup {
      on_attach = completion_on_attach;
      callbacks = lsp_callbacks;
    }

    -- nvim_lsp.sumneko_lua.setup {
    --   command = sumneko_command();
    --   on_attach = completion_on_attach;
    --   callbacks = lsp_callbacks;
    -- }
    require'nlua.lsp.nvim'.setup(nvim_lsp, {
      on_attach = completion_on_attach;
      callbacks = lsp_callbacks;
    })
    nvim_lsp.tsserver.setup {
      on_attach = completion_on_attach;
      callbacks = lsp_callbacks;
    }
    return
  end

  require'nlua.lsp.nvim'.setup(nvim_lsp, { on_attach = completion_on_attach })
  nvim_lsp.tsserver.setup { on_attach = completion_on_attach }
end

return lsp
