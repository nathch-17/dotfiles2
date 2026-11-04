#!/usr/bin/env bash
# Alterne la variante de blur entre acrylic (8) et frost (1)
cur=$(hyprctl getoption decoration:blur:variant | awk '/int:/{print $2}')
if [ "$cur" = "8" ]; then n=1; name=frost; else n=8; name=acrylic; fi
hyprctl eval "hl.config({ decoration = { blur = { variant = $n } } })"
notify-send "Blur: $name" 2>/dev/null
