#!/usr/bin/env -S node

// Example CLI script. Drop a new `*.ts` file in this folder, re-run the
// installer, and the filename (without `.ts`) becomes a global command.

const name = process.argv[2] ?? 'world';
console.log(`hello, ${name}`);
