# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
#
# This file is only a loader. Real config lives in ~/.config/bash/rc.d/*.bash,
# one fragment per concern, sourced in filename order.
#
# zsh is the login shell; this file mostly matters for scripts and for tools
# that shell out via `bash -lc`.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

for _bash_rc_fragment in "${XDG_CONFIG_HOME:-$HOME/.config}"/bash/rc.d/*.bash; do
    [ -r "$_bash_rc_fragment" ] && . "$_bash_rc_fragment"
done
unset _bash_rc_fragment

# ---------------------------------------------------------------------------
# Installers (rustup, pnpm, atuin, filen-cli, ...) append to this file without
# asking. Anything that shows up below is unsorted: move it into its own
# fragment above, then delete it from here.
# ---------------------------------------------------------------------------
