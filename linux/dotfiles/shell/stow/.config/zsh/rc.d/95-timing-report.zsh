# Report the startup timings collected by .zshrc. The total always gets a line
# -- it's the number worth watching, and a silent report is indistinguishable
# from a broken one. The per-fragment breakdown only earns its space once
# startup crosses 200ms, which is where it stops being fast enough to ignore.
typeset -gF _zsh_init_total_ms=$(( (EPOCHREALTIME - _zsh_init_start) * 1000 ))
if (( _zsh_init_total_ms >= 200 )); then
  printf '%s\n' "${_zsh_init_log[@]}"
fi
printf '[zsh-init] %-26s %8.2f ms\n' 'total startup' "$_zsh_init_total_ms"
