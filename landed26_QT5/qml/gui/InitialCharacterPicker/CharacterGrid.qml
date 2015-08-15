// Copyright (C) 2014 Chris Lamb
// This sofware is released under the MIT License --> http://en.wikipedia.org/wiki/MIT_license

import QtQuick 2.0

Column {
    id: grid

    property variant characters
    property variant charactersModel
    property int charactersPerRow
    property string selectedCharacter
    property string selectedRow
    property bool isHeader: false

    //onCharactersChanged: createRows()
    onCharactersModelChanged: createRows()
    onCharactersPerRowChanged: createRows()

    signal clicked (string character, string rowName)
    function resetGrid() {
        console.log("resetting grid")
        for(var i = grid.children.length; i > 0 ; i--) {
          grid.children[i-1].destroy()
        }
    }

    function createRows() {
        console.log("CharacterGrid; rows already in grid: " + grid.children.length);
        if (grid.children.length > 0) {
            //if the grid already exists, due to a previous onContactsChanged signal, we need to destroy
            //existing child rows
            resetGrid();
        }
        if (charactersModel && charactersPerRow) {
            //we instantiate the rows based on the characters supplied in the characters array
            var component;
            var characterRow;
            var noRows = Math.ceil(charactersModel.length / grid.charactersPerRow)
            console.log("dynamically creating " + noRows + " rows of " + grid.charactersPerRow + " for " + charactersModel.length + " chars")
            for (var i=1; i <= noRows; i++) {
                var rowName = "row" + i;
                var rowChars = chars4Row(i);
                component = Qt.createComponent("CharacterRow.qml");
                // Properties directly set are set initially only i.e. not bound to parent property.
                // An Explicit binding function is required to bind propierties of dynamic child to parent properties.
                // http://qt-project.org/doc/qt-5.0/qtqml/qml-qt.html#binding-method
                characterRow = component.createObject(grid, {"objectName": rowName,
                                                          "characters": rowChars,
                                                          "selectedCharacter": Qt.binding(function() { return selectedCharacter }),
                                                          "selectedRow": Qt.binding(function() { return selectedRow }),
                                                          "isHeader": grid.isHeader});
                characterRow.clicked.connect(grid.relayClicked);
            }
        }
        else {
            console.log("all properties must be defined")
            console.log("charactersModel: " + charactersModel)
            console.log("charactersPerRow: " + charactersPerRow + ", selectedCharacter: " + selectedCharacter + ", selectedRow: " + selectedRow + ", isHeader: " + isHeader )
        }
    }

    function relayClicked(character, row) {
        //This is a workaround, because I could not get a signal to signal connect working with parameters
        grid.clicked(character, row)
    }

    function chars4Row(row) {
        var ret = []
        var firstCharPos = ((row -1) * grid.charactersPerRow)
        //the last row may be shorter
        var lastCharPos = Math.min(((row * grid.charactersPerRow) - 1), (charactersModel.length - 1))
        //console.log("firstCharPos: " + firstCharPos + ", lastCharPos: " + lastCharPos)
        for(var i=firstCharPos; i <= lastCharPos; i++) {
            ret.push(grid.charactersModel[i]);
        }
        return ret;
    }

    width: picker.width
    move: Transition {
             NumberAnimation {
                 properties: "y"
                 //easing.type: Easing.OutBounce
                 //easing.type: Easing.InOutCirc
                 easing.type: Easing.OutCirc
             }
         }
}
