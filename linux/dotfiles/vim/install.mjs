#!/bin/sh

if test ! $(which vim)
then
  echo "  Installing vim for you."
  sudo apt-get install -y vim
fi
