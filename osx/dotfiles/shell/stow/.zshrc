# .zshrc

#colors in terminal commands like ls
export CLICOLOR=1

alias ls='eza -lah --icons --group-directories-first'

# starship prompt
eval "$(starship init zsh)"

# proper history
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=1000
setopt SHARE_HISTORY

# NVM stuff
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

source ~/.zshrc_secrets

# nicer shell history
PATH=$PATH:~/.atuin/bin
eval "$(atuin init zsh)"
. "$HOME/.atuin/bin/env"
