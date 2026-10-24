#!/bin/bash
# PostToolUse hook for Write|Edit: run shellcheck on shell scripts it supports
# (sh, bash, dash, ksh, busybox sh) and report findings back to Claude.
# Exit 2 sends stderr to Claude; any other problem exits 0 so edits never block.

f=$(jq -r '.tool_input.file_path // .tool_response.filePath // empty')
[ -n "$f" ] && [ -f "$f" ] || exit 0

case "$f" in
  *.sh|*.bash|*.dash|*.ksh|*.bats) ;;
  *)
    shebang=$(head -c 128 "$f" | head -n 1)
    case "$shebang" in
      '#!'*/sh|'#!'*/sh\ *|'#!'*bash*|'#!'*dash*|'#!'*ksh*|'#!'*busybox*) ;;
      *) exit 0 ;;
    esac
    ;;
esac

shellcheck=/opt/homebrew/bin/shellcheck
[ -x "$shellcheck" ] || exit 0

if ! out=$("$shellcheck" --format=gcc --external-sources "$f" 2>&1); then
  printf 'shellcheck found issues in %s:\n%s\n' "$f" "$out" >&2
  exit 2
fi

exit 0
