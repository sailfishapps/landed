import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "settingsDB.js" as DB

AUIPage {id: pageSmsTarget
    tools: commonTools
    width: 480
    //height: 828
    height: 740
    orientationLock: AUIPageOrientation.LockPortrait

    property int toolbarHeight: 0
    //property int toolbarHeight: 110
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
            var rs = getCurrentGroup();
            var group_id = rs.rows.item(0).id;
            var name = rs.rows.item(0).name;
            templateButtons.headerText = name;
            templateButtons.populate(group_id);
        }
    }

    function getCurrentGroup() {
        var rs = DB.getActiveGroup();
        console.log ("No records found: " + rs.rows.length)
     return rs;
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
