#!/bin/bash

# Dossier de tes images
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Sélection via Rofi
# Note: on utilise -show-icons si ton rofi le supporte
SEL=$(ls "$WALLPAPER_DIR" | rofi -dmenu -p "Wallpaper 󰸉 ")

if [ -n "$SEL" ]; then
    FULL_PATH="$WALLPAPER_DIR/$SEL"

    # 1. Appliquer le fond d'écran avec swww
    awww img "$FULL_PATH" --transition-fps 60 --transition-type wipe

    # 2. Générer les couleurs avec wallust
    wallust run "$FULL_PATH"

    # 3. Optionnel : recharger hyprland si tu utilises les couleurs wallust pour tes bordures
    # hyprctl reload
    
    notify-send "Thème mis à jour" "Image : $SEL" -i "$FULL_PATH"
fi
