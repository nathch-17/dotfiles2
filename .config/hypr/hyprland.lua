-- hyprland.lua
-- Translated from hyprland.conf

----------------
---- MONITORS ----
----------------
-- monitor=,preferred,auto,auto
-- monitor = HDMI-A-1, preferred, auto, 1, transform, 1
-- monitor = DP-3,2560x1440@280.00,auto,auto
require("monitors")
---------------------
---- MY PROGRAMS ----
---------------------
local terminal = "wezterm"
local fileManager = "yazi-gui"
local menu = "qs ipc call launcher toggle"
local EDITOR = "nvim"

-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function()
  hl.exec_cmd("quickshell")
  hl.exec_cmd("awww-daemon")
  hl.exec_cmd("hyprctl setcursor Adwaita 20")
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("touch /tmp/qs_vol")
  hl.exec_cmd("QML_XHR_ALLOW_FILE_READ=1 quickshell -p ~/.config/quickshell/mon_theme/shell.qml")
  hl.exec_cmd("sddm")
  hl.exec_cmd("snappy-switcher --daemon")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("LANG", "fr_FR.UTF-8")

-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 5,
    border_size = 1,
    col = {
      active_border = { colors = { "rgba(e8833aff)", "rgba(ff9d52ff)", "rgba(ffc94dff)" }, angle = 45 },
      inactive_border = "rgba(414868aa)",
    },
    resize_on_border = false,
    allow_tearing = false,
    layout = "dwindle",
  },

  decoration = {
    rounding = 18,
    rounding_power = 2,
    active_opacity = 1.0,
    inactive_opacity = 1.0,

    blur = {
      enabled = true,
      size = 8,
      passes = 3,
      ignore_opacity = true,
      new_optimizations = true,
    },

    shadow = {
      enabled = true,
      range = 10,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    },
  },

  animations = {
    enabled = true,
  },
})

hl.curve("snappy", { type = "bezier", points = { { 0.20, 1.00 }, { 0.30, 1.00 } } })
hl.curve("smooth", { type = "bezier", points = { { 0.45, 0.00 }, { 0.15, 1.00 } } })
hl.curve("bounce", { type = "bezier", points = { { 0.34, 1.56 }, { 0.64, 1.00 } } })
hl.curve("linear", { type = "bezier", points = { { 0.00, 0.00 }, { 1.00, 1.00 } } })
hl.curve("overshoot", { type = "bezier", points = { { 0.05, 0.90 }, { 0.10, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "bounce", style = "popin 85%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "bounce", style = "popin 85%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "snappy", style = "popin 90%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "snappy" })

hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "smooth" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 3, bezier = "smooth" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 2, bezier = "smooth" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 3, bezier = "smooth" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 3, bezier = "smooth" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 3, bezier = "smooth" })

hl.animation({ leaf = "border", enabled = true, speed = 4, bezier = "smooth" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "linear", style = "loop" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "overshoot", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "overshoot", style = "slidevert" })

hl.animation({ leaf = "layers", enabled = true, speed = 3, bezier = "smooth", style = "slide" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3, bezier = "bounce", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2, bezier = "snappy", style = "slide" })

hl.config({
  master = {
    new_status = "master",
  },
  misc = {
    force_default_wallpaper = -1,
    disable_hyprland_logo = false,
  },
  input = {
    kb_layout = "fr",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = true,
    },
  },
  xwayland = {
    force_zero_scaling = true,
  }
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

hl.device({
  name = "epic-mouse-v1",
  sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------
local mainMod = "SUPER"

hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/wallpaper-picker.sh"))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M",
  hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("rofi -show run"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grim ~/Pictures/$(date +'%Y-%m-%d_%Hh%Mm%Ss_grim.png')"))
hl.bind("SUPER + Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" ~/Pictures/$(date +'%Y-%m-%d_%Hh%Mm%Ss_grim.png')"))

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = 0 }))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + ampersand", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + eacute", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + quotedbl", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + apostrophe", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + parenleft", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + minus", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + egrave", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + underscore", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + ccedilla", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + agrave", hl.dsp.focus({ workspace = 10 }))

hl.bind(mainMod .. " + SHIFT + ampersand", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + eacute", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + quotedbl", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + apostrophe", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + parenleft", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + egrave", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + underscore", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + ccedilla", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + agrave", hl.dsp.window.move({ workspace = 10 }))

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume",
  hl.dsp.exec_cmd(
    "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ && wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}' > /tmp/qs_vol"))
hl.bind("XF86AudioLowerVolume",
  hl.dsp.exec_cmd(
    "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}' > /tmp/qs_vol"))
hl.bind("XF86AudioMute",
  hl.dsp.exec_cmd(
    "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{if ($3 == \"[MUTED]\") print 0; else print int($2 * 100)}' > /tmp/qs_vol"))

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind("ALT + Tab", hl.dsp.exec_cmd("snappy-switcher next"))
hl.bind("ALT + SHIFT + Tab", hl.dsp.exec_cmd("snappy-switcher prev"))

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})

hl.window_rule({
  name = "move-hyprland-run",
  match = { class = "hyprland-run" },
  move = "20 monitor_h-120",
  float = true,
})

hl.window_rule({
  name = "firefox-transparency",
  match = { class = "^(firefox)$" },
  no_blur = false,
})

hl.window_rule({
  name = "thunar-transparency",
  match = { class = "^(thunar)$" },
  opacity = "0.85 0.85",
})

hl.window_rule({
  name = "deezer-transparency",
  match = { class = "^(deezer-desktop)$" },
  opacity = "0.85 0.80",
})

hl.window_rule({
  name = "obsdian-transparency",
  match = { class = "^(obsidian)$" },
  opacity = "0.90 0.80",
})

hl.window_rule({
  name = "discord-transparency",
  match = { class = "^(discord)$" },
  opacity = "0.95 0.90",
})

hl.layer_rule({
  name = "flou_de_waybar",
  match = { namespace = "waybar" },
  blur = true,
  ignore_alpha = 0.5,
})

hl.layer_rule({
  name = "blur",
  match = { namespace = "^(quickshell)$" },
  blur = true,
  ignore_alpha = 0.5,
})

hl.window_rule({
  name = "wezterm-bg",
  match = { class = "^(wezterm)$" },
  opacity = "0.8 0.75",
})

hl.layer_rule({
  name = "launcher-blur",
  match = { namespace = "^(quickshell:launcher)$" },
  blur = true,
  ignore_alpha = 0.3,
  animation = "fade",
})
