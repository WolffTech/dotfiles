#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Übersicht
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🧩

# Documentation:
# @raycast.description Toggle Übersicht and adjust AeroSpace bottom padding
# @raycast.author wolfftech
# @raycast.authorURL https://raycast.com/wolfftech

set -euo pipefail

APP_BUNDLE_ID="tracesOf.Uebersicht"
AEROSPACE_CONFIG="$HOME/.aerospace.toml"

set_bottom_padding() {
  local value="$1"

  python3 - "$AEROSPACE_CONFIG" "$value" <<'PY'
from pathlib import Path
import re
import sys

config_path = Path(sys.argv[1]).expanduser()
bottom_padding = sys.argv[2]

if not config_path.exists():
    print(f"Error: AeroSpace config not found at {config_path}", file=sys.stderr)
    sys.exit(1)

contents = config_path.read_text()
updated, count = re.subn(
    r"^outer\.bottom\s*=.*$",
    f"outer.bottom =     {bottom_padding}",
    contents,
    count=1,
    flags=re.MULTILINE,
)

if count != 1:
    print("Error: Could not find 'outer.bottom' in AeroSpace config", file=sys.stderr)
    sys.exit(1)

config_path.write_text(updated)
PY
}

if ! command -v aerospace >/dev/null 2>&1; then
  echo "Error: aerospace command not found in PATH"
  exit 1
fi

is_running="$(osascript -e "application id \"$APP_BUNDLE_ID\" is running")"

if [ "$is_running" = "true" ]; then
  osascript -e "tell application id \"$APP_BUNDLE_ID\" to quit"
  set_bottom_padding "8"
  aerospace reload-config --no-gui
  echo "Übersicht closed. AeroSpace bottom padding set to 8."
else
  open -b "$APP_BUNDLE_ID"
  set_bottom_padding "55"
  aerospace reload-config --no-gui
  echo "Übersicht launched. AeroSpace bottom padding set to 55."
fi
