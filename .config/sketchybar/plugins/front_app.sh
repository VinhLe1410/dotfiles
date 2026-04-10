#!/bin/bash

if [ "$SENDER" = "front_app_switched" ]; then
  PLUGIN_DIR="$(dirname "$0")"
  APP_ICON=$("$PLUGIN_DIR/icon_map.sh" "$INFO")

  sketchybar --set "$NAME" label="$INFO" icon="$APP_ICON"
fi
