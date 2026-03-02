#!/usr/bin/env zx

try {
  await $`which vim`;
} catch {
  console.log('  Installing vim for you.');
  await $`sudo apt-get install -y vim`;
}
