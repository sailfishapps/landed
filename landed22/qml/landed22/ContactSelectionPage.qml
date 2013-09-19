import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "settingsDB.js" as DB

AUIPage {id: pageContactSelection

    property string template_id

    tools: commonTools
    width: 480
    //height: 828
    height: 740
    orientationLock: AUIPageOrientation.LockPortrait

    property int toolbarHeight: 0
    //property int toolbarHeight: 110
    property color backgroundColor: "black"
    property int itemHeight: 100;
    property int headerHeight: itemHeight;
    property int fontSize: 30

    signal backPage(string contactName, string contactPhone)
    signal cancelled()

    Component.onCompleted: {
        console.log("pageContactSelection.onCompleted")
    }

    onStatusChanged: {
        if (status == AUIPageStatus.Active)  {
            console.log ("Contact Selection Page now active with template_id: " + template_id)
            contactRadioButtons.populate(template_id);
        }
    }

    //A set of radio Buttons, one per contact for this template
    ContactRadioButtons {
        id: contactRadioButtons
        fontSize: parent.fontSize
        itemHeight: parent.itemHeight
        headerHeight: parent.headerHeight
        headerText: "Contacts";
        backgroundColor: parent.backgroundColor
        arrowVisible: false
        width: parent.width
        onDelegateClicked: {
            rumbleEffect.start();
            console.log("Contact clicked: " + contact_id + ", contactName: " + contactName + ", contactPhone: " + contactPhone);
            backPage(contactName, contactPhone);
        }

    }

    RumbleEffect {id: rumbleEffect}

    AUIButton {id: cancelButton
        anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; bottom: parent.bottom; bottomMargin: 25}
        height: 100;
        text: qsTr("Cancel");
        //platformStyle: greenButton;
        onClicked: {
            rumbleEffect.start();
            cancelled();
        }
    }

}
