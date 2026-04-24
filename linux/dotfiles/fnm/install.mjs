#!/usr/bin/env zx

const fnmDir = process.env.FNM_DIR || `${process.env.HOME}/.fnm`;

if (!(await fs.pathExists(fnmDir))) {
  console.log('  Installing fnm');
  await $`bash -lc "curl -fsSL https://fnm.vercel.app/install | bash"`;
}
