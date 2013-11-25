import QtQuick 1.1
import org.flyingsheep.abstractui.backend 1.0 //for AUIContactModel
//import QtMobility.contacts 1.1

Item {

    property alias phoneContactsModel: phoneContactsModelInternal
    property alias contactNumbersModel: contactNumbersModelInternal
    property alias nullModel: nullModelInternal
    property alias alphabetModel: leadingCharModelInternal



    //offers the phone's contacts
    AUIContactModel {
        id: phoneContactsModelInternal
        sortOrders: [
            //Note: for some reason the enums of ContactDetail (ContactDetailType) and ContactName (FieldType)
            //get lost when wrapped, therefore we have created our own equivalents.
            AUIContactSortOrder {
                detail: AUIContactDetailType.DisplayLabel
                field: label
                direction:Qt.AscendingOrder
                blankPolicy: SortOrder.BlanksFirst
            }
        ]
    }



    LeadingCharacterModel {
        id: leadingCharModelInternal;

        function populateAlphabet() {
            var initials = getInitials();
            console.log("populating model: " + initials.length);
            leadingCharModelInternal.clear();
            for (var i = 0; i < initials.length; i++) {
                leadingCharModelInternal.append(initials[i])
            }
        }

        function getInitials() {
            var oldInitial = "";
            var initialString = "";
            var initials = new Array();
            for (var i = 0; i < phoneContactsModelInternal.contacts.length; i ++) {
                //console.log("label: " + contactList.model[i].displayLabel)
                console.log(i + " label: " + phoneContactsModelInternal.contacts[i].displayLabel)
                var currentInitial = phoneContactsModelInternal.contacts[i].displayLabel.substring(0, 1).toUpperCase()
                console.log(i + " initial: " + currentInitial)
                if ((currentInitial != oldInitial) && (currentInitial.length > 0)) {
                    initialString = initialString + ";" + currentInitial;
                    initials.push({"character": currentInitial, "index": i});
                    oldInitial = currentInitial;
                }
            }
            console.log(initialString);
            return initials;
        }
    }


    //Stores the phone numbers and types of one contact
    ListModel {
        id: contactNumbersModelInternal
        function loadNumbers(phoneNumbers, name) {
            console.log ("numbers to load: " + phoneNumbers.length);
            contactNumbersModelInternal.clear();
            for(var i = 0; i < phoneNumbers.length; i++) {
                console.log("appending number" + phoneNumbers[i] + " " + phoneNumbers[i].number + " " + phoneNumbers[i].subTypes[0] )
                //contactNumbersModelInternal.append(phoneNumbers[i]);
                var subType = (phoneNumbers[i].subTypes[0] === undefined) ? "" : phoneNumbers[i].subTypes[0]
                contactNumbersModelInternal.append({num: phoneNumbers[i].number, type: subType, name: name});
            }
        }
        function flushNumbers() {
            contactNumbersModelInternal.clear();
        }
    }
    ListModel {
        id: nullModelInternal
    }

}
