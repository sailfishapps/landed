import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "settingsDB.js" as DB

LandedPageConfigure {
    id: thisPage

    property string group_id
    property string template_id
    property string tag_id
    property alias currentIndex: tagMVD.currentIndex

    onStatusChanged: {
        if (status == PageStatus.Active) {
            var rs = DB.getTags(template_id);
            tagMVD.headerState = (rs.rows.length == 0) ? "stateConfigureNew" : "stateConfigure";
            tagMVD.populate(rs, "configure");
        }
    }
    onBackButtonClicked: {
        console.log ("onBackButtonClicked");
        thisPage.backPage("Tag", null, currentIndex, group_id, template_id, tag_id, null)
    }

    LandedMVD {
        id: tagMVD
        fontSize: parent.fontSize
        itemHeight: parent.itemHeight
        headerHeight: parent.headerHeight
        headerText: "Tags:"
//Commented out for Sailfish
        //backGroundColor: parent.backGroundColor
        width: parent.width
        genericDelegate: ViewDelegate{
            width: tagMVD.width
            height: tagMVD.itemHeight
            text: model.tag_order + ", " + model.name + ", " + model.default_value + ", " + model.template_id + ", " + model.comment
            fontSize: tagMVD.fontSize
            onClicked:{
                console.log("tagMVD Delegate Clicked");
                tagMVD.currentIndex = index;
            }
            onDoubleClicked:{
                console.log("tagMVD Delegate Double Clicked");
                tagMVD.currentIndex = index;
            }
        }
        onNewClicked: {
            console.log ("Open the New Dialog for a new Tag for the template: " + thisPage.template_id)
            thisPage.nextPage("Tag", "New", null, thisPage.group_id, thisPage.template_id, null, null);
        }
        onEditClicked: {
            console.log ("Open the Edit Dialog for an existing Tag: " + tagMVD.getId())
            thisPage.nextPage("Tag", "Edit", null, thisPage.group_id, thisPage.template_id, tagMVD.getId(), null);
        }
        onDeleteClicked: {
            console.log ("Open the Delete Dialog to delete the selected Tag")
            console.log("with tag_id: " + tagMVD.getId());
            thisPage.nextPage("Tag", "Delete", null, thisPage.group_id, thisPage.template_id, tagMVD.getId(), null);
        }
        //onPopulated:
    }

}

