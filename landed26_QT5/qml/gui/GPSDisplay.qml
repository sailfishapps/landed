import QtQuick 2.0
//import QtQuick 1.1
//import org.flyingsheep.abstractui.qtquick 1.0
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import LandedTheme 1.0

//By design this is component is a "thin" GUI layer.
//This means it should be as simple / stupid as possible.
//All functionality and logic should be in the GPSBackEnd.
//This includes "formatting" logic that is GUI-centric.
//This is aid porting to other platforms.


//The main external interface is via the properties below
//on instance of this component on MainPage these properties are bound to their GPSDisplay equivalents
//In other direction, the display can request changes from the GPSBackEnd via requestXXX signals.

Item {id: thisGPSDisplay

    signal requestGPSActive(bool active);
    signal requestCoordAveraging(bool averaging);
    signal requestCompassActive(bool active);

    //gpsOn is bound in the instantiation (MainPage) to GPSBackEnd
    //Turning the GPSBackEnd on / off is via the signal requestGPSActive
    property bool gpsOn: false
    property bool compassOn: false

    //coordAveraging is bound in the instantiation (MainPage) to GPSBackEnd
    //It is changed by calling the signal requestCoordAveraging:
    property bool coordAveraging

    // GPSBackEnd has no equivalent to coordFormatDMS, it is passed as parameter when coords are formatted
    // in the bindings of latitude and longitude
    property bool coordFormatDMS: true;

    property bool reliableLocationAcquired: false
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
    property int bearing: 0

    //state is used to switch textColor from textColorActive to textColorInactive
    property color textColor
    property color textColorActive
    property color textColorInactive
    //state is used to switch labelColor from labelColorActive to labelColorInactive
    property color labelColor
    property color labelColorActive
    property color labelColorInactive
    //property int fontPixelSize

    height: coordsDisplay.height;

//TODO: this function, + property coordFormatDMS really belong to coordsDisplay
//and should be refactored into that component

//TODO: to avoid nasty state loops, everything that turns the GPS on or off should use the switch
//as unique entry point

   onGpsOnChanged: {
       console.log("onGpsOnChanged to: " + gpsOn)
       gpsSwitch.checked = gpsOn
   }

    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////
    //GUI Elements
    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////

    //GUI: GPS "Display" showing coords, alti, on off switche etc
    Column {id: coordsDisplay
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        property int rowSpacing: 10
        spacing: 4

        state: "stateGpsOff";
        states: [
            State {
                name: "stateGpsOn";
                //PropertyChanges{ target: thisGPSDisplay; gpsOn: true }
                PropertyChanges{ target: thisGPSDisplay; textColor: thisGPSDisplay.textColorActive }
                PropertyChanges{ target: thisGPSDisplay; labelColor: thisGPSDisplay.labelColorActive }
                PropertyChanges{ target: onOff; text: "On:" }
            },
            State {
                name: "stateGpsOff";
                //PropertyChanges{ target: thisGPSDisplay; gpsOn: false }
                PropertyChanges{ target: thisGPSDisplay; textColor: thisGPSDisplay.textColorInactive }
                PropertyChanges{ target: thisGPSDisplay; labelColor: thisGPSDisplay.labelColorInactive }
                PropertyChanges{ target: onOff; text: "Off:" }
            }
        ]

        Item {
            //height: childrenRect.height // causes binding-loop
            height: onOff.height
            width: parent.width
            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: coordsDisplay.rowSpacing;
                Text {id: onOffLabel; text: "GPS:" ; font.family: "Arial"; font.pixelSize: LandedTheme.FontSizeMedium; color: thisGPSDisplay.labelColor; width: 120}
                Text {id: onOff; text: "" ; font.family: "Arial"; font.pixelSize: LandedTheme.FontSizeMedium; color: thisGPSDisplay.textColor}
            }
            AUISwitch {
                id: gpsSwitch
                anchors.right: parent.right
                anchors.rightMargin: -20 //sailfish
                checked: false
                anchors.verticalCenter: parent.verticalCenter
                onCheckedChanged: {
                    coordsDisplay.toggleGPS();
                }
            }
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: latiLabel; text: "Lati:" ; font.family: "Arial"; font.pixelSize: LandedTheme.FontSizeMedium; color: thisGPSDisplay.labelColor; width: 120}
            Text {id: lati; text: (thisGPSDisplay.reliableLocationAcquired) ? thisGPSDisplay.latitude: "!!! " + thisGPSDisplay.latitude + " !!!"; font.family: "Arial"; font.pixelSize: LandedTheme.FontSizeMedium; color: thisGPSDisplay.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: lngiLabel; text: "Long:" ; font.family: "Arial"; font.pixelSize: LandedTheme.FontSizeMedium; color: thisGPSDisplay.labelColor; width: 120}
            Text {id: lngi; text: (thisGPSDisplay.reliableLocationAcquired) ? thisGPSDisplay.longitude: "!!! " + thisGPSDisplay.longitude + " !!!"; font.family: "Arial"; font.pixelSize: LandedTheme.FontSizeMedium; color: thisGPSDisplay.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: altiLabel; text: "Alti:"; font.family: "Arial"; font.pixelSize: LandedTheme.FontSizeMedium; color: thisGPSDisplay.labelColor; width: 120}
            Text {id: alti; text: isNaN(thisGPSDisplay.altitude) ? "n/a" : thisGPSDisplay.altitude + " m" ; font.family: "Arial"; font.pixelSize: LandedTheme.FontSizeMedium; color: thisGPSDisplay.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: speedLabel; text: "Speed:"; font.family: "Arial"; font.pixelSize: LandedTheme.FontSizeMedium; color: thisGPSDisplay.labelColor; width: 120}
            Text {id: speed; text: (thisGPSDisplay.speedValid) ? Math.round(thisGPSDisplay.speed * 3.6)  +" km/h" : "n/a" ; font.family: "Arial"; font.pixelSize: LandedTheme.FontSizeMedium; color: thisGPSDisplay.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: horizAccLabel; text: "Horizontal Accuracy:"; font.family: "Arial"; font.pixelSize: LandedTheme.FontSizeMedium; color: thisGPSDisplay.labelColor; width: 320}
            Text {id: horizAcc; text: (thisGPSDisplay.horizontalAccuracyValid) ? Math.round(thisGPSDisplay.horizontalAccuracy*10)/10 + " m" : "n/a" ; font.family: "Arial"; font.pixelSize: LandedTheme.FontSizeMedium; color: thisGPSDisplay.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: vertAccLabel; text: "Vertical Accuracy:" ; font.family: "Arial"; font.pixelSize: LandedTheme.FontSizeMedium; color: thisGPSDisplay.labelColor; width: 320}
            Text {id: vertAcc; text: (thisGPSDisplay.verticalAccuracyValid) ? Math.round(thisGPSDisplay.verticalAccuracy*10)/10 + " m" : "n/a" ; font.family: "Arial"; font.pixelSize: LandedTheme.FontSizeMedium; color: thisGPSDisplay.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: satsInViewUseLabel; text: "Sats in View / Use:" ; font.family: "Arial"; font.pixelSize: LandedTheme.FontSizeMedium; color: thisGPSDisplay.labelColor; width: 320}
            Text {id: satsInViewUse; text: thisGPSDisplay.satsInView + " / " + thisGPSDisplay.satsInUse ; font.family: "Arial"; font.pixelSize: LandedTheme.FontSizeMedium; color: thisGPSDisplay.textColor}
        }
        Item {
            height: compassSwitch.height
            width: parent.width
            Row {
                id: compassGUI
                height: 50
                spacing: 10
                anchors.verticalCenter: parent.verticalCenter
                Text {id: compassTextLabel; font.pixelSize: LandedTheme.FontSizeMedium; color: compassOn ? thisGPSDisplay.labelColorActive : thisGPSDisplay.labelColorInactive; text: "Bearing:"; width: 120}
                Text {id: compassText; text: thisGPSDisplay.bearing; font.pixelSize: LandedTheme.FontSizeMedium; color: compassOn ? thisGPSDisplay.textColorActive : thisGPSDisplay.textColorInactive; }
            //text: "No compass reading yet ..."
            }

            AUISwitch {
                id: compassSwitch
                anchors.right: parent.right
                anchors.rightMargin: -20 //sailfish
                anchors.verticalCenter: parent.verticalCenter
                checked: true
                onCheckedChanged: {
                    requestCompassActive(!compassOn)
                }
            }
        }


        function toggleGPS() {
            console.log ("thisGPSDisplay.toggleGPS")
            if(state == "stateGpsOn") {
                console.log("turning GPSDisplay off");
                if (gpsOn) requestGPSActive(false);
                state = "stateGpsOff"
            }
            else {
                console.log("turning GPSDisplay on")
                if (!gpsOn) requestGPSActive(true);
                state = "stateGpsOn";
            };
        }
    }

/*
TODO:
Disabled ad interim pending introduction of a settings page!
As sailfish does not offer the same kind of dialog as harmattan, and these options are not essential
rather than trying to force a harmattan dialog onto sailfish, move these options onto a settings page
together with other settings

    //GUI: Dialog opened by pressAndHolding GPS display, gives access to GPS related settings
    AUIDialog {id: gpsDialog
        //TODO: consider property acceptDestination in place of the harmattan visualParent
        //        visualParent: thisGPSDisplay.parent

        buttons: AUIButtonColumn
        {
            anchors.horizontalCenter: gpsDialog.horizontalCenter

            AUIButton {text: (thisGPSDisplay.coordFormatDMS) ? qsTr("Coordinates: Decimal" ): qsTr("Coordinates: D M S")
                onClicked: {
                    thisGPSDisplay.coordFormatDMS = !thisGPSDisplay.coordFormatDMS;
                    gpsDialog.accept();
                }
            }
            AUIButton {text: (thisGPSDisplay.coordAveraging) ? qsTr("Coordinate Averaging off" ): qsTr("Coordinate Averaging on")
                onClicked: {
                    thisGPSDisplay.requestCoordAveraging(!thisGPSDisplay.coordAveraging)
                    gpsDialog.accept();
                }
            }
        }
    }
*/
}

