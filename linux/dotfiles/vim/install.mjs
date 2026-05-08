#!/usr/bin/env zx

import { commandExists } from '../../../common/functions.mjs';

if (!(await commandExists('vim'))) {
  console.log('  Installing vim for you.');
  await $`sudo apt-get install -y vim`;
}
