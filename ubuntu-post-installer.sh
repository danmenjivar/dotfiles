#!/bin/bash

# Post-install script for Ubuntu by Dan Menjivar

# Installing some basic system utilities first
cd ~
sudo apt-get update -qq
sudo apt-get install -yy htop neofetch terminator vim zsh

# Installing Google Chrome
cd /home/dan/Downloads
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb
cd ~

# Installing VS Code
cd /home/dan/Downloads
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt install apt-transport-https
sudo apt-get update -qq
sudo apt install code 
rm -f packages.microsoft.gpg
cd ~

# Installing Spotify
sudo apt-add-repository -y "deb http://repository.spotify.com stable non-free" 
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0D811D58
sudo apt-get update -qq
sudo apt-get install -yy spotify-client

# Set Zshell as default shell
chsh -s $(which zsh)

# Installation complete.
echo "All done! Please reboot the computer."