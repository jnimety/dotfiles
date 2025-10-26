#!/usr/bin/env bash

function toggle() {
  floating=$(hyprctl activewindow -j | jq '.floating')

  if [ "$floating" == "false" ]; then
    hyprctl --batch "dispatch togglefloating; dispatch resizeactive exact ${width} ${height}; dispatch centerwindow"
  else
    hyprctl dispatch togglefloating
  fi
}

width=${1:-90%}
height=${2:-90%}

toggle "$1" "$2"
