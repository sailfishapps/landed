import QtQuick 1.1

Item {
    id: backGroundRect
    width: parent.width
    height: 80
    property string firstName: model.contact.name.firstName;

    signal clicked()
    signal contactSelected(string number, string name)
    signal contactRejected()

    Text {
        id: nameText
        anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; top: parent.top}
        font.pointSize: pageContent.listPointSize;
        font.weight: Font.DemiBold
        text: model.contact.displayLabel.trim();
    }  
    Text {
        id: numberText
        anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; top: nameText.bottom}
        font.pointSize: pageContent.listPointSize * (4/5);
        font.weight: Font.Light
        text: model.contact.phoneNumber.number + ", " + model.contact.contactId
    }
    MouseArea {
        anchors.fill: parent;
        onPressed: {
            contactList.currentIndex = index;
        }
        onClicked: {         
            console.log(model.contact.name.firstName + " " + model.contact.name.lastName + " clicked")
            parent.clicked()
        }
        onReleased: {
            contactList.currentIndex = -1;
            console.log("released")
        }
    }
}
