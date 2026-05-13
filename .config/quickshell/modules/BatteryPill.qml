
import QtQuick
import Quickshell.Io
import "."

Pill {
    id: pill

    property int pct: 0
    property bool charging: false

    Process {
        id: proc
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT0/capacity /sys/class/power_supply/BAT0/status"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")
                if (lines.length >= 2) {
                    pill.pct = parseInt(lines[0])
                    pill.charging = (lines[1] === "Charging" || lines[1] === "Full")
                }
            }
        }
    }

    Component.onCompleted: proc.running = true
    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: proc.running = true
    }

    icon: {
        if (charging) return "󰂄"
        if (pct > 80) return "󰁹"
        if (pct > 60) return "󰂀"
        if (pct > 40) return "󰁾"
        if (pct > 20) return "󰁼"
        return "󰁺"
    }
    accent: (pct < 20 && !charging) ? "#ff6b6b" : (charging ? "#a8e6a3" : "#ffd6a5")
    label: pct + "%"
    expandedText: charging ? pct + "% ⚡" : pct + "%"
}

