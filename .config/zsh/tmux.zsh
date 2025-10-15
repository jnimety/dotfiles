# Prevent warnings if the user has not set up a tmux user.conf file
if [ ! -f "$HOME/.config/tmux/user.conf" ]; then
  touch $HOME/.config/tmux/user.conf
fi
