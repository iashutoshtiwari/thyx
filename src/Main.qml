// qmllint disable unqualified
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0 as SDDM
import "components/buttons"
import "components/clock"
import "components/inputs"
import "effects"
import "layouts"
import "ui"

Pane {
    id: root

    readonly property var cfg: (typeof config !== "undefined" && config) ? config : ({
    })
    readonly property string formPos: String(cfg.FormPosition || "center")
    readonly property var sddmApi: (typeof sddm !== "undefined" && sddm) ? sddm : null
    readonly property color startupColor: (cfg.StartupBackgroundColor && cfg.StartupBackgroundColor !== "") ? cfg.StartupBackgroundColor : UiTokens.crust
    property bool authFailed: false
    property string errorMessage: ""

    height: Screen.height
    width: Screen.width
    padding: 0
    LayoutMirroring.enabled: false
    LayoutMirroring.childrenInherit: true
    palette.buttonText: cfg.HoverSystemButtonsIconsColor || UiTokens.lavender
    focus: true

    font {
        family: cfg.Font || font.family
        pointSize: (cfg.FontSize !== "" && typeof cfg.FontSize !== "undefined") ? parseInt(cfg.FontSize) : (parseInt(height / 80) || 11)
        weight: Font.Medium
    }

    Item {
        id: fxVisual

        anchors.fill: parent

        Background {
            id: bg

            config: root.cfg
            fallbackColor: root.startupColor
        }

        BlurEffect {
            id: blurOverlay

            sourceItem: bg.imageItem
            config: root.cfg
        }

        ColumnLayout {
            id: form

            z: 1
            width: Math.min(parent.width * 0.88, 320)
            spacing: UiTokens.spacing_md
            x: {
                if (root.formPos === "left")
                    return Math.round(parent.width * 0.08);

                if (root.formPos === "right")
                    return Math.round(parent.width - width - (parent.width * 0.08));

                return Math.round((parent.width - width) / 2);
            }
            anchors.verticalCenter: parent.verticalCenter
            opacity: 0
            Component.onCompleted: {
                entranceAnim.start();
                passwordInput.password.forceActiveFocus();
            }

            ParallelAnimation {
                id: entranceAnim

                NumberAnimation {
                    target: form
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: UiTokens.motion_normal
                    easing.type: UiTokens.easing_standard
                }

                NumberAnimation {
                    target: entranceTrans
                    property: "y"
                    from: 8
                    to: 0
                    duration: UiTokens.motion_normal
                    easing.type: UiTokens.easing_standard
                }

            }

            SDDM.TextConstants {
                id: textConstants
            }

            // Clock (Date + Time)
            Clock {
                rootItem: root
                config: root.cfg
            }

            Item {
                Layout.preferredHeight: UiTokens.spacing_xs
            }

            // Central Authentication Card
            Rectangle {
                id: authCard

                Layout.fillWidth: true
                Layout.preferredHeight: authCardContent.implicitHeight + 36
                radius: UiTokens.radius_lg
                color: Qt.rgba(24 / 255, 24 / 255, 37 / 255, 0.72)
                border.width: 1
                border.color: Qt.rgba(49 / 255, 50 / 255, 68 / 255, 0.65)

                Column {
                    id: authCardContent

                    width: parent.width - 32
                    anchors.centerIn: parent
                    spacing: UiTokens.spacing_sm

                    // Avatar & Username
                    UsernameInput {
                        id: usernameInput

                        width: parent.width
                        nextDown: passwordInput.password
                    }

                    // Password Field
                    PasswordField {
                        id: passwordInput

                        width: parent.width
                        nextDown: loginButton.authenticateBtn
                    }

                    // Login Error Message
                    Text {
                        id: errorLabel

                        anchors.horizontalCenter: parent.horizontalCenter
                        visible: root.authFailed && root.errorMessage.length > 0
                        text: root.errorMessage
                        color: UiTokens.red
                        horizontalAlignment: Text.AlignHCenter
                        renderType: Text.QtRendering

                        font {
                            pointSize: Math.round(root.font.pointSize * 0.85)
                            family: root.font.family
                            weight: Font.Medium
                        }

                    }

                    // Fingerprint Affordance & Login Button
                    LoginButton {
                        id: loginButton

                        width: parent.width
                        usernameField: usernameInput.username
                        passwordField: passwordInput.password
                        environmentIndex: environmentButton.currentIndex
                    }

                }

            }

            Item {
                Layout.preferredHeight: UiTokens.spacing_xs
            }

            // Session Selector
            EnvironmentButton {
                id: environmentButton
            }

            // System Buttons (Sleep, Restart, Shutdown)
            SystemButtonsLayout {
                id: systemButtonsLayout
            }

            Connections {
                function onLoginSucceeded() {
                    root.authFailed = false;
                    root.errorMessage = "";
                }

                function onLoginFailed() {
                    if (loginButton.userAttempted) {
                        root.authFailed = true;
                        root.errorMessage = textConstants.loginFailed || "Login failed";
                        passwordInput.password.text = "";
                        passwordInput.password.forceActiveFocus();
                    }
                }

                target: root.sddmApi
            }

            Connections {
                function onTextChanged() {
                    if (root.authFailed) {
                        root.authFailed = false;
                        root.errorMessage = "";
                    }
                }

                target: passwordInput.password
            }

            transform: Translate {
                id: entranceTrans

                y: 8
            }

        }

        MouseArea {
            anchors.fill: parent
            z: 0
            onClicked: parent.forceActiveFocus()
        }

    }

    background: Rectangle {
        color: root.startupColor
    }

}
