
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "."

PanelWindow {
    id: bar

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "quickshell:bar"

    anchors { top: true; left: true; right: true }
    implicitHeight: 38
    color: "transparent"

    Rectangle {
        id: barBg
        anchors.fill: parent
        anchors.margins: 6
        radius: 14
        color: "transparent"
        
        border.width: 0

        // ── LEFT ──
        //
        
    LeftSection {
      anchors.left: parent.left
      anchors.leftMargin: 12
      anchors.verticalCenter: parent.verticalCenter
  }
        
        

       
        // ── CENTER (vraiment centré sur la barre) ──
        
        Row{
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter

            Workspaces {
              
              anchors.verticalCenter: parent.verticalCenter
          }

        }
        // ── RIGHT ──

       
// ── RIGHT ──
Row {
    anchors.right: parent.right
    anchors.rightMargin: 14
    anchors.verticalCenter: parent.verticalCenter
    spacing: 6


    VolumePill    { 
      panelMode: "volume";
      
      onClicked: pillPanel.mode = (pillPanel.mode === "volume" ? "" : "volume") 

      }

    WifiPill      { 
      panelMode: "wifi";
      
      onClicked: pillPanel.mode = (pillPanel.mode === "wifi" ? "" : "wifi") 

    }

    BluetoothPill { 
      panelMode: "bluetooth"; 
      
      onClicked: pillPanel.mode = (pillPanel.mode === "bluetooth" ? "" : "bluetooth") 
    }

    BatteryPill   { 
      panelMode: "battery";   
    
      onClicked: pillPanel.mode = (pillPanel.mode === "battery" ? "" : "battery") 
    }

    ClockPill     { 
    panelMode: "clock";     
    
    onClicked: pillPanel.mode = (pillPanel.mode === "clock" ? "" : "clock") 

    } 
  
  }



}


PillPanel { id: pillPanel }



  }



