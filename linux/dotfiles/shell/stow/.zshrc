# .zshrc

zmodload zsh/datetime
typeset -gF _zsh_init_start=$EPOCHREALTIME

profile_step() {
  local label="$1"
  shift
  local -F start=$EPOCHREALTIME
  "$@"
  local exit_code=$?
  local -F elapsed_ms=$(( (EPOCHREALTIME - start) * 1000 ))
  printf '[zsh-init] %-26s %8.2f ms\n' "$label" "$elapsed_ms"
  return $exit_code
}

profile_eval_output() {
  local label="$1"
  shift
  local -F start=$EPOCHREALTIME
  eval "$("$@")"
  local exit_code=$?
  local -F elapsed_ms=$(( (EPOCHREALTIME - start) * 1000 ))
  printf '[zsh-init] %-26s %8.2f ms\n' "$label" "$elapsed_ms"
  return $exit_code
}

profile_source_if_exists() {
  local label="$1"
  local file="$2"
  if [[ -s "$file" ]]; then
    profile_step "$label" source "$file"
  fi
}

export LANG="en_US.utf8"
export LANGUAGE="en_US.utf8"
export LC_ALL="en_US.utf8"

alias ls='exa -l --group-directories-first'
alias vim='nvim'

# starship prompt
profile_eval_output "starship init" starship init zsh

# proper history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=1000
setopt SHARE_HISTORY

# direnv for .env files
profile_eval_output "direnv hook" direnv hook zsh

PATH=$PATH:~/.cargo/bin/navi
PATH=$PATH:~/.local/bin/bat
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

profile_step "zshrc secrets" source ~/.zshrc_secrets

profile_eval_output "atuin init" atuin init zsh

profile_eval_output "brew shellenv" /home/linuxbrew/.linuxbrew/bin/brew shellenv zsh

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
  profile_eval_output "fnm env" fnm env --shell zsh
fi

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

typeset -gF _zsh_init_total_ms=$(( (EPOCHREALTIME - _zsh_init_start) * 1000 ))
printf '[zsh-init] %-26s %8.2f ms\n' 'total startup' "$_zsh_init_total_ms"

