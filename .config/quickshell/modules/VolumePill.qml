
import QtQuick
import Quickshell.Services.Pipewire
import "."

Pill {
    id: pill

    property var sink: Pipewire.defaultAudioSink
    property real volume: sink?.audio?.volume ?? 0
    property bool muted: sink?.audio?.muted ?? false

    PwObjectTracker { objects: [pill.sink] }

    accent: Theme.accent

    icon: {
      if (muted || volume === 0) return "󰝟"
        if (volume < 0.34) return "\uf026"
        if (volume < 0.67) return "\uf027"
        return "\uf028"
    }

    label: muted ? "muted" : Math.round(volume * 100) + "%"

    expandedText: "Volume: " + (muted ? "muted" : Math.round(volume * 100) + "%")

    // Scroll pour ajuster le volume
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onWheel: (wheel) => {
            if (!pill.sink?.audio) return
            const step = 0.05
            const delta = wheel.angleDelta.y > 0 ? step : -step
            pill.sink.audio.volume = Math.max(0, Math.min(1, pill.volume + delta))
        }
    }
}
