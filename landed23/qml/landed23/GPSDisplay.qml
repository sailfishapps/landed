//import QtQuick 2.0
import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
import com.nokia.meego 1.0
//import QtMobility.location 1.2
//import "landed.js" as LJS


//By design this is component is a "thin" GUI layer.
//This means it should be as simple / stupid as possible.
//All functionality and logic should be in the GPSBackEnd.
//This includes "formatting" logic that is GUI-centric.
//This is aid porting to other platforms.

Item {id: thisGPSDisplay

    property bool gpsOn: false
    property bool coordFormatDMS: true;
    property bool coordAveraging

//TODO: should this set not be property aliases
//apparently property aliases are read only?
    //property alias latitude: lati;
    //property alias longitude: lngi;
    //property alias altitude: alti

    property string latitude: "searching ...";
    property string longitude: "searching ...";
    property string altitude: "searching ...";
    property bool speedValid;
    property real speed;
    property bool horizontalAccuracyValid;
    property real horizontalAccuracy;
    property bool verticalAccuracyValid;
    property real verticalAccuracy;
    property int satsInView: 0
    property int satsInUse: 0


    //state is used to switch textColor from textColorActive to textColorInactive
    property color textColor
    property color textColorActive
    property color textColorInactive
    //state is used to switch labelColor from labelColorActive to labelColorInactive
    property color labelColor
    property color labelColorActive
    property color labelColorInactive
    property int fontSize: 30

    height: coordsDisplay.height;

//TODO: this function, + property coordFormatDMS really belong to coordsDisplay
//and should be refactored into that component

//TODO: to avoid nasty state loops, everything that turns the GPS on or off should use the switch
//as unique entry point

    function displayOn() {
        console.log ("displayOn Display called. gpsSwitch.checked is: " + gpsSwitch.checked)
        gpsSwitch.checked = true
    }

    function displayOff() {
        console.log ("displayOff display called. gpsSwitch.checked is: " + gpsSwitch.checked)
        gpsSwitch.checked = false
    }
//TODO: toggleGPS, onGPS and offGPS should be private functions,
//not externally available: the external gateway is displayOn

    function toggleGPS() {
        console.log ("thisGPSDisplay.toggleGPS")
        if(state == "stateGpsOn") {
            offGPS();
        }
        else {
            onGPS();
        };
    }

    function onGPS () {
        console.log("turning GPSDisplay on")
        state = "stateGpsOn";
    }

    function offGPS () {
        console.log("turning GPSDisplay off")
        state = "stateGpsOff"
    }

    function refreshCoords() {
        coordsDisplay.refreshCoords();
    }

    state: "stateGpsOff";
    states: [
        State {
            name: "stateGpsOn";
            PropertyChanges{ target: thisGPSDisplay; gpsOn: true } // change on variable
            PropertyChanges{ target: thisGPSDisplay; textColor: thisGPSDisplay.textColorActive }
            PropertyChanges{ target: thisGPSDisplay; labelColor: thisGPSDisplay.labelColorActive }
            PropertyChanges{ target: onOff; text: "On;" }
        },
        State {
            name: "stateGpsOff";
            PropertyChanges{ target: thisGPSDisplay; gpsOn: false } // change on variable
            PropertyChanges{ target: thisGPSDisplay; textColor: thisGPSDisplay.textColorInactive }
            PropertyChanges{ target: thisGPSDisplay; labelColor: thisGPSDisplay.labelColorInactive }
            PropertyChanges{ target: onOff; text: "Off;" }
        }
    ]

    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////
    //GUI Elements
    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////

    //GUI: when pressAndHeld, opens gpsDialog
    //Note if the mousearea is placed after the coordsDisplay, then the gpsSwitch does not work
    //placing the mousearea before, allows the switch to work! Wierd or what?
    MouseArea {id: gpsMouseArea
        anchors.fill: parent
        onPressAndHold: {
            console.log("gpsMouseArea.onPressAndHold")
            rumbleEffect.start();
            gpsDialog.open();
        }
        RumbleEffect {id: rumbleEffect}
    }

    //GUI: GPS "Display" showing coords, alti, on off switche etc
    Column {id: coordsDisplay
        //font.pointSize: 24
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        property int rowSpacing: 10
        spacing: 4

        Item {
            //height: childrenRect.height // causes binding-loop
            height: onOff.height
            width: parent.width
            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: coordsDisplay.rowSpacing;
                Text {id: onOffLabel; text: "GPS:" ; font.family: "Arial"; font.pointSize: thisGPSDisplay.fontSize; color: thisGPSDisplay.labelColor; width: 150}
                Text {id: onOff; text: "" ; font.family: "Arial"; font.pointSize: thisGPSDisplay.fontSize; color: thisGPSDisplay.textColor}
            }
            AUISwitch {
                id: gpsSwitch
                anchors.right: parent.right
                checked: false
                anchors.verticalCenter: parent.verticalCenter
                onCheckedChanged: {
                    thisGPSDisplay.toggleGPS();
                    console.log("height of gpsSwitch is: " + gpsSwitch.height + " Text height is: " + onOffLabel.height)
                }
            }
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: latiLabel; text: "Lati:" ; font.family: "Arial"; font.pointSize: thisGPSDisplay.fontSize; color: thisGPSDisplay.labelColor; width: 150}
            Text {id: lati; text: thisGPSDisplay.latitude; font.family: "Arial"; font.pointSize: thisGPSDisplay.fontSize; color: thisGPSDisplay.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: lngiLabel; text: "Long:" ; font.family: "Arial"; font.pointSize: thisGPSDisplay.fontSize; color: thisGPSDisplay.labelColor; width: 150}
            Text {id: lngi; text: thisGPSDisplay.longitude; font.family: "Arial"; font.pointSize: thisGPSDisplay.fontSize; color: thisGPSDisplay.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: altiLabel; text: "Alti:"; font.family: "Arial"; font.pointSize: thisGPSDisplay.fontSize; color: thisGPSDisplay.labelColor; width: 150}
            Text {id: alti; text: isNaN(thisGPSDisplay.altitude) ? "n/a" : thisGPSDisplay.altitude + " m" ; font.family: "Arial"; font.pointSize: thisGPSDisplay.fontSize; color: thisGPSDisplay.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: speedLabel; text: "Speed:"; font.family: "Arial"; font.pointSize: thisGPSDisplay.fontSize; color: thisGPSDisplay.labelColor; width: 150}
            Text {id: speed; text: (thisGPSDisplay.speedValid) ? Math.round(thisGPSDisplay.speed * 3.6)  +" km/h" : "n/a" ; font.family: "Arial"; font.pointSize: thisGPSDisplay.fontSize; color: thisGPSDisplay.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: horizAccLabel; text: "Horizontal Accuracy:"; font.family: "Arial"; font.pointSize: thisGPSDisplay.fontSize; color: thisGPSDisplay.labelColor; width: 320}
            Text {id: horizAcc; text: (thisGPSDisplay.horizontalAccuracyValid) ? Math.round(thisGPSDisplay.horizontalAccuracy*10)/10 + " m" : "n/a" ; font.family: "Arial"; font.pointSize: thisGPSDisplay.fontSize; color: thisGPSDisplay.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: vertAccLabel; text: "Vertical Accuracy:" ; font.family: "Arial"; font.pointSize: thisGPSDisplay.fontSize; color: thisGPSDisplay.labelColor; width: 320}
            Text {id: vertAcc; text: (thisGPSDisplay.verticalAccuracyValid) ? Math.round(thisGPSDisplay.verticalAccuracy*10)/10 + " m" : "n/a" ; font.family: "Arial"; font.pointSize: thisGPSDisplay.fontSize; color: thisGPSDisplay.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: satsInViewUseLabel; text: "Sats in View / Use:" ; font.family: "Arial"; font.pointSize: thisGPSDisplay.fontSize; color: thisGPSDisplay.labelColor; width: 320}
            Text {id: satsInViewUse; text: thisGPSDisplay.satsInView + " / " + thisGPSDisplay.satsInUse ; font.family: "Arial"; font.pointSize: thisGPSDisplay.fontSize; color: thisGPSDisplay.textColor}
        }

        //http://harmattan-dev.nokia.com/docs/library/html/qtmobility/qml-position.html
    }


    //GUI: Dialog opened by pressAndHolding GPS display, gives access to GPS related settings
    AUIDialog {id: gpsDialog
        visualParent: thisGPSDisplay.parent

        buttons: AUIButtonColumn
        {
            //style: ButtonStyle { }
            anchors.horizontalCenter: parent.horizontalCenter
/*
            AUIButton {text: (thisGPSDisplay.gpsOn) ? qsTr("Turn GPS Off" ): qsTr("Turn GPS On")
                onClicked: {
                    thisGPSDisplay.toggleGPS()
                    gpsDialog.accept()
                }
            }
*/
            AUIButton {text: (thisGPSDisplay.coordFormatDMS) ? qsTr("Coordinates: Decimal" ): qsTr("Coordinates: D M S")
                onClicked: {
                    thisGPSDisplay.coordFormatDMS = !thisGPSDisplay.coordFormatDMS;
                    gpsDialog.accept();
                }
            }
            AUIButton {text: (thisGPSDisplay.coordAveraging) ? qsTr("Coordinate Averaging off" ): qsTr("Coordinate Averaging on")
                onClicked: {
                    thisGPSDisplay.coordAveraging = !thisGPSDisplay.coordAveraging;
                    gpsDialog.accept();
                }
            }
        }
    }
}

