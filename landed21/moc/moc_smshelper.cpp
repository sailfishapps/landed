/****************************************************************************
** Meta object code from reading C++ file 'smshelper.h'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../smshelper.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'smshelper.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_SMSHelper[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       5,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       3,       // signalCount

 // signals: signature, parameters, type, tag, flags
      20,   11,   10,   10, 0x05,
      47,   38,   10,   10, 0x05,
      72,   65,   10,   10, 0x05,

 // slots: signature, parameters, type, tag, flags
      92,   90,   10,   10, 0x08,

 // methods: signature, parameters, type, tag, flags
     161,  141,  136,   10, 0x02,

       0        // eod
};

static const char qt_meta_stringdata_SMSHelper[] = {
    "SMSHelper\0\0statemsg\0stateMsg(QString)\0"
    "errormsg\0errorMsg(QString)\0dbgmsg\0"
    "debugMsg(QString)\0s\0"
    "messageStateChanged(QMessageService::State)\0"
    "bool\0phonenumber,message\0"
    "sendsms(QString,QString)\0"
};

void SMSHelper::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        SMSHelper *_t = static_cast<SMSHelper *>(_o);
        switch (_id) {
        case 0: _t->stateMsg((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 1: _t->errorMsg((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 2: _t->debugMsg((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 3: _t->messageStateChanged((*reinterpret_cast< QMessageService::State(*)>(_a[1]))); break;
        case 4: { bool _r = _t->sendsms((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        default: ;
        }
    }
}

const QMetaObjectExtraData SMSHelper::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject SMSHelper::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_SMSHelper,
      qt_meta_data_SMSHelper, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &SMSHelper::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *SMSHelper::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *SMSHelper::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_SMSHelper))
        return static_cast<void*>(const_cast< SMSHelper*>(this));
    return QObject::qt_metacast(_clname);
}

int SMSHelper::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 5)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 5;
    }
    return _id;
}

// SIGNAL 0
void SMSHelper::stateMsg(const QString & _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void SMSHelper::errorMsg(const QString & _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void SMSHelper::debugMsg(const QString & _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}
QT_END_MOC_NAMESPACE
