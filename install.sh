#!/usr/bin/bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1

# --- Settings ---------------------------------------------------------------
WALLPAPER="$HOME/Pictures/Wallpapers/wallpaper.jpeg"
HYPRPAPER="$HOME/.config/hypr/hyprpaper.conf"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

# src (relative to repo) -> dest (absolute). Files and directories both work.
MAPPINGS=(
	".config/hyprland.conf|$HOME/.config/hypr/hyprland.conf"
	".config/hyprlock.conf|$HOME/.config/hypr/hyprlock.conf"
	".config/hypridle.conf|$HOME/.config/hypr/hypridle.conf"
	".vimrc|$HOME/.vimrc"
	".config/starship.toml|$HOME/.config/starship.toml"
	"waybar|$HOME/.config/waybar"
	".config/fastfetch|$HOME/.config/fastfetch"
	".config/kitty/|$HOME/.config/kitty/"
	"Wallpapers/wallpaper.jpeg|$WALLPAPER"
)

# --- Dependency checks ------------------------------------------------------
command -v hyprctl >/dev/null 2>&1 || echo "warning: hyprctl not found — monitor detection skipped"
command -v jq      >/dev/null 2>&1 || echo "warning: jq not found — monitor detection skipped"

# --- Directories ------------------------------------------------------------
mkdir -p "$HOME/.config/hypr" "$HOME/Pictures/Wallpapers"

# --- Backup helper ----------------------------------------------------------
backup() {
	local dest="$1"
	[ -e "$dest" ] || return 0
	local rel="${dest#"$HOME"/}"
	mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
	cp -r "$dest" "$BACKUP_DIR/$rel"
}

# --- Copy files / directories ----------------------------------------------
for pair in "${MAPPINGS[@]}"; do
	src="${pair%%|*}"
	dest="${pair#*|}"
	if [ ! -e "$src" ]; then
		echo "warning: source '$src' missing, skipping"
		continue
	fi
	backup "$dest"
	mkdir -p "$(dirname "$dest")"
	if [ -d "$src" ]; then
		rm -rf "$dest"
		cp -r "$src" "$dest"
	else
		cp -p "$src" "$dest"
	fi
	echo "installed: $dest"
done

[ -d "$BACKUP_DIR" ] && echo "backup of replaced configs: $BACKUP_DIR"

# --- Generate Hyprpaper config ----------------------------------------------
MONITORS=""
if command -v hyprctl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
	MONITORS=$(hyprctl monitors -j 2>/dev/null | jq -r '.[].name' 2>/dev/null || true)
fi

echo "preload = $WALLPAPER" > "$HYPRPAPER"

if [ -z "$MONITORS" ]; then
	cat >> "$HYPRPAPER" <<EOF
wallpaper {
    monitor =
    path = $WALLPAPER
    fit_mode = cover
}
EOF
else
	for MON in $MONITORS; do
		cat >> "$HYPRPAPER" <<EOF
wallpaper {
    monitor = $MON
    path = $WALLPAPER
    fit_mode = cover
}
EOF
	done
fi

echo "splash = false" >> "$HYPRPAPER"

./vicinae-setup

echo "Done!"
