#!/bin/bash

# Inspired by https://github.com/necolas/dotfiles

DOTFILES_DIRECTORY="${HOME}/dotfiles"

if [[ "$1" == "" ]]; then
    echo "Avaliable commands: update-submodules, init"
    exit
fi

## Init ########################################################################

function initall {
    read -p "Are you sure? This will delete all your configurations. (y/n):" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo -e "\n"
        # Force remove the vim directory if it's already there.
        if [ -e "${HOME}/.vim" ]; then
            echo -e "Removing .vim-folder\n"
            rm -rf "${HOME}/.vim"
        fi

        symlink bash/bashrc .bashrc
    fi
}

function symlink {
    echo -e " * Creating symbolic link from ${DOTFILES_DIRECTORY}/$1 to ${HOME}/$2\n"
    ln --force --symbolic ${DOTFILES_DIRECTORY}/$1 ${HOME}/$2
}

if [[ "$1" == "init" ]]; then
    initall
    exit
fi

## Submodules ##################################################################

submodules=( 'lib/bash/z' )

if [[ "$1" == "submodules" ]]; then
    for i in "${submodules[@]}"
    do
       update-submodule $i
    done
    exit
fi

function update-submodule {
    echo
    cd $1
    git checkout master
    git pull origin master
    cd ${DOTFILES_DIRECTORY}
    git add $1
    git commit -m "Update submodule '$1' to the latest version"
    git push origin master
}

################################################################################
