#!/usr/bin/env bash

if test ! $(which atuin)
then
  echo "  Installing atuin"
  # nice history
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
  PATH=$PATH:~/.atuin/bin
  atuin import auto
fi
