
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

// ─────────────────────────────────────────────────────────────────
//  PowerButton — Bouton pour le Power Menu
// ─────────────────────────────────────────────────────────────────

Rectangle {
    id: root

    property string btnIcon:  ""
    property string btnLabel: ""
    property string btnCmd:   ""
    property color  btnColor: "#c4a7e7"
    property bool   isSelected: false

    signal activated()
    signal hovered()

    function activate() { root.activated() }

    radius: 14
    color: isSelected
        ? Qt.rgba(btnColor.r, btnColor.g, btnColor.b, 0.22)
        : hoverArea.containsMouse
            ? Qt.rgba(btnColor.r, btnColor.g, btnColor.b, 0.12)
            : Qt.rgba(0.15, 0.14, 0.18, 0.6)

    border.color: isSelected
        ? Qt.rgba(btnColor.r, btnColor.g, btnColor.b, 0.6)
        : Qt.rgba(btnColor.r, btnColor.g, btnColor.b, 0.15)
    border.width: 1

    Behavior on color        { ColorAnimation { duration: 140 } }
    Behavior on border.color { ColorAnimation { duration: 140 } }

    scale: hoverArea.pressed ? 0.95 : (isSelected ? 1.03 : 1.0)
    Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 6

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: root.btnIcon
            color: root.btnColor
            font.pixelSize: 28
            font.family: "Maple Mono NF"

            // Glow subtil sur sélection
            opacity: root.isSelected ? 1 : 0.75
            Behavior on opacity { NumberAnimation { duration: 140 } }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: root.btnLabel
            color: root.isSelected ? "#e0def4" : "#6e6a86"
            font.pixelSize: 12
            font.family: "Maple Mono NF"
            Behavior on color { ColorAnimation { duration: 140 } }
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered:  root.hovered()
        onClicked:  root.activated()
    }
}
