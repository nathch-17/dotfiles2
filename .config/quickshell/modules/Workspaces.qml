
import QtQuick
import Quickshell
import Quickshell.Hyprland
import "."            // ou l'import qui expose Theme chez toi

Row {
    id: root
    spacing: Theme.gap / 2          // ~4px, resserré
    anchors.verticalCenter: parent.verticalCenter

    property var wsIds: {
        let ids = Hyprland.workspaces.values.map(w => w.id);
        if (Hyprland.focusedWorkspace && !ids.includes(Hyprland.focusedWorkspace.id))
            ids.push(Hyprland.focusedWorkspace.id);
        return ids.filter(i => i > 0).sort((a, b) => a - b);
    }

    Repeater {
        model: root.wsIds

        Rectangle {
            property int wsId: modelData
            property bool isActive: Hyprland.focusedWorkspace
                                    && Hyprland.focusedWorkspace.id === wsId

            width: 32
            height: 22
            radius: Theme.radiusPill

            color: isActive ? Theme.accent : Theme.bgPill
            border.color: isActive ? Theme.accentGlow : Theme.border
            border.width: 1

            Behavior on color       { ColorAnimation { duration: Theme.animFast } }
            Behavior on border.color { ColorAnimation { duration: Theme.animFast } }

            Text {
                anchors.centerIn: parent
                text: parent.wsId
                color: parent.isActive ? Theme.bgDeep : Theme.accent
                font.pixelSize: Theme.fontPill
                font.bold: parent.isActive
                font.family: Theme.fontMono
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: if (!parent.isActive) parent.color = Theme.bgHover
                onExited:  if (!parent.isActive) parent.color = Theme.bgPill
                onClicked: Hyprland.dispatch("workspace " + parent.wsId)
            }
        }
    }
}

