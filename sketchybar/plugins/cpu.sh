#!/bin/bash

# The existing executable CPU plugin also updates the memory widget.
# Use the total free-memory estimate from macOS memory_pressure.
if [ "$NAME" = "memory" ]; then
  free="$(memory_pressure -Q 2>/dev/null | awk '/System-wide free memory percentage:/ { gsub(/%/, "", $NF); print $NF; exit }')"
  case "$free" in
    ""|*[!0-9]*) sketchybar --set "$NAME" label="N/A" ;;
    *) sketchybar --set "$NAME" label="${free}% free" ;;
  esac
  exit 0
fi

CORE_COUNT=$(sysctl -n machdep.cpu.thread_count)
CPU_INFO=$(ps -eo pcpu,user)
CPU_SYS=$(echo "$CPU_INFO" | grep -v $(whoami) | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")
CPU_USER=$(echo "$CPU_INFO" | grep $(whoami) | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")

CPU_PERCENT="$(echo "$CPU_SYS $CPU_USER" | awk '{printf "%.0f\n", ($1 + $2)*100}')"

sketchybar --set $NAME label="$CPU_PERCENT%"
