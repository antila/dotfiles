if [[ -f ~/.zshrc_secrets ]]; then
  source ~/.zshrc_secrets;
else
  touch ~/.zshrc_secrets;
fi
