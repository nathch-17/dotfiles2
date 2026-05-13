
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris
import "."

Item {
    id: root

    // ── États ──
    readonly property var sizes: ({
        "resting":  { w: 90,  h: 26 },
        "hover":    { w: 200, h: 26 },
        "volume":   { w: 230, h: 30 },
        "music":    { w: 270, h: 30 },
        "expanded": { w: 320, h: 180 },
    })

    property string state_: "resting"

    width:  sizes[state_].w
    height: sizes[state_].h

    Behavior on width  { NumberAnimation { duration: Theme.animSlow; easing.type: Easing.OutExpo } }
    Behavior on height { NumberAnimation { duration: Theme.animSlow; easing.type: Easing.OutExpo } }

    // ── Pipewire ──
    PwObjectTracker { objects: [ Pipewire.defaultAudioSink ] }
    property PwNode sink:  Pipewire.defaultAudioSink
    property real   vol:   sink?.audio?.volume ?? 0
    property bool   muted: sink?.audio?.muted  ?? false

    // ── Mpris ──
    property var player: {
        const list = MprisController.players.values
        for (let i = 0; i < list.length; i++) {
            if (list[i].playbackState === MprisPlaybackState.Playing) return list[i]
        }
        return list[0] ?? null
    }
    property bool hasMusic: player !== null && (player?.trackTitle ?? "") !== ""

    // ── Horloge ──
    property var now: new Date()
    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: root.now = new Date()
    }

    // ── Timer volume ──
    Timer {
        id: volTimer
        interval: 2000
        onTriggered: {
            if (root.state_ === "volume")
                root.state_ = root.hasMusic ? "music" : "resting"
        }
    }

    // ── Réactions ──
    onVolChanged: {
        if (state_ !== "expanded") {
            state_ = "volume"
            volTimer.restart()
        }
    }
    onHasMusicChanged: {
        if (state_ === "resting" || state_ === "hover")
            state_ = hasMusic ? "music" : "resting"
    }

    // ── Pilule ──
    Rectangle {
        id: pill
        anchors.fill: parent
        radius: height / 2
        color: Theme.pillBg
        border.color: Theme.border
        border.width: 1
        clip: true

        // ─ RESTING : heure ─
        Text {
            anchors.centerIn: parent
            text: Qt.formatDateTime(root.now, "HH:mm")
            color: Theme.text
            font.pixelSize: 13
            font.family: Theme.fontMain
            font.weight: Font.Medium
            opacity: root.state_ === "resting" ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: Theme.animFast } }
        }

        // ─ HOVER : date complète ─
        Text {
            anchors.centerIn: parent
            text: Qt.formatDateTime(root.now, "ddd d MMM · HH:mm")
            color: Theme.text
            font.pixelSize: 12
            font.family: Theme.fontMain
            opacity: root.state_ === "hover" ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: Theme.animFast } }
        }

        // ─ VOLUME ─
        Row {
            anchors.centerIn: parent
            spacing: 8
            opacity: root.state_ === "volume" ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: Theme.animFast } }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.muted ? "󰝟" : root.vol > 0.5 ? "󰕾" : root.vol > 0 ? "󰖀" : "󰕿"
                color: Theme.accent
                font.pixelSize: 14
                font.family: Theme.fontIcon
            }
            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: 110; height: 4; radius: 2
                color: Qt.rgba(1, 1, 1, 0.15)
                Rectangle {
                    width: parent.width * root.vol
                    height: parent.height; radius: 2
                    color: Theme.accent
                    Behavior on width { NumberAnimation { duration: 100 } }
                }
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: Math.round(root.vol * 100) + "%"
                color: Theme.textDim
                font.pixelSize: 11
                font.family: Theme.fontMain
            }
        }

        // ─ MUSIC compact ─
        Row {
            anchors.centerIn: parent
            spacing: 8
            opacity: root.state_ === "music" ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: Theme.animFast } }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "󰋋"
                color: Theme.music
                font.pixelSize: 14
                font.family: Theme.fontIcon
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                width: 220
                text: {
                    const t = root.player?.trackTitle  ?? ""
                    const a = root.player?.trackArtist ?? ""
                    return a !== "" ? t + " — " + a : t
                }
                color: Theme.text
                font.pixelSize: 11
                font.family: Theme.fontMain
                elide: Text.ElideRight
            }
        }

        // ─ EXPANDED ─
        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12
            opacity: root.state_ === "expanded" ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: Theme.animMed } }

            // Track info
            Column {
                spacing: 2
                width: parent.width

                Text {
                    text: "󰋋  " + (root.player?.trackTitle ?? "Aucune lecture")
                    color: Theme.text
                    font.pixelSize: 13
                    font.family: Theme.fontMain
                    font.weight: Font.Medium
                    elide: Text.ElideRight
                    width: parent.width
                }
                Text {
                    text: root.player?.trackArtist ?? ""
                    color: Theme.textDim
                    font.pixelSize: 11
                    font.family: Theme.fontMain
                    elide: Text.ElideRight
                    width: parent.width
                }
            }

            // Controls
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 24

                Repeater {
                    model: [
                        { icon: "󰒮", action: "prev" },
                        { icon: root.player?.playbackState === MprisPlaybackState.Playing ? "󰏤" : "󰐊", action: "play" },
                        { icon: "󰒭", action: "next" },
                    ]
                    Text {
                        required property var modelData
                        text: modelData.icon
                        color: Theme.text
                        font.pixelSize: 18
                        font.family: Theme.fontIcon

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onEntered: parent.color = Theme.accent
                            onExited:  parent.color = Theme.text
                            onClicked: {
                                if (!root.player) return
                                if (modelData.action === "prev") root.player.previous()
                                else if (modelData.action === "play") root.player.playPause()
                                else root.player.next()
                            }
                        }
                    }
                }
            }

            // Volume slider
            Row {
                spacing: 8
                width: parent.width

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.muted ? "󰝟" : "󰕾"
                    color: Theme.accent
                    font.pixelSize: 13
                    font.family: Theme.fontIcon
                }
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 200; height: 5; radius: 2.5
                    color: Qt.rgba(1, 1, 1, 0.15)

                    Rectangle {
                        width: parent.width * root.vol
                        height: parent.height; radius: parent.radius
                        color: Theme.accent
                        Behavior on width { NumberAnimation { duration: 80 } }
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: (m) => {
                            if (root.sink) root.sink.audio.volume = Math.max(0, Math.min(1, m.x / width))
                        }
                    }
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: Math.round(root.vol * 100) + "%"
                    color: Theme.textDim
                    font.pixelSize: 11
                    font.family: Theme.fontMain
                }
            }
        }

        // ── MouseArea globale ──
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton

            onEntered: { if (root.state_ === "resting") root.state_ = "hover" }
            onExited:  { if (root.state_ === "hover")   root.state_ = "resting" }

            onClicked: {
                if (root.state_ === "expanded")
                    root.state_ = root.hasMusic ? "music" : "resting"
                else
                    root.state_ = "expanded"
            }

            onWheel: (wheel) => {
                if (!root.sink) return
                const step = 0.05
                const v = root.sink.audio.volume
                root.sink.audio.volume = wheel.angleDelta.y > 0
                    ? Math.min(1.0, v + step)
                    : Math.max(0.0, v - step)
            }
        }
    }
}
