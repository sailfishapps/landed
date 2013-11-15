//import QtQuick 2.0
import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import LandedTorch 1.0

// move to gui, most of the backend is in C++ LandedTorch,
//consider moving the onClicked into C++
//should not flashing and torhOn be properties offered by LandedTorch?

Item {
    id: thisTorch

    property bool flashing: false
    property bool torchOn: false

    onFlashingChanged: {
        console.log ("flash mode changed");
        modeButton.primaryColor = (flashing) ? "yellow" : "white"
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
        text: (parent.torchOn) ? "Turn Torch OFF" : "Turn Torch ON"
        //text: (landedTorch.status == true) ? "Torch OFF" : "Torch ON";
        property color colorA: "#808080" // "white"
        property color colorB: "#ffffff" // "grey"
        primaryColor: colorA;

        // "#808080" // "grey" // "#ffff00" // "yellow" // "#ffffff" // "white"

        //lets try dark button when off, white when on

        function styleToggle() {
            console.log ("styleToggle: primaryColor is: " + primaryColor)
            primaryColor = (primaryColor == colorA) ? colorB : colorA;
        }

        onClicked: {
            console.log("Torch Button Clicked; torchOn: " + parent.torchOn + ", flashing: " + parent.flashing);
            console.log ("LandedTorch.flashing: " + landedTorch.flashing)
            console.log ("LandedTorch.torchOn: " + landedTorch.torchOn)
            console.log("primaryColor: " + primaryColor);
            if ((parent.torchOn == false)  && (parent.flashing == false)) {
                landedTorch.turnOn();
                parent.torchOn = true;
            }
            else if ((parent.torchOn == false)  && (parent.flashing == true)) {
                //timer will start / toggle torch
                flashTimer.start();
                parent.torchOn = true;
            }
            else {
                console.log("stopping everything");
                landedTorch.turnOff();
                flashTimer.stop();
                parent.torchOn = false;
            }
            styleToggle();
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
        primaryColor: "white";
        enabled: (parent.torchOn) ? false : true
        onClicked: {
            parent.flashing = !parent.flashing;
            //the onFlashingChanged Event handler then changes the button colour.
            //ideally we would like to set the text color to flash (when flashing,
            //and keep the button color constant)
            //perhaps via a qml coloranimation element.
            //http://qt-project.org/doc/qt-4.8/qml-coloranimation.html
        }
    }

    Timer{ id: flashTimer;
        interval: 0.75*1000;
        //interval: landedTorch.flashInterval
        repeat: true;
        triggeredOnStart: true;

        property bool flashOn: false

        onTriggered: {
            console.log("Timer triggering: flashOn: " + flashOn);
            landedTorch.torchToggle();
            flashOn = !flashOn;
        }
    }

    LandedTorch {
        id: landedTorch
    }
}


