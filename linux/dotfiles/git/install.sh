#!/bin/sh

if test ! $(which rebase-editor)
then
  echo "  Installing rebase-editor"
  sudo npm install -g rebase-editor
  git config --global sequence.editor rebase-editor
fi
