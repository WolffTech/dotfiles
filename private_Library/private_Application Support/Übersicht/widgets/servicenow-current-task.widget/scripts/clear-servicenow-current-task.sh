#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Clear ServiceNow Current Task
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🧹

# Documentation:
# @raycast.description Clear the Übersicht ServiceNow current task widget back to the default state.
# @raycast.author wolfftech
# @raycast.authorURL https://raycast.com/wolfftech

set -euo pipefail

STATE_DIR="$HOME/Library/Application Support/Übersicht"
STATE_FILE="$STATE_DIR/servicenow-current-task.json"

mkdir -p "$STATE_DIR"

export STATE_FILE

python3 <<'PYTHON'
import json
import os
import tempfile
from datetime import datetime, timezone
from pathlib import Path

state = {
    "taskText": "General Work and Meetings",
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
print("Cleared current task")
PYTHON
