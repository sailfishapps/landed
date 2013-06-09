import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "settingsDB.js" as DB

LandedPageConfigure {
    id: thisPage

    property string group_id
    property string template_id
    property string contact_id
    property alias currentIndex: contactMVD.currentIndex

    onStatusChanged: {
        if (status == AUIPageStatus.Active) {
            var rs = DB.getContacts(template_id);
            contactMVD.headerState = (rs.rows.length == 0) ? "stateConfigureNew" : "stateConfigure";
            contactMVD.populate(rs, "configure");
        }
    }
    onBackButtonClicked: {
        console.log ("onBackButtonClicked");
        thisPage.backPage("Contact", null, currentIndex, group_id, template_id, null, contact_id)
    }

    LandedMVD {
        id: contactMVD
        fontSize: parent.fontSize
        itemHeight: parent.itemHeight
        headerHeight: parent.headerHeight
//Commented out for Sailfish
        //backGroundColor: parent.backGroundColor
        headerText: "Contacts:"
        width: parent.width
        genericDelegate: ViewDelegate{
            width: contactMVD.width
            height: contactMVD.itemHeight
            text: model.name + ", " + model.phone + ", " + model.template_id
            fontSize: contactMVD.fontSize
            onClicked:{
                console.log("contactMVD Delegate Clicked");
                contactMVD.currentIndex = index;
            }
            onDoubleClicked:{
                console.log("contactMVD Delegate Double Clicked");
                contactMVD.currentIndex = index;
            }
        }
        onNewClicked: {
            console.log ("Open the New Dialog for a new Contact for the template: " + thisPage.template_id)
            thisPage.nextPage("Contact", "New", null, thisPage.group_id, thisPage.template_id, null, null);
        }
        onEditClicked: {
            console.log ("Open the Edit Dialog for an existing Contact: " + contactMVD.getId())
            thisPage.nextPage("Contact", "Edit", null, thisPage.group_id, thisPage.template_id, null, contactMVD.getId());
        }
        onDeleteClicked: {
            console.log ("Open the Delete Dialog to delete the selected Contact")
            console.log("with contact_id: " + contactMVD.getId());
            thisPage.nextPage("Contact", "Delete", null, thisPage.group_id, thisPage.template_id, null, contactMVD.getId());
        }
        //onPopulated:
    }

}
