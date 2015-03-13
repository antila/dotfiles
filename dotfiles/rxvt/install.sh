#!/bin/sh

if test ! $(which urxvt)
then
  echo "  Installing rxvt-unicode-256color for you."
  sudo apt-get install -y rxvt-unicode-256color
fi
