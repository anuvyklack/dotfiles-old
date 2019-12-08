#! zsh

# autoload -Uz function_name
# -U
#     prevents alias from being expanded. That is, whenever you
#     define an alias and a function having the same name, the alias will
#     be considered first instead, so -U just skips alias expansion.
# -z
#     indicates that the function will be auto-loaded using zsh or
#     ksh style.

# Zplugin invocation {{{

# Source zplugin. Install if it's absent. These lines must be at the very
# begining of the file. The order of plugins loading matters.
if [[ ! -s "$HOME/.zplugin/bin/zplugin.zsh" ]]; then
  mkdir ~/.zplugin
  git clone https://github.com/zdharma/zplugin.git ~/.zplugin/bin
  source "$HOME/.zplugin/bin/zplugin.zsh"
  zplugin self-update
else
  source "$HOME/.zplugin/bin/zplugin.zsh"
fi

# # The lines attach Zplugin completion "on-the-fly" to already initialized
# # completion system. They need to be added if zplugin is sourced after
# # "autoload -Uz compinit && compinit".
# autoload -Uz _zplugin
# (( ${+_comps} )) && _comps[zplugin]=_zplugin

# }}}

setopt auto_cd           # Смена текущего каталога без ввода комады 'cd'
setopt auto_pushd        # 'cd' push the old dir onto the directory stack

setopt cdable_vars       # Можно вводить пути для команды 'cd' (или без
                         # неё, если используетя опция 'auto_cd') в
                         # домашней директории без '~/' в начале.

setopt pushd_ignore_dups # Don't push multiple copies of the same directory
                         # onto the directory stack.

setopt pushd_silent      # Do not print the directory stack after 'pushd'
                         # or 'popd'.

setopt interactive_comments  # Allow comments even in interactive shells.
setopt extendedglob
setopt nomatch
setopt notify
unsetopt beep            # Seriously why does this shit even exist

# History                                                              {{{
# ========================================================================

# History environment variables
HISTFILE=${HOME}/.cache/zsh/zsh_history
HISTSIZE=120000  # Larger than $SAVEHIST for HIST_EXPIRE_DUPS_FIRST to work
SAVEHIST=100000

setopt bang_hist               # Treat the '!' character specially during expansion.
# setopt extended_history        # Write the history file in the ":start:elapsed;command" format.
setopt inc_append_history      # Write to the history file immediately, not when the shell exits.
# setopt share_history           # Share history between all sessions.
setopt hist_expire_dups_first  # Expire duplicate entries first when trimming history.
setopt hist_ignore_dups        # Don't record an entry that was just recorded again.
# setopt hist_ignore_all_dups    # Delete old recorded entry if new entry is a duplicate.
setopt hist_find_no_dups       # Do not display a line previously found.
setopt hist_ignore_space       # Don't record an entry starting with a space.
# setopt hist_save_no_dups       # Don't write duplicate entries in the history file.
setopt hist_reduce_blanks      # Remove superfluous blanks before recording entry.
setopt hist_verify             # Don't execute immediately upon history expansion.
setopt hist_no_store           # Remove the 'history' (fc -i) command form the history list
setopt hist_reduce_blanks      # Remove superfluous blanks from each command line being added to the history list.

# Patterns that would not be stored in history
export HISTORY_IGNORE="(cd|ranger|exit)"

# Not store failed commands into history
zshaddhistory() { whence ${${(z)1}[1]} >/dev/null || return 2 }

# Forget the line in the history {{{2
# Delete from the history file all entries of the current zle buffer content.
forget(){
    cp $HISTFILE "$HISTFILE.old"
    fc -W "$HISTFILE.old"
    grep -v -xF $BUFFER "$HISTFILE.old" > $HISTFILE
    # fc -R
    rm "$HISTFILE.old" > /dev/null 2>&1
    zle kill-buffer
}
zle -N forget
bindkey '^[f' forget  # Alt + F
# }}}2

# }}}

# Completion                                                           {{{
# ========================================================================

setopt menu_complete    # При множестве вариатнов подстановки по нажатию
                        # <Tab> откроет меню и подставит первый вариант.
                        # При повторном нажатии подставит следующий вариант.
                        # В меню можно пользоваться стрелками.

setopt complete_aliases # дополнять aliaces как отдельные команды

setopt list_types       # When listing files that are possible completions,
                        # show the type of each file with a trailing
                        # identifying mark.

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Выбирать предлагаемые zsh варианты автодополнения с помощью стрелочек.
zstyle ':completion:*' menu select=1 _complete _ignored _approximate

# use the vi navigation keys (hjkl) besides cursor keys in menu completion
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char         # left
bindkey -M menuselect 'k' vi-up-line-or-history    # up
bindkey -M menuselect 'l' vi-forward-char          # right
bindkey -M menuselect 'j' vi-down-line-or-history  # down

zstyle ':completion:*' verbose true
zstyle :compinstall filename '~/.zshrc'

# Уравниваем в правах верхний и нижний регистр
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zplugin ice blockf
zplugin light zsh-users/zsh-completions

# }}}

# Colors {{{

# # After cloning and renewal repository construct from 'LS_COLORS' file
# # (using 'dircolors -b') the proper $LS_COLORS environment variable and
# # wright it into 'c.zsh' file. Execute this file at plugin loading.
# #
# zplugin ice nocompile:! \
#             atclone:'dircolors -b LS_COLORS > c.zsh' atpull:'%atclone' \
#             pick:"c.zsh"
# zplugin light trapd00r/LS_COLORS

# # Colored man pages {{{
# man() {
#     env LESS_TERMCAP_mb=$'\E[01;31m' \
#     LESS_TERMCAP_md=$'\E[01;38;5;74m' \
#     LESS_TERMCAP_me=$'\E[0m' \
#     LESS_TERMCAP_se=$'\E[0m' \
#     LESS_TERMCAP_so=$'\E[38;5;246m' \
#     LESS_TERMCAP_ue=$'\E[0m' \
#     LESS_TERMCAP_us=$'\E[04;38;5;146m' \
#     man "$@"
# }
# # }}}

# }}}

# Prompt {{{

# My custom prompt {{{

autoload -U colors && colors

git_prompt()
{
  temp=`git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3`
  if [ "$temp" != "" ]; then echo " ($temp)"; fi
}

# autoload -Uz vcs_info
# precmd_vcs_info() { vcs_info }
# precmd_functions+=( precmd_vcs_info )
# zstyle ':vcs_info:git:*' formats '%b'

setopt prompt_subst

# %n	Имя пользователя
# %m	Имя компьютера (до первой точки)
# %M	Полное имя компьютера
# %~	Путь к текущему каталогу относительно домашнего
# %d	Полный путь к текущей директории
# %T	Время в формате HH:MM
# %*	Время в формате HH:MM:SS
# %D	Дата в формате YY-MM-DD
# %B, %b	Начало и конец выделения жирным
# %U, %u	Начало и конец подчеркивания
# red green yellow blue magenta cyan black white

# RPROMPT=\$vcs_info_msg_0_
# PROMPT=\$vcs_info_msg_0_'%# '

PROMPT=$'\n %~$(git_prompt) $ '
# PROMPT=$'\n %{$fg_no_bold[blue]%}%~%{$reset_color%}$fg_no_bold[magenta]%}$(git_prompt)%{$reset_color%} $ '
# PROMPT=$'\n %{$fg_no_bold[yellow]%}%~ %{$reset_color%}$(git_prompt) $ '
# PROMPT="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg_no_bold[yellow]%}%1~ %{$reset_color%}%#"

# "правостороннее" приглашение
RPROMPT=' %T '  # показывает время

# }}}

# # Pure
# # https://github.com/sindresorhus/pure
# zplugin ice pick"async.zsh" src"pure.zsh"
# zplugin light sindresorhus/pure

# }}}

# fzf {{{

# ---------------------------------------------------------------------- #
# fzf keybindings for Zsh                                                #
# CTRL-R - Paste the selected command from history into the command line #
# CTRL-T - Paste the selected file path(s) into the command line         #
# ALT-C  - cd into the selected directory                                #
# ---------------------------------------------------------------------- #


# Install fzf with zplugin
# Set plugin id as 'fzf'. Now it is possible to update by:
# "zplugin update fzf" delete by: "zplugin delete fzf" and so on.
# Downloaded last release from "github releases", unpack it and move
# "fzf" to "$ZPFX/bin/fzf", which is already at he $PATH.
#
zplugin ice id-as"fzf" as"program" from"gh-r" \
            mv"fzf -> $ZPFX/bin/" \
            pick"$ZPFX/bin/fzf"
zplugin light junegunn/fzf-bin

# fzf keybindings
zplugin ice id-as"fzf-keybindings.zsh"
zplugin snippet https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh

# fzf.vim  Needed to enable fzf in vim/neovim.
zplugin ice id-as"auto" as"null"
zplugin snippet https://github.com/junegunn/fzf/blob/master/plugin/fzf.vim

# # fzf completions
# zplugin ice id-as"fzf-completion.zsh"
#             mv"fzf-completion.zsh ->_fzf-completion"
# zplugin snippet https://github.com/junegunn/fzf/blob/master/shell/completion.zsh


# # Enable if fzf installed with apt.
# # Documentation is at: /usr/share/doc/fzf/README.Debian
# if [[ -s "/usr/share/doc/fzf/examples/key-bindings.zsh" ]]; then
#   source /usr/share/doc/fzf/examples/key-bindings.zsh
# fi


export FZF_DEFAULT_OPTS='--height 75% --layout=reverse --border'
# export FZF_DEFAULT_OPTS='--height 75% --layout=reverse --border --preview="head -30 {}"'

# Using ripgrep with fzf
# (I've tried fd, but ripgrep is faster.)
# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


# Using bfs utility for directory searching.
# https://github.com/tavianator/bfs

# # don't show hidden folders
# export FZF_ALT_C_COMMAND="bfs -type d -nohidden -L -print 2> /dev/null"

# show hidden folders
export FZF_ALT_C_COMMAND="bfs -type d -L -print 2> /dev/null"

# Make fzf history search unique {{{2
fzf-history-widget()
{
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
  selected=( $(fc -rl 1 |
    sort -k2 -k1rn | uniq -f 1 | sort -r -n |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
      local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}
# }}}2

# }}}

# Programs and $PATH {{{1

# Homebrew {{{2
if [[ -a "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

    # Enable completion for brew and programs installes with brew.
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
# }}}2

# Miniconda {{{2
if [[ -d "/opt/miniconda3/bin" ]]; then
    export PATH="/opt/miniconda3/bin:$PATH"
fi
# }}}2

# Broot {{{2
if [[ -s "~/.config/broot/launcher/bash/br" ]]; then
    source ~/.config/broot/launcher/bash/br
fi
# }}}2

# }}}1

# Plugins {{{

# Zsh-Autosuggestions {{{

# http://zdharma.org/zplugin/wiki/INTRODUCTION/
#
# Autosuggestions uses precmd hook, which is being called right after
# processing zshrc (right before the first prompt). Turbo mode will wait 1
# second after that, so precmd will not be installed and thus not called
# at that first prompt. This makes autosuggestions inactive at the first
# prompt.  However the given atload Ice-mod fixes this, it calls the
# same function that precmd would, right after loading autosuggestions,
# resulting in exactly the same behavior of the plugin.
#
# The ice lucid causes the under-prompt message saying Loaded
# zsh-users/zsh-autosuggestions that normally appears for every
# Turbo-loaded plugin to not show.
#
zplugin ice wait lucid atload'_zsh_autosuggest_start'
zplugin light zsh-users/zsh-autosuggestions

export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)
export ZSH_AUTOSUGGEST_USE_ASYNC=1  # suggestions will be fetched
                                    # asynchronously
# }}}

# Install diff-so-fancy using zplugin
zplugin ice id-as"diff-so-fancy" wait"2" lucid as"program" pick"bin/git-dsf"
zplugin light zdharma/zsh-diff-so-fancy

# Автодополнение путей с использованием fzf для команды cd
zplugin ice wait"1" lucid
zplugin light changyuheng/zsh-interactive-cd

# }}}

# GUI settings                                                          {{{

# For X-server
# The format of this command is actually [host]:<display>.[screen] where [host]
# refers to a network host name. Since we left it blank, we’re going to use our
# local machine instead. Each host can have multiple display.
# export DISPLAY=:0.0
# export DISPLAY=$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0.0
# export DISPLAY=$(ip r l default | cut -d\ -f3):0
# export DISPLAY=$(awk '/nameserver/ {print $2}' /etc/resolv.conf):0.0

# }}}


# Keybindings                                                           {{{
# =========================================================================

# Нормальное поведение клавиш (не как в vi и emacs). {{{

# # create a zkbd compatible hash;
# # to add other keys to this hash, see: man 5 terminfo
# typeset -g -A key
#
# key[Home]="${terminfo[khome]}"
# key[End]="${terminfo[kend]}"
# key[Insert]="${terminfo[kich1]}"
# key[Backspace]="${terminfo[kbs]}"
# key[Delete]="${terminfo[kdch1]}"
# key[Up]="${terminfo[kcuu1]}"
# key[Down]="${terminfo[kcud1]}"
# key[Left]="${terminfo[kcub1]}"
# key[Right]="${terminfo[kcuf1]}"
# key[PageUp]="${terminfo[kpp]}"
# key[PageDown]="${terminfo[knp]}"
# key[ShiftTab]="${terminfo[kcbt]}"
#
# # Нормальное поведение клавиш (не как в vi и emacs).
# [[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
# [[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
# [[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
# [[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
# [[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
# [[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
# [[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
# [[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
# [[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
# [[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history
#
# # Finally, make sure the terminal is in application mode, when zle is
# # active. Only then are the values from $terminfo valid.
# if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
# 	autoload -Uz add-zle-hook-widget
# 	function zle_application_mode_start {
# 		echoti smkx
# 	}
# 	function zle_application_mode_stop {
# 		echoti rmkx
# 	}
# 	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
# 	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
# fi
# }}}

# bindkey -e  # Use Emacs style keybindings

# Vi style keybundugs {{{

# bindkey -v  # Use Vi style keybindings

# Don't wait too long after <Esc> to see if it's an arrow / function key
# Warning: Setting this too low can break some zsh functionality, eg:
#     https://github.com/zsh-users/zsh-autosuggestions/issues/254#issuecomment-345175735
export KEYTIMEOUT=25

# zplugin light softmoth/zsh-vim-mode

# # Change the color and shape of the terminal cursor with:
# MODE_CURSOR_VICMD="green block"
# MODE_CURSOR_VIINS="#20d08a blinking bar"
# MODE_CURSOR_SEARCH="#ff00ff steady underline"

# }}}


# Если в пустой командной строке набрать любые символы и начать просматривать
# историю команд клавишами Up и Down, то из буфера будут извлекаться только те,
# имена которых начинаются с этого набора символов.
bindkey "^[OA" .up-line-or-search
bindkey "^[OB" .down-line-or-search

# <C-Left> - backward-word
# <C-Right> - forward-word
bindkey "^[[1;5D" .backward-word
bindkey "^[[1;5C" .forward-word

bindkey "^[[1;3D" .beginning-of-line
bindkey "^[[1;3C" .end-of-line

# Use backtick for accept zsh-autosuggestions
bindkey \` autosuggest-accept

bindkey "^K" history-substring-search-up
bindkey "^J" history-substring-search-down

# }}}

# Functions                                                            {{{
# ========================================================================

# Запаковывать и распаковывать архивы командами:
# 'compress <files>' и 'extract <file>'
compress ()  # {{{2
{
  if [ $1 ] ; then
    case $1 in
      tbz)  tar cjvf $2.tar.bz2 $2   ;;
      tgz)  tar czvf $2.tar.gz  $2   ;;
      tar)  tar cpvf $2.tar  $2      ;;
      bz2)  bzip $2                  ;;
      gz)   gzip -c -9 -n $2 > $2.gz ;;
      zip)  zip -r $2.zip $2         ;;
      7z)   7z a $2.7z $2            ;;
      *)    echo "'$1' cannot be packed via >compress<" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

extract () # {{{2
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2) tar xvjf $1   ;;
      *.tar.gz)  tar xvzf $1   ;;
      *.tar.xz)  tar xvfJ $1   ;;
      *.bz2)     bunzip2 $1    ;;
      *.rar)     unrar x $1    ;;
      *.gz)      gunzip $1     ;;
      *.tar)     tar xvf $1    ;;
      *.tbz2)    tar xvjf $1   ;;
      *.tgz)     tar xvzf $1   ;;
      *.zip)     unzip $1      ;;
      *.Z)       uncompress $1 ;;
      *.7z)      7z x $1       ;;
      *)         echo "'$1' cannot be extracted via >extract<" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
# }}}2

update()  # {{{
{
  sudo apt upgrade
  sudo apt update
  sudo apt autoremove

  brew update
  brew upgrade

  zplugin self-update
  zplugin update --all
}
# }}}

back_in_history()  # {{{
{
  ~$(dirs -v | fzf | rg -o '\d+')
}
# }}}


# }}}

# Aliaces                                                              {{{
# ========================================================================

# Expand aliaces in command line.
# https://blog.sebastian-daschner.com/entries/zsh-aliases

# Define three types of aliaces:
# alias  - will be expanded into full command with wightspace after
# balias - will be expanded without wightspace after
# ialias - won't be expanded

# balias {{{2

# Blank aliases
typeset -a baliases
baliases=()

balias()
{
  alias $@
  args="$@"
  args=${args%%\=*}
  baliases+=(${args##* })
}

# ialiases {{{2

# ignored aliases
typeset -a ialiases
ialiases=()

ialias()
{
  alias $@
  args="$@"
  args=${args%%\=*}
  ialiases+=(${args##* })
}

# }}}2

# functionality
expand-alias-space() # {{{
{
  [[ $LBUFFER =~ "\<(${(j:|:)baliases})\$" ]]; insertBlank=$?
  if [[ ! $LBUFFER =~ "\<(${(j:|:)ialiases})\$" ]]; then
    zle _expand_alias
  fi
  zle self-insert
  if [[ "$insertBlank" = "0" ]]; then
    zle backward-delete-char
  fi
} # }}}
zle -N expand-alias-space

# Expand aliaces on space
bindkey " " expand-alias-space
bindkey -M isearch " " magic-space


# Пингуем один раз вместо бесконечности.
ialias ping='ping -c 1'

ialias vim='nvim'

ialias mv='nocorrect mv -i'  # переименование-перемещение c пogтвepжgeнueм
ialias cp='nocorrect cp -iR'  # рекурсивное копирование с подтверждением
ialias rm='nocorrect rm -i'  # удаление с подтверждением
# alias rmf='nocorrect rm -f'  # принудительное удаление
# alias rmrf='nocorrect rm -fR' # принудительное рекурсивное удаление
ialias mkdir='nocorrect mkdir'  # создание каталогов без коррекции

# alias l='ls -lAh --color=auto --group-directories-first'
# alias ls='ls --color=auto --group-directories-first'

# alias ls='ls -F'  # вывод символов типов файлов
# alias ll='ls -l'  # вывog в gлuннoм фopмaтe
# alias la='ls -A'  # вывog всех файлов, кромe . u ..
# alias lsd='ls -ld *(-/DN)'  # вывод только каталогов
# alias lsa='ls -ld .*'  # вывog тoльko dot-фaйлoв

# alias ls='lsd'
ialias ll='lsd --group-dirs=first --blocks=size,date,name --date=relative -l'
ialias lt='lsd --tree'

# alias ls='exa'
ialias exa='exa --group-directories-first'

ialias tree='tree -I .git -I .github'

# alias history="history -35"  # упрощение вывода истории команд

# вывод свободного и использованного дискового пространства в
# "гуманистическом" представлении
ialias df='df -h'
ialias du='du -h'

alias disk='df -h | grep -P "F|[A-Z]:"'

# представление вывода less в more-подобном виде
# (с именем файла и процентом вывода)
ialias less='less -M'
ialias wget='wget -c'  # автоматическое продолжение при разрыве соединения
ialias vw=' nvim -c WikiIndex'  # open wiki
ialias r=' ranger'
ialias sr=' source ranger'

# Git
alias gs='git status'
alias gc='git checkout'
alias -g random='-m curl -s http://whatthecommit.com/index.txt'

alias cdh='back_in_history'

# }}}

# Initializing completion system {{{

# This line initialized completion system and should be at the end of the
# file after loading all plugin and all "zstyle ':completion:*'" options.
autoload -Uz compinit; compinit

# Run all the `compdef's saved before `compinit` call (`compinit' declares
# the `compdef' function, so it cannot be used until `compinit` is ran;
# Zplugin solves this via intercepting the `compdef'-calls and storing them
# for later use with `zplugin cdreplay'). `-q` is for quiet.
zplugin cdreplay -q

# `compdef _gnu_generic myCommand` will parse output of `myCommand --help`
# and use that for autocompletions.
# Example: compdef _gnu_generic grep

# }}}

# zplugin light zsh-users/zsh-syntax-highlighting

# zplugin ice silent wait!1 atload"ZPLGM[COMPINIT_OPTS]=-C; zpcompinit"
# zplugin light zdharma/fast-syntax-highlighting

# vim: tw=75 fdm=marker ts=2 sw=2 nonumber

