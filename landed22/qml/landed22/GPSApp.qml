//import QtQuick 2.0
import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
import com.nokia.meego 1.0
import QtMobility.location 1.2
import "landed.js" as LJS
import SatInfoSource 1.0


Item {id: rectGPS
//Rectangle {id: rectGPS

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
        rectGPS.refreshCoords();
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
        console.log ("rectGPS.toggleGPS")
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
            PropertyChanges{ target: rectGPS; gpsOn: true } // change on variable
            PropertyChanges{ target: rectGPS; textColor: rectGPS.textColorActive }
            PropertyChanges{ target: rectGPS; labelColor: rectGPS.labelColorActive }
            PropertyChanges{ target: onOff; text: "On;" }

            //PropertyChanges{ target: positionSource; active: true }
            //PropertyChanges{ target: timer; running: true }
        },
        State {
            name: "stateGpsOff";
            PropertyChanges{ target: rectGPS; gpsOn: false } // change on variable
            PropertyChanges{ target: rectGPS; textColor: rectGPS.textColorInactive }
            PropertyChanges{ target: rectGPS; labelColor: rectGPS.labelColorInactive }
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

    function getLati() {
        console.log("getLati Called");
        return "Lati: "   + convertDDToDMS(positionSource.position.coordinate.latitude, "Lati");
    }

    function getCurrentCoordinate() {
        return positionSource.position.coordinate;
    }

    function getLongi() {
        console.log("getLongi Called");
        return "Long: "   + convertDDToDMS(positionSource.position.coordinate.longitude, "Longi");
    }

    function getAlti() {
        console.log("getAlti Called");
        return "Alt: "+ Math.round(positionSource.position.coordinate.altitude) + " m";
    }



    RumbleEffect {id: rumbleEffect}

    MouseArea {id: gpsMouseArea
        anchors.fill: parent
        onPressAndHold: {
            console.log("gpsMouseArea.onPressAndHold")
            rumbleEffect.start();
            gpsDialog.open();
        }
    }

    SatInfoSource {
        id: satInfoSource
        onSatellitesInUseUpdated: {
            rectGPS.satsInUse = satsInUse;
            setSatsText();
            console.log("SatellitesInUseUpdated! " + satsInUse);
        }
        onSatellitesInViewUpdated: {
            rectGPS.satsInView = satsInView;
            setSatsText();
            console.log("SatellitesInViewUpdated! " + satsInView);
        }
    }

    function setSatsText() {
        satsInViewUse.text = rectGPS.satsInView + " / " + rectGPS.satsInUse;
    }

    PositionSource {id: positionSource
        updateInterval: 1000
        active: false
        // nmeaSource: "nmealog.txt"
        onPositionChanged: {
            console.log("PositionChanged Signal Received! inner");
            //this could be used to start the timer,
            //and to enable the sms button
//TODO: won't the timer be restarted everytime postionChanged is called: reconsider this
            timer.start();
            rectGPS.positionChanged();
        }
    }

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
                Text {id: onOffLabel; text: "GPS:" ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: rectGPS.labelColor; width: 150}
                Text {id: onOff; text: "" ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: rectGPS.textColor}
            }
            AUISwitch {
                id: gpsSwitch
                anchors.right: parent.right
                checked: false
                anchors.verticalCenter: parent.verticalCenter
                onCheckedChanged: {
                    rectGPS.toggleGPS();
                    console.log("height of gpsSwitch is: " + gpsSwitch.height + " Text height is: " + onOffLabel.height)
                }
            }
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: latiLabel; text: "Lati:" ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: rectGPS.labelColor; width: 150}
            Text {id: lati; text: "searching ..."; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: rectGPS.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: lngiLabel; text: "Long:" ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: rectGPS.labelColor; width: 150}
            Text {id: lngi; text: "searching ..."; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: rectGPS.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: altiLabel; text: "Alti:"; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: rectGPS.labelColor; width: 150}
            Text {id: alti; text: isNaN(positionSource.position.coordinate.altitude) ? "n/a" : positionSource.position.coordinate.altitude + " m" ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: rectGPS.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: speedLabel; text: "Speed:"; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: rectGPS.labelColor; width: 150}
            Text {id: speed; text: Math.round(positionSource.position.speed * 3.6)  +" km/h" ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: rectGPS.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: horizAccLabel; text: "Horizontal Accuracy:"; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: rectGPS.labelColor; width: 320}
            Text {id: horizAcc; text: Math.round(positionSource.position.horizontalAccuracy*10)/10 + " m" ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: rectGPS.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: vertAccLabel; text: "Vertical Accuracy:" ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: rectGPS.labelColor; width: 320}
            Text {id: vertAcc; text: Math.round(positionSource.position.verticalAccuracy*10)/10 + " m" ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: rectGPS.textColor}
        }
        Row {
            spacing: coordsDisplay.rowSpacing;
            Text {id: satsInViewUseLabel; text: "Sats in View / Use:" ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: rectGPS.labelColor; width: 320}
            Text {id: satsInViewUse; text: "0 / 0" ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: rectGPS.textColor}
        }
        //TODO: consider using xxxvalid booleans to determine if info shown
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
                console.log("averageCoords called: " +  rectGPS.coordAveraging);
                if (rectGPS.coordAveraging) {
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
                lati.text = rectGPS.convertDDToDMS(newCoord.latitude, "Lati");
                lngi.text = rectGPS.convertDDToDMS(newCoord.longitude, "Longi");
            }
            else {
                lati.text = LJS.round(newCoord.latitude, 4);
                lngi.text = LJS.round(newCoord.longitude, 4);
            }
        }
    }

    AUIDialog {id: gpsDialog
        visualParent: rectGPS.parent

        buttons: AUIButtonColumn
        {
            //style: ButtonStyle { }
            anchors.horizontalCenter: parent.horizontalCenter
/*
            AUIButton {text: (rectGPS.gpsOn) ? qsTr("Turn GPS Off" ): qsTr("Turn GPS On")
                onClicked: {
                    rectGPS.toggleGPS()
                    gpsDialog.accept()
                }
            }
*/
            AUIButton {text: (coordFormatDMS) ? qsTr("Coordinates: Decimal" ): qsTr("Coordinates: D M S")
                onClicked: {
                    rectGPS.toogleCoordFormat()
                    gpsDialog.accept()
                }
            }
            AUIButton {text: (coordAveraging) ? qsTr("Coordinate Averaging off" ): qsTr("Coordinate Averaging on")
                onClicked: {
                    coordAveraging = !coordAveraging
                    gpsDialog.accept()
                }
            }

            /*
            AUIButton {text: "Refresh Coords";
                enabled: rectGPS.gpsOn;
                onClicked: {
                    rectGPS.refreshCoords();
                    gpsDialog.close();
                }
            }
            */
        }
    }

    function pause(millisecs) {
        var time1 = new Date()
        do {
            var time2 = new Date();
        } while (time2 - time1 < millisecs);
    }

    function printableMethod(method) {
        if (method == PositionSource.SatellitePositioningMethod)
            return "Satellite";
        else if (method == PositionSource.NoPositioningMethod)
            return "Not available"
        else if (method == PositionSource.NonSatellitePositioningMethod)
            return "Non-satellite"
        else if (method == PositionSource.AllPositioningMethods)
            return "All/multiple"
        return "source error";
    }
}

