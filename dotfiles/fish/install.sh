#!/bin/sh

if test ! $(which fish)
then
  echo "  Installing fish"
  sudo apt-add-repository ppa:fish-shell/release-3
  sudo apt update
  sudo apt-get install -y fish

  # Set as shell
  chsh -s $(which fish)
fi
