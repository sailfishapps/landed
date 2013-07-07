import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

//AUIBackgroundRectangle {
Item {
    id: thisHeader
    //signals here

    property int headerHeight
    property int fontSize: 24
    property string text

    state: "stateView";
    states: [
        State {
            name: "stateView";
            PropertyChanges{ target: thisHeader; height: headerHeight }
            PropertyChanges{ target: label; text: thisHeader.text }
            PropertyChanges{ target: label; color: "white" }
            //more property changes here
        },
        State {
            name: "stateParentEmpty";
            PropertyChanges{ target: thisHeader; height: headerHeight }
            PropertyChanges{ target: label; text: thisHeader.text }
            PropertyChanges{ target: label; color: "grey" }
            //more property changes here
        }
        //more states here
    ]

    Text{ id: label
        text: thisHeader.text
        font.pointSize: thisHeader.fontSize
        font.weight: Font.DemiBold
        anchors.top: parent.top
        anchors.topMargin: 2
        verticalAlignment: Text.AlignVCenter
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
}
