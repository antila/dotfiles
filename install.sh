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

  sudo stow --dir="$DOTFILES_ROOT/system/" --target=/ stow
}

run_installers () {
  # find the installers and run them iteratively
  info 'Installing stuff:'
  find "$DOTFILES_ROOT/" -name install.sh | while read installer ; do sh -c "${installer}" ; done
}

install_aptitude_stuff () {
  # find the installers and run them iteratively
  info 'Installing apt stuff:'
  TO_INSTALL=$(grep -vE "^\s*#" .auto-install  | tr "\n" " ")
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

if [ "$EUID" -ne 0 ]; then
    run_installers
    install_dotfiles
    install_aptitude_stuff
    echo ''
    success '  All installed!'
    exit
else
    fail "Don't run this as root."
    exit
fi
