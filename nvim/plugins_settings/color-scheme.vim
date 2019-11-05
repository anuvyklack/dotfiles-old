" let s:theme = 'ayu'
" let s:theme = 'onedark'
" let s:theme = 'gruvbox'
" let s:theme = 'OceanicNext'
let s:theme = 'blaquemagick'

if s:theme == 'onedark'
    let g:onedark_hide_endofbuffer = 1
    let g:onedark_terminal_italics = 1  " italic for comments

    let g:onedark_color_overrides = {
    \   "comment_grey": { "gui": "#666e7d", "cterm": "59", "cterm16": "15" },
    \}

    let s:colors = onedark#GetColors()

    if (has("autocmd"))
      augroup colorextend
        autocmd!
        " Override Foldcolumn color
        autocmd ColorScheme * call onedark#extend_highlight("FoldColumn", { "fg": s:colors.comment_grey })
      augroup END
    endif

    colorscheme onedark
    let g:airline_theme='onedark'

elseif s:theme == 'gruvbox'
    colorscheme gruvbox
    let g:airline_theme = 'gruvbox'

elseif s:theme == 'ayu'
    " let ayucolor="light"  " for light version of theme
    let ayucolor = "mirage" " for mirage version of theme
    " let ayucolor="dark"   " for dark version of theme
    colorscheme ayu
    let g:airline_theme = 'ayu'

    " ----------------- IndentLine -------------------
    let g:indentLine_char = '┊'
    let g:indentLine_first_char = '┊'
    " let g:indentLine_char_list = ['|', '¦', '┆', '┊']
    let g:indentLine_showFirstIndentLevel = 1
    let g:indentLine_setColors = 0

elseif s:theme == 'OceanicNext'
    colorscheme OceanicNext
    let g:airline_theme='oceanicnext'

elseif s:theme == 'blaquemagick'
    colorscheme blaquemagick

endif
