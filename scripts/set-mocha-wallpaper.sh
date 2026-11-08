#!/bin/bash
# Install the Great Wave Off Kanagawa Catppuccin Mocha wallpaper on macOS.
set -euo pipefail

WALLPAPER_DIR="${HOME}/Pictures/Wallpapers"
WALLPAPER_PATH="${WALLPAPER_DIR}/great-wave-catppuccin-mocha.png"
WALLPAPER_URL="https://raw.githubusercontent.com/mukhlisakbr/catppuccin-wallpaper/main/desktop/catppuccin-mocha.png"

if [[ "$(uname -s)" != "Darwin" ]]; then
  printf 'This wallpaper installer is for macOS only.\n' >&2
  exit 1
fi

mkdir -p "$WALLPAPER_DIR"
curl --fail --location --show-error --silent "$WALLPAPER_URL" --output "${WALLPAPER_PATH}.download"
mv "${WALLPAPER_PATH}.download" "$WALLPAPER_PATH"

# Sets the wallpaper for macOS desktops. System Events may ask for permission.
osascript - "$WALLPAPER_PATH" <<'APPLESCRIPT'
on run argv
  set wallpaperFile to POSIX file (item 1 of argv)
  tell application "System Events"
    repeat with d in desktops
      set picture of d to wallpaperFile
    end repeat
  end tell
end run
APPLESCRIPT

printf 'Wallpaper set: %s\n' "$WALLPAPER_PATH"
