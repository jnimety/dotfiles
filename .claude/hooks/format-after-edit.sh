#!/bin/bash
# PostToolUse hook for Write|Edit: format the touched file with its
# language formatter. Failures are ignored so a formatter problem never
# blocks an edit.

PATH="/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:$PATH"

run() {
  if [ -x /opt/homebrew/bin/timeout ]; then
    /opt/homebrew/bin/timeout 30 "$@"
  else
    "$@"
  fi
}

f=$(jq -r '.tool_input.file_path // .tool_response.filePath // empty')
[ -n "$f" ] && [ -f "$f" ] || exit 0

mason="$HOME/.local/share/nvim/mason/bin"

case "$f" in
  *.md)
    tmp=$(mktemp) || exit 0
    # shellcheck disable=SC2094 # output goes to $tmp, not back into $f
    if run "$mason/prettierd" --stdin-filepath "$f" < "$f" > "$tmp" 2>/dev/null && [ -s "$tmp" ]; then
      cmp -s "$tmp" "$f" || cat "$tmp" > "$f"
    fi
    rm -f "$tmp"
    ;;
  *.sql) run "$mason/sql-formatter" --fix "$f" ;;
  *.tf|*.tfvars) run /opt/homebrew/bin/terraform fmt "$f" ;;
  *.yml|*.yaml) run "$mason/yamlfmt" "$f" ;;
esac >/dev/null 2>&1

exit 0
