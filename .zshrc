export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="$PATH:$HOME/.bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

export PAGER="less -sR"
export VISUAL=nvim
export EDITOR=$VISUAL
export GIT_EDITOR=$VISUAL
export LANG=en_US.UTF-8
export LOCALE=UTF-8
export LC_ALL=en_US.UTF-8
export LC_COLLATE=en_US.UTF-8
# set -Ux MANPAGER "sh -c 'col -bx | bat --language man --plain'"
export MANPAGER="nvim +Man!"
export MANCOLOR=1

export LESSCHARSET='utf-8'

VI_MODE_SET_CURSOR=true

#disable ctrl-s/suspension
stty stop undef
setopt NO_FLOW_CONTROL
setopt magicequalsubst
setopt interactivecomments
bindkey '^R' history-incremental-search-backward
autoload -U zrecompile

# Allow for local environment configuration in ~/.zsh/*.zsh
if [ -d $HOME/.config/zsh ]; then
  for config_file ($HOME/.config/zsh/*.zsh); do
    source $config_file
  done
fi
