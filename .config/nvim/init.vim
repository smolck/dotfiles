"""""""""""""""""""""""""""""""""""""""""""""""""""" Plug-ins """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()

Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'roxma/nvim-yarp'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'ncm2/ncm2-vim-lsp'
Plug 'vim-airline/vim-airline'
Plug 'vhakulinen/gnvim-lsp'
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
Plug 'neomake/neomake'

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'vimwiki/vimwiki'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""" General Settings """""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remap leader key
let mapleader = ";"
set textwidth=80
set splitbelow
set splitright

cd $HOME " << Start nvim at home dir
let g:airline_powerline_fonts = 1

" GNvim settings
set guicursor+=a:blinkon333
set guifont=Iosevka\ Extrabold:h11

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
if has('nvim') || has('termguicolors')
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
filetype plugin on
syntax enable

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""" Autocomplete Settings """"""""""""""""""""""""""""""""""""""""""""""""""""

" Full config: when writing or reading a buffer, and on changes in insert and
" normal mode (after 1s; no delay when writing).
call neomake#configure#automake('nrwi', 500) " << Must be called after 'plug#end()'

" Required for operations modifying multiple buffers like rename.
set hidden

autocmd BufEnter * call ncm2#enable_for_buffer() " enable ncm2 for all buffers
set completeopt=noinsert,menuone,noselect " IMPORTANT: :help Ncm2PopupOpen for more information

" let g:LanguageClient_serverCommands = {
"     \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
"     \ }

let g:neomake_cpp_enabled_makers = ['clangd']

if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '-background-index']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif
if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
        \ 'workspace_config': {'rust': {'clippy-preference': 'on'}},
        \ 'whitelist': ['rust'],
        \ })
endif
if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif

let python_highlight_all=1

"""""""""""""""""""""""""""""""""""""""""""""""""""" Custom Mappings """"""""""""""""""""""""""""""""""""""""""""""""""""

" Remove trailing whitespaces when wanted.
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
noremap <leader>w :call DeleteTrailingWS()<CR>

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

colorscheme challenger_deep " << Must be called after plug#end
let g:airline#extensions#tabline#enabled = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
