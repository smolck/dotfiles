if !exists('g:vscode')
    lua require('plugins')
    " lua require('init')
    " lua require('nvim-todoist.ui').init()
    " lua require('aniseed.dotfiles')

    hi! Cursor guifg='Red'
    " hi! Normal guibg=none
    " hi! CursorLine guibg=none
    " hi! EndOfBuffer guibg=none

    " lua require('orgnvim').setup()

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

    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set rtp^="/home/smolck/.opam/default/share/ocp-indent/vim"
endif
