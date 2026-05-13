# Configuration Hyprland en Lua

Cette configuration convertit vos fichiers de configuration Hyprland en format Lua pour une meilleure modularité et flexibilité.

## Structure des fichiers

```
~/.config/hypr/
├── init.lua           # Fichier principal de chargement
├── hyprland.lua       # Configuration principale (équivalent à hyprland.conf)
├── monitors.lua       # Configuration des moniteurs
├── workspaces.lua     # Configuration des workspaces
├── hypridle.lua       # Configuration d'hypridle
├── hyprlock.lua       # Configuration d'hyprlock
└── README-lua.md      # Ce fichier
```

## Utilisation

### Activation de la configuration Lua

**⚠️ Important :** Hyprland ne supporte pas nativement Lua pour le moment. Cette conversion est préparatoire pour une future version qui pourrait le supporter, ou pour utiliser avec un wrapper personnalisé.

### Chargement manuel (pour test)

Si vous voulez tester la structure :

```bash
cd ~/.config/hypr
lua init.lua
```

### Modification de la configuration

#### Ajouter un raccourci clavier

```lua
-- Dans hyprland.lua, ajoutez à la table keybindings
{"SUPER", "T", "exec", "wezterm"}
```

#### Ajouter une règle de fenêtre

```lua
-- Dans hyprland.lua, ajoutez à window_rules
{
    name = "my-app-rule",
    match = {class = "^(myapp)$"},
    opacity = "0.9 0.8"
}
```

#### Configurer un nouveau moniteur

```lua
-- Dans monitors.lua, ajoutez à la table monitors
{
    name = "HDMI-A-1", 
    resolution = "1920x1080@60", 
    position = "1920x0", 
    scale = 1
}
```

## Avantages de la configuration Lua

1. **Modularité** : Configuration divisée en modules logiques
2. **Réutilisabilité** : Fonctions pour ajouter facilement des éléments
3. **Validation** : Possibilité d'ajouter des validations de configuration
4. **Dynamisme** : Configuration qui peut s'adapter selon le contexte
5. **Documentation** : Code auto-documenté avec des commentaires

## Fonctions utilitaires disponibles

### Dans init.lua

- `initialize()` : Initialise toute la configuration
- `reload()` : Recharge la configuration
- `get_config()` : Obtient la configuration actuelle
- `get_info()` : Affiche des informations sur la configuration
- `add_keybinding(modifier, key, action, command)` : Ajoute un raccourci
- `add_window_rule(name, match_rules, properties)` : Ajoute une règle de fenêtre
- `add_monitor(name, resolution, position, scale)` : Ajoute un moniteur

### Exemple d'utilisation

```lua
local hypr_config = require("init")

-- Ajouter un nouveau raccourci
hypr_config.add_keybinding("SUPER", "B", "exec", "firefox")

-- Ajouter une règle de fenêtre
hypr_config.add_window_rule("firefox-rule", {class = "firefox"}, {opacity = "0.95"})

-- Recharger la configuration
hypr_config.reload()
```

## Migration depuis les fichiers .conf

Vos fichiers de configuration originaux sont préservés. La conversion a été faite pour correspondre exactement à votre configuration actuelle :

- ✅ `hyprland.conf` → `hyprland.lua`
- ✅ `monitors.conf` → `monitors.lua` 
- ✅ `workspaces.conf` → `workspaces.lua`
- ✅ `hypridle.conf` → `hypridle.lua`
- ✅ `hyprlock.conf` → `hyprlock.lua`

## Retour aux fichiers .conf

Si vous souhaitez revenir à la configuration originale, il suffit de renommer ou supprimer les fichiers `.lua` et Hyprland utilisera automatiquement les fichiers `.conf`.

## Personnalisation

Chaque module expose des fonctions pour personnaliser la configuration :

### Monitors
- `add_monitor_config()` : Ajouter une nouvelle configuration de moniteur
- `apply_monitors()` : Appliquer la configuration des moniteurs

### Workspaces  
- `add_workspace_rule()` : Ajouter une règle de workspace
- `add_workspace_window_rule()` : Ajouter une règle de fenêtre spécifique à un workspace

### Hypridle
- `add_listener()` : Ajouter un listener d'événements temporisés
- `set_general_config()` : Modifier la configuration générale

### Hyprlock
- `add_label()` : Ajouter un nouveau label
- `set_background_config()` : Modifier la configuration du background
- `set_input_field_config()` : Modifier le champ de saisie

Cette structure modulaire permet une maintenance et une personnalisation beaucoup plus faciles de votre environnement Hyprland !