#!/bin/bash

# Inspired by https://github.com/necolas/dotfiles

DOTFILES_DIRECTORY="${HOME}/dotfiles"

if [[ "$1" == "" ]]; then
    echo "Avaliable commands: update-submodules, init"
    exit
fi

## Init ########################################################################

function initall {

    echo -e " * Updating submodules"
    # Force remove the vim directory if it's already there.
    if [ -e "${HOME}/.vim" ]; then
        echo -e " * Removing ~/.vim\n"
        rm -rf "${HOME}/.vim"
    fi

    # Submodules
    git submodule init
    git submodule update

    # Create symlinks
    symlink config/bash/bashrc .bashrc
    symlink config/zsh/zshrc .zshrc
    symlink lib/bash/oh-my-zsh .oh-my-zsh
	symlink config/vim .vim

    echo -e "\nDone!\n"
}

function symlink {
    echo -e " * Creating symbolic link from ${DOTFILES_DIRECTORY}/$1 to ${HOME}/$2"
    rm -f ${HOME}/$2
    ln --force --symbolic ${DOTFILES_DIRECTORY}/$1 ${HOME}/$2
}

if [[ "$1" == "init" ]]; then
    initall
    exit
fi

## Submodules ##################################################################

submodules=( 'lib/bash/z' 'lib/bash/oh-my-zsh' )

function update-submodule {
    echo
    cd $1
    git checkout master
    git pull origin master
    cd ${DOTFILES_DIRECTORY}
    git add $1
    git commit $1 -m "Update submodule '$1' to the latest version"
    git push origin master
}

if [[ "$1" == "update-submodules" ]]; then
    for i in "${submodules[@]}"
    do
       update-submodule $i
    done
    exit
fi

#function add-submodule {
    # Add the new submodule
    #git submodule add https://example.com/remote/path/to/repo.git vim/bundle/one-submodule
    # Initialize and clone the submodule
    #git submodule update --init
    # Stage the changes
    #git add vim/bundle/one-submodule
    # Commit the changes
    #git commit -m "Add a new submodule: one-submodule"
#}

################################################################################
