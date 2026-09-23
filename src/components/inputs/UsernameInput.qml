// qmllint disable unqualified

import "../../ui"
import Qt5Compat.GraphicalEffects
import QtQuick 2.15
import QtQuick.Controls 2.15
import SddmComponents 2.0 as SDDM

Rectangle {
    id: userInputContainer

    property alias username: authUserProxy
    property Item nextDown
    property int selectedUserIndex: {
        if (typeof userModel !== "undefined" && userModel && userModel.lastIndex >= 0)
            return userModel.lastIndex;

        return 0;
    }
    property string currentUserName: (typeof userModel !== "undefined" && userModel && userModel.lastUser) ? userModel.lastUser : ""
    property string currentUserRealName: ""
    property string avatarSource: (typeof userModel !== "undefined" && userModel && userModel.lastUser) ? ("/home/" + userModel.lastUser + "/.face.icon") : ""
    readonly property bool hasUsers: typeof userModel !== "undefined" && userModel && userModel.count > 0
    readonly property string displayName: {
        if (currentUserRealName && currentUserRealName.trim().length > 0)
            return currentUserRealName.trim();

        if (currentUserName && currentUserName.trim().length > 0)
            return currentUserName.trim();

        return "";
    }

    signal accepted(string username)

    function updateFromItem(uName, uRealName, uIcon) {
        currentUserName = uName;
        currentUserRealName = uRealName;
        if (uIcon && uIcon.length > 0)
            avatarSource = uIcon;
        else if (uName && uName.length > 0)
            avatarSource = "/home/" + uName + "/.face.icon";
        else
            avatarSource = "";
    }

    function selectUser(idx) {
        selectedUserIndex = idx;
        if (idx >= 0 && idx < userModelWatcher.count) {
            var item = userModelWatcher.itemAt(idx);
            if (item)
                updateFromItem(item.itemUserName, item.itemRealName, item.itemIcon);

        }
    }

    implicitHeight: userLayout.implicitHeight
    implicitWidth: parent ? parent.width : Math.round(280 * UiTokens.scale)
    anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
    color: "transparent"

    SDDM.TextConstants {
        id: loginConstants
    }

    QtObject {
        id: authUserProxy

        property string text: userInputContainer.currentUserName

        signal accepted()
    }

    Repeater {
        id: userModelWatcher

        model: (typeof userModel !== "undefined" && userModel) ? userModel : null

        Item {
            readonly property string itemUserName: model.name || ""
            readonly property string itemRealName: model.realName || ""
            readonly property string itemIcon: model.icon || ""

            Component.onCompleted: {
                if (index === userInputContainer.selectedUserIndex)
                    userInputContainer.updateFromItem(itemUserName, itemRealName, itemIcon);

            }
        }

    }

    Column {
        id: userLayout

        anchors.horizontalCenter: parent.horizontalCenter
        spacing: UiTokens.spacing_sm

        // Avatar
        Rectangle {
            id: avatarCircle

            width: Math.round(root.font.pointSize * 6)
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
                visible: avatarImg.status !== Image.Ready && userInputContainer.displayName.length > 0
                text: userInputContainer.displayName.charAt(0).toUpperCase()
                color: UiTokens.lavender
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                renderType: Text.QtRendering

                font {
                    family: root.font.family
                    pointSize: Math.round(root.font.pointSize * 2.2)
                    weight: Font.Bold
                }

            }

        }

        // User Identity (Full Name when users exist)
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: UiTokens.spacing_xs

            Text {
                id: nameDisplay

                visible: userInputContainer.hasUsers
                text: userInputContainer.displayName
                color: config.LoginFieldTextColor || UiTokens.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                renderType: Text.QtRendering

                font {
                    pointSize: Math.round(root.font.pointSize * 1.35)
                    family: root.font.family
                    weight: Font.DemiBold
                }

            }

            // Fallback editable text input only when no userModel exists
            TextInput {
                id: manualUserInput

                visible: !userInputContainer.hasUsers
                width: Math.round(160 * UiTokens.scale)
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                text: userInputContainer.currentUserName
                color: config.LoginFieldTextColor || UiTokens.text
                onTextChanged: userInputContainer.currentUserName = text
                onAccepted: {
                    userInputContainer.accepted(text);
                    if (userInputContainer.nextDown)
                        userInputContainer.nextDown.forceActiveFocus();

                }
                KeyNavigation.down: userInputContainer.nextDown

                font {
                    pointSize: Math.round(root.font.pointSize * 1.25)
                    family: root.font.family
                    weight: Font.DemiBold
                }

            }

            // Multi-user dropdown trigger (visible ONLY when multiple users exist)
            Rectangle {
                id: userSwitchBtn

                visible: typeof userModel !== "undefined" && userModel && userModel.count > 1
                width: Math.round(root.font.pointSize * 1.8)
                height: width
                radius: UiTokens.radius_sm
                color: userSwitchArea.containsMouse ? UiTokens.surface0 : "transparent"
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    anchors.centerIn: parent
                    text: "▾"
                    font.pointSize: Math.round(root.font.pointSize * 0.8)
                    color: userSwitchArea.containsMouse ? UiTokens.lavender : UiTokens.subtext0
                    renderType: Text.QtRendering
                }

                MouseArea {
                    id: userSwitchArea

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (userMenu.visible)
                            userMenu.close();
                        else
                            userMenu.open();
                    }
                }

            }

        }

    }

    Popup {
        id: userMenu

        implicitHeight: Math.min(userListContent.implicitHeight + Math.round(16 * UiTokens.scale), Math.round(200 * UiTokens.scale))
        width: Math.max(userLayout.width, Math.round(220 * UiTokens.scale))
        y: userLayout.height + UiTokens.spacing_xs
        x: Math.round((userInputContainer.width - width) / 2)
        padding: UiTokens.spacing_sm

        background: Rectangle {
            radius: UiTokens.radius
            color: config.DropdownBackgroundColor || UiTokens.mantle
            border.width: 1
            border.color: config.DropdownBorderColor || UiTokens.surface0
            layer.enabled: true

            layer.effect: DropShadow {
                horizontalOffset: 0
                verticalOffset: Math.round(4 * UiTokens.scale)
                radius: Math.round(12 * UiTokens.scale)
                samples: 16
                color: Qt.rgba(0, 0, 0, 0.3)
            }

        }

        contentItem: ListView {
            id: userListContent

            implicitHeight: contentHeight
            clip: true
            model: (typeof userModel !== "undefined" && userModel) ? userModel : null
            currentIndex: userInputContainer.selectedUserIndex

            delegate: Rectangle {
                width: userListContent.width
                height: delegateUserText.implicitHeight + Math.round(14 * UiTokens.scale)
                anchors.horizontalCenter: parent.horizontalCenter
                color: userListContent.currentIndex === index ? (config.DropdownSelectedBackgroundColor || UiTokens.lavender) : "transparent"
                radius: UiTokens.radius_sm

                Text {
                    id: delegateUserText

                    anchors.centerIn: parent
                    text: (model.realName && model.realName.trim().length > 0) ? model.realName.trim() : (model.name || "")
                    color: userListContent.currentIndex === index ? (config.DropdownSelectedTextColor || UiTokens.crust) : (config.DropdownTextColor || UiTokens.text)
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    renderType: Text.QtRendering

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
                        userInputContainer.selectUser(index);
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
