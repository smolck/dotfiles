"""""""""""""""""""""""""""""""""""""""""""""""""""" Plug-ins """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()

" Plug 'jiangmiao/auto-pairs'
Plug 'ncm2/ncm2-cssomni'
Plug 'ncm2/ncm2-tern',  {'do': 'npm install'}
Plug 'clojure-vim/async-clj-omni'
Plug 'tpope/vim-fireplace'

" Floating-window-utilizing plugins.
Plug 'rhysd/git-messenger.vim'
Plug 'voldikss/vim-floaterm'
Plug 'ncm2/float-preview.nvim'

Plug 'OmniSharp/omnisharp-vim'

Plug 'sbdchd/neoformat'

Plug 'ryanoasis/vim-devicons'

Plug 'sainnhe/gruvbox-material'

Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'roxma/nvim-yarp'
" Plug 'udalov/kotlin-vim'

Plug 'Yggdroot/indentLine'
Plug 'mhinz/vim-startify'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug 'itchyny/lightline.vim'
Plug 'taohexxx/lightline-buffer'

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
Plug 'vimwiki/vimwiki'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""" General Settings """""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:floaterm_position = 'center'
let g:floaterm_width = &columns/2

let g:OmniSharp_server_stdio = 1
let g:OmniSharp_highlight_types = 2
let g:OmniSharp_timeout = 5

let mapleader = ";"
let g:airline_powerline_fonts = 1
" let g:polyglot_disabled = ['kotlin']

set textwidth=80
set splitbelow
set splitright

set title

set ignorecase

cd $HOME " << Start nvim at home dir

" GNvim settings
if exists('g:gnvim') || exists('g:fvim_loaded')
    set guicursor+=a:blinkon333
    " set guifont=Fantasque\ Sans\ Mono\ Bold:h11
    set guifont=Iosevka\ Extrabold:h16

    " call gnvim#tabline#disable()
endif

if exists('g:fvim_loaded')
    set guifont=Iosevka\ Extrabold:h20
    FVimCursorSmoothMove v:true

    FVimCursorSmoothBlink v:true
endif

set number
set encoding=UTF-8
set background=dark
set path+=**
set wildmenu

set tabstop=4
set shiftwidth=4
set softtabstop=4

set expandtab
set smarttab
set autoindent

set relativenumber
set autochdir
if has('termguicolors')
    set termguicolors
endif
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
set completeopt=menuone,noinsert,noselect

" Required for operations modifying multiple buffers like rename.
set hidden

" \ 'haskell': ['hie-wrapper'],
let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'python': ['~/.local/bin/pyls'],
    \ 'cpp': ['clangd'],
    \ 'kotlin': ['kotlin-language-server'],
    \ 'lua': ['~/.luarocks/bin/lua-lsp'],
    \ 'go': ['$GOPATH/bin/gopls'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'reason': ['$HOME/dev/reason-ls/rls-linux/reason-language-server'],
    \ 'ocaml': ['ocaml-language-server', 'stdio'],
    \ 'scala': ['~/dev/scala/metals-vim'],
    \ 'sbt': ['~/dev/scala/metals-vim'],
    \ 'dart': ['dart', '/opt/dart-sdk-dev/bin/snapshots/analysis_server.dart.snapshot', '--lsp']
    \ }
    " \ 'reason': ['~/dev/reason-ls/rls-linux/reason-language-server'],

let g:neomake_cpp_enabled_makers = ['clangd']
let python_highlight_all=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""" Custom Mappings """"""""""""""""""""""""""""""""""""""""""""""""""""

" Remove trailing whitespaces when wanted.
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
noremap <leader>w :call DeleteTrailingWS()<CR>

" GitMessenger remap
nnoremap <Leader>git :GitMessenger<CR>

" Floaterm config (au lieu de Nuake)
nnoremap <Leader>t :FloatermToggle<CR>
inoremap <Leader>t <C-\><C-n>:FloatermToggle<CR>
tnoremap <Leader>t <C-\><C-n>:FloatermToggle<CR>

" tnoremap <Leader>api :new|put =map(filter(api_info().functions, '!has_key(v:val,''deprecated_since'')'), 'v:val.name')

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
" nnoremap ,nerd :NERDTreeToggle<CR>
" nnoremap <Leader>r :NERDTreeFocus<CR>:NERDTreeRefreshRoot<CR><C-w><C-w>

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

" Indentation for diff. filetypes
autocmd FileType javascript setlocal shiftwidth=2
autocmd FileType scala setlocal shiftwidth=2
autocmd FileType dart setlocal shiftwidth=2

" Esc out of nvim terminal
tnoremap <Esc> <C-\><C-n>

" Map a command for opening nvim this config file.
nnoremap <Leader>init :sp<Space>~/.config/nvim/init.vim<CR>

" YTC -> 'Yank To Clipboard'
nnoremap <Leader>ytc "+y

" LanguageClient conf
nnoremap <silent> <Leader>hov :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>

" :inoremap ( ()<Esc>i

" Map a command for typing 'reset' after making term window for GNvim (due to
" wierd bug/not-really-sure)
"  cmap ,ter vs<CR><Esc>:terminal<CR><Esc>Areset<CR><Esc>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""" Customization """"""""""""""""""""""""""""""""""""""""""""""""""""

let g:onedark_terminal_italics = 1
" set bg=light
colo gruvbox-material
let gruvbox_material_background = 'soft'

" For switching colorschemes depending on time of day.
" let hr = (strftime('%H'))
" if hr >= 17
"     set bg=dark
" elseif hr >= 9
"     set bg=light
" elseif hr >= 0
"     set bg=dark
" endif

" colo onedark

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""" Statusline (Lightline) """""""""""""""""""""""""""""""""""""""""""

set hidden  " allow buffer switching without saving
set showtabline=2  " always show tabline

" use lightline-buffer in lightline
let g:lightline = {
    \ 'colorscheme': 'gruvbox_material',
    \ 'tabline': {
    \   'left': [ [ 'bufferinfo' ],
    \             [ 'separator' ],
    \             [ 'bufferbefore', 'buffercurrent', 'bufferafter' ], ],
    \   'right': [ [ 'close' ], ],
    \ },
    \   'active': {
    \     'left': [ [ 'mode', 'paste' ],
    \             [ 'fugitive', 'readonly', 'filename', 'modified' ]
    \     ]
    \ },
    \ 'component_expand': {
    \   'buffercurrent': 'lightline#buffer#buffercurrent',
    \   'bufferbefore': 'lightline#buffer#bufferbefore',
    \   'bufferafter': 'lightline#buffer#bufferafter',
    \ },
    \ 'component_type': {
    \   'buffercurrent': 'tabsel',
    \   'bufferbefore': 'raw',
    \   'bufferafter': 'raw',
    \ },
    \ 'component_function': {
    \   'bufferinfo': 'lightline#buffer#bufferinfo',
    \   'readonly': 'LightlineReadonly',
    \   'fugitive': 'LightlineFugitive'
    \ }
    \ }

let g:lightline.separator = {
	\   'left': '', 'right': ''
  \}
let g:lightline.subseparator = {
	\   'left': '', 'right': ''
  \}


function! LightlineReadonly()
   return &readonly ? '' : ''
endfunction

function! LightlineFugitive()
   if exists('*fugitive#head')
   	let branch = fugitive#head()
   	return branch !=# '' ? ''.branch : ''
   endif
   return ''
endfunction

" let g:airline_powerline_fonts = 1

" lightline-buffer ui settings
" replace these symbols with ascii characters if your environment does not support unicode
let g:lightline_buffer_logo = ' '
let g:lightline_buffer_readonly_icon = ''
let g:lightline_buffer_modified_icon = '✭'
let g:lightline_buffer_git_icon = ' '
let g:lightline_buffer_ellipsis_icon = '..'
let g:lightline_buffer_expand_left_icon = '◀ '
let g:lightline_buffer_expand_right_icon = ' ▶'
let g:lightline_buffer_active_buffer_left_icon = ''
let g:lightline_buffer_active_buffer_right_icon = ''
let g:lightline_buffer_separator_icon = '  '

" enable devicons, only support utf-8
" require <https://github.com/ryanoasis/vim-devicons>
let g:lightline_buffer_enable_devicons = 1

" lightline-buffer function settings
let g:lightline_buffer_show_bufnr = 1

" :help filename-modifiers
let g:lightline_buffer_fname_mod = ':t'

" hide buffer list
let g:lightline_buffer_excludes = ['vimfiler']

" max file name length
let g:lightline_buffer_maxflen = 30

" max file extension length
let g:lightline_buffer_maxfextlen = 3

" min file name length
let g:lightline_buffer_minflen = 16

" min file extension length
let g:lightline_buffer_minfextlen = 3

" reserve length for other component (e.g. info, close)
let g:lightline_buffer_reservelen = 20

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set rtp+=<SHARE_DIR>/merlin/vim
