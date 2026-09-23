// qmllint disable unqualified

import "../../ui"
import Qt5Compat.GraphicalEffects
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: environmentSelector

    property alias currentIndex: environmentPicker.currentIndex
    readonly property int sessionCount: {
        if (typeof sessionModel === "undefined" || !sessionModel)
            return 0;

        if (typeof sessionModel.count !== "undefined")
            return sessionModel.count;

        if (typeof sessionModel.rowCount === "function")
            return sessionModel.rowCount();

        return environmentPicker.count;
    }

    visible: sessionCount > 1
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredHeight: visible ? environmentContainer.height : 0
    Layout.maximumHeight: visible ? environmentContainer.height : 0
    Layout.leftMargin: 0
    color: "transparent"
    implicitHeight: visible ? environmentContainer.height : 0
    implicitWidth: visible ? environmentContainer.width : 0
    height: visible ? environmentContainer.height : 0
    width: visible ? environmentContainer.width : 0

    Rectangle {
        id: environmentContainer

        anchors.horizontalCenter: parent.horizontalCenter
        height: Math.round(root.font.pointSize * 2.4)
        width: contentRow.implicitWidth + Math.round(24 * UiTokens.scale)
        radius: UiTokens.radius
        color: environmentTrigger.containsMouse ? UiTokens.surface0 : "transparent"
        border.width: 1
        border.color: environmentTrigger.containsMouse ? UiTokens.surface1 : Qt.rgba(49 / 255, 50 / 255, 68 / 255, 0.4)
        Keys.onPressed: function(event) {
            if ((event.key == Qt.Key_Left || event.key == Qt.Key_Right) && !environmentMenu.visible)
                environmentMenu.open();

        }

        MouseArea {
            id: environmentTrigger

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: environmentMenu.visible ? environmentMenu.close() : environmentMenu.open()
        }

        Row {
            id: contentRow

            anchors.centerIn: parent
            spacing: UiTokens.spacing_xs

            Text {
                id: environmentDisplayText

                text: environmentPicker.currentText
                color: environmentTrigger.containsMouse ? UiTokens.lavender : (config.EnvironmentButtonTextColor || UiTokens.subtext0)
                verticalAlignment: Text.AlignVCenter
                renderType: Text.QtRendering

                font {
                    pointSize: Math.round(root.font.pointSize * 0.9)
                    family: root.font.family
                    weight: Font.Medium
                }

                Behavior on color {
                    ColorAnimation {
                        duration: UiTokens.motion_fast
                    }

                }

            }

            Text {
                text: "▾"
                color: environmentTrigger.containsMouse ? UiTokens.lavender : (config.EnvironmentButtonTextColor || UiTokens.subtext0)
                anchors.verticalCenter: parent.verticalCenter
                renderType: Text.QtRendering

                font {
                    pointSize: Math.round(root.font.pointSize * 0.8)
                    family: root.font.family
                }

                Behavior on color {
                    ColorAnimation {
                        duration: UiTokens.motion_fast
                    }

                }

            }

        }

        Behavior on color {
            ColorAnimation {
                duration: UiTokens.motion_fast
            }

        }

        Behavior on border.color {
            ColorAnimation {
                duration: UiTokens.motion_fast
            }

        }

    }

    ComboBox {
        id: environmentPicker

        visible: false
        model: (typeof sessionModel !== "undefined" && sessionModel) ? sessionModel : null
        currentIndex: (typeof sessionModel !== "undefined" && sessionModel && sessionModel.lastIndex >= 0) ? sessionModel.lastIndex : 0
        textRole: "name"

        popup: Popup {
            id: environmentMenu

            implicitHeight: Math.min(menuContent.implicitHeight + Math.round(16 * UiTokens.scale), Math.round(220 * UiTokens.scale))
            width: Math.max(environmentContainer.width + Math.round(40 * UiTokens.scale), Math.round(200 * UiTokens.scale))
            y: environmentContainer.height + UiTokens.spacing_xs
            x: Math.round((environmentContainer.width - width) / 2)
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
                id: menuContent

                implicitHeight: contentHeight
                clip: true
                model: environmentPicker.popup.visible ? environmentPicker.delegateModel : null
                currentIndex: environmentPicker.highlightedIndex

                delegate: Rectangle {
                    width: menuContent.width
                    height: delegateText.implicitHeight + Math.round(12 * UiTokens.scale)
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: menuContent.currentIndex === index ? (config.DropdownSelectedBackgroundColor || UiTokens.lavender) : "transparent"
                    radius: UiTokens.radius_sm

                    Text {
                        id: delegateText

                        anchors.centerIn: parent
                        text: model.name || ""
                        color: menuContent.currentIndex === index ? (config.DropdownSelectedTextColor || UiTokens.crust) : (config.DropdownTextColor || UiTokens.text)
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        renderType: Text.QtRendering

                        font {
                            pointSize: Math.round(root.font.pointSize * 0.9)
                            family: root.font.family
                            weight: Font.Medium
                        }

                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            environmentPicker.currentIndex = index;
                            environmentMenu.close();
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
