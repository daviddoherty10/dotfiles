#!/bin/sh
# Report the macOS memory pressure tool's available memory estimate.
available="$(memory_pressure -Q 2>/dev/null | awk '/System-wide free memory percentage:/ { gsub(/%/, "", $NF); print $NF; exit }')"
case "$available" in
  ''|*[!0-9]*) exit 0 ;;
esac
sketchybar --set "$NAME" label="${available}% free"
