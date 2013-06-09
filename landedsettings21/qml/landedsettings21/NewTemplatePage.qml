import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "settingsDB.js" as DB

//This page is used both to create new templates, and to edit existing templates

LandedPageNew {
    id: thisPage

    property string group_id
    property string template_id

    onStatusChanged: {
        if (status == PageStatus.Active) {
            console.log("NewTemplatePage active with group_id: " + group_id)
            reset(); //ensure all fields empty
        }
    }

    onSaved: {
        //TODO: 1) first we should validate if the name is unique, only then do the insert
        console.log ("Inserting group with values: group_id: " + group_id + ", name: " + editName.text);
        DB.insertTemplate(group_id, editName.text, editButtonLabel.text, colorPicker.selectedColor);
        reset();
        thisPage.backPage("Template", null, null, group_id, template_id, null, null);
    }

    onCancelled: {
        reset();
    }

    function reset () {
        editName.text = "";
        editButtonLabel.text ="";
        colorPicker.setDefaultActive();
    }

    Column {
        spacing: 20
        width: parent.width
        LineTextEdit { id: editName
            width: parent.width
            labelText: "Template Name:"
            fontSize: thisPage.fontSize
        }
        LineTextEdit { id: editButtonLabel
            width: parent.width
            labelText: "Template Button Label:"
            fontSize: thisPage.fontSize
        }
        ColorPicker { id: colorPicker
        }
    }


}
