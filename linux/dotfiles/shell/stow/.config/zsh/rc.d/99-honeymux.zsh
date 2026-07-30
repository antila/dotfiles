# On interactive login, if a honeymux/tmux session is already running, attach via hmx.
# Skip when already inside tmux to avoid nesting.
# Must stay last: hmx takes over the terminal, so later fragments would not run.
if [[ -o interactive && -z "$TMUX" ]] && command -v hmx >/dev/null 2>&1 && tmux list-sessions >/dev/null 2>&1; then
  hmx
fi
