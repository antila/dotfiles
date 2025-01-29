#!/usr/bin/env bash
#
# bootstrap installs things.

# Load the test function
source "./common/functions.sh"

cd "../$(dirname "$0")/"
DOTFILES_ROOT=$(pwd)/dotfiles

set -e

echo ''

if [ "$EUID" -ne 0 ]; then
    run_installers
    install_dotfiles
    install_homebrew_stuff
    echo ''
    success '  All installed!'
    exit
else
    fail "Don't run this as root."
    exit
fi
