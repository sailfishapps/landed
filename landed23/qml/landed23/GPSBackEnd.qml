//import QtQuick 2.0
import QtQuick 1.1
import QtMobility.location 1.2
import "landed.js" as LJS
import SatInfoSource 1.0


Item {id: thisGPS

/*
    property bool gpsOn: false
*/

//THINK: as we want to offer an averagedCoordinate element (at Coordinate level)
//would it make sense the positionSource.position.coordinate rahther than PositionSource.position
//We would have to offer other properties (e.g. xxxAccuracy) separatly.

//Another option would be to offer one Coordinate element which can be swwitched from averageing to current.

    property alias position: positionSource.position
    property alias satsInUse: satInfoSource.satsInUse;
    property alias satsInView: satInfoSource.satsInView;

    property alias averagedCoordinate: averagedCoords

    //readonly not yet supported in 4.7.4
    //readonly property Position position: positionSource.position;
    //readonly property int satsInUse: satInfoSource.satsInUse;
    //readonly property int satsInView: satInfoSource.satsInView;

    onSatsInViewChanged: console.log("GPSBackEnd: onSatsInViewChanged: " + satsInView);
    onSatsInUseChanged: console.log("GPSBackEnd: onSatsInUseChanged: "  + satsInUse);

    function onGPS () {
        console.log("turning GPS on")
        positionSource.start();
        satInfoSource.startUpdates();
    }

    function offGPS () {
        console.log("turning GPS off")
        positionSource.stop();
        satInfoSource.stopUpdates();
    }


    //It could be argued that the timer belongs to the GUI, and the BackEnd should simply respond to on / off
    //but we want to restrict the Display element to visual stuff only, so for the moment we keep the
    //timer here in the BackEnd
    Timer{ id: timer;
        //interval: 60*1000;
        interval: 60*1000 * 10;
        //onTriggered: {state = "stateGpsOff"}
        onTriggered: {gpsSwitch.checked = false;}
    }



/*
//as we now expose position to MainPage, these functions are probably no longer required

    //called from MainPage.qml, then main.qml, used to transmit to SMSPage
    function getLati() {
        console.log("getLati Called");
        return "Lati: "   + positionSource.convertDDToDMS(positionSource.position.coordinate.latitude, "Lati");
    }

    //called from MainPage.qml, then main.qml, used to transmit to SMSPage
    function getLongi() {
        console.log("getLongi Called");
        return "Long: "   + positionSource.convertDDToDMS(positionSource.position.coordinate.longitude, "Longi");
    }

    //called from MainPage.qml, then main.qml, used to transmit to SMSPage
    function getAlti() {
        console.log("getAlti Called");
        return "Alt: "+ Math.round(positionSource.position.coordinate.altitude) + " m";
    }
*/
    function getFormatttedLatitude(latitude, dms) {
        return (dms) ? convertDDToDMS(latitude, 'Lati') : LJS.round(latitude, 4);
    }

    function getFormatttedLongitude(longitude, dms) {
        return (dms) ? convertDDToDMS(longitude, 'Longi') : LJS.round(longitude, 4);
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


    //gives access to info on number of Sats in view / use
    SatInfoSource {
        id: satInfoSource

        onSatellitesInUseChanged: {
            console.log("GPSBackEnd: SatellitesInUseChanged! " + satsInUse + "; " + thisGPS.satsInUse);
        }
        onSatellitesInViewChanged: {
            console.log("GPSBackEnd: SatellitesInViewChanged! " + satsInView + "; " + thisGPS.satsInView);
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

    function resetAverages() {
        averagedCoords.resetAverages();
    }

    Coordinate {
        id: averagedCoords
        latitude: -1
        longitude: -1
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

        //TODO: refactoring: should not this averaging stuff all be in an abstraction of PositionSource
        //this would offer both original and averaged coords + relevant changedSignals
        //the display should only care about displaying the provided coords
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



}

