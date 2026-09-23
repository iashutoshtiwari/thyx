// qmllint disable unqualified

import "../../ui"
import Qt5Compat.GraphicalEffects
import QtQuick 2.15

Rectangle {
    id: animatedIconButton

    property string iconSource: ""
    property color defaultIconColor: config.SystemButtonsIconsColor || UiTokens.subtext0
    property color hoverIconColor: config.HoverSystemButtonsIconsColor || UiTokens.lavender
    property color pressedIconColor: Qt.darker(hoverIconColor, 1.15)
    property real iconScale: 0.55
    property bool circular: true
    property alias mouseArea: clickHandler
    readonly property int animationDuration: Number(config.AnimationDuration || UiTokens.motion_normal)
    readonly property var animationEasing: {
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
    property bool isHovered: clickHandler.containsMouse && !clickHandler.pressed
    property bool isPressed: clickHandler.pressed

    signal clicked()
    signal pressed()
    signal released()

    color: isHovered ? UiTokens.surface0 : "transparent"
    radius: circular ? Math.min(width, height) / 2 : UiTokens.radius
    border.width: isHovered ? 1 : 0
    border.color: UiTokens.surface1
    Keys.onReturnPressed: animatedIconButton.clicked()
    Keys.onEnterPressed: animatedIconButton.clicked()
    states: [
        State {
            name: "pressed"
            when: animatedIconButton.isPressed

            PropertyChanges {
                iconColorOverlay.color: animatedIconButton.pressedIconColor
            }

        },
        State {
            name: "hovered"
            when: animatedIconButton.isHovered

            PropertyChanges {
                iconColorOverlay.color: animatedIconButton.hoverIconColor
            }

        }
    ]

    MouseArea {
        id: clickHandler

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: animatedIconButton.clicked()
        onPressed: animatedIconButton.pressed()
        onReleased: animatedIconButton.released()
    }

    Image {
        id: iconImage

        anchors.centerIn: parent
        width: parent.width * animatedIconButton.iconScale
        height: parent.height * animatedIconButton.iconScale
        sourceSize.width: width * 2
        sourceSize.height: height * 2
        source: animatedIconButton.iconSource
        fillMode: Image.PreserveAspectFit
        smooth: true
        antialiasing: true
        mipmap: true

        ColorOverlay {
            id: iconColorOverlay

            anchors.fill: parent
            source: parent
            color: animatedIconButton.defaultIconColor

            Behavior on color {
                ColorAnimation {
                    duration: animatedIconButton.animationDuration
                    easing.type: animatedIconButton.animationEasing
                }

            }

        }

    }

    Behavior on color {
        ColorAnimation {
            duration: animatedIconButton.animationDuration
            easing.type: animatedIconButton.animationEasing
        }

    }

    Behavior on border.color {
        ColorAnimation {
            duration: animatedIconButton.animationDuration
            easing.type: animatedIconButton.animationEasing
        }

    }

}
