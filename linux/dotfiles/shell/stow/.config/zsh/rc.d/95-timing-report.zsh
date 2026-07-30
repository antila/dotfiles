# Print the per-fragment timings collected by .zshrc, but only when startup was slow.
typeset -gF _zsh_init_total_ms=$(( (EPOCHREALTIME - _zsh_init_start) * 1000 ))
if (( _zsh_init_total_ms >= 200 )); then
  printf '%s\n' "${_zsh_init_log[@]}"
  printf '[zsh-init] %-26s %8.2f ms\n' 'total startup' "$_zsh_init_total_ms"
fi
