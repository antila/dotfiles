# SmartCard ##########################################################

# Grab new one
# gpg2 --recv-keys 0A361939
# gpgkey2ssh 700C8678 >> /home/aantila/.ssh/authorized_keys

# ... and add a comment
# sed -i.bak s/COMMENT/"anders@antila.se-yubikey"/g /home/aantila/.ssh/authorized_keys

# Video
# sudo apt-get install nvidia-detect nvidia-driver

# YOLO
# sudo sed -i -e 's/ \(stable\|jessie\)/ testing/ig' /etc/apt/sources.list
# sudo sed -i -e 's/ \(testing \)/ testing contrib non-free/ig' /etc/apt/sources.list
# apt-get update
# apt-get --download-only dist-upgrade
# apt-get dist-upgrade

# xset dpms force off
# chsh -s /bin/zsh
