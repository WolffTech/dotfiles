#!/bin/sh

set -eu

if ! command -v claude >/dev/null 2>&1; then
  echo "claude is not installed; skipping MCP configuration" >&2
  exit 0
fi

url="https://mcp.lucid.app/mcp"

# Inspect only user scope, without connecting to the server or using project overrides.
state=$(python3 - "$url" <<'PY'
import json
import os
import sys
from pathlib import Path

config_path = Path(os.environ.get("CLAUDE_CONFIG_DIR") or Path.home()) / ".claude.json"
config = json.loads(config_path.read_text()) if config_path.exists() else {}
server = config.get("mcpServers", {}).get("lucid")
if server is None:
    print("absent")
elif server.get("type") == "http" and server.get("url") == sys.argv[1]:
    print("matches")
else:
    print("different")
PY
)

case "$state" in
  matches) exit 0 ;;
  different) claude mcp remove --scope user lucid ;;
esac

claude mcp add --scope user --transport http lucid "$url"
