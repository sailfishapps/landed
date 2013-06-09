import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import QtMobility.contacts 1.1

AUIPage {
    width: 480
    height: 854
    orientationLock: AUIPageOrientation.LockPortrait

    ContactModel {
        id: contactModel
        Component.onCompleted : {
            if (manager == "memory")
                contactModel.importContacts(Qt.resolvedUrl("contents/example.vcf"));
        }
    }

    ContactListView {
        id: contactListView
        anchors.fill: parent
        contacts: contactModel
//        onOpenContact: {
//                screen.showContact = true;
//                contactView.contact = contact;
//                contactView.update();
//                }
//        onNewContact: {
//                // create new instance of contactComponent
//                // using createQmlObject does not work here; phoneNumbers and emails list properties do not get initialized for some reason
//                var contact = contactComponent.createObject(contactModel);
//                screen.showContact = true;
//                contactView.contact = contact;
//                contactView.update();
//            }
    }

}
