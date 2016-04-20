### Docker ############################################################
if test ! $(which docker)
then
    echo "Installing docker"
    echo "deb http://http.debian.net/debian jessie-backports main" | sudo tee /etc/apt/sources.list.d/docker.list
    sudo apt-get update
    sudo aptitude -t jessie-backports install docker.io

    sudo docker login docker.chas.se
    sudo docker pull docker.chas.se/oden
    # sudo docker run --name=oden-dev -d -t -p 443:443 docker.chas.se/oden
fi


### SmartCard ##########################################################

# Grab new one
gpg2 --recv-keys 0A361939
gpgkey2ssh 700C8678 >> /home/aantila/.ssh/authorized_keys

# ... and add a comment
sed -i.bak s/COMMENT/"anders@antila.se-yubikey"/g /home/aantila/.ssh/authorized_keys
