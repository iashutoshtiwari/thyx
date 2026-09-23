import QtMultimedia
import QtQuick 2.15

Item {
    id: background

    property var config: ({
    })
    property color fallbackColor: "#11111b"
    property alias imageItem: backgroundImage
    readonly property string backgroundPath: (config.Background && config.Background !== "") ? String(config.Background) : ""
    readonly property string backgroundExtension: backgroundPath !== "" ? backgroundPath.split(".").pop().toLowerCase() : ""
    readonly property bool hasBackground: backgroundPath !== ""
    readonly property bool isVideo: ["avi", "mp4", "mov", "mkv", "m4v", "webm"].indexOf(backgroundExtension) !== -1
    readonly property bool hasImage: hasBackground && !isVideo
    readonly property bool hasVideo: hasBackground && isVideo
    readonly property url backgroundUrl: hasBackground ? Qt.resolvedUrl("../../" + backgroundPath) : ""

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: background.fallbackColor
    }

    Image {
        id: backgroundImage

        anchors.fill: parent
        source: background.hasImage ? background.backgroundUrl : ""
        asynchronous: false
        cache: true
        clip: true
        mipmap: false
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
        fillMode: Image.PreserveAspectCrop
        visible: background.hasImage && status === Image.Ready
    }

    VideoOutput {
        id: videoOutput

        anchors.fill: parent
        visible: background.hasVideo
        fillMode: VideoOutput.PreserveAspectCrop
    }

    MediaPlayer {
        id: player

        videoOutput: videoOutput
        autoPlay: background.hasVideo
        loops: -1
        source: background.hasVideo ? background.backgroundUrl : ""
    }

    Rectangle {
        id: readabilityScrim

        anchors.fill: parent
        color: "#11111b"
        opacity: 0.35
        visible: background.hasBackground
    }

}
