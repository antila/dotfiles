#!/bin/bash

if ! command -v stow >/dev/null 2>&1 || ! command -v git >/dev/null 2>&1; then
	sudo apt-get install stow git
fi

npm install -g zx
npm install
~/.dotfiles/install.mjs
