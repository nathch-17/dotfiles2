
import QtQuick
import Quickshell.Io
import "."

Pill {
    id: pill

    property string ssid: ""
    property bool enabled: false
    property int signal: 0

  
Process {
    id: proc
    command: ["sh", "-c",
        "echo \"WIFI=$(nmcli -t -f WIFI g)\"; nmcli -t -f NAME,TYPE,DEVICE connection show --active | grep ':802-11-wireless:' | head -1"]
    running: false
    stdout: StdioCollector {
        onStreamFinished: {
            const lines = text.trim().split("\n")
            pill.enabled = lines[0].indexOf("enabled") !== -1
            pill.ssid = ""
            pill.signal = 0
            for (let i = 1; i < lines.length; i++) {
                if (lines[i].indexOf(":802-11-wireless:") !== -1) {
                    pill.ssid = lines[i].split(":")[0]
                }
            }
            // signal séparément
            if (pill.ssid) sigProc.running = true
        }
    }
}

Process {
    id: sigProc
    command: ["sh", "-c", "nmcli -t -f IN-USE,SIGNAL dev wifi | grep '^\\*' | head -1 | cut -d: -f2"]
    running: false
    stdout: StdioCollector {
        onStreamFinished: pill.signal = parseInt(text.trim()) || 0
    }
}


    Component.onCompleted: proc.running = true
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: proc.running = true
    }

    icon: {
        if (!enabled) return "󰖪"
        if (signal > 75) return "󰤨"
        if (signal > 50) return "󰤥"
        if (signal > 25) return "󰤢"
        if (signal > 0)  return "󰤟"
        return "󰤫"
    }
    accent: enabled ? (ssid ? "#a8d8ff" : "#888") : "#666"
    label: enabled ? (ssid || "—") : "off"
    expandedText: enabled
        ? (ssid ? ssid + " (" + signal + "%)" : "Déconnecté")
        : "Wi-Fi désactivé"
}

