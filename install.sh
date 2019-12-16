# zsh plugins

# echo $0:a:h
# echo ${0:a:h}

DIR=$0:a:h  # The parent folder of current script

export ZDOTDIR=$HOME/.config/zsh

# apt install fzf   # fuzzy finder
# apt install exa   # a modern replacment for ls
# apt install ripgrep
# apt install silversearcher-ag
# apt install bfs  # find(1) c поиском в ширину в первую очередь
# apt install htop
# apt install anacron  # make sure that regular cron task are completed
# apt install par  # Paragraph formating utility for vim
#
# # Make an symlink to win32yank for Neovim WSL clipboard
# ln -sv "/mnt/c/tools/win32yank.exe" "/usr/local/bin/win32yank"
#
# # run Xserver on WSL start
# ln -sv -f "~/dotfiles/vcxsrv.sh" "/etc/profile.d/vcxsrv.sh"

if [[ ! -d ~/.bin ]]; then
    echo "Make new directory: $HOME/.bin"
    mkdir ~/.bin
fi

for file in $DIR/bin/*; do
    ln -sv -f "$file" "$HOME/.bin/${file:t}"
    # ln -sv -f "$file" "$HOME/.bin/$(basename $file)"
done


# Setup zsh files

if [[ ! -d $ZDOTDIR ]]; then
    echo "Make new directory: $ZDOTDIR"
    mkdir $ZDOTDIR
fi

echo "Link zsh files to $ZDOTDIR"
ln -sv -f "$DIR/config/zsh/zshenv"    "$ZDOTDIR/.zshenv"
ln -sv -f "$DIR/config/zsh/zprofile"  "$ZDOTDIR/.zprofile"
ln -sv -f "$DIR/config/zsh/zshrc"     "$ZDOTDIR/.zshrc"
ln -sv -f "$DIR/config/zsh/zlogin"    "$ZDOTDIR/.zlogin"

ln -sv -f "$DIR/config/zsh/lib"       "$ZDOTDIR/lib"
ln -sv -f "$DIR/config/zsh/functions" "$ZDOTDIR/functions"
echo "Done!"
