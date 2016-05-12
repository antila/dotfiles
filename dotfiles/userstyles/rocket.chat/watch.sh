# sudo npm install -g less
# sudo apt-get install inotify-tools

while inotifywait -r styles.less; do
    lessc styles.less styles.css;
done
