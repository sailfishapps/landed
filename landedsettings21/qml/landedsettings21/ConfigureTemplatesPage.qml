import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "settingsDB.js" as DB

LandedPageConfigure {
    id: thisPage
    tools: commonTools

    property string group_id
    property string template_id
    property alias currentIndex: templateMVD.currentIndex

    onStatusChanged: {
        if (status == AUIPageStatus.Active) {
            var rs = DB.getMessageTemplates(group_id);
            templateMVD.headerState = (rs.rows.length == 0) ? "stateConfigureNew" : "stateConfigure";
            templateMVD.populate(rs, "configure");
        }
    }

    onBackButtonClicked: {
        console.log ("onBackButtonClicked");
        thisPage.backPage("Template", null, currentIndex, group_id, template_id, null, null);
    }

    LandedMVD {
        id: templateMVD
        fontSize: parent.fontSize
        itemHeight: parent.itemHeight
        headerHeight: parent.headerHeight
        headerText: "Templates:"
        width: parent.width
        customDelegate: ViewDelegate{
            width: templateMVD.width
            height: templateMVD.itemHeight
            text: model.name + ", " + model.id
            fontSize: templateMVD.fontSize
            onClicked:{
                console.log("templateMVD Delegate Clicked");
                templateMVD.currentIndex = index;
            }
            onDoubleClicked:{
                console.log("templateMVD Delegate Double Clicked");
                templateMVD.currentIndex = index;
            }
        }
        onNewClicked: {
            console.log ("Open the New Dialog for a new Template for the group: " + thisPage.group_id)
            thisPage.nextPage("Template", "New", null, thisPage.group_id, null, null, null);
        }
        onEditClicked: {
            console.log ("Open the Edit Dialog for an existing Template: " + templateMVD.getId())
            thisPage.nextPage("Group", "Edit", null, thisPage.group_id, templateMVD.getId(), null, null);
        }
        onDeleteClicked: {
            console.log ("Open the Delete Dialog to delete the selected Template")
            console.log("with template_id: " + templateMVD.getId());
            thisPage.nextPage("Template", "Delete", null, thisPage.group_id, templateMVD.getId(), null, null);
        }
    }
}
