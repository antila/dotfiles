import { $, chalk, fs, path } from 'zx';
import { fileURLToPath } from 'url';

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
export function fail(message) {
  console.error(`\r  [${chalk.red('FAIL')}] ${message}`);
  process.exit(1);
}

export function isRoot() {
  return typeof process.getuid === 'function' && process.getuid() === 0;
}

/** @param {string} command */
export async function commandExists(command) {
  try {
    await $`which ${command}`;
    return true;
  } catch {
    return false;
  }
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
    info(` - Checking: ${src}`);
    try {
      await $`stow --dir=${path.join(src, '..')} --target=${process.env.HOME} stow`;
    } catch {}
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

  if (!(await fs.pathExists('.auto-install-apt'))) {
    return;
  }

  const content = await fs.readFile('.auto-install-apt', 'utf8');
  /** @type {string[]} */
  const packages = parsePackageList(content);

  for (const pkg of packages) {
    let installed = false;
    try {
      const result = await $`dpkg-query -W -f=${'${Status}'} ${pkg}`;
      installed = result.stdout.includes('ok installed');
    } catch {
      installed = false;
    }

    if (!installed) {
      info(`  Installing ${pkg}`);
      await $`sudo apt-get install ${pkg}`;
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
  if (!(await commandExists('brew'))) {
    console.log('  Installing brew');
    await $`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`;
    setBrewPath();
  }

  info('Installing homebrew stuff:');

  if (!(await fs.pathExists('.auto-install-brew'))) {
    return;
  }

  const content = await fs.readFile('.auto-install-brew', 'utf8');
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
