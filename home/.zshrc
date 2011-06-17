# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
export ZSH_THEME="jnimety"

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git rails3 ruby osx gem vi-mode brew)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

alias ss='ruby script/server thin'
alias sd='ruby script/server thin --debugger'

alias gl='git pull --rebase -p'

# User specific environment and startup programs

export PATH=$PATH:$HOME/bin

export HISTCONTROL=ignoredups

# Setup Amazon EC2 Command-Line Tools
export EC2_HOME=~/.ec2
export PATH=$PATH:$EC2_HOME/bin
export EC2_PRIVATE_KEY="$(ls $EC2_HOME/pk-*.pem)"
export EC2_CERT="$(ls $EC2_HOME/cert-*.pem)"
export EC2_AMITOOL_HOME=${EC2_HOME}/ec2-ami-tools-1.3-31780

export JAVA_HOME="/Library/Java/Home/"
export AWS_IAM_HOME="/usr/local/Cellar/aws-iam-tools/HEAD/jars"
export AWS_CREDENTIAL_FILE=$HOME/.aws-credentials-master
export AWS_RDS_HOME="/usr/local/Cellar/rds-command-line-tools/1.3.003/jars"

export PATH=$PATH:${EC2_AMITOOL_HOME}/bin

#if [ -f "${HOME}/.gpg-agent-info" ]; then
#  . "${HOME}/.gpg-agent-info"
#  export GPG_AGENT_INFO
#  export SSH_AUTH_SOCK
#  export SSH_AGENT_PID
#fi

# UTF-8
#######
export LANG=en_US.UTF-8
export LOCALE=UTF-8
export LESSCHARSET='utf-8'

export GPG_TTY=`tty`

# Ruby Tuning
export RUBY_HEAP_MIN_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_HEAP_FREE_MIN=500000
export RUBY_FREE_MIN=$RUBY_HEAP_FREE_MIN

# iTerm Tab and Title Customization and prompt customization
# Put the string " [bash]   hostname::/full/directory/path"
# in the title bar using the command sequence
# \[\e]2;[bash]   \h::\]$PWD\[\a\]
# Put the penultimate and current directory
# in the iterm tab
# \[\e]1;\]$(basename $(dirname $PWD))/\W\[\a\]

#alias timestamp='date +"%Y%m%d%H%M%S"'
[[ -e `which gls` ]] && alias ls='gls --color=auto'
[[ -e `which gtar` ]] && alias tar='gtar'
[[ -e `which gseq` ]] && alias seq='gseq'
unset GREP_OPTIONS # .oh-my-zsh options conflict with homebrew/cmake

#disable ctrl-s/suspension
stty stop undef
setopt NO_FLOW_CONTROL
setopt magicequalsubst
bindkey '^R' history-incremental-search-backward
autoload -U zrecompile

__rvm_project_rvmrc
