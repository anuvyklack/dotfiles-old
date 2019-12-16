
"         ███                 ██
"        ░░██                ░░
"  ██████ ░██ ██   ██  ██████ ██ ██████   ██████
" ░██░░░██░██░██  ░██ ██░░░██░██░██░░░██ ██░░░░
" ░██  ░██░██░██  ░██░██  ░██░██░██  ░██░░█████
" ░██████ ░██░██  ░██░░██████░██░██  ░██ ░░░░░██
" ░██░░░  ░██░░█████  ░░░░░██░██░██  ░██ ██████
" ░██     ░░  ░░░░░    █████ ░░ ░░   ░░ ░░░░░░
" ░░                  ░░░░░


" Install Vim-Plug in Unix if not yet                               {{{
" =====================================================================
if has('unix')

    let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')

    if !filereadable(vimplug_exists)
        if !executable("curl")
            echoerr "You have to install curl or first install vim-plug yourself!"
            execute "q!"
        endif
        echo "Installing Vim-Plug..."
        echo ""
        silent exec "!\curl -fLo " . vimplug_exists . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

        autocmd VimEnter * PlugInstall
    endif

endif
" }}}

if has('unix')
    call plug#begin(expand('~/.config/nvim/plugged'))
elseif has('win32')
    call plug#begin(expand('~\AppData\Local\nvim\plugged'))
endif

" -------------------- Прочее ------------------------

Plug 'jiangmiao/auto-pairs'  " автоматическое завершение скобок
Plug 'matze/vim-move'        " перемещение строк и частей строк
Plug 'tpope/vim-surround'    " заключать фрагменты текста в кавычки или скобки
Plug 'godlygeek/tabular'     " Выравнивание текста по различным шаблонам
Plug 'wellle/targets.vim'    " plugin that provides additional text objects
Plug 'majutsushi/tagbar'     " список тегов в текущем файле
" Plug 'kien/tabman.vim'       " Tab management for Vim

Plug 'kshenoy/vim-signature' " display and navigate marks

" Переключение мемжду многострочными конструкциями и однострочными
Plug 'AndrewRadev/splitjoin.vim'

" Show syntax highlighting attributes of character under cursor.
Plug 'vim-scripts/SyntaxAttr.vim'

" Airline                                                           {{{
" =====================================================================

" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
" so ~/.config/nvim/plugins_settings/airline.vim

" }}}

" Beautiful Lightline configuration                                 {{{
" =====================================================================
" https://gist.github.com/sainnhe/b8240bc047313fd6185bb8052df5a8fb

Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'macthecadillac/lightline-gitdiff'
Plug 'maximbaz/lightline-ale'
Plug 'albertomontesg/lightline-asyncrun'
Plug 'rmolin88/pomodoro.vim'
so ~/.config/nvim/plugins_settings/lightline.vim

" Pomodoro                                                          {{{
" ---------------------------------------------------------------------
let g:pomodoro_time_work = 2
let pomodoro_use_devicons = 1
" }}}

" }}}

" ------------------ Autocomplete --------------------

Plug 'ervandew/supertab'

" Plug 'Valloric/YouCompleteMe'
" so ~/.config/nvim/plugins_settings/YouCompleteMe.vim

" Buffexplorer  {{{
Plug 'jlanzarotta/bufexplorer'
let g:bufExplorerFindActive=0   " Do not go to active window.
" }}}

" -------------- Визуальные улучшалки ----------------

" Plug 'Yggdroot/indentLine'     " show indent lines

" подсвечивает все такие же слова что и слово под курсором
Plug 'RRethy/vim-illuminate'

Plug 'inside/vim-search-pulse' " Найденный текст пульсирует

" ----------------------------------------------------

" Colorizer                                                          {{{
" ======================================================================
" Подсвечивает цветовые коды соответствующими цветами
Plug 'lilydjwg/colorizer', { 'on': ['ColorHighlight'] }

"   ColorHighlight  - start/update highlighting
"   ColorClear      - clear all highlights
"   ColorToggle     - toggle highlights

" Запускать подсветку цветоввых кодов на старте
let g:colorizer_startup = 0
" }}}

" Comments                                                           {{{
" ======================================================================
" Plug 'tpope/vim-commentary'  " добавляет оператор вместо набора команд

" tcomment                                                          {{{2
" ----------------------------------------------------------------------
Plug 'tomtom/tcomment_vim'

" }}}2

" NERDCommenter                                                     {{{2
" ----------------------------------------------------------------------

" Plug 'scrooloose/nerdcommenter'  " комментарии всевозможных видов и форм
"
" " so ~/.config/nvim/plugins_settings/NERDCommenter.vim
"
" let g:NERDSpaceDelims = 1        " add spaces around comments
" let g:NERDRemoveExtraSpaces = 1  " remove extra spaces around comments
"
" " Комменировать пустые строки при комментировании блоков текста
" let g:NERDCommentEmptyLines = 1
"
" " Use compact syntax for prettified multi-line comments
" let g:NERDCompactSexyComs = 1

" }}}2

" }}}

"  fzf                                              {{{
" =====================================================
if has('unix')

    if filereadable(expand("~/.zplugin/snippets/fzf.vim/fzf.vim"))
        " If fzf was installed by zplugin
        source ~/.zplugin/snippets/fzf.vim/fzf.vim
    elseif filereadable("/usr/share/doc/fzf/examples/fzf.vim")
        " If fzf was installed through apt.
        source /usr/share/doc/fzf/examples/fzf.vim
    endif
    Plug 'junegunn/fzf.vim'

    " Fzf in a floating window  {{{
    " https://kassioborges.dev/2019/04/10/neovim-fzf-with-a-floating-window.html

    " Reverse the layout to make the FZF list top-down
    let $FZF_DEFAULT_OPTS='--layout=reverse'

    " Using the custom window creation function
    let g:fzf_layout = { 'window': 'call FloatingFZF()' }

    " Function to create the custom floating window
    function! FloatingFZF()
      " creates a scratch, unlisted, new, empty, unnamed buffer
      " to be used in the floating window
      let buf = nvim_create_buf(v:false, v:true)

      " 90% of the height
      let height = float2nr(&lines * 0.7)
      " 60% of the height
      let width = float2nr(&columns * 0.6)
      " horizontal position (centralized)
      let horizontal = float2nr((&columns - width) / 2)
      " vertical position (one line down of the top)
      let vertical = 1

      " Set the position, size, etc. of the floating window.
      " The size configuration here may not be so flexible, and there's
      " room for further improvement.
      let opts = {
            \ 'relative': 'editor',
            \ 'row': vertical,
            \ 'col': horizontal,
            \ 'width': width,
            \ 'height': height
            \ }

      " open the new window, floating, and enter to it
      " call nvim_open_win(buf, v:true, opts)
      let win = nvim_open_win(buf, v:true, opts)

      "Set Floating Window Highlighting
      " call setwinvar(win, '&winhl', 'Normal:Pmenu')

      setlocal
            \ buftype=nofile
            \ nobuflisted
            \ bufhidden=hide
            \ nonumber
            \ norelativenumber
            \ signcolumn=no

    endfunction
    "}}}
endif
" }}}

" LeaderF                                           {{{
" =====================================================
" After running any command of LeaderF, check the value of echo
" g:Lf_fuzzyEngine_C, if the value is 1, it means the C extension is
" loaded sucessfully.

if has('unix')
    Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
elseif has('win32')
    Plug 'Yggdroot/LeaderF', { 'do': '.\install.bat' }
endif

" Show hidden file and directories
let g:Lf_ShowHidden = 1
let g:Lf_UseCache = 0

" Show LeaderF window in popup or floating window
let g:Lf_WindowPosition = 'popup'
let g:Lf_WindowHeight = 0.7
let g:Lf_ShowRelativePath = 0
let g:Lf_CursorBlink = 0
let g:Lf_FollowLinks = 1        " Follow the symlinks
let g:Lf_PreviewCode = 1        " Show the preview of the code the tag
                                " locates in when navigating the tags.

let g:Lf_RememberLastSearch = 1 " The search string you typed during
                                " last search is still there when
                                " LeaderF is launched again. (

let g:Lf_RecurseSubmodules = 0  " Show files in submosules of Git repo
let g:Lf_IgnoreCurrentBufferName = 1  " Remove the current buffer name
                                      " from the result list.

let g:Lf_PopupHeight = float2nr(&lines * 0.7)
let g:Lf_WorkingDirectoryMode = 'Ac'


" Specify the files and directories you want to exclude while indexing.
let g:Lf_WildIgnore = {
        \ 'dir': ['.git'],
        \ 'file': ['*.exe', '*.pdf']
        \}

let g:Lf_PreviewResult = {
        \ 'File': 0,
        \ 'Buffer': 1,
        \ 'Mru': 0,
        \ 'Tag': 0,
        \ 'BufTag': 1,
        \ 'Function': 1,
        \ 'Line': 1,
        \ 'Colorscheme': 0,
        \ 'Rg': 0,
        \ 'Gtags': 0
        \}

" Swttig the mappings in normal mode.
let g:Lf_NormalMap = {
    \ "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>'],
    \            ["<F6>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']
    \           ],
    \ "Buffer": [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<CR>'],
    \            ["<F6>", ':exec g:Lf_py "bufExplManager.quit()"<CR>']
    \           ],
    \ "Mru":    [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<CR>']],
    \ "Tag":    [],
    \ "BufTag": [],
    \ "Function": [],
    \ "Line":   [],
    \ "History":[],
    \ "Help":   [],
    \ "Self":   [],
    \ "Colorscheme": []
    \}

" " Specify a list of ripgrep configurations. For example, >
" let g:Lf_RgConfig = [
"     \ "--max-columns=150",
"     \ "--type-add web:*.{html,css,js}*",
"     \ "--glob=!git/*",
"     \ "--hidden"
" \ ]

" Configure the colorscheme of statusline for LeaderF
" The colorscheme files can be found in the directory:
" LeaderF/autoload/leaderf/colorscheme/
let g:Lf_StlColorscheme = 'gruvbox_material'
let g:Lf_PopupColorscheme = 'gruvbox_material'

" }}}


"  Git                                             {{{
" ====================================================

Plug 'tpope/vim-fugitive'  " git integration

" Plug 'mhinz/vim-signify'  " значки с историей изменений слева от текста

Plug 'junegunn/gv.vim'  " A git commit browser in Vim.

" }}}

" --------------- Motions in window ------------------

" Easymotion {{{
Plug 'easymotion/vim-easymotion'

" so ~/.config/nvim/plugins_settings/easymotion.vim

" Use uppercase target labels and type as a lower case
let g:EasyMotion_use_upper = 1

 " type `l` and match `l` & `L`
let g:EasyMotion_smartcase = 1

" Smartsign (type `3` and match `3` & `#`)
let g:EasyMotion_use_smartsign_us = 1

" При перемещении по строкам курсор будет прыгать не в
" начало строки, а в туже колонку, что и был.
let g:EasyMotion_startofline = 0

" }}}

Plug 'tpope/vim-repeat'

" Clever-f {{{
Plug 'rhysd/clever-f.vim'
let g:clever_f_ignore_case = 1
let g:clever_f_smart_case = 1
let g:clever_f_show_prompt = 1
let g:clever_f_chars_match_any_signs = ';'
" }}}

" Plug 'chaoren/vim-wordmotion'  " More useful word motions for Vim

" Different bidirectional motions: switch buffers, add balnk lines, etc.
Plug 'tpope/vim-unimpaired'

" --------------------- Fold ------------------------
" Plug 'arecarn/vim-fold-cycle'
" Plug 'benknoble/vim-auto-origami'

" Multiple cursors                                 {{{
" ====================================================
Plug 'terryma/vim-multiple-cursors'
" Plug 'mg979/vim-visual-multi', {'branch': 'test'}

" }}}

" Pandoc                                                        {{{
" =================================================================
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

" pandoc settings                                  {{{
" ----------------------------------------------------
" so ~/.config/nvim/plugins_settings/pandoc.vim

let g:pandoc#filetypes#handled = ["pandoc", "markdown"]

" Enable pandoc functionality for markdown files
let g:pandoc#filetypes#pandoc_markdown = 1

" let g:pandoc#modules#enabled = ["formatting", "folding", "toc"]

let g:pandoc#formatting#mode = "s"  " Use soft wraps

let g:pandoc#folding#mode = 'stacked'
let g:pandoc#folding#fdc = 0

let g:pandoc#keyboard#sections#header_style = 's'

let g:pandoc#toc#shift = 2

" Pandoc Syntax
" ----------------------------------------------------

let g:pandoc#syntax#codeblocks#embeds#langs =
            \ ["python", "shell=sh", "bash=sh", "sh", "zsh", "json", "vim"]
" }}}

" }}}

" Python                                                            {{{
" =====================================================================

" Python mode                                                       {{{
" ---------------------------------------------------------------------
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
" so ~/.config/nvim/plugins_settings/python-mode.vim

let g:pymode_run = 1  " возможность запускать код

let g:pymode_python = 'python3'

" GoToDefinition in vertical split
let g:pymode_rope_goto_def_newwin = 'vnew'

" Always open documentation in veertical split on the left
autocmd BufEnter __run__,__doc__ wincmd H

" отключаем автокомплит по коду
" (у нас вместо него используется jedi-vim)
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0

" документация
let g:pymode_doc = 1
let g:pymode_doc_bind = 'K'  " key to show python documentation

" проверка кода
" let g:pymode_lint = 1
" let g:pymode_lint_checkers = ['pyflakes', 'pyling', 'pep8', 'mccabe']
" let g:pymode_lint_ignore="" " E501,W601,C0110
"
" let g:pymode_lint_on_write = 1  " Проверять код при сохранении
" let g:pymode_lint_on_fly = 1    " Проверять код на лету

" Show error message if cursor placed at the error line
let g:pymode_lint_message = 1

" Pylint signs
let g:pymode_lint_todo_symbol = 'WW'
let g:pymode_lint_comment_symbol = 'CC'
let g:pymode_lint_visual_symbol = 'RR'
let g:pymode_lint_error_symbol = 'EE'
let g:pymode_lint_info_symbol = 'II'
let g:pymode_lint_pyflakes_symbol = 'FF'

" let g:pymode_virtualenv = 1  " Enable virtualenvs
" let g:pymode_breakpoint_bind = '<leader>b'
" let g:pymode_virtualenv_path = $VIRTUAL_ENV  " path to the virtualenv

" }}}

" Plug 'vim-python/python-syntax', { 'for': 'python' }
" let g:python_highlight_all = 1

" pudb python degugger integration
Plug 'SkyLeach/pudb.vim', { 'for': 'python' }

" Semantic based code highlighting
" Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins', 'for': 'python'}
" so ~/.config/nvim/plugins_settings/semshi.vim

" Connection to Jupyter QtConsole
" Plug 'broesler/jupyter-vim'
" let g:jupyter_mapkeys = 1  " enable default key mapping

" Looks like it doesn't works with Neovim
" Plug 'williamjameshandley/vimteractive'  " connection with ipython

" Plug 'szymonmaszke/vimpyter'  " edit ipython or ntrect notebooks in vim

" =====================================================================
" }}}

" Rainbow  {{{
" расцвечивание скобок по уровню вложенности
Plug 'luochen1990/rainbow'
" so ~/.config/nvim/plugins_settings/rainbow.vim

" Default: '#c475c1', '#8ab7d8', '#60dd60', '#ffff70', '#ea9d70', '#971717'
" My changes: #7ab061
let g:rainbow_active = 1
let g:rainbow_conf = {
\   'guifgs': ['#c475c1', '#8ab7d8', '#98c369', '#ffff70', '#ea9d70', '#971717'],
\   'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\   'separately': { 'nerdtree': 0, 'pandoc': 0 }
\}
" }}}

" ---------------------- Tags ------------------------

" Автоматически генерировать тэг-файлы
Plug 'ludovicchabant/vim-gutentags'

" --------------------- Wintabs ----------------------

" TODO: разберёмся с этим позже
" Plug 'zefei/vim-wintabs'
" Plug 'zefei/vim-wintabs-powerline'"

" ------------------ Wrighting -----------------------

" wiki.vim                                                          {{{
" ---------------------------------------------------------------------
Plug 'lervag/wiki.vim'
" so ~/.config/nvim/plugins_settings/wiki.vim

let g:wiki_root = '~/wiki'

" List of filetypes for which wiki.vim should be enabled.
let g:wiki_filetypes = ['md', 'wiki']

" The default type of the link: wiki or md.
let g:wiki_link_target_type = 'md'

" A list of TODO toggles that may be toggled with <plug>(wiki-list-toggle),
" which is by default mapped to `<c-s>`.
let g:wiki_list_todos = ['TODO', 'DONE']

" The title of TOC listings.
let g:wiki_toc_title = 'Contents'

" }}}

" Vimwiki                                                           {{{
" ---------------------------------------------------------------------
" Plug 'vimwiki/vimwiki'       " Wiki inside Vim!
" so ~/.config/nvim/plugins_settings/vimwiki.vim

" let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]
" let g:vimwiki_ext2syntax = {'.md': 'markdown'}
" let g:vimwiki_folding='expr'

" }}}

Plug 'junegunn/goyo.vim'  " Beautiful regime for writing

" " Pencil                                                            {{{
" " ---------------------------------------------------------------------
" Plug 'reedes/vim-pencil'  " Writing tools: soft wrap end etc
"
" let g:pencil#wrapModeDefault = 'soft'  " default is 'hard'
"
" " Only work in HardPencil mode;
" let g:pencil#autoformat = 1  " 0=disable, 1=enable (def)
" let g:pencil#textwidth = 80
"
" let g:pencil#joinspaces = 1  " 0=one_space (def), 1=two_spaces
"
" augroup pencil
"     autocmd!
"     autocmd FileType pandoc       call pencil#init()
"     autocmd FileType markdown,mkd call pencil#init()
"     autocmd FileType text         call pencil#init({'wrap': 'hard'})
" augroup END
"
" "}}}

" ----------------------------------------------------

" Smooth scroll                                    {{{
" ====================================================

" " Accelerated smooth scroll {{{
" Plug 'yonchu/accelerated-smooth-scroll'
" let g:ac_smooth_scroll_enable_accelerating = 0
" " }}}

Plug 'yuttie/comfortable-motion.vim'

" To prevent the plugin from defining those default key mappings
let g:comfortable_motion_no_default_key_mappings = 1

let g:comfortable_motion_interval = 17

" mouse wheel to scroll a window by the following mappings:
noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(40)<CR>
noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-40)<CR>

" }}}

" Startify                                                         " {{{
" ======================================================================
Plug 'mhinz/vim-startify'    " Красивый стартовый экран
" so ~/.config/nvim/plugins_settings/startify.vim

" Thw number of most recently used files
let g:startify_files_number = 10

let g:startify_bookmarks = [
\   {'m': '/mnt/d/artyu/OneDrive/Документы/Заметки/Monospace'},
\   {'t': '/mnt/c/Users/artyu/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/profiles.json'},
\   {'a': '/mnt/c/Users/artyu/AppData/Roaming/alacritty/alacritty.yml'},
\]
" \   {'i': '~/.config/nvim/init.vim'},
" \   {'p': '~/.config/nvim/plugins.vim'},
" '~/.zshrc'

let g:startify_lists = [
\   { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
\   { 'type': 'files',     'header': ['   MRU']            },
\   { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
\   { 'type': 'sessions',  'header': ['   Sessions']       },
\   { 'type': 'commands',  'header': ['   Commands']       },
\ ]

let g:startify_fortune_use_unicode = 1

" autocmd! TabNewEntered * Startify
" autocmd! TabNewEntered * Startify


" }}}

" Different syntaxes and languages                                   {{{
" ======================================================================
Plug 'sheerun/vim-polyglot'  " подсветка синтаксисов разных языков
let g:polyglot_disabled = ['markdown']

Plug 'lervag/vimtex', { 'for': 'LaTeX' }  " latex
Plug 'PProvost/vim-ps1', {'for': 'ps1'}   " powershell
Plug 'zplugin/zplugin-vim-syntax', { 'for': 'zsh' }  " Zplugin syntaxis

" }}}

" Русский язык (Switch language)                                     {{{
" ======================================================================

" Plug 'lyokha/vim-xkbswitch'
"
" let g:XkbSwitchEnabled = 1
" if has('wsl')
"     let g:XkbSwitchLib = '/mnt/c/tools/libxkbswitch64.dll'
" elseif has('win32')
"     let g:XkbSwitchLib = 'C:\tools\libxkbswitch64.dll'
" endif

Plug 'powerman/vim-plugin-ruscmd'

" }}}

" Undotree                                                          {{{
" =====================================================================
Plug 'mbbill/undotree'         " visualize undo tree
" Plug 'simnalamburt/vim-mundo'  " another undo tree visualizer

let g:undotree_HighlightChangedWithSign = 0
let g:undotree_WindowLayout             = 2

" }}}

" NERDTree                                                           {{{
" ======================================================================
" Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeFind' }
Plug 'scrooloose/nerdtree'

" Добавляет цветную подсветку к иконкам
Plug 'vwxyutarooo/nerdtree-devicons-syntax'

" so ~/.config/nvim/plugins_settings/NERDTree.vim

" Показывать скрытые файлы по умолчанию
let NERDTreeShowHidden = 0

" Automatically close NerdTree when you open a file
let NERDTreeQuitOnOpen = 0

" Automatically delete the buffer of the file you just deleted with NerdTree
let NERDTreeAutoDeleteBuffer = 1

" disable “Press ? for help”
let NERDTreeMinimalUI = 0

let g:NERDTreeHijackNetrw = 1

let g:NERDTreeDirArrowExpandable  = "▷"
let g:NERDTreeDirArrowCollapsible = "◢"

" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" }}}

" Devicons                                        {{{
" ---------------------------------------------------

Plug 'ryanoasis/vim-devicons'

" so ~/.config/nvim/plugins_settings/devicons.vim

let g:webdevicons_conceal_nerdtree_brackets = 1

" Reload Vim-Deviconda after reload .vimrc file
if exists("g:loaded_webdevicons")
    call webdevicons#refresh()
endif

" }}}

" Unused {{{

" Plug 't9md/vim-choosewin'    " Switch Windows on choose
" let g:choosewin_overlay_enable = 1 " use overlay
" nmap - <Plug>(choosewin)

" Delete buffer without closing related window
" Plug 'qpkorr/vim-bufkill'

" 'Rich text' highlighting in Vim
" (colors, underline, bold, italic, etc...)
" Plug 'bpstahlman/txtfmt'
" so ~/.config/nvim/plugins_settings/txtfmt.vim



" }}}

" Color Themes                                     {{{
" ====================================================

" Plug 'ayu-theme/ayu-vim'
Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'
Plug 'mhartington/oceanic-next'
Plug 'ajmwagar/vim-deus'
Plug 'sainnhe/gruvbox-material', { 'branch': 'neosyn' }

" }}}

call plug#end()

"                 ███                                    ██
"                ░░██                                   ░██
"   █████   █████ ░██  █████  ██████      ██████  █████ ░██████   █████  ██████████   █████
"  ██░░░██ ██░░░██░██ ██░░░██░░██░░█     ██░░░░  ██░░░██░██░░░██ ██░░░██░░██░░██░░██ ██░░░██
" ░██  ░░ ░██  ░██░██░██  ░██ ░██ ░     ░░█████ ░██  ░░ ░██  ░██░███████ ░██ ░██ ░██░███████
" ░██   ██░██  ░██░██░██  ░██ ░██        ░░░░░██░██   ██░██  ░██░██░░░░  ░██ ░██ ░██░██░░░░
" ░░█████ ░░█████ ░██░░█████ ░███        ██████ ░░█████ ░██  ░██░░█████  ███ ░██ ░██░░█████
"  ░░░░░   ░░░░░  ░░  ░░░░░  ░░░        ░░░░░░   ░░░░░  ░░   ░░  ░░░░░  ░░░  ░░  ░░  ░░░░░

" let s:theme = 'ayu'
" let s:theme = 'onedark'
" let s:theme = 'gruvbox'
let s:theme = 'gruvbox-material'
" let s:theme = 'deus'
" let s:theme = 'OceanicNext'

" Onedark {{{
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
    if exists('g:lightline')
        let g:lightline.colorscheme = 'onedark'
    endif
" }}}
" Gruvbox {{{
elseif s:theme == 'gruvbox'
    let g:gruvbox_improved_strings = 1
    let g:gruvbox_contrast_dark = 'medium'
    colorscheme gruvbox
    let g:airline_theme = 'gruvbox'
    if exists('g:lightline')
        let g:lightline.colorscheme = 'gruvbox'
    endif
" }}}
" Ayu {{{
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
" }}}
" OceanicNext {{{
elseif s:theme == 'OceanicNext'
    colorscheme OceanicNext
    let g:airline_theme='oceanicnext'
" }}}
" Deus {{{
elseif s:theme == 'deus'
    colorscheme deus
" }}}
" Gruvbox-material {{{
elseif s:theme == 'gruvbox-material'
    colorscheme gruvbox-material
    let g:airline_theme = 'gruvbox_material'
    if exists('g:lightline')
        let g:lightline.colorscheme = 'gruvbox_material'
    endif
endif
" }}}


"  ██                           ██      ██              ██ ██
" ░██                          ░██     ░░              ░██░░
" ░██   ██  █████  ██   ██     ░██████  ██ ██████   ██████ ██ ██████   ██████  ██████
" ░██  ██  ██░░░██░██  ░██     ░██░░░██░██░██░░░██ ██░░░██░██░██░░░██ ██░░░██ ██░░░░
" ░█████  ░███████░██  ░██     ░██  ░██░██░██  ░██░██  ░██░██░██  ░██░██  ░██░░█████
" ░██░░██ ░██░░░░ ░░██████     ░██  ░██░██░██  ░██░██  ░██░██░██  ░██░░██████ ░░░░░██
" ░██ ░░██░░█████  ░░░░░██     ░██████ ░██░██  ░██░░██████░██░██  ░██ ░░░░░██ ██████
" ░░   ░░  ░░░░░    █████      ░░░░░░  ░░ ░░   ░░  ░░░░░░ ░░ ░░   ░░   █████ ░░░░░░
"                  ░░░░░                                              ░░░░░

" Easymotion key bindings {{{
map  ; <Plug>(easymotion-prefix)
nmap s <Plug>(easymotion-bd-f)
xmap s <Plug>(easymotion-bd-f)
omap s <Plug>(easymotion-bd-f)
nmap ;w <Plug>(easymotion-w)
nmap ;b <Plug>(easymotion-b)
nmap ;l <Plug>(easymotion-lineanywhere)
"}}}

" Windows scrolling options / Comfortable motion key bindings {{{

" Little less then half of the screen
nnoremap <silent> <C-d> :call comfortable_motion#flick(winheight(0) * 2)<CR>
nnoremap <silent> <C-u> :call comfortable_motion#flick(winheight(0) * -2)<CR>

" " Half of the screen
" nnoremap <silent> <C-d> :call comfortable_motion#flick(winheight(0) * 2.2)<CR>
" nnoremap <silent> <C-u> :call comfortable_motion#flick(winheight(0) * -2.2)<CR>

" Full screen
nnoremap <silent> <C-f> :call comfortable_motion#flick(winheight(0) * 3.5)<CR>
nnoremap <silent> <C-b> :call comfortable_motion#flick(winheight(0) * -3.5)<CR>

" }}}

" Fzf {{{

" nmap <Leader>F :Files<CR>
" nmap <Leader>f :GFiles<CR>
" "
" nmap <Leader>h :History<CR>
" "
" nmap <Leader>l :BLines<CR>
" nmap <Leader>L :Lines<CR>
" nmap <Leader>' :Marks<CR>
" "
" nmap <Leader>/ :Rg<Space>
" "
" " Fuzzy search Vim help
" " nmap <Leader>H :Helptags!<CR>
" nmap <Leader>H :Helptags<CR>
" "
" nmap <Leader>C :Commands!<CR>
" "
" " Fuzzy search through ':command' history
" " nmap q: :History:!<CR>
" " nmap q/ :History/!<CR>
" nmap q: :History:<CR>
" nmap q/ :History/<CR>
" "
" " Fuzzy search key mappings
" nmap <Leader>M :Maps<CR>

" }}}

" LeaderF {{{

let g:Lf_ShortcutF = "<leader>ff"
nmap <silent> <Leader>fF :Leaderf file ~<CR>
"
nmap <leader>fh :Leaderf mru<CR>
"
nmap <leader>ft :Leaderf tag<CR>
nmap <leader>fu :Leaderf function<CR>
"
" nmap <Leader>fl :LeaderfLine<CR>
nmap <Leader>fl :Leaderf line<CR>
nmap <Leader>fL :LeaderfLineAll<CR>
" nmap <Leader>' :Marks<CR>
"
nmap <Leader>/ :LeaderfRgInteractive<CR>
"
" Fuzzy search Vim help
nmap <Leader>fH :LeaderfHelp<CR>
"
" nmap <Leader>C :Commands!<CR>
"
" Fuzzy search through ':command' history
nmap q: :LeaderfHistoryCmd<CR>
nmap q/ :LeaderfHistorySearch<CR>
"
" let g:Lf_ShortcutF = "<leader>ff"
" noremap <leader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
" noremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
" noremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
" noremap <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>

" }}}


" Открыть файловую панель NERDTree, и установить в ней курсор на файле
" открытом в текущем буфере. Повторное нажатие закроет файловую панель.
nnoremap <silent> <F2> :call ToggleNERDTree()<CR>
function! ToggleNERDTree() " {{{
    if IsFileTypeOpen('nerdtree')
        NERDTreeClose
        " AirlineRefresh
    else
        NERDTreeFind
    endif
endfunction
" }}}

noremap <silent> <F3> :SignatureToggleSigns<CR>
noremap <silent> <F4> :SignatureListBufferMarks<CR>
noremap <silent> <F5> :GV<CR>


nnoremap <silent> gb :call ChooseBuffer()<CR>
function! ChooseBuffer()  "{{{
    " Количество открытых буферов
    let num_of_buffers = len(getbufinfo({'buflisted':1}))
    if num_of_buffers > 2
        " If you are interesting what is <C-z> check ':help wildcharm'.
        " call feedkeys(":buffer \<C-z>")
        ToggleBufExplorer
    else
        bnext
    endif
endfunction
"}}}


nnoremap <Leader>u :UndotreeToggle<CR>

nmap <leader>vw <Plug>(wiki-index)


" Показать syntax group для участка кода, а также цвет этой группы.
" Удобно при создании своей цветовой схемы
nnoremap <C-g> :call SyntaxAttr()<CR>

" nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

" vim: foldenable tw=75 colorcolumn=+1
