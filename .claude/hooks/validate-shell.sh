#!/usr/bin/env bash
# validate-shell.sh - PreToolUse で Bash コマンドを検証

input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name // ""')

if [[ "$tool_name" != "Bash" ]]; then
  exit 0
fi

command=$(echo "$input" | jq -r '.tool_input.command // ""')

deny() {
  jq -n --arg reason "$1" '{"decision": "block", "reason": $reason}'
  exit 0
}

# git push
if echo "$command" | grep -qE '\bgit\s+push\b'; then
  deny "Do not execute 'git push'. Please ask the user to execute it."
fi

# git merge
if echo "$command" | grep -qE '\bgit\s+merge\b'; then
  deny "Do not execute 'git merge'. Please ask the user to execute it."
fi

# gh コマンド（push/merge 相当）
if echo "$command" | grep -qE '\bgh\s+(pr\s+merge|repo\s+sync)\b'; then
  deny "Do not execute 'gh pr merge' or 'gh repo sync'. Please ask the user to execute it."
fi

# rm -rf /（危険な削除）
if echo "$command" | grep -qE '\brm\s+(-rf?|--recursive)\s+/\s*$'; then
  deny "Destructive 'rm -rf /' is prohibited."
fi

exit 0
