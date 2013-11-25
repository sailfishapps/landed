import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

AUISelectionDialog {id: contactDialog

    property int phoneNumberDelegatePointSize: (simulator) ? 13 : 30

    signal contactSelected(string number, string name)

    delegate: phoneNumberDelegate

    //delegate of the SeletionDialog
    Component {
        id: phoneNumberDelegate
        Text {
            height: 64
            font.pointSize: contactDialog.phoneNumberDelegatePointSize;
            font.weight: Font.Light
            //
            text: model.num + " " + model.type
            //text: model.name
            color: "white"
            MouseArea {
                anchors.fill: parent
                onPressed: {
                    console.log ("delegate pressed")
                    contactDialog.contactSelected(model.num, model.name);
                    contactDialog.accept();
                    //workaround, otherwise the next time this item is visited, no rows are displayed
                    contactDialog.model = phoneContactBackEnd.nullModel;
                }
            }
        }
    }
}
