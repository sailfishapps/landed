import QtQuick 1.1
//import Sailfish.Silica 1.0
import org.flyingsheep.abstractui 1.0

Item{
    id: thisDelegate
    signal clicked();
    signal doubleClicked();
    signal pressed();
    signal pressAndHold();
    signal released();

    signal newPressed();
    signal editPressed();
    signal copyPressed();
    signal deletePressed();
    property int fontSize: 24
    property string text
    property variant model
    property variant index
    property int closedHeight

    Text {
        text: thisDelegate.text
        font.pointSize: thisDelegate.fontSize
        font.weight: Font.Light
        color: "white"
        verticalAlignment: Text.AlignVCenter
        width: thisDelegate.width
        elide: Text.ElideRight
    }

    property Item contextMenu
    Component {
        id: contextMenuComponent
        AUIContextMenu {
            id: menu
            AUIMenuItem {
                text: "New"
                onClicked: newPressed();
            }
            AUIMenuItem {
                text: "Copy"
                onClicked: copyPressed();
            }
            AUIMenuItem {
                text: "Edit"
                onClicked: editPressed();
            }
            AUIMenuItem {
                text: "Delete"
                onClicked: deletePressed();
            }
        }
    }
    property bool menuOpen: contextMenu != null && contextMenu.parent === thisDelegate

    onPressAndHold: {
        if (!contextMenu)
            contextMenu = contextMenuComponent.createObject(thisDelegate);
        contextMenu.show(thisDelegate);
    }

    MouseArea{
        anchors.fill: parent;
        onClicked:{
            thisDelegate.clicked();
        }
        onDoubleClicked:{
            thisDelegate.doubleClicked();
        }
        onPressed: {
            thisDelegate.pressed();
        }

        onPressAndHold: {
            thisDelegate.pressAndHold();
        }
        onReleased: {
            thisDelegate.released();
        }
    }
}
