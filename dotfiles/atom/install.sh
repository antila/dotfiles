#!/bin/sh

if test ! $(which atom)
then
  echo "  Installing atom.io for you."
  wget https://atom.io/download/deb -O /tmp/atom.deb
  sudo dpkg -i /tmp/atom.deb
  rm /tmp/atom.deb
fi
