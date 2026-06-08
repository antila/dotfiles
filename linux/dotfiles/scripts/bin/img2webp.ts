#!/usr/bin/env -S node

import { access } from 'node:fs/promises';
import { basename, dirname, extname, join } from 'node:path';
import sharp from 'sharp';

const input = process.argv[2];

if (!input) {
  console.error('Usage: img2webp <file>');
  process.exit(1);
}

try {
  await access(input);
} catch {
  console.error(`File not found: ${input}`);
  process.exit(1);
}

const ext = extname(input);
const output = join(dirname(input), `${basename(input, ext)}.webp`);

await sharp(input).webp({ quality: 80 }).toFile(output);

console.log(`${input} -> ${output}`);
