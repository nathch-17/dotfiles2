
import QtQuick
import Quickshell.Io

// ─────────────────────────────────────────────────────────────────
//  DesktopAppLoader — Lit les .desktop et expose un ListModel filtré
//  Utilise un script Python léger pour parser les .desktop
// ─────────────────────────────────────────────────────────────────

Item {
    id: root

    // Modèle complet (toutes les apps)
    property ListModel allApps: ListModel {}

    // Appel pour recharger la liste
    function reload() {
        allApps.clear()
        listProc.running = true
    }

    // Processus qui lit les .desktop via le script helper
    Process {
        id: listProc
        command: ["bash", "-c", "~/.config/quickshell/scripts/list-apps.sh"]
        running: false
        stdout: SplitParser {
            onRead: function(line) {
                if (line.trim() === "") return
                // Format: name\texec\ticon
                var parts = line.split("\t")
                if (parts.length >= 2) {
                    root.allApps.append({
                        name: parts[0] || "",
                        exec: parts[1] || "",
                        icon: parts[2] || ""
                    })
                }
            }
        }
    }
}
