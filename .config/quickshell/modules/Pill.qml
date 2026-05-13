
import QtQuick
import "."

Rectangle {
    id: root

    property string icon: ""
    property string label: ""
    property string expandedText: ""
    property color accent: Theme.accent
    property bool expanded: false
    property string panelMode: ""

    signal clicked()

    height: 26
    width: contentRow.width + 20
    radius: Theme.radiusPill

    color: mouseArea.containsMouse
        ? Theme.bgHover
        : Theme.bgPill
    border.color: expanded ? root.accent : Theme.border
    border.width: 1

    Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on border.color { ColorAnimation { duration: 150 } }

    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: 6

        Text {
            text: root.icon                          // ← root, pas pill
            color: root.accent
            font.pixelSize: 13
            font.family: Theme.fontIcon
            anchors.verticalCenter: parent.verticalCenter
            visible: text.length > 0
        }

        Text {
            text: root.label                         // ← root
            color: Theme.text                        // ← thème
            font.pixelSize: 11
            font.family: Theme.fontMono
            anchors.verticalCenter: parent.verticalCenter
            visible: text.length > 0
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: root.expanded = true
        onExited: root.expanded = false
        onClicked: root.clicked()
    }
}

