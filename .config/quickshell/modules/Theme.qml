
pragma Singleton
import QtQuick

QtObject {
    // ── Surfaces / fonds ──
    readonly property color bgDeep:    "#0d0a08"
    readonly property color barBg:     Qt.rgba(0.05, 0.04, 0.03, 0.8)
    readonly property color bgPanel:   Qt.rgba(0.09, 0.07, 0.06, 0.72)
    readonly property color bgPill:    Qt.rgba(0.12, 0.09, 0.07, 0.55)
    readonly property color bgHover:   Qt.rgba(0.18, 0.13, 0.09, 0.75)

    // ── Bordures ──
    readonly property color border:       Qt.rgba(1, 0.55, 0.2, 0.18)
    readonly property color borderStrong: Qt.rgba(1, 0.55, 0.2, 0.35)

    // ── Accents orange Zen ──
    readonly property color accent:      "#e8833a"
    readonly property color accentSoft:  "#c97339"
    readonly property color accentGlow:  "#ff9d52"
    readonly property color accentLight: "#ffc94d"
    readonly property color accentDim:   Qt.rgba(0.91, 0.51, 0.23, 0.15)

    // ── Texte ──
    readonly property color text:       "#f4ebe2"
    readonly property color textBright: "#ffffff"
    readonly property color textNormal: "#d8cabb"
    readonly property color textDim:    "#8a7e72"
    readonly property color textMuted:  "#5a5048"

    // ── États ──
    readonly property color ok:      "#a3b86c"
    readonly property color warn:    "#e8a33a"
    readonly property color danger:  "#d96a4a"
    readonly property color urgent:  "#e06c75"
    readonly property color music:   "#1db954"

    // ── Géométrie ──
    readonly property int radiusPill:  14
    readonly property int radiusPanel: 18
    readonly property int radiusBar:   20
    readonly property int gap:         8
    readonly property int padPill:     10

    // ── Typo (Maple Mono NF partout) ──
    readonly property string fontMain: "Maple Mono NF"
    readonly property string fontMono: "Maple Mono NF"
    readonly property string fontIcon: "Maple Mono NF"

    // Tailles
    readonly property int fontPill:       12
    readonly property int fontIconSize:   14
    readonly property int fontSizeSmall:  11
    readonly property int fontSizeNormal: 12
    readonly property int fontSizeLarge:  14
    readonly property int fontSizeIcon:   16

    // ── Animations ──
    readonly property int animFast: 150
    readonly property int animMed:  250
    readonly property int animSlow: 350
}

