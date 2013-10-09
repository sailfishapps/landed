import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

AUIPage {id: pageContactSelection

    property string template_id

    width: 480
    height: 828
    //height: 740
    orientationLock: AUIPageOrientation.LockPortrait

    property int toolbarHeight: 0
    //property int toolbarHeight: 110
    backgroundColor: "lightgrey"
    property int itemHeight: 100;
    property int headerHeight: itemHeight;
    property int fontSize: 30
    property color labelColorActive

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
        labelColorActive: parent.labelColorActive
        arrowVisible: false
        width: parent.width
        onDelegateClicked: {
            rumbleEffect.start();
            console.log("Contact clicked: " + contact_id + ", contactName: " + contactName + ", contactPhone: " + contactPhone);
            backPage(contactName, contactPhone);
        }

    }

    DialSheet2 {id: dialDialog2
        //visualParent: pageContactSelection;
        onNumberEntered: {
            //phoneNrField.text = phoneNumber;
            backPage("Custom Number", phoneNumber);
        }
        onContactSelected: {
            backPage(name, phoneNumber);
        }
    }

    RumbleEffect {id: rumbleEffect}

    //A button to open the dialer / Contacts
    //While this may not be the "native" way of doing this (toolbar or similar)
    //this app is designed to be easy and obvious.

    AUIButton {id: dialerButton
        anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; bottom: cancelButton.top; bottomMargin: 25}
        height: 100;
        text: qsTr("Open Dialer");
        primaryColor: "#008000" //"green"
        onClicked: {
            rumbleEffect.start();
            dialDialog2.open();
        }
    }

    //Cancel rather than back, as selecting a contact takes the user back with the selected contact
    AUIButton {id: cancelButton
        anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; bottom: parent.bottom; bottomMargin: 25}
        height: 100;
        text: qsTr("Cancel");
        //platformStyle: greenButton;
        primaryColor: "#808080" //"grey"
        onClicked: {
            rumbleEffect.start();
            cancelled();
        }
    }

}
