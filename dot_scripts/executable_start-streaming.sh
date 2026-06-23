#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Start Streaming
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🎥

# Documentation:
# @raycast.author wolfftech
# @raycast.authorURL https://raycast.com/wolfftech

echo "Setting streaming focus..."
shortcuts run "Set streaming focus"

echo "Purging command line history..."

yes all | history delete --contains "SHARED"
yes all | history delete --contains ".osu."
yes all | history delete --contains "ping"
yes all | history delete --contains "youtube."
yes all | history delete --contains "google."
yes all | history delete --contains "cheat"
yes all | history delete --contains "history delete"
yes all | history delete --contains "yt-dlp"
yes all | history delete --conatins "clear"

echo "Killing unnecessary apps..."

pkill -x "Mail"
pkill -x "Messages"
pkill -x "Fantastical"
pkill -x "Transmit"
pkill -x "Keychain Access"
pkill -x "IINA"

echo "Emptying trash..."

rm -rf ~/.Trash/*

echo "Deleting clipboard history..."

pbcopy < /dev/null

echo "Oepning OBS..."

open /Applications/OBS.app
