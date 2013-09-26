import QtQuick 1.1
import QtMobility.location 1.2
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "settingsDB.js" as DB
import "landed.js" as LJS

AUIPage {id: pageSmsTarget
    tools: commonTools
    width: 480
    //height: 828
    height: 740
    orientationLock: AUIPageOrientation.LockPortrait

    property int toolbarHeight: 0
    //property int toolbarHeight: 110
    //TDDO possible bug, object of type Coordinate not accepted as page property (or at least nothing can be passed to it)
    //property Coordinate currentLocaton
    property real currentLatitude
    property real currentLongitude
    backgroundColor: "lightgrey"
    property int itemHeight: 100;
    property int headerHeight: itemHeight;
    property int fontSize: 30

    signal nextPage(string pageType, string smsType, string template_id, string msg_status)
    signal cancelled()

    Component.onCompleted: {
        console.log("pageSmsTarget.onCompleted")
    }

    onStatusChanged: {
        if (status == AUIPageStatus.Active)  {

            console.log ("SMS Selection Page now active")
            var nearestGroup = getNearestGroup();
            groupLocation.latitude = nearestGroup.latitude;
            groupLocation.longitude = nearestGroup.longitude;
            var distance =  LJS.round((currentLocation.distanceTo(groupLocation) / 1000), 2) + " km";
            templateButtons.headerText = nearestGroup.name + ": " + nearestGroup.latitude + " " + nearestGroup.longitude + "; " + distance;
            templateButtons.populate(nearestGroup.id);

/*
            var rs = getCurrentGroup();
            var group_id = rs.rows.item(0).id;
            var name = rs.rows.item(0).name;
            var lati = rs.rows.item(0).latitude;
            var longi = rs.rows.item(0).longitude;
            groupLocation.latitude = lati;
            groupLocation.longitude = longi;
            var distance =  LJS.round((currentLocation.distanceTo(groupLocation) / 1000), 2) + " km";
            templateButtons.headerText = name + ": " + lati + " " + longi + "; " + distance;
            templateButtons.populate(group_id);
*/
        }
    }

    function getCurrentGroup() {
        var rs = DB.getActiveGroup();
        console.log ("No records found: " + rs.rows.length)
     return rs;
    }

    function getNearestGroup() {
        var rs = DB.getTemplateGroups();
        var distance;
        var nearestGroup = -1;
        var nearestGroupDistance = -1
        for(var i = 0; i < rs.rows.length; i++) {
            tempLocation.latitude = rs.rows.item(i).latitude;
            tempLocation.longitude = rs.rows.item(i).longitude;
            distance = currentLocation.distanceTo(tempLocation);
            //distance = currentLocation.distanceTo({latitude: rs.rows.item(0).latitude, longitude: rs.rows.item(0).longitude});
            console.log ("distance: " + distance + " to " + rs.rows.item(i).name);
            if ( (distance < nearestGroupDistance) || (i == 0) ) {
                nearestGroupDistance = distance;
                nearestGroup = rs.rows.item(i);
            }
        }
        console.log ("nearest group is: " + nearestGroup.name + " " + nearestGroup.latitude);
        return nearestGroup;
    }


    Coordinate {
        id:tempLocation
    }

    Coordinate {
        id: currentLocation
        latitude: pageSmsTarget.currentLatitude
        longitude: pageSmsTarget.currentLongitude
    }

    Coordinate {
        id: groupLocation
    }


    //A set of Buttons, one per template (Default SMS), plus one for Custom SMS
    TemplateButtons {
        id: templateButtons
        fontSize: parent.fontSize
        itemHeight: parent.itemHeight
        headerHeight: parent.headerHeight
        //Commented out for Sailfish
        //backgroundColor: parent.backgroundColor
        arrowVisible: true
        width: parent.width
        //onPopulated:
        onDelegateClicked: {
            rumbleEffect.start();
            if (template_id == -999) {
                console.log("Custom button chosen, for template_id: " + template_id);
                //nextPage("SMS", "Custom", template_id, msg_status);
                nextPage("SMS", "Default", template_id, msg_status)
            }
            else {
                console.log("Default button chosen, for template_id: " + template_id);
                nextPage("SMS", "Default", template_id, msg_status);
            }
        }
        onHeaderClicked: {
            clear();
            nextPage("Group", null, null, null);
        }

    }

    RumbleEffect {id: rumbleEffect}

    AUIButton {id: cancelButton
        anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; bottom: parent.bottom; bottomMargin: 25}
        height: 100;
        text: qsTr("Cancel");
        primaryColor: "#808080" // "grey"
        onClicked: {
            rumbleEffect.start();
            console.log ("platformStyle :" + platformStyle);
            cancelled();
        }
    }

}
