import QtQuick 1.1
import "settingsDB.js" as DB

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
    property color backgroundColor: "black"

    //inward looking, bound to inner objects.
    height: contactView.height
    color: backgroundColor
    property alias currentIndex: contactView.currentIndex;

    function populate(template_id) {
        contactModel.populate(template_id);
    }
    function resize(items){
        contactView.resize(items);
    }
    function get(index) {
        return contactModel.get(index);
    }

    ListModel {
        id: contactModel
        function populate(template_id){
            clear();
            var rs = DB.getContacts(template_id);
            console.log("Contact model populating for template: " + template_id + ", No Rows: " + rs.rows.length);
            contactView.resize(rs.rows.length);
            for(var i = 0; i < rs.rows.length; i++) {
                console.log(rs.rows.item(i).name);
                contactModel.append({"name": rs.rows.item(i).name, "phone": rs.rows.item(i).phone, "active":  rs.rows.item(i).active, "contact_id":  rs.rows.item(i).id});
            }
        }
        function setExclusiveActiveItem(activeItem) {
            //sets one item to active, and all others to inactive
            for(var i = 0; i < count; i++) {
                if (i == activeItem) {
                    setProperty(i, "active", 1);
                }
                else {
                    //deactivate all other items
                    setProperty(i, "active", 0);
                }
            }
        }
    }

    Component{
        id: contactHeader
        TemplateButtonsHeader {
            text: thisModel.headerText;
            width: thisModel.width;
            height: thisModel.headerHeight
            fontSize: thisModel.fontSize
            arrowVisible: thisModel.arrowVisible
            onClicked:{
                console.log("Contact Header Clicked");
                thisModel.headerClicked();
            }
        }
    }

    //TODO: this means the current delegate should be renamed to ViewTextDelegate or similar

    Component {
        id: contactDelegate
        ContactButtonsDelegate{
            width: thisModel.width
            height: thisModel.itemHeight
            text: name
            checked: (active == 1) ? true : false
            fontSize: thisModel.fontSize
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
        anchors.right:parent.right
        anchors.leftMargin: 10
        anchors.rightMargin: 10
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
