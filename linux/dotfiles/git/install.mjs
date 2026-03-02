#!/usr/bin/env zx

try {
  await $`which rebase-editor`;
} catch {
  console.log('  Installing rebase-editor');
  await $`sudo npm install -g rebase-editor`;
  await $`git config --global sequence.editor rebase-editor`;
}
