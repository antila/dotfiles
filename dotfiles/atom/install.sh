#!/bin/sh

if test ! $(which atom)
then
  echo "  Installing atom.io for you."
  cd /tmp
  wget https://atom.io/download/deb
  sudo dpkg -i atom-amd64.deb
  cd -
fi
