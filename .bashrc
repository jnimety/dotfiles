# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# From /etc/profile
for i in $HOME/.bash/* ; do
  if [ -r "$i" ]; then
    if [ "${-#*i}" != "$-" ]; then
      . "$i"
    else
      . "$i" >/dev/null
    fi
  fi
done

export PATH="$HOME/.bin:$PATH"

# It might make more sense to have `vi -e` for `EDITOR`
export EDITOR="vi"
export PAGER="less"
export VISUAL="vi"

PATH=$PATH:/usr/local/rvm/bin # Add RVM to PATH for scripting

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
. "$HOME/.cargo/env"
