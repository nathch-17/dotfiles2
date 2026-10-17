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

-- Supprime les bordures CSD qui créent le cadre décalé sous Wayland/Hyprland
config.window_decorations = "NONE"

-- Empêche WezTerm de recalculer la taille de fenêtre imposée par le compositeur
config.adjust_window_size_when_changing_font_size = false
config.use_resize_increments = false

-- Si un jour les bordures sautent sous Hyprland, essayez de passer ceci sur true
config.enable_wayland = false

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.tab_max_width = 36

-- =========================================================
-- STYLE DES ONGLETS (Adapté au thème Quickshell / Rosé Pine)
-- =========================================================
local qs_theme = {
  bg_deep     = '#0b0b0e', -- Theme.bgDeep
  bg_pill     = '#141419', -- Surface pilule repos
  bg_hover    = '#1e1e23', -- Theme.bgHover
  bg_active   = '#262026', -- Theme.accentDim sur bgDeep
  accent      = '#ebbcba', -- Theme.accent (Rose)
  accent_soft = '#c4a7e7', -- Theme.accentSoft (Iris)
  accent_glow = '#eb6f92', -- Theme.accentGlow / danger / urgent (Love)
  warn        = '#f6c177', -- Theme.warn / accentLight (Gold)
  ok          = '#9ccfd8', -- Theme.ok (Foam)
  text        = '#e0def4', -- Theme.text
  text_normal = '#908caa', -- Theme.textNormal
  text_dim    = '#6e6a86', -- Theme.textDim
  text_muted  = '#524f67', -- Theme.textMuted
}

local SOLID_LEFT_CIRCLE  = wezterm.nerdfonts.ple_left_half_circle_thick
local SOLID_RIGHT_CIRCLE = wezterm.nerdfonts.ple_right_half_circle_thick

config.colors.tab_bar = {
  background = qs_theme.bg_deep,
  active_tab = {
    bg_color = qs_theme.bg_active,
    fg_color = qs_theme.text,
    intensity = 'Bold',
  },
  inactive_tab = {
    bg_color = qs_theme.bg_pill,
    fg_color = qs_theme.text_dim,
  },
  inactive_tab_hover = {
    bg_color = qs_theme.bg_hover,
    fg_color = qs_theme.text_normal,
    italic = false,
  },
  new_tab = {
    bg_color = qs_theme.bg_deep,
    fg_color = qs_theme.text_dim,
  },
  new_tab_hover = {
    bg_color = qs_theme.bg_deep,
    fg_color = qs_theme.accent,
    italic = false,
  },
}

-- Bouton "+" en forme de pilule comme les IconBtn de Quickshell
config.tab_bar_style = {
  new_tab = wezterm.format {
    { Background = { Color = qs_theme.bg_deep } },
    { Foreground = { Color = qs_theme.bg_pill } },
    { Text = ' ' .. SOLID_LEFT_CIRCLE },
    { Background = { Color = qs_theme.bg_pill } },
    { Foreground = { Color = qs_theme.text_dim } },
    { Text = ' + ' },
    { Background = { Color = qs_theme.bg_deep } },
    { Foreground = { Color = qs_theme.bg_pill } },
    { Text = SOLID_RIGHT_CIRCLE .. ' ' },
  },
  new_tab_hover = wezterm.format {
    { Background = { Color = qs_theme.bg_deep } },
    { Foreground = { Color = qs_theme.bg_hover } },
    { Text = ' ' .. SOLID_LEFT_CIRCLE },
    { Background = { Color = qs_theme.bg_hover } },
    { Foreground = { Color = qs_theme.accent } },
    { Attribute = { Intensity = 'Bold' } },
    { Text = ' + ' },
    { Background = { Color = qs_theme.bg_deep } },
    { Foreground = { Color = qs_theme.bg_hover } },
    { Text = SOLID_RIGHT_CIRCLE .. ' ' },
  },
}

-- Icônes Nerd Font assorties aux modules Quickshell (LeftSection.qml)
local function get_tab_icon(tab)
  local proc = (tab.active_pane and tab.active_pane.foreground_process_name) or ''
  local name = proc:match('([^/\\]+)$') or ''
  local title = ((tab.active_pane and tab.active_pane.title) or ''):lower()
  local key = (name ~= '' and name:lower()) or title

  if key:find('nvim') or key:find('vim') then
    return '', qs_theme.ok
  elseif key:find('yazi') or key:find('ranger') then
    return '󰉋', qs_theme.warn -- Même icône/couleur que LeftSection.qml
  elseif key:find('btop') or key:find('htop') then
    return '󰍛', qs_theme.accent -- Même icône que le module CPU de Quickshell
  elseif key:find('git') or key:find('lazygit') then
    return '󰊢', qs_theme.accent_glow
  elseif key:find('python') or key:find('uv') then
    return '', qs_theme.warn
  elseif key:find('node') or key:find('bun') or key:find('npm') then
    return '󰎙', qs_theme.ok
  elseif key:find('cargo') or key:find('rust') then
    return '', qs_theme.warn
  elseif key:find('docker') or key:find('podman') then
    return '󰡨', qs_theme.ok
  elseif key:find('ssh') then
    return '󰣀', qs_theme.accent_soft
  elseif key:find('pacman') or key:find('yay') or key:find('paru') then
    return '󰣇', qs_theme.accent_glow -- Logo Arch de LeftSection.qml
  else
    return '󰆍', qs_theme.accent
  end
end

local function get_clean_title(tab)
  local title = tab.tab_title
  if not title or #title == 0 then
    title = (tab.active_pane and tab.active_pane.title) or 'shell'
  end
  -- Simplifie les chemins ou titres trop verbeux
  title = title:gsub('^%s+', ''):gsub('%s+$', '')
  if title == '' then
    title = 'shell'
  end
  return title
end

wezterm.on('format-tab-title', function(tab, _tabs, _panes, _config, hover, max_width)
  local is_active = tab.is_active
  local has_unseen = false
  for _, p in ipairs(tab.panes) do
    if p.has_unseen_output then
      has_unseen = true
      break
    end
  end

  local icon, icon_accent = get_tab_icon(tab)
  local index = tab.tab_index + 1

  -- Couleurs de la pilule selon l'état (calqué sur Pill.qml & Workspaces.qml)
  local pill_bg = qs_theme.bg_pill
  local text_fg = qs_theme.text_dim
  local icon_fg = qs_theme.text_muted

  if is_active then
    pill_bg = qs_theme.bg_active
    text_fg = qs_theme.text
    icon_fg = icon_accent
  elseif hover then
    pill_bg = qs_theme.bg_hover
    text_fg = qs_theme.text_normal
    icon_fg = qs_theme.accent
  elseif has_unseen then
    icon_fg = qs_theme.accent_glow
    text_fg = qs_theme.text_normal
  end

  local raw_title = get_clean_title(tab)
  local avail = math.max(8, max_width - 10)
  local title = wezterm.truncate_right(raw_title, avail)

  local badge = is_active and ' •' or (has_unseen and ' ◦' or '')
  local badge_fg = has_unseen and qs_theme.accent_glow or qs_theme.accent

  return {
    { Background = { Color = qs_theme.bg_deep } },
    { Foreground = { Color = pill_bg } },
    { Text = ' ' .. SOLID_LEFT_CIRCLE },
    { Background = { Color = pill_bg } },
    { Foreground = { Color = icon_fg } },
    { Text = ' ' .. icon .. ' ' },
    { Foreground = { Color = text_fg } },
    { Attribute = { Intensity = is_active and 'Bold' or 'Normal' } },
    { Text = index .. ':' .. title },
    { Foreground = { Color = badge_fg } },
    { Text = badge .. ' ' },
    { Background = { Color = qs_theme.bg_deep } },
    { Foreground = { Color = pill_bg } },
    { Text = SOLID_RIGHT_CIRCLE },
  }
end)

-- 1. Définir le Leader key (comme le prefix de tmux : Ctrl+B)
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  -- Split vertical (gauche/droite) : Ctrl+B puis %
  {
    key = 'v',
    mods = 'ALT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- Split horizontal (haut/bas) : Ctrl+B puis "
  {
    key = 'h',
    mods = 'ALT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  -- Naviguer entre les panneaux avec les flèches : Ctrl+B puis Flèche
  { key = 'LeftArrow',  mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'UpArrow',    mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'DownArrow',  mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },

  -- Fermer le panneau courant : Ctrl+B puis x
  { key = 'x',          mods = 'ALT',    action = wezterm.action.CloseCurrentPane { confirm = true } },

  {
    key = 'd',
    mods = 'ALT',
    action = wezterm.action.DetachDomain 'CurrentPaneDomain',

  },
}

-- Active le serveur de multiplexage local par défaut
config.unix_domains = {
  { name = 'unix' },
}

-- Déclare Hyprland (XWayland et Wayland) comme gestionnaire de fenêtres en Pavage (Tiling)
config.tiling_desktop_environments = {
  'X11 LG3D',
  'X11 bspwm',
  'X11 i3',
  'X11 dwm',
  'X11 awesome',
  'X11 Hyprland :D',
  'Wayland',
}

-- Corrige le bug de désynchronisation de taille (82x44 au lieu de la tuile complète)
-- lors de la reconnexion à wezterm-mux-server sous Hyprland :
-- Force TermWindow à recalculer et appliquer les dimensions réelles de la fenêtre Hyprland
-- aux onglets du serveur mux dès l'attachement et le focus.
local function sync_mux_window_size(window, pane)
  if not window then
    return
  end
  local active_pane = pane or window:active_pane()
  if active_pane then
    window:perform_action(wezterm.action.ResetFontSize, active_pane)
  end
end

wezterm.on('gui-attached', function(_domain)
  local workspace = wezterm.mux.get_active_workspace()
  for _, mux_win in ipairs(wezterm.mux.all_windows()) do
    if mux_win:get_workspace() == workspace then
      local gui_win = mux_win:gui_window()
      if gui_win then
        sync_mux_window_size(gui_win, mux_win:active_pane())
        if wezterm.time and wezterm.time.call_after then
          wezterm.time.call_after(0.05, function()
            sync_mux_window_size(gui_win, mux_win:active_pane())
          end)
          wezterm.time.call_after(0.15, function()
            sync_mux_window_size(gui_win, mux_win:active_pane())
          end)
        end
      end
    end
  end
end)

wezterm.on('window-focus-changed', function(window, pane)
  sync_mux_window_size(window, pane)
  if wezterm.time and wezterm.time.call_after then
    wezterm.time.call_after(0.05, function()
      sync_mux_window_size(window, nil)
    end)
  end
end)

wezterm.on('window-resized', function(window, pane)
  sync_mux_window_size(window, pane)
end)

return config
