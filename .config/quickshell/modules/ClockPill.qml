
import QtQuick
import "."

Pill {
    id: pill
    icon: "󰥔"
    accent: Theme.accentGlow
    
    property var now: new Date()
    label: Qt.formatDateTime(now, "HH:mm")
    expandedText: Qt.formatDateTime(now, "ddd dd MMM  HH:mm")
    
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: pill.now = new Date()
    }
}
