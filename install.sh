#!/usr/bin/env bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ./linux/install-linux.sh
elif [[ "$OSTYPE" == "darwin"* ]]; then
    ./osx/install-osx.sh
else
    echo Unknown.
fi
