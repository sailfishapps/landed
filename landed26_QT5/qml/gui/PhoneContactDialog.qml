import QtQuick 2.0
//import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

AUIPage {id: contactDialog

    property int phoneNumberDelegatePointSize: (simulator) ? 13 : 30
    property int selectedIndex
    //different to the PhoneContactsTabContent, we don't replace the provided model with an internal model
    //so we can use property alias to directly set the ListView model
    property alias model: numbersView.model
    //property QtObject model
    property string titleText

    signal contactSelected(string number, string name)
    signal rejected();

    ListView {
        id: numbersView
        delegate: phoneNumberDelegate
        width: contactDialog.width
//TODO: this assumes low number of numbers in model: it might be better to use some logic here
//400 or childrenRect.height, which ever is lowest
        height: childrenRect.height
        anchors.centerIn: contactDialog
        //y: 200
    }

    //delegate of the SeletionDialog
    Component {
        id: phoneNumberDelegate
        Text {
            height: 64
            font.pointSize: contactDialog.phoneNumberDelegatePointSize;
            font.weight: Font.Light
            //
            text: model.num //+ " " + model.type
            horizontalAlignment: Text.AlignRight
            color: "white"
            MouseArea {
                anchors.fill: parent
                onPressed: {
                    console.log ("delegate pressed")
                    contactDialog.contactSelected(model.num, model.name);
//TODO, check if this is still required, was a harmattan workaround for the DialogComponent, may not be needed
//for Sailfish, as we are using a DIY dialog.
                    //workaround, otherwise the next time this item is visited, no rows are displayed
                    contactDialog.model = phoneContactBackEnd.nullModel;
                }
            }
        }
    }
}

