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
        primaryColor: "white";
        onClicked: {
            console.log("mode is: " + landedTorch.mode )
            console.log("landedTorch.isBeam: " + landedTorch.isBeam);
            console.log("landedTorch.isFlash: " + landedTorch.isFlash);
            landedTorch.toggleMode();
            console.log("mode is: " + landedTorch.mode )
            console.log("landedTorch.isBeam: " + landedTorch.isBeam);
            console.log("landedTorch.isFlash: " + landedTorch.isFlash);
        }
    }

    LandedTorch {
        id: landedTorch
        /*
        onActiveChanged: {console.log ("somebody has changed active! " + landedTorch.active)}
        onTorchOnChanged: {console.log("somebody has changed torchOn! " + landedTorch.torchOn + " " + Qt.formatDateTime(new Date(), "yyyy:MM:dd hh.mm.sss.zzz"))}
        onIsFlashChanged: {console.log("somebody changed isFlash! " + landedTorch.isFlash)}
        onIsBeamChanged: {console.log("somebody changed isBeam! " + landedTorch.isBeam)}
        onFlashTimeChanged: {console.log("flashTimeChanged: " + landedTorch.flashTime) }
        */
    }
}


