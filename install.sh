#!/bin/bash

if ! command -v stow >/dev/null 2>&1 || ! command -v git >/dev/null 2>&1; then
	sudo apt-get install stow git
fi

if ! command -v curl >/dev/null 2>&1; then
	sudo apt-get install curl
fi

if ! command -v fnm >/dev/null 2>&1; then
	curl -fsSL https://fnm.vercel.app/install | bash
fi

export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env --shell bash)"

if ! command -v node >/dev/null 2>&1; then
	fnm install --latest
	fnm use latest
fi

npm install -g zx
npm install
~/.dotfiles/install.mjs
