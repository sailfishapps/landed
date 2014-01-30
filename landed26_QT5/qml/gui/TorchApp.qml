import QtQuick 2.0
//import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import GstTorch 1.0
import org.nemomobile.policy 1.0

//We don't want to bother with getting LED permissions unless the torch is really displayed (Emergency mode)
//We could even defer to point of torch being turned on, but that may delay activation
//So we could bind torch.enabled to a combination of applicationActive and thisTorch.visible

//an alternative might be to use a dynamic loader bound to by visible. This might speed up overall app start up
//See PhoneContactsPage for an example of this
//However I suggest we defer this step until it is clear if startup time is a problem,
//possibly I may want to make all (or most) pages dynamic (DynamicPage) instead of Page.
//Typically in an STP case the user will only require MainPage and SMSPage. All other pages are optonal,
//and will be visited less frequently, if at all

Item {
    id: thisTorch

    Rectangle {
        width: parent.width
        height: 120
        color: LandedTheme.BackgroundColorA
    }

    property color colorA: "#808080" // "white"
    property color colorB: "#ffffff" // "grey"

    AUIButton { id: torchButton
        anchors.left: parent.left
        //anchors.leftMargin: 10
        anchors.top: parent.top
        //anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        width: parent.width / 2
        enabled: torch.enabled
        text: torch.enabled ? "Torch On/Off" : "led permission not granted"
        //text: (torch.active) ? "Turn Torch OFF" : "Turn Torch ON"
        //primaryColor: torch.active ? colorB : colorA
        //primaryColor: colorB
        primaryColor: thisTorch.colorA
        // "#808080" // "grey" // "#ffff00" // "yellow" // "#ffffff" // "white"
        //lets try dark button when off, white when on

        onClicked: {
            //torch.active = !torch.active
            torch.toggleTorchOnOff();
        }
    }

    AUIButton { id: modeButton
        width: 100
        anchors.left: torchButton.right
        //anchors.leftMargin: 10
        anchors.right: parent.right
        //anchors.rightMargin: 10
        anchors.top: parent.top
        //anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        enabled: torch.enabled
        //text: (torch.isFlash) ? "Flash" : "Beam"
        text: torch.enabled ? "Beam / Flash" : "led permission not granted"
        //primaryColor: torch.isFlash ? "yellow" : "white";
        primaryColor: thisTorch.colorA
        onClicked: {
            //torch.toggleMode();
            torch.toggleTorchMode();
        }
    }

    Permissions {
        id: permissions
        enabled: thisTorch.visible && applicationActive //when minimized should release LED, when activated acquire LED
        onEnabledChanged: console.log("QML Permissions: onEnabledChanged: " + enabled);
        autoRelease: true
        applicationClass: "player"
        Resource {
            type: Resource.Led
            onAcquiredChanged: {
                console.log("Resource.Led: permission for LED take-off acquired: " + acquired);
            }
        }
    }

    GstTorch {
        id: torch
        enabled: permissions.acquired
        onEnabledChanged: console.log ("QML GstTorch: onEnabledChanged: qml properties bound to this should also change! " + enabled)
        lightOnEnabled: false
        onTorchOnChanged: {
            console.log("QML: onTorchOnChanged: " + torchOn);
        }
        onTorchModeChanged: {
            console.log("QML: onTorchModeChanged: " + mode)
            console.log("GstTorch: " + GstTorch.Flash)
        }
    }
}


