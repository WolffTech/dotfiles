#!/bin/zsh

set -euo pipefail

ROOT_DIR=${0:A:h:h}
SCRIPT_PATH="$ROOT_DIR/scripts/clear-servicenow-current-task.sh"

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

temp_dir=$(mktemp -d)
bin_dir="$temp_dir/bin"
home_dir="$temp_dir/home"
stdout_file="$temp_dir/stdout.txt"
stderr_file="$temp_dir/stderr.txt"
notifications_file="$temp_dir/notifications.log"
state_file="$home_dir/Library/Application Support/Übersicht/servicenow-current-task.json"

mkdir -p "$bin_dir" "$home_dir"

cat > "$bin_dir/osascript" <<EOF
#!/bin/zsh
set -euo pipefail
print -r -- "\$*" >> "$notifications_file"
EOF
chmod +x "$bin_dir/osascript"

[[ -x "$SCRIPT_PATH" ]] || fail "clear script is missing: $SCRIPT_PATH"

HOME="$home_dir" PATH="$bin_dir:$PATH" zsh "$SCRIPT_PATH" >"$stdout_file" 2>"$stderr_file"

assert_eq "" "$(<"$stdout_file")" "clear script should not print stdout"
assert_eq "" "$(<"$stderr_file")" "clear script should not write stderr"
assert_contains "$(<"$notifications_file")" "Cleared current task" "clear script should trigger a notification"
assert_eq "General Work and Meetings" "$(plutil -extract taskText raw -o - "$state_file")" "clear script should write the default task text"
assert_eq "" "$(plutil -extract url raw -o - "$state_file")" "clear script should clear the url"
assert_contains "$(plutil -extract capturedAt raw -o - "$state_file")" "T" "clear script should write an ISO timestamp"

print -- "PASS"
