#!/usr/bin/env bash
set -euo pipefail

media_control_bin="${MEDIA_CONTROL_BIN:-/opt/homebrew/bin/media-control}"
payload_file="$(mktemp)"
trap 'rm -f "$payload_file"' EXIT

"$media_control_bin" get >"$payload_file"

if python3 - "$payload_file" <<'PY'
import json
import sys

payload_path = sys.argv[1]

with open(payload_path, "r", encoding="utf-8") as payload_file:
    original_payload = payload_file.read()

try:
    payload = json.loads(original_payload)
except json.JSONDecodeError:
    print(original_payload, end="")
    sys.exit(0)

if not isinstance(payload, dict):
    print(original_payload, end="")
    sys.exit(0)

if "artworkMimeType" in payload and "artworkData" in payload:
    print(original_payload, end="")
    sys.exit(0)

safari_bundle_ids = {"com.apple.Safari", "com.apple.WebKit.GPU"}
bundle_ids = {
    payload.get("bundleIdentifier"),
    payload.get("parentApplicationBundleIdentifier"),
}

title = payload.get("title")
if not safari_bundle_ids.intersection(bundle_ids) or not isinstance(title, str) or not title:
    print(json.dumps(payload, separators=(",", ":")))
    sys.exit(0)

sys.exit(10)
PY
then
  exit 0
else
  status=$?
  if [[ "$status" -ne 10 ]]; then
    exit "$status"
  fi
fi

if [[ -n "${SAFARI_TABS_JSON:-}" ]]; then
  tabs_json="$SAFARI_TABS_JSON"
else
  tabs_json="$(osascript -l JavaScript <<'JXA' 2>/dev/null || printf '[]'
const safari = Application('Safari');
const tabs = [];

safari.windows().forEach((window, windowIndex) => {
  window.tabs().forEach((tab, tabIndex) => {
    tabs.push({
      windowIndex: windowIndex + 1,
      tabIndex: tabIndex + 1,
      title: tab.name(),
      url: tab.url(),
    });
  });
});

JSON.stringify(tabs);
JXA
)"
fi

TABS_JSON="$tabs_json" python3 - "$payload_file" <<'PY'
import json
import os
import sys
from urllib.parse import parse_qs, urlparse

payload_path = sys.argv[1]
tabs_json = os.environ.get("TABS_JSON", "[]")

with open(payload_path, "r", encoding="utf-8") as payload_file:
    original_payload = payload_file.read()

try:
    payload = json.loads(original_payload)
except json.JSONDecodeError:
    print(original_payload, end="")
    sys.exit(0)

if not isinstance(payload, dict):
    print(original_payload, end="")
    sys.exit(0)

if "artworkMimeType" in payload and "artworkData" in payload:
    print(json.dumps(payload, separators=(",", ":")))
    sys.exit(0)

safari_bundle_ids = {"com.apple.Safari", "com.apple.WebKit.GPU"}
bundle_ids = {
    payload.get("bundleIdentifier"),
    payload.get("parentApplicationBundleIdentifier"),
}

title = payload.get("title")
if not safari_bundle_ids.intersection(bundle_ids) or not isinstance(title, str) or not title:
    print(json.dumps(payload, separators=(",", ":")))
    sys.exit(0)

try:
    tabs = json.loads(tabs_json)
except json.JSONDecodeError:
    tabs = []

if not isinstance(tabs, list):
    tabs = []


def normalized_title(value):
    if not isinstance(value, str):
        return ""
    suffix = " - YouTube"
    return value[: -len(suffix)] if value.endswith(suffix) else value


def youtube_watch_tab(tab):
    if not isinstance(tab, dict):
        return None

    url = tab.get("url")
    if not isinstance(url, str):
        return None

    parsed = urlparse(url)
    hostname = parsed.hostname or ""
    # Safari YouTube tabs commonly use www.youtube.com; treat that as youtube.com.
    if hostname.startswith("www."):
        hostname = hostname[4:]
    if hostname not in {"youtube.com", "m.youtube.com"}:
        return None
    if parsed.path != "/watch":
        return None

    video_ids = parse_qs(parsed.query).get("v")
    if not video_ids or not video_ids[0]:
        return None

    return {
        "title": normalized_title(tab.get("title")),
        "video_id": video_ids[0],
    }


youtube_tabs = [tab for tab in (youtube_watch_tab(tab) for tab in tabs) if tab]
payload_title = normalized_title(title)

title_matches = [
    tab
    for tab in youtube_tabs
    if tab["title"]
    and (
        tab["title"] == payload_title
        or payload_title in tab["title"]
        or tab["title"] in payload_title
    )
]

selected = None
if len(title_matches) == 1:
    selected = title_matches[0]

if selected:
    payload["artworkUrl"] = f"https://img.youtube.com/vi/{selected['video_id']}/hqdefault.jpg"

print(json.dumps(payload, separators=(",", ":")))
PY
