#!/usr/bin/env zx

try {
  await $`which gpgsm`;
} catch {
  await $`sudo apt-get install -y gpgsm gnupg-agent pcscd`;
}

if (!(await fs.pathExists('/etc/udev/rules.d/70-yubikey.rules'))) {
  await $`sudo cp ./dotfiles/smartcard/70-yubikey.rules /etc/udev/rules.d`;

  await fs.ensureDir(`${process.env.HOME}/.gnupg`);
  await fs.appendFile(`${process.env.HOME}/.gnupg/gpg.conf`, 'use-agent\n');
  await fs.appendFile(
    `${process.env.HOME}/.gnupg/gpg-agent.conf`,
    'enable-ssh-support\n',
  );
}
