import QtQuick 2.15
pragma Singleton

QtObject {
    property real scale: 1.0

    readonly property int spacing_xs: Math.max(1, Math.round(4 * scale))
    readonly property int spacing_sm: Math.max(1, Math.round(8 * scale))
    readonly property int spacing_md: Math.max(1, Math.round(14 * scale))
    readonly property int spacing_lg: Math.max(1, Math.round(20 * scale))
    readonly property int spacing_xl: Math.max(1, Math.round(28 * scale))
    readonly property int radius_sm: Math.max(1, Math.round(6 * scale))
    readonly property int radius: Math.max(1, Math.round(8 * scale))
    readonly property int radius_lg: Math.max(1, Math.round(12 * scale))
    readonly property int motion_fast: 100
    readonly property int motion_normal: 150
    readonly property int motion_slow: 200
    readonly property int easing_standard: Easing.OutCubic
    readonly property int easing_bounce: Easing.OutBack
    readonly property int easing_smooth: Easing.OutQuart
    // Catppuccin Mocha Palette
    readonly property color base: "#1e1e2e"
    readonly property color mantle: "#181825"
    readonly property color crust: "#11111b"
    readonly property color surface0: "#313244"
    readonly property color surface1: "#45475a"
    readonly property color surface2: "#585b70"
    readonly property color overlay0: "#6c7086"
    readonly property color overlay1: "#7f849c"
    readonly property color overlay2: "#9399b2"
    readonly property color subtext0: "#a6adc8"
    readonly property color subtext1: "#bac2de"
    readonly property color text: "#cdd6f4"
    readonly property color lavender: "#b4befe"
    readonly property color mauve: "#cba6f7"
    readonly property color red: "#f38ba8"
    readonly property color green: "#a6e3a1"
    readonly property color yellow: "#f9e2af"
}
