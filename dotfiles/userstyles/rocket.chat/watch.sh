while inotifywait -r styles.less; do
    lessc styles.less styles.css;
done
