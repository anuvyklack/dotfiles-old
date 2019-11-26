# zsh plugins
apt install zsh-autosuggestions
apt install zsh-syntax-highlight
apt install zsh-theme-powerlevel9k  # theme for zsh

apt install fzf   # fuzzy finder
apt install exa   # a modern replacment for ls
apt install ripgrep
apt install silversearcher-ag
apt install bfs  # find(1) c поиском в ширину в первую очередь
apt install htop
apt install anacron  # make sure that regular cron task are completed
apt install par  # Paragraph formating utility for vim

# Make an symlink to win32yank for Neovim WSL clipboard
ln -sv "/mnt/c/tools/win32yank.exe" "/usr/local/bin/win32yank"

# run Xserver on WSL start
ln -sv -f "~/dotfiles/vcxsrv.sh" "/etc/profile.d/vcxsrv.sh"
