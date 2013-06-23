import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "settingsDB.js" as DB

LandedPageConfigure {id: thisPage

    property string group_id
    property alias currentIndex: groupMVD.currentIndex

    onStatusChanged: {
        if (status == AUIPageStatus.Active) {
            var rs = DB.getTemplateGroups();
            groupMVD.headerState = (rs.rows.length == 0) ? "stateConfigureNew" : "stateConfigure";
            groupMVD.populate(rs, "configure");
        }
    }

    onBackButtonClicked: {
        console.log ("onBackButtonClicked: group_id: " + group_id);
        thisPage.backPage("Group", null, currentIndex, group_id, null, null, null);
    }

    LandedMVD {
        id: groupMVD
        fontSize: parent.fontSize
        itemHeight: parent.itemHeight
        headerHeight: parent.headerHeight
        headerText: "Groups:"
        width: parent.width
        customDelegate: ViewDelegate{
            width: groupMVD.width
            height: groupMVD.itemHeight
            text: model.name + ", " + model.id
            fontSize: groupMVD.fontSize
            onClicked:{
                console.log("groupMVD Delegate Clicked");
                groupMVD.currentIndex = index;
            }
            onDoubleClicked:{
                console.log("groupMVD Delegate Double Clicked");
                groupMVD.currentIndex = index;
            }
        }
        onNewClicked: {
            console.log ("Open the New Dialog for a new Group")
            thisPage.nextPage("Group", "New", null, null, null, null, null);
        }
        onEditClicked: {
            console.log ("Open the Edit Dialog for an existing Group: " + groupMVD.getId())
            thisPage.nextPage("Group", "Edit", null, groupMVD.getId(), null, null, null);
        }
        onDeleteClicked: {
            console.log ("Open the Delete Dialog to delete the selected Group")
            console.log("with group_id: " + groupMVD.getId());
            thisPage.nextPage("Group", "Delete", null, groupMVD.getId(), null, null, null);
        }
    }
}
