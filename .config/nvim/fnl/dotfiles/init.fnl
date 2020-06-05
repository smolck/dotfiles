(module dotfiles.init
  {require {os os
            a aniseed.core
            nvim aniseed.nvim
            helpers dotfiles.helpers
            nvimux nvimux
            nvim-lsp nvim_lsp
            util nvim_lsp.util
            configs nvim_lsp.configs
            completion-nvim completion}})

;; Vim function definitions {{{
(defn define-vim-functions []
  (helpers.define-nvim-fn
    :BuildComposer
        (fn [info]
          (if
            (not (or (= info.status "unchanged") info.force))
            (if (nvim.fn.has "nvim")
              (nvim.command "!cargo build --release")
              (nvim.command "!cargo build --release --no-default-features --features json-rpc")))))
  (helpers.define-nvim-fn
    :LightlineReadonly
      (fn [] (if (nvim.g.readonly) "" "")))
  (nvim.command "
    function! DeleteTrailingWS()
      exe 'normal mz'
      %s/\\s\\+$//ge
      exe 'normal `z'
    endfunction")
  (nvim.command "
    function! SynStack()
        if !exists('*synstack')
            return
        endif
        echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, \"name\")')
    endfunction")
  (nvim.command "
    function! LightlineFugitive()
       if exists('*fugitive#head')
        let branch = fugitive#head()
        return branch !=# '' ? ''.branch : ''
       endif
       return ''
    endfunction"))
;; }}}

;; Plugins {{{
(defn plugins []
  (helpers.plug
    "~/.config/nvim/plugged"
    ["/home/smolck/dev/lua/org.nvim"
     "jiangmiao/auto-pairs"
     "scrooloose/nerdtree"
     "liuchengxu/vim-which-key"
     "rbgrouleff/bclose.vim"

     "francoiscabrol/ranger.vim"

     "wakatime/vim-wakatime"

     "Yggdroot/indentLine"

     "airblade/vim-gitgutter"


     "clojure-vim/async-clj-omni"
     "ctrlpvim/ctrlp.vim"
     "dart-lang/dart-vim-plugin"
     "itchyny/lightline.vim"
     "joshdick/onedark.vim"
     "mhinz/vim-startify"

     "guns/vim-clojure-static"
     "guns/vim-clojure-highlight"
     "junegunn/rainbow_parentheses.vim"

     {:package "eraserhd/parinfer-rust" :do "nix-shell --run \"cargo build --release\""}

     "kdheepak/lazygit.vim"

     "slashmili/alchemist.vim"
     ;; 'ncm2/ncm2',
     ;; 'ncm2/float-preview.nvim',
     ;; 'ncm2/ncm2-bufword',
     ;; 'ncm2/ncm2-cssomni',
     ;; 'ncm2/ncm2-path',
     ;; 'roxma/nvim-yarp',

     "neovim/nvim-lsp"

     "neovimhaskell/haskell-vim"
     "norcalli/nvim-colorizer.lua"
     "ntpeters/vim-better-whitespace"
     "rhysd/git-messenger.vim"
     "sainnhe/gruvbox-material"
     "sbdchd/neoformat"
     "sheerun/vim-polyglot"
     "taohexxx/lightline-buffer"

     ;; {:package "Olical/conjure" :tag "v3.4.0"}
     ;; {:package "Olical/aniseed" :tag "v3.5.0"}
     ;; "bakpakin/fennel.vim"

     "SirVer/ultisnips"
     "honza/vim-snippets"

     "tpope/vim-repeat"
     "tpope/vim-surround"
     "vimwiki/vimwiki"
     {:package "jaawerth/fennel-nvim" :branch "dev"}
     {:package "ncm2/ncm2-tern" :do "npm install"}]))
;; }}}

;; Nvimux Config {{{
;; (defn nvimux-config []
;;   (nvim.config.set_all
;;     {:prefix "<C-a>"
;;      :new_window "term"
;;      :new_tab nil
;;      :new_window_buffer "single"
;;      :quickterm_direction "botright"
;;      :quickterm_orientation "vertical"
;;      :quickterm_scope "g" ;; Use 'g' for global quickterm
;;      :quickterm_size "80"}))
;; }}}

;; Config for LSPs {{{
(defn lsp-config []
  (let [completion-on-attach completion-nvim.on_attach
        home (os.getenv "HOME")
        dart-aserver-snapshot-path
          (.. home
              "/flutter/bin/cache/dart-sdk/bin/snapshots/analysis_server.dart.snapshot")
        bare-setup {:on_attach completion-on-attach}
        empty {}]
    (nvim-lsp.metals.setup {:on_attach completion-on-attach :cmd ["metals-vim"]})
    (nvim-lsp.ccls.setup {})
    (nvim-lsp.pyls.setup bare-setup)
    (nvim-lsp.gopls.setup
      {:on_attach completion-on-attach
       :cmd [(.. home "/dev/go/bin/gopls")]})
    (nvim-lsp.tsserver.setup bare-setup)
    (tset configs :dart_analyzer
         {:default_config
          {:cmd ["dart" dart-aserver-snapshot-path "--lsp"]
           :filetypes ["dart"]
           :root_dir (util.root_pattern "pubspec.yaml")
           :log_level vim.lsp.protocol.MessageType.Warning
           :settings empty}}) ;; Use `empty` so the surrounding fold works (otherwise there'd be three "}" chars in a row).
    (tset configs :elixir_ls
          {:default_config
           {:cmd [(.. home "/dev/elixir/elixir-ls/language_server.sh")]
            :filetypes ["elixir" "eelixir"]
            :root_dir (util.root_pattern "mix.exs" ".git")
            :log_level vim.lsp.protocol.MessageType.Warning
            :settings empty}}))) ;; See note above.
    ;; (nvim_lsp.dart_analyzer.setup bare-setup)
    ;; (nvim_lsp.elixir_ls.setup bare-setup)

;; }}}

;; Globals {{{
(defn lightline []
  (tset vim.g :lightline
        {:colorscheme "gruvbox_material"
         :tabline
           {:left [["bufferinfo"] ["separator"] ["bufferbefore" "buffercurrent" "bufferafter"]]
            :right [["tabs" "close"]]}
         :active {:left [["mode" "paste"] ["fugitive" "readonly" "filename" "modified"]]}
         :component_expand {:buffercurrent "lightline#buffer#buffercurrent"
                            :bufferbefore "lightline#buffer#bufferbefore"
                            :bufferafter "lightline#buffer#bufferafter"}
         :component_type {:buffercurrent "tabsel"
                          :bufferbefore "raw"
                          :bufferafter "raw"}
         :component_function {:bufferinfo "lightline#buffer#bufferinfo"
                              :readonly "LightlineReadonly"
                              :fugitive "LightlineFugitive"}})
  (helpers.assoc-mut vim.g
    { ;; Lightline-buffer UI settings}
      :lightline_buffer_logo                     " "
      :lightline_buffer_readonly_icon            ""
      :lightline_buffer_modified_icon            "✭"
      :lightline_buffer_git_icon                 " "
      :lightline_buffer_ellipsis_icon            ".."
      :lightline_buffer_expand_left_icon         "◀ "
      :lightline_buffer_expand_right_icon        " ▶"
      :lightline_buffer_active_buffer_left_icon  ""
      :lightline_buffer_active_buffer_right_icon ""
      :lightline_buffer_separator_icon           "  "

      ;; Requires <https://github.com/ryanoasis/vim-devicons>}
      :lightline_buffer_enable_devicons          1

      :lightline_buffer_show_bfnr                1

      ;; See `:help filename-modifiers`
      :lightline_buffer_fname_mod                ":t"

      ;; Hide buffer list
      :lightline_buffer_excludes                 ["vimfiler"]

      :lightline_buffer_maxflen                  30 ;; Max file name length
      :lightline_buffer_minflen                  16 ;; Min file name length

      :lightline_buffer_maxfextlen               30 ;; Max file extension length
      :lightline_buffer_minfextlen               3  ;; Min file extension length

      ;; Reserve length for other componenet (e.g. info, close)
      :lightline_buffer_reservelen               20}))

(defn define-globals []
  (lightline)

  (let [home (os.getenv "HOME")]
    (helpers.assoc-mut
      vim.g
      {:completion_enable_snippet "UltiSnips"
       :startify_custom_header_quotes [[(os.getenv "VERSEOFDAY")]]
       :polyglot_disabled ["dart" "haskell"]
       :floaterm_position "center"
       :floaterm_width (/ nvim.o.columns 2)
       :mapleader ";"
       :maplocalleader ";"

       ;; :colors_name "gruvbox-material"
       :neomake_cpp_enabled_makers ["clangd"]
       :python_highlight_all 1
       :strip_whitespace_on_save 1
       :strip_max_file_size 1000
       :strip_whitespace_confirm 0

       :opamshare (nvim.fn.substitute (nvim.fn.system "opam config var share") "\n$" "" "''")
       :neoformat_basic_format_align 1
       :neoformat_basic_format_retab 1
       :neoformat_try_formatprg 1

       :UltiSnipsExpandTrigger "<tab>"
       :UltiSnipsJumpForwardTrigger "<c-b>"
       :UltiSnipsJumpBackwardTrigger "<c-z>"})))
       ;; :org_agenda_files ["~/org/todos.org"]})))
;; }}}

;; Options {{{
(defn options []
  (let [home (os.getenv "HOME")]
    (helpers.assoc-mut
      nvim.o
      {:timeoutlen         500
       :modeline           true
       :foldmethod         "marker"

       :textwidth          80
       :splitbelow         true
       :splitright         true
       :title              true
       :ignorecase         true
       :encoding           "UTF-8"
       :background         "dark"
       :path               (.. nvim.o.path "," (vim.api.nvim_call_function "getenv" ["PWD"]))

       :wildmenu           true
       :tabstop            4
       :shiftwidth         4
       :softtabstop        4
       :expandtab          true
       :smarttab           true
       :autoindent         true

       :number             true
       :relativenumber     true
       :autochdir          true
       :hlsearch           true
       :smartcase          true
       :cursorline         true
       :linebreak          true
       :wrap               false
       :lazyredraw         true

       :termguicolors      true
       :guifont            "Iosevka Extrabold:h14"

       :hidden             true
       :showtabline        2 ;; Always show tabline.
       :completeopt        "menuone,noinsert,noselect"

       :shortmess          (.. nvim.o.shortmess "c")

       :runtimepath        (.. nvim.o.runtimepath
                               "," home "/.luarocks/share")})))

       ;; Should be equivalent to `set rtp+=<SHARE_DIR>/merlin/vim` in VimL
       ;; :rtp             (.. nvim.o.rtp ',' vim.g.opamshare "/merlin/vim"})))
;; }}}

;; Autocmds {{{
(defn create-autocmds []
  (helpers.nvim-create-augroups
    {:indentation [["FileType" "javascript,scala,dart" "setlocal shiftwidth=2"]
                   ["FileType" "go" "setlocal shiftwidth=4"]]
     :omnifunc [["FileType"
                 "dart,rust,python,go,c,cpp,scala,elixir"
                 "setlocal omnifunc=v:lua.vim.lsp.omnifunc"]
                ;; ["FileType" "fennel" "setlocal omnifunc=fnl#omniComplete"]]}))
                ["FileType" "lua" "setlocal omnifunc=v:lua.vim.lsp.omnifunc"]]
     :general [["FocusGained" "*" "checktime"]]
     :clojure [["Syntax" "clojure" "ClojureHighlightReferences"]
               ["VimEnter" "*" "RainbowParentheses"]]}))
;; }}}

;; Keymappings {{{
(defn create-keymaps []
  ;; Taken from
  ;; https://github.com/norcalli/nvim_utils/blob/master/lua/nvim_utils.lua
  (let [valid-modes {:n "n" :v "v" :x "x" :i "i"
                     :o "o" :t "t" :c "c" :s "s"
                     ;; :map! and :map
                     :! "!"
                     " " ""}
         helpers-lua (require "lua_helpers")]
    (helpers-lua.nvim_apply_mappings valid-modes
      {"n<Leader>pt"  {1 ":NERDTreeToggle<CR>"      :noremap true}
       "n<Leader>"    {1 ":WhichKey '<Leader>'<CR>" :noremap true :silent true}
       "n<Leader>git" {1 ":GitMessenger<CR>"        :noremap true}

       "n<Leader>n"   {1 ":bn<CR>"                  :noremap true}
       "n<Leader>p"   {1 ":bp<CR>"                  :noremap true}
       "n<Leader>d"   {1 ":bd<CR>"                  :noremap true}

       ;; Esc out of nvim terminal
       "t<Esc>"       {1 "<C-\\><C-n>"              :noremap true}

       ;; YTC -> 'Yank To Clipboard'
       "n<Leader>ytc" {1 "\"+y"                     :noremap true}

       ;; 'n<Leader>cc'  {1 fn() print('') end,         :noremap true},

       ;; fe -> 'Format Elixir'
       ;; ['n<Leader>fe'  ] { format_current_elixir_file,      :noremap true},

       ;; ['n<Up>'        ] {1 function() jump(0) end,           :noremap true},
       ;; ['n<Right>'     ] {1 function() move_forward(0) end,   :noremap true},
       ;; ['n<Left>'      ] {1 function() move_backward(0) end,  :noremap true},
       ;; ['n?'           ] {1 ":call SynStack()<CR>",           :noremap true},

       ;; No arrow keys.
       "n<Up>"         {1 "<nop>"                           :noremap true}
       "n<Down>"       {1 "<nop>"                           :noremap true}
       "n<Left>"       {1 "<nop>"                           :noremap true}
       "n<Right>"      {1 "<nop>"                           :noremap true}
       "i<Up>"         {1 "<nop>"                           :noremap true}
       "i<Down>"       {1 "<nop>"                           :noremap true}
       "i<Left>"       {1 "<nop>"                           :noremap true}
       "i<Right>"      {1 "<nop>"                           :noremap true}

       "n<Leader>init" {1 ":sp<Space>~/.config/nvim/fnl/dotfiles/init.fnl<CR>" :noremap true}})))
;; }}}

;; (nvimux-config)
;; (plugins)
(define-vim-functions)
(define-globals)
(options)
(lsp-config)
(create-autocmds)
(create-keymaps)
(nvim.command ":colorscheme gruvbox-material")
