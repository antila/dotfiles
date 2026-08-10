#!/usr/bin/env zx

import { fileURLToPath } from 'node:url';
import { info } from '../../../common/functions.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const MOTD_DIR = '/etc/update-motd.d';
const SOURCE = path.join(__dirname, '20-sysinfo');
const TARGET = `${MOTD_DIR}/20-sysinfo`;
const UNAME = `${MOTD_DIR}/10-uname`;
const MOTD = '/etc/motd';
const MOTD_BACKUP = '/etc/motd.dpkg-orig';

// Debian drives the login banner through pam_motd, which re-runs
// /etc/update-motd.d on every login. No pam_motd, no place to put this.
if (!(await fs.pathExists(MOTD_DIR))) {
  info('    - No /etc/update-motd.d here, skipping MOTD stats');
} else {
  // Everything below needs root, so only reach for sudo when there is actually
  // something to change -- otherwise every install run prompts for a password.
  const wanted = await fs.readFile(SOURCE, 'utf8');
  const current = await fs.readFile(TARGET, 'utf8').catch(() => null);

  if (current === wanted) {
    info('    - MOTD stats already installed');
  } else {
    info('    - Installing MOTD stats');
    await $`sudo install -o root -g root -m 0755 ${SOURCE} ${TARGET}`;
  }

  // 20-sysinfo prints its own hostname/kernel header, so the stock uname line
  // is a duplicate. Drop the executable bit rather than the file: run-parts
  // skips it, and a chmod +x puts it back.
  if (await fs.pathExists(UNAME)) {
    const { mode } = await fs.stat(UNAME);
    if (mode & 0o111) {
      info('    - Disabling 10-uname, 20-sysinfo prints the kernel line');
      await $`sudo chmod a-x ${UNAME}`;
    }
  }

  // The static half of the banner is Debian's no-warranty boilerplate. Keep a
  // copy the first time, then empty it.
  const boilerplate = await fs.readFile(MOTD, 'utf8').catch(() => '');
  if (boilerplate.trim()) {
    if (!(await fs.pathExists(MOTD_BACKUP))) {
      await $`sudo cp -a ${MOTD} ${MOTD_BACKUP}`;
      info(`    - Saved the stock /etc/motd to ${MOTD_BACKUP}`);
    }
    info('    - Clearing the Debian boilerplate from /etc/motd');
    await $`sudo truncate -s 0 ${MOTD}`;
  }
}
