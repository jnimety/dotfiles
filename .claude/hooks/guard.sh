#!/bin/bash
# PreToolUse guard for Claude Code.
#
# Defense in depth for the layers the sandbox cannot see: Claude's own
# Read/Edit/Write tools, MCP servers, and any Bash invocation that a
# permission rule does not match. The sandbox still enforces the same
# paths at the OS level for shell commands.
#
# Denials are logged to ~/.claude/audit.jsonl.
# Set CLAUDE_ALLOW_CONFIG_EDIT=1 to allow editing Claude/shell config.

input=$(cat)
tool=$(jq -r '.tool_name // empty' <<<"$input" 2>/dev/null) || exit 0
[ -n "$tool" ] || exit 0

allow_config_edit="${CLAUDE_ALLOW_CONFIG_EDIT:-0}"

log() {
  local decision=$1 reason=$2
  mkdir -p "$HOME/.claude" 2>/dev/null
  (umask 077; jq -cn \
    --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    --arg tool "$tool" \
    --arg decision "$decision" \
    --arg reason "$reason" \
    '{ts:$ts,tool:$tool,decision:$decision,reason:$reason}' \
    >> "$HOME/.claude/audit.jsonl" 2>/dev/null)
}

deny() {
  log deny "$1"
  jq -n --arg reason "$1" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$reason}}'
  exit 0
}

expand() {
  local p=$1
  # shellcheck disable=SC2088 # these match literal prefixes, not tilde paths
  case "$p" in
    "~") p="$HOME" ;;
    "~/"*) p="$HOME/${p#\~/}" ;;
  esac
  # shellcheck disable=SC2016 # literal $HOME / ${HOME} text, not expansion
  case "$p" in
    '$HOME'/*) p="$HOME/${p#'$HOME'/}" ;;
    '${HOME}'/*) p="$HOME/${p#'${HOME}'/}" ;;
  esac
  printf '%s\n' "$p"
}

is_under() {
  [ "$1" = "$2" ] && return 0
  case "$1" in "$2"/*) return 0 ;; esac
  return 1
}

# Paths whose contents are credentials, private keys, or auth tokens.
protected_paths=(
  "$HOME/.ssh"
  "$HOME/.gnupg"
  "$HOME/.aws"
  "$HOME/.kube"
  "$HOME/.netrc"
  "$HOME/.git-credentials"
  "$HOME/.npmrc"
  "$HOME/.claude.json"
  "$HOME/.claude/.credentials.json"
  "$HOME/.claude/history.jsonl"
  "$HOME/.config/gh"
  "$HOME/.config/gcloud"
  "$HOME/Library/Keychains"
)

# Files that change how Claude Code or the shell behaves. Writing these from
# inside a session is a privilege escalation path.
config_paths=(
  "$HOME/.claude"
  "$HOME/.claude.json"
  "$HOME/.ssh"
  "$HOME/.gitconfig"
  "$HOME/.zshrc"
  "$HOME/.bashrc"
  "$HOME/.profile"
  "$HOME/.zshenv"
  "$HOME/.zprofile"
  "$HOME/.config/fish"
)

path=$(jq -r '.tool_input.file_path // .tool_input.path // .tool_input.notebook_path // empty' <<<"$input" 2>/dev/null)
if [ -n "$path" ]; then
  p=$(expand "$path")
  r=$(realpath "$p" 2>/dev/null || printf '%s' "$p")

  for prefix in "${protected_paths[@]}"; do
    if is_under "$p" "$prefix" || is_under "$r" "$prefix"; then
      deny "Blocked access to credential path: $path"
    fi
  done

  if [ "$allow_config_edit" != "1" ]; then
    case "$tool" in
      Edit|Write|NotebookEdit)
        for prefix in "${config_paths[@]}"; do
          if is_under "$p" "$prefix" || is_under "$r" "$prefix"; then
            deny "Blocked write to protected config: $path (set CLAUDE_ALLOW_CONFIG_EDIT=1 to override)"
          fi
        done
        case "$p" in
          */.git/hooks/*) deny "Blocked write to git hooks: $path" ;;
        esac
        ;;
    esac
  fi
fi

if [ "$tool" = "Bash" ]; then
  cmd=$(jq -r '.tool_input.command // empty' <<<"$input" 2>/dev/null)
  [ -n "$cmd" ] || exit 0

  if printf '%s' "$cmd" | grep -Eq '(^|[;&|([:space:]])(sudo|doas)([[:space:]]|$)'; then
    deny "Blocked privilege escalation command (sudo/doas)"
  fi

  if printf '%s' "$cmd" | grep -Eq '(curl|wget)[^|]*\|[[:space:]]*(sudo[[:space:]]+)?(ba|z|da|k)?sh([[:space:]]|$)'; then
    deny "Blocked pipe-to-shell command"
  fi

  if printf '%s' "$cmd" | grep -Eq '(^|[;&|[:space:]])rm[[:space:]]+-[^[:space:]]*[rR][^[:space:]]*[fF]?[^[:space:]]*[[:space:]]+/(\*)?([[:space:]]|$)'; then
    deny "Blocked recursive delete of a root path"
  fi

  if printf '%s' "$cmd" | grep -Eq '(^|[;&|[:space:]])(mkfs|wipefs)([[:space:]]|$)|dd[[:space:]][^|;&]*of=/dev/'; then
    deny "Blocked disk-destructive command"
  fi

  for prefix in "${protected_paths[@]}"; do
    tilde=${prefix#"$HOME"}
    # shellcheck disable=SC2016 # these single-quoted forms match literal $HOME/${HOME} text
    case "$cmd" in
      *"$prefix"*|*"~$tilde"*|*'$HOME'"$tilde"*|*'${HOME}'"$tilde"*)
        if printf '%s' "$cmd" | grep -Eq '(^|[;&|[:space:]])(cat|bat|less|more|head|tail|grep|rg|sed|awk|base64|xxd|od|strings|openssl|curl|wget|nc|ncat|python3?|node|perl|ruby|tar|zip|cp|mv|scp|rsync)([[:space:]]|$)'; then
          deny "Blocked command that reads a credential path: $prefix"
        fi
        ;;
    esac
  done

  if [ "$allow_config_edit" != "1" ]; then
    if printf '%s' "$cmd" | grep -Eq '(>|>>)[[:space:]]*[^[:space:];&|]*(\.claude/|\.claude\.json|\.ssh/|\.gitconfig|\.zshrc|\.bashrc|\.profile|\.zshenv|\.zprofile)'; then
      deny "Blocked shell redirect into protected config (set CLAUDE_ALLOW_CONFIG_EDIT=1 to override)"
    fi
    if printf '%s' "$cmd" | grep -Eq '(^|[;&|[:space:]])tee[[:space:]][^|;&]*(\.claude/|\.claude\.json|\.ssh/|\.gitconfig|\.zshrc|\.bashrc|\.profile|\.zshenv|\.zprofile)'; then
      deny "Blocked tee into protected config (set CLAUDE_ALLOW_CONFIG_EDIT=1 to override)"
    fi
    if printf '%s' "$cmd" | grep -Eq '(^|[;&|[:space:]])sed[[:space:]]+-i[^|;&]*(\.claude/|\.claude\.json|\.ssh/|\.gitconfig|\.zshrc|\.bashrc|\.profile|\.zshenv|\.zprofile)'; then
      deny "Blocked in-place edit of protected config (set CLAUDE_ALLOW_CONFIG_EDIT=1 to override)"
    fi
  fi
fi

exit 0
