import QtQuick 2.0
//import QtQuick 1.1
import org.flyingsheep.abstractui.backend 1.0 //for AUIContactModel
//import QtMobility.contacts 1.1
import QtContacts 5.0

Item {
    id: backEnd

    signal modelsPopulated

    property alias localContactModel: localContactModelInternal
    property alias contactNumbersModel: contactNumbersModelInternal
    property alias nullModel: nullModelInternal

    //offers the phone's contacts
    //we no longer directly expose phoneContactsModel to the GUI
    // contactNumbersModel serves as an adaper
    //this is due to the following bugs
    //a) fetchContacts returns a QList, QML cannot handle QLists
    //b) filtering on displayLabel does not work
    //c) sections don't work
    //Also, by adpoting the model adapter view pattern, we issolate the GUI (View)
    //from any future changes to QtContacts
    AUIContactModel {
        id: phoneContactsModelInternal
        sortOrders: [
            //Note: for some reason the enums of ContactDetail (ContactDetailType) and ContactName (FieldType)
            //get lost when wrapped, therefore we have created our own equivalents.
            AUIContactSortOrder {
                detail: AUIContactDetailType.DisplayLabel
                field: DisplayLabel.Label
                direction:Qt.AscendingOrder
                blankPolicy: SortOrder.BlanksFirst
            }
        ]

        onContactsChanged: {
            console.log(Qt.formatDateTime(new Date(), "yyyyMMdd hh:mm:ss") + " ContactModel: onContactsChanged: " + phoneContactsModelInternal.contacts.length);
            populateModels();
        }
    }

    function populateModels() {
        localContactModelInternal.populate();
        backEnd.modelsPopulated();
    }

    ListModel {
        id: localContactModelInternal

        function populate() {
            clear();
            for (var i = 0; i < phoneContactsModelInternal.contacts.length; i ++) {
                appendContact(phoneContactsModelInternal.contacts[i]);
                //console.log("appended: " + localContactModel.get(i).displayLabel);
                //console.log("checking number of phoneNumbers: " + localContactModel.get(i).phoneNumbers.length);
            }
        }
        function appendContact(contact) {
            localContactModel.append({"contactId": contact.contactId,
                                  "displayLabel": contact.displayLabel.label,
                                  "firstName": contact.name.firstName,
                                  "lastName": contact.name.lastName,
                                  "phoneNumber": contact.phoneNumber,
                                  "phoneNumbers": contact.phoneNumbers,
                                  "phoneNumbersCount": contact.phoneNumbers.length});
//TODO: phoneNumber.length is available here, but later when our localContactModel is used, it is no longer available
//How does this get lost?
            //console.log("appending: " + contact.displayLabel.label + ", numbers: " + contact.phoneNumbers.length)
            //phoneNumbers is a dynamic property of ContactModel, and is only partially documented
            //harmattan uses contact.displayLabel, sailfish contact.displayLabel.label
        }
        //This function is required for InitialCharacterPicker, which is the consumer of this model
        function value2FilterOn(index){
            return get(index).displayLabel;
        }
    }

    //Stores the phone numbers and types of one contact
    ListModel {
        id: contactNumbersModelInternal

        function loadNumbers(contact) {
            console.log("loadNumbers: name to load: " + contact.displayLabel)
            console.log("loadNumbers: numbers to load: " + contact.phoneNumbersCount);
            console.log("loadNumbers: numbers to load2: " + contact.phoneNumbers.length);
            contactNumbersModelInternal.clear();
            for(var i = 0; i < contact.phoneNumbersCount; i++) {
                console.log("appending number" + contact.phoneNumbers[i] + " " + contact.phoneNumbers[i].number + " " + contact.phoneNumbers[i].subTypes[0] )
                var subType = (contact.phoneNumbers[i].subTypes[0] === undefined) ? "" : contact.phoneNumbers[i].subTypes[0]
                contactNumbersModelInternal.append({num: contact.phoneNumbers[i].number, type: subType, name: contact.name});
            }
        }

        /*
        function loadNumbers(name, phoneNumbers, count) {
            console.log("loadNumbers: name to load: " + name)
            console.log("loadNumbers: numbers to load: " + count);
            contactNumbersModelInternal.clear();
            for(var i = 0; i < phoneNumbers.length; i++) {
                console.log("appending number" + phoneNumbers[i] + " " + phoneNumbers[i].number + " " + phoneNumbers[i].subTypes[0] )
                var subType = (phoneNumbers[i].subTypes[0] === undefined) ? "" : phoneNumbers[i].subTypes[0]
                contactNumbersModelInternal.append({num: phoneNumbers[i].number, type: subType, name: name});
            }
        }
        */

        /*
        function loadNumbers(phoneNumbers, name) {
            console.log("loadNumbers: name to load: " + name)
            console.log("loadNumbers: numbers to load: " + phoneNumbers.length);
            contactNumbersModelInternal.clear();
            for(var i = 0; i < phoneNumbers.length; i++) {
                console.log("appending number" + phoneNumbers[i] + " " + phoneNumbers[i].number + " " + phoneNumbers[i].subTypes[0] )
                var subType = (phoneNumbers[i].subTypes[0] === undefined) ? "" : phoneNumbers[i].subTypes[0]
                contactNumbersModelInternal.append({num: phoneNumbers[i].number, type: subType, name: name});
            }
        }
        */
        function flushNumbers() {
            contactNumbersModelInternal.clear();
        }

    }
    ListModel {
        id: nullModelInternal
    }

}
