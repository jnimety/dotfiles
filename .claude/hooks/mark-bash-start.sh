#!/bin/bash
# PreToolUse hook for Bash: record when the command started so
# format-md-after-bash.sh can tell which markdown files it changed.
# The marker lives in a per-user 0700 directory rather than a
# predictable world-writable /tmp path.

PATH="/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:$PATH"

session_id=$(jq -r '.session_id // empty')
case "$session_id" in
  ''|*[!A-Za-z0-9-]*) exit 0 ;;
esac

dir="${TMPDIR:-/tmp}/claude-hooks-$(id -u)"
(umask 077 && mkdir -p "$dir") || exit 0
: > "$dir/bash-start-$session_id" 2>/dev/null
exit 0
