
import QtQuick
import "."

Text {
    id: root
    property var now: new Date()
    text: Qt.formatDateTime(now, "ddd dd MMM  HH:mm")
    color: Theme.text
    font.pixelSize: 13
    font.family: Theme.fontMain
    font.weight: Font.Medium
    anchors.verticalCenter: parent?.verticalCenter ?? undefined

    anchors.horizontalCenter: parent?.horizontalCenter ?? undefined

    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: root.now = new Date()
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["gnome-calendar"])
    }
}
