#!/usr/bin/env zx

import { resolveCommand } from '../../../common/functions.mjs';

const atuinCommand = await resolveCommand('atuin', [
  `${process.env.HOME}/.atuin/bin/atuin`,
]);

if (!atuinCommand) {
  console.log('  Installing atuin');
  await $`bash -lc "curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh"`;
  const installedAtuinCommand = await resolveCommand('atuin', [
    `${process.env.HOME}/.atuin/bin/atuin`,
  ]);
  if (installedAtuinCommand) {
    await $`${installedAtuinCommand} import auto`;
  }
}
