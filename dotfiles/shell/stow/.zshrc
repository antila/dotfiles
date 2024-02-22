# .zshrc

alias ls='exa -l --group-directories-first'
alias vim='nvim'

# starship prompt
eval "$(starship init zsh)"

# proper history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=1000
setopt SHARE_HISTORY

# direnv for .env files
eval "$(direnv hook zsh)"

# https://stackoverflow.com/a/21163306
# Set window title to command just before running it.
preexec() {
    FOLDER=${PWD/\/home\/anders/"~"}
    printf "\x1b]0;%s\x07" "$FOLDER/$1";
}
# Set window title to current working directory after returning from a command.
precmd() {
    FOLDER=${PWD/\/home\/anders/"~"}
    printf "\x1b]0;%s\x07" "$FOLDER"
}

PATH=$PATH:~/.cargo/bin/navi
PATH=$PATH:~/.local/bin/bat
export PATH="$(yarn global bin):$PATH"

# function to set terminal title
function set-title(){
  if [[ -z "$ORIG" ]]; then
    ORIG=$PS1
  fi
  TITLE="\[\e]2;$*\a\]"
  PS1=${ORIG}${TITLE}
}

# NVM stuff
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

autoload -U add-zsh-hook
load-nvmrc() {
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
# end NVM

# https://askubuntu.com/questions/1265217/how-to-start-new-tilix-session-with-a-same-directory-as-the-previous-session
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  source /etc/profile.d/vte-2.91.sh
fi

