//import QtQuick 2.0
import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
import QtMobility.sensors 1.2

Item {
    id: thisCompassApp

    property color textColorActive
    property color textColorInactive
    property color labelColorActive
    property color labelColorInactive

    property int fontSize: 30

    height: compassGUI.height

    function stop() {
        thisCompass.stop();
    }
    function start() {
        thisCompass.start();
    }

    Compass {
        id: thisCompass
        onReadingChanged: {
            compassText.text = reading.azimuth;
        }
    }

    Row {
        id: compassGUI
        height: 50
        spacing: 10
        anchors.verticalCenter: parent.verticalCenter
        Text {id: compassTextLabel; font.pointSize: thisCompassApp.fontSize; color: thisCompass.active ? thisCompassApp.labelColorActive : thisCompassApp.labelColorInactive; text: "Bearing:"; width: 150}
        Text {id: compassText; font.pointSize: thisCompassApp.fontSize; color: thisCompass.active ? thisCompassApp.textColorActive : thisCompassApp.textColorInactive; text: "No compass reading yet ..."}
    }

    AUISwitch {
        id: compassSwitch
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        checked: true
        onCheckedChanged: {
            thisCompass.active ? thisCompass.stop() : thisCompass.start();
        }
    }
}
