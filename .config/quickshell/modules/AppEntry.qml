
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "."

// ─────────────────────────────────────────────────────────────────
//  AppEntry — Une ligne dans la liste du launcher
// ─────────────────────────────────────────────────────────────────

Rectangle {
    id: root

    property string appName: ""
    property string appExec: ""
    property string appIcon: ""
    property bool   isSelected: false

    signal activated()
    signal hovered()

    height: 48
    radius: 10
    color: isSelected
        ? Theme.accentDim   // iris teinté
        : hoverArea.containsMouse
            ? Theme.bgPill
            : "transparent"

    Behavior on color { ColorAnimation { duration: 120 } }

    // Barre gauche accent (sélectionné)
    Rectangle {
        width: 3
        height: parent.height * 0.55
        radius: 2
        anchors { left: parent.left; leftMargin: 2; verticalCenter: parent.verticalCenter }
        color: Theme.accent   // iris
        opacity: root.isSelected ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }

    RowLayout {
        anchors { fill: parent; leftMargin: 14; rightMargin: 14 }
        spacing: 12

        // Icône de l'app (via Image si dispo, sinon fallback text)
        Item {
            width: 28
            height: 28

            Image {
                id: iconImg
                anchors.fill: parent
                source: root.appIcon !== "" ? "image://icon/" + root.appIcon : ""
                fillMode: Image.PreserveAspectFit
                smooth: true
                visible: status === Image.Ready
            }

            Text {
                anchors.centerIn: parent
                text: ""   // fallback icon
                font.pixelSize: 20
                font.family: "Maple Mono NF"
                color: Theme.accent
                visible: iconImg.status !== Image.Ready
            }
        }

        // Nom de l'app
        Text {
            Layout.fillWidth: true
            text: root.appName
            color: root.isSelected ? Theme.textBright : Theme.textDim
            font.pixelSize: 14
            font.family: "Maple Mono NF"
            font.weight: root.isSelected ? Font.Medium : Font.Normal
            elide: Text.ElideRight

            Behavior on color { ColorAnimation { duration: 120 } }
        }

        // Exec hint (petit)
        Text {
            visible: root.isSelected
            text: root.appExec.split(" ")[0].split("/").pop()
            color: Theme.textMuted
            font.pixelSize: 11
            font.family: "Maple Mono NF"
            opacity: root.isSelected ? 0.8 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: root.hovered()
        onClicked: root.activated()
    }
}
