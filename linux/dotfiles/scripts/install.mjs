#!/usr/bin/env zx

import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const binDir = path.join(__dirname, 'bin');
const targetDir = path.join(process.env.HOME, '.local', 'bin');

if (await fs.pathExists(path.join(binDir, 'package.json'))) {
  console.log('  - Installing script dependencies');
  await $`npm install --prefix ${binDir}`;
}

await fs.ensureDir(targetDir);

const entries = (await fs.readdir(binDir)).filter((file) =>
  file.endsWith('.ts'),
);

for (const entry of entries) {
  const source = path.join(binDir, entry);
  const command = entry.replace(/\.ts$/, '');
  const link = path.join(targetDir, command);

  await fs.chmod(source, 0o755);

  const alreadyLinked =
    (await fs.pathExists(link)) &&
    (await fs.lstat(link)).isSymbolicLink() &&
    (await fs.realpath(link)) === source;

  if (alreadyLinked) {
    continue;
  }

  if (await fs.pathExists(link)) {
    const stat = await fs.lstat(link);
    if (!stat.isSymbolicLink()) {
      console.log(`  - ${command} exists and is not a symlink, skipping`);
      continue;
    }
    await fs.remove(link);
  }

  await fs.ensureSymlink(source, link);
  console.log(`  - Linked ${command} -> ${path.relative(targetDir, source)}`);
}
