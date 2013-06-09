import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

LandedPage {
    GreenButtonStyle {id: greenButton
    }

    AUIButton {id: cancelButton
        anchors {left: parent.left; leftMargin: 10; bottom: parent.bottom; bottomMargin: 25}
        width: (parent.width - (3 * buttonMargin)) / 2;
        height: buttonHeight;
        text: qsTr("Cancel");
        //platformStyle: greenButton;
        onClicked: {
            cancelled();
        }
    }

    AUIButton {id: saveButton
        anchors {left: cancelButton.right; leftMargin: 10; right: parent.right; rightMargin: 10; bottom: parent.bottom; bottomMargin: 25}
        height: buttonHeight;
        text: qsTr("Save");
        platformStyle: greenButton;
        onClicked: {
            saved();
        }
    }
}
