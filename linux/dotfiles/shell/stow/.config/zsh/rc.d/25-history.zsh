# proper history
HISTFILE=~/.zsh_history
HISTSIZE=100000
# Keep SAVEHIST >= HISTSIZE: it is the cap on $HISTFILE, and zsh silently trims
# the file down to it on every rewrite. At the old 1000 the file sat permanently
# at its cap, so anything older than the last thousand commands was dropped.
SAVEHIST=100000

# Append each command to $HISTFILE as soon as it is entered rather than at exit
# (this implies INC_APPEND_HISTORY), so a dropped connection or a killed
# terminal cannot take the session's commands with it. Also re-imports what
# other shells have written.
setopt SHARE_HISTORY

# Sharing merges entries from other shells by timestamp, so write timestamps.
setopt EXTENDED_HISTORY

# Lock $HISTFILE with fcntl(2) while writing. A tmux full of shells appends to
# one file constantly, and unlocked concurrent rewrites lose entries.
setopt HIST_FCNTL_LOCK
