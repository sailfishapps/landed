import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

//gives access to contacts stored by Landed / LandedSettings

AUIPage {id: favouriteContactsPage

    property string template_id

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
    property color labelColorActive


    signal contactSelected(string phoneNumber, string name)
    signal cancelled()

    Component.onCompleted: {
        console.log("favouriteContactsPage.onCompleted")
    }

    function populate(template_id) {
        contactRadioButtons.populate(template_id);
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
            favouriteContactsPage.contactSelected(contactPhone, contactName)
        }

    }

    RumbleEffect {id: rumbleEffect}

    //Cancel rather than back, as selecting a contact takes the user back with the selected contact
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
