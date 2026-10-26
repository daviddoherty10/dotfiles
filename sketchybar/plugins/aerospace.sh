#!/bin/bash
# Highlight the AeroSpace workspace receiving focus.
workspace="$1"
focused="${FOCUSED_WORKSPACE:-}"
if [ -z "$focused" ]; then
  focused="$(aerospace list-workspaces --focused 2>/dev/null)"
fi

if [ "$workspace" = "$focused" ]; then
  sketchybar --set "$NAME" background.drawing=on
else
  sketchybar --set "$NAME" background.drawing=off
fi
