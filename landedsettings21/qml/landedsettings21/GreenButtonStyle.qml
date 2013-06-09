import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

AUIButtonStyle {id: greenButton
    background: "image://theme/color2-meegotouch-button-accent-background"+(position?"-"+position:"");
    pressedBackground: "image://theme/color2-meegotouch-button-accent-background-pressed";
}
