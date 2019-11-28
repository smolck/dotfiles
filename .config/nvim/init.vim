"""""""""""""""""""""""""""""""""""""""""""""""""""" Plug-ins """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()

Plug 'dart-lang/dart-vim-plugin'

Plug 'gruvbox-community/gruvbox'
Plug 'joshdick/onedark.vim'

Plug 'neovim/nvim-lsp'

Plug 'bakpakin/fennel.vim'
Plug 'jaawerth/fennel-nvim', {'branch': 'dev'}

Plug 'ncm2/ncm2-cssomni'
Plug 'ncm2/ncm2-tern',  {'do': 'npm install'}
Plug 'clojure-vim/async-clj-omni'
Plug 'tpope/vim-fireplace'

Plug 'shlomif/vim-extract-variable'

" Floating-window-utilizing plugins.
Plug 'rhysd/git-messenger.vim'
Plug 'voldikss/vim-floaterm'
Plug 'ncm2/float-preview.nvim'

Plug 'sbdchd/neoformat'

Plug 'sainnhe/gruvbox-material'

Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'roxma/nvim-yarp'

Plug 'Yggdroot/indentLine'
Plug 'mhinz/vim-startify'

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

Plug 'ntpeters/vim-better-whitespace'
Plug 'ctrlpvim/ctrlp.vim'

Plug 'kassio/neoterm'

Plug 'neomake/neomake'

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vimwiki/vimwiki'

call plug#end()

" Define these Lightline functions for use in Lightline. Must be
" loaded before the `luafile ~/.config/nvim/init.lua` line AFAIK.
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

luafile ~/.config/nvim/init.lua


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""" General Settings """""""""""""""""""""""""""""""""""""""""""""""""""""""""

" GNvim settings
if exists('g:gnvim') || exists('g:fvim_loaded')
    set guicursor += a:blinkon333
    " call gnvim#tabline#disable()
endif

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
autocmd Filetype dart,rust,python,go,c,cpp setl omnifunc=lsp#omnifunc
" setl omnifunc=lsp#omnifunc
autocmd Filetype fennel setl omnifunc=fnl#omniComplete
autocmd Filetype lua setl omnifunc=fnl#omniCompleteLua

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

au FocusGained * checktime

" GitMessenger remap
nnoremap <Leader>git :GitMessenger<CR>

" Floaterm config (au lieu de Nuake)
nnoremap <Leader>t :FloatermToggle<CR>
inoremap <Leader>t <C-\><C-n>:FloatermToggle<CR>
tnoremap <Leader>t <C-\><C-n>:FloatermToggle<CR>

" tnoremap <Leader>api :new|put =map(filter(api_info().functions, '!has_key(v:val,''deprecated_since'')'), 'v:val.name')

nnoremap <Up> :lua jump(0)<CR>
nnoremap <Right> :lua move_forward(0)<CR>

function! SynStack()
    if !exists('*synstack')
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction
nnoremap ? :call SynStack()<CR>

function! ClearThings()
    echo ""
endfunction

nnoremap <Leader>cc :call ClearThings()<CR>

let g:strip_whitespace_on_save = 1
let g:strip_max_file_size = 1000
let g:strip_whitespace_confirm = 0

" No arrow keys
" noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
" noremap <Right> <nop>

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

set rtp+=<SHARE_DIR>/merlin/vim
