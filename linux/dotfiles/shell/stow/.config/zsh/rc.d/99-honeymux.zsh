# On interactive login, hand the terminal to honeymux: hmx attaches to the last
# session if one exists and creates a fresh one otherwise, so this fragment only
# decides *whether* to launch it, never which session to use.
#
#   -z "$TMUX"   already inside tmux; hmx is an outer TUI and refuses to nest.
#   pgrep hmx    honeymux holds a single global lock, so a second instance would
#                stop at a "Take over? [Y/n]" prompt and steal the session from
#                the terminal that already has it. Let extra terminals stay bare.
#
# Note this deliberately does not probe tmux for a session: hmx runs its own tmux
# server on the `honeymux` socket, so a plain `tmux list-sessions` looks at the
# default socket and answers about the wrong server.
#
# Must stay last: hmx takes over the terminal, so later fragments would not run.
if [[ -o interactive && -z "$TMUX" ]] \
  && command -v hmx >/dev/null 2>&1 \
  && ! pgrep -u "$UID" -x hmx >/dev/null 2>&1; then
  hmx
fi
