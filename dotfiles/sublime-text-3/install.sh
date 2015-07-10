#!/bin/sh

if test ! $(which subl)
then
  echo "  Installing zsh for you."
  cd /tmp
  wget http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_amd64.deb
  sudo dpkg -i sublime-text_build-3083_amd64.deb
  cd -
fi
