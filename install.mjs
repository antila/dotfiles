#!/usr/bin/env zx

if (process.platform === 'linux') {
    await $`./linux/install-linux.sh`;
} else if (process.platform === 'darwin') {
    await $`./osx/install-osx.sh`;
} else {
    console.log('Unknown.');
}
