#!/usr/bin/env -S node

import { readdir, readFile, stat, writeFile } from 'node:fs/promises';
import { extname, join } from 'node:path';
import { createInterface } from 'node:readline/promises';
import sharp from 'sharp';

type Format = 'jpeg' | 'png' | 'webp' | 'avif' | 'tiff';

const OPTIONS: Record<Format, Record<string, unknown>> = {
  jpeg: { quality: 90, mozjpeg: true },
  png: { compressionLevel: 9, palette: true },
  webp: { quality: 80 },
  avif: { quality: 55 },
  tiff: { quality: 80 },
};

const EXTENSIONS: Record<string, Format> = {
  '.jpg': 'jpeg',
  '.jpeg': 'jpeg',
  '.png': 'png',
  '.webp': 'webp',
  '.avif': 'avif',
  '.tif': 'tiff',
  '.tiff': 'tiff',
};

function humanSize(bytes: number): string {
  const units = ['B', 'KB', 'MB', 'GB'];
  let value = bytes;
  let unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit++;
  }
  return `${value.toFixed(value < 10 && unit > 0 ? 1 : 0)} ${units[unit]}`;
}

function percent(before: number, after: number): string {
  if (before === 0) {
    return '0.0%';
  }
  return `${(((before - after) / before) * 100).toFixed(1)}%`;
}

const cwd = process.cwd();
const dirEntries = await readdir(cwd, { withFileTypes: true });

const images: { name: string; format: Format; size: number }[] = [];
for (const entry of dirEntries) {
  if (!entry.isFile()) {
    continue;
  }
  const format = EXTENSIONS[extname(entry.name).toLowerCase()];
  if (!format) {
    continue;
  }
  const { size } = await stat(join(cwd, entry.name));
  images.push({ name: entry.name, format, size });
}

if (images.length === 0) {
  console.log('No images found in the current folder.');
  process.exit(0);
}

const nameWidth = Math.max(...images.map((image) => image.name.length));
console.log(`Found ${images.length} image(s) in ${cwd}:\n`);
for (const image of images) {
  console.log(
    `  ${image.name.padEnd(nameWidth)}  ${humanSize(image.size).padStart(9)}`,
  );
}

const rl = createInterface({ input: process.stdin, output: process.stdout });
const answer = await rl.question(
  `\nOptimize ${images.length} image(s) in place? [y/N] `,
);
rl.close();

if (!/^y(es)?$/i.test(answer.trim())) {
  console.log('Aborted.');
  process.exit(0);
}

console.log('');

let totalBefore = 0;
let totalAfter = 0;

for (const image of images) {
  const path = join(cwd, image.name);
  try {
    const input = await readFile(path);
    const output = await sharp(input)
      [image.format](OPTIONS[image.format])
      .toBuffer();

    const before = image.size;
    const after = output.length;

    // Skip the write unless we save at least 5%, so re-running doesn't
    // degrade already-optimized files (e.g. re-compressing JPEGs).
    if (before - after < before * 0.05) {
      console.log(
        `  ${image.name.padEnd(nameWidth)}  ${humanSize(before).padStart(9)}  (kept original, <5% gain)`,
      );
      totalBefore += before;
      totalAfter += before;
      continue;
    }

    await writeFile(path, output);
    totalBefore += before;
    totalAfter += after;

    console.log(
      `  ${image.name.padEnd(nameWidth)}  ${humanSize(before).padStart(9)} -> ${humanSize(after).padStart(9)}  (-${percent(before, after)})`,
    );
  } catch (error) {
    console.log(
      `  ${image.name.padEnd(nameWidth)}  failed: ${(error as Error).message}`,
    );
  }
}

console.log(
  `\nTotal  ${humanSize(totalBefore)} -> ${humanSize(totalAfter)}  (saved ${humanSize(totalBefore - totalAfter)}, -${percent(totalBefore, totalAfter)})`,
);
