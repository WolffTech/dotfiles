#!/bin/sh

set -eu

if ! command -v codex >/dev/null 2>&1; then
  echo "codex is not installed; skipping MCP configuration" >&2
  exit 0
fi

ensure_remote_mcp() {
  name=$1
  url=$2
  current=""

  if current=$(codex mcp get "$name" 2>/dev/null); then
    case "$current" in
      *"url: $url"*)
        return 0
        ;;
    esac

    codex mcp remove "$name"
  fi

  # Write the entry directly because `codex mcp add` starts OAuth automatically.
  python3 - "$name" "$url" <<'PY'
import json
import os
import sys
import tomllib
from pathlib import Path

name, url = sys.argv[1:]
config_dir = Path(os.environ.get("CODEX_HOME") or Path.home() / ".codex")
config_path = config_dir / "config.toml"
current = config_path.read_text() if config_path.exists() else ""
entry = f"\n\n[mcp_servers.{json.dumps(name)}]\nurl = {json.dumps(url)}\n"

# Validate before appending, leaving existing content and permissions intact.
tomllib.loads(current + entry)
config_dir.mkdir(parents=True, exist_ok=True)
fd = os.open(config_path, os.O_WRONLY | os.O_APPEND | os.O_CREAT, 0o600)
with os.fdopen(fd, "w") as config_file:
    config_file.write(entry)
PY
}

# Shared documentation servers are also configured in OpenCode.
ensure_remote_mcp "gh_grep" "https://mcp.grep.app"
ensure_remote_mcp "microsoft-learn" "https://learn.microsoft.com/api/mcp"
ensure_remote_mcp "lucid" "https://mcp.lucid.app/mcp"
