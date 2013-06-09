import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "settingsDB.js" as DB

LandedPageConfigure {
    id: thisPage

    property string group_id
    property string template_id
    property string contact_id

    function fillEdits(template_id) {
        var rs = DB.getContacts(template_id);
        if (rs.rows.length > 0) {
            editContactName.text = rs.rows.item(0).name;
            editContactName.cursorPosition = editContactName.text.length;
            editContactPhone.text = rs.rows.item(0).phone;
            editContactPhone.cursorPosition = editContactPhone.text.length;
            contact_id = rs.rows.item(0).contact_id;
        }
        else {
            editContactName.text = "";
            editContactPhone.text = "";
            contact_id = "";
        }
    }

    onStatusChanged: {
        if (status == PageStatus.Active) {
            fillEdits(template_id);
        }
    }

    onSaved: {
        console.log ("name is now: " + editContactName.text);
        DB.upsertContact(contact_id, template_id, editContactName.text, editContactPhone.text);
    }

    LineTextEdit { id: editContactName
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 20
        labelText: "Contact Name:"
        fontSize: thisPage.fontSize
    }

    LinePhoneEdit { id: editContactPhone
        width: parent.width
        anchors.top: editContactName.bottom
        anchors.topMargin: 40
        labelText: "Contact Phone Nr:"
        fontSize: thisPage.fontSize
    }
}
