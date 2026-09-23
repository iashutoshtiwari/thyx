import QtQuick 2.15

Text {
    id: dateDisplay

    property var rootItem: null
    property var config: ({
    })
    readonly property var cfg: config || ({
    })
    readonly property int basePt: (rootItem && rootItem.font && rootItem.font.pointSize) ? rootItem.font.pointSize : 13
    readonly property string baseFamily: (rootItem && rootItem.font && rootItem.font.family) ? rootItem.font.family : (cfg.Font && cfg.Font !== "" ? cfg.Font : dateDisplay.font.family)

    function refreshDisplay() {
        const today = new Date();
        const df = (typeof cfg.DateFormat === "undefined" || cfg.DateFormat === "") ? "dddd, MMMM d" : cfg.DateFormat;
        text = today.toLocaleDateString(Qt.locale(), df);
    }

    anchors.horizontalCenter: parent.horizontalCenter
    color: cfg.DateTextColor || "#bac2de"
    renderType: Text.QtRendering
    horizontalAlignment: Text.AlignHCenter
    Component.onCompleted: refreshDisplay()

    font {
        pointSize: Math.round(basePt * 1.15)
        weight: Font.Medium
        family: baseFamily
    }

}
