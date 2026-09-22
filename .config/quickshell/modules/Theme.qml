pragma Singleton
import QtQuick

QtObject {
    // ── Surfaces / fonds (Fond Terminal: #0b0b0e) ──
    readonly property color bgDeep:    "#0b0b0e"
    readonly property color barBg:     Qt.rgba(11/255, 11/255, 14/255, 0.85)
    readonly property color bgPanel:   Qt.rgba(11/255, 11/255, 14/255, 0.85)
    readonly property color bgPill:    "transparent"
    readonly property color bgHover:   Qt.rgba(30/255, 30/255, 35/255, 0.75)

    // ── Bordures ──
    readonly property color border:       Qt.rgba(0.92, 0.74, 0.73, 0.18)
    readonly property color borderStrong: Qt.rgba(0.92, 0.74, 0.73, 0.35)

    // ── Accents (Rosé Pine) ──
    readonly property color accent:      "#ebbcba"
    readonly property color accentSoft:  "#c4a7e7"
    readonly property color accentGlow:  "#eb6f92"
    readonly property color accentLight: "#f6c177"
    readonly property color accentDim:   Qt.rgba(0.92, 0.74, 0.73, 0.15)

    // ── Texte ──
    readonly property color text:       "#e0def4"
    readonly property color textBright: "#ffffff"
    readonly property color textNormal: "#908caa"
    readonly property color textDim:    "#6e6a86"
    readonly property color textMuted:  "#524f67"

    // ── États ──
    readonly property color ok:      "#9ccfd8"
    readonly property color warn:    "#f6c177"
    readonly property color danger:  "#eb6f92"
    readonly property color urgent:  "#eb6f92"
    readonly property color music:   "#c4a7e7"

    // ── Géométrie (Originale) ──
    readonly property int radiusPill:  14
    readonly property int radiusPanel: 18
    readonly property int radiusBar:   20
    readonly property int gap:         8
    readonly property int padPill:     10

    // ── Typo (SF Pro pour UI, FiraCode NF pour icônes) ──
    readonly property string fontMain: "SF Pro Display"
    readonly property string fontMono: "SF Pro Display"
    readonly property string fontIcon: "FiraCode Nerd Font"

    // Tailles originales
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
