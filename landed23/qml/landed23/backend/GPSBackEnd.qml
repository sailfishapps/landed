//import QtQuick 2.0
import QtQuick 1.1
import org.flyingsheep.abstractui.backend 1.0
//import QtMobility.location 1.2 //for GPS
//import QtMobility.sensors 1.2 //for compass
import SatInfoSource 1.0 //for info about satelittes (in view, in use)
import "../landed.js" as LJS

Item {id: thisGPSBackEnd

//THINK: as we want to offer an averagedCoordinate element (at Coordinate level)
//would it make sense the positionSource.position.coordinate rahther than PositionSource.position
//We would have to offer other properties (e.g. xxxAccuracy) separatly.

//Another option would be to offer one Coordinate element which can be swwitched from averageing to current.

//At the moment this is not linked in any way to MainPage / GPSDisplay
//so setting on GPSDisplay has no effect.
    property bool coordAveraging: false

    property alias gpsOn: positionSource.active

    //property alias position: positionSource.position;
    property alias speed: position.speed;
    property alias speedValid: position.speedValid;
    property alias horizontalAccuracy: position.horizontalAccuracy;
    property alias horizontalAccuracyValid: position.horizontalAccuracyValid;
    property alias verticalAccuracy: position.verticalAccuracy;
    property alias verticalAccuracyValid: position.verticalAccuracyValid;
    property alias coordinate: averagedCoords;
    property alias satsInUse: satInfoSource.satsInUse;
    property alias satsInView: satInfoSource.satsInView;

    //property alias compass: thisCompass

    property alias compassOn: thisCompass.active
    property alias bearing: thisCompass.bearing

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
        timer.stop();
    }
    function onCompass () {
        thisCompass.start();
    }
    function offCompass () {
        thisCompass.stop();
    }

    //It could be argued that the timer belongs to the GUI, and the BackEnd should simply respond to on / off
    //but we want to restrict the Display element to visual stuff only, so for the moment we keep the
    //timer here in the BackEnd
    Timer{ id: timer;
        interval: 60*1000;
        onTriggered: {offGPS()}
    }


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
            console.log("GPSBackEnd: SatellitesInUseChanged! " + satsInUse + "; " + thisGPSBackEnd.satsInUse);
        }
        onSatellitesInViewChanged: {
            console.log("GPSBackEnd: SatellitesInViewChanged! " + satsInView + "; " + thisGPSBackEnd.satsInView);
        }
    }

    //Bit of a nasty hack here
    //As a property alias can only be to a property, or element.property
    //e.g. not element.element.property
    //we can't directly alias positionSource.position.horizontalAccuracy;
    //But by creating an Item with properties deep bound, I can then alias the properties of the item!
    //Of course this is only readonly, but in this case that is all we want
    Item { id: position
        property real speed: positionSource.position.speed;
        property bool speedValid: positionSource.position.speedValid;
        property real horizontalAccuracy: positionSource.position.horizontalAccuracy;
        property bool horizontalAccuracyValid: positionSource.position.horizontalAccuracyValid;
        property real verticalAccuracy: positionSource.position.verticalAccuracy;
        property bool verticalAccuracyValid: positionSource.position.verticalAccuracyValid;
    }

    //gives access to GPS info
    AUIPositionSource {id: positionSource
        updateInterval: 1000
        active: false
        // nmeaSource: "nmealog.txt"
        onPositionChanged: {
            console.log("PositionChanged Signal Received! inner");
            //If the timer is running, subsequent calls to start() have no effect
            timer.start();
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

    Connections {
         target: positionSource.position.coordinate
         onLatitudeChanged: {
             console.log ("signal from positionSource.position.coordinate snatched out of the ether ...");
             if (coordAveraging) {
                averagedCoords.averageCoords(positionSource.position.coordinate);
             }
             else {
                averagedCoords.latitude = positionSource.position.coordinate.latitude;
             }
         }
         onLongitudeChanged: {
             console.log ("signal from positionSource.position.coordinate snatched out of the ether ...");
             if (coordAveraging) {
                averagedCoords.averageCoords(positionSource.position.coordinate);
             }
             else {
                averagedCoords.longitude = positionSource.position.coordinate.longitude;
             }
         }
    }

    onCoordAveragingChanged: {
        if (!coordAveraging) {
            resetAverages();
            averagedCoords.latitude = positionSource.position.coordinate.latitude;
            averagedCoords.longitude = positionSource.position.coordinate.longitude;
        }
    }

    AUICoordinate {
        id: averagedCoords
        latitude: NaN
        longitude: NaN
        altitude: positionSource.position.coordinate.altitude;
        property real summedLatitude: 0;
        property real summedLongitude: 0;
        property int hits: 0;

        onLatitudeChanged:  if (validCoord()) coordinateChanged();
        onLongitudeChanged: if (validCoord()) coordinateChanged();
        onAltitudeChanged:  if (validCoord()) coordinateChanged();

        function validCoord() {
            //check that latitude and longitude are valid numbers
            //i.e we have acquired a plausible position
            return (!isNaN(latitude) && !isNaN(longitude))
        }

        function resetAverages() {
            latitude = 0;
            longitude = 0;
            summedLatitude = 0;
            summedLongitude = 0;
            hits = 0;
        }

        function averageCoords(coord) {
            console.log("averageCoords called: " +  thisGPSBackEnd.coordAveraging);
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
        }
    }

    AUICompass {
        id: thisCompass
        property int bearing: -1

        onReadingChanged: {
            bearing = reading.azimuth;
        }
    }
}

