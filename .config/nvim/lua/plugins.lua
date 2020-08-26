vim.cmd [[packadd packer.nvim]]
vim._update_package_paths()

require('packer').startup(function()
  local use = use
  use {'wbthomason/packer.nvim', opt = true}

  use 'dstein64/vim-startuptime'

  use 'kyazdani42/nvim-web-devicons'
  use 'Akin909/nvim-bufferline.lua'

  -- Lua-related
  use 'nvim-lua/plenary.nvim'
  use 'tjdevries/express_line.nvim'
  use 'tjdevries/nlua.nvim'
  use 'neovim/nvim-lsp'
  use 'nvim-lua/completion-nvim'
  use 'norcalli/neovim-plugin'
  use 'norcalli/ui.nvim'
  use '~/dev/lua/nvim-todoist.lua'
  use '~/dev/lua/gitter.nvim'

  -- use 'editorconfig/editorconfig-vim'
  -- use 'neovimhaskell/nvim-hs.vim'
  -- use '~/dev/lua/org.nvim'
  use 'sainnhe/tmuxline.vim'

  use 'jiangmiao/auto-pairs'
  -- use 'junegunn/fzf'
  -- use 'junegunn/fzf.vim'

  -- use 'wakatime/vim-wakatime'
  use 'ActivityWatch/aw-watcher-vim'
  -- use 'Yggdroot/indentLine'

  -- use 'airblade/vim-gitgutter'

  -- use 'itchyny/lightline.vim'
  -- use 'taohexxx/lightline-buffer'
  use 'mhinz/vim-startify'

  use {'challenger-deep-theme/vim', as = 'challenger-deep'}

  -- use 'guns/vim-clojure-static'
  -- use 'guns/vim-clojure-highlight'
  -- use 'junegunn/rainbow_parentheses.vim'
  -- use {'eraserhd/parinfer-rust', run = 'cargo build --release'}
  -- use 'kdheepak/lazygit.vim'
  -- use 'neovimhaskell/haskell-vim'

  use 'norcalli/nvim-colorizer.lua'
  use 'ntpeters/vim-better-whitespace'
  use 'sbdchd/neoformat'
  use 'sheerun/vim-polyglot'

  -- use {'Olical/aniseed', tag = 'v3.5.0'}
  -- use 'Olical/conjure'
  -- use 'bakpakin/fennel.vim'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'

  -- use 'gruvbox-community/gruvbox'
  use 'sainnhe/gruvbox-material'

  use 'norcalli/snippets.nvim'
  use 'norcalli/nvim_utils'
end)
