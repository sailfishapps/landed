import QtQuick 2.0
//import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "../javascript/readDataModel.js" as DB

AUIPage {id: areaSelectionPage

    orientationLock: AUIPageOrientation.LockPortrait

    property int toolbarHeight: 0
    //property int toolbarHeight: 110
    property int itemHeight: 100;
    property int headerHeight: itemHeight;
    property int fontSize: 30
    property color labelColorActive

    signal backPageWithInfo(bool areaSet, string area_id)
    signal cancelled()

    Component.onCompleted: {
        console.log("areaSelectionPage.onCompleted")
    }

    onStatusChanged: {
        if (status == AUIPageStatus.Active)  {
            console.log ("Area Selection Page now active")
            areaRadioButtons.populate();
        }
    }

    function getCurrentArea() {
        var db = DB.DataModel();
        var rs = db.getPrimaryArea();
        console.log ("Num records found: " + rs.rows.length)
     return rs;
    }

    //A set of radio Buttons, one per area
    AreaRadioButtons {
        id: areaRadioButtons
        anchors.top: parent.top
        anchors.topMargin: 20 //sailfish
        fontSize: parent.fontSize
        itemHeight: parent.itemHeight
        headerHeight: parent.headerHeight
        headerText: "Areas";
        backgroundColor: parent.backgroundColor
        labelColorActive: parent.labelColorActive
        arrowVisible: false
        width: parent.width
        onDelegateClicked: {
            rumbleEffect.start();
//TODO: updating the DB is not on
            //DB.activateArea(area_id)
            backPageWithInfo(true, area_id);
        }
    }

    RumbleEffect {id: rumbleEffect}

    AUIButton {id: cancelButton
        anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; bottom: parent.bottom; bottomMargin: 25}
        height: 100;
        text: qsTr("Cancel");
        primaryColor: "#808080" //"grey"
        onClicked: {
            rumbleEffect.start();
            cancelled();
        }
    }

}

