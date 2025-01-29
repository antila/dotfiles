#!/usr/bin/env bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ./osx/install-linux.sh
elif [[ "$OSTYPE" == "darwin"* ]]; then
    ./osx/install-osx.sh
else
    echo Unknown.
fi
