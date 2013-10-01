import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import QtMobility.location 1.2
import "landed.js" as LJS


Item {id: rectGPS
//Rectangle {id: rectGPS

    property bool gpsOn: false
    property color textColor: "white"
    property int fontSize: 30

    signal positionChanged()

    function toggleGPS() {
        console.log ("rectGPS.toggleGPS")
        if(state == "stateGpsOn") { state = "stateGpsOff" } else { state = "stateGpsOn" };
    }

    function onGPS () {
        state = "stateGpsOn";
    }

    function offGPS () {
        state = "stateGpsOff"
    }

    function refreshCoords() {
        coordsDisplay.refreshCoords();
    }

    state: "stateGpsOff";
    states: [
        State {
            name: "stateGpsOn";
            PropertyChanges{ target: rectGPS; gpsOn: true } // change on variable
            PropertyChanges{ target: rectGPS; textColor: "lightGrey" }
            PropertyChanges{ target: onOff; text: "On" }
            PropertyChanges{ target: positionSource; active: true }
            //PropertyChanges{ target: timer; running: true }
        },
        State {
            name: "stateGpsOff";
            PropertyChanges{ target: rectGPS; gpsOn: false } // change on variable
            PropertyChanges{ target: rectGPS; textColor: "darkGrey" }
            PropertyChanges{ target: onOff; text: "Off" }
            PropertyChanges{ target: positionSource; active: false }
            PropertyChanges{ target: timer; running: false }
        }
    ]

    Timer{ id: timer;
        interval: 60*1000;
        onTriggered: {state = "stateGpsOff"}
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

    PositionSource {id: positionSource
        updateInterval: 1000
        active: false
        // nmeaSource: "nmealog.txt"
        onPositionChanged: {
            console.log("PositionChanged Signal Received! inner");
            //this could be used to start the timer,
            //and to enable the sms button
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
        //Text {text: "<==== PositionSource ====>" ; font.family: "Arial";font.pointSize: rectGPS.fontSize; color: "black"}
        Text {id: onOff; text: "tbd: " ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: "black"}
        //Text {text: "positioningMethod: "  + printableMethod(positionSource.positioningMethod) ; font.family: "Arial";font.pointSize: rectGPS.fontSize; color: parent.textColor}
        //Text {text: "updateInterval: "     + positionSource.updateInterval ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: parent.textColor}
        Text {id: stat; text: "active: "     + positionSource.active ; anchors.right: parent.right; anchors.rightMargin: 346; anchors.left: parent.left; anchors.leftMargin: 0; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: "black"}
        //Text {text: "<==== Position ====>" ; font.family: "Arial";font.pointSize: rectGPS.fontSize; color: "black"}
        Text {id: lati; text: "lati: " ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: "black"}
        Text {id: lngi; text: "long: " ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: "black"}
        //Text {id: lati2; text: "lati2: " + positionSource.position.coordinate.latitude ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: "black"}
        //Text {id: lngi2; text: "long2: " + positionSource.position.coordinate.longitude ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: "black"}
        Text {id: alti; text: "Alti: "   + positionSource.position.coordinate.altitude ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: "black"}
        Text {id: speed; text: "Speed: "   + Math.round(positionSource.position.speed * 3.6)  +" km/h" ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: "black"}
        //Text {id: time; text: "time: "  + positionSource.position.timestamp ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: "black"}
        Text {id: horizAcc; text: "horizontal accuracy: " + Math.round(positionSource.position.horizontalAccuracy*10)/10 + " m" ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: "black"}
        Text {id: vertAcc; text: "vertical accuracy: " + Math.round(positionSource.position.verticalAccuracy*10)/10 + " m" ; font.family: "Arial"; font.pointSize: rectGPS.fontSize; color: "black"}

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

        function refreshCoords() {
            console.log("refreshCoords called")
            lati.text = "Lati: "   + rectGPS.convertDDToDMS(positionSource.position.coordinate.latitude, "Lati");
            lngi.text = "Long: "   + rectGPS.convertDDToDMS(positionSource.position.coordinate.longitude, "Longi");
        }
    }

    AUIDialog {id: gpsDialog
        visualParent: rectGPS.parent

        buttons: AUIButtonColumn
        {
            //style: ButtonStyle { }
            anchors.horizontalCenter: parent.horizontalCenter

            AUIButton {text: (rectGPS.gpsOn) ? qsTr("Turn GPS Off" ): qsTr("Turn GPS On")
                onClicked: {
                    rectGPS.toggleGPS()
                    gpsDialog.accept()
                }
            }
            AUIButton {text: "Refresh Coords";
                enabled: rectGPS.gpsOn;
                onClicked: {
                    rectGPS.refreshCoords();
                    gpsDialog.close();
                }
            }
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

