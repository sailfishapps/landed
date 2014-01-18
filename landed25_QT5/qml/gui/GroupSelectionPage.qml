import QtQuick 2.0
//import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "../javascript/settingsDB.js" as DB

AUIPage {id: groupSelectionPage

    width: 480
    height: 828
    //height: 740
    orientationLock: AUIPageOrientation.LockPortrait

    property int toolbarHeight: 0
    //property int toolbarHeight: 110
    property int itemHeight: 100;
    property int headerHeight: itemHeight;
    property int fontSize: 30
    property color labelColorActive

    signal backPageWithInfo(bool groupSet)
    signal cancelled()

    Component.onCompleted: {
        console.log("groupSelectionPage.onCompleted")
    }

    onStatusChanged: {
        if (status == AUIPageStatus.Active)  {
            console.log ("Group Selection Page now active")
            //groupRadioButtons.headerText = name;
            groupRadioButtons.populate();
        }
    }

    function getCurrentGroup() {
        var rs = DB.getActiveGroup();
        console.log ("Num records found: " + rs.rows.length)
     return rs;
    }

    //A set of radio Buttons, one per group
    GroupRadioButtons {
        id: groupRadioButtons
        //anchors: {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10;}
        fontSize: parent.fontSize
        itemHeight: parent.itemHeight
        headerHeight: parent.headerHeight
        headerText: "Groups";
        backgroundColor: parent.backgroundColor
        labelColorActive: parent.labelColorActive
        arrowVisible: false
        width: parent.width
        onDelegateClicked: {
            rumbleEffect.start();
            DB.activateGroup(group_id)
            backPageWithInfo(true);
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

