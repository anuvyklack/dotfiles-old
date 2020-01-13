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
