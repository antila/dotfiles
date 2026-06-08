# scripts

Personal CLI scripts written in TypeScript. Each `*.ts` file in `bin/` is
symlinked into `~/.local/bin` (already on `$PATH`) without its extension, so it
becomes a global command.

Node (v23.6+) runs TypeScript directly via type-stripping, so there is no build
step — just keep the syntax erasable (no `enum`/`namespace`; use plain type
annotations and `import type`).

## Commands

| Command          | Description                                                                                 |
| ---------------- | ------------------------------------------------------------------------------------------- |
| `hello`          | Example command that prints a greeting.                                                      |
| `optimize-images`| Previews images in the current folder, confirms, then optimizes them in place with `sharp` and reports per-file and total size reduction. Skips any file that would shrink less than 5%. |
| `png2jpg <file>` | Converts a PNG to a sibling `.jpg`, flattening transparency onto white.                      |
| `img2webp <file>`| Converts any image to a sibling `.webp`, preserving transparency.                            |
| `webp2img <file> [png\|jpg]` | Converts a WebP to a sibling image (`png` by default, keeping transparency; `jpg` flattens onto white). |

The image commands depend on `sharp`, declared in `bin/package.json` and
installed automatically by the installer.

## Add a new command

1. Create `bin/<name>.ts` starting with `#!/usr/bin/env -S node`.
2. Run the installer to link it:

   ```sh
   ./bin/hello.ts                # files are runnable directly too
   zx install.mjs                # or re-run the whole dotfiles installer
   ```

3. Use it anywhere as `<name>`.

The installer is idempotent — it (re)creates symlinks and marks scripts
executable, and skips any non-symlink already sitting in `~/.local/bin`.
