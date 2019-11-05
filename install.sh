# zsh plugins
sudo apt install zsh-autosuggestions
sudo apt install zsh-syntax-highlight
sudo apt install zsh-theme-powerlevel9k  # theme for zsh

sudo apt install fzf   # fuzzy finder
sudo apt install exa   # a modern replacment for ls
sudo apt install ripgrep
sudo apt install silversearcher-ag
sudo apt install htop
sudo apt install anacron  # make sure that regular cron task are completed

sudo apt install par  # Paragraph formating utility for vim

# Make an symlink to win32yank for Neovim WSL clipboard
ln -sv "/mnt/c/tools/win32yank.exe" "/usr/local/bin/win32yank"

# run Xserver on WSL start
sudo ln -sv -f "~/dotfiles/vcxsrv.sh" "/etc/profile.d/vcxsrv.sh"
