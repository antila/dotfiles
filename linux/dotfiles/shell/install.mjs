#!/usr/bin/env zx

async function has(command) {
  try {
    await $`which ${command}`;
    return true;
  } catch {
    return false;
  }
}

if (!(await has('zsh'))) {
  console.log('  Installing zsh');
  await $`sudo apt-get install -y zsh`;

  const zshPath = (await $`which zsh`).stdout.trim();
  await $`chsh -s ${zshPath}`;
  await $`bash -lc "curl -sS https://starship.rs/install.sh | sh"`;

  const preztoDir = `${process.env.ZDOTDIR || process.env.HOME}/.zprezto`;
  if (!(await fs.pathExists(preztoDir))) {
    await $`git clone --recursive https://github.com/sorin-ionescu/prezto.git ${preztoDir}`;
  }
}

if (!(await has('exa'))) {
  console.log('  Installing exa');
  await $`sudo apt-get install -y exa`;
}

if (!(await has('nvim'))) {
  console.log('  Installing neovim');
  await $`sudo apt-get install -y neovim`;
}

if (!(await has('direnv'))) {
  console.log('  Installing direnv');
  await $`sudo apt-get install -y direnv`;
}

if (!(await has('atuin'))) {
  console.log('  Installing atuin');
  await $`/bin/bash -c "$(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)"`;
  await $`atuin import auto`;
}

if (!(await fs.pathExists('/usr/bin/batcat'))) {
  console.log('  Installing bat');
  await $`sudo apt-get install -y bat`;
  await fs.ensureDir(`${process.env.HOME}/.local/bin`);
  if (!(await fs.pathExists(`${process.env.HOME}/.local/bin/bat`))) {
    await $`ln -s /usr/bin/batcat ${process.env.HOME}/.local/bin/bat`;
  }
}
