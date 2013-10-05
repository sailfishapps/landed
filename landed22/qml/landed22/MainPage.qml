//import QtQuick 2.0
import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import QtMobility.location 1.2
//import QtMobility.sensors 1.2
import "settingsDB.js" as DB
import "landed.js" as LJS


AUIPageWithMenu {id: pageGPS
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

    function fakeGPSAquired() {
        //temporary function, used by testing to simulate gps aquired
        //for use when testing in building with no GPS signal
        privateVars.gpsAcquired = true;
    }

    QtObject {
        id: privateVars
        property bool gpsAcquired: false
    }

    signal nextPage(string pageType, string smsType, string template_id, string msg_status)

    onStatusChanged: {
        console.log ("onStatusChanged: " + status);
        console.log ("privateVars.gpsAcquired: " + privateVars.gpsAcquired);
        if (status == AUIPageStatus.Active) {
            if (privateVars.gpsAcquired) {
                if (groupSet) {
                    console.log("user has changed group, so we will use the selected group")
                    setActiveGroup(getCurrentCoordinate());
                }
                else {
                    console.log("use the nearest group")
                    setNearestGroup(getCurrentCoordinate());
                }
            }
            console.log ("MainPage: turning GPS on ...");
            //thisGPSApp.onGPS();
            thisGPSApp.activateGPS();
            compassApp.start();
        }
        else if (status == AUIPageStatus.Inactive) {
            console.log ("turning GPS off ...")
            thisGPSApp.offGPS();
            compassApp.stop();
        }
    }

    Rectangle {
        id: landedHeader
        anchors {left: parent.left; leftMargin: 5; right: parent.right; rightMargin: 5; top: parent.top; topMargin: 5}
        height: 50
        color: (theme.inverted) ? "#333333" : "#006600"
        radius: 10
        Text {
            text: "Landed!!!"
            color: (theme.inverted) ? "white" : "white"
            font.pointSize: pageGPS.fontSize
            font.weight: Font.DemiBold
            anchors.leftMargin: 10
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////
    //GPS related components and functions
    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////

    function getCurrentCoordinate() {
        return thisGPSApp.getCurrentCoordinate();
    }

    function getLati() {
        //return "lati: 123"
        return thisGPSApp.getLati()
    }

    function getLongi() {
        //return "longi: 456"
        return thisGPSApp.getLongi()
    }

    function getAlti() {
        return thisGPSApp.getAlti();
    }


    GPSApp{id: thisGPSApp
        //anchors.top: parent.top
        anchors.top: landedHeader.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.right: parent.right
        //color: parent.backgroundColor
        fontSize: parent.fontSize
        textColorActive: pageGPS.textColorActive
        textColorInactive: pageGPS.textColorInactive
        labelColorActive: pageGPS.labelColorActive
        labelColorInactive: pageGPS.labelColorInactive
        onPositionChanged: {
            console.log("PositionChanged Signal Received! outer");
            privateVars.gpsAcquired = true;
        }
    }

    CompassApp {
        id: compassApp
        anchors.top: thisGPSApp.bottom
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        fontSize: parent.fontSize
        textColorActive: pageGPS.textColorActive
        textColorInactive: pageGPS.textColorInactive
        labelColorActive: pageGPS.labelColorActive
        labelColorInactive: pageGPS.labelColorInactive
    }

    RumbleEffect {id: rumbleEffect}

    Coordinate {
        id:tempLocation
    }

    Coordinate {
        id: groupLocation
    }


    function setActiveGroup(currentLocation) {
        var rs = DB.getActiveGroup();
        console.log ("No records found: " + rs.rows.length)
        var distance = formatDistance(getDistance(rs.rows.item(0), currentLocation));
        templateButtons.set(rs.rows.item(0), distance);
    }

    function setNearestGroup(currentLocation) {
        console.log ("current location latitude: " + currentLocation.latitude + " longitude: " + currentLocation.longitude)
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

    function getDistance(item, currentLocation) {
        tempLocation.latitude = item.latitude;
        tempLocation.longitude = item.longitude;
        return currentLocation.distanceTo(tempLocation);
    }

    function formatDistance(distance) {
        return LJS.round((distance / 1000), 2) + " km";
    }

//TODO: the notAcquiredText should be better positioned (is too high)
//TODO: should this not belong to the template buttons?
// I suppose yes if the buttons become a separate control again.

    Text {
        id: notAcquiredText;
        enabled: !templateButtons.enabled
        visible: !templateButtons.enabled
        anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; top: compassApp.bottom; topMargin: 100}
        font.pointSize: parent.fontSize
        font.italic: true
        horizontalAlignment: Text.AlignHCenter
        color: pageGPS.textColorInactive
        text: "GPS not yet acquired . . ."
    }

//TODO: I am not happy that we have 2 use 2 ways of triggering activation of buttons
// 1) templateButtons enabled bound to privateVars.gpsAcquired
// 2) page onStatusChanged event (for when we return to the page from another)

    //A set of Buttons, one per template
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
        //anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; top: compassText.bottom; topMargin: 15}
        anchors {left: parent.left; right: parent.right; top: compassApp.bottom; topMargin: 15}
        //onPopulated:
        onEnabledChanged: {
            console.log ("TemplateButtons: onEnabledChanged: " + enabled);
            if (enabled) {
                setNearestGroup(getCurrentCoordinate());
                rumbleEffect.start();
            }
        }
        onDelegateClicked: {
            rumbleEffect.start();
            console.log("Default button chosen, for template_id: " + template_id);
            pageGPS.nextPage("SMS", "Default", template_id, msg_status);
        }
        onHeaderClicked: {
            clear();
            pageGPS.nextPage("Group", null, null, null);
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
    }


    menuitems: [
        AUIMenuAction {
            text: qsTr("Fake GPS Aquired");
            onClicked: {
                pageGPS.fakeGPSAquired();
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
