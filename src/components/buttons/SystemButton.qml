// qmllint disable unqualified

import "../../ui"
import "../misc"
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: powerControl

    property int idx: 0
    property string text: ""
    readonly property int buttonSize: Math.round(root.font.pointSize * 3)

    function activate() {
        if (powerControl.idx === 0)
            sddm.powerOff();
        else if (powerControl.idx === 1)
            sddm.reboot();
        else if (powerControl.idx === 2)
            sddm.suspend();
    }

    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    color: "transparent"
    implicitWidth: buttonSize
    implicitHeight: buttonSize
    Keys.onReturnPressed: powerControl.activate()
    Keys.onEnterPressed: powerControl.activate()

    AnimatedIconButton {
        id: iconButton

        width: powerControl.buttonSize
        height: powerControl.buttonSize
        anchors.centerIn: parent
        circular: true
        iconSource: {
            switch (powerControl.idx) {
            case 0:
                return Qt.resolvedUrl("../../../icons/shutdown.svg");
            case 1:
                return Qt.resolvedUrl("../../../icons/restart.svg");
            case 2:
                return Qt.resolvedUrl("../../../icons/sleep.svg");
            default:
                return Qt.resolvedUrl("../../../icons/shutdown.svg");
            }
        }
        onClicked: powerControl.activate()
        ToolTip.visible: isHovered
        ToolTip.text: powerControl.text
        ToolTip.delay: 200
    }

}
