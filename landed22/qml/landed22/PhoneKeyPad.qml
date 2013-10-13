import QtQuick 1.1

Item { id: thisKeyPad

    signal keyPressed (string key)

    width: 480
    property int rowHeight: 110
    property int keyPointSize

    Item { id: keyRow1
        y: 0
        height: rowHeight
        width: parent.width
        PhoneKey{id: key1
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: 0
            text: "1"
            keyPointSize: thisKeyPad.keyPointSize
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
        PhoneKey{id: key2
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: width;
            text: "2"
            keyPointSize: thisKeyPad.keyPointSize
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
        PhoneKey{id: key3
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: width*2;
            text: "3"
            keyPointSize: thisKeyPad.keyPointSize
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
    }

    Item { id: keyRow2
        y: rowHeight
        height: rowHeight
        width: parent.width
        PhoneKey{id: key4
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: 0
            text: "4"
            keyPointSize: thisKeyPad.keyPointSize
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
        PhoneKey{id: key5
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: width;
            text: "5"
            keyPointSize: thisKeyPad.keyPointSize
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
        PhoneKey{id: key6
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: width*2;
            text: "6"
            keyPointSize: thisKeyPad.keyPointSize
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
    }

    Item { id: keyRow3
        y: rowHeight*2
        height: rowHeight
        width: parent.width
        PhoneKey{id: key7
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: 0
            text: "7"
            keyPointSize: thisKeyPad.keyPointSize
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
        PhoneKey{id: key8
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: width;
            text: "8"
            keyPointSize: thisKeyPad.keyPointSize
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
        PhoneKey{id: key9
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: width*2;
            text: "9"
            keyPointSize: thisKeyPad.keyPointSize
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
    }

    Item { id: keyRow4
        y: rowHeight*3
        height: rowHeight
        width: parent.width
        PhoneKey{id: keyPlus
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: 0
            text: "+"
            keyPointSize: thisKeyPad.keyPointSize
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
        PhoneKey{id: key0
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: width;
            text: "0"
            keyPointSize: thisKeyPad.keyPointSize
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
        PhoneKey{id: keyHash
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: width*2;
            text: "#"
            keyPointSize: thisKeyPad.keyPointSize
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
    }
}
