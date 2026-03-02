#!/bin/sh

if test ! $(which gpgsm)
then
  sudo apt-get install -y gpgsm gnupg-agent pcscd
fi

if [ ! -f "/etc/udev/rules.d/70-yubikey.rules" ]; then
  sudo cp ./dotfiles/smartcard/70-yubikey.rules /etc/udev/rules.d

  echo "use-agent" >> ~/.gnupg/gpg.conf
  echo "enable-ssh-support" >> ~/.gnupg/gpg-agent.conf
fi


