#!/bin/sh

if test ! $(which awesome)
then
  echo "  Installing awesome for you."
  sudo apt-get install -y awesome
fi
