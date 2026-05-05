#!/usr/bin/env zx

try {
  await $`which code`;
} catch {
  console.log('  Installing Visual Studio Code');
  await $`sudo snap install code --classic`;
}
