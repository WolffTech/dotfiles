#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Set ServiceNow Current Task
# @raycast.mode silent
# @raycast.argument1 {"type":"text","placeholder":"Current task"}

# Optional parameters:
# @raycast.icon 📝

# Documentation:
# @raycast.description Set the Übersicht ServiceNow current task widget to custom text.
# @raycast.author wolfftech
# @raycast.authorURL https://raycast.com/wolfftech

set -euo pipefail

STATE_DIR="$HOME/Library/Application Support/Übersicht"
STATE_FILE="$STATE_DIR/servicenow-current-task.json"
TASK_TEXT="${1-}"

fail() {
  local message="$1"
  print -u2 -- "$message"
  exit 1
}

export STATE_FILE TASK_TEXT

if ! UPDATED_TASK_TEXT=$(python3 <<'PYTHON' 2>&1
import json
import os
import tempfile
from datetime import datetime, timezone
from pathlib import Path

task_text = os.environ.get("TASK_TEXT", "").strip()

if not task_text:
    raise SystemExit("Set current task failed: task text cannot be empty")

state = {
    "taskText": task_text,
    "url": "",
    "capturedAt": datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z"),
}

state_file = Path(os.environ["STATE_FILE"])
state_file.parent.mkdir(parents=True, exist_ok=True)

with tempfile.NamedTemporaryFile("w", encoding="utf-8", dir=state_file.parent, delete=False) as handle:
    json.dump(state, handle, indent=2)
    handle.write("\n")
    temp_name = handle.name

Path(temp_name).replace(state_file)
print(task_text)
PYTHON
); then
  fail "$UPDATED_TASK_TEXT"
fi

print -- "Set current task: $UPDATED_TASK_TEXT"
