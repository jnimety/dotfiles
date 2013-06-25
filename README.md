    setopt interactivecomments

    # install rvm and compile ruby 1.9.2
    bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
    if [[ -s ~/.rvm/scripts/rvm ]] ; then source ~/.rvm/scripts/rvm ; fi
    rvm get head
    rvm reload
    rvm install 1.9.2
    rvm use 1.9.2 --default

    # Clone dotfiles
    gem install homesick
    for x in ContinuityControl/dotfiles benjaminoakes/homesick-vi-everywhere jnimety/dotfiles
    do
      homesick clone $x
      homesick symlink $x
    done

    # install oh-my-zsh
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
