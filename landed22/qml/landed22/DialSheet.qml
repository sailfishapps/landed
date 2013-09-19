import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

AUISheet {id: thisSheet

    signal numberEntered(string phoneNumber)

    width: 480
    height: 854
    Rectangle {
        anchors.fill: parent
        color: "white"

        Rectangle {id: numDisplay
            anchors {left: parent.left; right: parent.right; top: parent.top; }
            color: "black"
            height: 150;
            property int marginWidth: 10;
            property int displayWidth: width - backSpaceButton.width;
            property int totalPaintedWidth: label1.paintedWidth + label2.paintedWidth;
            property int initialFontPointSize: 100;
            property int fontPointSize: initialFontPointSize;
            property string phoneNumber: label2.text + label1.text;

            AUIButtonStyle {id: backSpaceButtonStyle
                //no backgrounds: we just want to see the icons(S) only.
                background: ""
                pressedBackground: ""
            }

            AUIButton{id: backSpaceButton
                width: 64;
                height: 32;
                //y: 50
                anchors {right: parent.right; verticalCenter: parent.verticalCenter}
                //iconSource: "assets/icon_" + (pressed ? "pressed" : "normal") + ".png"
                platformStyle: backSpaceButtonStyle;
                iconSource: "icon-m-common-backspace_" + (pressed ? "pressed" : "normal") + ".png"
                onClicked: {
                    console.log("backSpaceButton.onClicked");
                    parent.delChar();
                }
            }

            Text{ id: label1
                //This is the "cell" on the right that receives the newest digit
                anchors {right: backSpaceButton.left; top: parent.top; bottom: parent.bottom;leftMargin: parent.marginWidth; rightMargin: 0; topMargin: parent.marginWidth; bottomMargin: parent.marginWidth;}
                font.pointSize: parent.fontPointSize;
                color: "white";
                horizontalAlignment: Text.AlignRight;
                verticalAlignment: Text.AlignVCenter;
            }

            Text{ id: label2
                //This displays the previously entered digits
                anchors {right: label1.left; top: parent.top; bottom: parent.bottom; leftMargin: 0; rightMargin: parent.marginWidth; topMargin: parent.marginWidth; bottomMargin: parent.marginWidth;}
                width: parent.displayWidth - label1.width;
                font.pointSize: parent.fontPointSize;
                color: "grey";
                horizontalAlignment: Text.AlignRight;
                verticalAlignment: Text.AlignVCenter;
            }

            function addChar(p_Char) {
                console.log("label1.paintedWidth: " + label1.paintedWidth);
                label2.text = label2.text + label1.text;
                label1.text = p_Char;
                numDisplay.fontPointSize = getFontPointSize();
            }

            function delChar() {
                var len = label2.text.length;
                console.log("length: " + len);
                //find the rightmost char in label2. This moves to label1
                label1.text = label2.text.charAt(len-1);
                label2.text = label2.text.slice(0, len-1);
                numDisplay.fontPointSize = getFontPointSize();
            }

            function getFontPointSize(){
                var len = label1.text.length + label2.text.length;
                var displayWidth = numDisplay.displayWidth - numDisplay.marginWidth;
                var maxFontSize = numDisplay.initialFontPointSize;
                var magicNumber = 1.35;
                var charWidth = Math.floor(displayWidth/len);
                var fontSize = Math.floor(charWidth * magicNumber);
                fontSize = Math.min(fontSize, maxFontSize);
                //numDisplay.fontPointSize = fontSize;
                return fontSize;
            }

//            function setFontPointSizeOld(){
//                console.log("label1.width: " + label1.width);
//                console.log("label1.paintedWidth: " + label1.paintedWidth);
//                console.log("label2.width: " + label2.width);
//                console.log("label2.paintedWidth: " + label2.paintedWidth);
//                console.log("label1.font.pointSize: " + label1.font.pointSize);
//                if (totalPaintedWidth > displayWidth) {
//                    fontPointSize = fontPointSize -1;
//                    //recursive call - we may not have reduced pointSize enough yet
//                    setFontPointSize();
//                }
//            }

            function clear () {
                label1.text = "";
                label2.text = "";
                fontPointSize = initialFontPointSize;
            }
        }

        PhoneKeyPad{id: phoneKeyPad
            anchors {left: parent.left; right: parent.right; top: numDisplay.bottom; topMargin: 50;}
            height: 480;
            onKeyPressed: {
                console.log("PhoneKeyPad.onKeyPressed: " + key);
                numDisplay.addChar(key);
            }

        }

        AUIButtonStyle {id: greenButton
            background: "image://theme/color2-meegotouch-button-accent-background"+(position?"-"+position:"");

        }

        AUIButton {id: cancelButton
            anchors {left: parent.left; leftMargin: 10; top: phoneKeyPad.bottom; topMargin: 50}
            height: 50;
            width: 200;
            text: qsTr("Cancel");
            onClicked: thisSheet.reject();
        }

        AUIButton {id: okButton
            anchors {right: parent.right; rightMargin: 10; top: phoneKeyPad.bottom; topMargin: 50}
            height: 50;
            width: 200;
            text: qsTr("Ok");
            onClicked: thisSheet.accept();
            platformStyle: greenButton;
        }
    }
    onRejected: {
        numDisplay.clear();
    }

    onAccepted: {
        numberEntered(numDisplay.phoneNumber);
        numDisplay.clear();
    }

}
