import QtQuick 2.0
//import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import org.flyingsheep.abstractui.backend 1.0 //for Coordinate
//import QtMobility.location 1.2
import "../javascript/settingsDB.js" as DB
import "../javascript/landed.js" as LJS
import "../backend"


// we should move this to gui, but still has quite a lot of functionality,
// especially in the TemplateButtons implementation
// consider also renaming TemplateButtons to SMSSelectionButtons, as use case has changed a little.
// Can we factor out notAcquiredText and templateButtons into a wrapper component, which handles which of the 2
// are displayed

AUIPageWithMenu {id: mainPage
    //tools: commonTools
    width: parent.width
    //width: 480
//    height: 828 -toolbarHeight
    orientationLock: AUIPageOrientation.LockPortrait

    //property int toolbarHeight: 0
    property int toolbarHeight: 110
    property int itemHeight: 100;
    property int headerHeight: itemHeight - 40;

    property color textColorActive
    property color textColorInactive
    property color labelColorActive
    property color labelColorInactive
    property int fontSize
    property bool groupSet: false;

    signal nextPage(string pageType, string smsType, string template_id, string msg_status)

    QtObject {
        id: privateVars
        property bool gpsAcquired: false
    }

    onStatusChanged: {
        console.log ("onStatusChanged: " + status);
        console.log ("privateVars.gpsAcquired: " + privateVars.gpsAcquired);
        if (status == AUIPageStatus.Active) {
            if (privateVars.gpsAcquired) {
                if (groupSet) {
                    console.log("user has changed group, so we will use the selected group")
                    templateButtons.setActiveGroup(gpsBackEnd.location);
                }
                else {
                    console.log("use the nearest group")
                    templateButtons.setNearestGroup(gpsBackEnd.location);
                }
            }
            console.log ("MainPage: turning GPS on ...");
            gpsBackEnd.onGPS();
            gpsBackEnd.onCompass();
        }
        else if (status == AUIPageStatus.Inactive) {
            //console.log ("turning GPS off ...")
            gpsBackEnd.offGPS();
            gpsBackEnd.offCompass();
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////
    //GPS BackEnd related wrapper functions and Components
    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////

    function fakeGPSAquired() {
        //temporary function, used by testing to simulate gps aquired
        //for use when testing in building with no GPS signal
        privateVars.gpsAcquired = true;
    }

    function getLati() {
        //called from main.qml to pass lati to SMSPage
        return gpsBackEnd.getFormatttedLatitude(gpsBackEnd.location.coordinate.latitude, gpsDisplay.coordFormatDMS)
    }

    function getLongi() {
        //called from main.qml to pass lati to SMSPage
        return gpsBackEnd.getFormatttedLongitude(gpsBackEnd.location.coordinate.longitude, gpsDisplay.coordFormatDMS)
    }

    function getAlti() {
        //called from main.qml to pass lati to SMSPage
        return gpsBackEnd.location.coordinate.altitude;
    }

    GPSBackEnd {
        id: gpsBackEnd
        onSatsInUseChanged: {
            console.log("MainPage: onSatsInUseChanged: " + satsInUse);
        }
        onSatsInViewChanged: {
            console.log("MainPage: onSatsInViewChanged: " + satsInView);
            console.log("averagedCoordinate.latitude: " + location.coordinate.latitude)
        }

        onLocationChanged: {
            console.log("Averaged Location Changed");
            privateVars.gpsAcquired = true;
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////
    //GUI Elements
    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////

    //GUI: Header Bar at the top of the page
    Rectangle {
        id: landedHeader
        anchors {left: parent.left; leftMargin: 5; right: parent.right; rightMargin: 5; top: parent.top; topMargin: 5}
        height: 50
        //color: (theme.inverted) ? "#333333" : "#006600" //harmattan
        color: "#006600"
        radius: 10
        Text {
            text: "Landed!!! v25"
            //color: (theme.inverted) ? "white" : "white"
            color: "white"
            font.pointSize: mainPage.fontSize
            font.weight: Font.DemiBold
            anchors.leftMargin: 10
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
        }
    }

    //GPSDisplay binds many properties to GPSBackEnd equivalents.
    //Communication from GPSDisplay to GPSBackEnd is via requestXXX signals,
    //the handlers of which then call GPSBackEnd methods.

    //GUI: Displays GPS Data
    GPSDisplay{id: gpsDisplay
        //anchors.top: parent.top
        anchors.top: landedHeader.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.right: parent.right
        //color: parent.backgroundColor
        fontSize: parent.fontSize
        textColorActive: mainPage.textColorActive
        textColorInactive: mainPage.textColorInactive
        labelColorActive: mainPage.labelColorActive
        labelColorInactive: mainPage.labelColorInactive

        //bind properties to GPSBackEnd equivalents
        gpsOn: gpsBackEnd.gpsOn;
        compassOn: gpsBackEnd.compassOn;
        coordAveraging: gpsBackEnd.locationAveraging;
        latitude: gpsBackEnd.getFormatttedLatitude(gpsBackEnd.location.coordinate.latitude, coordFormatDMS)
        longitude: gpsBackEnd.getFormatttedLongitude(gpsBackEnd.location.coordinate.longitude, coordFormatDMS)
        altitude: gpsBackEnd.location.coordinate.altitude;
        speedValid: gpsBackEnd.speedValid;
        speed: gpsBackEnd.speed;
        horizontalAccuracyValid: gpsBackEnd.horizontalAccuracyValid;
        horizontalAccuracy: gpsBackEnd.horizontalAccuracy;
        verticalAccuracyValid: gpsBackEnd.verticalAccuracyValid;
        verticalAccuracy: gpsBackEnd.verticalAccuracy;
        satsInView: gpsBackEnd.satsInView;
        satsInUse: gpsBackEnd.satsInUse;
        bearing: gpsBackEnd.bearing;
        onRequestGPSActive: (active) ? gpsBackEnd.onGPS() : gpsBackEnd.offGPS();
        onRequestCoordAveraging: {
            console.log ("MainPage.onRequestCoordAveraging; averaging is: " +  averaging)
            gpsBackEnd.coordAveraging = averaging;
        }
        onRequestCompassActive: (active) ? gpsBackEnd.onCompass() : gpsBackEnd.offCompass();
    }

    //GUI: Text displayed in place of templateButtons when GPS not yet acquired
    Text {
        id: notAcquiredText;
        enabled: !templateButtons.enabled
        visible: !templateButtons.enabled
        anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; top: gpsDisplay.bottom; topMargin: 100}
        //anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; top: compassApp.bottom; topMargin: 100}
        font.pointSize: parent.fontSize
        font.italic: true
        horizontalAlignment: Text.AlignHCenter
        color: mainPage.textColorInactive
        text: "GPS not yet acquired . . ."
    }

//TODO: I am not happy that we have 2 use 2 ways of triggering activation of buttons
// 1) templateButtons enabled bound to privateVars.gpsAcquired
// 2) page onStatusChanged event (for when we return to the page from another)

    //GUI: buttons for creating SMS, displayed when GPS is acquired
    TemplateButtons {
        id: templateButtons
        enabled: privateVars.gpsAcquired
        visible: privateVars.gpsAcquired
        fontSize: parent.fontSize
        itemHeight: parent.itemHeight
        headerHeight: parent.headerHeight
        //Commented out for Sailfish
        //backgroundColor: parent.backgroundColor
        arrowVisible: true
        textColor: parent.labelColorActive
        width: parent.width
        anchors {left: parent.left; right: parent.right; top: gpsDisplay.bottom; topMargin: 15}
        //anchors {left: parent.left; right: parent.right; top: compassApp.bottom; topMargin: 15}
        //onPopulated:
        onEnabledChanged: {
            console.log ("TemplateButtons: onEnabledChanged: " + enabled);
            if (enabled) {
                setNearestGroup(gpsBackEnd.location);
                rumbleEffect.start();
            }
        }
        onDelegateClicked: {
            rumbleEffect.start();
            console.log("Default button chosen, for template_id: " + template_id);
            mainPage.nextPage("SMS", "Default", template_id, msg_status);
        }
        onHeaderClicked: {
            clear();
            mainPage.nextPage("Group", null, null, null);
        }

        function setHeaderText(group) {
            return group.name;
        }

        function setHeaderSubText(group, distance) {
            return "Lat: " + group.latitude + "; Lng: " + group.longitude + "; Dst: " + distance;
        }

        function set (group, distance) {
            templateButtons.headerText = setHeaderText(group);
            templateButtons.headerSubText = setHeaderSubText(group, distance);
            templateButtons.populate(group.id);
        }

        AUILocation {
            //used by function getDistance
            id: tempLocation
        }

        function getDistance(item, currentLocation) {
            tempLocation.coordinate.latitude = item.latitude;
            tempLocation.coordinate.longitude = item.longitude;
            return currentLocation.coordinate.distanceTo(tempLocation.coordinate);
        }

        function setActiveGroup(currentLocation) {
            var rs = DB.getActiveGroup();
            console.log ("Records found: " + rs.rows.length)
            var distance = formatDistance(getDistance(rs.rows.item(0), currentLocation));
            templateButtons.set(rs.rows.item(0), distance);
        }

        function setNearestGroup(currentLocation) {
            console.log ("current location latitude: " + currentLocation.coordinate.latitude + " longitude: " + currentLocation.coordinate.longitude)
            var rs = DB.getTemplateGroups();
            var distance;
            var nearestGroup = -1;
            var nearestGroupDistance = -1
            for(var i = 0; i < rs.rows.length; i++) {
                distance = getDistance(rs.rows.item(i), currentLocation);
                console.log ("distance: " + distance + " to " + rs.rows.item(i).name);
                if ( (distance < nearestGroupDistance) || (i == 0) ) {
                    nearestGroupDistance = distance;
                    nearestGroup = rs.rows.item(i);
                }
            }
            console.log ("nearest group is: " + nearestGroup.name + " " + nearestGroup.latitude);
            distance = formatDistance(nearestGroupDistance);
            templateButtons.set(nearestGroup, distance);
        }

        function formatDistance(distance) {
            return LJS.round((distance / 1000), 2) + " km";
        }
        RumbleEffect {id: rumbleEffect}
    }



    //GUI: Menu for various settings and test functions
    menuitems: [
        AUIMenuAction {
            text: qsTr("Fake GPS Aquired");
            onClicked: {
                mainPage.fakeGPSAquired();
            }
        },
        AUIMenuAction {
            text: (appWindow.fontSize >= appWindow.largeFonts) ? qsTr("Small Fonts" ) : qsTr("Large Fonts");
            onClicked: (appWindow.fontSize == appWindow.largeFonts) ? appWindow.fontSize = appWindow.smallFonts : appWindow.fontSize = appWindow.largeFonts;
        },
        AUIMenuAction {
            text: qsTr("Increase fontSize");
            onClicked: {
               appWindow.fontSize++;
               console.log ("fontSize is now: " + appWindow.fontSize + "; Operating System is: " + OSId)
            }
        },
        AUIMenuAction {
            text: qsTr("Decrease fontSize");
            onClicked: {
               appWindow.fontSize--;
               console.log ("fontSize is now: " + appWindow.fontSize + "; Operating System is: " + OSId)
            }
        },
        AUIMenuAction {
            text: qsTr("Toggle Theme");
            onClicked: {
               theme.inverted = !theme.inverted;
            }
        }
    ]

}
