if !exists('g:vscode')
    let g:polyglot_disabled = [ 'dart', 'haskell', 'ocaml' ]

    lua require('globals')
    lua require('plugins')

    if exists('g:gnvim')
        set guifont=Fira\ Code:h8
    endif
    " set termguicolors
    " lua require('init')
    " lua require('nvim-todoist.ui').init()
    " lua require('aniseed.dotfiles')
    " lua require('orgnvim').setup()

    hi! link dartCoreType Red
    hi! link dartUserType Aqua

    let g:tmuxline_preset = {
        \'a'    : '#S',
        \'b'    : '%R',
        \'c'    : [ '#{sysstat_mem} #[fg=blue]\ufa51#{upload_speed}' ],
        \'win'  : [ '#I', '#W' ],
        \'cwin' : [ '#I', '#W', '#F' ],
        \'x'    : [ "#[fg=blue]#{download_speed} \uf6d9 #{sysstat_cpu}" ],
        \'y'    : [ '%a' ],
        \'z'    : '#H #{prefix_highlight}'
        \}
    let g:tmuxline_separators = {
        \ 'left' : "\ue0bc",
        \ 'left_alt': "\ue0bd",
        \ 'right' : "\ue0ba",
        \ 'right_alt' : "\ue0bd",
        \ 'space' : ' '}

    " function! init#floating_window()
    "     let width = min([&columns - 4, max([80, &columns - 20])])
    "     let height = min([&lines - 4, max([20, &lines - 10])])
    "     let top = ((&lines - height) / 2) - 1
    "     let left = (&columns - width) / 2
    "     let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    "     let top = "╭" . repeat("─", width - 2) . "╮"
    "     let mid = "│" . repeat(" ", width - 2) . "│"
    "     let bot = "╰" . repeat("─", width - 2) . "╯"
    "     let lines = [top] + repeat([mid], height - 2) + [bot]
    "     let s:buf = nvim_create_buf(v:false, v:true)
    "     call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    "     call nvim_open_win(s:buf, v:true, opts)
    "     " set winhl=normal:floating
    "     let opts.row += 1
    "     let opts.height -= 2
    "     let opts.col += 2
    "     let opts.width -= 4
    "     call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    "     au bufwipeout <buffer> exe 'bw '.s:buf
    " endfunction
    " let g:fzf_layout = { 'window': 'call init#floating_window()' }

    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    " set rtp^="/home/smolck/.opam/default/share/ocp-indent/vim"
endif
