#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ToDo - Clear Current Task
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🧹

# Documentation:
# @raycast.description Clear the Übersicht current task widget to a randomly selected default task.
# @raycast.author wolfftech
# @raycast.authorURL https://raycast.com/wolfftech

set -euo pipefail

STATE_DIR="$HOME/Library/Application Support/Übersicht"
STATE_FILE="$STATE_DIR/current-task.json"
TASKS=(
  "My site isn't loading, But my agents are coding."
  "Make a thing do a thing, but only a little bit faster."
  "Automating atomations which are automating all my things. "
  "Make NO MISTAKES"
  "Do not break userspace"
)

mkdir -p "$STATE_DIR"

TASK_TEXT=${TASKS[$((RANDOM % ${#TASKS[@]} + 1))]}
CAPTURED_AT=$(/bin/date -u +"%Y-%m-%dT%H:%M:%SZ")
TEMP_FILE=$(/usr/bin/mktemp "$STATE_DIR/.current-task.XXXXXX")

json_escape() {
  local value=$1

  value=${value//\\/\\\\}
  value=${value//\"/\\\"}
  value=${value//$'\b'/\\b}
  value=${value//$'\f'/\\f}
  value=${value//$'\n'/\\n}
  value=${value//$'\r'/\\r}
  value=${value//$'\t'/\\t}
  print -rn -- "$value"
}

cleanup() {
  /bin/rm -f -- "$TEMP_FILE"
}
trap cleanup EXIT

ESCAPED_TASK_TEXT=$(json_escape "$TASK_TEXT")
/usr/bin/printf '{\n  "taskText": "%s",\n  "url": "",\n  "capturedAt": "%s"\n}\n' \
  "$ESCAPED_TASK_TEXT" "$CAPTURED_AT" > "$TEMP_FILE"
/bin/mv -f -- "$TEMP_FILE" "$STATE_FILE"

print -- "Current task: $TASK_TEXT"
