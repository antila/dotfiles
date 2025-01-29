#!/usr/bin/env bash
#
# bootstrap installs things.

cd "$(dirname "$0")/"
DOTFILES_ROOT=$(pwd)/dotfiles

set -e

echo ''

info () {
  printf "  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m?\033[0m ] $1 "
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo "\n"
  exit
}

install_dotfiles () {
  info 'Installing dotfiles:'

  for src in $(find "$DOTFILES_ROOT/" -maxdepth 2 -path ./system -prune -o -name 'stow')
  do
    stow --dir="$src/.." --target=$HOME stow
    info " - Checking: $src"
  done
}

run_installers () {
  # find the installers and run them iteratively
  info 'Installing stuff:'
  find "$DOTFILES_ROOT/" -name install.sh | while read installer ; do sh -c "${installer}" ; done
}

install_aptitude_stuff () {
  info 'Installing apt stuff:'
  TO_INSTALL=$(cat .auto-install-apt | sed '/^\(#\|[[:space:]]*$\)/d;s/#.*//g' | tr "\n" " ")
  TO_INSTALL_ARRAY=($TO_INSTALL)

  for i in "${TO_INSTALL_ARRAY[@]}"
    do
      if [ $(dpkg-query -W -f='${Status}' $i 2>/dev/null | grep -c "ok installed") -eq 0 ];
        then
          info "  Installing $i"
          sudo apt-get install $i;
        else
          success "- $i already installed"
      fi
  done
}

install_homebrew_stuff () {
  info 'Installing homebrew stuff:'
  TO_INSTALL=$(cat .auto-install-brew | sed '/^\(#\|[[:space:]]*$\)/d;s/#.*//g' | tr "\n" " ")
  TO_INSTALL_ARRAY=($TO_INSTALL)

  for i in "${TO_INSTALL_ARRAY[@]}"
    do
      if brew list $i &>/dev/null; then
        echo "${i} is already installed"
      else
        brew install $i && echo "$i is installed"
      fi
  done
}

