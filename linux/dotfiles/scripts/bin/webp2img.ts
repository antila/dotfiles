#!/usr/bin/env -S node

import { access } from 'node:fs/promises';
import { basename, dirname, extname, join } from 'node:path';
import sharp from 'sharp';

const input = process.argv[2];
const target = (process.argv[3] ?? 'png').toLowerCase();

if (!input) {
  console.error('Usage: webp2img <file.webp> [png|jpg]');
  process.exit(1);
}

if (target !== 'png' && target !== 'jpg' && target !== 'jpeg') {
  console.error(`Unsupported target format: ${target} (use png or jpg)`);
  process.exit(1);
}

try {
  await access(input);
} catch {
  console.error(`File not found: ${input}`);
  process.exit(1);
}

const ext = extname(input);
const outExt = target === 'png' ? 'png' : 'jpg';
const output = join(dirname(input), `${basename(input, ext)}.${outExt}`);

const image = sharp(input);
if (outExt === 'png') {
  image.png();
} else {
  image.flatten({ background: '#ffffff' }).jpeg({ quality: 90, mozjpeg: true });
}
await image.toFile(output);

console.log(`${input} -> ${output}`);
