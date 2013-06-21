import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

LandedPage {
    id: thisPage
//    tools: commonTools

    WhiteButtonStyle {id: whiteButton
    }

//TODO:
// I need to find a better way of positioning these buttons (assuming we keep the overall layout)
//On Sailfish the buttons are very far down the long screen --> looks odd
//What if the MVD has lots of entries and is longer than the screen? What should happen to the buttons

//I need to rethink the whole layout, and the save handling
//It is a bit desktopy.
//Do I need a Save Button on this level?
//Should not the change been saved on the New / Edit / Delete dialogs?

//What about actions like copy?


//A possible reference is the Harmattan contacts app
//On the contacts page:
//New is available from the icon on the left of the MenuBar
// to do anything else, the item must be clicked, displaying a detail page
//On the detail page Edit, Delete, Copy would be available from the menu
//Each of these slides up the appropriate change dialog

//This does involve lots of screens (or similar). And given that we have multiple MVDs,
//my implementation would have more.

//How about this:
//Back on the MainPage
// 1) clicking on an item (short prod) selects that item and repopulates childs
// 2) a long prod pops a context menu that offers the following actions:
//   a) Add new contact
//   b) edit this contact
//   c) copy this contact
//   d) delete this contact
// selecting an action then pops the relevant change page.

//See example "combo box" in Components Gallery"

//This is a fairly major re-engineering, so first do the following
//Commit the current status to GitHub - it kind of works, and serves as a reference
//Make a new branch



    AUIButton {id: backButton
        anchors {left: parent.left; leftMargin: 10; bottom: parent.bottom; bottomMargin: 25}
        width: (parent.width - (3 * buttonMargin)) / 2;
        height: buttonHeight;
        text: qsTr("Back");
        platformStyle: whiteButton;
        onClicked: {
            backButtonClicked();
        }
    }

    AUIButton {id: saveButton
        anchors {left: backButton.right; leftMargin: 10; right: parent.right; rightMargin: 10; bottom: parent.bottom; bottomMargin: 25}
        height: buttonHeight;
        text: qsTr("Save");
        platformStyle: whiteButton
        enabled: true
        onClicked: {
            saved();
        }
    }
}
