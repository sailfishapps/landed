# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = landed26_QT5

CONFIG += sailfishapp

QT += multimedia dbus positioning sensors
# QT += location not recognised

PKGCONFIG += TelepathyQt5
PKGCONFIG += gstreamer-0.10

HEADERS += \
        src/telepathyhelper.h \
        src/windowingsystem.h \
        src/operatingsystem.h \
        src/landedtorch.h \
        src/satinfosource.h \
    src/gsttorch.h \
    src/landedtheme.h \
    src/jsonstorage.h \
    src/conversationchannel.h

SOURCES += src/landed26_QT5.cpp \
        src/landedtorch.cpp \
        src/telepathyhelper.cpp \
        src/satinfosource.cpp \
    src/gsttorch.cpp \
    src/jsonstorage.cpp \
    src/conversationchannel.cpp

# qml.files = qml/gui qml/backend

OTHER_FILES += qml/landed26_QT5.qml \
    qml/cover/CoverPage.qml \
    rpm/landed26_QT5.spec \
    rpm/landed26_QT5.yaml \
    landed26_QT5.desktop \
    qml/gui/MainPage.qml \
    qml/gui/GPSDisplay.qml \
    qml/gui/TemplateButtons.qml \
    qml/gui/RumbleEffect.qml \
    qml/gui/TemplateButtonsHeader.qml \
    qml/gui/TemplateButtonsDelegate.qml \
    qml/backend/GPSBackEnd.qml \
    qml/backend/SMSTemplateListModel.qml \
    qml/javascript/landed.js \
    qml/gui/SimpleHeader.qml \
    qml/gui/SMSPage.qml \
    qml/gui/TorchApp.qml \
    qml/gui/SMSDisplay.qml \
    qml/backend/SMSBackEnd.qml \
    qml/backend/FavouriteContactsBackEnd.qml \
    qml/gui/SMSTextEdit.qml\
    qml/javascript/message.js \
    qml/gui/GreenCheckButtonStyle.qml \
    qml/gui/ContactSelectionPage.qml \
    qml/gui/FavouriteContactsPage.qml \
    qml/gui/PhoneDialer.qml \
    qml/gui/ContactRadioButtons.qml \
    qml/backend/ContactListModel.qml \
    qml/gui/ContactButtonsDelegate.qml \
    qml/gui/PhoneKeyPad.qml \
    qml/gui/PhoneKey.qml \
    qml/backend/PhoneContactsBackEnd.qml \
    qml/gui/SearchBox.qml \
    qml/gui/PhoneContactsDelegate.qml \
    qml/gui/PhoneContactDialog.qml \
    qml/backend/LeadingCharacterModel.qml \
    qml/gui/AreaSelectionPage.qml \
    qml/gui/AreaButtonsDelegate.qml \
    qml/gui/AreaRadioButtons.qml \
    qml/gui/InitialCharacterPicker/InitialCharacterPicker.qml \
    qml/gui/InitialCharacterPicker/CharacterButton.qml \
    qml/gui/InitialCharacterPicker/CharacterGrid.qml \
    qml/gui/InitialCharacterPicker/CharacterRow.qml \
    qml/backend/AreaListModel.qml \
    qml/javascript/readDataModel.js \
    qml/javascript/writeDataModel.js \
    qml/javascript/jsonpath.js \
    qml/gui/PhoneContactsTab.qml \
    qml/gui/PhoneContactsTabContent.qml \
    qml/javascript/jsonSupport.js \
    qml/javascript/settings.js
