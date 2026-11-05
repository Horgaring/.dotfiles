#!/usr/bin/env bash
# Переключить оболочку рабочего стола: waybar | caelestia
set -euo pipefail
shell="${1:-}"
dir="$HOME/.config/hypr"
case "$shell" in
  waybar|caelestia) ;;
  *) echo "usage: $(basename "$0") waybar|caelestia" >&2; exit 1 ;;
esac
[[ -f "$dir/shell/$shell.lua" ]] || { echo "нет $dir/shell/$shell.lua" >&2; exit 1; }

echo "return \"$shell\"" > "$dir/shell.lua"

# Остановить всё от обеих оболочек
pkill -x waybar 2>/dev/null || true
pkill -x swaync 2>/dev/null || true
pkill -x swayosd-server 2>/dev/null || true
pkill -f 'qs -c caelestia|quickshell.*caelestia' 2>/dev/null || true
caelestia shell -k >/dev/null 2>&1 || true
sleep 0.5

hyprctl reload >/dev/null

# exec-once не перезапускается при reload — стартуем вручную
case "$shell" in
  waybar)
    setsid -f waybar >/dev/null 2>&1
    command -v swayosd-server >/dev/null && setsid -f swayosd-server >/dev/null 2>&1
    ;;
  caelestia)
    setsid -f caelestia shell -d >/dev/null 2>&1
    sleep 2
    caelestia wallpaper -f "$HOME/Pictures/Wallpapers/wallpaper.jpeg" >/dev/null 2>&1 || true
    ;;
esac
echo "оболочка: $shell"
