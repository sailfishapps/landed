import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "settingsDB.js" as DB

//This page is used both to create new groups, and to edit existing groups

LandedPageNew {
    id: thisPage

    property string group_id

    onStatusChanged: {
        if (status == AUIPageStatus.Active) {
            reset(); //ensure all fields empty
        }
    }

    onSaved: {
        //TODO: 1) first we should validate if the name is unique, only then do the insert
        DB.insertGroup(editName.text, (checkActive.checked) ? 1 : 0);
        reset();
        thisPage.backPage("Group", null, null, group_id, null, null, null);
    }

    onCancelled: {
        reset();
    }

    function reset () {
        editName.text = "";
        checkActive.checked = false;
    }

    LineTextEdit { id: editName
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 20
        labelText: "Group Name:"
        fontSize: thisPage.fontSize
    }

    AUICheckBox { id: checkActive
        anchors.top: editName.bottom
        anchors.topMargin: 20
        text: "Active Group"
        platformStyle: greenCheck;
    }

    GreenCheckButtonStyle { id: greenCheck
    }
}
