# .zshrc

zmodload zsh/datetime
typeset -gF _zsh_init_start=$EPOCHREALTIME

typeset -ga _zsh_init_log=()

start_timer() {
  typeset -g _timer_label="$1"
  typeset -gF _timer_start=$EPOCHREALTIME
}

end_timer() {
  local -F elapsed_ms=$(( (EPOCHREALTIME - _timer_start) * 1000 ))
  _zsh_init_log+=("$(printf '[zsh-init] %-26s %8.2f ms' "$_timer_label" "$elapsed_ms")")
}

export LANG="en_US.utf8"
export LANGUAGE="en_US.utf8"
export LC_ALL="en_US.utf8"

alias ls='exa -l --group-directories-first'
alias vim='nvim'

# starship prompt
start_timer "starship init"
eval "$(starship init zsh)"
end_timer

# proper history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=1000
setopt SHARE_HISTORY

# direnv for .env files
start_timer "direnv hook"
eval "$(direnv hook zsh)"
end_timer

PATH=$PATH:~/.cargo/bin/navi
PATH=$PATH:~/.local/bin/bat
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"


if [[ -f ~/.zshrc_secrets ]]; then 
  source ~/.zshrc_secrets; 
else 
  touch ~/.zshrc_secrets; 
fi

start_timer "atuin init"
export PATH="$HOME/.atuin/bin:$PATH"
eval "$(atuin init zsh)"
end_timer

start_timer "brew shellenv"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
end_timer

# pnpm
export PNPM_HOME="/home/anders/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# fnm
FNM_PATH="/home/anders/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  start_timer "fnm env"
  eval "$(fnm env --shell zsh)"
  end_timer
fi

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

typeset -gF _zsh_init_total_ms=$(( (EPOCHREALTIME - _zsh_init_start) * 1000 ))
if (( _zsh_init_total_ms >= 200 )); then
  printf '%s\n' "${_zsh_init_log[@]}"
  printf '[zsh-init] %-26s %8.2f ms\n' 'total startup' "$_zsh_init_total_ms"
fi
unset _zsh_init_log

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# filen-cli
PATH=$PATH:~/.filen-cli/bin

. "$HOME/.atuin/bin/env"

# On interactive login, if a honeymux/tmux session is already running, attach via hmx.
# Skip when already inside tmux to avoid nesting.
if [[ -o interactive && -z "$TMUX" ]] && command -v hmx >/dev/null 2>&1 && tmux list-sessions >/dev/null 2>&1; then
  hmx
fi
