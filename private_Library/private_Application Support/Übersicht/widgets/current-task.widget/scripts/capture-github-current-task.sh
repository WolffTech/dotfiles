#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ToDo GitHub Widget
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🐙

# Documentation:
# @raycast.description Update Übersicht widget to show current GitHub issue or pull request.
# @raycast.author wolfftech
# @raycast.authorURL https://raycast.com/wolfftech

set -euo pipefail

STATE_DIR="$HOME/Library/Application Support/Übersicht"
STATE_FILE="$STATE_DIR/current-task.json"

fail() {
  local message="$1"
  print -u2 -- "$message"
  exit 1
}

mkdir -p "$STATE_DIR"

if ! SAFARI_JSON=$(osascript -l JavaScript 2>&1 <<'JXA'
const safari = Application('Safari');

if (!safari.running()) {
  throw new Error('Safari is not running');
}

if (safari.windows.length === 0) {
  throw new Error('Safari has no front window');
}

const currentTab = safari.windows[0].currentTab();
const url = currentTab.url() || '';
const title = currentTab.name() || '';

const domResult = safari.doJavaScript(`(() => {
  const textOf = (value) => (value || '').toString().replace(/\\s+/g, ' ').trim();
  const titleNodes = [
    document.querySelector('[data-testid="issue-title"]'),
    document.querySelector('bdi.js-issue-title'),
    document.querySelector('.js-issue-title'),
    document.querySelector('span.js-issue-title'),
    document.querySelector('h1 bdi'),
    document.querySelector('h1')
  ];

  for (const node of titleNodes) {
    const candidate = textOf(node ? node.textContent : '');
    if (candidate) {
      return JSON.stringify({ taskTitle: candidate });
    }
  }

  const ogTitle = document.querySelector('meta[property="og:title"]');
  const ogCandidate = textOf(ogTitle ? ogTitle.getAttribute('content') : '');
  return JSON.stringify({ taskTitle: ogCandidate });
})()`, { in: currentTab });

console.log(JSON.stringify({ url, title, dom: JSON.parse(domResult) }));
JXA
); then
  case "$SAFARI_JSON" in
    *"JavaScript from Apple Events"*)
      fail "GitHub capture failed: enable Safari's 'Allow JavaScript from Apple Events' setting, then try again"
      ;;
    *)
      fail "GitHub capture failed: unable to inspect the front Safari tab"
      ;;
  esac
fi

export SAFARI_JSON STATE_FILE

if ! TASK_TEXT=$(python3 <<'PYTHON' 2>&1
import json
import os
import re
import tempfile
from datetime import datetime, timezone
from pathlib import Path
from urllib.parse import urlparse

payload = json.loads(os.environ["SAFARI_JSON"])
url = str(payload.get("url", "")).strip()
title = str(payload.get("title", "")).strip()
dom = payload.get("dom") or {}

if not isinstance(dom, dict):
    raise SystemExit("GitHub capture failed: unable to inspect the front Safari tab")

parsed_url = urlparse(url)
host = parsed_url.netloc.lower()
path_parts = [part for part in parsed_url.path.split("/") if part]

is_github_host = host == "github.com" or host.endswith(".github.com")
is_issue_or_pull = (
    is_github_host
    and len(path_parts) >= 4
    and path_parts[2] in {"issues", "pull"}
    and re.fullmatch(r"\d+", path_parts[3]) is not None
)

if not is_issue_or_pull:
    raise SystemExit("GitHub capture failed: active Safari tab is not a recognized issue or pull request")

def clean_title(value):
    value = re.sub(r"\s+", " ", str(value or "")).strip()
    value = re.sub(r"\s+[·-]\s+(?:Issue|Pull Request)\s+#\d+\s+[·-]\s+.+$", "", value)
    value = re.sub(r"\s+#\d+\s*$", "", value)
    return value.strip()

task_title = clean_title(dom.get("taskTitle"))

if not task_title:
    task_title = clean_title(title)

if not task_title:
    raise SystemExit("GitHub capture failed: no issue or pull request title found")

task_number = f"#{path_parts[3]}"
if not task_title.endswith(task_number):
    task_title = f"{task_title} {task_number}"

state = {
    "taskText": task_title,
    "url": url,
    "capturedAt": datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z"),
}

state_file = Path(os.environ["STATE_FILE"])
state_file.parent.mkdir(parents=True, exist_ok=True)

with tempfile.NamedTemporaryFile("w", encoding="utf-8", dir=state_file.parent, delete=False) as handle:
    json.dump(state, handle, indent=2)
    handle.write("\n")
    temp_name = handle.name

Path(temp_name).replace(state_file)
print(task_title)
PYTHON
); then
  fail "$TASK_TEXT"
fi

print -- "Captured: $TASK_TEXT"
