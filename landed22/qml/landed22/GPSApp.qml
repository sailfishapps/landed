//import QtQuick 2.0
import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
import com.nokia.meego 1.0
import QtMobility.location 1.2
import "landed.js" as LJS
import SatInfoSource 1.0

//TODO: currently this combines both backend GPS functionality and GUI GPS display
//for porting purposes it may be better to split into 2 halves

Item {id: thisGPS

    property bool gpsOn: false
    property bool coordAveraging: false
    property bool coordFormatDMS: true //Degree Minute Second
    //state is used to switch textColor from textColorActive to textColorInactive
    property color textColor
    property color textColorActive
    property color textColorInactive
    //state is used to switch labelColor from labelColorActive to labelColorInactive
    property color labelColor
    property color labelColorActive
    property color labelColorInactive
    property int fontSize: 30
    property int satsInUse: 0
    property int satsInView: 0

    height: coordsDisplay.height

    signal positionChanged()

    onCoordAveragingChanged: {
        coordsDisplay.resetAverages();
    }

    function toogleCoordFormat(){
        if (coordFormatDMS) {
            coordFormatDMS = false;
        }
        else {
           coordFormatDMS = true;
        }
        thisGPS.refreshCoords();
    }
//TODO: to avoid nasty state loops, everything that turns the GPS on or off should use the switch
//as unique entry point

    function activateGPS() {
        console.log ("activateGPS called. gpsSwitch.checked is: " + gpsSwitch.checked)
        gpsSwitch.checked = true
    }

    function deactivateGPS() {
        console.log ("deactivateGPS called. gpsSwitch.checked is: " + gpsSwitch.checked)
        gpsSwitch.checked = false
    }
//TODO: toggleGPS, onGPS and offGPS should be private functions,
//not externally available: the external gateway is activateGPS

    function toggleGPS() {
        console.log ("thisGPS.toggleGPS")
        if(state == "stateGpsOn") {
            offGPS();
        }
        else {
            onGPS();
        };
    }

    function onGPS () {
        console.log("turning GPS on")
        state = "stateGpsOn";
        positionSource.start();
        satInfoSource.startUpdates();
    }

    function offGPS () {
        console.log("turning GPS off")
        state = "stateGpsOff"
        positionSource.stop();
        satInfoSource.stopUpdates();
    }

    function refreshCoords() {
        coordsDisplay.refreshCoords();
    }

    state: "stateGpsOff";
    states: [
        State {
            name: "stateGpsOn";
            PropertyChanges{ target: thisGPS; gpsOn: true } // change on variable
            PropertyChanges{ target: thisGPS; textColor: thisGPS.textColorActive }
            PropertyChanges{ target: thisGPS; labelColor: thisGPS.labelColorActive }
            PropertyChanges{ target: onOff; text: "On;" }

            //PropertyChanges{ target: positionSource; active: true }
            //PropertyChanges{ target: timer; running: true }
        },
        State {
            name: "stateGpsOff";
            PropertyChanges{ target: thisGPS; gpsOn: false } // change on variable
            PropertyChanges{ target: thisGPS; textColor: thisGPS.textColorInactive }
            PropertyChanges{ target: thisGPS; labelColor: thisGPS.labelColorInactive }
            PropertyChanges{ target: onOff; text: "Off;" }
            //PropertyChanges{ target: positionSource; active: false }
            PropertyChanges{ target: timer; running: false }
        }
    ]

    Timer{ id: timer;
        interval: 60*1000;
        //onTriggered: {state = "stateGpsOff"}
        onTriggered: {gpsSwitch.checked = false;}
    }


    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////
    //Backend Functionality
    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////

    //called from MainPage.qml
    function getCurrentCoordinate() {
        return positionSource.position.coordinate;
    }

    //called from MainPage.qml
    function getLati() {
        console.log("getLati Called");
        return "Lati: "   + positionSource.convertDDToDMS(positionSource.position.coordinate.latitude, "Lati");
    }

    //called from MainPage.qml
    function getLongi() {
        console.log("getLongi Called");
        return "Long: "   + positionSource.convertDDToDMS(positionSource.position.coordinate.longitude, "Longi");
    }

    //called from MainPage.qml
    function getAlti() {
        console.log("getAlti Called");
        return "Alt: "+ Math.round(positionSource.position.coordinate.altitude) + " m";
    }

    //gives access to info on number of Sats in view / use
    SatInfoSource {
        id: satInfoSource
        onSatellitesInUseUpdated: {
            thisGPS.satsInUse = satsInUse;
            coordsDisplay.setSatsText();
            console.log("SatellitesInUseUpdated! " + satsInUse);
        }
        onSatellitesInViewUpdated: {
            thisGPS.satsInView = satsInView;
            coordsDisplay.setSatsText();
            console.log("SatellitesInViewUpdated! " + satsInView);
        }
    }

    //gives access to GPS info
    PositionSource {id: positionSource
        updateInterval: 1000
        active: false
        // nmeaSource: "nmealog.txt"
        onPositionChanged: {
            console.log("PositionChanged Signal Received! inner");
            //If the timer is running, subsequent calls to start() have no effect
            timer.start();
            thisGPS.positionChanged();
        }
        function convertDDToDMS(dd, axis){

            /*
            Distance between 2 GPS points calculated by the Haversine formulae is:

            http://www.movable-type.co.uk/scripts/latlong.html

            Using Patras Greece as a reference
            38 09 34N
            21 31 15E

            1 degree North is 111.2 km
            1 degree East is 87.43 km

            1 minute North is 1.853 km
            1 degree East is 1.457 km

            1 second North is 0.03089 km --> 31 meters
            1 second East is 0.02429 km --> 24 meters

            1 tenth of a second North is 0.003089 km --> 3 meters
            1 tenth of a second East is 0.002429 km --> 2.4 meters

            This means that one decimal point is acurate enough!!!!

            */
            var ddOrig = dd;
            console.log(ddOrig);
            dd = Math.abs(dd);  //make positive
            if (isNaN(dd)) {
                console.log ("yep, Nan");
                return "No valid position yet";
            }
            //console.log ("axis is: " + axis);
            //console.log ("dd is: " + dd);
            var deg = LJS.pad(dd | 0); // truncate dd to get degrees
            //console.log ("deg is: " + deg);
            var frac = dd - deg; // get fractional part
            //console.log ("frac is: " + frac);
            var min = LJS.pad((frac * 60) | 0); // multiply fraction by 60 and truncate
            //console.log ("min is: " + min);
            var sec = frac * 3600 - min * 60;
            sec = LJS.pad(LJS.round(sec, 1)); // round to ONE decmal place
            //console.log ("sec is: " + sec);
            var suffix
            if (axis == "Lati") {
                (ddOrig >= 0) ? (suffix = 'N') : (suffix = 'S')
            }
            else if (axis == "Longi") {
                (ddOrig >= 0) ? (suffix = 'E') : (suffix = 'W')
            }

            return deg + "d " + min + "m " + sec + "s " + suffix;
        }

    }

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
                Text {id: onOffLabel; text: "GPS:" ; font.family: "Arial"; font.pointSize: thisGPS.fontSize; color: thisGPS.labelColor; width: 150}
                Text {id: onOff; text: "" ; font.family: "Arial"; font.pointSize: thisGPS.fontSize; color: thisGPS.textColor}
            }
            AUISwitch {
                id: gpsSwitch
                anchors.right: parent.right
                checked: false
                anchors.verticalCenter: parent.verticalCenter
                onCheckedChanged: {
                    thisGPS.toggleGPS();
                    console.log("height of gpsSwitch is: " + gpsSwitch.height + " Text height is: " + onOffLabel.height)
                }
            }
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: latiLabel; text: "Lati:" ; font.family: "Arial"; font.pointSize: thisGPS.fontSize; color: thisGPS.labelColor; width: 150}
            Text {id: lati; text: "searching ..."; font.family: "Arial"; font.pointSize: thisGPS.fontSize; color: thisGPS.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: lngiLabel; text: "Long:" ; font.family: "Arial"; font.pointSize: thisGPS.fontSize; color: thisGPS.labelColor; width: 150}
            Text {id: lngi; text: "searching ..."; font.family: "Arial"; font.pointSize: thisGPS.fontSize; color: thisGPS.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: altiLabel; text: "Alti:"; font.family: "Arial"; font.pointSize: thisGPS.fontSize; color: thisGPS.labelColor; width: 150}
            Text {id: alti; text: isNaN(positionSource.position.coordinate.altitude) ? "n/a" : positionSource.position.coordinate.altitude + " m" ; font.family: "Arial"; font.pointSize: thisGPS.fontSize; color: thisGPS.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: speedLabel; text: "Speed:"; font.family: "Arial"; font.pointSize: thisGPS.fontSize; color: thisGPS.labelColor; width: 150}
            Text {id: speed; text: (positionSource.position.speedValid) ? Math.round(positionSource.position.speed * 3.6)  +" km/h" : "n/a" ; font.family: "Arial"; font.pointSize: thisGPS.fontSize; color: thisGPS.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: horizAccLabel; text: "Horizontal Accuracy:"; font.family: "Arial"; font.pointSize: thisGPS.fontSize; color: thisGPS.labelColor; width: 320}
            Text {id: horizAcc; text: (positionSource.position.horizontalAccuracyValid) ? Math.round(positionSource.position.horizontalAccuracy*10)/10 + " m" : "n/a" ; font.family: "Arial"; font.pointSize: thisGPS.fontSize; color: thisGPS.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: vertAccLabel; text: "Vertical Accuracy:" ; font.family: "Arial"; font.pointSize: thisGPS.fontSize; color: thisGPS.labelColor; width: 320}
            Text {id: vertAcc; text: (positionSource.position.verticalAccuracyValid) ? Math.round(positionSource.position.verticalAccuracy*10)/10 + " m" : "n/a" ; font.family: "Arial"; font.pointSize: thisGPS.fontSize; color: thisGPS.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: satsInViewUseLabel; text: "Sats in View / Use:" ; font.family: "Arial"; font.pointSize: thisGPS.fontSize; color: thisGPS.labelColor; width: 320}
            Text {id: satsInViewUse; text: "0 / 0" ; font.family: "Arial"; font.pointSize: thisGPS.fontSize; color: thisGPS.textColor}
        }

        //http://harmattan-dev.nokia.com/docs/library/html/qtmobility/qml-position.html

        Connections {
             target: positionSource.position.coordinate
             onLatitudeChanged: {
                 console.log ("signal from positionSource.position.coordinate snatched out of the ether ...");
                 refreshCoords()
             }
             onLongitudeChanged: {
                 console.log ("signal from positionSource.position.coordinate snatched out of the ether ...");
                 refreshCoords()
             }
        }

        Coordinate {
            id: averagedCoords
            latitude: 0
            longitude: 0
            property real summedLatitude: 0;
            property real summedLongitude: 0;
            property int hits: 0;
            function resetAverages() {
                latitude = 0;
                longitude = 0;
                summedLatitude = 0;
                summedLongitude = 0;
                hits = 0;
            }
            function averageCoords(coord) {
                console.log("averageCoords called: " +  thisGPS.coordAveraging);
                if (thisGPS.coordAveraging) {
                    console.log("distance from average: "+ coord.distanceTo(averagedCoords) + " m")
                    if (coord.distanceTo(averagedCoords) > 500) {
                        //500 m
                        //difference to average is too great, we are probably moving: reset our averages and start again.
                        console.log("difference too great, resetting");
                        resetAverages();
                    }
                    hits++;
                    console.log("coords averaged over hits: " + hits);
                    console.log("1) averagedCoords.summedLatitude: " + summedLatitude + ", averagedCoords.latitude: " + latitude);
                    summedLatitude = summedLatitude + coord.latitude;
                    console.log("2) averagedCoords.summedLatitude: " + summedLatitude);
                    summedLongitude = summedLongitude + coord.longitude;
                    latitude = summedLatitude / hits;
                    longitude = summedLongitude / hits;
                    console.log("orig lati: " + coord.latitude + ", averaged lati: " + latitude);
                    console.log("orig longi: " + coord.longitude + ", averaged longi: " + longitude);
                    return averagedCoords;
                }
                else  {
                    return coord;
                }
            }
        }

        //TODO: refactoring: should not this stuff all be in an abstraction of PositionSource
        //this would offer both original and averaged coords + relevant changedSignals

        function resetAverages() {
            averagedCoords.resetAverages();
        }

        function refreshCoords() {
            console.log("refreshCoords called")
            var newCoord = averagedCoords.averageCoords(positionSource.position.coordinate);
            if (coordFormatDMS) {
                lati.text = positionSource.convertDDToDMS(newCoord.latitude, "Lati");
                lngi.text = positionSource.convertDDToDMS(newCoord.longitude, "Longi");
            }
            else {
                lati.text = LJS.round(newCoord.latitude, 4);
                lngi.text = LJS.round(newCoord.longitude, 4);
            }
        }

        function setSatsText() {
            satsInViewUse.text = thisGPS.satsInView + " / " + thisGPS.satsInUse;
        }
    }



    //GUI: Dialog opened by pressAndHolding GPS display, gives access to GPS related settings
    AUIDialog {id: gpsDialog
        visualParent: thisGPS.parent

        buttons: AUIButtonColumn
        {
            //style: ButtonStyle { }
            anchors.horizontalCenter: parent.horizontalCenter
/*
            AUIButton {text: (thisGPS.gpsOn) ? qsTr("Turn GPS Off" ): qsTr("Turn GPS On")
                onClicked: {
                    thisGPS.toggleGPS()
                    gpsDialog.accept()
                }
            }
*/
            AUIButton {text: (coordFormatDMS) ? qsTr("Coordinates: Decimal" ): qsTr("Coordinates: D M S")
                onClicked: {
                    thisGPS.toogleCoordFormat()
                    gpsDialog.accept()
                }
            }
            AUIButton {text: (coordAveraging) ? qsTr("Coordinate Averaging off" ): qsTr("Coordinate Averaging on")
                onClicked: {
                    coordAveraging = !coordAveraging
                    gpsDialog.accept()
                }
            }
        }
    }
}

