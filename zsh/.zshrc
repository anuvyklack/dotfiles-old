# History                                                               {{{
# =========================================================================

HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
# setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
# setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
# setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
# setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
# setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.

# Patterns that would not be stored in history
export HISTORY_IGNORE="(history|ranger|exit)"

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

setopt autocd  # Смена текущего каталога без ввода комады `cd`

setopt extendedglob nomatch notify

# Seriously why does this shit even exist
unsetopt beep

# Completion                                                            {{{
# =========================================================================

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select=1
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/anuvyklack/.zshrc'

# Следующий строки обеспечивают разворот последовательности типа /h/d/w/s в
# полный путь: `$ /home/dara/works/soft`
autoload -Uz compinit
compinit

# Уравниваем в правах верхний и нижний регистр
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# }}}

# Colorer man pages {{{
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}
# }}}


# =========================================================================
# Utilities
# =========================================================================

# Prompt                                                                {{{
# =========================================================================

# Defaul prompt themes {{{

# autoload -Uz promptinit
# promptinit

# prompt adam1
# prompt adam2
    # prompt bart
    # prompt bigfade
# prompt clint
# prompt default
# prompt fire
# prompt off
# prompt special_chars
# prompt suse
# prompt walters
# prompt zefram

# }}}

# Кастовмное приглашение командной строки
PROMPT=' %~ $ '
# "правостороннее" приглашение
RPROMPT=' %T '  # показывает время

# }}}

# fzf {{{
# Read the documentation (/usr/share/doc/fzf/README.Debian)

# enable fzf keybindings for Zsh
# CTRL-R - Paste the selected command from history into the command line
# CTRL-T - Paste the selected file path(s) into the command line
# ALT-C  - cd into the selected directory
source /usr/share/doc/fzf/examples/key-bindings.zsh

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

export FZF_DEFAULT_OPTS='--height 75% --layout=reverse --border'
# export FZF_DEFAULT_OPTS='--height 75% --layout=reverse --border --preview="head -30 {}"'
# }}}

# Par (paragraph formating)                                             {{{
# =========================================================================
# The following string is recommended in par man.
export PARINIT='rTbgqR B=.,?_A_a Q=_s>|'

# }}}

# Add conda in PATH
export PATH="/opt/miniconda3/bin:$PATH"


# zsh-autosuggestion and zsh-syntax-highlighting                        {{{
# =========================================================================

# https://github.com/softmoth/zsh-vim-mode
# https://github.com/zdharma/fast-syntax-highlighting

# export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_USE_ASYNC=1  # suggestions will be fetched asynchronously

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# }}}


# GUI settings                                                          {{{

# For X-server
# The format of this command is actually [host]:<display>.[screen] where [host]
# refers to a network host name. Since we left it blank, we’re going to use our
# local machine instead. Each host can have multiple display.
# export DISPLAY=:0.0
# export DISPLAY=$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0.0
# export DISPLAY=$(ip r l default | cut -d\ -f3):0
export DISPLAY=$(awk '/nameserver/ {print $2}' /etc/resolv.conf):0.0

# }}}

# oh-my-zsh                                                             {{{
# =========================================================================

# # If you come from bash you might have to change your $PATH.
# # export PATH=$HOME/bin:/usr/local/bin:$PATH
#
# # Path to your oh-my-zsh installation.
# export ZSH="/home/anuvyklack/.oh-my-zsh"
#
# # Theme
# DEFAULT_USER="anuvyklack"
# ZSH_THEME="agnoster"
#
# # Uncomment the following line if you want to disable marking untracked
# # files under VCS as dirty. This makes repository status check for large
# # repositories much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"
#
# HIST_STAMPS="dd.mm.yyyy"
#
# plugins=(
    # git
    # extract     # extract any archive files
    # web-search  # invoke web query from prompt
    # git-extras  # Pressing tab after the various commands should autofill
                # #   authors, branches and tags depending on context.
    # # colored-man-pages
# )
#
# source $ZSH/oh-my-zsh.sh

# }}}

# Keybindings                                                           {{{
# =========================================================================

bindkey -e  # Use Emacs style keybindings
# bindkey -v  # Use Vi style keybindings

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

# Aliaces                                                               {{{
# =========================================================================

alias mv='nocorrect mv -i'  # переименование-перемещение c пogтвepжgeнueм
alias cp='nocorrect cp -iR'  # рекурсивное копирование с подтверждением
alias rm='nocorrect rm -i'  # удаление с подтверждением
# alias rmf='nocorrect rm -f'  # принудительное удаление
# alias rmrf='nocorrect rm -fR' # принудительное рекурсивное удаление
alias mkdir='nocorrect mkdir'  # создание каталогов без коррекции

alias ls='ls -F'  # вывод символов типов файлов
alias ll='ls -l'  # вывog в gлuннoм фopмaтe
alias la='ls -A'  # вывog всех файлов, кромe . u ..
alias lsd='ls -ld *(-/DN)'  # вывод только каталогов
alias lsa='ls -ld .*'  # вывog тoльko dot-фaйлoв

alias ls='exa'

# alias history="history -35"  # упрощение вывода истории команд

# вывод свободного и использованного дискового пространства в
# "гуманистическом" представлении
alias df='df -h'
alias du='du -h'

# представление вывода less в more-подобном виде
# (с именем файла и процентом вывода)
alias less='less -M'

alias wget='wget -c'  # автоматическое продолжение при разрыве соединения

alias vw=' nvim -c WikiIndex'  # open wiki

alias r=' ranger'
alias sr=' source ranger'

# }}}

# vim: fdm=marker nonumber
