#!/bin/sh

if test ! $(which zsh)
then
  echo "  Installing zsh"
  sudo apt-get install -y zsh

  curl -sS https://starship.rs/install.sh | sh

  # nicer cat
  sudo apt-get install -y bat
  mkdir -p ~/.local/bin
  ln -s /usr/bin/batcat ~/.local/bin/bat

  # nicer ls
  sudo apt-get install -y exa

  # neovim
  sudo apt-get install -y neovim 
  
  # direnv
  sudo apt-get install -y direnv

  # Set as shell
  chsh -s $(which zsh)

  # Download presto
  # https://github.com/sorin-ionescu/prezto
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi
