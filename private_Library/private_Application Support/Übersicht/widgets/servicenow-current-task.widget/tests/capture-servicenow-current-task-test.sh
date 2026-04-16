#!/bin/zsh

set -euo pipefail

ROOT_DIR=${0:A:h:h}
SCRIPT_PATH="$ROOT_DIR/scripts/capture-servicenow-current-task.sh"

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
  local notifications_file="$2"

  cat > "$bin_dir/osascript" <<EOF
#!/bin/zsh
set -euo pipefail

if [[ "\${1-}" == "-l" ]]; then
  [[ "\${2-}" == "JavaScript" ]] || {
    print -u2 -- "expected osascript -l JavaScript"
    exit 1
  }

  jxa_script=\$(< /dev/stdin)

  [[ "\$jxa_script" == *"Application('Safari')"* ]] || {
    print -u2 -- "missing Safari application lookup"
    exit 1
  }
  [[ "\$jxa_script" == *"const currentTab = safari.windows[0].currentTab();"* ]] || {
    print -u2 -- "missing Safari currentTab lookup via windows[0]"
    exit 1
  }
  [[ "\$jxa_script" != *"frontWindow().currentTab()"* ]] || {
    print -u2 -- "unexpected frontWindow currentTab lookup"
    exit 1
  }
  [[ "\$jxa_script" == *"const domResult = safari.doJavaScript("* ]] || {
    print -u2 -- "missing safari.doJavaScript call"
    exit 1
  }
  [[ "\$jxa_script" == *"const findInTree = (root, predicate, seen = new Set()) => {"* ]] || {
    print -u2 -- "missing recursive DOM search helper"
    exit 1
  }
  [[ "\$jxa_script" == *"const frame = findInTree(document, (node) => node.tagName === 'IFRAME' && node.id === 'gsft_main');"* ]] || {
    print -u2 -- "missing gsft_main iframe lookup"
    exit 1
  }
  [[ "\$jxa_script" == *"const recordDocument = frame && frame.contentDocument ? frame.contentDocument : document;"* ]] || {
    print -u2 -- "missing record document fallback"
    exit 1
  }
  [[ "\$jxa_script" == *", { in: currentTab });"* ]] || {
    print -u2 -- "missing currentTab target for Safari JS execution"
    exit 1
  }
  [[ "\$jxa_script" != *"currentTab.doJavaScript("* ]] || {
    print -u2 -- "unexpected tab-scoped doJavaScript call"
    exit 1
  }
  [[ "\$jxa_script" == *"console.log(JSON.stringify({ url, title, dom: JSON.parse(domResult) }));"* ]] || {
    print -u2 -- "missing JSON output contract"
    exit 1
  }

  if [[ -n "\${MOCK_JXA_STDERR-}" ]]; then
    print -u2 -- "\${MOCK_JXA_STDERR}"
    exit "\${MOCK_JXA_EXIT_CODE:-1}"
  fi

  print -r -- "\${MOCK_JXA_JSON:?}"
else
  print -r -- "\$*" >> "$notifications_file"
  exit "\${MOCK_NOTIFY_EXIT_CODE:-0}"
fi
EOF
  chmod +x "$bin_dir/osascript"
}

run_success_case() {
  local temp_dir bin_dir home_dir stdout_file stderr_file notifications_file state_file plutil_output
  temp_dir=$(mktemp -d)
  bin_dir="$temp_dir/bin"
  home_dir="$temp_dir/home"
  stdout_file="$temp_dir/stdout.txt"
  stderr_file="$temp_dir/stderr.txt"
  notifications_file="$temp_dir/notifications.log"
  state_file="$home_dir/Library/Application Support/Übersicht/servicenow-current-task.json"

  mkdir -p "$bin_dir" "$home_dir"
  write_mock_osascript "$bin_dir" "$notifications_file"

  [[ -x "$SCRIPT_PATH" ]] || fail "capture script is missing: $SCRIPT_PATH"

  MOCK_JXA_JSON='{"url":"https://example.service-now.com/incident.do?sys_id=123","title":"INC0012345 Old Title","dom":{"ticketNumber":"INC0012345","shortDescription":"Fix VPN access for user"}}' \
    HOME="$home_dir" PATH="$bin_dir:$PATH" zsh "$SCRIPT_PATH" >"$stdout_file" 2>"$stderr_file"

  assert_eq "INC0012345 Fix VPN access for user" "$(<"$stdout_file")" "script should print captured task text"
  assert_eq "" "$(<"$stderr_file")" "success case should not write stderr"
  assert_contains "$(<"$notifications_file")" "Captured current ServiceNow task" "success should trigger a notification"

  plutil_output=$(plutil -extract taskText raw -o - "$state_file")
  assert_eq "INC0012345 Fix VPN access for user" "$plutil_output" "state file should store task text"
  assert_eq "https://example.service-now.com/incident.do?sys_id=123" "$(plutil -extract url raw -o - "$state_file")" "state file should store url"
  assert_contains "$(plutil -extract capturedAt raw -o - "$state_file")" "T" "state file should store ISO timestamp"
  [[ ! -e "$home_dir/Library/Application Support/Uebersicht/servicenow-current-task.json" ]] || fail "script should not create ASCII Uebersicht state path"
}

run_notification_failure_case() {
  local temp_dir bin_dir home_dir stdout_file stderr_file notifications_file state_file
  temp_dir=$(mktemp -d)
  bin_dir="$temp_dir/bin"
  home_dir="$temp_dir/home"
  stdout_file="$temp_dir/stdout.txt"
  stderr_file="$temp_dir/stderr.txt"
  notifications_file="$temp_dir/notifications.log"
  state_file="$home_dir/Library/Application Support/Übersicht/servicenow-current-task.json"

  mkdir -p "$bin_dir" "$home_dir"
  write_mock_osascript "$bin_dir" "$notifications_file"

  MOCK_JXA_JSON='{"url":"https://example.service-now.com/incident.do?sys_id=123","title":"INC0012345 Old Title","dom":{"ticketNumber":"INC0012345","shortDescription":"Fix VPN access for user"}}' \
    MOCK_NOTIFY_EXIT_CODE=1 \
    HOME="$home_dir" PATH="$bin_dir:$PATH" zsh "$SCRIPT_PATH" >"$stdout_file" 2>"$stderr_file"

  assert_eq "INC0012345 Fix VPN access for user" "$(<"$stdout_file")" "script should succeed when success notification fails"
  assert_eq "" "$(<"$stderr_file")" "success notification failure should not write stderr"
  assert_contains "$(<"$notifications_file")" "Captured current ServiceNow task" "success should still attempt a notification"
  assert_eq "INC0012345 Fix VPN access for user" "$(plutil -extract taskText raw -o - "$state_file")" "state file should still be written when success notification fails"
}

run_title_fallback_and_failure_case() {
  local temp_dir bin_dir home_dir stdout_file stderr_file notifications_file state_file state_before state_after
  temp_dir=$(mktemp -d)
  bin_dir="$temp_dir/bin"
  home_dir="$temp_dir/home"
  stdout_file="$temp_dir/stdout.txt"
  stderr_file="$temp_dir/stderr.txt"
  notifications_file="$temp_dir/notifications.log"
  state_file="$home_dir/Library/Application Support/Übersicht/servicenow-current-task.json"

  mkdir -p "$bin_dir" "${state_file:h}"

  print -r -- '{"taskText":"KEEP EXISTING","url":"https://old.example","capturedAt":"2026-04-16T00:00:00Z"}' > "$state_file"
  write_mock_osascript "$bin_dir" "$notifications_file"

  MOCK_JXA_JSON='{"url":"https://example.service-now.com/incident.do?sys_id=123","title":"INC0019999 - Restore SSO access | ServiceNow","dom":{"ticketNumber":"","shortDescription":""}}' \
    HOME="$home_dir" PATH="$bin_dir:$PATH" zsh "$SCRIPT_PATH" >"$stdout_file" 2>"$stderr_file"
  assert_eq "INC0019999 Restore SSO access" "$(<"$stdout_file")" "script should fall back to parsing the tab title"
  state_before=$(<"$state_file")

  if MOCK_JXA_JSON='{"url":"https://example.com/","title":"Example Domain","dom":{"ticketNumber":"","shortDescription":""}}' \
    HOME="$home_dir" PATH="$bin_dir:$PATH" zsh "$SCRIPT_PATH" >"$stdout_file" 2>"$stderr_file"; then
    fail "non-ServiceNow page should fail"
  fi

  assert_eq "ServiceNow capture failed: active Safari tab is not a recognized ticket" "$(<"$stderr_file")" "script should emit the non-ServiceNow failure"
  assert_contains "$(<"$notifications_file")" "active Safari tab is not a recognized ticket" "failure should trigger a notification"

  state_after=$(<"$state_file")
  assert_eq "$state_before" "$state_after" "failure should preserve prior state"
}

run_failure_notification_failure_case() {
  local temp_dir bin_dir home_dir stdout_file stderr_file notifications_file state_file state_before state_after
  temp_dir=$(mktemp -d)
  bin_dir="$temp_dir/bin"
  home_dir="$temp_dir/home"
  stdout_file="$temp_dir/stdout.txt"
  stderr_file="$temp_dir/stderr.txt"
  notifications_file="$temp_dir/notifications.log"
  state_file="$home_dir/Library/Application Support/Übersicht/servicenow-current-task.json"

  mkdir -p "$bin_dir" "${state_file:h}"

  print -r -- '{"taskText":"KEEP EXISTING","url":"https://old.example","capturedAt":"2026-04-16T00:00:00Z"}' > "$state_file"
  write_mock_osascript "$bin_dir" "$notifications_file"

  state_before=$(<"$state_file")

  if MOCK_JXA_JSON='{"url":"https://example.com/","title":"Example Domain","dom":{"ticketNumber":"","shortDescription":""}}' \
    MOCK_NOTIFY_EXIT_CODE=1 \
    HOME="$home_dir" PATH="$bin_dir:$PATH" zsh "$SCRIPT_PATH" >"$stdout_file" 2>"$stderr_file"; then
    fail "non-ServiceNow page should fail even if notification delivery fails"
  fi

  assert_eq "ServiceNow capture failed: active Safari tab is not a recognized ticket" "$(<"$stderr_file")" "failure notification failure should not hide the real error"
  assert_contains "$(<"$notifications_file")" "active Safari tab is not a recognized ticket" "failure should still attempt a notification"

  state_after=$(<"$state_file")
  assert_eq "$state_before" "$state_after" "failure notification failure should preserve prior state"
}

run_jxa_permission_failure_case() {
  local temp_dir bin_dir home_dir stdout_file stderr_file notifications_file state_file state_before state_after expected_message
  temp_dir=$(mktemp -d)
  bin_dir="$temp_dir/bin"
  home_dir="$temp_dir/home"
  stdout_file="$temp_dir/stdout.txt"
  stderr_file="$temp_dir/stderr.txt"
  notifications_file="$temp_dir/notifications.log"
  state_file="$home_dir/Library/Application Support/Übersicht/servicenow-current-task.json"
  expected_message="ServiceNow capture failed: enable Safari's 'Allow JavaScript from Apple Events' setting, then try again"

  mkdir -p "$bin_dir" "${state_file:h}"

  print -r -- '{"taskText":"KEEP EXISTING","url":"https://old.example","capturedAt":"2026-04-16T00:00:00Z"}' > "$state_file"
  write_mock_osascript "$bin_dir" "$notifications_file"

  state_before=$(<"$state_file")

  if MOCK_JXA_JSON='{"url":"https://example.service-now.com/incident.do?sys_id=123","title":"INC0012345 Old Title","dom":{"ticketNumber":"INC0012345","shortDescription":"Fix VPN access for user"}}' \
    MOCK_JXA_STDERR='Safari got an error: JavaScript from Apple Events is turned off.' \
    HOME="$home_dir" PATH="$bin_dir:$PATH" zsh "$SCRIPT_PATH" >"$stdout_file" 2>"$stderr_file"; then
    fail "JXA permission failure should fail"
  fi

  assert_eq "" "$(<"$stdout_file")" "JXA permission failure should not print stdout"
  assert_eq "$expected_message" "$(<"$stderr_file")" "script should emit the actionable Safari permission failure"
  assert_contains "$(<"$notifications_file")" "$expected_message" "actionable JXA failure should trigger a notification"

  state_after=$(<"$state_file")
  assert_eq "$state_before" "$state_after" "JXA permission failure should preserve prior state"
}

run_nested_iframe_record_case() {
  local temp_dir bin_dir home_dir stdout_file stderr_file notifications_file state_file
  temp_dir=$(mktemp -d)
  bin_dir="$temp_dir/bin"
  home_dir="$temp_dir/home"
  stdout_file="$temp_dir/stdout.txt"
  stderr_file="$temp_dir/stderr.txt"
  notifications_file="$temp_dir/notifications.log"
  state_file="$home_dir/Library/Application Support/Übersicht/servicenow-current-task.json"

  mkdir -p "$bin_dir" "$home_dir"
  write_mock_osascript "$bin_dir" "$notifications_file"

  MOCK_JXA_JSON='{"url":"https://example.service-now.com/incident.do?sys_id=123","title":"INC0292497 | Incident | ServiceNow","dom":{"ticketNumber":"INC0292497","shortDescription":"Missing subfolder in Member Services UDrive"}}' \
    HOME="$home_dir" PATH="$bin_dir:$PATH" zsh "$SCRIPT_PATH" >"$stdout_file" 2>"$stderr_file"

  assert_eq "INC0292497 Missing subfolder in Member Services UDrive" "$(<"$stdout_file")" "script should prefer iframe-backed form fields over title fallback text"
  assert_eq "INC0292497 Missing subfolder in Member Services UDrive" "$(plutil -extract taskText raw -o - "$state_file")" "state file should store the real short description from the record form"
}

run_success_case
run_notification_failure_case
run_title_fallback_and_failure_case
run_failure_notification_failure_case
run_jxa_permission_failure_case
run_nested_iframe_record_case

print -- "PASS"
