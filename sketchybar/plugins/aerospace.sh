#!/bin/bash
# Single fixed workspace indicator: only the label changes, never its position.
focused="${FOCUSED_WORKSPACE:-}"
if [ -z "$focused" ]; then
  focused="$(aerospace list-workspaces --focused 2>/dev/null)"
fi
[ -n "$focused" ] && sketchybar --set "$NAME" label="$focused"
