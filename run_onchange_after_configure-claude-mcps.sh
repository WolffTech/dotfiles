#!/bin/sh

set -eu

if ! command -v claude >/dev/null 2>&1; then
  echo "claude is not installed; skipping MCP configuration" >&2
  exit 0
fi

url="https://mcp.lucid.app/mcp"

# Run a command against one Claude profile. An empty directory selects the default profile,
# so a CLAUDE_CONFIG_DIR inherited from the calling shell cannot redirect it.
in_profile() {
  dir=$1
  shift
  if [ -n "$dir" ]; then
    CLAUDE_CONFIG_DIR=$dir "$@"
  else
    env -u CLAUDE_CONFIG_DIR "$@"
  fi
}

configure_profile() {
  dir=$1

  # Inspect only user scope, without connecting to the server or using project overrides.
  state=$(python3 - "$dir" "$url" <<'PY'
import json
import sys
from pathlib import Path

profile_dir, url = sys.argv[1:]
config_path = Path(profile_dir or Path.home()) / ".claude.json"
config = json.loads(config_path.read_text()) if config_path.exists() else {}
server = config.get("mcpServers", {}).get("lucid")
if server is None:
    print("absent")
elif server.get("type") == "http" and server.get("url") == url:
    print("matches")
else:
    print("different")
PY
)

  case "$state" in
    matches) return 0 ;;
    different) in_profile "$dir" claude mcp remove --scope user lucid ;;
  esac

  in_profile "$dir" claude mcp add --scope user --transport http lucid "$url"
}

configure_profile ""
configure_profile "$HOME/.claude_work"
