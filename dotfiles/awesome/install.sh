#!/bin/sh

if test ! $(which awesome)
then
    echo "  Installing awesome for you."
    sudo mkdir /etc/apt/sources.list.d/
    echo "deb http://ppa.launchpad.net/klaus-vormweg/awesome/ubuntu vivid main" | sudo tee /etc/apt/sources.list.d/klaus-vormweg-awesome-jessie.list
    sudo apt-get update
    sudo apt-get install -y awesome feh
    sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /usr/share/xsessions/awesome.desktop
fi
