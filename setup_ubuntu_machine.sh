#!/usr/bin/env bash
#Script for setting up an Ubuntu development machine

command_exists () {
  type "$1" > /dev/null 2>&1;
}

install_command_if_not_exists () {
  if ! command_exists $1 ; then
    echo "Installing $1..."
    sudo apt install $1
  else
    echo "$1 already installed"
  fi
}

echo "Updating packages"
sudo apt -qq update

#dev tools
#Use vim-gtk for +xterm_clipboard
install_command_if_not_exists vim-gtk
install_command_if_not_exists git

if ! command_exists tmux ; then
  #install this version of tmux
  VERSION=2.6
  sudo apt -y remove tmux
  #tmux dependencies
  sudo apt -y install wget tar libevent-dev libncurses-dev
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

  #tmux plugin manager
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  #Dependecies for tmux plugins
  #tmux-yank
  sudo apt install xsel
else
  echo "$(tmux -V) already installed"
fi

#docker
if ! command_exists docker ; then
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
  sudo apt -qq update
  sudo apt install docker-ce
else
  echo "$(docker --version) already installed"


#clone my dotfiles
if [ ! -f ~/.tmux.conf ] || [! -f ~/.vimrc ]; then
  git clone --recursive git@github.com:ppope/dotfiles.git ~/


#chrome
#TODO: Stop letting Google surveil me
if ! command_exists google-chrome ; then
  sudo apt -qq install libxss1 libappindicator1 libindicator7
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo dpkg -i google-chrome*.deb
  rm google-chrome*.deb
else
  echo "$(google-chrome --version) already installed"

echo "Upgrading packages"
sudo apt -qq upgrade
