
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "."

// ─────────────────────────────────────────────────────────────────
//  Rosé Pine Launcher — remplace Rofi pour ta config Hyprland
//  Toggle via : IpcHandler "launcher" → méthode "toggle"
//  Keybind Hyprland : SUPER+R → qs ipc call launcher toggle
// ─────────────────────────────────────────────────────────────────

PanelWindow {
    id: launcherWindow

    // ── Couche Wayland ──
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    WlrLayershell.namespace: "quickshell:launcher"

    implicitWidth: 570
    implicitHeight: panel.height
    color: "transparent"
    visible: opened

    // ── État ──
    property bool   opened:        false
    property string searchText:    ""
    property int    selectedIndex: 0
    property string mode:          "apps"   // "apps" | "power"

    // ── Theme Quickshell ──
    readonly property color rpBase:     Theme.bgDeep
    readonly property color rpSurface:  Theme.bgPanel
    readonly property color rpOverlay:  Theme.bgPill
    readonly property color rpMuted:    Theme.textMuted
    readonly property color rpSubtle:   Theme.textDim
    readonly property color rpText:     Theme.text
    readonly property color rpLove:     Theme.danger
    readonly property color rpGold:     Theme.accentSoft
    readonly property color rpRose:     Theme.accent
    readonly property color rpPine:     Theme.accent
    readonly property color rpFoam:     Theme.accentGlow
    readonly property color rpIris:     Theme.accent
    readonly property color rpHighHigh: Theme.bgHover
    readonly property color rpHighMed:  Theme.bgPill
    readonly property color rpHighLow:  Theme.bgDeep

    // ─── IPC Handler : appel depuis Hyprland ───
    IpcHandler {
        target: "launcher"
        function toggle() { launcherWindow.toggleLauncher() }
        function show()   { launcherWindow.openLauncher()   }
        function hide()   { launcherWindow.closeLauncher()  }
    }

    function toggleLauncher() {
        if (opened) closeLauncher()
        else        openLauncher()
    }

    function openLauncher() {
        opened = true
        searchText = ""
        selectedIndex = 0
        mode = "apps"
        appLoader.reload()
        // Focus après un court délai (le temps que la fenêtre soit visible)
        focusTimer.restart()
    }

    function closeLauncher() {
        opened = false
        searchText = ""
        selectedIndex = 0
    }

    Timer {
        id: focusTimer
        interval: 80
        onTriggered: searchInput.forceActiveFocus()
    }

    // ─── Chargeur + modèle filtré ───
    DesktopAppLoader {
        id: appLoader
    }

    ListModel {
        id: filteredModel
    }

    // Filtrage réactif au texte de recherche
    Connections {
        target: appLoader.allApps
        function onCountChanged() { rebuildFiltered() }
    }

    function rebuildFiltered() {
        filteredModel.clear()
        var query = searchText.toLowerCase().trim()
        for (var i = 0; i < appLoader.allApps.count; i++) {
            var item = appLoader.allApps.get(i)
            if (query === "" || item.name.toLowerCase().indexOf(query) >= 0) {
                filteredModel.append(item)
                if (filteredModel.count >= 200) break  // limite de sécurité
            }
        }
        selectedIndex = 0
    }

    onSearchTextChanged: rebuildFiltered()

    // ─── Fond scrim ───
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0.10, 0.09, 0.14, launcherWindow.opened ? 0.65 : 0)
        visible: true

        Behavior on color { ColorAnimation { duration: 200 } }

        MouseArea {
            anchors.fill: parent
            enabled: launcherWindow.opened
            onClicked: launcherWindow.closeLauncher()
        }
    }

    // ─── Panneau principal ───
    Rectangle {
        id: panel
        anchors.centerIn: parent
        width: 570

        // Hauteur dynamique : barre recherche + liste (max 7 résultats) ou power menu
        height: {
            if (!launcherWindow.opened) return 68
            if (launcherWindow.mode === "power") return 72 + 180 + 16
            var rows = Math.min(filteredModel.count, 7)
            if (rows === 0 && launcherWindow.searchText !== "") rows = 1  // message vide
            return 68 + rows * 52 + (rows > 0 ? 8 : 0)
        }

        Behavior on height { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

        radius: 20
        color: Qt.rgba(0.122, 0.114, 0.180, 0.97)   // rpSurface ~opaque
        border.color: Qt.rgba(0.769, 0.655, 0.906, 0.30)  // rpIris
        border.width: 1

        opacity: launcherWindow.opened ? 1 : 0
        scale:   launcherWindow.opened ? 1 : 0.94
        visible: launcherWindow.opened

        Behavior on opacity { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
        Behavior on scale   { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

        // ── Contenu ──
        ColumnLayout {
            anchors { fill: parent; margins: 14 }
            spacing: 10

            // ── Barre de recherche ──
            Rectangle {
                Layout.fillWidth: true
                height: 44
                radius: 12
                color: Qt.rgba(0.149, 0.137, 0.227, 0.80)  // rpOverlay
                border.color: searchInput.activeFocus
                    ? Qt.rgba(0.769, 0.655, 0.906, 0.70)    // iris fort
                    : Qt.rgba(0.431, 0.416, 0.525, 0.30)    // muted
                border.width: 1
                Behavior on border.color { ColorAnimation { duration: 150 } }

                RowLayout {
                    anchors { fill: parent; leftMargin: 14; rightMargin: 10 }
                    spacing: 10

                    // Icône mode
                    Text {
                        text: launcherWindow.mode === "power" ? "⏻" : ""
                        color: launcherWindow.mode === "power"
                            ? launcherWindow.rpLove
                            : launcherWindow.rpIris
                        font.pixelSize: 17
                        font.family: "Maple Mono NF"
                    }

                    // Champ texte + placeholder simulé
                    Item {
                        Layout.fillWidth: true
                        height: 28

                        // Placeholder (visible quand vide et sans focus)
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: launcherWindow.mode === "power"
                                ? "Power menu  (Tab → Apps)"
                                : "Rechercher…  (Tab → Power)"
                            color: launcherWindow.rpMuted
                            font.pixelSize: 15
                            font.family: "Maple Mono NF"
                            visible: searchInput.text === ""
                        }

                        TextInput {
                            id: searchInput
                            anchors.fill: parent
                            font.pixelSize: 15
                            font.family: "Maple Mono NF"
                            color: launcherWindow.rpText
                            selectionColor: Theme.accentDim
                            text: launcherWindow.searchText
                            cursorVisible: activeFocus
                            verticalAlignment: TextInput.AlignVCenter

                            onTextChanged: launcherWindow.searchText = text

                            Keys.onEscapePressed: launcherWindow.closeLauncher()
                            Keys.onReturnPressed: launcherWindow.activateSelected()
                            Keys.onEnterPressed:  launcherWindow.activateSelected()

                            Keys.onUpPressed: {
                                if (launcherWindow.selectedIndex > 0)
                                    launcherWindow.selectedIndex--
                            }
                            Keys.onDownPressed: {
                                var max = launcherWindow.mode === "power"
                                    ? 5  // 6 boutons power (indices 0-5)
                                    : filteredModel.count - 1
                                if (launcherWindow.selectedIndex < max)
                                    launcherWindow.selectedIndex++
                            }

                            Keys.onTabPressed: {
                                launcherWindow.mode = launcherWindow.mode === "apps" ? "power" : "apps"
                                launcherWindow.selectedIndex = 0
                                text = ""
                            }
                        }
                    }

                    // Badge mode
                    Rectangle {
                        width: badgeText.implicitWidth + 14
                        height: 22
                        radius: 8
                        color: launcherWindow.mode === "power"
                            ? Theme.bgPill   // love
                            : Theme.bgPill   // iris
                        Text {
                            id: badgeText
                            anchors.centerIn: parent
                            text: launcherWindow.mode === "power" ? "Power ⏻" : "Apps "
                            color: launcherWindow.mode === "power"
                                ? launcherWindow.rpLove
                                : launcherWindow.rpSubtle
                            font.pixelSize: 11
                            font.family: "Maple Mono NF"
                        }
                    }
                }
            }

            // ── Liste des apps ──
            ListView {
                id: appList
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(filteredModel.count, 7) * 52
                visible: launcherWindow.mode === "apps" && filteredModel.count > 0
                clip: true
                model: filteredModel
                spacing: 3
                currentIndex: launcherWindow.selectedIndex

                // Scroll auto vers l'élément sélectionné
                onCurrentIndexChanged: positionViewAtIndex(currentIndex, ListView.Contain)

                ScrollBar.vertical: ScrollBar {
                    policy: filteredModel.count > 7 ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
                    contentItem: Rectangle {
                        radius: 3
                        color: Theme.accentDim
                    }
                }

                delegate: AppEntry {
                    width: appList.width - (filteredModel.count > 7 ? 12 : 0)
                    appName: model.name
                    appExec: model.exec
                    appIcon: model.icon
                    isSelected: index === launcherWindow.selectedIndex
                    onActivated: launcherWindow.launchApp(model.exec)
                    onHovered:   launcherWindow.selectedIndex = index
                }
            }

            // Message aucun résultat
            Item {
                Layout.fillWidth: true
                height: 52
                visible: launcherWindow.mode === "apps"
                    && filteredModel.count === 0
                    && launcherWindow.searchText !== ""

                Text {
                    anchors.centerIn: parent
                    text: " Aucune app pour \"" + launcherWindow.searchText + "\""
                    color: launcherWindow.rpMuted
                    font.pixelSize: 13
                    font.family: "Maple Mono NF"
                }
            }

            // ── Power menu ──
            Grid {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                visible: launcherWindow.mode === "power"
                columns: 3
                columnSpacing: 10
                rowSpacing: 10

                // Les 6 actions power
                Repeater {
                    id: powerRepeater
                    model: ListModel {
                        ListElement { icon: "󰌾"; label: "Verrouiller";   cmd: "hyprlock";                color: "#9ccfd8" }
                        ListElement { icon: "󰍃"; label: "Déconnecter";   cmd: "hyprctl dispatch exit";   color: "#f6c177" }
                        ListElement { icon: "";  label: "Suspendre";      cmd: "systemctl suspend";        color: "#31748f" }
                        ListElement { icon: "󰜉"; label: "Redémarrer";    cmd: "systemctl reboot";         color: "#ebbcba" }
                        ListElement { icon: "󰐥"; label: "Éteindre";      cmd: "systemctl poweroff";       color: "#eb6f92" }
                        ListElement { icon: "󰦛"; label: "Hiberner";      cmd: "systemctl hibernate";      color: "#c4a7e7" }
                    }

                    delegate: PowerButton {
                        width:  (panel.width - 28 - 20) / 3
                        height: 82
                        btnIcon:  model.icon
                        btnLabel: model.label
                        btnCmd:   model.cmd
                        btnColor: model.color
                        isSelected: index === launcherWindow.selectedIndex
                        onHovered:  launcherWindow.selectedIndex = index
                        onActivated: {
                            launcherWindow.closeLauncher()
                            execPower.command = ["bash", "-c", model.cmd]
                            execPower.running = true
                        }
                    }
                }
            }
        }
    }

    // ── Processus power ──
    Process {
        id: execPower
        running: false
    }

    // ── Lancer une app ──
    function launchApp(exec) {
        closeLauncher()
        // Nettoyer les placeholders .desktop (%u %F etc.)
        var cleaned = exec.replace(/%[uUfFdDnNickvm]/g, "").trim()
        var proc = Qt.createQmlObject(
            'import Quickshell.Io; Process { command: ["bash", "-c", "' +
            cleaned.replace(/\\/g, "\\\\").replace(/"/g, '\\"') +
            '"]; running: true }',
            launcherWindow, "launchProc"
        )
    }

    function activateSelected() {
        if (mode === "power") {
            // Trouver le bon bouton et l'activer
            var item = powerRepeater.itemAt(selectedIndex)
            if (item) item.activated()
        } else {
            if (selectedIndex < filteredModel.count) {
                launchApp(filteredModel.get(selectedIndex).exec)
            }
        }
    }

    Keys.onEscapePressed: closeLauncher()
}
