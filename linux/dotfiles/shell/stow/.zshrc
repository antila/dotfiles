# .zshrc
#
# This file is only a loader. Real config lives in ~/.config/zsh/rc.d/*.zsh,
# one fragment per concern, sourced in filename order. The numeric prefix is
# the ordering contract -- a few fragments genuinely care where they land
# (see 70-sdkman, 75-yarn, 99-honeymux).
#
# Every fragment is timed; 95-timing-report prints the breakdown when startup
# crosses 200ms.

zmodload zsh/datetime

typeset -gF _zsh_init_start=$EPOCHREALTIME
typeset -ga _zsh_init_log=()

for _zsh_rc_fragment in ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/rc.d/*.zsh(N); do
  typeset -F _zsh_rc_fragment_start=$EPOCHREALTIME
  source "$_zsh_rc_fragment"
  _zsh_init_log+=("$(printf '[zsh-init] %-26s %8.2f ms' "${_zsh_rc_fragment:t:r}" \
    $(( (EPOCHREALTIME - _zsh_rc_fragment_start) * 1000 )))")
done

unset _zsh_rc_fragment _zsh_rc_fragment_start _zsh_init_log
