#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ToDo Service Now Widget
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📝

# Documentation:
# @raycast.description Update Übersicht widget to show current service now ticket.
# @raycast.author wolfftech
# @raycast.authorURL https://raycast.com/wolfftech


set -euo pipefail

STATE_DIR="$HOME/Library/Application Support/Übersicht"
STATE_FILE="$STATE_DIR/servicenow-current-task.json"

notify() {
  local message="$1"
  osascript -e "display notification \"${message//\"/\\\"}\" with title \"ServiceNow Capture\"" || true
}

fail() {
  local message="$1"
  notify "$message"
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
  const findInTree = (root, predicate, seen = new Set()) => {
    if (!root || seen.has(root)) return null;
    seen.add(root);
    if (predicate(root)) return root;

    const children = [];
    if (root.querySelectorAll) {
      for (const child of root.querySelectorAll('*')) {
        children.push(child);
      }
    } else if (root.children) {
      for (const child of root.children) {
        children.push(child);
      }
    }

    for (const child of children) {
      if (predicate(child)) return child;
      if (child.shadowRoot) {
        const nested = findInTree(child.shadowRoot, predicate, seen);
        if (nested) return nested;
      }
    }

    return null;
  };

  const frame = findInTree(document, (node) => node.tagName === 'IFRAME' && node.id === 'gsft_main');
  const recordDocument = frame && frame.contentDocument ? frame.contentDocument : document;
  const textOf = (value) => (value || '').toString().trim();
  const pickValue = (...selectors) => {
    for (const selector of selectors) {
      const node = recordDocument.querySelector(selector);
      if (!node) continue;
      const value = textOf(node.value || node.getAttribute('value') || node.textContent);
      if (value) return value;
    }
    return '';
  };

  const ticketNumber = pickValue(
    '#incident\\.number',
    '#task\\.number',
    '#change_request\\.number',
    '#sc_req_item\\.number',
    '#sys_display\\.incident\\.number',
    '#sys_display\\.task\\.number',
    '#sys_display\\.change_request\\.number',
    '#sys_display\\.sc_req_item\\.number',
    'input[id*="number"]',
    'input[name="number"]'
  );

  const shortDescription = pickValue(
    '#incident\\.short_description',
    '#task\\.short_description',
    '#change_request\\.short_description',
    '#sc_req_item\\.short_description',
    'input[id*="short_description"]',
    'input[name="short_description"]',
    'textarea[id*="short_description"]',
    'textarea[name="short_description"]'
  );

  return JSON.stringify({ ticketNumber, shortDescription });
})()`, { in: currentTab });

console.log(JSON.stringify({ url, title, dom: JSON.parse(domResult) }));
JXA
); then
  case "$SAFARI_JSON" in
    *"JavaScript from Apple Events"*)
      fail "ServiceNow capture failed: enable Safari's 'Allow JavaScript from Apple Events' setting, then try again"
      ;;
    *)
      fail "ServiceNow capture failed: unable to inspect the front Safari tab"
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

payload = json.loads(os.environ["SAFARI_JSON"])
url = str(payload.get("url", "")).strip()
title = str(payload.get("title", "")).strip()
dom = payload.get("dom") or {}

if not isinstance(dom, dict):
    raise SystemExit("ServiceNow capture failed: unable to inspect the front Safari tab")

normalized_url = url.lower()
if "service-now" not in normalized_url and "servicenow" not in normalized_url:
    raise SystemExit("ServiceNow capture failed: active Safari tab is not a recognized ticket")

ticket_pattern = re.compile(r"\b((?:INC|RITM|REQ|CHG|PRB|SCTASK|TASK)\d+)\b", re.IGNORECASE)

ticket_number = str(dom.get("ticketNumber") or "").strip()
short_description = str(dom.get("shortDescription") or "").strip()

if not ticket_number or not short_description:
    title_match = ticket_pattern.search(title)
    if title_match:
        if not ticket_number:
            ticket_number = title_match.group(1).upper()
        trailing = title[title_match.end():]
        parsed_short_description = re.sub(r"^[\s\-:|]+", "", trailing).strip()
        parsed_short_description = re.sub(
            r"\s*[|:-]\s*(?:service\s*now|now\s+platform)\s*$",
            "",
            parsed_short_description,
            flags=re.IGNORECASE,
        ).strip()
        if not short_description:
            short_description = parsed_short_description

if not ticket_number:
    raise SystemExit("ServiceNow capture failed: no ticket number found")

if not short_description:
    raise SystemExit("ServiceNow capture failed: no short description found")

task_text = f"{ticket_number.upper()} {short_description}"
state = {
    "taskText": task_text,
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
print(task_text)
PYTHON
); then
  fail "$TASK_TEXT"
fi

notify "Captured current ServiceNow task"
print -- "$TASK_TEXT"
