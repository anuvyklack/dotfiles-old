# Install Homebrew

# Check we have correct dependencies installed for brew
echo -e "\e[1;37mInstalling \e[1;33mHomebrew \e[1;37mdependencies\e[0m"
sudo apt-get install -y -q build-essential curl file git

if [[ ! -d "/home/linuxbrew/.linuxbrew" ]]
then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
fi

eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
