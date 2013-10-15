import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

AUICheckBoxStyle {id: greenCheckButton
    backgroundPressed: "image://theme/color2-meegotouch-button-checkbox-inverted-background-pressed";
    backgroundSelected: "image://theme/color2-meegotouch-button-checkbox-inverted-background-selected";
    backgroundDisabled: "image://theme/color2-meegotouch-button-checkbox-inverted-background-disabled";
}
