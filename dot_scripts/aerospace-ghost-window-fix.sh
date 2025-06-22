#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Aerospace - Ghost Window Fix
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🧹

# Documentation:
# @raycast.description Cleans up ghost windows for aerospace on MacOS Beta
# @raycast.author wolfftech
# @raycast.authorURL https://raycast.com/wolfftech

ghost_window_ids=$(aerospace list-windows --all | grep -e '.*|.*| $' | awk '{print $1}')

for id in $ghost_window_ids ; do
    aerospace close --window-id $id
done
