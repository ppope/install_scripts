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

add_bashrc () {
  if grep --quiet "$1" ~/.bashrc; then
    echo "$1" >> ~/.bashrc
  fi
}

echo "Updating packages..."
sudo apt -qq update

#dev tools
#Use vim-gtk for +xterm_clipboard
if ! command_exists vim ; then
  echo "Installing vim..."
  sudo apt install vim-gtk
else
  echo "vim already installed"
fi

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
fi

#clone my dotfiles
if [ ! -f ~/.tmux.conf ] || [ ! -f ~/.vimrc ]; then
  echo "Cloning dotfiles"
  git clone --recursive git@github.com:ppope/dotfiles.git ~/
fi

#Personal Programs
#chrome TODO(phil): Switch to something else, so Google stops surveiling me
if ! command_exists google-chrome ; then
  echo "Installing chrome"
  sudo apt -qq install libxss1 libappindicator1 libindicator7
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo dpkg -i google-chrome*.deb
  rm google-chrome*.deb
else
  echo "$(google-chrome --version) already installed"
fi


#sublime
if ! command_exists subl; then
  echo "Installing sublime"
  sudo add-apt-repository ppa:webupd8team/sublime-text-3
  sudo apt-get -qq update
  sudo apt-get install sublime-text-installer
else
  echo "$(subl -v) already installed"
fi

echo "Package installation complete!"

#bashrc edits
echo "Adding to bashrc..."
add_bashrc "#Additions made by Phil's install script"
add_bashrc "set -o vi"
add_bashrc "alias gogh=\"wget -O gogh https://git.io/vQgMr && chmod +x gogh && ./gogh && rm gogh\""

echo "Complete!"
