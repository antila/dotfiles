#!/usr/bin/env zx

if (process.platform === 'linux') {
  await import('./linux/install-linux.mjs');
} else if (process.platform === 'darwin') {
  await import('./osx/install-osx.mjs');
} else {
  console.log('Unknown.');
}
