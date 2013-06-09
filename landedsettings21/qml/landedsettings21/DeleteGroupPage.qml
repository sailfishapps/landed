import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "settingsDB.js" as DB

LandedPageDelete {
    id: thisPage

    property string group_id

    function fillEdits(group_id) {
        var rs = DB.getGroup(group_id);
        if (rs.rows.length > 0) {
            editName.text = rs.rows.item(0).name;
            editName.cursorPosition = editName.text.length;
        }
        else {
            editName.text = "";
        }
    }

    onStatusChanged: {
        if (status == PageStatus.Active) {
            reset(); //ensure all fields empty
            fillEdits(group_id);
        }
    }

    onSaved: {
        DB.deleteGroup(group_id);
        reset(); //ensure all fields empty the next time this page is opened
        thisPage.backPage("Group", null, null, group_id, null, null, null);
    }

    function reset () {
        editName.text = "";
    }

    LineTextEdit { id: editName
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 20
        labelText: "Group Name:"
        fontSize: thisPage.fontSize
        enabled: false
    }

    GreenCheckButtonStyle { id: greenCheck
    }
}
