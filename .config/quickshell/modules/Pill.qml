
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
    property int labelSize: 11
    property int iconSize: 13
    property int pillHeight: 26

    signal clicked()

    height: root.pillHeight
    width: contentRow.width + 20
    radius: Theme.radiusPill

    color: mouseArea.containsMouse
        ? Theme.bgHover
        : Theme.bgPill
    border.color: expanded ? root.accent : "transparent"
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
            font.pixelSize: root.iconSize
            font.family: Theme.fontIcon
            anchors.verticalCenter: parent.verticalCenter
            visible: text.length > 0
        }

        Text {
            text: root.label                         // ← root
            color: Theme.text                        // ← thème
            font.pixelSize: root.labelSize
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

