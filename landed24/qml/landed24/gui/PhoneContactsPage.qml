import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import org.flyingsheep.abstractui.backend 1.0 //for ContactModel
//import QtMobility.contacts 1.1

//gives access to the contacts from the phone (as opposed to contacts stored by Landed / LandedSettings)

//move to gui, as is a page. The ony non visual items are the Listmodels, so we could try factoring the models out.

AUIPage {
    id: contactsPage
    orientationLock: AUIPageOrientation.LockPortrait

    property int listPointSize: (simulator) ? 9 : 20
    property int phoneNumberDelegatePointSize: (simulator) ? 13 : 30

    signal contactSelected(string phoneNumber, string name)

    AUIContactModel {
        id: contactModel
        sortOrders: [
            //Note: for some reason the enums of ContactDetail (ContactDetailType) and ContactName (FieldType)
            //get lost when wrapped, therefore we have created our own equivalents.
            AUIContactSortOrder {
                //detail:ContactDetail.Name
                detail: AUIContactDetailType.Name
                //field:Name.FirstName
                field: AUIContactNameType.FirstName
                direction:Qt.AscendingOrder
            },
            AUIContactSortOrder {
               //detail:ContactDetail.Name
               detail: AUIContactDetailType.Name
               //field:Name.LastName
               field: AUIContactNameType.LastName
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
                font.pointSize: contactsPage.listPointSize;
                font.weight: Font.DemiBold
                text: model.contact.name.firstName + " " + model.contact.name.lastName;
            }
            Text {
                id: numberText
                anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; top: nameText.bottom}
                font.pointSize: contactsPage.listPointSize * (4/5);
                font.weight: Font.Light
                text: model.contact.phoneNumber.number + ", " + model.contact.contactId
            }

            AUISelectionDialog {id: contactDialog
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
                    phoneNumbersModel.loadNumbers(model.contact.phoneNumbers, model.contact.name.firstName + " " + model.contact.name.lastName)
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
        function loadNumbers(phoneNumbers, name) {
            console.log ("numbers to load: " + phoneNumbers.length);
            phoneNumbersModel.clear();
            for(var i = 0; i < phoneNumbers.length; i++) {
                console.log("appending number" + phoneNumbers[i] + " " + phoneNumbers[i].number + " " + phoneNumbers[i].subTypes[0] )
                //phoneNumbersModel.append(phoneNumbers[i]);
                var subType = (phoneNumbers[i].subTypes[0] === undefined) ? "" : phoneNumbers[i].subTypes[0]
                phoneNumbersModel.append({num: phoneNumbers[i].number, type: subType, name: name});
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
            font.pointSize: contactsPage.phoneNumberDelegatePointSize;
            font.weight: Font.Light
            //
            text: model.num + " " + model.type

            //text: model.name
            color: "white"
            MouseArea {
                anchors.fill: parent
                onPressed: {
                    console.log ("delegate pressed")
                    contactsPage.contactSelected(model.num, model.name);
                    contactDialog.accept();
                    //workaround, otherwise the next time this item is visited, no rows are displayed
                    contactDialog.model = nullModel;
                }
            }
        }
    }
}

