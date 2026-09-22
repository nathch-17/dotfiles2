#!/bin/bash
# ─────────────────────────────────────────────────────────────────
#  list-apps.sh — Wrapper appelé par DesktopAppLoader.qml
# ─────────────────────────────────────────────────────────────────
exec python3 "$(dirname "$0")/list-apps.py"
