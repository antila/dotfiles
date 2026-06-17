#!/usr/bin/env zx

import { commandExists, resolveCommand, info } from '../../../common/functions.mjs';

/**
 * @param {string} name - Display name
 * @param {() => Promise<boolean>} checkFn - Check if installed
 * @param {() => Promise<void>} installFn - Installation function
 */
async function ensureInstalled(name, checkFn, installFn) {
  if (!(await checkFn())) {
    info(`Installing ${name}`);
    await installFn();
  } else {
    info(`    - ${name} is already installed`);
  }
}

await ensureInstalled('zsh', () => commandExists('zsh'), async () => {
  await $`sudo apt-get install -y zsh`;
  const zshPath = await resolveCommand('zsh');
  await $`chsh -s ${zshPath}`;
});

await ensureInstalled('starship', () => commandExists('starship'), async () => {
  await $`bash -lc "curl -sS https://starship.rs/install.sh | sh"`;
});

const preztoDir = `${process.env.ZDOTDIR || process.env.HOME}/.zprezto`;
await ensureInstalled('prezto', () => fs.pathExists(preztoDir), async () => {
  await $`git clone --recursive https://github.com/sorin-ionescu/prezto.git ${preztoDir}`;
});

await ensureInstalled('eza', () => commandExists('eza'), async () => {
  await $`sudo apt-get install -y eza`;
});

await ensureInstalled('neovim', () => commandExists('nvim'), async () => {
  await $`sudo apt-get install -y neovim`;
});

await ensureInstalled('direnv', () => commandExists('direnv'), async () => {
  await $`sudo apt-get install -y direnv`;
});

await ensureInstalled('tmux', () => commandExists('tmux'), async () => {
  await $`sudo apt-get install -y tmux`;
});


await ensureInstalled('honeymux', () => commandExists('hmx'), async () => {
  await $`curl -fsSL https://get.hmx.dev | bash`;
});

await ensureInstalled('atuin', async () => {
  return !!(await resolveCommand('atuin', [`${process.env.HOME}/.atuin/bin/atuin`]));
}, async () => {
  await $`/bin/bash -c "$(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)"`;
  const installedAtuinCommand = await resolveCommand('atuin', [
    `${process.env.HOME}/.atuin/bin/atuin`,
  ]);
  if (installedAtuinCommand) {
    await $`${installedAtuinCommand} import auto`;
  }
});

await ensureInstalled('bat', () => fs.pathExists('/usr/bin/batcat'), async () => {
  await $`sudo apt-get install -y bat`;
  await fs.ensureDir(`${process.env.HOME}/.local/bin`);
  if (!(await fs.pathExists(`${process.env.HOME}/.local/bin/bat`))) {
    await $`ln -s /usr/bin/batcat ${process.env.HOME}/.local/bin/bat`;
  }
});
