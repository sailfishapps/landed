import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "../backend"

Rectangle {
    id: pageContent
    anchors.fill:  parent
    color: "white"

    property int listPointSize: (simulator) ? 9 : 20

    signal contactSelected(string number, string name)

    Text {
        text: "Contacts loading ..."
        visible: contactList.count <= 0
        font.pointSize: 30
        anchors.centerIn : parent
    }

    PhoneContactsBackEnd {
        id: phoneContactBackEnd
    }

    SearchBox {
        id: searchBox
        font.pointSize: 24
        onRequestSearch: {
            console.log("searchRequested: " + searchKey);
            phoneContactBackEnd.searchKey = searchKey;
        }
    }

    AlphabetSlider {
        id: alphabetSlider
        anchors.top: searchBox.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        z: contactList.z + 1;
        alphabetModel: phoneContactBackEnd.alphabetModel
        onInitialChanged: {
            console.log("initialChanged: " + initial + ", " + index);
            contactList.positionViewAtIndex(index, ListView.Beginning);
        }
    }

    //our main list view + associate items, lists contacts on the phone

    ListView {
        id:  contactList
        anchors.top: searchBox.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: alphabetSlider.barWidth
        anchors.bottom: parent.bottom
        model: phoneContactBackEnd.phoneContactsModel
        delegate:contactDelegate
        highlight: highlightBar
        highlightFollowsCurrentItem: true
        //section.property: model.contact.displayLabel
        //section.property: model.contacts.displayLabel.label
        section.property: name.firstName
        section.criteria: ViewSection.FirstCharacter
        section.delegate: sectionDelegate
        clip: true
        cacheBuffer: 1000
        onCountChanged: {
            contactList.currentIndex = -1;
            console.log("LazyPhoneContactsPage: contactList.count: " + count);
            if (count > 0) {
                //phoneContactBackEnd.alphabetModel.populateAlphabet();
                console.log("cacheBuffer: " + cacheBuffer)
            }
        }
        onMovementStarted: {
            //causes highlight to disapear - we don't want it to scroll with the
            //previously selected item
            contactList.currentIndex = -1;
        }
    }

    Component {
        id: sectionDelegate
        Rectangle {
            width: contactList.width
            height: 20
            color: "blue"
        }
    }

    Component {
        id: highlightBar
        Rectangle {
            color: "#cccccc";
            width: contactList.width;
            height: 80
        }
    }

    Component {
        id: contactDelegate
        PhoneContactsDelegate {
            onClicked: {
                alphabetSlider.opacity = 0
                phoneContactBackEnd.contactNumbersModel.loadNumbers(model.contact.phoneNumbers, model.contact.name.firstName + " " + model.contact.name.lastName)
                contactDialog.model = phoneContactBackEnd.nullModel;
                contactDialog.model = phoneContactBackEnd.contactNumbersModel;
                contactDialog.titleText = model.contact.displayLabel
                contactDialog.open();
            }
        }
    }

    PhoneContactDialog {
        id: contactDialog
        visualParent: pageContent
        selectedIndex: 1
        //only set the model when it is fully populated. i.e. on openening the dialog
        //otherwise if there is more than one record, nothing will be shown.
        //model: phoneNumbersModel
        onContactSelected: pageContent.contactSelected(number, name);
        onRejected: alphabetSlider.resetOpacity();
    }

}
