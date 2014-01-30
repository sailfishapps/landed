import QtQuick 2.0
//import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import LandedTheme 1.0

//Should also be renamed, as is not a page

Item {

    id: thisDialer

    signal numberEntered(string phoneNumber)
    signal cancelled()


    //orientationLock: AUIPageOrientation.LockPortrait

    property int keyPointSize: (simulator) ? 16 : 40
    property int displayInitialFontPointSize: (simulator) ? 42.8 : 100

    Rectangle {
        anchors.fill: parent
        //color: "white" //harmattan
        color: LandedTheme.BackgroundColorB

        Rectangle {id: numDisplay
            anchors {left: parent.left; right: parent.right; top: parent.top; }
            //color: "black" //harmattan
            color: LandedTheme.BackgroundColorA
            height: 150;
            property int marginWidth: 10;
            property int displayWidth: width - backSpaceButton.width;
            property int totalPaintedWidth: label1.paintedWidth + label2.paintedWidth;
            property int initialFontPointSize: thisDialer.displayInitialFontPointSize;
            property int fontPointSize: initialFontPointSize;
            property string phoneNumber: label2.text + label1.text;

            AUIButton{id: backSpaceButton
                width: 64;
                height: 32;
                //y: 50
                anchors {right: parent.right; verticalCenter: parent.verticalCenter}
                transparent: true
                iconSource: "icons/icon-m-common-backspace_" + (pressed ? "pressed" : "normal") + ".png"
                onClicked: {
                    console.log("backSpaceButton.onClicked");
                    parent.delChar();
                }
            }

            //NOTE:
            //We have 2 Text elements to allow for a two coloured disply
            //the newest digit is white, "older" digits are grey
            Text{ id: label1
                //This is the "cell" on the right that receives the newest digit
                anchors {right: backSpaceButton.left; top: parent.top; bottom: parent.bottom;leftMargin: 0; rightMargin: parent.marginWidth; topMargin: parent.marginWidth; bottomMargin: parent.marginWidth;}
                font.pointSize: parent.fontPointSize;
                color: "white";
                horizontalAlignment: Text.AlignRight;
                verticalAlignment: Text.AlignVCenter;
            }

            Text{ id: label2
                //This displays the previously entered digits
                anchors {right: label1.left; top: parent.top; bottom: parent.bottom; leftMargin: parent.marginWidth; rightMargin: 0; topMargin: parent.marginWidth; bottomMargin: parent.marginWidth;}
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
                //1.35 for normal N9, 0.54 for simulator
                //var magicNumber = (simulator) ? 0.54 : 1.35;
                //for Sailfish something around 1.18 hits the spot
                var magicNumber = 1.18
                var charWidth = Math.floor(displayWidth/len);
                var fontSize = Math.floor(charWidth * magicNumber);
                console.log("charWidth: " + charWidth + ", " + "fontSize: " + fontSize)
                fontSize = Math.min(fontSize, maxFontSize);
                return fontSize;
            }

            function clear () {
                label1.text = "";
                label2.text = "";
                fontPointSize = initialFontPointSize;
            }
        }

        PhoneKeyPad{id: phoneKeyPad
            anchors {left: parent.left; right: parent.right; top: numDisplay.bottom; topMargin: 40;}
            height: 440;
            keyPointSize: thisDialer.keyPointSize
            onKeyPressed: {
                console.log("PhoneKeyPad.onKeyPressed: " + key);
                numDisplay.addChar(key);
            }
        }

        AUIButton {id: cancelButton
            anchors {left: parent.left; leftMargin: 10; top: phoneKeyPad.bottom; topMargin: 15}
            height: 80;
            width: 200;
            text: qsTr("Cancel");
            primaryColor: "#808080" //"grey"
            onClicked: {
                //thisSheet.reject();
                numDisplay.clear();
                cancelled();
            }
        }

        AUIButton {id: okButton
            anchors {right: parent.right; rightMargin: 10; top: phoneKeyPad.bottom; topMargin: 15}
            height: 80;
            width: 200;
            text: qsTr("Ok");
            primaryColor: "#008000" //"green"
            onClicked: {
                //thisSheet.accept();
                numberEntered(numDisplay.phoneNumber);
                numDisplay.clear();
            }
        }
    }
}
