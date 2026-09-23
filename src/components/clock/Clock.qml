import "../../ui"
import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: temporalDisplay

    property var rootItem: null
    property var config: ({
    })
    property string layoutPosition: String(config.FormPosition || "")

    Layout.alignment: Qt.AlignHCenter
    Layout.preferredHeight: timeDisplayContainer.implicitHeight
    Layout.fillWidth: false
    color: "transparent"
    Layout.leftMargin: 0
    implicitWidth: timeDisplayContainer.implicitWidth
    implicitHeight: timeDisplayContainer.implicitHeight
    Component.onCompleted: timeUpdater.refreshTimeDisplay()

    Column {
        id: timeDisplayContainer

        anchors.centerIn: parent
        spacing: UiTokens.spacing_xs

        TimeLabel {
            id: currentTime

            rootItem: temporalDisplay.rootItem
            config: temporalDisplay.config
        }

        DateLabel {
            id: currentDate

            rootItem: temporalDisplay.rootItem
            config: temporalDisplay.config
        }

    }

    QtObject {
        id: timeUpdater

        property var refreshTimer

        function refreshTimeDisplay() {
            currentDate.refreshDisplay();
            currentTime.refreshDisplay();
        }

        refreshTimer: Timer {
            interval: 1000
            repeat: true
            running: true
            triggeredOnStart: true
            onTriggered: timeUpdater.refreshTimeDisplay()
        }

    }

}
