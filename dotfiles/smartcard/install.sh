#!/bin/sh

# if test ! $(which atom)
# then
  # echo "  Installing atom.io for you."
  # wget https://atom.io/download/deb -O /tmp/atom.deb
  # sudo dpkg -i /tmp/atom.deb
  # rm /tmp/atom.deb
# fi

sudo apt-get install -y gpgsm gnupg-agent pcscd

sudo cp 70-yubikey.rules /etc/udev/rules.d

echo "use-agent" >> ~/.gnupg/gpg.conf
echo "enable-ssh-support" >> ~/.gnupg/gpg-agent.conf
