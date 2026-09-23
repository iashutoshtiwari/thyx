// qmllint disable unqualified

import "../../ui"
import Qt5Compat.GraphicalEffects
import QtQuick 2.15
import QtQuick.Controls 2.15
import SddmComponents 2.0 as SDDM

Rectangle {
    id: userInputContainer

    property alias username: userInput
    property Item nextDown
    property string avatarSource: {
        if (typeof userModel !== "undefined" && userModel && userModel.lastUser)
            return "/home/" + userModel.lastUser + "/.face.icon";

        return "";
    }

    signal accepted(string username)

    implicitHeight: userLayout.implicitHeight
    implicitWidth: parent ? parent.width : 280
    anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
    color: "transparent"

    SDDM.TextConstants {
        id: loginConstants
    }

    Column {
        id: userLayout

        anchors.horizontalCenter: parent.horizontalCenter
        spacing: UiTokens.spacing_sm

        // Avatar / User Identity
        Rectangle {
            id: avatarCircle

            width: Math.round(root.font.pointSize * 5.8)
            height: width
            radius: width / 2
            color: UiTokens.surface0
            border.width: 1.5
            border.color: UiTokens.surface1
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                id: avatarMask

                anchors.fill: parent
                anchors.margins: 2
                radius: width / 2
                visible: false
            }

            // Circular masked avatar image
            Item {
                anchors.fill: parent
                anchors.margins: 2
                layer.enabled: true

                Image {
                    id: avatarImg

                    anchors.fill: parent
                    source: userInputContainer.avatarSource
                    fillMode: Image.PreserveAspectCrop
                    visible: status === Image.Ready
                    smooth: true
                    asynchronous: true
                }

                layer.effect: OpacityMask {
                    maskSource: avatarMask
                }

            }

            // Fallback Initial Letter
            Text {
                anchors.centerIn: parent
                visible: avatarImg.status !== Image.Ready && userInput.text.length > 0
                text: userInput.text.charAt(0).toUpperCase()
                color: UiTokens.lavender
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font {
                    family: root.font.family
                    pointSize: Math.round(root.font.pointSize * 2)
                    weight: Font.Bold
                }

            }

        }

        // Username
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: UiTokens.spacing_xs

            Rectangle {
                id: nameContainer

                height: Math.round(root.font.pointSize * 2.2)
                width: Math.max(userInput.implicitWidth + 24, 120)
                radius: UiTokens.radius_sm
                color: userInput.activeFocus ? UiTokens.surface0 : (nameHover.containsMouse ? Qt.rgba(49 / 255, 50 / 255, 68 / 255, 0.4) : "transparent")
                border.width: userInput.activeFocus ? 1 : 0
                border.color: UiTokens.surface1

                MouseArea {
                    id: nameHover

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.IBeamCursor
                    onClicked: userInput.forceActiveFocus()
                }

                TextInput {
                    id: userInput

                    anchors.centerIn: parent
                    width: parent.width - 16
                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter
                    z: 1
                    text: userPicker.currentText || (typeof userModel !== "undefined" && userModel ? userModel.lastUser : "") || ""
                    color: config.LoginFieldTextColor || UiTokens.text
                    cursorVisible: activeFocus
                    selectByMouse: true
                    renderType: Text.QtRendering
                    onFocusChanged: {
                        if (focus)
                            selectAll();

                    }
                    onAccepted: {
                        userInputContainer.accepted(userInput.text);
                        if (userInputContainer.nextDown)
                            userInputContainer.nextDown.forceActiveFocus();

                    }
                    KeyNavigation.down: userInputContainer.nextDown

                    font {
                        pointSize: Math.round(root.font.pointSize * 1.25)
                        family: root.font.family
                        weight: Font.DemiBold
                        capitalization: config.AllowUppercaseLettersInUsernames == "false" ? Font.AllLowercase : Font.MixedCase
                    }

                    Text {
                        id: userPlaceholder

                        anchors.centerIn: parent
                        visible: userInput.text === ""
                        text: loginConstants.userName
                        color: config.PlaceholderTextColor || UiTokens.overlay0
                        font: userInput.font
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                }

                Behavior on color {
                    ColorAnimation {
                        duration: UiTokens.motion_fast
                    }

                }

            }

            // User switcher trigger when multiple users exist
            Rectangle {
                id: userSwitchBtn

                visible: typeof userModel !== "undefined" && userModel && userModel.count > 1
                width: Math.round(root.font.pointSize * 2.2)
                height: width
                radius: UiTokens.radius_sm
                color: userSwitchArea.containsMouse ? UiTokens.surface0 : "transparent"
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    anchors.centerIn: parent
                    text: "▾"
                    font.pointSize: Math.round(root.font.pointSize * 0.9)
                    color: userSwitchArea.containsMouse ? UiTokens.lavender : UiTokens.subtext0
                }

                MouseArea {
                    id: userSwitchArea

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (userPicker.popup.visible)
                            userPicker.popup.close();
                        else
                            userPicker.popup.open();
                    }
                }

            }

        }

    }

    ComboBox {
        id: userPicker

        visible: false
        model: (typeof userModel !== "undefined" && userModel) ? userModel : null
        currentIndex: (typeof userModel !== "undefined" && userModel && userModel.lastIndex >= 0) ? userModel.lastIndex : 0
        textRole: "name"
        onActivated: {
            userInput.text = currentText;
            if (typeof userModel !== "undefined" && userModel)
                userInputContainer.avatarSource = "/home/" + currentText + "/.face.icon";

        }

        popup: Popup {
            id: userMenu

            implicitHeight: Math.min(userListContent.implicitHeight + 20, 200)
            width: Math.max(userInputContainer.width, 200)
            y: userLayout.height + 4
            x: Math.round((userInputContainer.width - width) / 2)
            padding: 8

            background: Rectangle {
                radius: UiTokens.radius
                color: config.DropdownBackgroundColor || UiTokens.mantle
                border.width: 1
                border.color: config.DropdownBorderColor || UiTokens.surface0
                layer.enabled: true

                layer.effect: DropShadow {
                    horizontalOffset: 0
                    verticalOffset: 4
                    radius: 12
                    samples: 16
                    color: Qt.rgba(0, 0, 0, 0.3)
                }

            }

            contentItem: ListView {
                id: userListContent

                implicitHeight: contentHeight
                clip: true
                model: userPicker.popup.visible ? userPicker.delegateModel : null
                currentIndex: userPicker.highlightedIndex

                delegate: Rectangle {
                    width: ListView.view.width
                    height: delegateUserText.implicitHeight + 14
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: ListView.view.currentIndex === index ? (config.DropdownSelectedBackgroundColor || UiTokens.lavender) : "transparent"
                    radius: UiTokens.radius_sm

                    Text {
                        id: delegateUserText

                        anchors.centerIn: parent
                        text: model.name || ""
                        color: ListView.view.currentIndex === index ? (config.DropdownSelectedTextColor || UiTokens.crust) : (config.DropdownTextColor || UiTokens.text)
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter

                        font {
                            pointSize: root.font.pointSize
                            family: root.font.family
                            weight: Font.Medium
                        }

                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            userPicker.currentIndex = index;
                            userInput.text = userPicker.currentText;
                            userInputContainer.avatarSource = "/home/" + userInput.text + "/.face.icon";
                            userMenu.close();
                        }
                    }

                }

                ScrollIndicator.vertical: ScrollIndicator {
                }

            }

            enter: Transition {
                NumberAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: UiTokens.motion_fast
                }

            }

            exit: Transition {
                NumberAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: UiTokens.motion_fast
                }

            }

        }

    }

}
