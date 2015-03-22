#!/bin/sh

if test ! $(which awesome)
then
    echo "  Installing awesome for you."
    sudo apt-get install -y awesome feh
    sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /usr/share/xsessions/awesome.desktop
fi

