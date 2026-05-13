#!/bin/bash

# Dossier où se trouvent tes fonds d'écran
DIR="$HOME/Downloads"

# On utilise Rofi pour choisir l'image
SELECT=$(ls "$DIR" | rofi -dmenu -p "Choisir un fond d'écran")

if [ -n "$SELECT" ]; then
    # 1. Changer le fond d'écran
    swww img "$DIR/$SELECT" --transition-type center

    # 2. Générer les couleurs avec wallust
    wallust run "$DIR/$SELECT"
    
    # 3. Optionnel : Envoyer une notification
    notify-send "Thème mis à jour" "Couleurs extraites de $SELECT"
fi
