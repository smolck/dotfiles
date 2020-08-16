vim.cmd [[packadd packer.nvim]]
vim._update_package_paths()

require('packer').startup(function()
  use {'wbthomason/packer.nvim', opt = true}
  use 'tjdevries/nlua.nvim'
  use 'nvim-lua/plenary.nvim'
  use '~/dev/lua/nvim-todoist.lua/'
  use 'editorconfig/editorconfig-vim'
  -- use 'neovimhaskell/nvim-hs.vim'
  -- use '~/dev/lua/org.nvim'
  use 'sainnhe/tmuxline.vim'
  use {'neoclide/coc.nvim', branch = 'release'}

  use 'jiangmiao/auto-pairs'
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'

  use 'wakatime/vim-wakatime'
  use 'Yggdroot/indentLine'
  use 'airblade/vim-gitgutter'
  use 'itchyny/lightline.vim'
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
  use 'sheerun/vim-polyglot'
  use 'taohexxx/lightline-buffer'


  use {'Olical/aniseed', tag = 'v3.5.0'}
  use 'Olical/conjure'
  use 'bakpakin/fennel.vim'
  -- use 'SirVer/ultisnips'
  -- use 'honza/vim-snippets'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'

  use 'gruvbox-community/gruvbox'
  use 'sainnhe/gruvbox-material'
end)
