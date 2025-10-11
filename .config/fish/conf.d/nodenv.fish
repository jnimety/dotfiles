# Load nodenv automatically by appending
# the following to ~/.config/fish/config.fish:

status --is-interactive; and source (nodenv init -|psub)
