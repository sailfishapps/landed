landed
======

An app for paraglider pilots to send GPS coords via SMS to a recovery team using a few button pushes only.

Development / Migration Status:

landed26_QT5 is the latest version for Sailfish Qt5, and is the lead version. It is 95% ported. All the important things are functional, and it even looks Sailfishy. Small things need polishing

landed25 is the fully functional version for Harmattan. It will be the last major verison on that platform. I may release a Landed26 to backport refactorings from future Sailfish versions

Development on landedSettings is currently suspended. In the short to medium term I intend to develop a Qt Desktop application to provide the same functionality.

LandedCreateDB is a temporary app that installs a demo LocalStorageDB used by Landed. The script used is initiateDB.js, so this file can be altered to configure the Database.


Follow progress on my blog: http://flyingsheeponsailfish.blogspot.ch/


Purpose:

The Landed app is intended for a paraglider pilot flying cross-country to easily transmit his GPS coordinates via SMS to a recovery team.

The app is intended to be used "in action" with a bare minimum of button presses. The thinking behind this is that the pilot may be in the best case tired, and in the worse case hanging from a tree! So the app has to be very simple to use, with any "hard work" done beforehand.

To achieve this we use prefilled SMS templates. On landing the Pilot just choses the most appropriate template, and presses send. The GPS coordinates are automatically added to the placeholders in the template, and an SMS is sent to the contact associated with the template.

So there is no cutting and pasting or copying of GPS co-ordinates with all the possibilities of transposing digits, and no scrolling through long lists of contacts.

The templates and associated contacts are setup in the sidekick app LandedSettings, more of which below.


Data Model.

The top level entity is "Group" (will probably be renamed to Area or Zone). A Group equates to an area where I frequently fly (e.g. Switzerland, Greece, South Africa).

Each Group is the parent of two SMS Templates, one normal Recovery SMS Template, and one emergency "Help me!" SMS Template. A Template is the text body that will be sent.

Each Template is the the parent of several "Tags": these are placeholders that will be replaced by values from the GPS Location (e.g. Latittude, Longitude).

Each Template is the parent of several "Contacts", one of which is the default.

Hot-of-the-press (2014-02-11), data can be stored in both a LocalStorageDB, and (new) in a json file queried by jsonpath.


Using Landed:

When Landed starts, it automatically fires up the GPS. When the location is found, the nearest "Group" is selected, and the SMS Buttons are activated, allowing the sending of either a normal Recovery SMS, or an emergency "Help Me!" SMS.

The user can:
1) change the "Group" by clicking on the "Group" header between the GPS Display and the SMS buttons.
2) edit the SMS text to add more information to the default text.
3) change the preselected contact, by pressing on the displayed contact. This opens a Contact Selection page with three tabs:
3.1) Favourite Contacts: from the LocalStorageDb
3.2) A Dialer, allowing a number to be dialed.
3.3.) PhoneContactPage: allowing the phones contacts pages to be selected (this bit is not fully ported on Sailfish, coming soon).
4) On the Emergency SMS a torch is available to signal with beam or flash (e.g. to a helicopter).


Safety / Legal:

We give no warranty or guarantee that this app will actually work. If you are in a new location, please please test it with your recovery. Check that the coords transmitted make sense, and you and your recovery agree that you know where you are! I have not been able to test this app "all over the world", so I cannot totally eliminate the possibility that there maybe an error in the coordinates algorithm!

For the app to work you will need both GPS reception, and Cell-phone signal


Requirements:

Both Landed and LandedSettings require:

1) AbstractUI Abstraction Library.
The Harmattan version can be found here: https://github.com/harmattan/AbstractUI-for-Harmattan

The Sailfish version can be found here: https://github.com/sailfishapps/AbstractUI-for-Sailfish-Silica

Make sure you install the correct version for your platform! This is where the magic takes place handling differences between Harmattan and Sailfish, so the wrong version won't get you anywhere!

2) The Sailfish yaml file for Landed should help install all the bits Landed requires, but it is hard to keep track of what is installed as default, in the course of development, added by playing-around, or instaling 3rd Party apps.
Some of the dependencies are:
Telepathy
Gstreamer,
QtPositioning
QtSensors
LocalStorage
