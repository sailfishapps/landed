landed
======

An app for paraglider pilots to send GPS coords via SMS to a recovery team using a few button pushes only.

Development Status:
Landed, LandedSettings, and AbstractUI are all very much work-in-progress and not finished! This is why I have not published the code of Landed until now: but realising very likely they never will be finished as I find new things to add, improve, and play around with, has triggered me to "publish and be dammed".

Follow progress on my blog: http://flyingsheeponsailfish.blogspot.ch/


Purpose:
The Landed app is intended for a paraglider pilot flying cross-country to easily transmit his GPS coordinates via SMS to a recovery team.

The app is intended to be used "in action" with a bare minimum of button presses. The thinking behind this is that the pilot may be in the best case tired, and in the worse case hanging from a tree! So the app has to be very simple to use, with any "hard work" done beforehand.

To achieve this we use prefilled SMS templates. On landing the Pilot just choses the most appropriate template, and presses send. The GPS coordinates are automatically added to the placeholders in the template, and an SMS is sent to the contact associated with the template.

So there is no cutting and pasting or copying of GPS co-ordinates with all the possibilities of transposing digits, and no scrolling through long lists of contacts.

The templates and associated contacts are setup in the sidekick app LandedSettings, more of which below.


LandedSettings:
In a future version this may be fully integrated into Landed. For now it is a separate app.

The templates setup in LandedSettings can be grouped into "Groups". By my way of thinking a Group equates to a location where I frequently fly - with the idea that I want to have different templates (maybe with different languages) and different contacts attached to these based on the locations. So in my example I have a "Group" for Switzerland, South Africa and Greece respectively.

For each of these I have a "Status Ok" and and a "Status NOT Ok" template:: While these are functionally identical, the status OK is intended for use after a normal landing, and indicates to recovery to "come and get me some time", while the "Status NOT Ok" is intended for use when you are hanging from the proverbial tree or worse, and indicates that help is required!

Landed:
When Landed starts, it automatically fires up the GPS. When the location is found, the Button "Create SMS" is activated.
Pressing the Create SMS button pops the "SMS Selection" Page, showing the SMS templates for the current Group / Location. The Group / Location can be changed by clicking on the header.
Pressing one of the SMS buttons opens the SMS page, with the SMS text built from the selected template with the GPS coords added. Then all you have to do is press send!

If the SMS Page is opened for a NOT Ok SMS, then in addition to the SMS functionality, a torch is available at the top of the page. This allows you to shine and flash the camera flash LEDs to help that big red helicopter find you at night. This function was added based on real world experience …

Status:
Both Apps are work in progress, and probably always will be as I find new things to add, or better ways of doing things.
The core functionality of Landed is up and running: here I just have to make things slicker and even easier (e.g. integrate the phone's contacts).
LandedSettings still needs a little more work so that all the add / new / edit functionality works.
Both Apps are in the midst of a Harmattan to Sailfish migration using the AbstractUI abstraction library, which has been my main focus for the past few weeks.


Safety / Legal:
We give no warranty of guarantee that this app will actually work. If you are in a new location, please please test it with your recovery. Check that the coords transmitted make sense, and you and your recovery agree that you know where you are! I have not been able to test this app "all over the world", so I cannot totally eliminate the possibility that there maybe an error in the coordinates algorithm!

For the app to work you will need both GPS reception, and Cell-phone signal

Requirements:
Both Landed and LandedSettings require:
1) AbstractAUI abstraction Library.
The Harmattan version can be found here: https://github.com/harmattan/AbstractUI-for-Harmattan
The Sailfish version can be found here: https://github.com/sailfishapps/AbstractUI-for-Sailfish-Silica
Make sure you install the correct version for your platform! This is where the magic takes place handling differences between Harmattan and Sailfish, so the wrong version won't get you anywhere!

2) Qt-Components (com.nokia.meego)
These are installed as standard on Harmattan.
On Sailfish you will need to install these as instructed here: http://flyingsheeponsailfish.blogspot.ch/2013/05/adding-additional-qt-packages-to.html
When the AbstractUI is more mature we may be able to completely remove Sailfish dependancies on this package, but for the moment we need it.

3) SQlite
Is available "out-of-the-box" on Harmattan (at least on my N9)
Can be installed to Sailfish as instructed here. http://flyingsheeponsailfish.blogspot.ch/2013/05/adding-additional-qt-packages-to.html

First Time Use
Fire up LandedSettings first, to setup the templates.
You may have to Initiate and refresh the DB first (via PullUPMenu), soon I will automate this.
As the new / edit / delete functionality is not yet fully working you may have to cheat and resort to editing the initiateDB.js in LandedSettings.
Once you have your templates and contacts setup, then these should be available when you start Landed.
Please test the GPS coords shown make sense, before you send your recovery team off to the South Pole!


Strange Behaviours:
1) Harmattan Device in SDK mode vs from the Device itself.
If you setup and configure the settings DB in SDK mode on Harmttan (as I do when developing), these settings will not be available when firing up the app from the device itself (non sdk mode). I guess this is down to differences in users between SDK and non SDK mode.


