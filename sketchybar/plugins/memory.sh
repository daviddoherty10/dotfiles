#!/bin/sh
# Estimate available RAM (free + inactive + speculative) on macOS.
# Uses vm_stat and physical RAM rather than parsing memory_pressure output.
vm_output="$(/usr/bin/vm_stat 2>/dev/null)"
total_bytes="$(/usr/sbin/sysctl -n hw.memsize 2>/dev/null)"
page_size="$(printf '%s\n' "$vm_output" | /usr/bin/sed -n '1s/.*page size of \([0-9][0-9]*\) bytes.*/\1/p')"
available_pages="$(printf '%s\n' "$vm_output" | /usr/bin/awk '/^Pages (free|inactive|speculative):/ { gsub(/\./, "", $NF); sum += $NF } END { printf "%.0f", sum }')"

case "$total_bytes:$page_size:$available_pages" in
  *[!0-9:]*|:*|*::*|*:0:*|0:*|*:) sketchybar --set "$NAME" label="N/A"; exit 0 ;;
esac
percent="$(/usr/bin/awk -v pages="$available_pages" -v size="$page_size" -v total="$total_bytes" 'BEGIN { if (total <= 0) exit 1; p = 100 * pages * size / total; if (p > 100) p = 100; if (p < 0) p = 0; printf "%.0f", p }')"
sketchybar --set "$NAME" label="${percent:-N/A}%"
