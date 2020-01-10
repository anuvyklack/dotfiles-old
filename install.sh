# zsh plugins

# For WSL
[[ "$(umask)" = "000" ]] && umask 022

# echo $0:a:h
# echo ${0:a:h}

DIR=$0:a:h  # The parent folder of current script

symlink()  # {{{
{
    TARGET=$1
    LINK=$2

    # [[ -s "$TARGET" ]] && echo "$TARGET exists" || echo "$TARGET NOT exists"

    # $LINK doesn't exists, or not a symlink OR
    # is a symlink but and points to $TARGET.
    if [[ ! -L "$LINK" ]] || [[ $(readlink -f "$LINK") != "$TARGET" ]]
    then
        ln -sv -f "$TARGET" "$LINK"
    fi

    # # $LINK exists, is a symlink and points to $TARGET
    # [[ -L "$LINK" ]] && [[ $(readline -f "$LINK") = "$TARGET" ]]

}  # }}}


# Setup zsh files
export ZDOTDIR=$HOME/.config/zsh

[[ -d $ZDOTDIR ]] || mkdir -pv $ZDOTDIR
[[ -d $HOME/.cache/zsh ]] || mkdir -pv $HOME/.cache/zsh

echo -e "\e[1;37mLink zsh files to\e[0m \e[1;34m$ZDOTDIR\e[0m"

symlink "$DIR/config/zsh/zshenv"    "$HOME/.zshenv"
symlink "$DIR/config/zsh/zprofile"  "$ZDOTDIR/.zprofile"
symlink "$DIR/config/zsh/zshrc"     "$ZDOTDIR/.zshrc"
symlink "$DIR/config/zsh/zlogin"    "$ZDOTDIR/.zlogin"
symlink "$DIR/config/zsh/functions" "$ZDOTDIR/functions"

local folders=(lib themes)

for FOLDER in $folders
do
    [[ -d $ZDOTDIR/$FOLDER ]] || mkdir -pv $ZDOTDIR/$FOLDER

    for FILE in $DIR/config/zsh/$FOLDER/*
    do
        symlink $FILE "$ZDOTDIR/$FOLDER/${FILE:t}"
    done
done

echo -e '\e[1;37mDone!\e[0m'
echo ''


# Setup ~/.bin
[[ -d $HOME/.bin ]] || mkdir -v $HOME/.bin
for file in $DIR/bin/*
do
    symlink "$file" "$HOME/.bin/${file:t}"
    # ln -sv -f "$file" "$HOME/.bin/$(basename $file)"
done


# Install Miniconda3 to /opt/miniconda3
symlink $DIR/condarc $HOME/.condarc
if [[ ! -d /opt/miniconda3 ]]
then
    echo -e '\e[37;1mInstalling \e[35;1mminiconda3\e[0m'
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
    sudo bash ~/miniconda.sh -b -p /opt/miniconda3

    # Make current user the owner of the /opt/miniconda3 to make 'conda update' work.
    sudo chown -R $USER /opt/miniconda3

    rm -f ~/miniconda.sh

    export PATH="/opt/miniconda3/bin:$PATH"
    conda update conda --yes
fi


# Setup Neovim
echo -e '\e[37;1mSetup Neovim\e[0m'
symlink $DIR/config/nvim $HOME/.config/nvim

if ! command -v conda > /dev/null 2>&1
then
    echo -e '\e[31;1m conda:\e[0m \e[37;1mcommand not found!\e[0m'
fi

if conda list | grep 'pynvim' > /dev/null 2>&1
then
    echo -e '\e[32;1mpynvim\e[0m \e[37;1malready installed\e[0m'
else
    echo -e '\e[37;1mconda install\e[0m \e[32;1mpynvim\e[0m'
    conda install pynvim --yes
fi
echo ''


# Setup Git
symlink $DIR/config/git $HOME/.config/git

# Make an symlink to win32yank for Neovim WSL clipboard
local TARGET="/mnt/c/tools/win32yank.exe"
local LINK="/usr/local/bin/win32yank"
if [[ ! -L "$LINK" ]] || [[ $(readlink -f "$LINK") != "$TARGET" ]]
then
    ln -sv -f "$TARGET" "$LINK"
fi

# # run Xserver on WSL start
# ln -sv -f "~/dotfiles/vcxsrv.sh" "/etc/profile.d/vcxsrv.sh"


installed-by-apt ()  # {{{
{
    # In Unix shells (contrary to many other programming languages) 0 stands for
    # true and any other (integer) value stands for false. This goes in hand with
    # Unix programs returning 0 on successful completion and any other value
    # (usually between 1 and 255) indicates some negative result or error.

    CONDITION=$(dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -c "ok installed")
    if [[ $CONDITION -eq 0 ]]
    then
        # echo 'No'
        return 1
    else
        # echo 'Yes'
        return 0
    fi
}
# }}}

aptinstall ()  # {{{
{
    # Check if installed and install through `apt` otherwise.
    if installed-by-apt $1
    then
        # echo -e "\e[32;1m$1 \e[37;1malready installed\e[0m"
        echo -e "\e[32;1m$1 \e[0malready installed"
    else
        echo -e "\e[33;1mapt \e[37;1minstall \e[32;1m$1\e[0m"
        sudo apt install "$1"
    fi
}
# }}}

local aptapps=(
    patchelf
    bfs      # find(1) c поиском в ширину в первую очередь
    anacron  # make sure that regular cron task are completed
    par      # Paragraph formating utility for vim
    rsync
    mlocate
    # htop
    # exa      # a modern replacment for ls
    # ripgrep
    # silversearcher-ag
    # fzf      # fuzzy finder
)
for APP in $aptapps; do aptinstall $APP; done


# Install Homebrew
if [[ ! -d "/home/linuxbrew/.linuxbrew" ]]
then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
fi

eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

brewinstall ()  # {{{
{
    # Check if installed and install using `brew` otherwise.
    if $(brew list $1 > /dev/null 2>&1)
    then
        echo -e "\e[32;1m$1\e[0m already installed"
    else
        echo ''
        echo -e "\e[33;1mbrew \e[37;1minstall \e[32;1m$1\e[0m"
        brew install $1
        echo ''
    fi
}
# }}}

local brewapps=(
    # neovim
    lsd
    bat
    fd
    ripgrep
    node
)
for APP in $brewapps; do brewinstall $APP; done

brew install --HEAD universal-ctags/universal-ctags/universal-ctags
