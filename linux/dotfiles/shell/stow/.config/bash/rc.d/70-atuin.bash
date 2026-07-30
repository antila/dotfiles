[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh

[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"

# Left off deliberately: bash is not the login shell, and the atuin widget
# fights with bash-preexec here. Enable if bash ever becomes the daily driver.
# eval "$(atuin init bash)"
