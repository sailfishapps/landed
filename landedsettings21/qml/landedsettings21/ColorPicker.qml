import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

Column {
    property alias selectedColor: colorGroup.selectedColor
    spacing: 10

    function setDefaultActive(){
        colorGroup.setExclusiveActive("green");
    }

    AUILabel { id: label1
        height: 60
        text: "Template Colour";
        verticalAlignment: Text.AlignBottom
    }
    Column { id: colorGroup
        property string selectedColor
        spacing: 20
        AUICheckBox { id: checkActive
            text: "Green"
            platformStyle: greenCheck;
            onClicked: {
                parent.setExclusiveActive(text);
            }
        }
        AUICheckBox { id: checkActive2
            text: "Red"
            platformStyle: greenCheck;
            onClicked: {
                parent.setExclusiveActive(text);
            }
        }


        function setExclusiveActive(selectedColor){
            for (var i = 0; i < children.length ; i++) {
                if (children[i].text == selectedColor) {
                    console.log("Selected Object: " + children[i].text);
                    colorGroup.selectedColor = selectedColor;
                    children[i].checked = true;
                }
                else {
                    children[i].checked = false;
                }
            }
        }
    }
    GreenCheckButtonStyle { id: greenCheck
    }
}
