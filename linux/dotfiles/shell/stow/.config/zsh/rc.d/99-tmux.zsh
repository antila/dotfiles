# On interactive login, report any running tmux session instead of attaching to
# it. Attaching is a deliberate act: run `tmux attach` when you want it.
#
#   -z "$TMUX"   already inside tmux; the status bar already says this.
#   -t 0         no controlling tty (scp, `ssh host cmd`, editors sourcing the
#                rc file); nothing there wants a stray line on stdout.
if [[ -o interactive && -z "$TMUX" && -t 0 ]] \
  && command -v tmux >/dev/null 2>&1; then
  _tmux_panes=(${(f)"$(tmux list-panes -a -F '#{pane_id}' 2>/dev/null)"})
  _tmux_sessions=(${(f)"$(tmux list-sessions -F '#{session_name}' 2>/dev/null)"})

  if (( $#_tmux_panes )); then
    _tmux_pane_word=panes
    _tmux_session_word=sessions
    (( $#_tmux_panes == 1 )) && _tmux_pane_word=pane
    (( $#_tmux_sessions == 1 )) && _tmux_session_word=session

    print -r -- "tmux is running with $#_tmux_panes open $_tmux_pane_word in $#_tmux_sessions $_tmux_session_word -- attach with \`tmux attach\`"

    unset _tmux_pane_word _tmux_session_word
  fi

  unset _tmux_panes _tmux_sessions
fi
