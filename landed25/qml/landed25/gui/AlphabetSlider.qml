import QtQuick 1.1
import com.nokia.meego 1.0
import "../backend"

Item {
    id: alphabetSlider

    signal initialChanged(string initial, int index);

    property alias barWidth: verticalbar.width;
    property alias sliderVisible: slider.visible
    property LeadingCharacterModel alphabetModel

    function resetOpacity() {
        opacityAnimation.running = true;
        //opacity = 1
        //verticalbar.opacity = 0.5
        //slider.opacity = 0.75
        console.log("verticalbar.opacity: " + verticalbar.opacity)
        console.log("slider.opacity: " + slider.opacity)
        console.log("opacity: " + opacity)
    }


//TODO:
//consider adding states with transitions
//in some cases we want a slow transition, in other cases immediate
//problem is color / visibility of slider bar.

    Rectangle {
        id: verticalbar
        height: parent.height
        width: 75
        anchors.right: parent.right
        color: "white"
        opacity: 0.50
        property alias mouseY: verticalMouse.mouseY

        property int step: getStep(verticalMouse.mouseY, height, alphabetModel.count)

        function getStep(mouseY, screenHeight, steps) {
            if (steps > 0) {
                var tempScreenHeight = screenHeight - slider.fingerOffset();
                var tempMouseY = Math.min(tempScreenHeight, Math.max(0, mouseY - slider.fingerOffset()));
                var ret = Math.ceil((tempMouseY / (tempScreenHeight)) * steps);
                //console.log("mouseY: " + tempMouseY + ", height: " + tempScreenHeight + ", steps: " + steps +", step: " + ret);
                return ret;
            }
            else {
                return -1;
            }
        }

        MouseArea {
            id: verticalMouse
            anchors.fill: parent
            onPressed: {
                verticalbar.color = "lightgrey"
                slider.visible = true
                forceActiveFocus(slider)
            }
            onReleased: {
                sliderAnimation.running = true;
                barAnimation.running = true;
            }
        }
    }

    PropertyAnimation { id: opacityAnimation; target: alphabetSlider; property: "opacity"; to: 1; duration: 750; easing.type: Easing.InExpo }
    PropertyAnimation { id: sliderAnimation; target: slider; property: "visible"; to: false; duration: 250 }
    PropertyAnimation { id: barAnimation; target: verticalbar; property: "color"; to: "white"; duration: 250 }

    Rectangle {
        id: slider
        width: parent.width
        height: 140
        //color: "lightsteelblue"
        color: "black"
        opacity: 0.75
        visible: false
        y: topY
        property alias drag: mouseArea.drag
        property int fingerY : verticalbar.mouseY
        //topY is the top of the slider, which is above the finger moving the slider!
        property int topY: getTopY(fingerY)
        property string initial: visible ? alphabetModel.get(verticalbar.step).character : ""
        onInitialChanged: {
            if (initial.length > 0)
            {
                var index = alphabetModel.get(verticalbar.step).index
                alphabetSlider.initialChanged(initial, index);
            }
        }
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: slider.initial
            font.pointSize: 70
            color: "white"
            opacity: 1
        }
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            drag.axis: Drag.YAxis
            drag.target: slider
            drag.minimumY: 0
            drag.maximumY: alphabetSlider.height-slider.height
            onReleased: slider.visible = false
        }
        function getTopY(mouseY) {
            //we want the slider to be vertically centred on mouseY.
            var ret = mouseY - (slider.height /2);
            ret = Math.max(slider.drag.minimumY, Math.min(slider.drag.maximumY, ret));
            return ret;
        }
        function fingerOffset() {
            return height / 2;
        }
    }
}
