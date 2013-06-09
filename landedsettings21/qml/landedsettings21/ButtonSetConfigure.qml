import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

Item {id: configureButtons
    property int buttonHeight: 38;
    property int buttonWidth: parent.width / 3;
    height: buttonHeight;

    signal editClicked();
    signal newClicked();
    signal deleteClicked();

    Row {
        width: parent.width
        spacing: 2

        AUIButton {id: newButton
            width: configureButtons.buttonWidth;
            height: configureButtons.buttonHeight;
//            platformStyle: greenStyle
            text: qsTr("New");
            onClicked: {
                console.log("Header New Clicked xxx")
                configureButtons.newClicked();
            }
        }

        AUIButton {id: editButton
            width: configureButtons.buttonWidth;
            height: configureButtons.buttonHeight;
//            platformStyle: greenStyle
            text: qsTr("Edit");
            onClicked: {
                console.log("Header Edit Clicked")
                configureButtons.editClicked();
            }
        }

        AUIButton {id: deleteButton
            width: configureButtons.buttonWidth;
            height: configureButtons.buttonHeight;
//            platformStyle: greenStyle
            text: qsTr("Delete");
            onClicked: {
                console.log("Header Delete Clicked")
                configureButtons.deleteClicked();
            }
        }
    }
    GreenButtonStyle { id: greenStyle
    }

    state: "stateEnabledAll";
    states: [
        State {
            name: "stateEnabledAll";
            PropertyChanges{ target: editButton; visible: true }
            PropertyChanges{ target: editButton; enabled: true }
            PropertyChanges{ target: newButton; visible: true }
            PropertyChanges{ target: newButton; enabled: true }
            PropertyChanges{ target: deleteButton; visible: true }
            PropertyChanges{ target: deleteButton; enabled: true }
        },
        State {
            name: "stateEnabledNew";
            PropertyChanges{ target: editButton; visible: true }
            PropertyChanges{ target: editButton; enabled: false }
            PropertyChanges{ target: newButton; visible: true }
            PropertyChanges{ target: newButton; enabled: true }
            PropertyChanges{ target: deleteButton; visible: true }
            PropertyChanges{ target: deleteButton; enabled: false }
        },
        State {
            name: "stateHidden";
            PropertyChanges{ target: editButton; visible: false }
            PropertyChanges{ target: editButton; enabled: false }
            PropertyChanges{ target: newButton; visible: false }
            PropertyChanges{ target: newButton; enabled: false }
            PropertyChanges{ target: deleteButton; visible: false }
            PropertyChanges{ target: deleteButton; enabled: false }
        }
    ]
}


