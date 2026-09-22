
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Io
import "."

PanelWindow {
    id: root
    property string mode: ""
    property bool isOpen: mode !== ""

    // Reste visible pendant l'anim de fermeture
    property bool _shouldShow: isOpen
    visible: _shouldShow || content.opacity > 0.01

    color: "transparent"

    anchors {
        top: true
        right: true
        bottom: true
    }
    margins.top: 1
    margins.right: 0
    margins.bottom: 1

    implicitWidth: 300

    PwObjectTracker { objects: [Pipewire.defaultAudioSink] }

    // Clic à l'extérieur pour fermer
    MouseArea {
        anchors.fill: parent
        enabled: root.isOpen
        onClicked: root.mode = ""
    }

    Rectangle {
        id: content
        anchors.fill: parent
        anchors.margins: 6
        radius: 14
        color: Theme.bgPanel
        border.color: Theme.border
        border.width: 1

        // bloque la propagation du clic
        MouseArea { anchors.fill: parent; onClicked: {} }

        // === ANIMATIONS D'ENTRÉE/SORTIE ===
        opacity: root.isOpen ? 1 : 0
        transform: [
            Translate {
                id: slideT
                x: root.isOpen ? 0 : 50
            },
            Scale {
                id: scaleT
                origin.x: content.width
                origin.y: 20
                xScale: root.isOpen ? 1 : 0.94
                yScale: root.isOpen ? 1 : 0.94
            }
        ]

        Behavior on opacity {
            NumberAnimation {
                duration: root.isOpen ? 280 : 180
                easing.type: root.isOpen ? Easing.OutCubic : Easing.InCubic
            }
        }

        // Barre orange qui se trace
        Rectangle {
            id: topAccent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 12
            anchors.leftMargin: 14
            height: 2
            radius: 1
            color: Theme.accent
            opacity: 0.85
            width: root.isOpen ? (parent.width - 28) : 0

            Behavior on width {
                NumberAnimation {
                    duration: 450
                    easing.type: Easing.OutExpo
                }
            }
        }

        // Loader avec animation au switch de mode
        Loader {
            id: loader
            anchors.fill: parent
            anchors.margins: 18
            anchors.topMargin: 26

            sourceComponent: {
                if (root.mode === "wifi") return wifiView
                if (root.mode === "bluetooth") return btView
                if (root.mode === "battery") return batView
                if (root.mode === "clock") return clockView
                if (root.mode === "volume") return volumeView
                return null
            }

            opacity: 0
            transform: Translate { id: loaderSlide; y: 10 }

            onLoaded: {
                if (item) loaderFadeIn.restart()
            }

            ParallelAnimation {
                id: loaderFadeIn
                NumberAnimation {
                    target: loader; property: "opacity"
                    from: 0; to: 1
                    duration: 260; easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    target: loaderSlide; property: "y"
                    from: 10; to: 0
                    duration: 320; easing.type: Easing.OutCubic
                }
            }
        }
    }

    // Animations sur translate/scale
    Behavior on isOpen {
        // Trigger animations via le binding ci-dessus
    }

    // On utilise des Behavior directs sur les transforms
    NumberAnimation {
        id: slideAnim
        target: slideT; property: "x"
        duration: root.isOpen ? 380 : 200
        easing.type: root.isOpen ? Easing.OutExpo : Easing.InCubic
    }

    Connections {
        target: root
        function onIsOpenChanged() {
            slideT.x = root.isOpen ? 0 : 50
            scaleT.xScale = root.isOpen ? 1 : 0.94
            scaleT.yScale = root.isOpen ? 1 : 0.94
        }
    }

    Behavior on _shouldShow {
        // pas d'animation, juste le binding
    }

    // ---------- styles partagés ----------
    component SectionTitle : Text {
        color: Theme.accent
        font.pixelSize: 11
        font.family: Theme.fontMain
        font.letterSpacing: 1.5
        font.capitalization: Font.AllUppercase
    }
    component Header : Text {
        color: Theme.textBright
        font.pixelSize: 18
        font.family: Theme.fontMain
        font.weight: Font.Medium
    }
    component Sub : Text {
        color: Theme.textDim
        font.pixelSize: 11
        font.family: Theme.fontMain
    }

    // ---------- WIFI ----------
    
// ---------- WIFI ----------
Component {
    id: wifiView
    Column {
        id: wifiCol
        spacing: 12
        width: parent.width

        property bool enabled: false
        property string activeSsid: ""
        property var networks: []

        function refresh() { scanProc.running = true }

        
Process {
    id: scanProc
    command: ["sh", "-c",
        "nmcli -t -f WIFI g; echo '---'; nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY dev wifi list"]
    running: true
    stdout: StdioCollector {
        onStreamFinished: {
            const lines = text.trim().split("\n")
            wifiCol.enabled = lines[0].indexOf("enabled") !== -1
            const nets = []
            let active = ""
            const seen = {}
            let started = false
            for (let i = 0; i < lines.length; i++) {
                if (lines[i] === "---") { started = true; continue }
                if (!started) continue
                const p = lines[i].split(":")
                if (p.length < 4) continue
                const ssid = p[1]
                if (!ssid || seen[ssid]) continue
                seen[ssid] = true
                const isActive = (p[0] === "*")
                if (isActive) active = ssid
                nets.push({
                    ssid: ssid,
                    signal: parseInt(p[2]) || 0,
                    secure: p[3] !== "",
                    active: isActive
                })
            }
            nets.sort((a, b) => b.signal - a.signal)
            wifiCol.networks = nets
            wifiCol.activeSsid = active
        }
    }
}

        Process {
            id: actionProc
            running: false
            stdout: StdioCollector { onStreamFinished: wifiCol.refresh() }
        }

        Timer {
            interval: 8000; running: true; repeat: true
            onTriggered: wifiCol.refresh()
        }

        SectionTitle { text: "Network" }

       
Item {
    width: parent.width
    height: 28

    Header {
        text: "󰖩  Wi-Fi"
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        id: toggleSwitch
        width: 44; height: 22; radius: 11
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        color: wifiCol.enabled ? Theme.accent : Theme.bgDeep
        Behavior on color { ColorAnimation { duration: 200 } }

        Rectangle {
            width: 16; height: 16; radius: 8
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
            x: wifiCol.enabled ? 25 : 3
            Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        }
       
MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: {
        const newState = !wifiCol.enabled
        wifiCol.enabled = newState  // ← update visuel immédiat
        actionProc.command = ["sh", "-c",
            newState ? "nmcli radio wifi on" : "nmcli radio wifi off"]
        actionProc.running = true
        refreshTimer.start()
    }
}

    }
}

Timer {
    id: refreshTimer
    interval: 800
    onTriggered: wifiCol.refresh()
}


        Sub {
            text: wifiCol.enabled
                ? (wifiCol.activeSsid ? "Connecté à " + wifiCol.activeSsid : "Aucune connexion")
                : "Wi-Fi désactivé"
        }

        // Liste des réseaux
        ScrollView {
            width: parent.width
            height: 280
            visible: wifiCol.enabled
            clip: true

            ListView {
                model: wifiCol.networks
                spacing: 4
                delegate: Rectangle {
                    width: ListView.view.width
                    height: 44
                    radius: 8
                    color: ma.containsMouse ? Theme.bgHover : (modelData.active ? Theme.bgPill : "transparent")
                    border.color: modelData.active ? Theme.border : "transparent"
                    border.width: 1

                    Behavior on color { ColorAnimation { duration: 120 } }

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        spacing: 10

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: {
                                if (modelData.signal > 75) return "󰤨"
                                if (modelData.signal > 50) return "󰤥"
                                if (modelData.signal > 25) return "󰤢"
                                return "󰤟"
                            }
                            color: modelData.active ? Theme.accent : Theme.text
                            font.family: Theme.fontMain
                            font.pixelSize: 16
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2
                            Text {
                                text: modelData.ssid
                                color: Theme.text
                                font.family: Theme.fontMain
                                font.pixelSize: 12
                            }
                            Text {
                                text: (modelData.secure ? "󰌾 " : "") + modelData.signal + "%"
                                color: Theme.textDim
                                font.family: Theme.fontMain
                                font.pixelSize: 10
                            }
                        }

                        Item { width: parent.width - 200; height: 1 }

                        Text {
                            visible: modelData.active
                            anchors.verticalCenter: parent.verticalCenter
                            text: "✓"
                            color: Theme.accent
                            font.pixelSize: 14
                        }
                    }

                    MouseArea {
                        id: ma
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (modelData.active) return
                            // Tente de se connecter (utilise les creds enregistrés si dispo)
                            actionProc.command = ["sh", "-c",
                                "nmcli dev wifi connect " + JSON.stringify(modelData.ssid)
                                + " || notify-send 'Wi-Fi' 'Connexion à " + modelData.ssid + " impossible — mot de passe requis'"]
                            actionProc.running = true
                        }
                    }
                }
            }
        }
    }
}

    // ---------- BLUETOOTH ----------
   
// ─────── BLUETOOTH ───────
Component {
    id: btView
    Column {
        id: btCol
        spacing: 14
        width: parent.width

        property bool powered: false
        property string connectedDevice: ""
        property var devices: []  // [{mac, name, connected}]

        function refresh() {
            stateProc.running = true
            devicesProc.running = true
        }

        Component.onCompleted: refresh()

        // État power + device connecté
        Process {
            id: stateProc
            command: ["bash", "-c",
                "bluetoothctl show | grep -q 'Powered: yes' && echo ON || echo OFF"]
            stdout: SplitParser {
                onRead: data => {
                    btCol.powered = (data.trim() === "ON")
                }
            }
        }

        // Liste des appareils appairés + état connected
        Process {
            id: devicesProc
            command: ["bash", "-c",
                "bluetoothctl devices Paired | while read -r _ mac name; do " +
                "  conn=$(bluetoothctl info \"$mac\" | grep -q 'Connected: yes' && echo 1 || echo 0); " +
                "  echo \"$mac|$conn|$name\"; " +
                "done"]
            stdout: SplitParser {
                splitMarker: "\n"
                onRead: data => {
                    const lines = data.split("\n").filter(l => l.trim().length > 0)
                    const list = []
                    let connected = ""
                    for (const line of lines) {
                        const parts = line.split("|")
                        if (parts.length < 3) continue
                        const mac = parts[0]
                        const isConn = parts[1] === "1"
                        const name = parts.slice(2).join("|")
                        list.push({ mac: mac, name: name, connected: isConn })
                        if (isConn) connected = name
                    }
                    btCol.devices = list
                    btCol.connectedDevice = connected
                }
            }
        }

        Process {
            id: btActionProc
            running: false
        }

        Timer {
            id: btRefreshTimer
            interval: 1200
            onTriggered: btCol.refresh()
        }

        Timer {
            interval: 5000
            running: true
            repeat: true
            onTriggered: btCol.refresh()
        }

        SectionTitle { text: "Devices" }

        // Header avec toggle
        Item {
            width: parent.width
            height: 32

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10
                Text {
                    text: "󰂯"
                    color: btCol.powered ? Theme.accentSoft : Theme.textMuted
                    font.pixelSize: 20
                    font.family: "Symbols Nerd Font"
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: "Bluetooth"
                    color: Theme.textBright
                    font.pixelSize: 18
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            // Toggle switch
            Rectangle {
                anchors.right: parent.right
                anchors.rightMargin: 4
                anchors.verticalCenter: parent.verticalCenter
                width: 40
                height: 22
                radius: 11
                color: btCol.powered ? Theme.accentSoft : Theme.bgDeep
                Behavior on color { ColorAnimation { duration: 150 } }

                Rectangle {
                    width: 18
                    height: 18
                    radius: 9
                    color: Theme.textBright
                    y: 2
                    x: btCol.powered ? 20 : 2
                    Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        const newState = !btCol.powered
                        btCol.powered = newState
                        btActionProc.command = ["sh", "-c",
                            newState ? "bluetoothctl power on" : "bluetoothctl power off"]
                        btActionProc.running = true
                        btRefreshTimer.start()
                    }
                }
            }
        }

        // Statut connecté
        Sub {
            text: btCol.powered
                ? (btCol.connectedDevice.length > 0
                    ? "Connecté : " + btCol.connectedDevice
                    : "Aucun appareil connecté")
                : "Bluetooth désactivé"
        }

        // Liste des appareils appairés
        Repeater {
            model: btCol.powered ? btCol.devices : []
            delegate: Rectangle {
                width: parent.width
                height: 38
                radius: 8
                color: devMouse.containsMouse ? Theme.bgHover : "transparent"
                Behavior on color { ColorAnimation { duration: 120 } }

                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10

                    Text {
                        text: modelData.connected ? "✓" : "·"
                        color: modelData.connected ? Theme.accentSoft : Theme.textMuted
                        font.pixelSize: 16
                        width: 12
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: modelData.name
                        color: Theme.text
                        font.pixelSize: 14
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: devMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (modelData.connected) {
                            btActionProc.command = ["bluetoothctl", "disconnect", modelData.mac]
                        } else {
                            btActionProc.command = ["bluetoothctl", "connect", modelData.mac]
                        }
                        btActionProc.running = true
                        btRefreshTimer.start()
                    }
                }
            }
        }
    }
}


    // ---------- BATTERY ----------
    
// ---------- BATTERY ----------
Component {
    id: batView
    Column {
        id: batCol
        spacing: 14
        width: parent.width

        property int pct: 0
        property string status: "Unknown"
        property bool charging: status === "Charging" || status === "Full"

        Process {
            id: batProc
            command: ["sh", "-c", "cat /sys/class/power_supply/BAT0/capacity /sys/class/power_supply/BAT0/status"]
            running: true
            stdout: StdioCollector {
                onStreamFinished: {
                    const lines = text.trim().split("\n")
                    if (lines.length >= 2) {
                        batCol.pct = parseInt(lines[0])
                        batCol.status = lines[1]
                    }
                }
            }
        }
        Timer {
            interval: 10000
            running: true
            repeat: true
            onTriggered: batProc.running = true
        }

        SectionTitle { text: "Power" }
        Header {
            text: {
                let icon = "󰁹"
                if (batCol.charging) icon = "󰂄"
                else if (batCol.pct > 80) icon = "󰁹"
                else if (batCol.pct > 60) icon = "󰂀"
                else if (batCol.pct > 40) icon = "󰁾"
                else if (batCol.pct > 20) icon = "󰁼"
                else icon = "󰁺"
                return icon + "  Batterie"
            }
        }
        Text {
            text: batCol.pct + "%"
            color: Theme.accent
            font.pixelSize: 36
            font.family: Theme.fontMain
        }
        Sub {
            text: {
                if (batCol.status === "Charging") return "État : En charge ⚡"
                if (batCol.status === "Discharging") return "État : Décharge"
                if (batCol.status === "Full") return "État : Pleine"
                if (batCol.status === "Not charging") return "État : Branchée"
                return "État : " + batCol.status
            }
        }
    }
}


   
// ─────── DATE & TIME ───────
Component {
    id: clockView
    Column {
        id: clockCol
        spacing: 14
        width: parent.width

        property var now: new Date()

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clockCol.now = new Date()
        }

        function pad(n) { return n < 10 ? "0" + n : "" + n }
        function fmtDate(d) {
            const days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
            const months = ["January","February","March","April","May","June",
                            "July","August","September","October","November","December"]
            return days[d.getDay()] + " " + pad(d.getDate()) + " " + months[d.getMonth()] + " " + d.getFullYear()
        }

        SectionTitle { text: "Date & Time" }

        Sub {
            text: clockCol.fmtDate(clockCol.now)
        }

        // Heure géante avec secondes
        Row {
            spacing: 6
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: clockCol.pad(clockCol.now.getHours()) + ":" + clockCol.pad(clockCol.now.getMinutes())
                color: Theme.accent
                font.pixelSize: 56
                font.bold: true
                anchors.bottom: parent.bottom
            }
            Text {
                text: ":" + clockCol.pad(clockCol.now.getSeconds())
                color: Theme.accent
                opacity: 0.6
                font.pixelSize: 28
                font.bold: true
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 6
            }
        }

        // Mini calendrier
        Rectangle {
            width: parent.width
            height: calGrid.height + 50
            radius: 10
            color: Theme.bgDeep
            border.color: Theme.border
            border.width: 1

            property int viewYear: clockCol.now.getFullYear()
            property int viewMonth: clockCol.now.getMonth()  // 0-11

            function daysInMonth(y, m) { return new Date(y, m + 1, 0).getDate() }
            function firstWeekday(y, m) {
                // Lundi = 0 ... Dimanche = 6
                let d = new Date(y, m, 1).getDay()
                return (d + 6) % 7
            }

            Column {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                // Header mois + nav
                Item {
                    width: parent.width
                    height: 22

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: {
                            const months = ["January","February","March","April","May","June",
                                            "July","August","September","October","November","December"]
                            return months[parent.parent.parent.viewMonth] + " " + parent.parent.parent.viewYear
                        }
                        color: Theme.text
                        font.pixelSize: 13
                        font.bold: true
                    }

                    Row {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4

                        Text {
                            text: "‹"
                            color: Theme.accent
                            font.pixelSize: 18
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    const r = parent.parent.parent.parent.parent
                                    if (r.viewMonth === 0) { r.viewMonth = 11; r.viewYear-- }
                                    else r.viewMonth--
                                }
                            }
                        }
                        Text {
                            text: "›"
                            color: Theme.accent
                            font.pixelSize: 18
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    const r = parent.parent.parent.parent.parent
                                    if (r.viewMonth === 11) { r.viewMonth = 0; r.viewYear++ }
                                    else r.viewMonth++
                                }
                            }
                        }
                    }
                }

                // Jours de la semaine
                Row {
                    width: parent.width
                    Repeater {
                        model: ["M","T","W","T","F","S","S"]
                        delegate: Item {
                            width: parent.width / 7
                            height: 16
                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                color: Theme.textMuted
                                font.pixelSize: 11
                                font.bold: true
                            }
                        }
                    }
                }

                // Grille des jours
                Grid {
                    id: calGrid
                    width: parent.width
                    columns: 7
                    rowSpacing: 2
                    columnSpacing: 0

                    Repeater {
                        model: 42
                        delegate: Item {
                            width: calGrid.width / 7
                            height: 24

                            property int offset: calGrid.parent.parent.firstWeekday(
                                calGrid.parent.parent.viewYear,
                                calGrid.parent.parent.viewMonth)
                            property int dim: calGrid.parent.parent.daysInMonth(
                                calGrid.parent.parent.viewYear,
                                calGrid.parent.parent.viewMonth)
                            property int dayNum: index - offset + 1
                            property bool valid: dayNum >= 1 && dayNum <= dim
                            property bool isToday: valid
                                && dayNum === clockCol.now.getDate()
                                && calGrid.parent.parent.viewMonth === clockCol.now.getMonth()
                                && calGrid.parent.parent.viewYear === clockCol.now.getFullYear()

                            Rectangle {
                                anchors.centerIn: parent
                                width: 22
                                height: 22
                                radius: 11
                                color: parent.isToday ? Theme.accent : "transparent"
                            }
                            Text {
                                anchors.centerIn: parent
                                text: parent.valid ? parent.dayNum : ""
                                color: parent.isToday ? "#000" : Theme.text
                                font.pixelSize: 12
                                font.bold: parent.isToday
                            }
                        }
                    }
                }
            }
        }
    }
}


 
// ------ VOLUME ------
Component {
    id: volumeView
    Column {
        spacing: 14; width: parent.width

        // Track tous les sinks pour les lister
        PwObjectTracker {
            objects: {
                let arr = []
                if (Pipewire.defaultAudioSink) arr.push(Pipewire.defaultAudioSink)
                for (let n of Pipewire.nodes.values)
                    if (n.isSink && !n.isStream) arr.push(n)
                return arr
            }
        }

        SectionTitle { text: "Audio" }

        // ── Header avec icône mute cliquable ──
        Row {
            spacing: 8; width: parent.width
            Text {
                id: muteIcon
                text: (Pipewire.defaultAudioSink?.audio?.muted ?? false) ? "󰝟"
                    : (volSlider.value > 0.5 ? "󰕾"
                    : volSlider.value > 0   ? "󰖀" : "󰕿")
                color: muteMa.containsMouse ? Theme.accent : Theme.text
                font.pixelSize: 16
                font.family: Theme.fontMain
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    id: muteMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (Pipewire.defaultAudioSink?.audio)
                            Pipewire.defaultAudioSink.audio.muted =
                                !Pipewire.defaultAudioSink.audio.muted
                    }
                }
            }
            Text {
                text: "Volume"
                color: Theme.text
                font.pixelSize: 13
                font.family: Theme.fontMain
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // ── Slider ──
        
Row {
    spacing: 12; width: parent.width

    Item {
        width: parent.width - valLabel.width - 12
        height: 20
        anchors.verticalCenter: parent.verticalCenter

        Slider {
            id: volSlider
            anchors.fill: parent
            from: 0; to: 1
            value: Pipewire.defaultAudioSink?.audio?.volume ?? 0
            onMoved: {
                if (Pipewire.defaultAudioSink?.audio)
                    Pipewire.defaultAudioSink.audio.volume = value
            }
            background: Rectangle {
                x: volSlider.leftPadding
                y: volSlider.topPadding + volSlider.availableHeight / 2 - height / 2
                width: volSlider.availableWidth; height: 4
                radius: 2; color: Theme.bgPill
                Rectangle {
                    width: volSlider.visualPosition * parent.width
                    height: parent.height; radius: 2
                    color: (Pipewire.defaultAudioSink?.audio?.muted ?? false)
                        ? Theme.textMuted : Theme.accent
                }
            }
            handle: Rectangle {
                x: volSlider.leftPadding + volSlider.visualPosition * (volSlider.availableWidth - width)
                y: volSlider.topPadding + volSlider.availableHeight / 2 - height / 2
                width: 14; height: 14; radius: 7
                color: (Pipewire.defaultAudioSink?.audio?.muted ?? false)
                    ? Theme.textMuted : Theme.accent
                border.color: "transparent"; border.width: 2
            }
        }

        // Scroll par-dessus, sans bloquer le drag
        WheelHandler {
            target: null
            onWheel: (event) => {
                if (!Pipewire.defaultAudioSink?.audio) return
                const step = 0.05
                const v = Pipewire.defaultAudioSink.audio.volume
                Pipewire.defaultAudioSink.audio.volume = event.angleDelta.y > 0
                    ? Math.min(1, v + step) : Math.max(0, v - step)
            }
        }
    }

    Text {
        id: valLabel
        text: Math.round(volSlider.value * 100) + "%"
        color: Theme.text; font.pixelSize: 12
        font.family: Theme.fontMain
        anchors.verticalCenter: parent.verticalCenter
    }
}

        Sub {
            text: Pipewire.defaultAudioSink?.description ?? "—"
            elide: Text.ElideRight; width: parent.width
        }

        // ── Liste des périphériques de sortie ──
        Item { width: 1; height: 6 }
        Header { text: "󰓃  Périphériques" }

        Repeater {
            model: {
                let arr = []
                let seen = {}
                for (let n of Pipewire.nodes.values) {
                    if (!n.isSink) continue
                    if (n.isStream) continue
                    if (!n.audio) continue
                    if (!n.description) continue
                    if (seen[n.description]) continue
                    seen[n.description] = true
                    arr.push(n)
                }
                arr.sort((a, b) => {
                    if (a === Pipewire.defaultAudioSink) return -1
                    if (b === Pipewire.defaultAudioSink) return 1
                    return a.description.localeCompare(b.description)
                })
                return arr
            }
            delegate: Rectangle {
                required property var modelData
                width: parent.width
                height: 30
                radius: 6
                color: {
                    const isDefault = modelData === Pipewire.defaultAudioSink
                    if (isDefault) return Theme.bgPill
                    return devMa.containsMouse ? Theme.bgHover : "transparent"
                }
                border.color: modelData === Pipewire.defaultAudioSink
                    ? Theme.accent : "transparent"
                border.width: 1
                Behavior on color { ColorAnimation { duration: 120 } }

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 8

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData === Pipewire.defaultAudioSink ? "󰄬" : "󰓃"
                        color: modelData === Pipewire.defaultAudioSink
                            ? Theme.accent : Theme.textDim
                        font.pixelSize: 12
                        font.family: Theme.fontMain
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.description || modelData.name
                        color: Theme.text
                        font.pixelSize: 11
                        font.family: Theme.fontMain
                        elide: Text.ElideRight
                        width: parent.width - 30
                    }
                }

                MouseArea {
                    id: devMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Pipewire.preferredDefaultAudioSink = modelData
                }
            }
        }
    }
}


}

