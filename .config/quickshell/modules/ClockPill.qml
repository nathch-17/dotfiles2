import QtQuick
import "."

Pill {
    id: pill
    // Pas d'icône pour l'horloge
    icon: ""
    accent: Theme.accentGlow
    
    // Agrandissement
    labelSize: 15
    pillHeight: 30
    
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
