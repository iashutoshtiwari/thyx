// qmllint disable unqualified

import "../../ui"
import QtQuick 2.15
import SddmComponents 2.0 as SDDM

Rectangle {
    id: secureInputContainer

    property alias password: secureInput
    property Item nextDown

    signal accepted(string password)

    implicitHeight: inputWrapper.height + UiTokens.spacing_xs
    implicitWidth: parent ? Math.min(parent.width - Math.round(48 * UiTokens.scale), Math.round(280 * UiTokens.scale)) : Math.round(280 * UiTokens.scale)
    anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
    color: "transparent"

    SDDM.TextConstants {
        id: authConstants
    }

    Rectangle {
        id: inputWrapper

        anchors.centerIn: parent
        width: parent.width
        height: Math.round(root.font.pointSize * 3)
        radius: UiTokens.radius
        color: config.PasswordFieldBackgroundColor || UiTokens.base
        border.width: 1
        border.color: secureInput.activeFocus ? UiTokens.lavender : UiTokens.surface1

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.IBeamCursor
            onClicked: secureInput.forceActiveFocus()
        }

        TextInput {
            id: secureInput

            anchors.fill: parent
            anchors.leftMargin: Math.round(16 * UiTokens.scale)
            anchors.rightMargin: Math.round(16 * UiTokens.scale)
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            color: config.PasswordFieldTextColor || UiTokens.text
            focus: true
            selectByMouse: true
            renderType: Text.QtRendering
            echoMode: TextInput.Password
            passwordCharacter: "•"
            passwordMaskDelay: undefined
            onAccepted: secureInputContainer.accepted(secureInput.text)
            KeyNavigation.down: secureInputContainer.nextDown

            font {
                pointSize: root.font.pointSize
                family: root.font.family
                weight: Font.Normal
            }

            Text {
                id: placeholder

                anchors.centerIn: parent
                visible: secureInput.text === ""
                text: authConstants.password
                color: config.PlaceholderTextColor || UiTokens.overlay0
                font: secureInput.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

        }

        Behavior on border.color {
            ColorAnimation {
                duration: UiTokens.motion_normal
                easing.type: UiTokens.easing_standard
            }

        }

    }

}
