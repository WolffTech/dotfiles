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

  codex mcp add "$name" --url "$url"
}

# Keep Codex's MCP servers aligned with ~/.config/opencode/opencode.json.
ensure_remote_mcp "context7" "https://mcp.context7.com/mcp"
ensure_remote_mcp "gh_grep" "https://mcp.grep.app"
ensure_remote_mcp "microsoft-learn" "https://learn.microsoft.com/api/mcp"
