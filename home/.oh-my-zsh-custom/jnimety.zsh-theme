# ZSH Theme - Preview: http://gyazo.com/8becc8a7ed5ab54a0262a470555c3eed.png
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="›%{$reset_color%} "
ZSH_THEME_TF_PROMPT_PREFIX="%{$fg[red]%}‹terraform@"
ZSH_THEME_TF_PROMPT_SUFFIX="›%{$reset_color%} "

function findconfig() {
  # from: https://www.npmjs.com/package/find-config#algorithm
  # 1. If X/file.ext exists and is a regular file, return it. STOP
  # 2. If X has a parent directory, change X to parent. GO TO 1
  # 3. Return NULL.

  if [ -f "$1" ]; then
    printf '%s\n' "${PWD%/}/$1"
  elif [ "$PWD" = / ]; then
    false
  else
    # a subshell so that we don't affect the caller's $PWD
    (cd .. && findconfig "$1")
  fi
}

function rvm_prompt_info() {
  hash rvm-prompt 2>/dev/null || return
  findconfig Gemfile >/dev/null || return

  echo "%{$fg[red]%}‹$(rvm-prompt s i v p g)›%{$reset_color%} "
}

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

local user_host='%{$terminfo[bold]$fg[green]%}%n@%m%{$reset_color%}'
local current_dir='%{$terminfo[bold]$fg[blue]%} %~%{$reset_color%}'
local git_branch='$(git_prompt_info)'
local ruby_version='$(rvm_prompt_info)'
local terraform_workspace='$(tf_prompt_info)'

PROMPT="╭ ${user_host} ${current_dir} ${terraform_workspace}${ruby_version}${git_branch}\$BUNDLE_GEMFILE
╰ %B$%b "
