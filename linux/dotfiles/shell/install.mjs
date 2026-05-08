#!/usr/bin/env zx

import { commandExists, resolveCommand } from '../../../common/functions.mjs';

if (!(await commandExists('zsh'))) {
  console.log('  Installing zsh');
  await $`sudo apt-get install -y zsh`;
  const zshPath = await resolveCommand('zsh');
  await $`chsh -s ${zshPath}`;
}

if (!(await commandExists('starship'))) {
  console.log('  Installing starship');
  await $`bash -lc "curl -sS https://starship.rs/install.sh | sh"`;
}

const preztoDir = `${process.env.ZDOTDIR || process.env.HOME}/.zprezto`;
if (!(await fs.pathExists(preztoDir))) {
  console.log('  Installing prezto');
  await $`git clone --recursive https://github.com/sorin-ionescu/prezto.git ${preztoDir}`;
}

if (!(await commandExists('eza'))) {
  console.log('  Installing eza');
  await $`sudo apt-get install -y eza`;
}

if (!(await commandExists('nvim'))) {
  console.log('  Installing neovim');
  await $`sudo apt-get install -y neovim`;
}

if (!(await commandExists('direnv'))) {
  console.log('  Installing direnv');
  await $`sudo apt-get install -y direnv`;
}

const atuinCommand = await resolveCommand('atuin', [
  `${process.env.HOME}/.atuin/bin/atuin`,
]);
if (!atuinCommand) {
  console.log('  Installing atuin');
  await $`/bin/bash -c "$(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)"`;
  const installedAtuinCommand = await resolveCommand('atuin', [
    `${process.env.HOME}/.atuin/bin/atuin`,
  ]);
  if (installedAtuinCommand) {
    await $`${installedAtuinCommand} import auto`;
  }
}

if (!(await fs.pathExists('/usr/bin/batcat'))) {
  console.log('  Installing bat');
  await $`sudo apt-get install -y bat`;
  await fs.ensureDir(`${process.env.HOME}/.local/bin`);
  if (!(await fs.pathExists(`${process.env.HOME}/.local/bin/bat`))) {
    await $`ln -s /usr/bin/batcat ${process.env.HOME}/.local/bin/bat`;
  }
}
