

#!/usr/bin/fish

if ! type -q navi
  # https://github.com/denisidoro/navi
  echo "  Installing navi"
  curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install | bash
  fish_add_path /home/$USER/.cargo/bin

end
