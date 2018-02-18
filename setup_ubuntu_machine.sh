#!/usr/bin/env bash

sudo apt update

#dev tools
sudo apt install vim git


#install latest version of tmux
VERSION=2.6
sudo apt-get -y remove tmux
sudo apt-get -y install wget tar libevent-dev libncurses-dev
wget https://github.com/tmux/tmux/releases/download/${VERSION}/tmux-${VERSION}.tar.gz
tar xf tmux-${VERSION}.tar.gz
rm -f tmux-${VERSION}.tar.gz
cd tmux-${VERSION}
./configure
make
sudo make install
cd -
sudo rm -rf /usr/local/src/tmux-*
sudo mv tmux-${VERSION} /usr/local/src


git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#Dependecies for tmux plugins
#tmux-yank
sudo apt-get install xsel 


#docker
#https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce
sudo apt remove -y docker docker-engine docker.io
sudo apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -


sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt update
sudo apt install docker-ce


#clone dotfiles
git clone --recursive git@github.com:ppope/dotfiles.git ~/


#chrome
#TODO: Stop letting Google surveil me
sudo apt install libxss1 libappindicator1 libindicator7
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb


sudo apt upgrade

