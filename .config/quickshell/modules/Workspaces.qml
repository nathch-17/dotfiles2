import QtQuick
import Quickshell
import Quickshell.Hyprland
import "."

Row {
    id: root
    spacing: 10
    anchors.verticalCenter: parent.verticalCenter

    property var wsIds: {
        let ids = Hyprland.workspaces.values.map(w => w.id);
        if (Hyprland.focusedWorkspace && !ids.includes(Hyprland.focusedWorkspace.id))
            ids.push(Hyprland.focusedWorkspace.id);
        return ids.filter(i => i > 0).sort((a, b) => a - b);
    }

    Repeater {
        model: root.wsIds

        Item {
            property int wsId: modelData
            property bool isActive: Hyprland.focusedWorkspace
                                    && Hyprland.focusedWorkspace.id === wsId
            
            // Largeur dynamique pour repousser les éléments adjacents si besoin
            width: rect.width
            height: 22

            Rectangle {
                id: rect
                anchors.centerIn: parent
                
                // Le rond s'allonge en pilule s'il est actif
                width: parent.isActive ? 28 : 10
                height: 10
                radius: 5

                color: {
                    if (parent.isActive) return Theme.accent
                    if (ma.containsMouse) return Theme.textDim
                    return Theme.textMuted
                }

                Behavior on width { NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutBack } }
                Behavior on height { NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutBack } }
                Behavior on radius { NumberAnimation { duration: Theme.animFast } }
                Behavior on color  { ColorAnimation { duration: Theme.animFast } }
            }

            MouseArea {
                id: ma
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: Hyprland.dispatch("workspace " + parent.wsId)
            }
        }
    }
}
