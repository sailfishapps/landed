import QtQuick 1.1
import org.flyingsheep.abstractui.backend 1.0 //for SoundEffect
//import QtMultimediaKit 1.1

// move to gui

Rectangle { id: thisKey

    property alias text: label.text;
    property int keyPointSize

    signal keyPressed (string key)
    color: "#fafafa"

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
        color: "black"
        font.pointSize: thisKey.keyPointSize
        font.bold: true
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
