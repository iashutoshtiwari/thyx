// qmllint disable unqualified

import "../../ui"
import Qt5Compat.GraphicalEffects
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: environmentSelector

    property alias currentIndex: environmentPicker.currentIndex

    Layout.alignment: Qt.AlignHCenter
    Layout.preferredHeight: environmentContainer.height
    Layout.maximumHeight: environmentContainer.height
    Layout.leftMargin: 0
    color: "transparent"
    implicitHeight: environmentContainer.height
    implicitWidth: environmentContainer.width

    Rectangle {
        id: environmentContainer

        anchors.horizontalCenter: parent.horizontalCenter
        height: Math.round(root.font.pointSize * 2.4)
        width: contentRow.implicitWidth + 24
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

            implicitHeight: Math.min(menuContent.implicitHeight + 16, 220)
            width: Math.max(environmentContainer.width + 40, 200)
            y: environmentContainer.height + 4
            x: Math.round((environmentContainer.width - width) / 2)
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
                id: menuContent

                implicitHeight: contentHeight
                clip: true
                model: environmentPicker.popup.visible ? environmentPicker.delegateModel : null
                currentIndex: environmentPicker.highlightedIndex

                delegate: Rectangle {
                    width: ListView.view.width
                    height: delegateText.implicitHeight + 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: ListView.view.currentIndex === index ? (config.DropdownSelectedBackgroundColor || UiTokens.lavender) : "transparent"
                    radius: UiTokens.radius_sm

                    Text {
                        id: delegateText

                        anchors.centerIn: parent
                        text: model.name || ""
                        color: ListView.view.currentIndex === index ? (config.DropdownSelectedTextColor || UiTokens.crust) : (config.DropdownTextColor || UiTokens.text)
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
