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

    Rectangle {
        width: parent.width
        height: 120
        color: "black"
    }

    AUIButton { id: torchButton
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        text: (landedTorch.active) ? "Turn Torch OFF" : "Turn Torch ON"
        property color colorA: "#808080" // "white"
        property color colorB: "#ffffff" // "grey"
        primaryColor: landedTorch.active ? colorB : colorA
        // "#808080" // "grey" // "#ffff00" // "yellow" // "#ffffff" // "white"
        //lets try dark button when off, white when on

        onClicked: {
            landedTorch.active = !landedTorch.active
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
        text: (landedTorch.isFlash) ? "Flash" : "Beam"
        primaryColor: landedTorch.isFlash ? "yellow" : "white";
        onClicked: {
            landedTorch.toggleMode();
        }
    }

    LandedTorch {
        id: landedTorch
    }
}


