import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "."

PanelWindow {
    id: bar

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "quickshell"

    anchors { top: true; left: true; right: true }
    implicitHeight: 34
    color: "transparent"

    Rectangle {
        id: barBg
        anchors.fill: parent
        radius: 0
        color: Theme.barBg
        
        border.color: Theme.border
        border.width: 0

        // ── LEFT ──
        Row {
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            spacing: 16

            LeftSection {
                anchors.verticalCenter: parent.verticalCenter
            }

            Workspaces {
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // ── CENTER (horloge) ──
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            ClockPill { 
                panelMode: "clock";     
                onClicked: pillPanel.mode = (pillPanel.mode === "clock" ? "" : "clock") 
            }
        }

        // ── RIGHT ──
        Row {
            anchors.right: parent.right
            anchors.rightMargin: 14
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6

            VolumePill { 
                panelMode: "volume";
                onClicked: pillPanel.mode = (pillPanel.mode === "volume" ? "" : "volume") 
            }
            WifiPill { 
                panelMode: "wifi";
                onClicked: pillPanel.mode = (pillPanel.mode === "wifi" ? "" : "wifi") 
            }
            BluetoothPill { 
                panelMode: "bluetooth"; 
                onClicked: pillPanel.mode = (pillPanel.mode === "bluetooth" ? "" : "bluetooth") 
            }
            BatteryPill { 
                panelMode: "battery";   
                onClicked: pillPanel.mode = (pillPanel.mode === "battery" ? "" : "battery") 
            }
        }
    }

    PillPanel { id: pillPanel }
}
