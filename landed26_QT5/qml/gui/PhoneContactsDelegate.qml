import QtQuick 2.0
//import QtQuick 1.1
import LandedTheme 1.0

Item {
    id: backGroundRect
    width: parent.width
    height: childrenRect.height

    signal pressed()
    signal clicked()
    signal released()
    signal contactSelected(string number, string name)
    signal contactRejected()

    Text {
        id: nameText
        anchors {left: parent.left; leftMargin: 20; right: parent.right; rightMargin: 20; top: parent.top}
        //font.pixelSize: pageContent.listpixelSize;
        font.pixelSize: LandedTheme.FontSizeMedium
        font.weight: Font.DemiBold
        text: model.displayLabel;
        color: "lightblue"
        height: 70
        verticalAlignment: Text.AlignVCenter
    }
    /*
    Text {
        id: numberText
        anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; top: nameText.bottom}
        font.pixelSize: pageContent.listpixelSize * (4/5);
        font.weight: Font.Light
        text: model.phoneNumber.number //+ ", " + model.contactId
        color: "lightgreen"
    }
    */
    MouseArea {
        anchors.fill: parent;
        onPressed: {
            parent.pressed()
        }
        onClicked: {
            console.log(model.displayLabel + " clicked")
            parent.clicked()
        }
        onReleased: {
            parent.released();
            console.log("released")
        }
    }
}
