#!/bin/bash

mouse_clicked() {
  yabai -m space --focus "$SID" 2>/dev/null
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked ;;
  *) sketchybar --set "$NAME" icon.highlight=$SELECTED ;;
esac
