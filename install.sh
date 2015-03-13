#!/usr/bin/env bash
#
# bootstrap installs things.

cd "$(dirname "$0")/"
DOTFILES_ROOT=$(pwd)/dotfiles

set -e

echo ''

info () {
  printf "  [ \033[00;34m..\033[0m ] $1"
}

user () {
  printf "\r  [ \033[0;33m?\033[0m ] $1 "
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

install_dotfiles () {
  info 'installing dotfiles'

  for src in $(find "$DOTFILES_ROOT/" -maxdepth 2 -name 'stow')
  do
    stow --dir="$src/.." --target=$HOME stow
  done
}

run_installers () {
  # find the installers and run them iteratively
  info 'Installing stuff...'
  find "$DOTFILES_ROOT/" -name install.sh | while read installer ; do sh -c "${installer}" ; done
}

install_aptitude_stuff () {
  # find the installers and run them iteratively
  info 'Installing apt stuff...'
  #sudo apt-get install $(grep -vE "^\s*#" .auto-install  | tr "\n" " ")
}

run_installers
install_dotfiles
#install_aptitude_stuff

echo ''
echo '  All installed!'
