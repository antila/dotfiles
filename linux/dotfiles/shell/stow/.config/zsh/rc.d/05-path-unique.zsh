# Keep $path deduplicated for the rest of startup: first occurrence wins, so
# precedence is whatever the earliest fragment asked for. Saves every later
# fragment from having to guard its own PATH append.
typeset -U path PATH
