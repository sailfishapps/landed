import QtQuick 2.0
//import QtQuick 1.1
import "../backend"

Rectangle {
    id: thisModel
    signal populated(string contact_id);
    signal headerClicked();
    signal delegateClicked(string contact_id, string contactName, string contactPhone);

    //"outward" looking properties, should be bound by parent
    property int itemHeight: 60;
    property int headerHeight: itemHeight;
    property string headerText
    property int fontSize: 24
    property bool arrowVisible: true
    property color backgroundColor
    property color labelColorActive

    //inward looking, bound to inner objects.
    height: contactView.height
    color: backgroundColor
    property alias currentIndex: contactView.currentIndex;

    function populate(template_id) {
        contactModel.populate(template_id);
    }

    ContactListModel {
        id: contactModel
    }

    Component{
        id: contactHeader
        SimpleHeader {
            text: thisModel.headerText;
            textColor: thisModel.labelColorActive
            width: thisModel.width;
            height: thisModel.headerHeight
            anchors.left: parent.left
            anchors.right: parent.right
            fontSize: thisModel.fontSize * 1.5
            fontBold: true
            onClicked:{
                console.log("Contact Header Clicked");
                thisModel.headerClicked();
            }
        }
    }

    Component {
        id: contactDelegate
        ContactButtonsDelegate{
            width: thisModel.width
            height: thisModel.itemHeight
            text: name
            checked: (active == 1) ? true : false
            fontSize: thisModel.fontSize
            backgroundColor: thisModel.backgroundColor
            onClicked:{
                console.log("Contact Delegate Clicked: contact_id is: " + contact_id + ", name: " + name);
                thisModel.delegateClicked(contact_id, name, phone);
                //clear here so model is really empty when page is called again.
                contactModel.clear();
            }

            onPressedChanged: {
                console.log ("onPressedChanged, pressed: " + pressed)
                if (pressed) {
                    console.log("index: " + index);
                    contactModel.setExclusiveActiveItem(index);
                }
            }
        }
    }

    ListView {
        id: contactView
        anchors.left: parent.left
        //anchors.leftMargin: 10 //harmattan
        anchors.leftMargin: 0 //sailfish
        anchors.right:parent.right
        anchors.rightMargin: 30
        model: contactModel
        delegate: contactDelegate
        header: contactHeader
        // Set the highlight delegate. Note we must also set highlightFollowsCurrentItem
        // to false so the highlight delegate can control how the highlight is moved.
        //stop dragging of the listview: we will need to change this if more buttons used
        interactive: false
        function resize(items){
            console.log("resizing");
            contactView.height = (items * itemHeight) + headerHeight;
        }
    }

}
