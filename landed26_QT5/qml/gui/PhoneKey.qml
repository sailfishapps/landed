import QtQuick 2.0
//import QtQuick 1.1
import org.flyingsheep.abstractui.backend 1.0 //for SoundEffect
//import QtMultimediaKit 1.1
import LandedTheme 1.0

Rectangle { id: thisKey

    property alias text: label.text;
    property int keypixelSize

    signal keyPressed (string key)
    //color: "#fafafa" //harmattan
    color: LandedTheme.BackgroundColorB

    Rectangle { id: highLight
        anchors.fill: parent
        anchors.margins: 10
        radius: 100
        color: "lightgreen"
        opacity: (keyMouseArea.pressed) ? 0.15 : 0
    }

    Text {
        id: label
        anchors.centerIn: parent;
        //color: "black" //harmattan
        color: "white" //sailfish
        font.pixelSize: thisKey.keypixelSize
        //font.bold: true //harmattan
        font.bold: false //sailfish
    }
    MouseArea { id: keyMouseArea
        anchors.fill: parent;
        onClicked: {
            console.log("Key: " + thisKey.text + ".OnClicked")
            thisBeep.play();
            parent.keyPressed(thisKey.text);
        }

    }
    AUISoundEffect {id:thisBeep
        source: beep.wav
    }

}
