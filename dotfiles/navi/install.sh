#!/bin/sh

if test ! $(which navi)
then
  # https://github.com/denisidoro/navi
  echo "  Installing navi"
  curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install | bash
fi
