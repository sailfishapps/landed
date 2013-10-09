import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
import com.nokia.meego 1.0
import QtMobility.contacts 1.1

AUIPage {
    id: contactsPage
    orientationLock: AUIPageOrientation.LockPortrait

    signal contactSelected(string phoneNumber, string name)

    ContactModel {
        id: contactModel
        sortOrders: [
            SortOrder {
                detail:ContactDetail.Name
                field:Name.FirstName
                direction:Qt.AscendingOrder
            },
            SortOrder {
               detail:ContactDetail.Name
               field:Name.LastName
               direction:Qt.AscendingOrder
            }
        ]
    }

    ListView {
        id:  contactList
        anchors.fill: parent
        anchors.rightMargin: 50
        model: contactModel
        delegate:contactDelegate
    }

    Component {
        id: contactDelegate
        Rectangle {
            width: parent.width
            height: 80
            color: "white"
            property string firstName: model.contact.name.firstName;
            Text {
                id: nameText
                anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; top: parent.top}
                font.pointSize: 20;
                font.weight: Font.DemiBold
                text: model.contact.name.firstName + " " + model.contact.name.lastName;
            }
            Text {
                id: numberText
                anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; top: nameText.bottom}
                font.pointSize: 16;
                font.weight: Font.Light
                text: model.contact.phoneNumber.number + ", " + model.contact.contactId
            }

            SelectionDialog {id: contactDialog
                visualParent: contactsPage
                titleText: nameText.text
                selectedIndex: 1
                //only set the model when it is fully populated. i.e. on openening the dialog
                //otherwise if there is more than one record, nothing will be shown.
                //model: phoneNumbersModel
                delegate: phoneNumberDelegate
                onAccepted: {
                    console.log ("accepted")
                }
                onRejected: {
                    console.log ("rejected")
                }
            }

            MouseArea {
                anchors.fill: parent;
                onPressed: {
                    contactDelegate.color = "#CCCCCC";
                }
                onClicked: {
                    console.log(model.contact.name.firstName + " " + model.contact.name.lastName + " clicked")
                    phoneNumbersModel.loadNumbers(model.contact.phoneNumbers)
                    contactDialog.model = phoneNumbersModel;
                    contactDialog.open();
                }
                onReleased: {
                    contactDelegate.color = "white";
                    console.log("released")
                }
            }
        }
    }

    ListModel {
        id: phoneNumbersModel
        function loadNumbers(phoneNumbers) {
            console.log ("numbers to load: " + phoneNumbers.length);
            phoneNumbersModel.clear();
            for(var i = 0; i < phoneNumbers.length; i++) {
                console.log("appending number" + phoneNumbers[i] + " " + phoneNumbers[i].number + " " + phoneNumbers[i].subTypes[0] )
                //phoneNumbersModel.append(phoneNumbers[i]);
                //phoneNumbersModel.append({num: phoneNumbers[i].number, type: phoneNumbers[i].subTypes[0]});
                phoneNumbersModel.append({name: phoneNumbers[i].number + " " + phoneNumbers[i].subTypes[0]});
            }
        }
        function flushNumbers() {
            phoneNumbersModel.clear();
        }
    }
    ListModel {
        id: nullModel
    }

    Component {
        id: phoneNumberDelegate
        Text {
            height: 64
            font.pointSize: 30;
            font.weight: Font.Light
            //text: model.num + " " + model.type
            text: model.name
            color: "white"
            MouseArea {
                anchors.fill: parent
                onPressed: {
                    console.log ("delegate pressed")
                    contactsPage.contactSelected(model.name, "fred");
                    contactDialog.accept();

                    //workaround, otherwise the next time this item is visited, no rows are displayed
                    contactDialog.model = nullModel;
                }
            }
        }
    }
}

