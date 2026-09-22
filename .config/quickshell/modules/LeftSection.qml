
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.modules

Row {
    id: root
    spacing: Theme.gap
    anchors.verticalCenter: parent.verticalCenter

    // ── Helper component pour les boutons icônes ──
    component IconBtn: Rectangle {
        id: btn
        property string icon: ""
        property var onActivated: () => {}
        property color hoverColor: Theme.accent

        width: 36
        height: 28
        radius: Theme.radiusPill
        color: ma.containsMouse ? Theme.bgHover : Theme.bgPill
        border.color: ma.containsMouse ? btn.hoverColor : "transparent"
        border.width: 1
        Behavior on color { ColorAnimation { duration: Theme.animFast } }
        Behavior on border.color { ColorAnimation { duration: Theme.animFast } }

        Text {
            anchors.centerIn: parent
            text: btn.icon
            color: ma.containsMouse ? btn.hoverColor : Theme.textNormal
            font.pixelSize: Theme.fontIconSize
            font.family: Theme.fontIcon
            Behavior on color { ColorAnimation { duration: Theme.animFast } }
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: btn.onActivated()
        }
    }

    // ── Logo Arch → rofi run ──
    IconBtn {
        icon: "󰣇"
        hoverColor: Theme.accentGlow
        onActivated: () => Quickshell.execDetached(["sh", "-c", "rofi -show run"])
    }

    // ── Finder → rofi window ──
    IconBtn {
        icon: "󰍉"
        hoverColor: Theme.accent
        onActivated: () => Quickshell.execDetached(["sh", "-c", "rofi -show window"])
    }

    // ── File manager → yazi-gui ──
    IconBtn {
        icon: "󰉋"
        hoverColor: Theme.accentLight
        onActivated: () => Quickshell.execDetached(["yazi-gui"])
    }

    // ── Module CPU ──
    Rectangle {
        id: cpuPill
        width: cpuRow.implicitWidth + Theme.padPill * 2
        height: 28
        radius: Theme.radiusPill
        color: cpuMa.containsMouse ? Theme.bgHover : Theme.bgPill
        border.color: {
            if (cpuMa.containsMouse) return Theme.danger
            if (cpuPill.cpuUsage > 80) return Theme.danger
            if (cpuPill.cpuUsage > 50) return Theme.warn
            return "transparent"
        }
        border.width: 1
        anchors.verticalCenter: parent.verticalCenter
        Behavior on color { ColorAnimation { duration: Theme.animFast } }
        Behavior on border.color { ColorAnimation { duration: Theme.animFast } }

        property real cpuUsage: 0
        property real lastTotal: 0
        property real lastIdle: 0

        Process {
            id: cpuProc
            running: false
            command: ["sh", "-c", "head -n1 /proc/stat"]
            stdout: StdioCollector {
                onStreamFinished: {
                    const parts = text.trim().split(/\s+/).slice(1).map(Number)
                    const idle = parts[3] + parts[4]
                    const total = parts.reduce((a, b) => a + b, 0)
                    const dTotal = total - cpuPill.lastTotal
                    const dIdle = idle - cpuPill.lastIdle
                    if (cpuPill.lastTotal > 0 && dTotal > 0)
                        cpuPill.cpuUsage = 100 * (1 - dIdle / dTotal)
                    cpuPill.lastTotal = total
                    cpuPill.lastIdle = idle
                }
            }
        }

        Timer {
            interval: 2000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: cpuProc.running = true
        }

        Row {
            id: cpuRow
            anchors.centerIn: parent
            spacing: 6

            Text {
                text: "󰍛"
                color: {
                    if (cpuPill.cpuUsage > 80) return Theme.danger
                    if (cpuPill.cpuUsage > 50) return Theme.warn
                    return Theme.accent
                }
                font.pixelSize: Theme.fontIconSize
                font.family: Theme.fontIcon
                anchors.verticalCenter: parent.verticalCenter
                Behavior on color { ColorAnimation { duration: Theme.animMed } }
            }

            Text {
                text: Math.round(cpuPill.cpuUsage) + "%"
                color: Theme.textNormal
                font.pixelSize: Theme.fontPill
                font.family: Theme.fontMono
                anchors.verticalCenter: parent.verticalCenter
            }

            // Mini-bar de progression
            Rectangle {
                width: 28
                height: 4
                radius: 2
                color: Theme.bgDeep
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    height: parent.height
                    radius: parent.radius
                    width: parent.width * (cpuPill.cpuUsage / 100)
                    color: {
                        if (cpuPill.cpuUsage > 80) return Theme.danger
                        if (cpuPill.cpuUsage > 50) return Theme.warn
                        return Theme.accent
                    }
                    Behavior on width { NumberAnimation { duration: Theme.animMed; easing.type: Easing.OutCubic } }
                    Behavior on color { ColorAnimation { duration: Theme.animMed } }
                }
            }
        }

        MouseArea {
            id: cpuMa
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: Quickshell.execDetached(["wezterm", "start", "--", "btop"])
        }
    }
}

