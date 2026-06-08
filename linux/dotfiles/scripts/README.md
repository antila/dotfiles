# scripts

Personal CLI scripts written in TypeScript. Each `*.ts` file in `bin/` is
symlinked into `~/.local/bin` (already on `$PATH`) without its extension, so it
becomes a global command.

Node (v23.6+) runs TypeScript directly via type-stripping, so there is no build
step — just keep the syntax erasable (no `enum`/`namespace`; use plain type
annotations and `import type`).

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
