#!/usr/bin/env python3
# ─────────────────────────────────────────────────────────────────
#  list-apps.py — Lit tous les fichiers .desktop et retourne :
#  name\texec\ticon  (une ligne par app, triées par nom)
# ─────────────────────────────────────────────────────────────────

import os
import sys
import glob
import configparser

DESKTOP_DIRS = [
    "/usr/share/applications",
    "/usr/local/share/applications",
    os.path.expanduser("~/.local/share/applications"),
    "/var/lib/flatpak/exports/share/applications",
    os.path.expanduser("~/.local/share/flatpak/exports/share/applications"),
]

def parse_desktop(path):
    """Parse un fichier .desktop et retourne (name, exec, icon) ou None."""
    cp = configparser.RawConfigParser(strict=False)
    try:
        cp.read(path, encoding="utf-8")
    except Exception:
        return None

    if not cp.has_section("Desktop Entry"):
        return None

    entry = cp["Desktop Entry"]

    # On ignore les apps cachées, les sections non-Application
    entry_type = entry.get("Type", "").strip()
    if entry_type != "Application":
        return None

    no_display = entry.get("NoDisplay", "false").strip().lower()
    if no_display == "true":
        return None

    hidden = entry.get("Hidden", "false").strip().lower()
    if hidden == "true":
        return None

    # Langue française en priorité, fallback anglais
    name = (
        entry.get("Name[fr]") or
        entry.get("Name[fr_FR]") or
        entry.get("Name", "")
    ).strip()

    if not name:
        return None

    exec_cmd = entry.get("Exec", "").strip()
    if not exec_cmd:
        return None

    icon = entry.get("Icon", "").strip()

    return (name, exec_cmd, icon)


def main():
    apps = {}

    for d in DESKTOP_DIRS:
        if not os.path.isdir(d):
            continue
        for path in glob.glob(os.path.join(d, "*.desktop")):
            result = parse_desktop(path)
            if result:
                name, exec_cmd, icon = result
                # Dédupliquer par nom (local priority)
                if name not in apps:
                    apps[name] = (exec_cmd, icon)

    # Trier par nom
    for name in sorted(apps.keys(), key=lambda s: s.lower()):
        exec_cmd, icon = apps[name]
        # Échapper les tabulations dans le nom si besoin
        safe_name = name.replace("\t", " ")
        safe_exec = exec_cmd.replace("\t", " ")
        safe_icon = icon.replace("\t", " ")
        print(f"{safe_name}\t{safe_exec}\t{safe_icon}")


if __name__ == "__main__":
    main()
