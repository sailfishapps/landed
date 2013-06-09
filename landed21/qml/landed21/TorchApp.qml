import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import LandedTorch 1.0


Item {
    id: thisTorch

    property bool flashing: false
    property bool torchOn: false

    onFlashingChanged: {
        console.log ("flash mode changed");
        modeButton.platformStyle = (flashing) ? yellowButtonStyle : whiteButtonStyle;
    }

    Rectangle {
        width: parent.width
        height: 120
        color: "black"
    }

    AUIButton { id: torchButton
        anchors.left: parent.left
        anchors.leftMargin: 10
        //anchors.right: parent.right
        //anchors.rightMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        text: "Toggle Torch ON / OFF"
        //text: (landedTorch.status == true) ? "Torch OFF" : "Torch ON";
        platformStyle: whiteButtonStyle;

        function styleToggle() {
            platformStyle = (platformStyle == whiteButtonStyle) ? yellowButtonStyle : whiteButtonStyle;
        }

        onClicked: {
            console.log("Torch Button Clicke; torchOn: " + parent.torchOn + ", flashing: " + parent.flashing);
            if ((parent.torchOn == false)  && (parent.flashing == false)) {
                landedTorch.torchOn();
                parent.torchOn = true;
            }
            else if ((parent.torchOn == false)  && (parent.flashing == true)) {
                //timer will start / toggle torch
                flashTimer.start();
                parent.torchOn = true;
            }
            else {
                console.log("stopping everything");
                landedTorch.torchOff();
                flashTimer.stop();
                parent.torchOn = false;
                torchButton.platformStyle = whiteButtonStyle;
            }
        }

    }

    AUIButton { id: modeButton
        width: 100
        anchors.left: torchButton.right
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        text: (parent.flashing) ? "Flash" : "Beam"
        //due to a bug, we can't change platformStyle: by bindings
        //platformStyle: (parent.flashing) ? yellowButtonStyle : whiteButtonStyle;
        platformStyle:  whiteButtonStyle;
        onClicked: {
            parent.flashing = !parent.flashing;
        }

    }

    WhiteButtonStyle {id: whiteButtonStyle}
    YellowButtonStyle {id: yellowButtonStyle}

    Timer{ id: flashTimer;
        interval: 0.75*1000;
        repeat: true;
        triggeredOnStart: true;

        property bool flashOn: false

        onTriggered: {
            console.log("Timer triggering: flashOn: " + flashOn);
            landedTorch.torchToggle();
            torchButton.styleToggle();
            flashOn = !flashOn;
        }
    }

    LandedTorch {
        id: landedTorch
    }
}


