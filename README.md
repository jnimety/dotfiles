# dotfiles

The dotfiles we use when pairing.

## Prerequisites

- git
- GNU Stow

## Setup

```
git clone git@github.com:jnimety/dotfiles.git ~/.dotfiles
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

Install tmux plugins

```
tmux
CTRL-a I
```

## Updates

`cd ~/.dotfiles && git pull && git submodule update && stow .`
