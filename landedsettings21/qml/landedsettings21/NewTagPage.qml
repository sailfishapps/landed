import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "settingsDB.js" as DB

//This page is used both to create new tags, and to edit existing tags

LandedPageNew {
    id: thisPage

//TODO: In this first version, new tags will be added after existing tags
//future versions should allow tags to be added between existing tags / tags to be reordered

    property string template_id
    property string tag_id

    onStatusChanged: {
        if (status == AUIPageStatus.Active) {
            console.log("NewTagPage active with template_id: " + template_id)
            reset(); //ensure all fields empty
        }
    }

    onSaved: {
        console.log ("name is now: " + editTagName.text);
        DB.upsertTag(tag_id, template_id, editTagName.text, editPlaceholder.text, editComment.text, editTagOrder.text);
        reset();
        thisPage.backPage("Tag", null, null, null, template_id, tag_id, null);
    }

    onCancelled: {
        reset();
    }

    function reset () {
        editTagName.text = "";
        editPlaceholder.text = "";
        editComment.text = "";
        editTagOrder.text = "";
    }

    Column {
        spacing: 20
        width: parent.width
        LineTextEdit { id: editTagName
            width: parent.width
            labelText: "Tag Name:"
            fontSize: thisPage.fontSize
        }
        LineTextEdit { id: editPlaceholder
            width: parent.width
            labelText: "Placeholder / Default Text:"
            fontSize: thisPage.fontSize
        }
        LineTextEdit { id: editComment
            width: parent.width
            labelText: "Comment:"
            fontSize: thisPage.fontSize
        }
//TODO: replace this with a numeric control
        LineTextEdit { id: editTagOrder
            width: parent.width
            labelText: "Order:"
            fontSize: thisPage.fontSize
        }
    }
    GreenCheckButtonStyle { id: greenCheck}

}
