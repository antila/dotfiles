# On interactive login, hand the terminal to tmux: `new-session -A` attaches to
# the `main` session if it exists and creates it otherwise, so every terminal
# lands in the same session instead of piling up new ones.
#
#   -z "$TMUX"   already inside tmux; tmux refuses to nest.
#   -t 0         no controlling tty (scp, `ssh host cmd`, editors sourcing the
#                rc file); tmux needs a terminal to attach to.
#
# Must stay last: tmux takes over the terminal, so later fragments would not run.
if [[ -o interactive && -z "$TMUX" && -t 0 ]] \
  && command -v tmux >/dev/null 2>&1; then
  tmux new-session -A -s main
fi
