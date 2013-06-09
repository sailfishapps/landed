import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "settingsDB.js" as DB

LandedPageDelete {
    id: thisPage

    property string template_id
    property string contact_id

    function fillEdits(contact_id) {
        var rs = DB.getContact(contact_id);
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
            fillEdits(contact_id);
        }
    }

    onSaved: {
        DB.deleteContact(template_id, contact_id);
        reset(); //ensure all fields empty the next time this page is opened
        thisPage.backPage("Contact", null, null, null, template_id, null, contact_id);
    }

    function reset () {
        editName.text = "";
    }

    LineTextEdit { id: editName
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 20
        labelText: "Contact Name:"
        fontSize: thisPage.fontSize
        enabled: false
    }

    GreenCheckButtonStyle { id: greenCheck
    }
}
