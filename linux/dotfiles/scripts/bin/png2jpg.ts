#!/usr/bin/env -S node

import { access } from 'node:fs/promises';
import { basename, dirname, extname, join } from 'node:path';
import sharp from 'sharp';

const input = process.argv[2];

if (!input) {
  console.error('Usage: png2jpg <file.png>');
  process.exit(1);
}

try {
  await access(input);
} catch {
  console.error(`File not found: ${input}`);
  process.exit(1);
}

const ext = extname(input);
const output = join(dirname(input), `${basename(input, ext)}.jpg`);

await sharp(input)
  .flatten({ background: '#ffffff' })
  .jpeg({ quality: 90, mozjpeg: true })
  .toFile(output);

console.log(`${input} -> ${output}`);
