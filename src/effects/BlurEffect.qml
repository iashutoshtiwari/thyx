import Qt5Compat.GraphicalEffects
import QtQuick 2.15

Item {
    id: root

    property Item sourceItem
    property var config: ({
    })
    property real blurAmount: {
        var v = (config.Blur === "" ? 0.4 : Number(config.Blur));
        if (isNaN(v))
            v = 0.4;

        if (v < 0)
            v = 0;

        if (v > 1)
            v = 1;

        return v;
    }

    anchors.fill: parent
    z: 0.5
    visible: !!sourceItem && blurAmount > 0

    FastBlur {
        id: blur

        anchors.fill: parent
        source: root.sourceItem
        radius: root.blurAmount * 64
        transparentBorder: true
    }

}
