# Add more folders to ship with the application, here
folder_01.source = qml/landed25
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
CONFIG += mobility
MOBILITY += location messaging multimedia

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
CONFIG += qdeclarative-boostable

QT += dbus
PKGCONFIG += TelepathyQt4

HEADERS += \
    landedtorch.h \
    satinfosource.h \
    operatingsystem.h \
    windowingsystem.h \
    telepathyhelper.h

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    landedtorch.cpp \
    satinfosource.cpp \
    telepathyhelper.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    qml/landed24/backend/ContactListModel.qml \
    qml/landed24/gui/SMSPage.qml \
    qml/landed24/gui/Dialer.qml \
    qml/landed24/backend/PhoneContactsBackEnd.qml \
    qml/landed25/gui/PhoneDialer.qml \
    qml/landed25/gui/SMSTextEdit.qml

