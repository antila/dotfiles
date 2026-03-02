#!/usr/bin/env zx

const nvmDir = process.env.NVM_DIR || `${process.env.HOME}/.nvm`;

if (!(await fs.pathExists(nvmDir))) {
  console.log('  Installing nvm');
  await $`bash -lc "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash"`;
}
