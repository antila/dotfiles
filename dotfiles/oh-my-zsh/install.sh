#!/bin/sh

if test ! $(which zsh)
then
  echo "  Installing zsh for you."
  sudo apt-get install -y zsh
fi

if [ ! -d ~/.oh-my-zsh ]; then
  echo "  Installing zsh for you."
  wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh
  # Removing built in .zshrc
  rm ~/.zshrc
  # Set as shell
  chsh -s $(which zsh)
fi
