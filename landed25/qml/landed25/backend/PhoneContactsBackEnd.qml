import QtQuick 1.1
import org.flyingsheep.abstractui.backend 1.0 //for AUIContactModel
import QtMobility.contacts 1.1

Item {
    id: backEnd
    property alias phoneContactsModel: phoneContactsModelInternal
    property alias contactNumbersModel: contactNumbersModelInternal
    property alias nullModel: nullModelInternal
    property alias alphabetModel: leadingCharModelInternal
    property string searchKey

//TODO: consider creating my own model which will be filled from the contact model
// the view will be linked to the landedmodel (rather than the ContactModel)
//The hope is that searching will perform better



    //offers the phone's contacts
    AUIContactModel {
        id: phoneContactsModelInternal
        sortOrders: [
            //Note: for some reason the enums of ContactDetail (ContactDetailType) and ContactName (FieldType)
            //get lost when wrapped, therefore we have created our own equivalents.


            AUIContactSortOrder {
                detail: AUIContactDetailType.DisplayLabel
                //field: label
                field: DisplayLabel.Label
                direction:Qt.AscendingOrder
                blankPolicy: SortOrder.BlanksFirst
            }
/*
            SortOrder {
                detail: ContactDetail.DisplayLabel
                field: DisplayLabel.Label
                direction:Qt.AscendingOrder
                blankPolicy: SortOrder.BlanksFirst
            }
*/

        ]

//TODO: we temporarily filter with firstName and lastName
// as filtering on DisplayLabel is not working (no records found)
//This workaround means that a part of name scores a hit, but a part space part
//will not do so (as firstName and lastName are both searched with the complete searchKey)

        filter: UnionFilter {
            DetailFilter {
            //detail: ContactDetail.Name
            detail: AUIContactDetailType.Name
            field: Name.FirstName
            //value: "T"
            value: backEnd.searchKey
            matchFlags: Filter.MatchContains
            }

            DetailFilter {
            //detail: ContactDetail.Name
            detail: AUIContactDetailType.Name
            field: Name.LastName
            //value: "T"
            value: backEnd.searchKey
            matchFlags: Filter.MatchContains
            }
        }


/*

        //https://bugreports.qt-project.org/browse/QTBUG-35259
        //This one refuses to work!!!
        filter: DetailFilter {
            detail: ContactDetail.DisplayLabel
            field: DisplayLabel.Label
            value: backEnd.searchKey
            matchFlags: Filter.MatchContains
        }
*/

/*
        //This one works
        filter: DetailFilter {
            detail: ContactDetail.Name
            field: Name.FirstName
            value: backEnd.searchKey
            matchFlags: Filter.MatchStartsWith
        }
*/

        /*
        //Does not work
        filter: DetailFilter {
            detail: ContactDetail.DisplayLabel
            field: DisplayLabel.label
            value: "T"
            //value: searchbox.searchText
            matchFlags: Filter.MatchStartsWith
        }
        //Does not work
        filter: DetailFilter {
            detail: ContactDetail.DisplayLabel
            field: DisplayLabel.Label
            value: "T"
            //value: searchbox.searchText
            matchFlags: Filter.MatchStartsWith
        }
        //Does not work
        filter: DetailFilter {
            detail: ContactDetail.DisplayLabel
            field: Label
            value: "T"
            //value: searchbox.searchText
            matchFlags: Filter.MatchStartsWith
        }
        //Does not work
        filter: DetailFilter {
            detail: ContactDetail.DisplayLabel
            field: label
            value: "T"
            //value: searchbox.searchText
            matchFlags: Filter.MatchStartsWith
        }
        //Does not work
        filter: DetailFilter {
            detail: ContactDetail.DisplayLabel
            field: displayLabel
            value: "T"
            //value: searchbox.searchText
            matchFlags: Filter.MatchStartsWith
        }
        */

        /*
        //This one works
        filter: UnionFilter {
            DetailFilter {
            detail: ContactDetail.Name
            field: Name.FirstName
            value: "T"
            //value: searchbox.searchText
            matchFlags: Filter.MatchStartsWith
            }

            DetailFilter {
            detail: ContactDetail.Name
            field: Name.LastName
            value: "T"
            //value: searchbox.searchText
            matchFlags: Filter.MatchStartsWith
            }

            DetailFilter {
            detail: ContactDetail.DisplayLabel
            field: DisplayLabel.Label
            value: "T"
            //value: searchbox.searchText
            matchFlags: Filter.MatchStartsWith
            }
        }
        */

        onContactsChanged: {
            console.log("ContactModel: onContactsChanged: " + phoneContactsModelInternal.contacts.length);
            leadingCharModelInternal.populateAlphabet();
        }
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
