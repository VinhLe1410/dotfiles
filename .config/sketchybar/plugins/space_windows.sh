#!/bin/bash

# Queries yabai for all windows on each space and sets the label
# to a strip of app-font icons.

PLUGIN_DIR="$(dirname "$0")"

CURRENT_SPACES="$(yabai -m query --displays | jq -r '.[].spaces | @sh')"

args=()
while read -r line; do
  for space in $line; do
    icon_strip=""
    apps=$(yabai -m query --windows --space "$space" | jq -r '.[].app' 2>/dev/null)
    if [ -n "$apps" ]; then
      while IFS= read -r app; do
        icon_strip+=" $("$PLUGIN_DIR/icon_map.sh" "$app")"
      done <<< "$apps"
    fi

    if [ -n "$icon_strip" ]; then
      args+=(--set space."$space" label="$icon_strip" label.drawing=on)
    else
      args+=(--set space."$space" label.drawing=off)
    fi
  done
done <<< "$CURRENT_SPACES"

if [ ${#args[@]} -gt 0 ]; then
  sketchybar -m "${args[@]}"
fi
