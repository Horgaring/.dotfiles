# Общий список: путь в репозитории | путь в системе. Используется install.sh и collect.sh
WALLPAPER="$HOME/Pictures/Wallpapers/wallpaper.jpeg"

MAPPINGS=(
	".config/hypr/hyprland.lua|$HOME/.config/hypr/hyprland.lua"
	".config/hypr/hyprlock.conf|$HOME/.config/hypr/hyprlock.conf"
	".config/hypr/hypridle.conf|$HOME/.config/hypr/hypridle.conf"
	".config/hypr/hyprsunset.conf|$HOME/.config/hypr/hyprsunset.conf"
	".config/hypr/scripts|$HOME/.config/hypr/scripts"
	".config/hypr/shell|$HOME/.config/hypr/shell"
	".config/matugen|$HOME/.config/matugen"
	".config/waybar|$HOME/.config/waybar"
	".config/kitty/kitty.conf|$HOME/.config/kitty/kitty.conf"
	".config/swaync/config.json|$HOME/.config/swaync/config.json"
	".config/wlogout/layout|$HOME/.config/wlogout/layout"
	".config/btop/btop.conf|$HOME/.config/btop/btop.conf"
	".config/cava/config|$HOME/.config/cava/config"
	".config/gtk-3.0/settings.ini|$HOME/.config/gtk-3.0/settings.ini"
	".config/gtk-3.0/gtk.css|$HOME/.config/gtk-3.0/gtk.css"
	".config/gtk-4.0/settings.ini|$HOME/.config/gtk-4.0/settings.ini"
	".config/gtk-4.0/gtk.css|$HOME/.config/gtk-4.0/gtk.css"
	".config/qt6ct/qt6ct.conf|$HOME/.config/qt6ct/qt6ct.conf"
	".config/vicinae/settings.json|$HOME/.config/vicinae/settings.json"
	".vimrc|$HOME/.vimrc"
	"Wallpapers/wallpaper.jpeg|$WALLPAPER"
)

# Генерируемые matugen файлы не храним — install.sh создаёт их через theme.sh
COLLECT_EXCLUDE=(
	"--exclude=themes/matugen.css"
)
