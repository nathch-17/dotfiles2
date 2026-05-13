
import QtQuick
import Quickshell.Io
import "."

Pill {
    id: pill
    
    property bool powered: false
    property string device: ""
    
    icon: powered ? (device.length > 0 ? "󰂱" : "󰂯") : "󰂲"
    accent: powered ? "#a0c4ff" : "#888"
    label: powered ? (device.length > 0 ? device : "on") : "off"
    expandedText: label
    
    Process {
        id: btProc
        command: ["bash", "-c", "bluetoothctl show | grep -q 'Powered: yes' && bluetoothctl devices Connected | head -1 | cut -d' ' -f3- || echo 'OFF'"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const t = data.trim()
                if (t === "OFF") { pill.powered = false; pill.device = "" }
                else { pill.powered = true; pill.device = t }
            }
        }
    }
    
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: btProc.running = true
    }
}
