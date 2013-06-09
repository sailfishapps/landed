import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "settingsDB.js" as DB

LandedPageDelete {
    id: thisPage

    property string group_id
    property string template_id

    function fillEdits(template_id) {
        var rs = DB.getTemplate(template_id);
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
            fillEdits(template_id);
        }
    }

    onSaved: {
        console.log ("About to delete template with group_id: " + group_id + ", template_id: " + template_id)
        DB.deleteTemplate(group_id, template_id);
        reset(); //ensure all fields empty the next time this page is opened
        thisPage.backPage("Template", null, null, group_id, template_id, null, null);
    }

    function reset () {
        editName.text = "";
    }

    LineTextEdit { id: editName
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 20
        labelText: "Template Name:"
        fontSize: thisPage.fontSize
        enabled: false
    }

    GreenCheckButtonStyle { id: greenCheck
    }
}
