import QtQuick 2.0
//import QtQuick 1.1
import org.flyingsheep.abstractui.backend 1.0 //for AUIContactModel
//import QtMobility.contacts 1.1
import QtContacts 5.0

Item {
    id: backEnd

    property alias localContactModel: localContactModelInternal
    property alias contactNumbersModel: contactNumbersModelInternal
    property alias nullModel: nullModelInternal
    property alias alphabetModel: leadingCharModelInternal
    property string searchKey

    onSearchKeyChanged: {
        console.log("repopulating the localContactModel and alphabetModel models");
        populateModels();
    }

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
            console.log("ContactModel: onContactsChanged: " + phoneContactsModelInternal.contacts.length);
            populateModels();
        }
    }

    function populateModels() {
        localContactModelInternal.populate(backEnd.searchKey);
        leadingCharModelInternal.populate();
    }

    ListModel {
        id: localContactModelInternal

        function populate(searchKey) {
            clear();
            for (var i = 0; i < phoneContactsModelInternal.contacts.length; i ++) {
                if (searchKey.length == 0) { //console.log ("no filter set, append all elements");
                    appendContact(phoneContactsModelInternal.contacts[i]);
                }
                else { //filter elements
                    if (isSearchHit(phoneContactsModelInternal.contacts[i].displayLabel, searchKey)) {
                        appendContact(phoneContactsModelInternal.contacts[i]);
                    }
                }
            }
        }
        function isSearchHit(textToSearch, searchKey) {
            return (textToSearch.toUpperCase().search(searchKey.toUpperCase()) >=0) ? true : false;
        }
        function appendContact(contact) {
            localContactModel.append({"contactId": contact.contactId,
                                  "displayLabel": contact.displayLabel.label,
                                  "firstName": contact.name.firstName,
                                  "lastName": contact.name.lastName,
                                  "phoneNumber": contact.phoneNumber,
                                  "phoneNumbers": contact.phoneNumbers});
            //phoneNumbers is a dynamic property of ContactModel, and is only partially documented
            //harmattan uses contact.displayLabel, sailfish contact.displayLabel.label
        }
    }

    LeadingCharacterModel {
        id: leadingCharModelInternal;

        function populate() {
            clear();
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
            for (var i = 0; i < localContactModelInternal.count; i ++) {
                var displayLabel = localContactModelInternal.get(i).displayLabel;
                var currentInitial = displayLabel.substring(0, 1).toUpperCase()
                console.log(i + " displayLabel: " +  displayLabel + " initial: " + currentInitial)
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
