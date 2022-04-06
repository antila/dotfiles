#!/usr/bin/fish

if ! type -q fisher
  echo "  Installing fisher" 
  curl -sL https://git.io/fisher | source
  fisher install jorgebucaran/fisher

  # The ultimate Fish prompt
  # https://github.com/IlanCosman/tide
  fisher install IlanCosman/tide@v5

  # https://github.com/jethrokuan/z
  fisher install jethrokuan/z

  # A fish shell package to automatically receive notifications when long processes finish.
  # https://github.com/franciscolourenco/done
  fisher install franciscolourenco/done

  # Sponge quietly runs in the background and keeps your shell history clean from typos
  # https://github.com/andreiborisov/sponge
  fisher install andreiborisov/sponge

  # Auto-complete matching (), [], {}, "", and '' in the Fish command line.
  # https://github.com/jorgebucaran/autopair.fish
  fisher install jorgebucaran/autopair.fish

  # Node.js version manager
  # https://github.com/jorgebucaran/nvm.fish
  fisher install jorgebucaran/nvm.fish

  # mnemonic key bindings
  # https://github.com/PatrickF1/fzf.fish
  fisher install PatrickF1/fzf.fish
end
