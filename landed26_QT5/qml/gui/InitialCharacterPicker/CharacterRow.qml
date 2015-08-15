// Copyright (C) 2014 Chris Lamb
// This sofware is released under the MIT License --> http://en.wikipedia.org/wiki/MIT_license

import QtQuick 2.0

Row {

    id: characterRow

    signal clicked (string character, string rowName)

    //we expect an array of characters here
    property variant characters
    onCharactersChanged: {
        //we populate the characterRow based on the characters supplied in the characters array
        //console.log("CharacterRow: onCharactersChanged: " + characters + ", isHeader: " + isHeader)
        var component;
        var characterButton;
        for (var i=0; i < characters.length; i++) {
            //console.log("adding character: " + characters[i] );
            component = Qt.createComponent("CharacterButton.qml");
            // Properties directly set are set initially only i.e. not bound to parent property.
            // An Explicit binding function is required to bind propierties of dynamic child to parent properties.
            // http://qt-project.org/doc/qt-5.0/qtqml/qml-qt.html#binding-method
            var text = characters[i].char;
            var hits = characters[i].hits;
            //console.log("char is: " + text + ", hits: " + hits + ", index: " + i  + " of: " + characters.length)
            characterButton = component.createObject(characterRow,
                                                     {"text": text,
                                                     "hits": hits,
                                                     "selectedCharacter": Qt.binding(function() { return selectedCharacter })});
            characterButton.clicked.connect(characterRow.relayClicked);
        }
    }

    function relayClicked(character) {
        //This is a workaround, because I could not get a signal to signal connect working with parameters
        characterRow.clicked(character, objectName)
    }

    property string selectedCharacter

    property string selectedRow
    onSelectedRowChanged: {
        //There are 3 cases
        //I am the selected row         --> visible in Header, Not visible in Footer
        //I am above the selected row   --> visible in Header, Not visible in Footer
        //I am below the selected row   --> visible in Footer, Not visible in Header
        //console.log (objectName + " selected row changed: " + selectedRow )
        setVisibility();
    }

    property bool isHeader: true //initially true, then overridden by binding to grid.isHeader
    //this forces a change picked up below to set inital state (footer rows not visible)

    onIsHeaderChanged: {
        //console.log ("isHeaderChanged: " + isHeader)
        if (!isHeader && (selectedCharacter=="" || selectedCharacter=="%" )) {
            visible = false;
        }
    }

    function inHeader(thisRow, selectedRow) {
        var thisRowNo = row2Num(thisRow);
        var selectedRowNo = row2Num(selectedRow);
        // if the number of this row is smaller or equal to that of the selected row, I belong in the header
        if (thisRowNo <= selectedRowNo) {
            return true
        }
        else {
            return false
        }
    }

    function row2Num(rowName) {
        return rowName.charAt(rowName.length-1);
    }

    function setVisibility() {
        //console.log("setting row visibility; selectedRow:" + selectedRow)
        if (isHeader) {
            selectedRow == "none"  || inHeader(objectName, selectedRow) ? visible = true : visible = false
        }
        else {
            inHeader(objectName, selectedRow) ? visible = false : visible = true
        }
    }

    //onVisibleChanged: console.log(objectName + " onVisibleChanged: " + visible + ", isHeader: " + isHeader + ", height: " + height + ", parent.height: " + parent.height)

    width: parent.width
    height: childrenRect.height

}



