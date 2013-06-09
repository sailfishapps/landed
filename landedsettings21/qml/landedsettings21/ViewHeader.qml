import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

AUIBackgroundRectangle {
    id: thisHeader
    signal clicked();
    signal editClicked();
    signal newClicked();
    signal deleteClicked();

    property int closedHeight
    property int expandedHeight
    property int fontSize: 24
    property string text

    state: "stateView";
    states: [
        State {
            name: "stateView";
            PropertyChanges{ target: arrow; visible: true }
            PropertyChanges{ target: arrow; color: "white" }
            PropertyChanges{ target: configureButtons; state: "stateHidden" }
            PropertyChanges{ target: thisMouse; enabled: true }
            PropertyChanges{ target: thisHeader; height: closedHeight }
            PropertyChanges{ target: label; text: thisHeader.text }
            PropertyChanges{ target: label; color: "white" }
        },
        State {
            name: "stateParentEmpty";
            PropertyChanges{ target: arrow; visible: false }
            PropertyChanges{ target: configureButtons; state: "stateHidden" }
            PropertyChanges{ target: thisMouse; enabled: false }
            PropertyChanges{ target: thisHeader; height: closedHeight }
            PropertyChanges{ target: label; text: thisHeader.text }
            PropertyChanges{ target: label; color: "grey" }
        },
        State {
            name: "stateConfigure";
            PropertyChanges{ target: arrow; visible: false }
            PropertyChanges{ target: configureButtons; state: "stateEnabledAll" }
            PropertyChanges{ target: thisMouse; enabled: false }
            PropertyChanges{ target: thisHeader; height: expandedHeight }
            PropertyChanges{ target: label; text: "Configure " + thisHeader.text }
            PropertyChanges{ target: label; color: "white" }
        },
        State {
            name: "stateConfigureNew";
            PropertyChanges{ target: arrow; visible: false }
            PropertyChanges{ target: configureButtons; state: "stateEnabledNew" }
            PropertyChanges{ target: thisMouse; enabled: false }
            PropertyChanges{ target: thisHeader; height: expandedHeight }
            PropertyChanges{ target: label; text: "Configure " + thisHeader.text }
            PropertyChanges{ target: label; color: "white" }
        }
    ]
//Commented out for Sailfish
    //color: "black"
    Text{ id: label
        text: thisHeader.text
        font.pointSize: thisHeader.fontSize
        font.weight: Font.DemiBold
        //color: "white"
        anchors.top: parent.top
        anchors.topMargin: 2
        verticalAlignment: Text.AlignVCenter
    }
    Text{ id: arrow
        text: ">"
        font.pointSize: thisHeader.fontSize
        font.weight: Font.DemiBold
        //color: "white"
        anchors.top: parent.top
        anchors.topMargin: 2
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        anchors.right: thisHeader.right
        anchors.rightMargin: 10
        width: 30
        //visible: thisHeader.arrowVisible
    }
    Rectangle {
        width: thisHeader.width; height: 1
        color: "lightgrey"
        anchors.bottom: thisHeader.bottom
    }
    Rectangle {
        width: thisHeader.width; height: 1
        color: "lightgrey"
        anchors.top: thisHeader.top
    }

    ButtonSetConfigure { id: configureButtons
        anchors.bottom: thisHeader.bottom;
        anchors.bottomMargin: 5;
        //anchors.right: thisHeader.right
        width: parent.width
        onNewClicked: thisHeader.newClicked();
        onEditClicked: {
            console.log("configureButtons height: " + configureButtons.height)
            thisHeader.editClicked();
        }
        onDeleteClicked: thisHeader.deleteClicked();
    }

    MouseArea{ id: thisMouse
        anchors.fill: thisHeader;
        onClicked:{
            console.log("Header Clicked")
            thisHeader.clicked();
        }
    }
}
