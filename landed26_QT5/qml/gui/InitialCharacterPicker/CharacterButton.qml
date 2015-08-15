// Copyright (C) 2014 Chris Lamb
// This sofware is released under the MIT License --> http://en.wikipedia.org/wiki/MIT_license

import QtQuick 2.0
import LandedTheme 1.0

Text {
    id: characterButton

    signal clicked (string character)

    property int hits

    property string selectedCharacter

    onSelectedCharacterChanged: {
        //console.log("CharacterButton: " + text + " selectedCharacter changed to: " + selectedCharacter)
        if (selectedCharacter == text) {
            //console.log("highlighting characterButton: " + text)
            backgroundRect.opacity = selectedOpacity
            characterButton.color = selectedColor
        }
        else {
            //console.log("unhighlighting characterButton: " + text)
            backgroundRect.opacity = normalOpacity;
            characterButton.color = (hits > 0) ? normalColor : emptyColor;
        }
    }

    property color emptyColor: "darkgrey"
    property color normalColor: "white"
    property color selectedColor: "lightblue"
    property real normalOpacity: 0.25
    property real selectedOpacity: 0.1

    width : parent.width / 5
    font.pixelSize: LandedTheme.FontSizeVeryLarge
    font.weight: Font.Light
    color: (hits > 0) ? normalColor : emptyColor
    horizontalAlignment: Text.AlignHCenter
    MouseArea {
        anchors.fill: parent
        enabled: (characterButton.hits > 0)
        onClicked: {
            //console.log("characterButton" + parent.text + " onClicked:")
            characterButton.clicked(parent.text)
        }
    }

    Rectangle {
        id: backgroundRect
        anchors.fill: parent
        color: "grey"
        opacity: normalOpacity
    }
}
