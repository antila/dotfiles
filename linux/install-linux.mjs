#!/usr/bin/env zx

import { cd } from 'zx';
import {
    ROOT_DIR,
    fail,
    install_aptitude_stuff,
    install_dotfiles,
    install_homebrew_stuff,
    isRoot,
    run_installers,
    success,
} from '../common/functions.mjs';

cd(`${ROOT_DIR}/linux`);

console.log('');

if (!isRoot()) {
    await run_installers();
    await install_dotfiles();
    await install_aptitude_stuff();
    await install_homebrew_stuff();
    console.log('');
    success('  All installed!');
    process.exit(0);
}

fail("Don't run this as root.");
