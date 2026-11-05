#!/usr/bin/env bash
# Перегенерировать палитру.
#   theme.sh             — бирюзовая палитра под текущие обои
#   theme.sh <картинка>  — палитра из другой картинки
set -e
if [[ -n "$1" ]]; then
  matugen image "$1" -m dark --prefer saturation -t scheme-expressive
else
  matugen color hex "#6fa3a8" -m dark -t scheme-expressive
fi
hyprctl reload >/dev/null 2>&1 || true
pkill -SIGUSR2 waybar 2>/dev/null || true
pkill -SIGUSR1 kitty 2>/dev/null || true
swaync-client -rs >/dev/null 2>&1 || true
