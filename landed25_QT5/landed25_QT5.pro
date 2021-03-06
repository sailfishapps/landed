# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = landed25_QT5

CONFIG += sailfishapp

QT += multimedia dbus positioning sensors
# QT += location not recognised

PKGCONFIG += TelepathyQt5

HEADERS += \
        src/telepathyhelper.h \
        src/windowingsystem.h \
        src/operatingsystem.h \
        src/landedtorch.h \
        src/satinfosource.h

SOURCES += src/landed25_QT5.cpp \
        src/landedtorch.cpp \
        src/telepathyhelper.cpp \
        src/satinfosource.cpp

# qml.files = qml/gui qml/backend

OTHER_FILES += qml/landed25_QT5.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    rpm/landed25_QT5.spec \
    rpm/landed25_QT5.yaml \
    landed25_QT5.desktop \
    qml/gui/MainPage.qml \
    qml/gui/GPSDisplay.qml \
    qml/gui/TemplateButtons.qml \
    qml/gui/RumbleEffect.qml \
    qml/gui/TemplateButtonsHeader.qml \
    qml/gui/TemplateButtonsDelegate.qml \
    qml/backend/GPSBackEnd.qml \
    qml/backend/SMSTemplateListModel.qml \
    qml/javascript/settingsDB.js \
    qml/javascript/landed.js \
    qml/gui/SMSPage.qml \
    qml/gui/TorchApp.qml \
    qml/gui/SMSDisplay.qml \
    qml/backend/SMSBackEnd.qml \
    qml/backend/FavouriteContactsBackEnd.qml \
    qml/gui/SMSTextEdit.qml\
    qml/javascript/message.js \
    qml/gui/GroupSelectionPage.qml \
    qml/gui/GroupRadioButtons.qml \
    qml/backend/GroupListModel.qml \
    qml/gui/SimpleHeader.qml \
    qml/gui/GroupButtonsDelegate.qml \
    qml/gui/GreenCheckButtonStyle.qml
