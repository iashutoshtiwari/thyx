// qmllint disable unqualified

import "../../ui"
import QtQuick 2.15
import SddmComponents 2.0 as SDDM

Rectangle {
    id: authenticationControl

    required property var usernameField
    required property var passwordField
    required property int environmentIndex
    property alias authenticateBtn: focusProxy
    property bool userAttempted: false
    readonly property int animationDuration: Number(config.AnimationDuration || UiTokens.motion_normal)
    readonly property int animationEasing: {
        switch (config.AnimationEasing) {
        case "OutBack":
            return Easing.OutBack;
        case "OutQuart":
            return Easing.OutQuart;
        case "OutCubic":
        default:
            return Easing.OutCubic;
        }
    }
    readonly property bool canLogin: {
        const u = String(usernameField.text || "");
        const p = String(passwordField.text || "");
        return u.length > 0 && p.length > 0;
    }

    function normalizedUser() {
        const raw = String(usernameField.text || "");
        return (config.AllowUppercaseLettersInUsernames == "false") ? raw.toLowerCase() : raw;
    }

    function doLogin() {
        if (!canLogin)
            return ;

        userAttempted = true;
        const userName = normalizedUser();
        const pwd = String(passwordField.text || "");
        sddm.login(userName, pwd, environmentIndex);
    }

    implicitHeight: buttonLayout.implicitHeight
    implicitWidth: parent ? Math.min(parent.width - Math.round(48 * UiTokens.scale), Math.round(280 * UiTokens.scale)) : Math.round(280 * UiTokens.scale)
    anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
    color: "transparent"

    SDDM.TextConstants {
        id: loginConstants
    }

    Timer {
        id: fingerprintAutoStart

        interval: 500
        running: true
        repeat: false
        onTriggered: {
            if (config.AutoFingerprintOnLoad == "true" || config.AutoFingerprintOnLoad === true) {
                const userName = normalizedUser();
                sddm.login(userName, "", authenticationControl.environmentIndex);
            }
        }
    }

    Connections {
        function onAccepted() {
            authenticationControl.doLogin();
        }

        target: authenticationControl.passwordField
    }

    Connections {
        function onAccepted() {
            if (!authenticationControl.passwordField.text || authenticationControl.passwordField.text.length === 0)
                authenticationControl.passwordField.forceActiveFocus();
            else
                authenticationControl.doLogin();
        }

        target: authenticationControl.usernameField
    }

    Item {
        id: focusProxy

        width: 0
        height: 0
        visible: false
        focus: true
        Keys.onReturnPressed: authenticationControl.doLogin()
        Keys.onEnterPressed: authenticationControl.doLogin()
    }

    Column {
        id: buttonLayout

        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: UiTokens.spacing_md

        // Fingerprint Affordance
        Column {
            id: fingerprintHint

            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            visible: config.AutoFingerprintOnLoad == "true" || config.AutoFingerprintOnLoad === true
            spacing: Math.max(2, Math.round(2 * UiTokens.scale))

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Touch fingerprint sensor"
                color: UiTokens.subtext1
                horizontalAlignment: Text.AlignHCenter
                renderType: Text.QtRendering

                font {
                    pointSize: Math.round(root.font.pointSize * 0.9)
                    family: root.font.family
                    weight: Font.Medium
                }

            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "or enter your password"
                color: UiTokens.overlay0
                horizontalAlignment: Text.AlignHCenter
                renderType: Text.QtRendering

                font {
                    pointSize: Math.round(root.font.pointSize * 0.8)
                    family: root.font.family
                    weight: Font.Normal
                }

            }

        }

        // Login Button
        Rectangle {
            id: authBtn

            readonly property color baseColor: config.LoginButtonBackgroundColor || UiTokens.lavender
            readonly property color hoverColor: config.HoverLoginButtonBackgroundColor || UiTokens.mauve
            readonly property color pressedColor: Qt.darker(hoverColor, 1.15)

            height: Math.round(root.font.pointSize * 3)
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            radius: UiTokens.radius
            color: baseColor
            states: [
                State {
                    name: "buttonPressed"
                    when: authClickArea.pressed

                    PropertyChanges {
                        authBtn.color: authBtn.pressedColor
                    }

                },
                State {
                    name: "buttonHovered"
                    when: authClickArea.containsMouse && !authClickArea.pressed

                    PropertyChanges {
                        authBtn.color: authBtn.hoverColor
                    }

                }
            ]
            transitions: [
                Transition {
                    from: "*"
                    to: "*"

                    ColorAnimation {
                        target: authBtn
                        property: "color"
                        duration: authenticationControl.animationDuration
                        easing.type: authenticationControl.animationEasing
                    }

                }
            ]

            MouseArea {
                id: authClickArea

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: authenticationControl.doLogin()
            }

            Text {
                id: authLabel

                anchors.centerIn: parent
                text: loginConstants.login
                color: config.LoginButtonTextColor || UiTokens.crust
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                renderType: Text.QtRendering

                font {
                    pointSize: root.font.pointSize
                    family: root.font.family
                    weight: Font.DemiBold
                }

            }

        }

    }

}
