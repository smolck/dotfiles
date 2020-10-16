vim.cmd [[packadd packer.nvim]]
vim._update_package_paths()

require('packer').startup(function()
  local use = use
  use {'wbthomason/packer.nvim', opt = true}

  -- use 'cocopon/iceberg.vim'

  use 'nvim-treesitter/nvim-treesitter'
  use 'vigoux/architext.nvim'

  use 'dstein64/vim-startuptime'
  -- use 'voldikss/vim-floaterm'

  use {'Raimondi/delimitMate', event = 'InsertEnter *'}

  use 'kyazdani42/nvim-web-devicons'
  use 'Akin909/nvim-bufferline.lua'

  -- use 'junegunn/fzf'
  -- use 'junegunn/fzf.vim'
  -- use 'chengzeyi/fzf-preview.vim'

  -- Lua-related
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lua/popup.nvim'

  use 'neovim/nvim-lspconfig'

  use 'tjdevries/express_line.nvim'
  use '/home/smolck/dev/lua/nlua.nvim'
  -- use 'tjdevries/nlua.nvim'


  -- use 'nvim-lua/telescope.nvim'
  use '~/dev/lua/telescope.nvim'
  use 'nvim-lua/completion-nvim'
  use 'norcalli/ui.nvim'

  use '~/dev/lua/nvim-todoist.lua'
  -- use {'smolck/nvim-todoist.lua', branch = 'plenary-as-submodule'}
  use '~/dev/lua/gitter.nvim'

  -- use 'editorconfig/editorconfig-vim'
  -- use 'neovimhaskell/nvim-hs.vim'
  -- use '~/dev/lua/org.nvim'
  use 'sainnhe/tmuxline.vim'

  use 'ActivityWatch/aw-watcher-vim'
  use 'mhinz/vim-startify'

  -- use 'guns/vim-clojure-static'
  -- use 'guns/vim-clojure-highlight'
  -- use 'junegunn/rainbow_parentheses.vim'
  -- use {'eraserhd/parinfer-rust', run = 'cargo build --release'}
  -- use 'kdheepak/lazygit.vim'
  -- use 'neovimhaskell/haskell-vim'

  use 'norcalli/nvim-colorizer.lua'
  use 'ntpeters/vim-better-whitespace'
  use 'sbdchd/neoformat'
  -- use 'sheerun/vim-polyglot'
  -- use 'dart-lang/dart-vim-plugin'

  -- use {'Olical/aniseed', tag = 'v3.5.0'}
  -- use 'Olical/conjure'
  -- use 'bakpakin/fennel.vim'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'

  use 'sainnhe/gruvbox-material'

  use 'norcalli/snippets.nvim'
  use 'norcalli/nvim_utils'
end)
