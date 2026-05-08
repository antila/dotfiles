#!/usr/bin/env zx

import { commandExists } from '../../../common/functions.mjs';

if (!(await commandExists('code'))) {
  console.log('  Installing Visual Studio Code');
  await $`sudo snap install code --classic`;
}
