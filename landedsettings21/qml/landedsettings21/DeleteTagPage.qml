import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "settingsDB.js" as DB

LandedPageDelete {
    id: thisPage

    property string template_id
    property string tag_id

    function fillEdits(tag_id) {
        var rs = DB.getTag(tag_id);
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
            fillEdits(tag_id);
        }
    }

    onSaved: {
        console.log ("About to delete tag with template_id: " + template_id + ", tag_id: " + tag_id)
        DB.deleteTag(template_id, tag_id);
        reset(); //ensure all fields empty the next time this page is opened
        thisPage.backPage("Tag", null, null, null, template_id, tag_id, null);
    }

    function reset () {
        editName.text = "";
    }

    LineTextEdit { id: editName
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 20
        labelText: "Tag Name:"
        fontSize: thisPage.fontSize
        enabled: false
    }

    GreenCheckButtonStyle { id: greenCheck
    }
}
