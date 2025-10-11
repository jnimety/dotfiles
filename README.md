# dotfiles

The dotfiles we use when pairing.

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

## Updates

```
cd ~/.dotfiles
git pull
git submodule update
stow .
```
