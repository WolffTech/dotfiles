#!/bin/zsh

set -euo pipefail

ROOT_DIR=${0:A:h:h}
SCRIPT_PATH="$ROOT_DIR/scripts/capture-github-current-task.sh"

fail() {
  print -u2 -- "FAIL: $1"
  exit 1
}

assert_eq() {
  local expected="$1"
  local actual="$2"
  local message="$3"

  if [[ "$actual" != "$expected" ]]; then
    print -u2 -- "Expected: $expected"
    print -u2 -- "Actual:   $actual"
    fail "$message"
  fi
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local message="$3"

  if [[ "$haystack" != *"$needle"* ]]; then
    print -u2 -- "Missing substring: $needle"
    print -u2 -- "Actual text: $haystack"
    fail "$message"
  fi
}

write_mock_osascript() {
  local bin_dir="$1"

  cat > "$bin_dir/osascript" <<'EOF'
#!/bin/zsh
set -euo pipefail

if [[ "${1-}" != "-l" || "${2-}" != "JavaScript" ]]; then
  print -u2 -- "expected osascript -l JavaScript"
  exit 1
fi

jxa_script=$(< /dev/stdin)

[[ "$jxa_script" == *"Application('Safari')"* ]] || {
  print -u2 -- "missing Safari application lookup"
  exit 1
}
[[ "$jxa_script" == *"const currentTab = safari.windows[0].currentTab();"* ]] || {
  print -u2 -- "missing Safari currentTab lookup via windows[0]"
  exit 1
}
[[ "$jxa_script" == *"const url = currentTab.url() || '';"* ]] || {
  print -u2 -- "missing Safari current tab URL read"
  exit 1
}
[[ "$jxa_script" == *"const title = currentTab.name() || '';"* ]] || {
  print -u2 -- "missing Safari current tab title read"
  exit 1
}
[[ "$jxa_script" == *"const domResult = safari.doJavaScript("* ]] || {
  print -u2 -- "missing safari.doJavaScript call"
  exit 1
}
[[ "$jxa_script" == *"replace(/\\\\s+/g, ' ')"* ]] || {
  print -u2 -- "missing escaped whitespace normalization for nested Safari JavaScript"
  exit 1
}
[[ "$jxa_script" == *"document.querySelector('[data-testid=\"issue-title\"]')"* ]] || {
  print -u2 -- "missing GitHub issue-title selector"
  exit 1
}
[[ "$jxa_script" == *"document.querySelector('bdi.js-issue-title')"* ]] || {
  print -u2 -- "missing GitHub js-issue-title selector"
  exit 1
}
[[ "$jxa_script" == *", { in: currentTab });"* ]] || {
  print -u2 -- "missing currentTab target for Safari JS execution"
  exit 1
}
[[ "$jxa_script" == *"console.log(JSON.stringify({ url, title, dom: JSON.parse(domResult) }));"* ]] || {
  print -u2 -- "missing JSON output contract"
  exit 1
}

if [[ -n "${MOCK_JXA_STDERR-}" ]]; then
  print -u2 -- "${MOCK_JXA_STDERR}"
  exit "${MOCK_JXA_EXIT_CODE:-1}"
fi

print -r -- "${MOCK_JXA_JSON:?}"
EOF
  chmod +x "$bin_dir/osascript"
}

run_capture() {
  local mock_json="$1"
  local stdout_file="$2"
  local stderr_file="$3"
  local temp_dir bin_dir home_dir

  temp_dir=$(mktemp -d)
  bin_dir="$temp_dir/bin"
  home_dir="$temp_dir/home"
  mkdir -p "$bin_dir" "$home_dir"
  write_mock_osascript "$bin_dir"

  PATH="$bin_dir:$PATH" HOME="$home_dir" MOCK_JXA_JSON="$mock_json" "$SCRIPT_PATH" > "$stdout_file" 2> "$stderr_file"
  print -r -- "$home_dir/Library/Application Support/Übersicht/servicenow-current-task.json"
}

read_json_field() {
  local state_file="$1"
  local field="$2"

  STATE_FILE="$state_file" FIELD="$field" python3 <<'PYTHON'
import json
import os
from pathlib import Path

state = json.loads(Path(os.environ["STATE_FILE"]).read_text(encoding="utf-8"))
print(state.get(os.environ["FIELD"], ""))
PYTHON
}

run_issue_success_case() {
  local temp_dir stdout_file stderr_file state_file task_text url captured_at
  temp_dir=$(mktemp -d)
  stdout_file="$temp_dir/stdout"
  stderr_file="$temp_dir/stderr"

  state_file=$(run_capture '{"url":"https://github.com/example-org/example-repo/issues/123?focused=1","title":"Fix widget spacing · Issue #123 · example-org/example-repo","dom":{"taskTitle":"Fix widget spacing"}}' "$stdout_file" "$stderr_file")

  [[ -f "$state_file" ]] || fail "state file was not written for issue capture"
  task_text=$(read_json_field "$state_file" taskText)
  url=$(read_json_field "$state_file" url)
  captured_at=$(read_json_field "$state_file" capturedAt)

  assert_eq "Fix widget spacing #123" "$task_text" "issue title and number should be taskText"
  assert_eq "https://github.com/example-org/example-repo/issues/123?focused=1" "$url" "issue URL should be preserved"
  assert_contains "$captured_at" "Z" "capturedAt should be UTC ISO text"
  assert_contains "$(< "$stdout_file")" "Captured: Fix widget spacing #123" "stdout should report captured issue"
}

run_pull_success_case() {
  local temp_dir stdout_file stderr_file state_file task_text url
  temp_dir=$(mktemp -d)
  stdout_file="$temp_dir/stdout"
  stderr_file="$temp_dir/stderr"

  state_file=$(run_capture '{"url":"https://github.com/example-org/example-repo/pull/456#discussion_r1","title":"Add GitHub current task capture by wolfftech · Pull Request #456 · example-org/example-repo","dom":{"taskTitle":"Add GitHub current task capture"}}' "$stdout_file" "$stderr_file")

  [[ -f "$state_file" ]] || fail "state file was not written for pull capture"
  task_text=$(read_json_field "$state_file" taskText)
  url=$(read_json_field "$state_file" url)

  assert_eq "Add GitHub current task capture #456" "$task_text" "pull request title and number should be taskText"
  assert_eq "https://github.com/example-org/example-repo/pull/456#discussion_r1" "$url" "pull URL should be preserved"
}

run_title_fallback_case() {
  local temp_dir stdout_file stderr_file state_file task_text
  temp_dir=$(mktemp -d)
  stdout_file="$temp_dir/stdout"
  stderr_file="$temp_dir/stderr"

  state_file=$(run_capture '{"url":"https://github.com/example-org/example-repo/issues/789","title":"Use browser title fallback · Issue #789 · example-org/example-repo","dom":{"taskTitle":""}}' "$stdout_file" "$stderr_file")

  [[ -f "$state_file" ]] || fail "state file was not written for title fallback"
  task_text=$(read_json_field "$state_file" taskText)

  assert_eq "Use browser title fallback #789" "$task_text" "browser title fallback should include issue number"
}

run_invalid_page_case() {
  local temp_dir bin_dir home_dir stdout_file stderr_file state_file
  temp_dir=$(mktemp -d)
  bin_dir="$temp_dir/bin"
  home_dir="$temp_dir/home"
  stdout_file="$temp_dir/stdout"
  stderr_file="$temp_dir/stderr"
  mkdir -p "$bin_dir" "$home_dir/Library/Application Support/Übersicht"
  write_mock_osascript "$bin_dir"
  state_file="$home_dir/Library/Application Support/Übersicht/servicenow-current-task.json"
  print -r -- '{"taskText":"Existing Task","url":"https://example.test","capturedAt":"2026-05-06T00:00:00Z"}' > "$state_file"

  if PATH="$bin_dir:$PATH" HOME="$home_dir" MOCK_JXA_JSON='{"url":"https://github.com/example-org/example-repo","title":"example-org/example-repo","dom":{"taskTitle":""}}' "$SCRIPT_PATH" > "$stdout_file" 2> "$stderr_file"; then
    fail "invalid GitHub repo page should fail"
  fi

  assert_contains "$(< "$stderr_file")" "GitHub capture failed: active Safari tab is not a recognized issue or pull request" "invalid page should explain failure"
  assert_eq "Existing Task" "$(read_json_field "$state_file" taskText)" "invalid page should not overwrite existing task"
}

run_javascript_events_error_case() {
  local temp_dir bin_dir home_dir stdout_file stderr_file
  temp_dir=$(mktemp -d)
  bin_dir="$temp_dir/bin"
  home_dir="$temp_dir/home"
  stdout_file="$temp_dir/stdout"
  stderr_file="$temp_dir/stderr"
  mkdir -p "$bin_dir" "$home_dir"
  write_mock_osascript "$bin_dir"

  if PATH="$bin_dir:$PATH" HOME="$home_dir" MOCK_JXA_STDERR="Error: JavaScript from Apple Events is not enabled" MOCK_JXA_EXIT_CODE=1 MOCK_JXA_JSON='{}' "$SCRIPT_PATH" > "$stdout_file" 2> "$stderr_file"; then
    fail "JavaScript from Apple Events error should fail"
  fi

  assert_contains "$(< "$stderr_file")" "GitHub capture failed: enable Safari's 'Allow JavaScript from Apple Events' setting, then try again" "JavaScript events error should be actionable"
}

run_issue_success_case
run_pull_success_case
run_title_fallback_case
run_invalid_page_case
run_javascript_events_error_case

print -- "capture-github-current-task tests passed"
