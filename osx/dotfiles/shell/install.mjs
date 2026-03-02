#!/usr/bin/env zx

try {
  await $`which atuin`;
} catch {
  console.log('  Installing atuin');
  await $`bash -lc "curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh"`;
  process.env.PATH = `${process.env.PATH}:${process.env.HOME}/.atuin/bin`;
  await $`atuin import auto`;
}
