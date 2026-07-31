import { fileURLToPath } from 'node:url';
import { $, chalk, fs, path } from 'zx';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export const ROOT_DIR = path.resolve(__dirname, '..');

/** @param {string} message */
export function info(message) {
  console.log(`  [ ${chalk.blue('..')} ] ${message}`);
}

/** @param {string} message */
export function user(message) {
  process.stdout.write(`\r  [ ${chalk.yellow('?')} ] ${message} `);
}

/** @param {string} message */
export function success(message) {
  console.log(`\r  [ ${chalk.green('OK')} ] ${message}`);
}

/** @param {string} message */
export function fail(message, exit = true) {
  console.error(`\r  [${chalk.red('FAIL')}] ${message}`);
  if (exit) {
    process.exit(1);
  }
}

export function isRoot() {
  return typeof process.getuid === 'function' && process.getuid() === 0;
}

/** @param {string} command */
export async function resolveCommand(command, extraCandidates = []) {
  const home = process.env.HOME || '';
  const candidates = [
    command,
    home ? `${home}/.local/bin/${command}` : '',
    home ? `${home}/.cargo/bin/${command}` : '',
    ...extraCandidates,
  ].filter(Boolean);

  for (const candidate of candidates) {
    try {
      await $`command -v ${candidate}`;
      return candidate;
    } catch {
      // Try next location.
    }

    if (candidate.includes('/') && (await fs.pathExists(candidate))) {
      return candidate;
    }
  }

  return null;
}

/** @param {string} command */
export async function commandExists(command) {
  return !!(await resolveCommand(command));
}

/** @param {string} target */
async function pointsIntoRepo(target) {
  const link = await fs.readlink(target).catch(() => null);
  if (link === null) {
    return false;
  }

  const resolved = path.resolve(path.dirname(target), link);
  return resolved.startsWith(`${ROOT_DIR}${path.sep}`);
}

/** @param {string} dir */
async function hasSubdirectory(dir) {
  const entries = await fs.readdir(dir, { withFileTypes: true });
  return entries.some((entry) => entry.isDirectory());
}

/**
 * Set $HOME up so stow folds at the deepest level: a directory that holds
 * further subdirectories has to exist for real, otherwise stow symlinks it
 * whole and ~/.config ends up pointing into this repo. Leaf directories are
 * left missing on purpose so stow links each of them as a single symlink.
 *
 * @param {string} stowDir
 */
async function prepareTarget(stowDir) {
  /** @param {string} currentDir @param {string} prefix */
  async function walk(currentDir, prefix = '') {
    const entries = await fs.readdir(currentDir, { withFileTypes: true });

    for (const entry of entries) {
      const relativePath = path.join(prefix, entry.name);
      const absolutePath = path.join(currentDir, entry.name);
      const target = path.join(process.env.HOME, relativePath);
      const stat = await fs.lstat(target).catch(() => null);

      if (entry.isDirectory()) {
        if (await hasSubdirectory(absolutePath)) {
          // Shared parent such as ~/.config: keep it a real directory.
          if (stat?.isSymbolicLink() && (await pointsIntoRepo(target))) {
            info(`   - Unfolding directory symlink: ${target}`);
            await fs.remove(target);
          }
          await fs.mkdirp(target);
          await walk(absolutePath, relativePath);
        } else if (stat && !stat.isSymbolicLink()) {
          // A real directory blocks folding. Clear out any links we own, and
          // if that empties it, drop it so stow can fold it into one symlink.
          // Anything else living there, e.g. ~/.claude, keeps it a real
          // directory and stow links the individual files instead.
          await walk(absolutePath, relativePath);

          if ((await fs.readdir(target)).length === 0) {
            info(`   - Folding directory: ${target}`);
            await fs.remove(target);
          }
        }

        continue;
      }

      if (!stat) {
        continue;
      }

      if (stat.isSymbolicLink()) {
        await fs.remove(target);
      } else {
        // Move it aside rather than --adopt it: adopting would overwrite the
        // tracked copy in this repo with whatever happens to be in $HOME.
        info(`   - Backing up existing file: ${target} -> ${target}.bak`);
        await fs.move(target, `${target}.bak`, { overwrite: true });
      }
    }
  }

  await walk(stowDir);
}

export async function install_dotfiles() {
  info('Installing dotfiles:');

  const output =
    await $`find dotfiles/ -maxdepth 2 -path ./system -prune -o -name stow -print`;
  /** @type {string[]} */
  const sources = String(output.stdout)
    .split('\n')
    .map((line) => line.trim())
    .filter(Boolean);

  for (const src of sources) {
    const stowDir = path.join(src);
    info(` - Checking: ${stowDir}`);

    await prepareTarget(stowDir);

    try {
      await $`stow --restow --dir=${path.join(src, '..')} --target=${process.env.HOME} stow`;
    } catch {
      fail(`   - Conflicts while stowing ${stowDir}, skipping`, false);
    }
  }
}

export async function run_installers(folder) {
  info('Installing stuff:');

  const output = await $`find dotfiles/ -name install.mjs`;
  /** @type {string[]} */
  const installers = String(output.stdout)
    .split('\n')
    .map((line) => line.trim())
    .filter(Boolean);

  for (const installer of installers) {
    const file = path.join(ROOT_DIR, folder, installer);
    info(` - ${installer}`);
    await import(file);
  }
}

/** @param {string} content */
function parsePackageList(content) {
  return content
    .split('\n')
    .map((line) => line.replace(/#.*/, '').trim())
    .filter(Boolean);
}

export async function install_aptitude_stuff() {
  info('Installing apt stuff:');

  if (!(await fs.pathExists('apt-packages.txt'))) {
    return;
  }

  const content = await fs.readFile('apt-packages.txt', 'utf8');
  /** @type {string[]} */
  const packages = parsePackageList(content);
  const dpkgStatusFormat = '$' + '{Status}';

  for (const pkg of packages) {
    let installed = false;
    try {
      const result = await $`dpkg-query -W -f=${dpkgStatusFormat} ${pkg}`;
      installed = result.stdout.includes('ok installed');
    } catch {
      installed = false;
    }

    if (!installed) {
      info(`  Installing ${pkg}`);
      try {
        await $`sudo apt-get install -y ${pkg}`;
      } catch {
        fail(`  ${pkg} not available, skipping`, false);
      }
    } else {
      success(`- ${pkg} already installed`);
    }
  }
}

function setBrewPath() {
  const linuxbrew = '/home/linuxbrew/.linuxbrew/bin';
  if (!process.env.PATH?.includes(linuxbrew)) {
    process.env.PATH = `${linuxbrew}:${process.env.PATH ?? ''}`;
  }
}

export async function install_homebrew_stuff() {
  setBrewPath();

  if (!(await commandExists('brew'))) {
    console.log('  Installing brew');
    await $`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`;
  }

  info('Installing homebrew stuff:');

  if (!(await fs.pathExists('brew-packages.txt'))) {
    return;
  }

  const content = await fs.readFile('brew-packages.txt', 'utf8');
  /** @type {string[]} */
  const packages = parsePackageList(content);

  for (const pkg of packages) {
    try {
      await $`brew list ${pkg}`;
      console.log(`${pkg} is already installed`);
    } catch {
      await $`brew install ${pkg}`;
      console.log(`${pkg} is installed`);
    }
  }
}
