# dotfiles

## Prerequisites

- git
- GNU Stow

## Setup

```
git clone https://github.com/jnimety/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git submodule init
git submodule update
```

These dotfiles assume you have the following installed:

- nodenv (fish)
- rbenv (fish)
- rust/cargo (nvim)
- starship (fish)
- tree-sitter-cli (nvim)
- npm (nvim)
- ripgrep (nvim)
- fzf (fish, nvim)
- jq (hyprland bind)

## Installation

`cd ~/.dotfiles && stow .`

## Post Installation

Update `~/.gitconfig.d/user`

```
[user]
  name = [YOUR NAME HERE]
  email = [YOUR EMAIL HERE]
```

Install tmux plugins, see https://github.com/tmux-plugins/tpm?tab=readme-ov-file#key-bindings

```
tmux
CTRL-a I # The initial install takes a few seconds, be patient
```

Install your fish theme

```
fish_config theme choose tokyonight_night
fish_config theme save
```

## Updates

```
cd ~/.dotfiles
git pull
git submodule update
stow --verbose .
```

## Useful Commands

Ghostty Terminfo - If xterm-ghostty isn't available yet in your version of ncurses:

```
# Install system-wide (/etc/terminfo or /usr/share/terminfo)
infocmp -x xterm-ghostty | sudo tic -x -

# Install to ~/.terminfo on remote
infocmp -x xterm-ghostty | ssh YOUR-SERVER -- tic -x -

# Install system-wide on remote (/etc/terminfo or /usr/share/terminfo)
# If sudo requires a password I don't think this will work
infocmp -x xterm-ghostty | ssh YOUR-SERVER -- sudo tic -x -
```
