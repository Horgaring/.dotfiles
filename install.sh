#!/usr/bin/env bash
# Установка окружения Hyprland.
#   ./install.sh               — пакеты + конфиги + палитра
#   ./install.sh --no-packages — только конфиги и палитра
#   ./install.sh --caelestia   — дополнительно поставить оболочку Caelestia
set -euo pipefail
cd "$(dirname "$0")"
source ./mappings.sh

WITH_PACKAGES=1
WITH_CAELESTIA=0
for arg in "$@"; do
	case "$arg" in
		--no-packages) WITH_PACKAGES=0 ;;
		--caelestia)   WITH_CAELESTIA=1 ;;
		*) echo "unknown option: $arg" >&2; exit 1 ;;
	esac
done

HYPRPAPER="$HOME/.config/hypr/hyprpaper.conf"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

# --- Пакеты -----------------------------------------------------------------
PACKAGES=(
	# Hyprland
	hyprland hyprlock hypridle hyprpaper hyprsunset hyprpicker hyprshot hyprpm
	xdg-desktop-portal-hyprland polkit-gnome
	# оболочка (waybar-вариант)
	waybar swaync swayosd wlogout vicinae-bin
	# тема
	matugen-bin adw-gtk-theme-git papirus-icon-theme papirus-folders bibata-cursor-theme-bin
	qt6ct darkly-bin nwg-look
	# шрифты
	ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols inter-font noto-fonts noto-fonts-emoji
	# утилиты
	kitty fastfetch starship btop cava yazi eza fzf jq
	cliphist wl-clipboard grim slurp brightnessctl playerctl libnotify
	# приложения
	zen-browser-bin dolphin
)
CAELESTIA_PACKAGES=(caelestia-shell caelestia-cli quickshell-git)

if (( WITH_PACKAGES )); then
	if ! command -v paru >/dev/null 2>&1; then
		echo "paru не найден, устанавливаю..."
		sudo pacman -S --needed --noconfirm base-devel git
		tmp=$(mktemp -d)
		git clone https://aur.archlinux.org/paru-bin.git "$tmp/paru-bin"
		(cd "$tmp/paru-bin" && makepkg -si --noconfirm)
	fi
	paru -S --needed "${PACKAGES[@]}"
	if (( WITH_CAELESTIA )); then
		echo "Caelestia: power-profiles-daemon заменит tlp, quickshell-git заменит quickshell"
		paru -S --needed "${CAELESTIA_PACKAGES[@]}"
	fi
fi

# --- Конфиги ----------------------------------------------------------------
backup() {
	local dest="$1"
	[ -e "$dest" ] || [ -L "$dest" ] || return 0
	local rel="${dest#"$HOME"/}"
	mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
	cp -a "$dest" "$BACKUP_DIR/$rel" 2>/dev/null || true
}

for pair in "${MAPPINGS[@]}"; do
	src="${pair%%|*}"
	dest="${pair#*|}"
	if [ ! -e "$src" ]; then
		echo "warning: '$src' нет в репозитории, пропускаю"
		continue
	fi
	backup "$dest"
	# битая ссылка (например, от старых dotfiles) — убрать
	[ -L "$(dirname "$dest")" ] && [ ! -e "$(dirname "$dest")" ] && rm "$(dirname "$dest")"
	mkdir -p "$(dirname "$dest")"
	if [ -d "$src" ]; then
		rm -rf "$dest"
		cp -r "$src" "$dest"
	else
		[ -L "$dest" ] && rm "$dest"
		cp -p "$src" "$dest"
	fi
	echo "installed: $dest"
done
[ -d "$BACKUP_DIR" ] && echo "бэкап заменённых конфигов: $BACKUP_DIR"

# --- hyprpaper ----------------------------------------------------------------
MONITORS=""
if command -v hyprctl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
	MONITORS=$(hyprctl monitors -j 2>/dev/null | jq -r '.[].name' 2>/dev/null || true)
fi
echo "preload = $WALLPAPER" > "$HYPRPAPER"
for MON in ${MONITORS:-""}; do
	cat >> "$HYPRPAPER" <<EOT
wallpaper {
    monitor = $MON
    path = $WALLPAPER
    fit_mode = cover
}
EOT
done
echo "splash = false" >> "$HYPRPAPER"

# --- Оболочка по умолчанию -----------------------------------------------------
[ -f "$HOME/.config/hypr/shell.lua" ] || \
	echo 'return "waybar"' > "$HOME/.config/hypr/shell.lua"

mkdir -p "$HOME/Pictures/Screenshots"

# --- Палитра (matugen) ---------------------------------------------------------
if command -v matugen >/dev/null 2>&1; then
	"$HOME/.config/hypr/scripts/theme.sh" || echo "warning: theme.sh завершился с ошибкой"
fi

# --- GTK / курсор / иконки -----------------------------------------------------
if command -v gsettings >/dev/null 2>&1; then
	gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-dark
	gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark
	gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Classic
	gsettings set org.gnome.desktop.interface cursor-size 24
	gsettings set org.gnome.desktop.interface color-scheme prefer-dark
	gsettings set org.gnome.desktop.interface font-name 'Inter 11'
fi

# --- vicinae -------------------------------------------------------------------
if command -v vicinae >/dev/null 2>&1; then
	systemctl --user enable --now vicinae 2>/dev/null || true
	vicinae theme set matugen 2>/dev/null || true
fi

# --- Запуск в текущей сессии ---------------------------------------------------
# Автозапуск (hyprland.start) срабатывает только при входе, поэтому если установка
# идёт из уже запущенного Hyprland — перезагружаем конфиг и поднимаем обои/панель сами.
if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ] && command -v hyprctl >/dev/null 2>&1; then
	start_if_missing() {
		command -v "$1" >/dev/null 2>&1 || return 0
		pgrep -x "$1" >/dev/null 2>&1 || setsid -f "$@" >/dev/null 2>&1
	}
	hyprctl reload >/dev/null 2>&1 || true
	hyprctl configerrors 2>/dev/null | grep -q . && \
		echo "warning: hyprctl configerrors сообщает об ошибках конфига" >&2
	start_if_missing hyprpaper
	start_if_missing hypridle
	shell=$(sed -n 's/^return "\(.*\)"$/\1/p' "$HOME/.config/hypr/shell.lua" 2>/dev/null)
	case "${shell:-waybar}" in
		waybar)
			start_if_missing waybar
			start_if_missing swayosd-server
			;;
		caelestia)
			pgrep -f 'caelestia shell' >/dev/null 2>&1 || setsid -f caelestia shell -d >/dev/null 2>&1
			;;
	esac
	echo "Готово! Обои и панель запущены."
else
	echo "Готово! Перезайди в сессию Hyprland."
fi
