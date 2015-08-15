import QtQuick 2.0
//import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "../backend"
import "InitialCharacterPicker"
import LandedTheme 1.0



Rectangle {
    id: pageContent
    anchors.fill:  parent

//Think! for some reason the InitialCharacterPicker becomes about 30 greater than its parent rectangle!

    Component.onCompleted: {
        console.log("pageContent.height: " + pageContent.height + ", contactPicker.height: " + contactPicker.height)
        console.log("pageContent.y: " + pageContent.y + ", contactPicker.y: " + contactPicker.y)
    }

    //anchors.topMargin: 30 // without is shifted off screen a bit!
    //anchors.topMargin: 130 // required if the indicator is visible.
    color: LandedTheme.BackgroundColorB

    property int listpixelSize: (simulator) ? 9 : 24

    signal contactSelected(string number, string name)

    //Component.onCompleted: console.log(Qt.formatDateTime(new Date(), "yyyyMMdd hh:mm:ss") + " PhoneContactsPageContent onCompleted")

    Text {
        id: loadingText
        text: "Contacts loading ..."
        color: "lightblue"
        visible: true
        font.pixelSize: 30
        anchors.centerIn : parent
    }

    PhoneContactsBackEnd {
        id: phoneContactBackEnd
        onModelsPopulated: {
            contactPicker.populate();
            loadingText.visible = false
        }
    }

    InitialCharacterPicker {
        id: contactPicker
        anchors.fill: parent
        model: phoneContactBackEnd.localContactModel
        delegate: contactDelegate
        //initialCharacter is used to provide the initial to filter on when the component is created
        //"" will chose nothing, "%" all entries, any other letter will be filtered upon as normal.
        initialCharacter: ""
        charactersPerRow: 5
        property bool displayChars: true
        property bool displayNumerals: false
        characters: buildCharacters(displayChars, displayNumerals);

        function buildCharacters(displayChars, displayNumerals) {
            var ret = [];
            if (displayChars) {
                //alphanumeric wild card, will display all entries
                ret.push("%");
                //65-90 ascii codes for chars A to Z
                for (var i = 65; i <= 90; i++) {
                    ret.push(String.fromCharCode(i));
                }
            }
            if (displayNumerals) {
                //48-57 ascii codes for digits 0 to 9
                for (var i = 48; i <= 57; i++) {
                    ret.push(String.fromCharCode(i));
                }
            }
            //numeric wildcard, will display entries starting with a numeral
            ret.push("#");
            return ret;
        }

        onCountChanged: {
            console.log(Qt.formatDateTime(new Date(), "yyMMdd hh:mm:ss") +" LazyPhoneContactsPage: contactPicker.count: " + count);
        }
    }

    Component {
        id: contactDelegate
        PhoneContactsDelegate {
            onPressed: {
                contactPicker.currentIndex = index;
            }
            onClicked: {
                console.log("model.displayLabel: " + model.displayLabel)
                console.log("model.phoneNumbers: " + model.phoneNumbers + " count: " + model.phoneNumbersCount)
                //console.log("model.phoneNumbers: " + model.phoneNumbers + " length: " + model.phoneNumbers.length)
                //phoneContactBackEnd.contactNumbersModel.loadNumbers(model.displayLabel, model.phoneNumbers, model.phoneNumbersCount )
                phoneContactBackEnd.contactNumbersModel.loadNumbers(model);
                contactDialog.model = phoneContactBackEnd.nullModel;
                console.log("phoneContactBackEnd.contactNumbersModel.count: " + phoneContactBackEnd.contactNumbersModel.count)
                contactDialog.model = phoneContactBackEnd.contactNumbersModel;
                contactDialog.titleText = model.displayLabel
                pageStack.push(contactDialog);
            }
            onReleased: {
                contactPicker.currentIndex = -1;
            }
        }
    }

    PhoneContactDialog {
        id: contactDialog
        selectedIndex: 1
        //only set the model when it is fully populated. i.e. on openening the dialog
        //otherwise if there is more than one record, nothing will be shown.
        //model: phoneNumbersModel
        onContactSelected: pageContent.contactSelected(number, name);
        onRejected: alphabetSlider.resetOpacity();
    }
}
