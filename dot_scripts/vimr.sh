#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title VimR Clipboard
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Modify your clipboard buffer with VimR
# @raycast.author wolfftech
# @raycast.authorURL https://raycast.com/wolfftech

VIM=/opt/homebrew/bin/vimr
TMPFILE_DIR=/tmp/vim-anywhere
TMPFILE=$TMPFILE_DIR/last-buffer
VIM_OPTS='--wait -n'

mkdir -p $TMPFILE_DIR
touch $TMPFILE

app=$(osascript \
    -e 'tell application "System Events"
            copy (name of application processes whose frontmost is true) to stdout
        end tell')

$VIM $VIM_OPTS $TMPFILE

LANG=en_US.UTF-8 pbcopy < $TMPFILE
osascript -e "activate application \"$app\""
