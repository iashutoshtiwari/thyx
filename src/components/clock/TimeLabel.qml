import QtQuick 2.15

Text {
    id: timeDisplay

    property var rootItem: null
    property var config: ({
    })
    readonly property var cfg: config || ({
    })
    readonly property int basePt: (rootItem && rootItem.font && rootItem.font.pointSize) ? rootItem.font.pointSize : 13
    readonly property string baseFamily: (rootItem && rootItem.font && rootItem.font.family) ? rootItem.font.family : (cfg.Font && cfg.Font !== "" ? cfg.Font : timeDisplay.font.family)
    readonly property var systemLocale: Qt.locale()

    function refreshDisplay() {
        const now = new Date();
        const hf = (typeof cfg.HourFormat === "undefined") ? "" : cfg.HourFormat;
        const timeFormat = (hf == "long") ? Locale.LongFormat : (hf !== "" ? hf : Locale.ShortFormat);
        text = now.toLocaleTimeString(systemLocale, timeFormat);
    }

    anchors.horizontalCenter: parent.horizontalCenter
    color: cfg.TimeTextColor || "#cdd6f4"
    renderType: Text.QtRendering
    horizontalAlignment: Text.AlignHCenter
    Component.onCompleted: refreshDisplay()

    font {
        pointSize: Math.round(basePt * 3.6)
        weight: Font.DemiBold
        family: baseFamily
    }

}
