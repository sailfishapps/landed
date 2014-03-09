import QtQuick 2.0
//import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

//gives access to the contacts from the phone (as opposed to contacts stored by Landed / LandedSettings)

//The content of this page is lazy-loaded when the page becomes visible (as oppossed to when the app starts).
//http://harmattan-dev.nokia.com/docs/library/html/qt-components/qt-components-meego-pagestack.html#advanced-usage
//dynamic loading of page content as loading contacts takes time
//and sometimes stalls during load with error "The task queue's background thread stalled"


Item {
    id: contactsTab

    anchors.fill: parent

    signal contactSelected(string phoneNumber, string name)

    property Item containerObject;

    QtObject {
        id: privateVars
        property bool created: false
    }

    onVisibleChanged: {
        if (visible && !privateVars.created) {
            // create component
            console.log("Page content created.");
            var object = componentDynamic.createObject(contactsTab);
            privateVars.created = true;
            containerObject = object;
            console.log("contactsTab.height: " + contactsTab.height)
        } else {
            //why destroy: if we have gone to the bother of loading this, then we should keep this stuff
            //we don't need to take the loss of time to load this more than once.
            // destroy component
            //console.log("Page content destroyed.");
            //containerObject.destroy();
        }
    }

    // Page content inside Component, this is created dynamically when page is visible
    Component {
        id: componentDynamic
        PhoneContactsTabContent {
            anchors.fill: contactsTab
            id: content
            onContactSelected: contactsTab.contactSelected(number, name);
        }
    }

}


