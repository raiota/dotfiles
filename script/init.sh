#!/bin/bash

# clone dotfiles
echo '==> Cloning dotfiles...'
if [ -e ~/dotfiles ]; then
  rm -rf ~/dotfiles
fi
git clone https://github.com/raiota/dotfiles.git ~/dotfiles

# install build-essential
if [ $(uname) == "Linux" ]; then
  echo '==> Installing build-essential...'
  sudo apt update
  sudo apt install build-essential
end

# install Command Line Tools for Xcode
if [ $(uname) == "Darwin" ]; then
  echo '==> Installing command Line Tools for Xcode'
  xcode-select --install
end

# install Homebrew
echo '==> Installing Homebrew...'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# symbolic links
echo '==> Making Symbolic Links...'
make -f ~/dotfiles/Makefile deploy

# install packages
echo '==> Start Installing Packages'
brew bundle

# change default shell
echo '==> Changing Default Shell...'
command -v fish | sudo tee -a /etc/shells
sudo chsh -s $(command -v fish) ${USER}

# fisher
echo '==> Installing Fisher plugins...'
fish -c "curl -sL git.io/fisher | source && fisher update"