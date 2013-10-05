// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
//import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "settingsDB.js" as DB

Rectangle {
    id: thisModel
    signal populated(string group_id);
    signal headerClicked();
    signal delegateClicked(string group_id);

    //"outward" looking properties, should be bound by parent
    property int itemHeight: 60;
    property int headerHeight: itemHeight;
    property string headerText
    property int fontSize: 24
    property bool arrowVisible: true
    property color backgroundColor
    property color labelColorActive

    //inward looking, bound to inner objects.
    height: groupView.height
    color: backgroundColor
    property alias currentIndex: groupView.currentIndex;

    function populate(group_id) {
        groupModel.populate(group_id);
    }
    function resize(items){
        groupView.resize(items);
    }
    function get(index) {
        return groupModel.get(index);
    }

    ListModel {
        id: groupModel
        function populate(){
            clear();
            var rs = DB.getTemplateGroups();
            console.log("Group model populating: No Rows: " + rs.rows.length);
            groupView.resize(rs.rows.length);
            for(var i = 0; i < rs.rows.length; i++) {
                groupModel.append({"name": rs.rows.item(i).name, "active":  rs.rows.item(i).active, "group_id":  rs.rows.item(i).id});
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
//TODO: Why TemplateButtonsHeader here??? should be GroupButtonsHeader
    Component{
        id: groupHeader
        SimpleHeader {
            text: thisModel.headerText;
            textColor: thisModel.labelColorActive
            width: thisModel.width;
            height: thisModel.headerHeight
            fontSize: thisModel.fontSize
            onClicked:{
                console.log("Group Header Clicked");
                thisModel.headerClicked();
            }
        }
    }

    //TODO: this means the current delegate should be renamed to ViewTextDelegate or similar

    Component {
        id: groupDelegate
        GroupButtonsDelegate{
            width: thisModel.width
            height: thisModel.itemHeight
            text: name
            checked: (active == 1) ? true : false
            fontSize: thisModel.fontSize
            backgroundColor: thisModel.backgroundColor
            onClicked:{
                console.log("Group Delegate Clicked: group_id is: " + group_id);
                thisModel.delegateClicked(group_id);
                //clear here so model is really empty when page is called again.
                groupModel.clear();
            }

            onPressedChanged: {
                console.log ("onPressedChanged, pressed: " + pressed)
                if (pressed) {
                    console.log("index: " + index);
                    groupModel.setExclusiveActiveItem(index);
                }
            }
        }
    }

    ListView {
        id: groupView
        anchors.left: parent.left
        anchors.right:parent.right
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        model: groupModel
        delegate: groupDelegate
        header: groupHeader
        // Set the highlight delegate. Note we must also set highlightFollowsCurrentItem
        // to false so the highlight delegate can control how the highlight is moved.
        //stop dragging of the listview: we will need to change this if more buttons used
        interactive: false
        function resize(items){
            console.log("resizing");
            groupView.height = (items * itemHeight) + headerHeight;
        }
    }

}
