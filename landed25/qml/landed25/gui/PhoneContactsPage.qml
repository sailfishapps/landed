import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "../backend"

//gives access to the contacts from the phone (as opposed to contacts stored by Landed / LandedSettings)


AUIPage {
    id: contactsPage
    orientationLock: AUIPageOrientation.LockPortrait

    property int listPointSize: (simulator) ? 9 : 20
    property int phoneNumberDelegatePointSize: (simulator) ? 13 : 30

    signal contactSelected(string phoneNumber, string name)

    //http://harmattan-dev.nokia.com/docs/library/html/qt-components/qt-components-meego-pagestack.html#advanced-usage
    //dynamic loading of page content as loading contacts takes time
    //and sometimes stalls during load with error "The task queue's background thread stalled"

    Item {
        id: container
        anchors.fill: parent
    }

    property Item containerObject;

    onVisibleChanged: {
        if (visible) {
            // create component
            console.log("Page content created.");
            var object = componentDynamic.createObject(container);
            containerObject = object;
        } else {
            // destroy component
            console.log("Page content destroyed.");
            containerObject.destroy();
        }
    }

    // Page content inside component, this is created dynamically when page is visible
    Component {
        id: componentDynamic
        Item {
            id: content
            anchors.fill: container
            PhoneContactsBackEnd {
                id: phoneContactBackEnd
            }

            ListView {
                id:  contactList
                anchors.fill: parent
                anchors.rightMargin: 50
                model: phoneContactBackEnd.phoneContactsModel
                delegate:contactDelegate
                onCountChanged: {
                    console.log("LazyPhoneContactsPage: contactList.count: " + count);
                    console.log("contactList.height: " + height);
                    console.log("content.height: " + content.height);
                }
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
                            phoneContactBackEnd.contactNumbersModel.loadNumbers(model.contact.phoneNumbers, model.contact.name.firstName + " " + model.contact.name.lastName)
                            contactDialog.model = phoneContactBackEnd.contactNumbersModel;
                            contactDialog.open();
                        }
                        onReleased: {
                            contactDelegate.color = "white";
                            console.log("released")
                        }
                    }
                }
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
                            contactDialog.model = phoneContactBackEnd.nullModel;
                        }
                    }
                }
            }
        }
    }


   /*
    //this component hosts the 3 models used by this page
    PhoneContactsBackEnd {
        id: phoneContactBackEnd
    }

    ListView {
        id:  contactList
        anchors.fill: parent
        anchors.rightMargin: 50
        //model: contactModel
        model: phoneContactBackEnd.phoneContactsModel
        delegate:contactDelegate
        onCountChanged: console.log("PhoneContactsPage: contactList.count: " + count);
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
                    phoneContactBackEnd.contactNumbersModel.loadNumbers(model.contact.phoneNumbers, model.contact.name.firstName + " " + model.contact.name.lastName)
                    contactDialog.model = phoneContactBackEnd.contactNumbersModel;
                    contactDialog.open();
                }
                onReleased: {
                    contactDelegate.color = "white";
                    console.log("released")
                }
            }
        }
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
                    contactDialog.model = phoneContactBackEnd.nullModel;
                }
            }
        }
    }
    */

}

