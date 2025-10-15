# Set up fzf key bindings and fuzzy completion

export FZF_DEFAULT_OPTS='
  --cycle --layout=reverse --border --height=90%
  --preview-window=wrap --marker="*"'

export FZF_COMPLETION_OPTS=''
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target,sorbet
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# https://github.com/folke/tokyonight.nvim/blob/main/extras/fzf/tokyonight_night.sh
export FZF_COMPLETION_OPTS="$FZF_COMPLETION_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=thinblock \
  --color=bg+:#283457 \
  --color=bg:#16161e \
  --color=border:#16161e \
  --color=fg:#c0caf5 \
  --color=gutter:#16161e \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#27a1b9 \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"

source <(fzf --zsh)
