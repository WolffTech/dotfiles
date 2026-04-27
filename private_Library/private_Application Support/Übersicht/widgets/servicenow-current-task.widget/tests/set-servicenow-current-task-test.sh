#!/bin/zsh

set -euo pipefail

ROOT_DIR=${0:A:h:h}
SCRIPT_PATH="$ROOT_DIR/scripts/set-servicenow-current-task.sh"

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

assert_ends_with() {
  local haystack="$1"
  local suffix="$2"
  local message="$3"

  if [[ "$haystack" != *"$suffix" ]]; then
    print -u2 -- "Missing suffix: $suffix"
    print -u2 -- "Actual text: $haystack"
    fail "$message"
  fi
}

make_test_home() {
  local temp_dir="$1"
  local bin_dir="$temp_dir/bin"
  local home_dir="$temp_dir/home"

  mkdir -p "$bin_dir" "$home_dir"
  cat > "$bin_dir/osascript" <<EOF
#!/bin/zsh
set -euo pipefail
print -r -- "\$*" >> "$temp_dir/osascript.log"
EOF
  chmod +x "$bin_dir/osascript"
}

run_success_case() {
  local temp_dir
  temp_dir=$(mktemp -d)
  local bin_dir="$temp_dir/bin"
  local home_dir="$temp_dir/home"
  local stdout_file="$temp_dir/stdout.txt"
  local stderr_file="$temp_dir/stderr.txt"
  local osascript_log="$temp_dir/osascript.log"
  local state_file="$home_dir/Library/Application Support/Übersicht/servicenow-current-task.json"

  make_test_home "$temp_dir"
  : > "$osascript_log"

  [[ -x "$SCRIPT_PATH" ]] || fail "set script is missing or not executable: $SCRIPT_PATH"

  HOME="$home_dir" PATH="$bin_dir:$PATH" zsh "$SCRIPT_PATH" "  Testing 1234  " >"$stdout_file" 2>"$stderr_file"

  assert_eq "Set current task: Testing 1234" "$(<"$stdout_file")" "set script should print the Raycast HUD message to stdout"
  assert_eq "" "$(<"$stderr_file")" "set script should not write stderr on success"
  [[ ! -s "$osascript_log" ]] || fail "set script should not invoke osascript"
  assert_eq "Testing 1234" "$(plutil -extract taskText raw -o - "$state_file")" "set script should write the trimmed task text"
  assert_eq "" "$(plutil -extract url raw -o - "$state_file")" "set script should clear the url"
  local captured_at
  captured_at=$(plutil -extract capturedAt raw -o - "$state_file")
  assert_contains "$captured_at" "T" "set script should write an ISO timestamp"
  assert_ends_with "$captured_at" "Z" "set script should write a UTC timestamp"
}

run_empty_input_case() {
  local temp_dir
  temp_dir=$(mktemp -d)
  local bin_dir="$temp_dir/bin"
  local home_dir="$temp_dir/home"
  local stdout_file="$temp_dir/stdout.txt"
  local stderr_file="$temp_dir/stderr.txt"
  local state_file="$home_dir/Library/Application Support/Übersicht/servicenow-current-task.json"

  make_test_home "$temp_dir"

  mkdir -p "${state_file:h}"
  print -r -- '{"taskText":"KEEP EXISTING","url":"https://old.example","capturedAt":"2026-04-16T00:00:00Z"}' > "$state_file"

  if HOME="$home_dir" PATH="$bin_dir:$PATH" zsh "$SCRIPT_PATH" "   " >"$stdout_file" 2>"$stderr_file"; then
    fail "set script should fail for whitespace-only input"
  fi

  assert_eq "" "$(<"$stdout_file")" "set script should not write stdout on validation failure"
  assert_eq "Set current task failed: task text cannot be empty" "$(<"$stderr_file")" "set script should explain empty input failure"
  assert_eq "KEEP EXISTING" "$(plutil -extract taskText raw -o - "$state_file")" "set script should preserve task text for empty input"
  assert_eq "https://old.example" "$(plutil -extract url raw -o - "$state_file")" "set script should preserve url for empty input"
  assert_eq "2026-04-16T00:00:00Z" "$(plutil -extract capturedAt raw -o - "$state_file")" "set script should preserve capturedAt for empty input"
}

run_success_case
run_empty_input_case

print -- "PASS"
