#!/bin/sh

if test ! $(which zsh)
then
  echo "  Installing zsh"
  sudo apt-get install -y zsh

  # Set as shell
  chsh -s $(which zsh)

  # Download presto
  # https://github.com/sorin-ionescu/prezto
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi

if test ! $(which nvm)
then
  echo "  Installing nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
fi

if test ! $(which exa)
then
  echo "  Installing exa"
  sudo apt-get install -y exa
fi

if test ! $(which nvim)
then
  echo "  Installing neovim"
  sudo apt-get install -y neovim
fi

if test ! $(which direnv)
then
  echo "  Installing direnv"
  sudo apt-get install -y direnv
fi

if test ! $(which bat)
then
  echo "  Installing bat"

  # nicer cat
  sudo apt-get install -y bat
  mkdir -p ~/.local/bin
  ln -s /usr/bin/batcat ~/.local/bin/bat
fi
