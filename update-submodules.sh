#!/bin/bash

submodules=( 'lib/bash/z' )

function update-submodule {
    echo
    cd $1
    git checkout master
    git pull origin master
    cd ../../..
    git add $1
    git commit -m "Update submodule '$1' to the latest version"
    git push origin master
}

for i in "${submodules[@]}"
do
   update-submodule $i
done
