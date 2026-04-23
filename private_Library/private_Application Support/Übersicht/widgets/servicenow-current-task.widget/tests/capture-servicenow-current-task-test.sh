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
  local osascript_log="$2"

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
  [[ "\$jxa_script" == *"const valueFromFieldContainer = (fieldName, blockedTexts = []) => {"* ]] || {
    print -u2 -- "missing scoped field container helper"
    exit 1
  }
  [[ "\$jxa_script" != *'\${fieldName}'* ]] || {
    print -u2 -- "unexpected nested template interpolation in generated JXA"
    exit 1
  }
  [[ "\$jxa_script" == *"const blocked = new Set(blockedTexts.map((value) => textOf(value)).filter(Boolean));"* ]] || {
    print -u2 -- "missing blocked text normalization for field helper"
    exit 1
  }
  [[ "\$jxa_script" == *"const treeWalker = recordDocument.createTreeWalker(container, NodeFilter.SHOW_TEXT);"* ]] || {
    print -u2 -- "missing scoped text walker for read-only fields"
    exit 1
  }
  [[ "\$jxa_script" == *"const candidate = textOf(current.nodeValue);"* ]] || {
    print -u2 -- "missing text candidate normalization"
    exit 1
  }
  [[ "\$jxa_script" == *"if (candidate && !blocked.has(candidate)) return candidate;"* ]] || {
    print -u2 -- "missing blocked text filter for read-only fields"
    exit 1
  }
  [[ "\$jxa_script" == *"const valueFromLabeledField = (labelTexts) => {"* ]] || {
    print -u2 -- "missing label-linked field helper"
    exit 1
  }
  [[ "\$jxa_script" == *"const wantedLabels = new Set(labelTexts.map((value) => textOf(value)).filter(Boolean));"* ]] || {
    print -u2 -- "missing label normalization for labeled field helper"
    exit 1
  }
  [[ "\$jxa_script" == *"const labels = root.querySelectorAll ? Array.from(root.querySelectorAll('label[for]')) : [];"* ]] || {
    print -u2 -- "missing label lookup for labeled field helper"
    exit 1
  }
  [[ "\$jxa_script" == *"const input = root.getElementById ? root.getElementById(label.getAttribute('for')) : null;"* ]] || {
    print -u2 -- "missing linked input lookup for labeled field helper"
    exit 1
  }
  [[ "\$jxa_script" == *"'[data-field-name=\"number\"] input',"* ]] || {
    print -u2 -- "missing workspace number input selector"
    exit 1
  }
  [[ "\$jxa_script" == *"'[data-field-name=\"number\"] textarea',"* ]] || {
    print -u2 -- "missing workspace number textarea selector"
    exit 1
  }
  [[ "\$jxa_script" == *"'[data-field-name=\"number\"] [value]',"* ]] || {
    print -u2 -- "missing workspace number value selector"
    exit 1
  }
  [[ "\$jxa_script" != *"'[name=\"number\"]',"* ]] || {
    print -u2 -- "unexpected broad number name selector"
    exit 1
  }
  [[ "\$jxa_script" == *"const ticketNumber = pickValue("* ]] || {
    print -u2 -- "missing ticket number value lookup"
    exit 1
  }
  [[ "\$jxa_script" == *"|| valueFromFieldContainer('number', ['Number']);"* ]] || {
    print -u2 -- "missing scoped ticket number read-only fallback"
    exit 1
  }
  [[ "\$jxa_script" != *"'[data-field-name=\"number\"]',"* ]] || {
    print -u2 -- "unexpected broad workspace number container selector"
    exit 1
  }
  [[ "\$jxa_script" != *"'[id*=\"number\"]',"* ]] || {
    print -u2 -- "unexpected broad number id selector"
    exit 1
  }
  [[ "\$jxa_script" == *"'[data-field-name=\"short_description\"] input',"* ]] || {
    print -u2 -- "missing workspace short description input selector"
    exit 1
  }
  [[ "\$jxa_script" == *"'[data-field-name=\"short_description\"] textarea',"* ]] || {
    print -u2 -- "missing workspace short description textarea selector"
    exit 1
  }
  [[ "\$jxa_script" == *"'[data-field-name=\"short_description\"] [value]',"* ]] || {
    print -u2 -- "missing workspace short description value selector"
    exit 1
  }
  [[ "\$jxa_script" != *"'[name=\"short_description\"]',"* ]] || {
    print -u2 -- "unexpected broad short description name selector"
    exit 1
  }
  [[ "\$jxa_script" == *"const shortDescription = pickValue("* ]] || {
    print -u2 -- "missing short description value lookup"
    exit 1
  }
  [[ "\$jxa_script" == *"valueFromFieldContainer('short_description', ['Short description'])"* ]] || {
    print -u2 -- "missing scoped short description read-only fallback"
    exit 1
  }
  [[ "\$jxa_script" == *"valueFromLabeledField(['Short Description', 'Short description'])"* ]] || {
    print -u2 -- "missing labeled short description fallback"
    exit 1
  }
  [[ "\$jxa_script" != *"'[data-field-name=\"short_description\"]',"* ]] || {
    print -u2 -- "unexpected broad workspace short description container selector"
    exit 1
  }
  [[ "\$jxa_script" != *"'[id*=\"short_description\"]',"* ]] || {
    print -u2 -- "unexpected broad short description id selector"
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
  print -r -- "\$*" >> "$osascript_log"
  exit 0
fi
EOF
  chmod +x "$bin_dir/osascript"
}

run_success_case() {
  local temp_dir bin_dir home_dir stdout_file stderr_file osascript_log state_file plutil_output
  temp_dir=$(mktemp -d)
  bin_dir="$temp_dir/bin"
  home_dir="$temp_dir/home"
  stdout_file="$temp_dir/stdout.txt"
  stderr_file="$temp_dir/stderr.txt"
  osascript_log="$temp_dir/osascript.log"
  state_file="$home_dir/Library/Application Support/Übersicht/servicenow-current-task.json"

  mkdir -p "$bin_dir" "$home_dir"
  write_mock_osascript "$bin_dir" "$osascript_log"

  [[ -x "$SCRIPT_PATH" ]] || fail "capture script is missing: $SCRIPT_PATH"

  MOCK_JXA_JSON='{"url":"https://example.service-now.com/incident.do?sys_id=123","title":"INC0012345 Old Title","dom":{"ticketNumber":"INC0012345","shortDescription":"Fix VPN access for user"}}' \
    HOME="$home_dir" PATH="$bin_dir:$PATH" zsh "$SCRIPT_PATH" >"$stdout_file" 2>"$stderr_file"

  assert_eq "Captured: INC0012345 Fix VPN access for user" "$(<"$stdout_file")" "script should print Raycast HUD message with captured task text"
  assert_eq "" "$(<"$stderr_file")" "success case should not write stderr"
  [[ ! -f "$osascript_log" || ! -s "$osascript_log" ]] || fail "success should not invoke osascript for macOS notifications"

  plutil_output=$(plutil -extract taskText raw -o - "$state_file")
  assert_eq "INC0012345 Fix VPN access for user" "$plutil_output" "state file should store task text"
  assert_eq "https://example.service-now.com/incident.do?sys_id=123" "$(plutil -extract url raw -o - "$state_file")" "state file should store url"
  assert_contains "$(plutil -extract capturedAt raw -o - "$state_file")" "T" "state file should store ISO timestamp"
  [[ ! -e "$home_dir/Library/Application Support/Uebersicht/servicenow-current-task.json" ]] || fail "script should not create ASCII Uebersicht state path"
}


run_title_fallback_and_failure_case() {
  local temp_dir bin_dir home_dir stdout_file stderr_file osascript_log state_file state_before state_after
  temp_dir=$(mktemp -d)
  bin_dir="$temp_dir/bin"
  home_dir="$temp_dir/home"
  stdout_file="$temp_dir/stdout.txt"
  stderr_file="$temp_dir/stderr.txt"
  osascript_log="$temp_dir/osascript.log"
  state_file="$home_dir/Library/Application Support/Übersicht/servicenow-current-task.json"

  mkdir -p "$bin_dir" "${state_file:h}"

  print -r -- '{"taskText":"KEEP EXISTING","url":"https://old.example","capturedAt":"2026-04-16T00:00:00Z"}' > "$state_file"
  write_mock_osascript "$bin_dir" "$osascript_log"
  state_before=$(<"$state_file")

  if MOCK_JXA_JSON='{"url":"https://example.service-now.com/incident.do?sys_id=123","title":"INC0019999 - Restore SSO access | ServiceNow","dom":{"ticketNumber":"","shortDescription":""}}' \
    HOME="$home_dir" PATH="$bin_dir:$PATH" zsh "$SCRIPT_PATH" >"$stdout_file" 2>"$stderr_file"; then
    fail "ServiceNow page without a DOM short description should fail"
  fi

  assert_eq "ServiceNow capture failed: no short description found" "$(<"$stderr_file")" "script should require a DOM-backed short description"
  state_after=$(<"$state_file")
  assert_eq "$state_before" "$state_after" "missing short description failure should preserve prior state"

  if MOCK_JXA_JSON='{"url":"https://example.com/","title":"Example Domain","dom":{"ticketNumber":"","shortDescription":""}}' \
    HOME="$home_dir" PATH="$bin_dir:$PATH" zsh "$SCRIPT_PATH" >"$stdout_file" 2>"$stderr_file"; then
    fail "non-ServiceNow page should fail"
  fi

  assert_eq "ServiceNow capture failed: active Safari tab is not a recognized ticket" "$(<"$stderr_file")" "script should emit the non-ServiceNow failure"
  [[ ! -f "$osascript_log" || ! -s "$osascript_log" ]] || fail "failure should not invoke osascript for macOS notifications (Raycast handles HUD from stderr)"

  state_after=$(<"$state_file")
  assert_eq "$state_before" "$state_after" "failure should preserve prior state"
}

run_jxa_permission_failure_case() {
  local temp_dir bin_dir home_dir stdout_file stderr_file osascript_log state_file state_before state_after expected_message
  temp_dir=$(mktemp -d)
  bin_dir="$temp_dir/bin"
  home_dir="$temp_dir/home"
  stdout_file="$temp_dir/stdout.txt"
  stderr_file="$temp_dir/stderr.txt"
  osascript_log="$temp_dir/osascript.log"
  state_file="$home_dir/Library/Application Support/Übersicht/servicenow-current-task.json"
  expected_message="ServiceNow capture failed: enable Safari's 'Allow JavaScript from Apple Events' setting, then try again"

  mkdir -p "$bin_dir" "${state_file:h}"

  print -r -- '{"taskText":"KEEP EXISTING","url":"https://old.example","capturedAt":"2026-04-16T00:00:00Z"}' > "$state_file"
  write_mock_osascript "$bin_dir" "$osascript_log"

  state_before=$(<"$state_file")

  if MOCK_JXA_JSON='{"url":"https://example.service-now.com/incident.do?sys_id=123","title":"INC0012345 Old Title","dom":{"ticketNumber":"INC0012345","shortDescription":"Fix VPN access for user"}}' \
    MOCK_JXA_STDERR='Safari got an error: JavaScript from Apple Events is turned off.' \
    HOME="$home_dir" PATH="$bin_dir:$PATH" zsh "$SCRIPT_PATH" >"$stdout_file" 2>"$stderr_file"; then
    fail "JXA permission failure should fail"
  fi

  assert_eq "" "$(<"$stdout_file")" "JXA permission failure should not print stdout"
  assert_eq "$expected_message" "$(<"$stderr_file")" "script should emit the actionable Safari permission failure"
  [[ ! -f "$osascript_log" || ! -s "$osascript_log" ]] || fail "JXA permission failure should not invoke osascript for macOS notifications"

  state_after=$(<"$state_file")
  assert_eq "$state_before" "$state_after" "JXA permission failure should preserve prior state"
}

run_nested_iframe_record_case() {
  local temp_dir bin_dir home_dir stdout_file stderr_file osascript_log state_file
  temp_dir=$(mktemp -d)
  bin_dir="$temp_dir/bin"
  home_dir="$temp_dir/home"
  stdout_file="$temp_dir/stdout.txt"
  stderr_file="$temp_dir/stderr.txt"
  osascript_log="$temp_dir/osascript.log"
  state_file="$home_dir/Library/Application Support/Übersicht/servicenow-current-task.json"

  mkdir -p "$bin_dir" "$home_dir"
  write_mock_osascript "$bin_dir" "$osascript_log"

  MOCK_JXA_JSON='{"url":"https://example.service-now.com/incident.do?sys_id=123","title":"INC0292497 | Incident | ServiceNow","dom":{"ticketNumber":"INC0292497","shortDescription":"Missing subfolder in Member Services UDrive"}}' \
    HOME="$home_dir" PATH="$bin_dir:$PATH" zsh "$SCRIPT_PATH" >"$stdout_file" 2>"$stderr_file"

  assert_eq "Captured: INC0292497 Missing subfolder in Member Services UDrive" "$(<"$stdout_file")" "script should prefer iframe-backed form fields over title fallback text"
  assert_eq "INC0292497 Missing subfolder in Member Services UDrive" "$(plutil -extract taskText raw -o - "$state_file")" "state file should store the real short description from the record form"
}

run_workspace_dom_short_description_case() {
  local temp_dir bin_dir home_dir stdout_file stderr_file osascript_log state_file
  temp_dir=$(mktemp -d)
  bin_dir="$temp_dir/bin"
  home_dir="$temp_dir/home"
  stdout_file="$temp_dir/stdout.txt"
  stderr_file="$temp_dir/stderr.txt"
  osascript_log="$temp_dir/osascript.log"
  state_file="$home_dir/Library/Application Support/Übersicht/servicenow-current-task.json"

  mkdir -p "$bin_dir" "$home_dir"
  write_mock_osascript "$bin_dir" "$osascript_log"

  MOCK_JXA_JSON='{"url":"https://example.service-now.com/now/sow/record/incident/123","title":"INC0292497 - Service Operations Workspace","dom":{"ticketNumber":"INC0292497","shortDescription":"Missing subfolder in Member Services UDrive"}}' \
    HOME="$home_dir" PATH="$bin_dir:$PATH" zsh "$SCRIPT_PATH" >"$stdout_file" 2>"$stderr_file"

  assert_eq "Captured: INC0292497 Missing subfolder in Member Services UDrive" "$(<"$stdout_file")" "workspace DOM short description should be preferred over generic title text"
  assert_eq "" "$(<"$stderr_file")" "workspace DOM short description case should not write stderr"
  assert_eq "INC0292497 Missing subfolder in Member Services UDrive" "$(plutil -extract taskText raw -o - "$state_file")" "workspace DOM short description should be written to state"
}

run_workspace_title_ticket_fallback_with_dom_short_description_case() {
  local temp_dir bin_dir home_dir stdout_file stderr_file osascript_log state_file
  temp_dir=$(mktemp -d)
  bin_dir="$temp_dir/bin"
  home_dir="$temp_dir/home"
  stdout_file="$temp_dir/stdout.txt"
  stderr_file="$temp_dir/stderr.txt"
  osascript_log="$temp_dir/osascript.log"
  state_file="$home_dir/Library/Application Support/Übersicht/servicenow-current-task.json"

  mkdir -p "$bin_dir" "$home_dir"
  write_mock_osascript "$bin_dir" "$osascript_log"

  MOCK_JXA_JSON='{"url":"https://example.service-now.com/now/sow/record/incident/123","title":"INC0292497 - Service Operations Workspace","dom":{"ticketNumber":"","shortDescription":"Missing subfolder in Member Services UDrive"}}' \
    HOME="$home_dir" PATH="$bin_dir:$PATH" zsh "$SCRIPT_PATH" >"$stdout_file" 2>"$stderr_file"

  assert_eq "Captured: INC0292497 Missing subfolder in Member Services UDrive" "$(<"$stdout_file")" "workspace ticket number should still fall back from title when DOM short description exists"
  assert_eq "" "$(<"$stderr_file")" "workspace title ticket fallback case should not write stderr"
  assert_eq "INC0292497 Missing subfolder in Member Services UDrive" "$(plutil -extract taskText raw -o - "$state_file")" "workspace title ticket fallback should be written to state"
}

run_workspace_generic_title_failure_case() {
  local temp_dir bin_dir home_dir stdout_file stderr_file osascript_log state_file state_before state_after
  temp_dir=$(mktemp -d)
  bin_dir="$temp_dir/bin"
  home_dir="$temp_dir/home"
  stdout_file="$temp_dir/stdout.txt"
  stderr_file="$temp_dir/stderr.txt"
  osascript_log="$temp_dir/osascript.log"
  state_file="$home_dir/Library/Application Support/Übersicht/servicenow-current-task.json"

  mkdir -p "$bin_dir" "${state_file:h}"
  print -r -- '{"taskText":"KEEP EXISTING","url":"https://old.example","capturedAt":"2026-04-16T00:00:00Z"}' > "$state_file"
  write_mock_osascript "$bin_dir" "$osascript_log"

  state_before=$(<"$state_file")

  if MOCK_JXA_JSON='{"url":"https://example.service-now.com/now/sow/record/incident/123","title":"INC0292497 - Service Operations Workspace","dom":{"ticketNumber":"","shortDescription":""}}' \
    HOME="$home_dir" PATH="$bin_dir:$PATH" zsh "$SCRIPT_PATH" >"$stdout_file" 2>"$stderr_file"; then
    fail "generic workspace title should not be accepted as a short description"
  fi

  assert_eq "ServiceNow capture failed: no short description found" "$(<"$stderr_file")" "workspace generic title case should fail with missing short description"
  state_after=$(<"$state_file")
  assert_eq "$state_before" "$state_after" "workspace generic title failure should preserve the prior state"
}

run_success_case
run_title_fallback_and_failure_case
run_jxa_permission_failure_case
run_nested_iframe_record_case
run_workspace_dom_short_description_case
run_workspace_title_ticket_fallback_with_dom_short_description_case
run_workspace_generic_title_failure_case

print -- "PASS"
