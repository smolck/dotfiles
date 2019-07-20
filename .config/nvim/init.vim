"""""""""""""""""""""""""""""""""""""""""""""""""""" Plug-ins """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()

Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'roxma/nvim-yarp'
Plug 'udalov/kotlin-vim'

Plug 'tyrannicaltoucan/vim-quantum'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'reedes/vim-colors-pencil'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug 'vim-airline/vim-airline'
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
Plug 'sheerun/vim-polyglot'

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction

Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
Plug 'ntpeters/vim-better-whitespace'
Plug 'ctrlpvim/ctrlp.vim'

Plug 'kassio/neoterm'
Plug 'Lenovsky/nuake'

Plug 'neomake/neomake'

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'vimwiki/vimwiki'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""" General Settings """""""""""""""""""""""""""""""""""""""""""""""""""""""""

let mapleader = ";"
let g:airline_powerline_fonts = 1
let g:polyglot_disabled = ['kotlin']

set textwidth=80
set splitbelow
set splitright

set title

cd $HOME " << Start nvim at home dir

" GNvim settings
if exists('g:gnvim')
    set guicursor+=a:blinkon333
    "set guifont=Iosevka\ Heavy:h11
    set guifont=Fantasque\ Sans\ Mono\ Bold:h11
endif

set number
set encoding=UTF-8
set background=dark
set path+=**
set wildmenu
set shiftwidth=4
set tabstop=4
set autoindent
set smartindent
set relativenumber
set autochdir
if has('termguicolors')
    set termguicolors
endif
set expandtab
set smarttab
set hlsearch
set smartcase
set cursorline
set linebreak
set wrap
set lazyredraw
set nocompatible


" For custom mappings
syntax enable
filetype plugin on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""" Autocomplete Settings """"""""""""""""""""""""""""""""""""""""""""""""""""

call neomake#configure#automake('nrwi', 500) " << Must be called after 'plug#end()'
autocmd BufEnter * call ncm2#enable_for_buffer() " enable ncm2 for all buffers
set completeopt=menuone,noinsert,noselect,preview

" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'python': ['~/.local/bin/pyls'],
    \ 'cpp': ['clangd'],
    \ 'go': ['~/go/bin/gopls'],
    \ 'kotlin': ['kotlin-language-server'],
    \ 'lua': ['~/.luarocks/bin/lua-lsp']
    \ }

let g:neomake_cpp_enabled_makers = ['clangd']
let python_highlight_all=1

"""""""""""""""""""""""""""""""""""""""""""""""""""" Custom Mappings """"""""""""""""""""""""""""""""""""""""""""""""""""

" Remove trailing whitespaces when wanted.
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
noremap <leader>w :call DeleteTrailingWS()<CR>

" Nuake config
nnoremap <Leader>t :Nuake<CR>
inoremap <Leader>t <C-\><C-n>:Nuake<CR>
tnoremap <Leader>t <C-\><C-n>:Nuake<CR>

let g:strip_whitespace_on_save = 1
let g:strip_max_file_size = 1000
let g:strip_whitespace_confirm = 0

" No arrow keys
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>

" Easy buffer navigation
map <Leader>n :bn<CR>
map <Leader>p :bp<CR>
map <Leader>d :bd<CR>

" NERDTree Custom Commands
" autocmd VimEnter * silent NERDTree | wincmd p
nnoremap ,nerd :NERDTreeToggle<CR>
nnoremap <Leader>r :NERDTreeFocus<CR>:NERDTreeRefreshRoot<CR><C-w><C-w>

" Command to move around code snippets
inoremap \\ <Esc>/<++><CR>ca>

" C++ code snippets
autocmd FileType html inoremap ;b <button></button><Esc>FuT>i
autocmd FileType h,hpp,cpp inoremap ;if if<Space>()<Space>{<CR><++><CR>}<Esc>2k4li
autocmd FileType h,cpp,hpp inoremap ;for for<Space>()<Space>{<CR><++><CR>}<Esc>2k5li

" Rust code snippets
autocmd FileType rust inoremap ;mat match<Space><Space>{<CR><++><CR>}<Esc>2kfh<Space>a
autocmd FileType rust inoremap ;if if<Space><Space>{<CR><++><CR>}<Esc>2kff<Space>a
autocmd FileType rust inoremap ;fn fn<Space>temp(<++>)<Space><++>{<CR><++><CR>}<Esc>2kftciw

" Esc out of nvim terminal
tnoremap <Esc> <C-\><C-n>

" Map a command for opening nvim this config file
cmap ,init sp<Space>~/.config/nvim/init.vim<CR>
" Map a command for typing 'reset' after making term window for GNvim (due to
" wierd bug/not-really-sure)
cmap ,ter vs<CR><Esc>:terminal<CR><Esc>Areset<CR><Esc>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""" Customization """"""""""""""""""""""""""""""""""""""""""""""""""""

colo pencil

let g:airline#extensions#tabline#enabled = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
