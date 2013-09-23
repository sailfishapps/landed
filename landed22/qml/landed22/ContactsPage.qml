import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import QtMobility.contacts 1.1

AUIPage {
    ListView {
        id:  contactList
        anchors.fill: parent
        model: ContactModel {}
        delegate: Text {
            font.pointSize: 20;
            text: "Name: " + model.contact.name.firstName + " " + model.contact.name.lastName;
                  //+ " Number: " + model.contact.phoneNumber.number
        }

    }
}
