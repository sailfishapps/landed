import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "settingsDB.js" as DB

//This page is used both to create new contacts, and to edit existing contacts

LandedPageNew {
    id: thisPage

    property string template_id
    property string contact_id

    onStatusChanged: {
        if (status == AUIPageStatus.Active) {
            console.log("NewContactPage active with template_id: " + template_id + ", contact_id: " + contact_id + ", action is: " + configureAction)
            if (configureAction == "New") {
                reset(); //ensure all fields empty
            }
            else if (configureAction == "Edit") {
                fillEdits(template_id, contact_id);
            }
        }
    }
    onSaved: {
        console.log ("name is now: " + editContactName.text + ", id is now: " + contact_id);
        DB.upsertContact(contact_id, template_id, editContactName.text, editContactPhone.text, (checkActive.checked) ? 1 : 0);
        reset();
        thisPage.backPage("Contact", null, null, null, template_id, null, contact_id);
    }

    onCancelled: {
        reset();
    }

    function fillEdits(template_id, contact_id) {
        var rs = DB.getContact(template_id, contact_id);
        editContactName.text = rs.rows.item(0).name;
        editContactName.cursorPosition = editContactName.text.length;
        editContactPhone.text = rs.rows.item(0).phone;
        editContactPhone.cursorPosition = editContactPhone.text.length;
        checkActive.checked = (rs.rows.item(0).active == 1) ? true : false;
    }

    function reset () {
        editContactName.text = "";
        editContactPhone.text = "";
        var rs = DB.getActiveContact(template_id);
        checkActive.checked = (rs.rows.length == 0) ? true : false;
    }

    Column {
        spacing: 20
        width: parent.width
        LineTextEdit { id: editContactName
            width: parent.width
            labelText: "Contact Name:"
            fontSize: thisPage.fontSize
        }
        LinePhoneEdit { id: editContactPhone
            width: parent.width
            labelText: "Contact Phone Nr:"
            fontSize: thisPage.fontSize
        }
        AUICheckBox { id: checkActive
            text: "Active Contact"
            platformStyle: greenCheck;
        }
    }
    GreenCheckButtonStyle { id: greenCheck}

}
