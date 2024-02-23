#!/bin/sh

if [ ! -d "$NVM_DIR" ]; then
  echo "  Installing nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
fi
