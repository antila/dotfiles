#!/bin/sh

if ! test $(fc-list | grep Proggy2 | wc -l) -eq 0
then
    echo "  Installing fonts.\n"
    rm /etc/fonts/conf.d/70-no-bitmaps.conf
    fc-cache -f -v
fi
