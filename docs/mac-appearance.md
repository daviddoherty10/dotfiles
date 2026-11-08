# macOS appearance — Catppuccin Mocha

This repository keeps the existing AeroSpace, tmux, and Neovim keybindings intact.

## Wallpaper

Selected: [Catppuccin Mocha desktop wallpaper](https://github.com/mukhlisakbr/catppuccin-wallpaper/blob/main/desktop/catppuccin-mocha.png), 2560×1600, from [mukhlisakbr/catppuccin-wallpaper](https://github.com/mukhlisakbr/catppuccin-wallpaper).

To download it to `~/Pictures/Wallpapers` and set it as the desktop background:

```sh
bash ~/.config/scripts/set-mocha-wallpaper.sh
```

The script is **opt-in**: cloning the repo does not change your wallpaper. macOS may request permission for System Events to change the background. Requires `curl`. Image comes from the upstream wallpaper project, not this repository.

## Font

Alacritty already uses **MesloLGS Nerd Font Mono** at 18 pt. SketchyBar now uses the same font family (15 pt icons, 13 pt labels). Neovim inherits the font from Alacritty. Your Powerlevel10k prompt remains compatible with MesloLGS.

Verify MesloLGS Nerd Font Mono is installed before reloading SketchyBar. If missing, install it through the Powerlevel10k font instructions: https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k.

## Prompt

The tracked `zsh/p10k-minimal.zsh` is sourced **after** your personal `~/.p10k.zsh`; it only changes prompt segment selection:

- Left: directory and Git status
- Right: last command status and time

This keeps local theme customization and custom shortcuts in place. To revert only the compact prompt, comment out its `source` line in `zsh/.zshrc` and open a new terminal. Source your updated Zsh file only through Zsh; don't source it through tmux.

## Test

```sh
git pull --rebase
bash ~/.config/scripts/set-mocha-wallpaper.sh
sketchybar --reload
exec zsh
```

The wallpaper may look different on a scaled MacBook display. Adjust macOS wallpaper appearance in System Settings if needed.
