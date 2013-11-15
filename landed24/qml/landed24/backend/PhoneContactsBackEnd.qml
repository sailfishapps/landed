import QtQuick 1.1
import org.flyingsheep.abstractui.backend 1.0 //for AUIContactModel
//import QtMobility.contacts 1.1

Item {

    property alias phoneContactsModel: phoneContactsModelInternal
    property alias contactNumbersModel: contactNumbersModelInternal
    property alias nullModel: nullModelInternal

    //offers the phone's contacts
    AUIContactModel {
        id: phoneContactsModelInternal
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
