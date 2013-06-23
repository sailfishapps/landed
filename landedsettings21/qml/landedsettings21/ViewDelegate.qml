import QtQuick 1.1
import Sailfish.Silica 1.0

Item{
    id: thisDelegate
    signal clicked();
    signal doubleClicked();
    signal pressAndHold();
    signal released();
    signal menuOpening();
    signal menuClosing();
    property int fontSize: 24
    property string text
    property variant model
    property variant index

    Text {
        text: thisDelegate.text
        font.pointSize: thisDelegate.fontSize
        font.weight: Font.Light
        color: "white"
        verticalAlignment: Text.AlignVCenter
        width: thisDelegate.width
        //clip: true
        //elide: (paintedWidth > width) ? Text.ElideRight : Text.ElideNone
        elide: Text.ElideRight

    }

    property bool contextMenuIsOpen : contextMenu.active
    //height: contextMenuIsOpen ? contextMenu.childrenRect.height + 45 : 45

    ContextMenu { id: contextMenu
        MenuItem {
            text: "new";
            color: "white"
            onClicked: console.log("1 clicked")
        }
        MenuItem {
            text: "copy";
            color: "white"
            onClicked: console.log("2 clicked")
        }
        MenuItem {
            text: "edit";
            color: "white"
            onClicked: console.log("3 clicked")
        }
        MenuItem {
            text: "delete";
            color: "white"
            onClicked: console.log("4 clicked")
        }
        onStateChanged: console.log ("context menu state changed state is: " + state)
        onActiveChanged: {
            console.log ("context menu opening / closing: active is: " + active)
            if (active == true) {
                thisDelegate.menuOpening();
            }
            else {
                thisDelegate.menuClosing();
            }
        }
    }

    function showContextMenu(thisItem) {
        console.log("thisDelegate.height: " + thisDelegate.height)
        console.log ("showing ContextMenu: childrenRect.height is: " + contextMenu.childrenRect.height + "; height is: " + contextMenu.height)
        console.log ("child height is: " + contextMenu.children[1].height)
        //thisDelegate.height = thisDelegate.height + 350
        contextMenu.show(thisItem);
        console.log ("ContextMenu now open: childrenRect.height is: " + contextMenu.childrenRect.height + "; height is: " + contextMenu.height)
        console.log("thisDelegate.height: " + thisDelegate.height)
    }

    MouseArea{
        anchors.fill: parent;
        onClicked:{
            thisDelegate.clicked();
        }
        onDoubleClicked:{
            thisDelegate.doubleClicked();
        }
        onPressAndHold: {
            thisDelegate.pressAndHold();
        }
        onReleased: {
            thisDelegate.released();
        }
    }
}
