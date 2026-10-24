#!/bin/bash
# PostToolUse hook for Bash: Claude often edits markdown through shell commands
# (python, sed), which the Write|Edit formatter hook never sees. Bash hook
# payloads don't list changed files, so find markdown in the current project
# that changed since the PreToolUse marker and format it with prettierd.

input=$(cat)
session_id=$(jq -r '.session_id // empty' <<<"$input")
cwd=$(jq -r '.cwd // empty' <<<"$input")
[ -n "$session_id" ] || exit 0
[ -n "$cwd" ] || cwd="$PWD"

dir="${TMPDIR:-/tmp}/claude-hooks-$(id -u)"
marker="$dir/bash-start-$session_id"
[ -f "$marker" ] || exit 0

prettierd="$HOME/.local/share/nvim/mason/bin/prettierd"
if [ ! -x "$prettierd" ]; then
  rm -f "$marker"
  exit 0
fi

root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
if [ -n "$root" ]; then
  # Only untracked or modified files in this repo: asking git is ~10x faster
  # than walking node_modules, vendor, and tmp.
  git -C "$root" ls-files -m -o --exclude-standard -z -- '*.md' 2>/dev/null |
    while IFS= read -r -d '' f; do printf '%s\0' "$root/$f"; done
else
  find "$cwd" -maxdepth 5 -name '*.md' \
    -not -path '*/node_modules/*' -not -path '*/.git/*' -print0 2>/dev/null
fi |
  xargs -0 -I{} find {} -maxdepth 0 -newer "$marker" -print0 2>/dev/null |
  while IFS= read -r -d '' f; do
    tmp=$(mktemp) || continue
    # shellcheck disable=SC2094 # output goes to $tmp, not back into $f
    if "$prettierd" --stdin-filepath "$f" < "$f" > "$tmp" 2>/dev/null && [ -s "$tmp" ]; then
      cmp -s "$tmp" "$f" || cat "$tmp" > "$f"
    fi
    rm -f "$tmp"
  done

rm -f "$marker"
exit 0
