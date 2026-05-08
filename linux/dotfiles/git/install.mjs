#!/usr/bin/env zx

import { commandExists } from '../../../common/functions.mjs';

if (!(await commandExists('rebase-editor'))) {
  console.log('  Installing rebase-editor');
  await $`npm install -g rebase-editor`;
  await $`git config --global sequence.editor rebase-editor`;
}
