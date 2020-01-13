# For WSL
[[ "$(umask)" = "000" ]] && umask 022

# The parent folder of current script
DIR=$0:a:h
# strip "/setup" part from the path to obtain the path of the "dotfiles" repo.
DIR=$(dirname $DIR)

symlink()  # {{{
{
    TARGET=$1
    LINK=$2

    # $LINK doesn't exists, or not a symlink OR
    # is a symlink but and points to $TARGET.
    if [[ ! -L "$LINK" ]] || [[ $(readlink -f "$LINK") != "$TARGET" ]]
    then
        ln -sv -f "$TARGET" "$LINK"
    fi

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


# Setup Neovim
echo -e '\e[37;1mSetup Neovim\e[0m'
symlink $DIR/config/nvim $HOME/.config/nvim

# Make an symlink to win32yank for Neovim WSL clipboard
symlink "/mnt/c/tools/win32yank.exe" "/usr/local/bin/win32yank"


# Setup Git
symlink $DIR/config/git $HOME/.config/git

# Install Miniconda3 to /opt/miniconda3
symlink $DIR/condarc $HOME/.condarc
