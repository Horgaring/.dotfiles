#!/bin/bash
cd "$(dirname "$0")"


HYPRPAPER=~/.config/hypr/hyprpaper.conf 
WALLPAPER=~/Pictures/Wallpapers/wallpaper.jpeg
MONITORS=$(hyprctl monitors -j | jq -r '.[] | .name' 2>/dev/null || echo "")

# 2. Create Directories
mkdir -p ~/.config/hypr
mkdir -p ~/Pictures/Wallpapers

# 3. Copy Static Files
cp ./.config/hyprland.conf ~/.config/hypr/hyprland.conf 
cp ./.vimrc ~/.vimrc
cp -r ./waybar ~/.config/
cp -p ./Wallpapers/wallpaper.jpeg "$WALLPAPER"
if [ -d ~/.config/fastfetch ]; then 
       rm -r ~/.config/fastfetch
fi       
cp -r ./.config/fastfetch ~/.config/


# 4. Generate Hyprpaper Config
echo "preload = $WALLPAPER" > "$HYPRPAPER"

if [ -z "$MONITORS" ]; then
	cat <<EOF >> "$HYPRPAPER"
wallpaper {
    monitor = 
    path = $WALLPAPER
    fit_mode = cover
}
EOF
else
	for MON in $MONITORS; do
		cat <<EOF >> "$HYPRPAPER"
wallpaper {
    monitor = $MON
    path = $WALLPAPER
    fit_mode = cover
}
EOF
done
fi

echo "splash = false" >> "$HYPRPAPER"

echo "Done!"

