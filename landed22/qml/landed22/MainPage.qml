import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import QtMobility.sensors 1.2
import QtMobility.feedback 1.1


AUIPageWithMenu {id: pageGPS
    //tools: commonTools
    width: parent.width
    //width: 480
//    height: 828 -toolbarHeight
    orientationLock: AUIPageOrientation.LockPortrait

    //property int toolbarHeight: 0
    property int toolbarHeight: 110
    //backgroundColor: "slategrey"
    //backgroundColor: "grey"
    backgroundColor: "lightgrey"
    property int fontSize: 30

    function fakeGPSAquired() {
        //temporary function, used by testing to simulate gps aquired
        //for use when testing in building with no GPS signal
        privateVars.gpsAcquired = true;
    }

    QtObject {
        id: privateVars
        property bool gpsAcquired: false
    }

    signal nextPage()

    onStatusChanged: {
        if (status == AUIPageStatus.Active) {
            console.log ("turning GPS on ...")
            thisGPSApp.onGPS();
            thisCompass.start();
            console.log("compass reading: " + thisCompass.reading)
        }
        else if (status == AUIPageStatus.Inactive) {
            console.log ("turning GPS off ...")
            thisGPSApp.offGPS();
            thisCompass.stop();
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
        anchors.top: parent.top
        anchors.topMargin: 15
        //anchors.topMargin:150
        anchors.left: parent.left
        anchors.right: parent.right
        height: 420
        //color: parent.backgroundColor
        fontSize: parent.fontSize
        textColor: "blue"
        onPositionChanged: {
            privateVars.gpsAcquired = true;
        }
    }

    Compass {
        id: thisCompass
        onReadingChanged: {
            compassText.text = "Bearing: " + reading.azimuth;
            //console.log("Compass Reading has changed")
        }
    }

    Text {
        id: compassText
        anchors.top: thisGPSApp.bottom
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        height: 120
        font.pointSize: pageGPS.fontSize
        color: "lightGrey"
        text: "No compass reading yet ..."

    }


/*
    //replaced by RumbleEffect
    HapticsEffect {id: rumbleEffect
        attackIntensity: 0.0
        attackTime: 250
        intensity: 1.0
        duration: 100
        fadeTime: 250
        fadeIntensity: 0.0
    }
*/


    RumbleEffect {id: rumbleEffect}


    AUIButton {id: smsButton
        anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; top: compassText.bottom; topMargin: 15}
        height: 100;
        //width: parent.width;
        text: (privateVars.gpsAcquired) ? qsTr("Create SMS") : qsTr("Acquiring GPS...");
        //primaryColor: "#808080" // "grey"
        primaryColor: "#008000" //"green"
        enabled: privateVars.gpsAcquired
        onClicked: {
            rumbleEffect.start();
            nextPage()
        }
        onEnabledChanged: rumbleEffect.start();
    }    

    menuitems: [
        AUIMenuAction {
            text: qsTr("Fake GPS Aquired");
            onClicked: {
                pageGPS.fakeGPSAquired();
            }
        }
        ,
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
        }
    ]

}
