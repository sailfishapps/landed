//import QtQuick 2.0
import QtQuick 1.1
//import com.nokia.meego 1.0
import "settingsDB.js" as DB

Item {
//Rectangle {
    id: thisModel
    signal populated(string template_id);
    signal headerClicked();
    signal delegateClicked(string template_id, string msg_status);

    //"outward" looking properties, should be bound by parent
    property int itemHeight: 60;
    property int marginWidth: 10;
    property int headerHeight: itemHeight;
    property string headerText
    property string headerSubText
    property int fontSize: 24
    property bool arrowVisible: true
    property color textColor
    //Commented out for Sailfish
    //property color backgroundColor: "black"

    //inward looking, bound to inner objects.
    height: templateView.height

    //Commented out for Sailfish
    //color: backgroundColor

    property alias currentIndex: templateView.currentIndex;

    function populate(group_id) {
        templateModel.populate(group_id);
    }
    function resize(items){
        templateView.resize(items);
    }
    function get(index) {
        return templateModel.get(index);
    }

    function clear() {
        headerText = "";
        templateModel.clear();
    }

    ListModel {
        id: templateModel
        function populate(group_id){
            templateModel.clear();
            var rs = DB.getMessageTemplates(group_id);
            console.log("Template model populating using group_id: " + group_id + ", No Rows: " + rs.rows.length);
            templateView.resize(rs.rows.length+1); //add 1 for the custom button
            for(var i = 0; i < rs.rows.length; i++) {
                templateModel.append({"button_label": rs.rows.item(i).button_label, "msg_status": rs.rows.item(i).msg_status, "template_id": rs.rows.item(i).id});
                console.log("button_label is: " + rs.rows.item(i).button_label + ", msg_status is: " + rs.rows.item(i).msg_status);
            }
            //templateModel.append({"button_label":  "Create Custom SMS", "msg_status": "Ok", "template_id": "-999"});

            if (rs.rows.length > 0) {
                thisModel.populated(rs.rows.item(0).id);
            }
            else{
                thisModel.populated("");
            }
        }
    }

    Component{
        id: templateHeader
        TemplateButtonsHeader {
            text: thisModel.headerText;
            subText: thisModel.headerSubText
            width: thisModel.width;
            //TODO: find a better way of calculating the height based on height of text + subText
            height: thisModel.headerHeight * 1.666
            fontSize: thisModel.fontSize
            arrowVisible: thisModel.arrowVisible
            textColor: thisModel.textColor
            onClicked:{
                console.log("Template Header Clicked");
                thisModel.headerClicked();
            }
        }
    }

    //TODO: this means the current delegate should be renamed to ViewTextDelegate or similar

    Component {
        id: templateDelegate
        TemplateButtonsDelegate{
            width: thisModel.width - (marginWidth*2)
            height: thisModel.itemHeight
            text: button_label
            fontSize: thisModel.fontSize
            buttonColor: (msg_status == "Ok") ? "green" : "red";
            onClicked:{
                console.log("Template Delegate Clicked: template_id is: " + template_id);
                templateView.currentIndex = index;
                thisModel.delegateClicked(template_id, msg_status);
            }
        }
    }

    ListView {
        id: templateView
        anchors.left: parent.left
        anchors.right:parent.right
        anchors.leftMargin: marginWidth
        anchors.rightMargin: marginWidth
        model: templateModel
        delegate: templateDelegate
        header: templateHeader
        //stop dragging of the listview: we will need to change this if more buttons used
        interactive: false
        // Set the highlight delegate. Note we must also set highlightFollowsCurrentItem
        // to false so the highlight delegate can control how the highlight is moved.
        function resize(items){
            console.log("resizing");
            templateView.height = (items * itemHeight) + headerHeight;
        }
    }

}
