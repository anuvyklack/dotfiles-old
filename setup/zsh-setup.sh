#!/bin/sh

sudo apt update && sudo apt upgrade
sudo apt install zsh
chsh -s $(which zsh)
