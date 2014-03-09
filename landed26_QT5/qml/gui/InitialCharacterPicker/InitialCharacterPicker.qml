// Copyright (C) 2014 Chris Lamb
// This sofware is released under the MIT License --> http://en.wikipedia.org/wiki/MIT_license

import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: picker

    Component.onCompleted: {
        if ((picker.count) && (picker.count > 0)) {
            PrivateObject.populateModels();
        }
    }

    signal clicked (string character, string rowName)
    onClicked: {
        console.log("InitialPicker onClicked:" + character + ", row is: " + rowName);
        if (selectedCharacter == character) {
            console.log("the same character has been clicked again, close up")
            selectedCharacter = "";
        }
        else {
            selectedCharacter = character;
        }
        selectedRow = rowName;
    }

    property alias delegate: listView.delegate
    property alias currentIndex: listView.currentIndex
    property QtObject model

    anchors.fill: parent

    property variant characters
    property int charactersPerRow
    property string initialCharacter: ""
    property string selectedCharacter
    property string selectedRow: "none"
    property string role2Filter
    property bool caseSensitive: false
    property alias count: listView.count

    onSelectedCharacterChanged: {
        console.log("picker: onSelectedCharacterChanged: " + selectedCharacter + " filtering model")
        filteredModel.populate(picker.model, selectedCharacter);
    }

    function populate(){
        privateObject.populateModels();
    }

    QtObject {
        id: privateObject
        property variant charactersModel

        function filterMatch(field2Filter, filterCharacter) {
            //console.log("filterCharacter: " + filterCharacter)
            var left = field2Filter.trim()
            var right = filterCharacter.trim()
            if (picker.caseSensitive) {
                return (left.charAt(0) == right);
            }
            else {
                return (left.charAt(0).toUpperCase() == right.toUpperCase());
            }
        }

        function countHits4Character (character) {
            var hits = 0;
            for (var j = 0; j < model.count; j++) {

                //depends on model providing a function called value2Filteron in which returns the value to be filterdon.
                // --> still some coupling to parent element, but abstracted a bit, and made evident in example model
                var field = model.value2FilterOn(j);
                if (privateObject.filterMatch(field, character)) {
                    hits++;
                }

                /*
                //dynamic attempt (does not work (yet))
                //--> still some coupling, but all the user has to do is provide a string property, not a function.
                var rec = model.get(j);
                console.log("rec: " + rec);
                var getValue2Filter = new Function(
                            "return function foo(){ return " + rec + "." + model.role2Filter + " }"
                )();
                var value2Filter = getValue2Filter();

                console.log("field2FilterOn: " + field)
                if (value2Filter.charAt(0).toUpperCase() == character.toUpperCase()) {
                    hits++;
                }
                //end dynamic attempt
                */


                /*
                //original version, depends on model having role displayLabel
                // --> very nasty coupling of child to parent
                var rec = model.get(j);
                console.log ("rec: " + rec);
                if (rec.displayLabel.charAt(0).toUpperCase() == character.toUpperCase()) {
                    hits++;
                }
                */

            }
            return hits;
        }

        function populateModels() {
            //first count how many of each char we have in the full model
            var charsModel = []
            for (var i=0; i < characters.length; i++) {
                var character = characters[i]
                var hits = 0;
                if (characters[i] == "%") {
                    //Wildcard for all leading characters
                    hits = picker.model.count;
                }
                else if (characters[i] == "#") {
                    //Wildcard for leading numerals
                    for (var j = 0; j <= 9; j++) {
                        hits = hits + countHits4Character(j.toString());
                    }
                }
                else {
                    //normal character
                    hits = countHits4Character(character);
                }
                charsModel.push({"char": character, "hits": hits});
            }
            console.log("populateModels: length: " + charsModel.length)
            privateObject.charactersModel = charsModel;

            //Now populate the filter model
            filteredModel.clear();
            filteredModel.populate(picker.model, picker.initialCharacter);
        }
    }

    ListModel {
        id: filteredModel
        objectName: "filteredModel"
        function populate(model, filter) {
            console.log("populating filteredModel for character: " + filter)
            filteredModel.clear();
            if (filter =="") {
                //leave the model empty
            }
            else if (filter =="%") {
                //Wildcard for all entries
                console.log("don't filter, copy the model lock stock and barrel " + model.count);
                for (var i = 0; i < model.count; i ++) {
                    var rec = model.get(i);
                    filteredModel.append(rec);
                }
            }
            else if (filter =="#") {
                //Wildcard for all numeric entries
                for (var j = 0; j <= 9; j++) {
                    bulkAppend(model, j.toString());
                }
            }
            else {
                //filter on the chosen character
                bulkAppend(model, filter);
            }
            console.log("populated filteredModel with entries: " + filteredModel.count);
        }
        function bulkAppend(model, filter) {
            for (var i = 0; i < model.count; i ++) {
                var field = model.value2FilterOn(i);
                if (privateObject.filterMatch(field, filter)) {
                    //console.log("appending to filteredModel")
                    var rec = model.get(i);
                    filteredModel.append(rec);
                }
            }
        }
    }

    SilicaListView {
        id: listView
        anchors.fill: parent
        //height: childrenRect.height // don't this, it stops the listview flicking!!!!!
        model: filteredModel
        header: characterHeader
        footer: characterFooter
        clip: true
        VerticalScrollDecorator { flickable: listView }
    }

    Component{
        id: characterHeader
        CharacterGrid {
            charactersPerRow: picker.charactersPerRow
            charactersModel: privateObject.charactersModel
            //these 3 properties used to determine which character rows should be open on header or footer
            selectedCharacter: picker.selectedCharacter
            selectedRow: picker.selectedRow
            isHeader: true
            onClicked: picker.clicked(character, rowName);
        }
    }

    Component{
        id: characterFooter
        CharacterGrid {
            charactersPerRow: picker.charactersPerRow
            charactersModel: privateObject.charactersModel
            //these 3 properties used to determine which character rows should be open on header or footer
            selectedCharacter: picker.selectedCharacter
            selectedRow: picker.selectedRow
            isHeader: false //we are a footer!
            onClicked: picker.clicked(character, rowName);
        }
    }
}
