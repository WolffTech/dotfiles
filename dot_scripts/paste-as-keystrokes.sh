#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Paste as Keystrokes
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Paste your clipboard as keystrokes
# @raycast.author wolfftech
# @raycast.authorURL https://raycast.com/wolfftech

osascript -e 'tell application "System Events" to keystroke the clipboard as text'

