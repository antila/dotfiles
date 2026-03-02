#!/usr/bin/env bash

source "./common/functions.sh"

cd $ROOT_DIR/linux

set -e

echo ''

if [ "$EUID" -ne 0 ]; then
    run_installers
    install_dotfiles
    install_aptitude_stuff
    install_homebrew_stuff
    echo ''
    success '  All installed!'
    exit
else
    fail "Don't run this as root."
    exit
fi
