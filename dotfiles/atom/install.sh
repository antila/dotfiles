#!/bin/sh

if test ! $(which atom)
then
    # Grab latest atom, also used as update
    echo "Downloading latest version of Atom"
    wget -q https://github.com/atom/atom/releases/latest -O /tmp/latest
    wget -q $(awk -F '[<>]' '/href=".*atom-amd64.deb/ {match($0,"href=\"(.*.deb)\"",a); print "https://github.com/" a[1]} ' /tmp/latest) -O /tmp/atom-amd64.deb
    sudo dpkg -i /tmp/atom-amd64.deb
fi

if test ! $(apm list | grep package-sync); then
    echo "Downloading Atom modules"
    apm install package-sync
fi
