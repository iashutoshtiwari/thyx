// qmllint disable unqualified

import "../components/buttons"
import "../ui"
import QtQuick 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0 as SDDM

RowLayout {
    id: systemButtons

    Layout.alignment: Qt.AlignHCenter
    Layout.preferredHeight: Math.round(root.font.pointSize * 3.2)
    Layout.maximumHeight: Math.round(root.font.pointSize * 3.2)
    Layout.leftMargin: 0
    spacing: UiTokens.spacing_sm

    SDDM.TextConstants {
        id: textConstants
    }

    Repeater {
        model: [{
            "name": "Sleep",
            "idx": 2,
            "can": typeof sddm !== "undefined" && sddm ? sddm.canSuspend : true
        }, {
            "name": "Restart",
            "idx": 1,
            "can": typeof sddm !== "undefined" && sddm ? sddm.canReboot : true
        }, {
            "name": textConstants.shutdown,
            "idx": 0,
            "can": typeof sddm !== "undefined" && sddm ? sddm.canPowerOff : true
        }]

        SystemButton {
            text: modelData.name
            idx: modelData.idx
            visible: modelData.can !== false
        }

    }

}
