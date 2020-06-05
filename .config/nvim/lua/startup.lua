local plug = require('lua_helpers').plug

plug('~/.config/nvim/plugged', {
  '/home/smolck/dev/lua/org.nvim',

  'jiangmiao/auto-pairs',

  'scrooloose/nerdtree',
  'liuchengxu/vim-which-key',
  'rbgrouleff/bclose.vim',
  'francoiscabrol/ranger.vim',

  'wakatime/vim-wakatime',

  'Vigemus/nvimux',
  'Yggdroot/indentLine',

  'airblade/vim-gitgutter',


  'clojure-vim/async-clj-omni',
  'ctrlpvim/ctrlp.vim',
  'dart-lang/dart-vim-plugin',
  'itchyny/lightline.vim',
  'joshdick/onedark.vim',
  'mhinz/vim-startify',

  'guns/vim-clojure-static',
  'guns/vim-clojure-highlight',
  'junegunn/rainbow_parentheses.vim',

  {'eraserhd/parinfer-rust', ['do'] = 'nix-shell --run "cargo build --release"'},

  'kdheepak/lazygit.vim',

  'slashmili/alchemist.vim',
  -- 'ncm2/ncm2',
  -- 'ncm2/float-preview.nvim',
  -- 'ncm2/ncm2-bufword',
  -- 'ncm2/ncm2-cssomni',
  -- 'ncm2/ncm2-path',
  -- 'roxma/nvim-yarp',

  'neovim/nvim-lsp',

  'haorenW1025/completion-nvim',

  'neovimhaskell/haskell-vim',
  'norcalli/nvim-colorizer.lua',
  'ntpeters/vim-better-whitespace',
  'rhysd/git-messenger.vim',
  'sainnhe/gruvbox-material',
  'sbdchd/neoformat',
  'sheerun/vim-polyglot',
  'taohexxx/lightline-buffer',

  -- 'tpope/vim-fireplace',
  {'Olical/conjure', tag = 'v3.4.0'},
  {'Olical/aniseed', tag = 'v3.5.0' },
  'bakpakin/fennel.vim',

  'SirVer/ultisnips',
  'honza/vim-snippets',

  'tpope/vim-repeat',
  'tpope/vim-surround',
  'vimwiki/vimwiki',
  {'jaawerth/fennel-nvim', branch = 'dev'},
  {'ncm2/ncm2-tern', ['do'] = 'npm install'},
})
