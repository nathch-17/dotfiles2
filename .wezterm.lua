local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local colors_file = wezterm.home_dir .. "/.cache/wallust/wezterm.lua"

local function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

-- 1. On charge wallust si dispo
if file_exists(colors_file) then
  config.colors = dofile(colors_file)
end

-- 2. On applique le thème pour les couleurs du texte (ANSI)
config.color_scheme = "rose-pine-moon"

-- 3. LA TOUCHE FINALE : On force le fond très sombre ici
-- Ça écrasera le fond de Dracula et de Wallust
if not config.colors then config.colors = {} end
config.colors.background = "#0b0b0e" -- Un noir très élégant


-- =========================================================
-- AJOUTS POUR LE STYLE (Marges et Taille)
-- =========================================================

-- Marges internes (Padding) pour recréer l'espace vide élégant
config.window_padding = {
  left = 24,
  right = 24,
  top = 24,
  bottom = 24,
}

-- Taille de la police (à ajuster selon la résolution de votre écran)



-- =========================================================
-- VOS PARAMÈTRES D'INTERFACE & TRANSPARENCE
-- =========================================================

-- ── FONT ──
config.font = wezterm.font_with_fallback {
  {
    family = 'FiraCode Nerd Font',
    weight = 'Regular',
    harfbuzz_features = { 'calt=1', 'liga=1', 'ss01=1', 'ss02=1', 'ss03=1' },
  },
  'Symbols Nerd Font Mono', -- fallback icônes au cas où
  'Noto Color Emoji',
}

config.font_size = 13.0
config.line_height = 1.15
config.cell_width = 1.0

-- Anti-aliasing propre
config.freetype_load_target = 'Light'
config.freetype_render_target = 'HorizontalLcd'

-- Note : 0.85 est assez opaque. Si l'effet de flou (blur) d'Hyprland
-- ne ressort pas assez à votre goût, n'hésitez pas à descendre vers 0.75
config.window_background_opacity = 0.85
config.text_background_opacity = 1.0

config.window_decorations = "RESIZE"

-- Si un jour les bordures sautent sous Hyprland, essayez de passer ceci sur true
config.enable_wayland = false

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

return config
